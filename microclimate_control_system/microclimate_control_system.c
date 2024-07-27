/*****************************************************
This program was produced by the
CodeWizardAVR V2.04.4a Advanced
Automatic Program Generator
© Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : Автматизована система моніторингу та управління мікрокліматом 
		  в тепличних господарствах на мікроконтролері AVR ATmega32
Version :  
Date    : 
Author  :  

Chip type               : ATmega32
Program type            : Application
AVR Core Clock frequency: 8,000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 512
*****************************************************/

#include <mega32.h>
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
    rtc_get_time(&hour,&min,&sec);//,&wd);   
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
  rtc_set_time(hour, min, sec);//, wd);
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
    char *menu_items[8]={"DATE", "TIME", "WATERING", "TEMPERATURE", 
        "HUMIDITY", "SOIL MOISTURE", "LIGHT INTENSITY","EXIT"};
    int pos[] = {6, 6, 4, 2, 4, 2, 0, 6};
   /* char *menu_items[8]={"ДАТА", "ЧАС", "ПОЛИВ", "ТЕМПЕРАТУРА", 
        "ВОЛОГIСТЬ", "ВОЛОГIСТЬ ГРУНТУ", "ОСВIТЛЕННЯ","ВИХIД"};
    int pos[] = {6, 6, 5, 2, 4, 0, 3, 5};*/
    char title[] = "** Main Menu **";
    //char title[] = "* Головне Меню *";  
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
  char *weekdays[7]={"Sun","Mon","Tue","Wed","Thr","Fri","Sat"};
  //char *weekdays[7]={"Нд.","Пн.","Вт.","Ср.","Чт.","Пт.","Сб."};  
  //char *monthes[]={"Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"};
  //char *monthes[]={"Сiч.","Лют.","Бер.","Квiт.","Трав.","Черв.","Лип.","Серп.","Вер.","Жовт.","Лист.","Груд."};

  //initADC();  
  sht_init();  
  s_connectionreset();  
  therm_init(-55, 125, THERM_9BIT_RES); 
  i2c_init();  // I2C Bus initialization
  // DS1307 Real Time Clock initialization
  rtc_init(0,1,0);  // Square wave output on pin SQW/OUT: Off // SQW/OUT pin state: 0
 // start = rtc_read(0)&0x80; 
 // if (start)
  //  rtc_write(0,0x00);  //start clock     
   
  //LCD initialization     
  lcd_init(16);
  lcd_clear();
  //lcd_gotoxy(2,0);
  //lcd_putsf("Microclimate");
  //lcd_gotoxy(1,1);
  //lcd_putsf("Control System");
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
  lcd_gotoxy(2,0);
  lcd_putsf("Andriy Halakh");
  //lcd_putsf("А. Галах");
  lcd_gotoxy(4,1);
  lcd_putsf("(C) 2017"); 
  delay_ms(2000);
  lcd_clear();
 //set SHTXX sensor resolution for temperature 12 bit and for humidity 8 bit 
  s_write_statusreg(&value);
  s_read_statusreg(&value, &checksum);
  
  REL1_DDR|=(1<<REL1);  // REL1 0x20
  REL1_PORT&=~(1<<REL1); // REL1 - off 0xdf
  REL2_DDR|=(1<<REL2);  // REL2 0x40
  REL2_PORT|=(1<<REL2); // REL2 - off 0xbf 
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
     // REL1_PORT&=0xdf;
    }
    // check humidity value
    if (humi_val.f < hum.min)
    {
      REL2_PORT|=0x40;
    }
    else //if (humi_val.f > hum.max)
    {
      //REL2_PORT&=0xbf;
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
	   // REL3_PORT&=0x7f;
    }              
    REL2_PORT|=0x40;
    /*vin=readADC(5); //measure pressure ADC5 pin
    pressure=press_m(vin); //calculate pressure
    //print pressure from MPX4115
    sprintf(lcd_buffer,"%uкПа %.1fатм ",pressure, (pressure/101.325));
    lcd_goto_xy(2,3);
    lcd_str(lcd_buffer);*/	
    rtc_get_time(&hour,&min,&sec);//, &wd);
    //rtc_get_date(&date,&month,&year);
    //print time
    sprintf(lcd_buffer, "%u%u:%u%u %s", hour/10,hour%10, min/10,min%10, weekdays[0]);//[wd-1]);
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
