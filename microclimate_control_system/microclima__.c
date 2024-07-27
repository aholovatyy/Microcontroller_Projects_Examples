/*****************************************************
This program was produced by the
CodeWizardAVR V2.04.4a Advanced
Automatic Program Generator
© Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : Автматизована система моніторингу та управління мікрокліматом
		  в тепличних господарствах на мікроконтролері AVR ATmega32
Version : Дипломна робота
Date    : 2016
Author  : (C) студент групи КНс-21 Калитовський Роман

Chip type               : ATmega32
Program type            : Application
AVR Core Clock frequency: 8,000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 512
*****************************************************/

#include <mega32.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
#include <stdio.h>
#include <stdlib.h>
#include <delay.h>
#include <lcd.h> // функції LCD
#include <i2c.h>           // інтерфейс i2c - Bus functions
#include <ds1307.h>       // DS1307 Real Time Clock functions
#include "therm_ds18b20.h"
#include "shtxx.h"

#asm
    .equ __lcd_port=0x12 // порт піключення LCD, PORTD
#endasm

#asm
   .equ __i2c_port=0x15 ;PORTC   // DS1317 на порті С
   .equ __sda_bit=1              // SDA - на pin.1
   .equ __scl_bit=0              // SCL - на pin.0
#endasm

#pragma rl+

//buttons MENU/ENTER, SELECT+, SELECT-
#define BTN_PORT PORTB
#define BTN_PIN PINB
#define BTN_DDR DDRB
#define MENU_ENTER_BTN 0
#define SELECT_PLUS_BTN 1
#define SELECT_MINUS_BTN 2
#define EXIT_BTN 3

//air-conditioner
#define REL1_PORT PORTC
#define REL1_DDR DDRC
#define REL1 5

//water pump
#define REL2_PORT PORTC
#define REL2_DDR DDRC
#define REL2 6

//artificial light source
#define REL3_PORT PORTC
#define REL3_DDR DDRC
#define REL3 7

#define WATERING_TIME_NUMBER 8

typedef struct {
   unsigned int min, max;
} values_range;

typedef struct {
  unsigned char hour, min, mode_on_off;
} watering_time;

values_range temp = {23, 27}, hum = {50, 60}, soil = {0, 0}, light = {0, 0};
watering_time w_time[WATERING_TIME_NUMBER] = {{0,0,0}, {0,0,0}, {0,0,0}, {0,0,0},
            {0,0,0}, {0,0,0}, {0,0,0}, {0,0,0}};
unsigned char PREV_BTN_PIN = 0xff;
char lcd_buffer[33];

unsigned char get_key_status(unsigned char BTN_ID)
{
    return (!(BTN_PIN&(1<<BTN_ID)));
}

unsigned char get_prev_key_status(unsigned char BTN_ID)
{
    return (!(PREV_BTN_PIN&(1<<BTN_ID)));
}

void set_time()
{
    unsigned char i = 0, x = 3, ok = 0;
    //char *str[] = {"hh","mm","ss","^^"};
    char str[4][3] = {"гг","хх","сс","^^"};
    unsigned char hour = 0, min = 0, sec = 0, wd = 0;
    rtc_get_time(&hour,&min,&sec,&wd);
    while(!ok)
    {
        PREV_BTN_PIN = BTN_PIN;
        sprintf(lcd_buffer,"%u%u:%u%u:%u%u OK!", hour/10,hour%10, min/10,min%10, sec/10,sec%10);
        lcd_gotoxy(3,0);
        lcd_puts(lcd_buffer);
        lcd_gotoxy(x,1);
        lcd_puts(str[i]);
        if(get_key_status(SELECT_PLUS_BTN))
        {
            //if (!get_prev_key_status(SELECT_PLUS_BTN))
            //{
            switch(i)
            {
                case 0:
                  if (hour == 23) hour = 0;
                  else hour++;
                break;
                case 1:
                  if (min == 59) min = 0;
                  else min++;
                break;
                case 2:
                  if (sec == 59) sec = 0;
                  else sec++;
                break;
                case 3:
                  ok = 1;
                break;
            }
            //}
            delay_ms(300);
        }
        if (get_key_status(SELECT_MINUS_BTN))
        {
            //if (!get_prev_key_status(SELECT_MINUS_BTN))
            //{
            switch (i)
            {
                case 0:
                  if (hour == 0) hour = 23;
                  else hour--;
                break;
                case 1:
                  if (min == 0) min = 59;
                  else min--;
                break;
                case 2:
                  if (sec == 0) sec = 59;
                  else sec--;
                break;
                case 3:
                  ok = 1;
                break;
            }
            // }
           delay_ms(300);
        }
        if(get_key_status(MENU_ENTER_BTN))
        {
            if(!get_prev_key_status(MENU_ENTER_BTN))
            {
                lcd_gotoxy(x,1);
                lcd_putsf("  ");
                if (i == 3)
                {
                    i = 0;
                    x = 3;
                }
                else
                {
                  x += 3;
                  i++;
                }
           }
       }
       if(get_key_status(EXIT_BTN))
         if(!get_prev_key_status(EXIT_BTN))
         {
            delay_ms(300);
            PREV_BTN_PIN = BTN_PIN;
            return;
         }
    }
  rtc_set_time(hour, min, sec, wd);
}

