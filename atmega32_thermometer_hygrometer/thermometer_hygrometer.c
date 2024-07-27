/*****************************************************
Project : Термометр-гігрометр з годинником на мікроконтролері ATmega32
Version : 
Date    :                                                     
Comments: 
                           
Chip type           : ATmega32
Program type        : Application
Clock frequency     : 8,000000 MHz
Memory model        : Small
External SRAM size  : 0
Data Stack size     : 512
*****************************************************/

#include <avr/io.h> 
#include <stdio.h> // input/output library 
#include <stdlib.h> // ldiv() function 
#include "shtxx.h" // SHTXX temperature & humidity sensor library
#include "therm_ds18b20.h" // DS18B20 temperature sensor library
#include "lcd_lib.h" // бібліотека роботи з РКД
#include "ds1307.h" // Dallas Semiconductors DS1307 I2C Bus Real Time Clock library
#include "24lc256.h" // Microchip 24LC256 I2C Bus EEPROM functions library 

// кнопки MENU/ENTER, SELECT+, SELECT-
#define MENU_ENTER_BTN 0
#define SELECT_PLUS_BTN 1
#define SELECT_MINUS_BTN 2
#define EXIT_BTN 3

int temp_scale = 0; //  шкала вимірювання температури, 0 = Цельсія, 1 = Фаренгейт, 2 = Кельвіна

unsigned char PREV_PINB = 0xFF;

unsigned char GetButtonStatus(unsigned char button)
{
  return (!(PINB & (1 << button)));  
}

unsigned char GetPrevButtonStatus(unsigned char button)
{
  return (!(PREV_PINB & (1 << button)));  
}
  
void SetTime(void)
{
  unsigned char hour = 0, min = 0, sec = 0, wd = 0;
  char *items[] = {"гг", "хх", "сс", "^^"};
  uint8_t x[] = {1, 4, 7, 11}, i = 0;
  
  rtc_get_time(&hour, &min, &sec, &wd);  // прочитати поточний час 
  while(1)
  {
    PREV_PINB = PINB;
    
    LCDGotoXY(1,0);    
    LCDsendChar((48+hour/10));
    LCDsendChar((48+hour%10));	
    LCDsendChar(':');
    LCDsendChar((48+min/10));
    LCDsendChar((48+min%10));	
    LCDsendChar(':');
    LCDsendChar((48+sec/10));
    LCDsendChar((48+sec%10));
	LCDsendChar(' ');
	LCDstring("<OK>");
	
	LCDGotoXY(x[i],1);    
    LCDstring(items[i]);
    	
    if (GetButtonStatus(SELECT_PLUS_BTN)) // натиснута кнопка SELECT+?
    {  
      /*if (!GetPrevButtonStatus(SELECT_PLUS_BTN))
      {*/
	    _delay_ms(200);
        if (i == 0)
		{
          if (hour < 23)
		    hour++;
		  else hour = 0;
		}
        else if (i == 1)
		{
		  if (min<59)
		    min++;
		  else min=0;
		}  
		else if (i == 2)
		{
		  if (sec < 59)
		    sec++;
		  else sec = 0;
		}  
        else if (i == 3) // OK selection
		{
		  /*LCDGotoXY(x[i],1);    
          LCDstring("  ");
		  i = 0;*/
          rtc_set_time(hour, min, sec, wd);
		  return;		
        }
    }
    if (GetButtonStatus(SELECT_MINUS_BTN)) // натиснута кнопка SELECT-?
    {  
      if (!GetPrevButtonStatus(SELECT_MINUS_BTN))
      {
        if (i == 0)
		{
          if (hour != 0)
		    hour--;
		  else hour = 23;
		}
		else if (i == 1)
		{
		  if (min != 0)
		    min--;
		  else min = 59;
		}  
		else if (i == 2)
		{
		  if (sec != 0)
		    sec--;
		  else sec = 59;
		}  
		else if (i == 3) // <OK> 
		{
		  /*LCDGotoXY(x[i],1);    
          LCDstring("  ");
		  i = 2;*/
		  rtc_set_time(hour, min, sec, wd);
		  return;
		}
		
      }
    }              
   
    if (GetButtonStatus(MENU_ENTER_BTN)) // натиснута кнопка MENU_ENTER?
    {  
      if (!GetPrevButtonStatus(MENU_ENTER_BTN))
	  {
	    LCDGotoXY(x[i],1);    
        LCDstring("  ");
    	
        if (i < 3)
		  i++;
		/*else if (i == 3)
		{
		   rtc_set_time(hour, min, sec, wd);
		   return;
		}*/
		else		   
		  i = 0;
	  }
    }   
    
    if (GetButtonStatus(EXIT_BTN)) // натиснута кнопка EXIT?
    {
	  PREV_PINB = PINB;	  
      return;
    }                          
  }
  
}

