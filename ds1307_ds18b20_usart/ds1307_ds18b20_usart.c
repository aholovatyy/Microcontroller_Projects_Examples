/*****************************************************
This program was produced by the
CodeWizardAVR V1.25.8 Professional
Automatic Program Generator
© Copyright 1998-2007 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 14.04.2010
Author  : Andriy                          
Company : Home                            
Comments: 


Chip type           : ATmega32
Program type        : Application
Clock frequency     : 16,000000 MHz
Memory model        : Small
External SRAM size  : 0
Data Stack size     : 512
*****************************************************/

#include <avr/io.h>
#include <stdio.h>
#include <avr/interrupt.h>
#include <util/delay.h>

#include "lcd_lib.h"
#include "i2c.h"
#include "ds1307.h"
#include "therm_ds18b20.h"  

#define BTN_PORT PORTB
#define BTN_PIN PINB
#define BTN_DDR DDRB

#define MENU_ENTER_BTN 0
#define SELECT_PLUS_BTN 1
#define SELECT_MINUS_BTN 2
#define EXIT_BTN 3

#ifndef F_CPU
   #define F_CPU 16000000UL
#endif

#define CMD_READTEMP 0xa
#define CMD_READTIME 0xb
#define CMD_READDATE 0xc

//визначаємо швидкість обміну
#define BAUDRATE 19200

//розраховуємо значення для UBRR
#define UBRRVAL ((F_CPU/(BAUDRATE*16UL))-1) 

unsigned char PREV_BTN_PIN=0xff; 
char lang = 1; 
unsigned char t_meas_unit = 0; // 0 = Celsius 1 = Fahrenheit
char time_str[9], date_str[17], temp_str[7], lcd_buffer[33];
uint8_t tx_flag = 0;
char *p;

char *dayofweek[7] = //{
	{"Sun","Mon","Tue","Wed","Thr","Fri","Sat"//},
    //{"Нд", "Пн", "Вв", "Ср", "Чт", "Пт", "Сб"//}
}; 

//char *temp_meas_units[2]={"\xdf C ", "\xdf F "};
 