void set_date(void)
{
    unsigned char ok = 0;
    //char str[4][3]={"dd", "mm", "yy", "^^"};
    char str[4][3]={"дд", "мм", "рр", "^^"};
    unsigned char i = 0, x = 3;
    unsigned char date, month, year;
    rtc_get_date(&date,&month,&year);
    lcd_clear();
    while(!ok)
    {
        PREV_BTN_PIN = BTN_PIN;
        sprintf(lcd_buffer, "%u%u/%u%u/%u%u OK!", date/10,date%10, month/10,month%10, year/10,year%10);
        lcd_gotoxy(3, 0);
        lcd_puts(lcd_buffer);
        lcd_gotoxy(x, 1);
        lcd_puts(str[i]);
        if (get_key_status(SELECT_PLUS_BTN))
        {
           if (get_key_status(SELECT_PLUS_BTN))
              if (!get_prev_key_status(SELECT_PLUS_BTN))
              {
                 switch (i)
                 {
                    case 0:
                      if (date == 31) date = 0;
                      else date++;
                    break;
                    case 1:
                      if (month == 12) month = 0;
                      else month++;
                    break;
                    case 2:
                       if (year == 99) year = 0;
                       else year++;
                    break;
                    case 3:
                      ok = 1;
                    break;
                  }
               }
        }
        if (get_key_status(SELECT_MINUS_BTN))
        {
            if (get_key_status(SELECT_MINUS_BTN))
              if (!get_prev_key_status(SELECT_MINUS_BTN))
              {
                switch (i)
                {
                    case 0:
                      if (date == 0) date = 31;
                      else date--;
                    break;
                    case 1:
                       if (month == 0) month = 12;
                       else month--;
                    break;
                    case 2:
                       if (year == 0) year = 99;
                       else year--;
                    break;
                    case 3:
                      ok = 1;
                    break;
                }
            }
        }
        if (get_key_status(MENU_ENTER_BTN))
        {
            if (!get_prev_key_status(MENU_ENTER_BTN))
            {
                lcd_gotoxy(x, 1);
                lcd_putsf("  ");
                if (i == 3)
                {
                    i = 0;
                    x = 3;
                }
                else
                {
                    i++;
                    x += 3;
                }
            }
       }
       if (get_key_status(EXIT_BTN))
         if (!get_prev_key_status(EXIT_BTN))
            {
               delay_ms(300);
               PREV_BTN_PIN = BTN_PIN;
               return;
            }
 }
 rtc_set_date(date, month, year);
}

void set_values(unsigned char j, values_range *p)
{
    char str[3][4]={"<=","<=","OK!"};
    unsigned char i = 0, xpos[] = {14, 14, 13}, ypos[] = {0,1,1};
    unsigned char ok = 0;
    values_range v[4] = {{0,99},{10,100},{0,100},{300,1000}};
    values_range tmp;
    tmp = *p;

    lcd_clear();

    while(!ok)
    {
        PREV_BTN_PIN = BTN_PIN;
        switch (j)
        {
            case 0:
              sprintf(lcd_buffer,"Tmin: %u%cC \nTmax: %u%cC ", tmp.min, 0xdf, tmp.max, 0xdf);
            break;
            case 1:
              sprintf(lcd_buffer,"Hmin: %u%% \nHmax: %u%% ", tmp.min, tmp.max);
            break;
            case 2:
              sprintf(lcd_buffer,"Smin: %u%% \nSmax: %u%% ", tmp.min, tmp.max);
            break;
            case 3:
              sprintf(lcd_buffer,"Imin: %u lx \nImax: %u lx ", tmp.min, tmp.max);
            break;
        }
        lcd_gotoxy(0,0);
        lcd_puts(lcd_buffer);
        lcd_gotoxy(xpos[i],ypos[i]);
        lcd_puts(str[i]);

        if(get_key_status(SELECT_PLUS_BTN))
        {
            //if (!get_prev_key_status(SELECT_PLUS_BTN))
            {
                switch(i)
                {
                    case 0:
                      if (tmp.min < tmp.max) tmp.min++;
                    break;
                    case 1:
                      if (tmp.max < v[j].max) tmp.max++;
                    break;
                    case 2:
                      ok = 1;
                    break;
                }
            }
            delay_ms(300);
        }
        if (get_key_status(SELECT_MINUS_BTN))
        {
            //if (!get_prev_key_status(SELECT_MINUS_BTN))
            {
                switch (i) {
                   case 0:
                     if (tmp.min > v[j].min) tmp.min--;
                     break;
                   case 1:
                     if (tmp.max > tmp.min) tmp.max--;
                   break;
                   case 2:
                     ok = 1;
                   break;
                }

         }
         delay_ms(300);
     }
     if(get_key_status(MENU_ENTER_BTN))
     {
       if(!get_prev_key_status(MENU_ENTER_BTN))
       {
          lcd_gotoxy(xpos[i],ypos[i]);
          lcd_putsf("  ");
          if (i==2)
          {
             i=0;
             lcd_putsf(" ");
          }
          else
            i++;
         }
       }
       if(get_key_status(EXIT_BTN))
         if(!get_prev_key_status(EXIT_BTN))
         {
            delay_ms(300);
            PREV_BTN_PIN = BTN_PIN;
            return;
         }
    }
    *p = tmp;
}