void SetDate(void)
{
  unsigned char date = 0, month = 0, year = 0;
  char *items[] = {"дд", "мм", "рр", "^^"};
  uint8_t x[] = {1, 4, 7, 11}, i = 0;
  
  rtc_get_date(&date,&month,&year);
  
  while(1)
  {
    PREV_PINB = PINB;
    
    LCDGotoXY(1,0);    
    LCDsendChar((48+date/10));
    LCDsendChar((48+date%10));	
    LCDsendChar('/');
    LCDsendChar((48+month/10));
    LCDsendChar((48+month%10));	
    LCDsendChar('/');
    LCDsendChar((48+year/10));
    LCDsendChar((48+year%10));
	LCDsendChar(' ');
	LCDstring("<OK>");
	
	LCDGotoXY(x[i],1);    
    LCDstring(items[i]);

	
    if (GetButtonStatus(SELECT_PLUS_BTN))  // натиснута кнопка SELECT+?
    {  
      /*if (!GetPrevButtonStatus(SELECT_PLUS_BTN))
      {*/
	    _delay_ms(200);
		switch (i)
		{
		   case 0:
             if (date < 31)
		       date++;
		     else date = 0;
		   break;  
		   
		   case 1:
		     if (month < 12)
		       month++;
		     else month = 0;
		   break; 
		   
		   case 2:
		     if (year < 99)
		       year++;
		     else year = 0;
		   break;
		   
		   case 3:
		     rtc_set_date(&date, &month, &year);     
             return;
		   
		}        
	
    }
	
	
    if (GetButtonStatus(SELECT_MINUS_BTN)) // натиснута кнопка SELECT-?
    {  
      if (!GetPrevButtonStatus(SELECT_MINUS_BTN))
      {
        switch (i)
		{
           case 0:
		     if (date != 0)
		       date--;
		     else date = 31;
		   break;
		   
		   case 1:
		     if (month != 0)
		       month--;
		     else month = 12;
		   break;
		   
		   case 2:
		     if (year != 0)
		       year--;
		     else year = 99;
		   break;
		   
		   case 3:
		     rtc_set_date(&date, &month, &year);     
             return;
		   //default: break;
		   
		}  		
	
      }  
    
    }        
   
    if (GetButtonStatus(MENU_ENTER_BTN)) // натиснута кнопка MENU_ENTER?
    {  
      if (!GetPrevButtonStatus(MENU_ENTER_BTN))
      {
        LCDGotoXY(x[i],1);    
        LCDstring("  ");
    	
        if (i < 3)
		  i++;	
		else		   
		  i = 0;
	  }
    }   
    
    if (GetButtonStatus(EXIT_BTN)) // натиснута кнопка EXIT?
    {
	  PREV_PINB = PINB;
      return;
    }                           
  }   
}


