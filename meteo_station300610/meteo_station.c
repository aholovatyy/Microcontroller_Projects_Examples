/*****************************************************
Project : METEO STATION DEMO
Version : 
Date    : 22.06.2010
Author  : (C) Andriy Holovatyy                                                     
Comments: 
                           
Chip type           : ATmega32
Program type        : Application
Clock frequency     : 4,000000 MHz
Memory model        : Small
External SRAM size  : 0
Data Stack size     : 512
*****************************************************/

#include <avr/io.h> 
#include <stdio.h> //input/output library 
#include <stdlib.h> // ldiv() function 
#include "shtxx.h" //SHTXX temperature & humidity sensor library
#include "mpx4115.h" //MPX4115 pressure sensor library
#include "therm_ds18b20.h" // DS18B20 temperature sensor library
#include "nokia_lcd.h" // NOKIA3310 LCD library
#include "ds1307.h" // Dallas Semiconductors DS1307 I2C Bus Real Time Clock library
#include "24lc256.h" // Microchip 24LC256 I2C Bus EEPROM functions library 
#include <avr/pgmspace.h>

unsigned char PROGMEM waitImage[]= {
0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0xC0,0x20,0x20,
0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0xC0,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
0x00,0x00,0xF0,0x10,0x10,0x10,0x10,0xE0,0x00,0x00,0xF0,0x00,0x00,0x80,0x40,0x40,
0x40,0x80,0x00,0x00,0x80,0x40,0x40,0x40,0x80,0x00,0x00,0x80,0x40,0x40,0x40,0x80,
0x00,0x00,0x80,0x40,0x40,0x40,0x80,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
0x00,0x0F,0x11,0x31,0x31,0xD1,0xF1,0xD1,0xD1,0x31,0x11,0x11,0x0F,0x00,0x00,0x00,
0x00,0x00,0x00,0x00,0x00,0x00,0x1F,0x01,0x01,0x01,0x01,0x00,0x00,0x00,0x1F,0x00,
0x00,0x0F,0x12,0x12,0x12,0x0B,0x00,0x00,0x0C,0x12,0x12,0x0A,0x1F,0x00,0x00,0x09,
0x12,0x12,0x12,0x0C,0x00,0x00,0x0F,0x12,0x12,0x12,0x0B,0x00,0x00,0x00,0x00,0x00,
0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
0x00,0x00,0x00,0x00,0x00,0xF0,0x18,0x86,0x86,0xE1,0xF1,0xE1,0xE1,0x86,0x18,0x18,
0xF0,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x60,0x80,0x00,0x80,
0x60,0x80,0x00,0x80,0x60,0x00,0x40,0x20,0x20,0x20,0xC0,0x00,0x00,0xE8,0x00,0x20,
0xF8,0x20,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x03,0x07,0x07,0x07,0x07,0x07,0x07,
0x07,0x07,0x07,0x07,0x03,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
0x00,0x03,0x0C,0x03,0x00,0x03,0x0C,0x03,0x00,0x00,0x06,0x09,0x09,0x05,0x0F,0x00,
0x00,0x0F,0x00,0x00,0x0F,0x08,0x00,0x00,0x00,0x00,0x08,0x00,0x00,0x08,0x00,0x00,
0x08,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00};



//buttons MENU/ENTER, SELECT+, SELECT-
#define MENU_ENTER_BTN 0
#define SELECT_PLUS_BTN 1
#define SELECT_MINUS_BTN 2
#define EXIT_BTN 3

unsigned char PREV_PINB=0xff;