void set_watering()
{
    unsigned char i = 0, j = 0, x = 0, ok = 0;
    //char *str[] = {"pr", "hh","mm","^^", "^^"};
    char *str[5] = {"пр", "гг","хх","^^", "^^"};
    unsigned char hour, min, mode_on_off;
    char *s_mode[] = {"OFF", "ON "};

    hour = w_time[j].hour;
    min = w_time[j].min;
    mode_on_off = w_time[j].mode_on_off;

    while(!ok)
    {
        PREV_BTN_PIN = BTN_PIN;
        sprintf(lcd_buffer,"#%u %u%u:%u%u %s OK!", j+1, hour/10,hour%10, min/10,min%10, s_mode[mode_on_off]);
        lcd_gotoxy(0,0);
        lcd_puts(lcd_buffer);
        lcd_gotoxy(x,1);
        lcd_puts(str[i]);
        if(get_key_status(SELECT_PLUS_BTN))
        {
            //if (!get_prev_key_status(SELECT_PLUS_BTN))
            //{
            switch(i)
            {
                case 0:
                  if (j < WATERING_TIME_NUMBER - 1) j++;
                  else j = 0;
                  hour = w_time[j].hour;
                  min = w_time[j].min;
                  mode_on_off = w_time[j].mode_on_off;
                  break;
                case 1:
                  if (hour == 23) hour = 0;
                  else hour++;
                break;
                case 2:
                  if (min == 59) min = 0;
                  else min++;
                break;
                case 3:
                  if (mode_on_off) mode_on_off = 0;
                  else mode_on_off = 1;
                break;
                case 4:
                  ok = 1;
                break;
            }
            //}
            delay_ms(300);
        }
        if (get_key_status(SELECT_MINUS_BTN))
        {
            //if (!get_prev_key_status(SELECT_MINUS_BTN))
            //{
            switch (i)
            {
                case 0:
                  if (j > 0) j--;
                  else j = WATERING_TIME_NUMBER;
                  hour = w_time[j].hour;
                  min = w_time[j].min;
                  mode_on_off = w_time[j].mode_on_off;
                  break;
                case 1:
                  if (hour == 0) hour = 23;
                  else hour--;
                break;
                case 2:
                  if (min == 0) min = 59;
                  else min--;
                break;
                case 3:
                  if (!mode_on_off) mode_on_off = 1;
                  else mode_on_off = 0;
                break;
                case 4:
                  ok = 1;
                break;
            }
            // }
           delay_ms(300);
        }
        if(get_key_status(MENU_ENTER_BTN))
        {
            if(!get_prev_key_status(MENU_ENTER_BTN))
            {
                lcd_gotoxy(x,1);
                lcd_putsf("  ");
                if (i == 4)
                {
                    i = 0;
                    x = 0;
                }
                else
                {
                  if (x == 9)
                    x += 4;
                  else x += 3;
                  i++;
                }
           }
       }
       if(get_key_status(EXIT_BTN))
         if(!get_prev_key_status(EXIT_BTN))
         {
            delay_ms(300);
            PREV_BTN_PIN = BTN_PIN;
            return;
         }
    }
    w_time[j].hour = hour;
    w_time[j].min = min;
    w_time[j].mode_on_off = mode_on_off;
}