void SetTempUnit(void)
{
  char *menu_items[] = {"    Цельсiя  ", "   Фаренгейта", "    Кельвiна  "};
  int i = 0;
  LCDGotoXY(0,0);
  LCDstring("ШКАЛА ВИМ. ТЕМП."); 

  while(1)
  {    
    PREV_PINB = PINB;
    LCDGotoXY(0,1);
    LCDstring(menu_items[i]);
	
    if (GetButtonStatus(SELECT_PLUS_BTN))  // натиснута кнопка SELECT+?
    {  
      if (!GetPrevButtonStatus(SELECT_PLUS_BTN))
      {
        if (i < 2)
		  i++;
		else i = 0;
      }
    }
    if (GetButtonStatus(SELECT_MINUS_BTN)) // натиснута кнопка SELECT-?
    {  
      if (!GetPrevButtonStatus(SELECT_MINUS_BTN))
      {
        if (i > 0)	
		  i--;
		else
		  i = 2;
      }
    }              
    if (GetButtonStatus(MENU_ENTER_BTN)) // натиснута кнопка MENU_ENTER?
    {  
      if (!GetPrevButtonStatus(MENU_ENTER_BTN))
      {
        temp_scale = i; 
		return;
      }
    }      
  
    if (GetButtonStatus(EXIT_BTN)) // натиснута кнопка EXIT?
    {
      if (!GetPrevButtonStatus(EXIT_BTN))
      {
	    PREV_PINB = PINB;	    
        return;
	  }
    }        
    
  }
}

void MainMenu(void)
{
  char *menu_items[]={" Встановити час ", "Встановити дату ", "Одиницi темп-ри ", "     Вийти      "};
  int i = 0;
  LCDGotoXY(0,0);
  LCDstring("* ГОЛОВНЕ МЕНЮ *"); //("Головне меню");
  while(1)
  {    
    PREV_PINB = PINB;
    LCDGotoXY(0,1);
    LCDstring(menu_items[i]);
    if (GetButtonStatus(SELECT_PLUS_BTN))  // натиснута кнопка SELECT+?
    {  
      if (!GetPrevButtonStatus(SELECT_PLUS_BTN))
      {
        if (i < 3)
		  i++;
		else i = 0;
      }
    }
    if (GetButtonStatus(SELECT_MINUS_BTN)) // натиснута кнопка SELECT-?
    {  
      if (!GetPrevButtonStatus(SELECT_MINUS_BTN))
      {
        if (i > 0)	
		  i--;
		else
		  i = 3;
      }
    }              
    if (GetButtonStatus(MENU_ENTER_BTN)) // натиснута кнопка MENU_ENTER?
    {  
      if (!GetPrevButtonStatus(MENU_ENTER_BTN))
      {
        LCDclr(); 
        switch (i)
		{
		  case 0: SetTime(); break;
		  case 1: SetDate(); break;
		  case 2: SetTempUnit(); break;
		  case 3: return;
		}   
		LCDclr(); 
		LCDGotoXY(0,0);
		LCDstring("* ГОЛОВНЕ МЕНЮ *");
      }
    }      
  
    if (GetButtonStatus(EXIT_BTN)) // натиснута кнопка EXIT?
    {
      if (!GetPrevButtonStatus(EXIT_BTN))
      {
	    PREV_PINB = PINB;
	    LCDclr();
        return;
	  }
    }        
    
  }
}


