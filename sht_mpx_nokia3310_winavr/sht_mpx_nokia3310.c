/*****************************************************
Project : SHT_MPX_NOKIA3310 DEMO
Version : 
Date    : 19.06.2010
Author  : (C) Andriy                                                      
Comments: 
                           
Chip type           : ATmega32
Program type        : Application
Clock frequency     : 4,000000 MHz
Memory model        : Small
External SRAM size  : 0
Data Stack size     : 512
*****************************************************/

#include <avr/io.h> 
#include <avr/interrupt.h>
//#include <avr/iom32.h>
#include <stdio.h> //input/output library  
#include "shtxx.h" //SHTXX temperature & humidity sensor library
#include "mpx4115.h" //MPX4115 pressure sensor library
#include "therm_ds18b20.h" // DS18B20 temperature sensor library
#include "nokia_lcd.h" // NOKIA3310 LCD library

int main(void)
{
  //----------------------------------------------------------------------------------
  // sample program that shows how to use SHT11 functions
  // 1. connection reset 
  // 2. measure humidity [ticks](12 bit) and temperature [ticks](14 bit)
  // 3. calculate humidity [%RH] and temperature [°C]
  // 4. calculate dew point [°C]
  // 5. print temperature, humidity, dew point  
   
  value humi_val,temp_val;
  float t=0,dew_point=0;
  unsigned char error,checksum,value=1;
//  unsigned int i;
  char lcd_buffer[33];
  unsigned int vin, pressure;
  
  initADC();
  sht_init();  
  s_connectionreset();
  therm_init(-55, 125, THERM_9BIT_RES);    
  //LCD initialization 	
  lcd_init();
  lcd_contrast(0x40);
  // Print on first line
  lcd_goto_xy(1,3);	
  lcd_str("SHTX & MPX4115");
  lcd_goto_xy(2,4);	
  lcd_str("Sensors Demo");  
  _delay_ms(2000);
  lcd_clear();             
  //set SHTXX sensor resolution for temperature 12 bit and for humidity 8 bit 
  s_write_statusreg(&value);
  s_read_statusreg(&value, &checksum);
  lcd_goto_xy(3,2);	
  lcd_str("status_reg:"); 
  sprintf(lcd_buffer,"0x%X",value);
  lcd_goto_xy(3,3);	
  lcd_str(lcd_buffer);
  
  lcd_goto_xy(3,4);	
  lcd_str("checksum:"); 
  sprintf(lcd_buffer,"0x%X",checksum);
  lcd_goto_xy(3,5);	
  lcd_str(lcd_buffer); 
  _delay_ms(2000); 
  lcd_clear();
  while(1)
  { 
    error=0;
    error+=s_measure((unsigned char*) &humi_val.i,&checksum,HUMI);  //measure humidity
    error+=s_measure((unsigned char*) &temp_val.i,&checksum,TEMP);  //measure temperature
    vin=readADC(5); //measure pressure ADC5 pin
    pressure=press_m(vin); //calculate pressure
	therm_read_temperature(&t); //measure temperature from DS18B20
    if (error!=0) 
      s_connectionreset();                 //in case of an error: connection reset
    else
    { 
      humi_val.f=(float)humi_val.i;                   //converts integer to float
      temp_val.f=(float)temp_val.i;                   //converts integer to float
      calc_sth11(&humi_val.f,&temp_val.f);            //calculate humidity, temperature
      dew_point=calc_dewpoint(humi_val.f,temp_val.f); //calculate dew point
      //sprintf(lcd_buffer,"Press: %u hPa",pressure); // 1 kilopascal (kPa) = 10 hectopascal (hPa)
      //sprintf(lcd_buffer,"Press: %u kPa",pressure);     
      //lcd_clear_line(1);
	  lcd_goto_xy(3,1);
	  lcd_str("Temperature");	  
	  sprintf(lcd_buffer,"%+3.1f%cC %+d%cC ",(double)temp_val.f, ICON(6), (int)t, ICON(6)); // lcd_chr('z'+7); -> degree symbol
	  //lcd_clear_line(2);
      lcd_goto_xy(1,2);	  
      lcd_str(lcd_buffer);
	  //nokia_printstr(lcd_buffer);
	  /*sprintf(lcd_buffer,"%+3.1f %cC   ",(double)temp_val.f, 'z'+7);
	  lcd_goto_xy(5,2);	  
      lcd_str(lcd_buffer);*/
	  
	  //lcd_clear_line(3);
	  lcd_goto_xy(4,3);
	  lcd_str("Humidity");	  
	  sprintf(lcd_buffer,"%3.1f %%  ",(double)humi_val.f);
      //lcd_clear_line(4);
	  lcd_goto_xy(5,4);
      lcd_str(lcd_buffer);
	  lcd_goto_xy(4,5);
	  //lcd_clear_line(5);
      lcd_str("Pressure");
      sprintf(lcd_buffer,"%u kPa  ",pressure);
      lcd_goto_xy(5,6);
	  //lcd_clear_line(6);
      lcd_str(lcd_buffer);       
    }
    //delay_ms(800);
    //----------wait approx. 0.8s to avoid heating up SHTxx------------------------------      
    //for (i=0;i<40000;i++);     //(be sure that the compiler doesn't eliminate this line!)
    //-----------------------------------------------------------------------------------                       
  }
  return 0;
}