void main_menu(void)
{
    /*char *menu_items[8]={"DATE", "TIME", "WATERING", "TEMPERATURE",
        "HUMIDITY", "SOIL MOISTURE", "LIGHT INTENSITY","EXIT"};
    int pos[] = {6, 6, 4, 2, 4, 2, 0, 6}; */
    char *menu_items[8]={"ДАТА", "ЧАС", "ПОЛИВ", "ТЕМПЕРАТУРА",
        "ВОЛОГIСТЬ", "ВОЛОГIСТЬ ГРУНТУ", "ОСВIТЛЕННЯ","ВИХIД"};
    int pos[] = {6, 6, 5, 2, 4, 0, 3, 5};
    //char title[] = "** Main Menu **";
    char title[] = "* Головне Меню *";
    unsigned char i = 0;

    while(1)
    {
        PREV_BTN_PIN = BTN_PIN;
        lcd_gotoxy(0,0);
        lcd_puts(title);
        lcd_gotoxy(pos[i],1);
        lcd_puts(menu_items[i]);
        if(get_key_status(SELECT_PLUS_BTN))
        {
            if(!get_prev_key_status(SELECT_PLUS_BTN))
            {
                if(i == 7) i = 0;
                else i++;
                lcd_clear();
            }
        }
        if(get_key_status(SELECT_MINUS_BTN))
        {
            if (!get_prev_key_status(SELECT_MINUS_BTN))
            {
                if (i == 0) i = 7;
                else i--;
                lcd_clear();
            }
        }
        if(get_key_status(MENU_ENTER_BTN))
            if(!get_prev_key_status(MENU_ENTER_BTN))
            {
                lcd_clear();
                switch(i)
                {
                    case 0: set_date(); break; // date
                    case 1: set_time(); break; // time
                    case 2: set_watering(); break; // watering
                    case 3: set_values(0, &temp); break; // temperature
                    case 4: set_values(1, &hum); break; // humidity
                    case 5: set_values(2,&soil); break; // soil moisture
                    case 6: set_values(3, &light); break;
                    case 7: return;
                    default: break;
            }
            lcd_clear();
      }
      if (get_key_status(EXIT_BTN))
        if (!get_prev_key_status(EXIT_BTN))
        {
           return;
        }

    }
}

void main(void)
{
  /* program that shows how to use SHTXX, DS18B20 functions and to display information on LCD */

  value humi_val = {0}, temp_val = {0};
  float temp_ds = 0, dew_point = 0;
  unsigned int soil_val = 0, light_val = 0;
  unsigned char error, checksum, value = 1;
  unsigned int vin, start;
  unsigned char hour, min, sec, wd;
  //unsigned char date, month, year;
  //char *weekdays[7]={"Sun","Mon","Tue","Wed","Thr","Fri","Sat"};
  char *weekdays[7]={"Нд.","Пн.","Вт.","Ср.","Чт.","Пт.","Сб."};
  //char *monthes[]={"Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"};
  //char *monthes[]={"Сiч.","Лют.","Бер.","Квiт.","Трав.","Черв.","Лип.","Серп.","Вер.","Жовт.","Лист.","Груд."};

  //initADC();
  sht_init();
  s_connectionreset();
  therm_init(-55, 125, THERM_9BIT_RES);
  i2c_init();  // I2C Bus initialization
  // DS1307 Real Time Clock initialization
  rtc_init(0,1,0);  // Square wave output on pin SQW/OUT: Off // SQW/OUT pin state: 0
  start = rtc_read(0)&0x80;
  if (start)
    rtc_write(0,0x00);  //start clock

  //LCD initialization
  lcd_init(16);
  lcd_clear();
  /*lcd_gotoxy(2,0);
  lcd_putsf("Microclimate");
  lcd_gotoxy(1,1);
  lcd_putsf("Control System"); */
  lcd_gotoxy(4,0);
  lcd_putsf("СИСТЕМА");
  lcd_gotoxy(3,1);
  lcd_putsf("УПРАВЛIННЯ");
  delay_ms(2000);
  lcd_clear();
  lcd_gotoxy(1,0);
  lcd_putsf("МIКРОКЛIМАТОМ");
  lcd_gotoxy(3,1);
  lcd_putsf("В ТЕПЛИЦI");
  delay_ms(2000);
  lcd_clear();
  lcd_gotoxy(0,0);
  //lcd_putsf("Roman Kalytovsky");
  lcd_putsf("Р. Калитовський");
  lcd_gotoxy(4,1);
  lcd_putsf("(C) 2016");
  delay_ms(2000);
  lcd_clear();
 //set SHTXX sensor resolution for temperature 12 bit and for humidity 8 bit
  s_write_statusreg(&value);
  s_read_statusreg(&value, &checksum);

  REL1_DDR|=(1<<REL1);  // REL1 0x20
  REL1_PORT&=~(1<<REL1); // REL1 - off 0xdf
  REL2_DDR|=(1<<REL2);  // REL2 0x40
  REL2_PORT&=~(1<<REL2); // REL2 - off 0xbf
  REL3_DDR|=(1<<REL3);  // REL3 0x80
  REL3_PORT&=~(1<<REL3); // REL3 - off 0x7f

  while(1)
  {
    therm_read_temperature(&temp_ds); //measures temperature from DS18B20
    error = 0;
    error += s_measure((unsigned char*) &humi_val.i, &checksum,HUMI);  //measure humidity
    error += s_measure((unsigned char*) &temp_val.i, &checksum,TEMP);  //measure temperature
    if (error!=0)
      s_connectionreset(); //in case of an error: connection reset
    else
    {
      humi_val.f = (float)humi_val.i;  //converts integer to float
      temp_val.f = (float)temp_val.i;   //converts integer to float
      calc_sth11(&humi_val.f, &temp_val.f); //calculate humidity, temperature
      dew_point = calc_dewpoint(humi_val.f, temp_val.f); //calculate dew point

      sprintf(lcd_buffer,"%+3.1f%cC %3.1f%% RH ", temp_ds,
      0xdf, humi_val.f);
      lcd_gotoxy(0,0);
      lcd_puts(lcd_buffer);
      sprintf(lcd_buffer,"%+d%cC ",(int)temp_val.f, 0xdf);
      lcd_gotoxy(0,1);
      lcd_puts(lcd_buffer);
    }
    // check temperature value
    if (temp_ds > temp.max)
    {
       REL1_PORT|=0x20;
    }
    else //if (temp_ds < temp.min)
    {
      REL1_PORT&=0xdf;
    }
    // check humidity value
    if (humi_val.f < hum.min)
    {
      REL2_PORT|=0x40;
    }
    else //if (humi_val.f > hum.max)
    {
      REL2_PORT&=0xbf;
    }
    // check soil moisture value
    /*if (soil_val < soil.min)
    {
        REL2_PORT|=0x40;
    }
    else //if (soil_val > soil.max)
    {
        REL2_PORT&=0xbf;
    }*/
    // check light intensity value
    if (light_val < light.min)
    {
        REL3_PORT|=0x80;
    }
    else //if (light_val > light.max)
    {
	    REL3_PORT&=0x7f;
    }
    /*vin=readADC(5); //measure pressure ADC5 pin
    pressure=press_m(vin); //calculate pressure
    //print pressure from MPX4115
    sprintf(lcd_buffer,"%uкПа %.1fатм ",pressure, (pressure/101.325));
    lcd_goto_xy(2,3);
    lcd_str(lcd_buffer);*/
    rtc_get_time(&hour,&min,&sec, &wd);
    //rtc_get_date(&date,&month,&year);
    //print time
    sprintf(lcd_buffer, "%u%u:%u%u %s", hour/10,hour%10, min/10,min%10, weekdays[wd-1]);
    lcd_gotoxy(7,1);
    lcd_puts(lcd_buffer);
    //print date
    /*sprintf(lcd_buffer, "%u%u %s 20%u%u", date/10,date%10, monthes[month-1], year/10,year%10);
    lcd_goto_xy(2,6);
    lcd_str(lcd_buffer);   */
    if (get_key_status(MENU_ENTER_BTN)) //enter
    {
      if (!get_prev_key_status(MENU_ENTER_BTN))
      {
		lcd_clear();
        main_menu();
    	lcd_clear();
      }
    }
    //delay_ms(200);
    //----------wait approx. 0.8s to avoid heating up SHTxx------------------------------
    //for (i=0;i<40000;i++);     //(be sure that the compiler doesn't eliminate this line!)
    //-----------------------------------------------------------------------------------
  }
}