int main(void)
{  
  value humi_val, temp_val;
  float t=0,dew_point=0;
  unsigned char error, checksum, value = 1;
  char lcd_buffer[33];
  unsigned char hour, min, sec, wd, prev_sec = 0, colon_symbol = ':';
  unsigned char date, month, year;
  char *weekdays[]={"Нд","Пн","Вт","Ср","Чт","Пт","Сб"};  
  char *monthes[]={"Сiч.","Лют.","Бер.","Квiт.","Трав.","Черв.","Лип.","Серп.","Вер.","Жовт.","Лист.","Груд."};
     
  sht_init();  
  s_connectionreset();  
  therm_init(-55, 125, THERM_9BIT_RES);   
  //i2c_init();  
  rtc_init(0,1,0);  
  /* ініціалізація РКД  */
   LCDinit();
   LCDcursorOFF();  
  // Print on first line
  LCDGotoXY(3,0);	
  LCDstring("Термометр-");  
  LCDGotoXY(3,1);
  LCDstring("гiгрометр");
  _delay_ms(1000);
  LCDclr();
  LCDGotoXY(2,0);	
  LCDstring("з годинником");  
  LCDGotoXY(1,1);
  LCDstring("на МК ATmega32");
  _delay_ms(1000);
  LCDclr();
  LCDGotoXY(1,0);
  LCDstring("Розробив: ");  
  LCDGotoXY(1,1);
  LCDstring("Олексiй Федик"); 
  _delay_ms(1000);
  LCDclr();	
  LCDGotoXY(0,1);	                
  //set SHTXX sensor resolution for temperature 12 bit and for humidity 8 bit 
  s_write_statusreg(&value);
  s_read_statusreg(&value, &checksum);  
  while(1)
  { 
    therm_read_temperature(&t); //measure temperature from DS18B20	
    error=0;
    error+=s_measure((unsigned char*) &humi_val.i,&checksum,HUMI);  //measure humidity
    error+=s_measure((unsigned char*) &temp_val.i,&checksum,TEMP);  //measure temperature
    if (error!=0) 
      s_connectionreset(); //in case of an error: connection reset
    else
    { 
      humi_val.f = (float)humi_val.i;    //converts integer to float
      temp_val.f = (float)temp_val.i;    //converts integer to float
      calc_sth11(&humi_val.f,&temp_val.f);   //calculate humidity, temperature
      dew_point = calc_dewpoint(humi_val.f,temp_val.f); //calculate dew point      
	  // виводимо температуру з давача температури ds18b20 і вологість з давача SHTXX
	  switch (temp_scale)
      {
        case 0: 
          sprintf(lcd_buffer,"%+3.1f", (double)t);
	      LCDGotoXY(0,0);
	      LCDstring(lcd_buffer);
	      LCDsendChar(0xdf);
	      LCDstring("C ");
        break; 
        case 1: 
		  t = (9.0/5.0)*t+32.0;
          sprintf(lcd_buffer,"%+3.1f", (double)t);
	      LCDGotoXY(0,0);
	      LCDstring(lcd_buffer);
	      LCDsendChar(0xdf);
	      LCDstring("F ");
        break;
        case 2:
          t += 274.15;
		  sprintf(lcd_buffer,"%+3.1f", (double)t);
	      LCDGotoXY(0,0);
	      LCDstring(lcd_buffer);
	      LCDstring("K ");
        break;       
      }	  
	  sprintf(lcd_buffer,"%3.1f%% ", (double)humi_val.f);
      LCDstring(lcd_buffer);	  	  
    }
	rtc_get_time(&hour, &min, &sec, &wd);
	rtc_get_date(&date, &month, &year);
	LCDstring(weekdays[wd-1]);
	LCDsendChar(' ');
	if (prev_sec != sec)
	{
	   prev_sec = sec;
	   if (colon_symbol == ':') 
	     colon_symbol = ' ';
	   else
	     colon_symbol = ':';
	}
	// виводимо час
	sprintf(lcd_buffer, "%u%u%c%u%u ", hour/10,hour%10, colon_symbol, min/10,min%10);
    LCDGotoXY(0,1);	  
	LCDstring(lcd_buffer);
	// виводимо дату
	sprintf(lcd_buffer, "%u%u.%u%u.20%u%u", date/10,date%10, month/10,month%10, year/10,year%10);
    LCDstring(lcd_buffer);        
	
	if (GetButtonStatus(MENU_ENTER_BTN)) //enter
    {  
      if (!GetPrevButtonStatus(MENU_ENTER_BTN))
      {
        LCDclr();        
        MainMenu(); 
      }
    }      
    _delay_ms(300);
    //----------wait approx. 0.8s to avoid heating up SHTxx------------------------------      
    //for (i=0;i<40000;i++);     //(be sure that the compiler doesn't eliminate this line!)
    //-----------------------------------------------------------------------------------                       
  }
  return 0;
}