/*eeprom*/ //char temp[]={ 
    //26, /* T_OUT_FAN_OFF ciai?oiy oaiia?aoo?a aeee??aiiy FAN */
    //22, /* T_IN_FAN_ON aioo??oiy oaiia?aoo?a aieeaiiy FAN */
    //20, /* T_IN_FAN_OFF aioo??oiy oaiia?aoo?a aeieeaiiy FAN */
    //26, /* T_OUT_SHU_OFF_MAX iaeneiaeuia ciai?oiy oaiia?aoo?a cae?eooy caneiiee */
    //10, /* T_OUT_SHU_OFF_MIN i?i?iaeuia ciai?oiy oaiia?aoo?a cae?eooy caneiiee */ 
    //26, /* T_IN_CON_ON_MAX iaeneiaeuia aioo??oiy oaiia?aoo?a aee??aiiy eiiaeo?iia?a */
    //10, /* T_IN_CON_ON_MIN i?i?iaeuia aioo??oiy oaiia?aoo?a aee??aiiy eiiaeo?iia?a */
    //10, /* T_OUT_CON_ON ciai?oiy oaiia?aoo?a aee??aiiy eiiaeo?iia?a */
    //37  /* T_ALARM aaa??eia oaiia?aoo?a aeee??aiiy aaioeeyoi?a (FAN) ? caneiiee (SHU) */
//}; // temperatures

unsigned char get_key_status(unsigned char key)
{
  return (!(PINB & (1<<key)));  
}

unsigned char get_prev_key_status(unsigned char key)
{
  return (!(PREV_PINB & (1<<key)));  
}
  
void set_time(void)
{
  unsigned char hour=0, min=0, sec=0, wd=0;
  unsigned char x=4, y=4;
  
  rtc_get_time(&hour,&min,&sec, &wd);
//  rtc_get_date(&date,&month,&year);
  
  lcd_goto_xy(4,2);
  lcd_str("hh mm ss");
  
  lcd_goto_xy(7,5);
  lcd_str("OK");
  
  while(1)
  {
    PREV_PINB=PINB;
    
    lcd_goto_xy(4,3);    
    lcd_chr((48+hour/10));
    lcd_chr((48+hour%10));	
    lcd_chr(':');
    lcd_chr((48+min/10));
    lcd_chr((48+min%10));	
    lcd_chr(':');
    lcd_chr((48+sec/10));
    lcd_chr((48+sec%10));
	
	if (y!=5) 
	{
	 lcd_goto_xy(x,y);    
     lcd_str("^^");
    }
	
    if (get_key_status(SELECT_PLUS_BTN))  //select+
    {  
      /*if (!get_prev_key_status(SELECT_PLUS_BTN))
      {*/
	    _delay_ms(120);
        if (x==4)
		{
          if (hour<23)
		    hour++;
		  else hour=0;
		}
  
		if (x==7)
		{
		  if (min<59)
		    min++;
		  else min=0;
		}  
		
		if (x==10)
		{
		  if (sec<59)
		    sec++;
		  else sec=0;
		}  
         
		if (y==5) // OK selection
		  break;
		
      //}
    }
    if (get_key_status(SELECT_MINUS_BTN)) //select-
    {  
      if (!get_prev_key_status(SELECT_MINUS_BTN))
      {
        if (x==4)
		{
          if (hour!=0)
		    hour--;
		  else hour=23;
		}
  
		if (x==7)
		{
		  if (min!=0)
		    min--;
		  else min=59;
		}  
		
		if (x==10)
		{
		  if (sec!=0)
		    sec--;
		  else sec=59;
		}  
		
		if (y==5) // OK selection
		  break;
		
      }
    }              
   
    if (get_key_status(MENU_ENTER_BTN)) //enter
    {  
      if (!get_prev_key_status(MENU_ENTER_BTN))
      {
        lcd_goto_xy(x,4);    
        lcd_str("  ");
		if (x!=10) x+=3;
	    else 
		{
		  if (y!=5)
		  {
		    y++;
		    lcd_goto_xy(6,y);
            lcd_chr('<');
			lcd_goto_xy(9,y);            
			lcd_chr('>');			 
		  }
		  else 
		  { 
		    lcd_goto_xy(6,y);
            lcd_chr(' ');
			lcd_goto_xy(9,y);            
			lcd_chr(' ');	
			x=4; y=4; 
		  }
		}
      } 
    }   
    
    if (get_key_status(EXIT_BTN)) //exit
    {
      //button_pressed=1;
	  PREV_PINB=PINB;	  
      return;
    }                          
  }
  
  rtc_set_time(hour, min, sec, wd); 
}