/*unsigned char get_key_status(unsigned char BTN_ID)
{
	return (!(BTN_PIN&(1<<BTN_ID)));
} 

unsigned char get_prev_key_status(unsigned char BTN_ID)
{
	return (!(PREV_BTN_PIN&(1<<BTN_ID)));
} 
     
void temp_settings(void)
{
	unsigned char i = t_meas_unit;
  
	LCDclr();
	LCDGotoXY(3,0); 
	LCDstring("temp in ");
	LCDstring(temp_meas_units[0]);
	LCDGotoXY(3,1);
	LCDstring("temp in ");
	LCDstring(temp_meas_units[1]); 
 
	while(1)                  
	{
		PREV_BTN_PIN=BTN_PIN;
		LCDGotoXY(2,i);
		LCDsendChar('>');
		if(get_key_status(SELECT_PLUS_BTN))
			if(!get_prev_key_status(SELECT_PLUS_BTN))
			{
				LCDGotoXY(2,i);
				LCDsendChar(' ');
				if (i == 1) i = 0;
				else i++; 
			}
		if(get_key_status(SELECT_MINUS_BTN))
			if(!get_prev_key_status(SELECT_MINUS_BTN))
			{
				LCDGotoXY(2,i);
				LCDsendChar(' ');
				if (i == 0) i = 1;
				else i--; 
			}    
       
		if(get_key_status(MENU_ENTER_BTN))       
			if(!get_prev_key_status(MENU_ENTER_BTN))
			{ 
				t_meas_unit = i;
				return;
			}  
         
        if(get_key_status(EXIT_BTN))
        {       
			if(!get_prev_key_status(EXIT_BTN))
            {
                PREV_BTN_PIN = BTN_PIN;
                LCDclr();
                return;
            }
         }             
 }
}    
    
void set_time(void)
{
 unsigned char hh=0, mm=0, ss=0, wd=0, i=0, x=0;
 char ok=0;
 char *items[2][5]={{"wd","hh","mm","ss","^^"},
                   {"дт","гг","хх","сс","^^"}};
 
 rtc_get_time(&hh,&mm,&ss, &wd); 
  
 LCDclr();
 
 while(!ok)                  
 {                         
   PREV_BTN_PIN=BTN_PIN; 
   LCDGotoXY(x,1);
   LCDstring(items[lang][i]);
   LCDGotoXY(0,0);
   sprintf(lcd_buffer,"%s %u%u:%u%u:%u%u OK", dayofweek[lang][wd+1], hh/10,hh%10,mm/10,mm%10,ss/10,ss%10);
   LCDGotoXY(0,0);
   LCDstring(lcd_buffer);
   if(get_key_status(SELECT_PLUS_BTN))
   {
		if (!get_prev_key_status(SELECT_PLUS_BTN))
		{
			switch(i)
			{
				case 0: 
					if (wd==6) wd=0;
					else wd++; 
				break;
				case 1:        
					if (hh==23) hh=0;
					else hh++; 
				break;
				case 2:       
					if (mm==59) mm=0;
					else mm++; 
				break;
				case 3:
					if (ss==59) ss=0;
					else ss++; 
				break;
				case 4: 
					ok=1; 
				break;
			} 
       
        }       
   }    
     
   if (get_key_status(SELECT_MINUS_BTN))
   {
		if (!get_prev_key_status(SELECT_MINUS_BTN))
        {
                switch (i)
                {       
                        case 0: if (wd==6) wd=0;
                                else wd++; 
                                break;
                        case 1: if (hh==0) hh=23;
                                else hh--; 
                                break;
                        case 2: if (mm==0) mm=59;
                                else mm--; 
                                break;
                        case 3: if (ss==0) ss=59;
                                else ss--; 
                                break;
                        case 4: ok=1; 
                                break;
                } 
       
         }       
     }    
     
     if(get_key_status(MENU_ENTER_BTN))
     {       
       if(!get_prev_key_status(MENU_ENTER_BTN))
       {
          LCDGotoXY(x,1);
          LCDstring("  ");
          if (i == 4) 
          {
             i = 0;
             x = 0;
          }
          else 
          {
            if (i == 0) x += 5;
            else x += 3;
            i++;             
          }
                        
         }
       }  
         
         if(get_key_status(EXIT_BTN))
         {       
                if(!get_prev_key_status(EXIT_BTN))
                {
                        PREV_BTN_PIN=BTN_PIN;
                        return;
                }
         }
     
 }  
 rtc_set_time(hh,mm,ss,wd+1); 
} 

void set_language(void)
{
 char languages[2][14]={" *English*  ", "*Украiнська*"};
 //char sel[2][5]={"OK","<OK>"};          
 unsigned char i=0;
 LCDclr();
 
 while(1)                  
 {
    PREV_BTN_PIN=BTN_PIN;
    LCDGotoXY(1,0);
    LCDstring(languages[i]);  
    if (get_key_status(SELECT_PLUS_BTN))
       if (!get_prev_key_status(SELECT_PLUS_BTN))
       {
         if (i==1) i=0;
         else i++; 
       }
    if (get_key_status(SELECT_MINUS_BTN))
       if (!get_prev_key_status(SELECT_MINUS_BTN))
       {
         if (i==0) i=1;
         else i--; 
       }
    if (get_key_status(MENU_ENTER_BTN))       
       if (!get_prev_key_status(MENU_ENTER_BTN))
       { 
          lang=i;
          //ok=1;
          return;
       }  
         
         if (get_key_status(EXIT_BTN))
         {       
                if (!get_prev_key_status(EXIT_BTN))
                {
                        PREV_BTN_PIN = BTN_PIN;
                        LCDclr();
                        return;
                }
         }             
 }
                   
}

void set_date(void)
{
 unsigned char dd=0, mm=0, yy=0, i=0, x=3;
 char ok=0;
 char items[4][5]={"dd","mm","yy","^^"};
 
 rtc_get_date(&dd,&mm,&yy);
 
 LCDclr();
 
 while(!ok)                  
 {                         
   PREV_BTN_PIN=BTN_PIN; 
   LCDGotoXY(x,1);
   LCDstring(items[i]);
   sprintf(lcd_buffer,"%u%u-%u%u-%u%u OK",dd/10,dd%10,mm/10,mm%10,yy/10,yy%10);
   LCDGotoXY(3,0);
   LCDstring(lcd_buffer);
   if (get_key_status(SELECT_PLUS_BTN))
   {
        //delay_ms(100);
        if (get_key_status(SELECT_PLUS_BTN))
        if (!get_prev_key_status(SELECT_PLUS_BTN))
        {
                switch (i)
                {
                        case 0: 
                                if (dd==31) dd=0;
                                else dd++; 
                                break;
                        case 1:       
                                if (mm==12) mm=0;
                                else mm++; 
                                break;
                        case 2:
                                if (yy==99) yy=0;
                                else yy++; 
                                break;
                        case 3: ok=1; break;
                } 
       
         }       
     }    
     
     if (get_key_status(SELECT_MINUS_BTN))
     {
        //delay_ms(100);
        if (get_key_status(SELECT_MINUS_BTN))
        if (!get_prev_key_status(SELECT_MINUS_BTN))
        {
                switch (i)
                {
                        case 0: 
                                if (dd==0) dd=31;
                                else dd--; 
                                break;
                        case 1:       
                                if (mm==0) mm=12;
                                else mm--; 
                                break;
                        case 2:
                                if (yy==0) yy=99;
                                else yy--; 
                                break;
                        case 3: ok=1; break;
                } 
       
         }       
     }    
     
     if (get_key_status(MENU_ENTER_BTN))
     {       
       if (!get_prev_key_status(MENU_ENTER_BTN))
       {
          LCDGotoXY(x,1);
          LCDstring("  ");
          if (i==3) 
          {
             i=0;
             x=3;
          }
          else 
          {
            i++;
            x+=3;
          }
                        
         }
       }  
         
         if (get_key_status(EXIT_BTN))
         {       
                if (!get_prev_key_status(EXIT_BTN))
                {
                        PREV_BTN_PIN=BTN_PIN;
                        LCDclr();
                        return;
                }
         }
     
 }  
 rtc_set_date(&dd,&mm,&yy);
} */
 