#pragma rl-

/*void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port A initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
PORTA=0x00;
DDRA=0x00;

// Port B initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
PORTB=0x00;
DDRB=0x00;

// Port C initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
PORTC=0x00;
DDRC=0x00;

// Port D initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
PORTD=0x00;
DDRD=0x00;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
// Mode: Normal top=FFh
// OC0 output: Disconnected
TCCR0=0x00;
TCNT0=0x00;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=FFFFh
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=0x00;
TCCR1B=0x00;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=FFh
// OC2 output: Disconnected
ASSR=0x00;
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// INT2: Off
MCUCR=0x00;
MCUCSR=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x00;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

while (1)
      {
      // Place your code here

      };
} */
#include "therm_ds18b20.h"
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

struct __ds18b20_scratch_pad_struct __ds18b20_scratch_pad;
//uint8_t therm_dq;

/*void therm_input_mode(void)
{
	THERM_DDR&=~(1<<THERM_DQ);
}
void therm_output_mode(void)
{
	THERM_DDR|=(1<<THERM_DQ);
}
void therm_low(void)
{
	THERM_PORT&=~(1<<THERM_DQ);
}     */
/*void therm_high(void)
{
	THERM_PORT|=(1<<THERM_DQ);
}
void therm_delay(uint16_t delay)
{
	while (delay--) #asm("nop");
}*/

uint8_t therm_reset()
{
	uint8_t i;
	//посилаємо імпульс скидання тривалістю 480 мкс
	THERM_LOW();
	THERM_OUTPUT_MODE();
	//therm_delay(us(480));
	delay_us(480);
	//повертаємо шину і чекаємо 60 мкс на відповідь
	THERM_INPUT_MODE();
	//therm_delay(us(60));
	delay_us(60);
	//зберігаємо значення на шині і чекаємо завершення 480 мкс періода
	i=(THERM_PIN & (1<<THERM_DQ));
	//therm_delay(us(420));
	delay_us(420);
	if ((THERM_PIN & (1<<THERM_DQ))==i) return 1;
	//повертаємо результат виконання (presence pulse) (0=OK, 1=WRONG)
	return 0;
}