void set_date(void)
{
  unsigned char date=0, month=0, year=0;
  unsigned char x=4, y=4;
  
  rtc_get_date(&date,&month,&year);
  
  lcd_goto_xy(4,2);
  lcd_str("dd mm yy");
  
  lcd_goto_xy(7,5);
  lcd_str("OK");
  
  while(1)
  {
    PREV_PINB=PINB;
    
    lcd_goto_xy(4,3);    
    lcd_chr((48+date/10));
    lcd_chr((48+date%10));	
    lcd_chr('/');
    lcd_chr((48+month/10));
    lcd_chr((48+month%10));	
    lcd_chr('/');
    lcd_chr((48+year/10));
    lcd_chr((48+year%10));
	
	if (y!=5) 
	{
	 lcd_goto_xy(x,y);    
     lcd_str("^^");
    }
	
    if (get_key_status(SELECT_PLUS_BTN))  //select+
    {  
      /*if (!get_prev_key_status(SELECT_PLUS_BTN))
      {*/
	    _delay_ms(120);
        if (x==4)
		{
          if (date<31)
		    date++;
		  else date=0;
		}
  
		if (x==7)
		{
		  if (month<12)
		    month++;
		  else month=0;
		}  
		
		if (x==10 && y!=5)
		{
		  if (year<99)
		    year++;
		  else year=0;
		}  
        
		if (y==5) // OK selection
		  break;
      //}
    }
    if (get_key_status(SELECT_MINUS_BTN)) //select-
    {  
      if (!get_prev_key_status(SELECT_MINUS_BTN))
      {
        if (x==4)
		{
          if (date!=0)
		    date--;
		  else date=31;
		}
  
		if (x==7)
		{
		  if (month!=0)
		    month--;
		  else month=12;
		}  
		
		if (x==10 && y!=5)
		{
		  if (year!=0)
		    year--;
		  else year=99;
		}
   
        if (y==5) // OK selection
		  break; 
      }
    }              
   
    if (get_key_status(MENU_ENTER_BTN)) //enter
    {  
      if (!get_prev_key_status(MENU_ENTER_BTN))
      {
        lcd_goto_xy(x,4);    
        lcd_str("  ");
		if (x!=10) x+=3;
	    else 
		{
		  if (y!=5)
		  {
		    y++;
		    lcd_goto_xy(6,y);
            lcd_chr('<');
			lcd_goto_xy(9,y);            
			lcd_chr('>');			 
		  }
		  else 
		  { 
		    lcd_goto_xy(6,y);
            lcd_chr(' ');
			lcd_goto_xy(9,y);            
			lcd_chr(' ');	
			x=4; y=4; 
		  }
		}
      } 
    }   
    
    if (get_key_status(EXIT_BTN)) //exit
    {
      //button_pressed=1;
	  PREV_PINB=PINB;
	  //lcd_clear();
      return;
    }                          
  }
  
  rtc_set_date(&date, &month, &year); 
  
}