/*void main_menu(void)
{
  char *menu_items[2][5] = {{" Set Time & Day ","    Set Date     ", "Choose Language ", 
                                "  t\xdf Settings  ", "      Exit       "}, /
                           {"Вист. Час i День"," Виставити Дату ", "  Вибрати Мову ", 
                                "t\xdf Налаштування", "     Вихiд     "}     };
  char *menu_title[] = { " MAIN MENU", "ГОЛОВНЕ МЕНЮ" };
  unsigned char selected=0;
     
  while(1)
  {
    PREV_BTN_PIN = BTN_PIN;
    LCDGotoXY(2,0);
    LCDstring(menu_title[lang]);
    LCDGotoXY(0,1);    
    LCDstring(menu_items[lang][selected]);
    if(get_key_status(SELECT_PLUS_BTN))
    {
      if(!get_prev_key_status(SELECT_PLUS_BTN))
        if(selected == 4) selected = 0;
        else selected++;
    }   
    
    if(get_key_status(SELECT_MINUS_BTN))
    {
      if (!get_prev_key_status(SELECT_MINUS_BTN))
        if (selected == 0) selected = 4;
        else selected--;
    }   
    
    if(get_key_status(MENU_ENTER_BTN))
		if(!get_prev_key_status(MENU_ENTER_BTN)) 
		{
			switch(selected)
			{    
				case 0: set_time(); break;
				case 1: set_date(); break;   
				case 2: set_language(); break;
				case 3: temp_settings(); break;
				case 4: return; 
				default: break;    
			} 
        LCDclr();
      }
        
    if (get_key_status(EXIT_BTN))
    {       
     if (!get_prev_key_status(EXIT_BTN))
     {
       PREV_BTN_PIN=BTN_PIN;
       return;
     }
    }
  }
}
*/
// USART Initialization
void USART_Init(void)
{
 //виставляємо швидкість обміну: baud rate
 UBRRL=UBRRVAL;	 //молодший байт
 UBRRH=(UBRRVAL>>8); //старший байт
 //виставляємо формат обміну: асинхронний режим, no parity, 1 stop bit, 8 bit size
 UCSRC=(1<<URSEL)/* біт доступу регістр UCSRC або UBRRH. URSEL має бути 1 коли пишемо в регістр UCSRC */
       |(0<<UMSEL) /* режим роботи 0-асинхронний, 1-синхрониий */
       |(0<<UPM1)|(0<<UPM0) /* режим паритету, якщо UPM1=0 і UPM0=0 то відключений */
       |(0<<USBS) /* кількість стоп-бітів, якщо USBS=0 то 1 стоп-біт */
       |(0<<UCSZ2)|(1<<UCSZ1)|(1<<UCSZ0);	/* число біт передачі, якщо UCSZ2=0 UCSZ1=1 UCSZ0=1 то розмір даних 8 біт */
 //Enable Transmitter and Receiver and Interrupt on receive and transmit complete
 UCSRB=(1<<RXCIE)|(1<<TXCIE)|(1<<RXEN)|(1<<TXEN);
 //дозволяємо переривання 
// set_sleep_mode(SLEEP_MODE_IDLE);
 sei();
}    
        
