/*****************************************************
Project : Апаратно-програмна система моніторингу метеопараметрів накволишнього середовища 
Version : 
Date    : 2018
Author  : (C) Назар Куровецький                                          
Comments: 
                           
Chip type           : ATmega64
Program type        : Application
Clock frequency     : 16,000000 MHz
Memory model        : Small
External SRAM size  : 0
Data Stack size     : 512
*****************************************************/

#include <avr/io.h> 
#include <util/delay.h>
#include <stdio.h> // стандартна бібліотека вводу/виводу 
#include "lcd_lib.h" // бібліотека роботи з РКД
#include "bmp180_lib.h" // бібліотека роботи з цифровим давачем тиску і температури BMP180
#include "dht22.h" // бібліотека роботи з цифровим давачем вологості і температури DHT22
#include "lm35.h" // бібліотека зчитування значення температури з аналогового давача температури LM35

#define BUTTON_PORT PORTC
#define BUTTON_PIN PINC
#define BUTTON_DDR DDRC

#define MENU_ENTER_BTN_PIN 0
#define SELECT_PLUS_BTN_PIN 1
#define SELECT_MINUS_BTN_PIN 2
#define EXIT_BTN_PIN 3

#define TEMP_UNITS_NUM 3
#define PRESS_UNITS_NUM 3 

unsigned char PREV_BUTTON_PIN = 0xFF;
char lcd_buffer[81];
char temp_unit[] = {'C','F','K'};
char *press_unit[] = {"Pa", "hPa", "mmHg"};
int temp_unit_ind = 0, press_unit_ind = 0; 

unsigned char getBtnStatus(unsigned char BUTTON_ID)
{
	return (!(BUTTON_PIN & (1 << BUTTON_ID)));
}

unsigned char getPrevBtnStatus(unsigned char BUTTON_ID)
{
	return (!(PREV_BUTTON_PIN & (1<< BUTTON_ID)));
}

void setTempUnitFormat(void)
{
 int i, pos_x = 0; //pos_x_max = TEMP_UNITS_NUM * 2;
 char oK = 0;               
 
 LCDclr();
 LCDGotoXY(0,0);
 LCDstring("*Temperature Units*");
 LCDGotoXY(0,1);
 for (i = 0; i < TEMP_UNITS_NUM; i++)
 {
    LCDsendChar(temp_unit[i]);
	LCDsendChar(' ');
 }
 
 while(!oK)
 {
   PREV_BUTTON_PIN = BUTTON_PIN;   
   LCDGotoXY(pos_x, 2);
   LCDsendChar('^');
 
  if (getBtnStatus(SELECT_PLUS_BTN_PIN))
   {
		if (!getPrevBtnStatus(SELECT_PLUS_BTN_PIN))
		{
			LCDGotoXY(pos_x, 2);
            LCDsendChar(' ');
			if (pos_x < (TEMP_UNITS_NUM - 1) * 2)
			  pos_x += 2; 
			else
			  pos_x = 0;			
        }
   }

   if (getBtnStatus(SELECT_MINUS_BTN_PIN))
   {
		if (!getPrevBtnStatus(SELECT_MINUS_BTN_PIN))
        {
            LCDGotoXY(pos_x, 2);
            LCDsendChar(' ');
			if (pos_x < 0)
			  pos_x -= 2; 
			else
			  pos_x = 2*(TEMP_UNITS_NUM - 1);			 
        }
     }

     if (getBtnStatus(MENU_ENTER_BTN_PIN))
     {
       if (!getPrevBtnStatus(MENU_ENTER_BTN_PIN))
       {
          temp_unit_ind = pos_x / 2;
		  return;
       }
     }

     if (getBtnStatus(EXIT_BTN_PIN))
         {
                if(!getPrevBtnStatus(EXIT_BTN_PIN))
                {
                        PREV_BUTTON_PIN = BUTTON_PIN;
                        return;
                }
         }
 }
}

void setPressUnitFormat(void)
{
 int i, pos_x = 0; //pos_x_max = TEMP_UNITS_NUM * 2;
 char oK = 0;               
 
 LCDclr();
 LCDGotoXY(0,0);
 LCDstring("*Pressure Units*");
 LCDGotoXY(0,1);
 for (i = 0; i < PRESS_UNITS_NUM; i++)
 {
    LCDstring(press_unit[i]);
	LCDsendChar(' ');
 }
 
 while(!oK)
 {
   PREV_BUTTON_PIN = BUTTON_PIN;   
   LCDGotoXY(pos_x, 2);
   LCDsendChar('^');
 
  if (getBtnStatus(SELECT_PLUS_BTN_PIN))
   {
		if (!getPrevBtnStatus(SELECT_PLUS_BTN_PIN))
		{
			LCDGotoXY(pos_x, 2);
            LCDsendChar(' ');
			if (pos_x < (PRESS_UNITS_NUM - 1) * 2)
			  pos_x += 2; 
			else
			  pos_x = 0;			
        }
   }

   if (getBtnStatus(SELECT_MINUS_BTN_PIN))
   {
		if (!getPrevBtnStatus(SELECT_MINUS_BTN_PIN))
        {
            LCDGotoXY(pos_x, 2);
            LCDsendChar(' ');
			if (pos_x < 0)
			  pos_x -= 2; 
			else
			  pos_x = 2*(PRESS_UNITS_NUM - 1);			 
        }
     }

     if (getBtnStatus(MENU_ENTER_BTN_PIN))
     {
       if (!getPrevBtnStatus(MENU_ENTER_BTN_PIN))
       {
          press_unit_ind = pos_x / 2;
		  return;
       }
     }

     if (getBtnStatus(EXIT_BTN_PIN))
         {
                if(!getPrevBtnStatus(EXIT_BTN_PIN))
                {
                        PREV_BUTTON_PIN = BUTTON_PIN;
                        return;
                }
         }
 }
} 