void show_main_menu(void)
{
  char *menu_items[]={" Set Time ", " Set Date ", " Settings "};//," Exit "};
  int selected=0, i;
  lcd_goto_xy(4,1);
  lcd_str("MAIN MENU");
  for (i=0; i<3; i++) 
  {
   lcd_goto_xy(3,i+3);
   lcd_str(menu_items[i]);     
  }
  while(1)
  {    
    PREV_PINB=PINB;
    lcd_goto_xy(2,selected+3);
    lcd_str(">");
    if (get_key_status(SELECT_PLUS_BTN))  //select+
    {  
      if (!get_prev_key_status(SELECT_PLUS_BTN))
      {
        if (selected!=2)
		{
          lcd_goto_xy(2,selected+3);
		  lcd_str(" ");
		  selected++;
		}
      }
    }
    if (get_key_status(SELECT_MINUS_BTN)) //select-
    {  
      if (!get_prev_key_status(SELECT_MINUS_BTN))
      {
        if (selected!=0)
		{
          lcd_goto_xy(2,selected+3);
		  lcd_str(" ");
		  selected--;
		}
      }
    }              
    if (get_key_status(MENU_ENTER_BTN)) //enter
    {  
      if (!get_prev_key_status(MENU_ENTER_BTN))
      {
        lcd_clear(); 
        switch (selected)
		{
		  case 0: set_time(); break;
		  case 1: set_date(); break;
		  case 2: break;
		}   
		lcd_clear(); 
		lcd_goto_xy(4,1);
		lcd_str("MAIN MENU");
		for (i=0; i<3; i++) 
		{
			lcd_goto_xy(3,i+3);
			lcd_str(menu_items[i]);     
		}
      }
    }      
  
    if (get_key_status(EXIT_BTN)) //exit
    {
      if (!get_prev_key_status(EXIT_BTN))
      {
	    //button_pressed=1;
	    PREV_PINB=PINB;
	    lcd_clear();
        return;
	  }
    }        
    
  }
}


int h;
unsigned int address;
char hist_sel;
unsigned int hist_index=20, curr_index=10;			// for graphical stuff
int diff_hi_lo, tt_in_hi, tt_in_lo, t_value, tt_value;
char plot_value;

//signed char displ_mod;					// for user menu
char temp_outp=0;
char press_outp=0;

float tc_ex_float;
float tf_ex_float;

float t_ex_hi,t_ex_lo,t_ex_temp;
char rx_status;							// for RX Radio routines
unsigned int rx_valid_in_loop;

