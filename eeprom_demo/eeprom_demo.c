/************************************************************

A program to demonstrate the use of I2C EEPROM
(24LC256). Here the 24LC256 EEPROM is connected with an
AVR ATmega32 MCU by I2C Serial Bus.

************************************************************/

#include <avr/io.h>
#include <stdio.h>
#include <util/delay.h>

#include "i2c.h"
#include "lcd_lib.h"
#include "24lc256.h"

int main(void)
{
	//char buffer[10]={0, 1, 2, 3, 4, 5, 6, 7, 8, 9};
	char lcd_buffer[33];
	uint8_t data;
	unsigned int dev_address=0x00, address=0;
	
	i2c_init();
	
	LCDinit(); 
	LCDcursorOFF();
	LCDclr();
	LCDstring("EEPROM Demo\n24LC256");
	_delay_ms(1000);
	//LCDclr();
	
	/*data=read_ext_eeprom(dev_address);
	LCDsendChar(48+data);
	LCDsendChar(' ');	
	_delay_ms(50);	
	data=read_ext_eeprom(dev_address+1);
	LCDsendChar(48+data);	
	
	LCDclr();
	LCDGotoXY(0,0);
	LCDstring("Writting 24LC256");	
	for(i=0; i<10; i++) 
	{
      write_ext_eeprom((dev_address+i), buffer[i]);      
	  LCDGotoXY(0,1);
	  LCDsendChar(48+buffer[i]);
	  _delay_ms(300);
    }*/
	LCDclr();
	LCDGotoXY(0,0);
	LCDstring("Reading 24LC256");
	_delay_ms(1000);	
	LCDclr();	
	for(address=0; address<32768; address++) // 0x7FFF+1
	{ 
      data=read_ext_eeprom((dev_address+address));
      LCDGotoXY(0,0);
	  sprintf(lcd_buffer,"address: 0x%X\ndata: %u ", (dev_address+address), data);  
	  //LCDstring("Wrote:");
	  //LCDsendChar(48+buffer[i]);
	  //LCDsendChar(' ');	  
	  LCDstring(lcd_buffer);
	  _delay_ms(100);	 
    }
	
	while (1);
	
    return 0;	
}