void therm_write_bit(uint8_t _bit)
{
	//переводимо шину в стан лог. 0 на 1 мкс
	THERM_LOW();
	THERM_OUTPUT_MODE();
	//therm_delay(us(1));
	delay_us(1);
	//якщо пишемо 1, відпускаємо шину (якщо 0 тримаємо в стані лог. 0)
	if (_bit) THERM_INPUT_MODE();
	//чекаємо 60мкм і відпускаємо шину
	//therm_delay(us(60));
	delay_us(60);
	THERM_INPUT_MODE();
}

uint8_t therm_read_bit(void)
{
	uint8_t _bit=0;
	//переводимо шину в лог. 0 на 1 мкс
	THERM_LOW();
	THERM_OUTPUT_MODE();
	//therm_delay(us(1));
	delay_us(1);
	//відпускаємо шину і чекаємо 14 мкс
	THERM_INPUT_MODE();
	//therm_delay(us(14));
	delay_us(14);
	//читаємо біт з шини
	if (THERM_PIN&(1<<THERM_DQ)) _bit=1;
	//чекаємо 45 мкс до закінчення і вертаємо прочитане значення
	//therm_delay(us(45));
	delay_us(45);
	return _bit;
}

uint8_t therm_read_byte(void)
{
	uint8_t i=8, n=0;
	while (i--)
	{
		//зсуваємо на 1 розряд вправо і зберігаємо прочитане значення
		n>>=1;
		n|=(therm_read_bit()<<7);
	}
	return n;
}

void therm_write_byte(uint8_t byte)
{
	uint8_t i=8;
	while (i--)
	{
		//пишемо молодший біт і зсуваємо на 1 розряд вправо для виводу наступного біта
		therm_write_bit(byte&1);
		byte>>=1;
	}
}

uint8_t therm_crc8(uint8_t *data, uint8_t num_bytes)
{
	uint8_t byte_ctr, cur_byte, bit_ctr, crc=0;

	for (byte_ctr=0; byte_ctr<num_bytes; byte_ctr++)
	{
		cur_byte=data[byte_ctr];
		for (bit_ctr=0; bit_ctr<8; cur_byte>>=1, bit_ctr++)
			if ((cur_byte ^ crc) & 1) crc = ((crc ^ 0x18) >> 1) | 0x80;
			else crc>>=1;
	}
	return crc;
}

uint8_t therm_init(int8_t temp_low, int8_t temp_high, uint8_t resolution)
{
	resolution=(resolution<<5)|0x1f;
	//ініціалізуємо давач
	if (therm_reset()) return 1;
	therm_write_byte(THERM_CMD_SKIPROM);
	therm_write_byte(THERM_CMD_WSCRATCHPAD);
	therm_write_byte(temp_high);
	therm_write_byte(temp_low);
	therm_write_byte(resolution);
	therm_reset();
	therm_write_byte(THERM_CMD_SKIPROM);
	therm_write_byte(THERM_CMD_CPYSCRATCHPAD);
	delay_ms(15);
	return 0;
}

uint8_t therm_read_spd(void)
{
	uint8_t i=0, *p;

	p = (uint8_t*) &__ds18b20_scratch_pad;
	do
		*(p++)=therm_read_byte();
	while(++i<9);
	if (therm_crc8((uint8_t*)&__ds18b20_scratch_pad,8)!=__ds18b20_scratch_pad.crc)
		return 1;
	return 0;
}

uint8_t therm_read_temperature(float *temp)
{
	uint8_t digit, decimal, resolution, sign;
	uint16_t meas, bit_mask[4]={0x0008, 0x000c, 0x000e, 0x000f};

	//скинути, пропустити процедуру перевірки серійного номера ROM і почати вимірювання і перетворення температури
	if (therm_reset()) return 1;
	therm_write_byte(THERM_CMD_SKIPROM);
	therm_write_byte(THERM_CMD_CONVERTTEMP);
	//чекаємо до закінчення перетворення
	//if (!therm_read_bit()) return 1;
	while(!therm_read_bit());
	//скидаємо, пропускаємо ROM і посилаємо команду зчитування Scratchpad
	therm_reset();
	therm_write_byte(THERM_CMD_SKIPROM);
	therm_write_byte(THERM_CMD_RSCRATCHPAD);
	if (therm_read_spd()) return 1;
	therm_reset();
	resolution=(__ds18b20_scratch_pad.conf_register>>5) & 3;
    //отримуємо молодший і старший байти температури
	meas=__ds18b20_scratch_pad.temp_lsb;  // LSB
	meas|=((uint16_t)__ds18b20_scratch_pad.temp_msb) << 8; // MSB
	//перевіряємо на мінусову температуру
	if (meas & 0x8000)
	{
		sign=1;  //відмічаємо мінусову температуру
		meas^=0xffff;  //перетворюємо в плюсову
		meas++;
	}
	else sign=0;
	//зберігаємо цілу і дробову частини температури
	digit=(uint8_t)(meas >> 4); //зберігаємо цілу частину
	decimal=(uint8_t)(meas & bit_mask[resolution]);	//отримуємо дробову частину
	*temp=digit+decimal*0.0625;
	if (sign) *temp=-(*temp); //ставемо знак мінус, якщо мінусова температура
	return 0;
}
/***********************************************************************************
Project:          SHTxx library
Filename:         shtxx.c
Processor:        AVR family
Author:           (C) Andriy Holovatyy
***********************************************************************************/