void store_t_ex(void)
{
  address=(0x1000|(hist_index<<4));

  if (rx_valid_in_loop<60){
	if (temp_outp==0)
	{
	  write_float_ext_eeprom(address,tc_ex_float);
	}	
	else if (temp_outp==1)
	{
	  write_float_ext_eeprom(address,tf_ex_float);
	}	
  }
  
  t_ex_hi=-200.0499;
  t_ex_lo=200.0499; 

  for (h=0; h!=42; h++)
  {											// search for t_in_hi & lo in EEPROM
	address=(0x1000|(h<<4));
	t_ex_temp=read_float_ext_eeprom(address);
	if (((t_ex_temp<-200)||(t_ex_temp>200))&&(rx_valid_in_loop<60))
	{ // write current value if reading is invalid
   	  if (temp_outp==0)
	  {
	    write_float_ext_eeprom(address,tc_ex_float);
	  }	
	  else if (temp_outp==1)
	  {
	    write_float_ext_eeprom(address,tf_ex_float);
	  }	
	}	
	else if (rx_valid_in_loop<60)
	{
	  if (t_ex_temp>t_ex_hi)
	  {
	    t_ex_hi=t_ex_temp;
	  }
	  if (t_ex_temp<t_ex_lo)
	  {
	    t_ex_lo=t_ex_temp;
	  }
	}
  }

}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void show_t_ex_graph(void)
{
  ldiv_t x;

  tt_in_hi=t_ex_hi*10;
  tt_in_lo=t_ex_lo*10;

  diff_hi_lo=(tt_in_hi-tt_in_lo);
  curr_index=hist_index;

  for (h=83;h!=41;h--)
  {
	address=(0x1000|(curr_index<<4));
	t_value=read_float_ext_eeprom(address)*10;
    tt_value=(diff_hi_lo-(tt_in_hi-t_value));
    x=ldiv(tt_value*32,diff_hi_lo);
    plot_value=x.quot; 
    lcd_plot(h,plot_value);
    curr_index-=1;
    if (curr_index==65535){ curr_index=41; } // 0 to 41 here 
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

float tc_in_float;
float tf_in_float;
float t_in_hi,t_in_lo,t_in_temp;

void store_t_in(void)
{
  address=(0x1008|(hist_index<<4));
  if (temp_outp==0)
  {
    write_float_ext_eeprom(address,tc_in_float);
  }	
  else if (temp_outp==1)
  {
    write_float_ext_eeprom(address,tf_in_float);
  }	
  t_in_hi=-200;
  t_in_lo=200;
  
  for (h=0; h!=42; h++)
  {											// search for t_in_hi & lo in EEPROM
	address=(0x1008|(h<<4));
	t_in_temp=read_float_ext_eeprom(address);
	if ((t_in_temp<-200)||(t_in_temp>200))
	{					// write current value if reading is invalid
	  if (temp_outp==0) { write_float_ext_eeprom(address,tc_in_float); }	
	  else if (temp_outp==1){ write_float_ext_eeprom(address,tf_in_float); }	
	}	
	else 
	{
	  if (t_in_temp>t_in_hi){ t_in_hi=t_in_temp; }
	  if (t_in_temp<t_in_lo){t_in_lo=t_in_temp;}
	}
  }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void show_t_in_graph(void)
{
  ldiv_t x;
  
  tt_in_hi=t_in_hi*10;
  tt_in_lo=t_in_lo*10;

  diff_hi_lo=(tt_in_hi-tt_in_lo);

  curr_index=hist_index;

  for (h=83; h!=41; h--)
  {
	address=(0x1008|(curr_index<<4));
	t_value=read_float_ext_eeprom(address)*10;

    tt_value=(diff_hi_lo-(tt_in_hi-t_value));
    x=ldiv(tt_value*32,diff_hi_lo);
    plot_value=x.quot; 

    lcd_plot(h,plot_value);

    curr_index-=1;
    if (curr_index==65535){ curr_index=41; } // 0 to 41 here 
  }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

float p_hPa_float;
float p_inHg_float;						
float press_hi,press_lo,press_temp; 

void store_press(void)
{
  address=(0x1004|(hist_index<<4));
  if (press_outp==0) { write_float_ext_eeprom(address,p_hPa_float); }	
  else if (press_outp==1) { write_float_ext_eeprom(address,p_inHg_float); }	

  press_hi=-200;
  press_lo=1200;

  for (h=0; h!=41; h++)
  {												// search for press_hi & lo in EEPROM
	address=(0x1004|(h<<4));
	press_temp=read_float_ext_eeprom(address);

	if ((press_temp<-200)||(press_temp>1200))
	{					// write current value if reading is invalid
	  if (press_outp==0) { write_float_ext_eeprom(address,p_hPa_float); }	
	  else if (press_outp==1){ write_float_ext_eeprom(address,p_inHg_float); }	
	}												
	else 
	{	
	  if (press_temp>press_hi) { press_hi=press_temp; }
	  if (press_temp<press_lo) { press_lo=press_temp; }
	}
  }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void show_press_graph(void)
{
  ldiv_t x;

  tt_in_hi=press_hi*10;
  tt_in_lo=press_lo*10;

  diff_hi_lo=(tt_in_hi-tt_in_lo);

  curr_index=hist_index;

  for (h=83; h!=41; h--)
  {
	address=(0x1004|(curr_index<<4));
	t_value=read_float_ext_eeprom(address)*10;

    tt_value=(diff_hi_lo-(tt_in_hi-t_value));

    x=ldiv(tt_value*32,diff_hi_lo);
    plot_value=x.quot; 

    lcd_plot(h,plot_value);

    curr_index-=1;
    if (curr_index==65535) { curr_index=41; } // 0 to 41 here
  }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
char rh_hi,rh_lo,rh_temp; 
char rh_procent;

void store_rh(void)
{
  address=(0x100c|(hist_index<<4));
  write_ext_eeprom(address,rh_procent);	

  rh_hi=0;
  rh_lo=100;

  for (h=0; h!=42; h++)
  {											// search for t_in_hi & lo in EEPROM
	address=(0x100c|(h<<4));
	rh_temp=read_ext_eeprom(address);
	if ((rh_temp<1)||(rh_temp>100))
	{					// write current value if reading is invalid
  	  write_ext_eeprom(address,rh_procent);
	}	
	else 
	{	
	  if (rh_temp>rh_hi) { rh_hi=rh_temp; }
	  if (rh_temp<rh_lo) { rh_lo=rh_temp; }
	}
  }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void show_rh_graph(void)
{
  ldiv_t x;

  tt_in_hi=rh_hi;
  tt_in_lo=rh_lo;

  diff_hi_lo=(tt_in_hi-tt_in_lo);

  curr_index=hist_index;

  for (h=83; h!=41; h--)
  {
	address=(0x100c|(curr_index<<4));
	t_value=read_ext_eeprom(address);

    tt_value=(diff_hi_lo-(tt_in_hi-t_value));

    x=ldiv(tt_value*32,diff_hi_lo);
    plot_value=x.quot; 

	lcd_plot(h,plot_value);

    curr_index-=1;
    if (curr_index==65535) { curr_index=41; } // 0 to 41 here
  }
}

/*void update_interval(void)
{
  hist_index=read_ext_eeprom(0x0007);		// hist_index increment (every 1 hour)
  if ((rtenmin==0)&&(rmin==0))
  {
    hist_index+=1;
	while(rmin==0){ show_rtc(); }		// wait until minute is passed
  }
  //
  if (hist_index>41) hist_index=0;
    write_ext_eeprom(0x0007, hist_index);
}*/


int main(void)
{
  /* program that shows how to use SHTXX, DS18B20, MPX4115 functions and to display information on NOKIA LCD 3310 */
    
  value humi_val,temp_val;
  float t=0,dew_point=0;
  unsigned char error,checksum,value=1;
//  unsigned int i;
  char lcd_buffer[33];
  unsigned int vin, pressure;
  unsigned char hour, min, sec, wd;
  unsigned char date, month, year;
  //char *weekdays[]={"Sun","Mon","Tue","Wed","Thr","Fri","Sat"};
  char *weekdays[]={"Õ‰.","œÌ.","¬Ú.","—.","◊Ú.","œÚ.","—·."};  
  //char *monthes[]={"Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"};
  char *monthes[]={"—i˜.","À˛Ú.","¡Â."," ‚iÚ.","“‡‚.","◊Â‚.","ÀËÔ.","—ÂÔ.","¬Â.","∆Ó‚Ú.","ÀËÒÚ.","√Û‰."};
  
   
  initADC();
  
  sht_init();  
  s_connectionreset();
  
  therm_init(-55, 125, THERM_9BIT_RES);  
  
  //i2c_init();
  
  rtc_init(0,1,0);
  
  //LCD initialization 	
  lcd_init();
  //lcd_contrast(0x40);
  // Print on first line
  lcd_goto_xy(6,3);	
  lcd_str("ÃÂÚÂÓ");
  lcd_goto_xy(5,4);
  lcd_str("—Ú‡Ìˆiˇ");  
  lcd_goto_xy(6,5);	
  lcd_str("ƒÂÏÓ");  
  _delay_ms(2000);
  lcd_image(waitImage); 
  lcd_update();
  _delay_ms(2000);
  /*LcdClear();
  LcdPixelMode mode=PIXEL_ON; 
  lcd_line (5, 20, 10, 30, mode);
  lcd_update();
  _delay_ms(1000);
  LcdClear();
  lcd_circle(40, 24, 22, mode);
  lcd_update();
  _delay_ms(1000);  */
  lcd_clear();
  //lcd_goto_xy(6,5);
    
  //if (test_eeprom()) lcd_str("Failed"); 
  //else lcd_str("OK"); 
  //_delay_ms(2000);
  //lcd_clear();
  // sprintf(lcd_buffer,"%d",test_eeprom());
   //lcd_goto_xy(4,3);
   //lcd_chr_inv('C');
   //show_t_in_graph();
   //_delay_ms(1000);
     
   //lcd_str(lcd_buffer);	  
   //_delay_ms(2000);   
  //lcd_goto_xy(4,3);	
  //lcd_print_lowbatdegree();
  //_delay_ms(2000);
  /*lcd_goto_xy(1,4);
  lcd_goto_xy(1+i,4);  
  lcd_plot(1,i+1);   
  _delay_ms(2000);
  lcd_clear();    */             
  //set SHTXX sensor resolution for temperature 12 bit and for humidity 8 bit 
  //s_write_statusreg(&value);
  //s_read_statusreg(&value, &checksum);
  
  /*temp_outp=read_ext_eeprom(0x0003);		// load user presets
  press_outp=read_ext_eeprom(0x0004);
  p_corr=read_ext_eeprom(0x0005);
  rh_corr=read_ext_eeprom(0x0006);

  rx_valid_in_loop=250;

  t_ex_hi=-200.0499;
  t_ex_lo=200.0499;*/
  
  while(1)
  { 
   // therm_read_temperature(&t); //measure temperature from DS18B20	
  //  error=0;
   // error+=s_measure((unsigned char*) &humi_val.i,&checksum,HUMI);  //measure humidity
    //error+=s_measure((unsigned char*) &temp_val.i,&checksum,TEMP);  //measure temperature
   // if (error!=0) 
   //   s_connectionreset();                 //in case of an error: connection reset
   // else
   // { 
     // humi_val.f=(float)humi_val.i;                   //converts integer to float
    //  temp_val.f=(float)temp_val.i;                   //converts integer to float
    //  calc_sth11(&humi_val.f,&temp_val.f);            //calculate humidity, temperature
    //  dew_point=calc_dewpoint(humi_val.f,temp_val.f); //calculate dew point      
	  // print temp from SHTXX
	  //sprintf(lcd_buffer,"%+3.1f%c ",(double)temp_val.f, ICON(6));
	//  sprintf(lcd_buffer,"%+3.1f%c %+.1f%c ",(double)temp_val.f, ICON(6), (double)t, ICON(6));
	//  lcd_goto_xy(1,1);
	//  lcd_str(lcd_buffer);	  
	  //print temp from DS18B20 
	  //sprintf(lcd_buffer,"%+d%c ", (int)t, ICON(6)); // lcd_chr('z'+7); -> degree symbol	  
	  //lcd_goto_xy(1,2);	        
	  //lcd_str(lcd_buffer);
	  //print humditiy from SHTXX
	//  sprintf(lcd_buffer,"%3.1f %% RH ",(double)humi_val.f);
   //   lcd_goto_xy(3,2);	  
	//  lcd_str(lcd_buffer); 	  
 //   }
	//vin=readADC(5); //measure pressure ADC5 pin
  //  pressure=press_m(vin); //calculate pressure
	//print pressure from MPX4115
  //  sprintf(lcd_buffer,"%uÍœ‡ %.1f‡ÚÏ ",pressure, (pressure/101.325));
    lcd_goto_xy(2,3);
	lcd_str(lcd_buffer);	
    rtc_get_time(&hour,&min,&sec, &wd);
	rtc_get_date(&date,&month,&year);
	//print time
	sprintf(lcd_buffer, "%u%u:%u%u:%u%u %s", hour/10,hour%10, min/10,min%10, sec/10,sec%10, weekdays[wd-1]);
    lcd_goto_xy(2,5);	  
	lcd_str(lcd_buffer);
	//print date
	//sprintf(lcd_buffer, "%u%u/%u%u/%u%u", date/10,date%10, month/10,month%10, year/10,year%10);
	sprintf(lcd_buffer, "%u%u %s 20%u%u", date/10,date%10, monthes[month-1], year/10,year%10);
    lcd_goto_xy(2,6);	 
	lcd_str(lcd_buffer);        
	
	if (get_key_status(MENU_ENTER_BTN)) //enter
    {  
      if (!get_prev_key_status(MENU_ENTER_BTN))
      {
        lcd_clear();        
        show_main_menu(); 
      }
    }      
    //delay_ms(200);
    //----------wait approx. 0.8s to avoid heating up SHTxx------------------------------      
    //for (i=0;i<40000;i++);     //(be sure that the compiler doesn't eliminate this line!)
    //-----------------------------------------------------------------------------------                       
  }
  return 0;
}