void mainMenu(void)
{
  char *menu_items[] = {"Set Tempature Format", "Set Pressure Format", 
    "      Exit      "};
  char menu_title[] = "< Main Menu >"; // Units Conversion
  unsigned char selected = 0;
  
  LCDGotoXY(0,1);
  LCDstring(menu_title);

  while(1)
  {
    PREV_BUTTON_PIN = BUTTON_PIN;
    LCDGotoXY(2,0);
    LCDstring(menu_title);
    LCDGotoXY(0,1);
    LCDstring(menu_items[selected]);
    if(getBtnStatus(SELECT_PLUS_BTN_PIN))
    {
      if(!getPrevBtnStatus(SELECT_PLUS_BTN_PIN))
        if(selected == 5) selected = 0;
        else selected++;
    }

    if(getBtnStatus(SELECT_MINUS_BTN_PIN))
    {
      if (!getPrevBtnStatus(SELECT_MINUS_BTN_PIN))
        if (selected == 0) selected = 5;
        else selected--;
    }

    if(getBtnStatus(MENU_ENTER_BTN_PIN))
		if(!getPrevBtnStatus(MENU_ENTER_BTN_PIN))
		{
			switch(selected)
			{
				case 0: setTempUnitFormat(); break; 
				case 1: setPressUnitFormat(); break;
				case 2: return;				
				default: break;
			}
        LCDclr();
		
      }

    if (getBtnStatus(EXIT_BTN_PIN))
    {
     if (!getPrevBtnStatus(EXIT_BTN_PIN))
     {
       PREV_BUTTON_PIN = BUTTON_PIN;
       return;
     }
    }
  }
}

int main(void)
{
	/* BMP180  */
	int32_t bmp180_temp = 0;
	int32_t bmp180_pressure = 0;
	int16_t bmp180_calib_int16_t[8];
	int16_t bmp180_calib_uint16_t[3];
	uint8_t error_code = 0;
	/* DHT22 */
	struct dht22 dht;
	float dht_temp = 0.0f, dht_hum = 0.0f;
	/* LM35 */
	unsigned int val;
	float lm35_temp;
  
	/* ініціалізація кнопок */
	BUTTON_DDR&=~(1<<MENU_ENTER_BTN_PIN)&~(1<<SELECT_PLUS_BTN_PIN)&~(1<<SELECT_MINUS_BTN_PIN)&~(1<<EXIT_BTN_PIN);
	BUTTON_PORT|=(1<<MENU_ENTER_BTN_PIN)|(1<<SELECT_PLUS_BTN_PIN)|(1<<SELECT_MINUS_BTN_PIN)|(1<<EXIT_BTN_PIN);	
	
	/* ініціалізація АЦП, РКД  */
	initADC();
	LCDinit();
	LCDcursorOFF();  
	/* ініціалізація UART0 */
	//uart_init();
	/* ініціалізація TWI */
	i2cSetBitrate(1000);
	/* ініціалізація давача BMP180 */
	bmp180Calibration(bmp180_calib_int16_t, bmp180_calib_uint16_t, &error_code);
	/* ініціалізація давача DHT22 */
	dht_init(&dht,3);
  
	LCDGotoXY(0,0);    
	LCDstring("Weather Parameters");
	LCDGotoXY(0,1);
	LCDstring("Monitoring System");
	LCDGotoXY(0,2);  
	LCDstring("KNEM-22");
	LCDGotoXY(0,3); 
	LCDstring("Nazar Kurovetskyy");
	_delay_ms(1000);
	LCDclr();	
  
	while(1)
	{	
		bmp180Convert(bmp180_calib_int16_t, bmp180_calib_uint16_t, &bmp180_temp, &bmp180_pressure, &error_code);
		//printf("%ld;%ld;%ld\n", bmp180_temp/10, bmp180_pressure, bmp180CalcAltitude(bmp180_pressure)/10);
		//printf("Temperature: %ld\n", bmp180_temp);
		//printf("Pressure: %ld Pa\n", bmp180_pressure);
		//printf("Altitude: %ld m\n\n", bmp180CalcAltitude(bmp180_pressure)/10);
		sprintf(lcd_buffer,"%+.1f%cC %1.f hPa", (float) bmp180_temp/10, 0xdf, (float) bmp180_pressure * 0.01);
		LCDGotoXY(0,0);    
		LCDstring(lcd_buffer);
		val = readADC(0); //measure temp ADC0 pin from LM35
		lm35_temp = getTemp_lm35(val); 
		sprintf(lcd_buffer,"%ld m %+.1f%cC", bmp180CalcAltitude(bmp180_pressure)/10, lm35_temp, 0xdf);
		LCDGotoXY(0,1);    
		LCDstring(lcd_buffer);
		dht_read_data(&dht, &dht_temp, &dht_hum);
		sprintf(lcd_buffer,"%+.1f%cC %.1f%%", dht_temp, 0xdf,  dht_hum);
		LCDGotoXY(0,2);    
		LCDstring(lcd_buffer);
		_delay_ms(10);
		if (getBtnStatus(MENU_ENTER_BTN_PIN))
          if (!getPrevBtnStatus(MENU_ENTER_BTN_PIN))
          {
            LCDclr();
            mainMenu();
            LCDclr();;
          }
        PREV_BUTTON_PIN = BUTTON_PIN;
	} 
  return 0;
}