#include "shtxx.h"
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
#include <math.h>   //math library

/* константи для обчислення температури і вологості */
//const float C1=-4.0;              // for 12 Bit
//const float C2=+0.0405;           // for 12 Bit
//const float C3=-0.0000028;        // for 12 Bit

/*const float C1=-2.0468;           // for 12 Bit
const float C2=+0.0367;           // for 12 Bit
const float C3=-0.0000015955;     // for 12 Bit

const float T1=+0.01;             // for 14 Bit @ 5V
const float T2=+0.00008;           // for 14 Bit @ 5V

*/

const float C1=-2.0468;           // for 8 Bit
const float C2=+0.5872;           // for 8 Bit
const float C3=-0.00040845;       // for 8 Bit

const float T1=+0.01;             // for 12 Bit @ 5V
const float T2=+0.00128;          // for 12 Bit @ 5V

void sht_init(void)
{
  SHT_PORT=0x00;
  SHT_DDR=1<<SHT_SCK;
}

//----------------------------------------------------------------------------------
char s_write_byte(unsigned char _value)
//----------------------------------------------------------------------------------
// writes a byte on the Sensibus and checks the acknowledge
{
  unsigned char i,error=0;
  SHT_OUTPUT_MODE();
  for (i=0x80;i>0;i/=2)             //shift bit for masking
  {
    if (i & _value) SHT_DATA_HIGH(); //masking value with i , write to SENSI-BUS
    else
     SHT_DATA_LOW();
    delay_us(1);
    SHT_SCK_HIGH(); //clk for SENSI-BUS
    delay_us(5);    //pulswith approx. 5 us
    SHT_SCK_LOW();
  }
  SHT_INPUT_MODE(); //release DATA-line
  delay_us(1);
  SHT_SCK_HIGH(); //clk #9 for ack
  delay_us(1);
  error=(SHT_PIN&(1<<SHT_DATA));                       //check ack (DATA will be pulled down by SHT11)
  SHT_SCK_LOW();
  delay_us(1);
  return error;                     //error=1 in case of no acknowledge
}

//----------------------------------------------------------------------------------
char s_read_byte(unsigned char ack)
//----------------------------------------------------------------------------------
// reads a byte form the Sensibus and gives an acknowledge in case of "ack=1"
{
  unsigned char i,val=0;
  SHT_INPUT_MODE(); //release DATA-line
  for (i=0x80;i>0;i/=2)  //shift bit for masking
  {
    SHT_SCK_HIGH();    //clk for SENSI-BUS
    delay_us(1);
    if ((SHT_PIN & (1<<SHT_DATA))) val=(val | i);        //read bit
    SHT_SCK_LOW();
    delay_us(1);
  }
  if (ack) //in case of "ack==1" pull down DATA-Line
  {
   SHT_OUTPUT_MODE();
   SHT_DATA_LOW();
   delay_us(1);
  }
  SHT_SCK_HIGH();        //clk #9 for ack
  delay_us(5);  //pulswith approx. 5 us
  SHT_SCK_LOW();
  delay_us(1);
  SHT_INPUT_MODE(); //release DATA-line
  return val;
}

//----------------------------------------------------------------------------------
void s_transstart(void)
//----------------------------------------------------------------------------------
// generates a transmission start
//       _____         ________
// DATA:      |_______|
//           ___     ___
// SCK : ___|   |___|   |______
{
  //Initial state
  SHT_OUTPUT_MODE();
  SHT_DATA_HIGH();
  SHT_SCK_LOW();
  delay_us(1);

  SHT_SCK_HIGH();
  delay_us(1);

  SHT_DATA_LOW();
  delay_us(1);

  SHT_SCK_LOW();
  delay_us(5);

  SHT_SCK_HIGH();
  delay_us(1);

  SHT_DATA_HIGH();
  delay_us(1);
  SHT_SCK_LOW();
  delay_us(1);
}