// USART Transmitter interrupt service routine 
ISR(USART_TXC_vect)  
{                                           
 if(*p != '\0')
 {               
	UDR = *p;
	p++;
 }
 else 
  tx_flag = 0; 
}                

// USART Receiver interrupt service routine 
ISR(USART_RXC_vect)  
{                                           
  char Byte; 
  Byte = UDR;
  /*if (Byte == CMD_READTEMP)
  {
	p = temp_str; 
	UDR = p; 
	tx_flag = 1;
  }
  else if */
  switch (Byte)
  {
	case CMD_READTEMP: p = temp_str; UDR = *p; p++; tx_flag = 1; break;
	case CMD_READTIME: p = time_str; UDR = *p; p++; tx_flag = 1; break;
	case CMD_READDATE: p = date_str; UDR = *p; p++; tx_flag = 1; break;
	default: break;
  }
}           
  
int main(void)
{
  char *monthes[12] = //{
		{"Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"//},
		//{"Січ","Лют","Бер","Квiт","Трав","Черв","Лип","Серп","Вер","Жовт","Лист","Груд"//}
  };  
  
  float temp = 0; 
  unsigned char hour, min, sec, wd;
  unsigned char date, month, year;
  
  /* Ініціалізація USART */
  USART_Init();

  /* Ініціалізація кнопок */
  //BTN_DDR&=~(1<<MENU_ENTER_BTN)&~(1<<SELECT_PLUS_BTN)&~(1<<SELECT_MINUS_BTN)&~(1<<EXIT_BTN);              
  //BTN_PORT|=(1<<MENU_ENTER_BTN)|(1<<SELECT_PLUS_BTN)|(1<<SELECT_MINUS_BTN)|(1<<EXIT_BTN);
   
  i2c_init();
  
  rtc_init(0,1,0);
  
  //therm_init(-55, 125, THERM_9BIT_RES);   
 
  /* Ініціалізація LCD */	
  LCDinit(); 
  LCDcursorOFF();
  LCDstring("DS1307 & DS18B20\nUSART DEMO");
  _delay_ms(1000);   
  LCDclr();
 
  for(;;) 
  {
	//if (!tx_flag)
	//{
	therm_read_temperature(&temp); //зчитуємо температуру з DS18B20
    
	if (t_meas_unit) temp = 1.8*temp + 32; // F=(9/5)C+32, 1 degree Celsius = 33.8 degree Fahrenheit
    if (temp>99.9) sprintf(temp_str, "%+d", (int)temp); 
    else sprintf(temp_str, "%+.1f", (double)temp);  
    
	LCDGotoXY(0,0);    
	if (t_meas_unit) sprintf(lcd_buffer,"%s%cF ",temp_str,0xdf); 
	else sprintf(lcd_buffer,"%s%cC ",temp_str,0xdf); 
    LCDstring(lcd_buffer);
    
	LCDGotoXY(8,0);    
    rtc_get_time(&hour, &min, &sec, &wd);
    sprintf(time_str, "%u%u:%u%u:%u%u", hour/10,hour%10, min/10,min%10, sec/10,sec%10);
    LCDstring(time_str);
    rtc_get_date(&date, &month, &year);
    sprintf(date_str, "%s %u%u %s 20%u%u", dayofweek[wd-1],
                date/10,date%10, monthes[month-1], year/10,year%10);
    LCDGotoXY(0,1);                    
    LCDstring(date_str);
      
   /*  if (get_key_status(MENU_ENTER_BTN))
       if (!get_prev_key_status(MENU_ENTER_BTN))
       {
         lcd_clear();
         main_menu();
         lcd_clear(); 
       }  
       
       PREV_BTN_PIN=BTN_PIN;
	 */
    //}
  }      
 
  return 0;
}