//----------------------------------------------------------------------------------
void s_connectionreset(void)
//----------------------------------------------------------------------------------
// communication reset: DATA-line=1 and at least 9 SCK cycles followed by transstart
//       _____________________________________________________         ________
// DATA:                                                      |_______|
//          _    _    _    _    _    _    _    _    _        ___     ___
// SCK : __| |__| |__| |__| |__| |__| |__| |__| |__| |______|   |___|   |______
{
  unsigned char i;
  //Initial state
  SHT_OUTPUT_MODE();
  SHT_DATA_HIGH();
  SHT_SCK_LOW();
  delay_us(1);
  for(i=0;i<9;i++)                  //9 SCK cycles
  {
    SHT_SCK_HIGH();
    delay_us(1);
    SHT_SCK_LOW();
    delay_us(1);
  }
  s_transstart();                   //transmission start
}

//----------------------------------------------------------------------------------
char s_softreset(void)
//----------------------------------------------------------------------------------
// resets the sensor by a softreset
{
  unsigned char error=0;
  s_connectionreset();              //reset communication
  error+=s_write_byte(RESET);       //send RESET-command to sensor
  return error;                     //error=1 in case of no response form the sensor
}

//----------------------------------------------------------------------------------
char s_read_statusreg(unsigned char *p_value, unsigned char *p_checksum)
//----------------------------------------------------------------------------------
// reads the status register with checksum (8-bit)
{
  unsigned char error=0;
  s_transstart();                   //transmission start
  error=s_write_byte(STATUS_REG_R); //send command to sensor
  *p_value=s_read_byte(ACK);        //read status register (8-bit)
  *p_checksum=s_read_byte(noACK);   //read checksum (8-bit)
  return error;                     //error=1 in case of no response form the sensor
}

//----------------------------------------------------------------------------------
char s_write_statusreg(unsigned char *p_value)
//----------------------------------------------------------------------------------
// writes the status register with checksum (8-bit)
{
  unsigned char error=0;
  s_transstart();                   //transmission start
  error+=s_write_byte(STATUS_REG_W);//send command to sensor
  error+=s_write_byte(*p_value);    //send value of status register
  return error;                     //error>=1 in case of no response form the sensor
}

//----------------------------------------------------------------------------------
char s_measure(unsigned char *p_value, unsigned char *p_checksum, unsigned char mode)
//----------------------------------------------------------------------------------
// makes a measurement (humidity/temperature) with checksum
{
  unsigned error=0;
  unsigned int i;

  s_transstart();                   //transmission start
  switch(mode){                     //send command to sensor
    case TEMP	: error+=s_write_byte(MEASURE_TEMP); break;
    case HUMI	: error+=s_write_byte(MEASURE_HUMI); break;
    default     : break;
  }
  SHT_INPUT_MODE();
  for (i=0;i<65535;i++)
  {
   delay_us(1);
   if((SHT_PIN & (1<<SHT_DATA))==0) break; //wait until sensor has finished the measurement
  }
  if(SHT_PIN & (1<<SHT_DATA)) error+=1;                // or timeout (~2 sec.) is reached
  *(p_value+1)=s_read_byte(ACK);    //read the first byte (MSB)
  *(p_value)=s_read_byte(ACK);    //read the second byte (LSB)
  *p_checksum =s_read_byte(noACK);  //read checksum
  return error;
}

//----------------------------------------------------------------------------------------
void calc_sth11(float *p_humidity ,float *p_temperature)
//----------------------------------------------------------------------------------------
// calculates temperature [°C] and humidity [%RH]
// input :  humi [Ticks] (12 bit)
//          temp [Ticks] (14 bit)
// output:  humi [%RH]
//          temp [°C]
{
  float rh=*p_humidity;             // rh:      Humidity [Ticks] 12 Bit
  float t=*p_temperature;           // t:       Temperature [Ticks] 14 Bit
  float rh_lin;                     // rh_lin:  Humidity linear
  float rh_true;                    // rh_true: Temperature compensated humidity
  float t_C;                        // t_C   :  Temperature [°C]

  t_C=t*0.04 - 39.8;                  //calc. temperature from ticks to [°C]  first coeff. 0.01 for 14 bit and 0.04 for 12 bit
  rh_lin=C3*rh*rh + C2*rh + C1;     //calc. humidity from ticks to [%RH]
  rh_true=(t_C-25)*(T1+T2*rh)+rh_lin;   //calc. temperature compensated humidity [%RH]
  if(rh_true>100)rh_true=100;       //cut if the value is outside of
  if(rh_true<0.1)rh_true=0.1;       //the physical possible range

  *p_temperature=t_C;               //return temperature [°C]
  *p_humidity=rh_true;              //return humidity[%RH]
}

//--------------------------------------------------------------------
float calc_dewpoint(float h,float t)
//--------------------------------------------------------------------
// calculates dew point
// input:   humidity [%RH], temperature [°C]
// output:  dew point [°C]
{ float logEx,dew_point;
  logEx=0.66077+7.5*t/(237.3+t)+(log10(h)-2);
  dew_point = (logEx - 0.66077)*237.3/(0.66077+7.5-logEx);
  return dew_point;
}

