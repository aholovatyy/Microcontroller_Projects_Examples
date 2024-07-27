//*****************************************************************************
//
// File Name	: 'lcd_lib.c'
// Title		: 4 bit LCd interface
// Author		: Scienceprog.com - Copyright (C) 2007
// Created		: 2007-06-18
// Revised		: 2007-06-18
// Version		: 1.0
// Target MCU	: Atmel AVR series
//
// This code is distributed under the GNU Public License
//		which can be found at http://www.gnu.org/licenses/gpl.txt
//
//*****************************************************************************
#include "lcd_lib.h"
#include <inttypes.h>
#include <avr/io.h>
#include <avr/pgmspace.h>
#include <avr/eeprom.h>
#include <util/delay.h>

//#define F_CPU 8000000UL 


// Code Table 1251
uint16_t /*EEMEM*/ TabWin[256] = {
	0xc8, 0xc9, 0xca, 0xcb, 0xcc, 0xcd, 0xce, 0xcf,   // псевдографика
	0xd0, 0xd1, 0xd2, 0xd3, 0xd4, 0xd5, 0xd6, 0xd7,   // псевдографика
	0xd8, 0xd9, 0xda, 0xdb, 0xdc, 0xdd, 0xde, 0xdf,   // псевдографика
	0xe7, 0xe8, 0xe9, 0xea, 0xeb, 0xec, 0xed, 0xee,   // псевдографика
	0xef, 0xf0, 0xf1, 0xf2, 0xf3, 0xf4, 0xf5, 0xf6,   // псевдографика
	0xa2, 0xf7, 0xf8, 0xf9, 0xfa, 0xfb, 0xfc, 0xfd,   // Ё    псевдографика
	0xfe, 0xff, 0xe7, 0xe8, 0xe9, 0xea, 0xeb, 0xec,   // псевдографика
	0xb5, 0xee, 0xef, 0xf0, 0xf1, 0xf2, 0xfd, 0xff,   // ё    псевдографика
	0x41, 0xa0, 0x42, 0xa1, 0xe0, 0x45, 0xa3, 0xa4,   // АБВГДЕЖЗ
	0xa5, 0xa6, 0x4b, 0xa7, 0x4d, 0x48, 0x4f, 0xa8,   // ИЙКЛМНОП
	0x50, 0x43, 0x54, 0xa9, 0xaa, 0x58, 0xe1, 0xab,   // РСТУФХЦЧ
	0xac, 0xe2, 0xad, 0xae, 0x62, 0xaf, 0xb0, 0xb1,   // ШЩЪЫЬЭЮЯ
	0x61, 0xb2, 0xb3, 0xb4, 0xe3, 0x65, 0xb6, 0xb7,   // абвгдежз
	0xb8, 0xb9, 0xba, 0xbb, 0xbc, 0xbd, 0x6f, 0xbe,   // ийклмноп
	0x70, 0x63, 0xbf, 0x79, 0xe4, 0x78, 0xe5, 0xc0,   // рстуфхцч
	0xc1, 0xe6, 0xc2, 0xc3, 0xc4, 0xc5, 0xc6, 0xc7    // шщъыьэюя
};

char ANSI1251_CO_FF [] =
{
   0x41,       //код 0xC0, символ 'А'
   0xA0,       //код 0xC1, символ 'Б'
   0x42,       //код 0xC2, символ 'В'
   0xA1,       //код 0xC3, символ 'Г'
   0xE0,       //код 0xC4, символ 'Д'
   0x45,       //код 0xC5, символ 'Е'
   0xA3,       //код 0xC6, символ 'Ж'
   0xA4,       //код 0xC7, символ 'З'
   0xA5,       //код 0xC8, символ 'И'
   0xA6,       //код 0xC9, символ 'Й'
   0x4B,       //код 0xCA, символ 'К'
   0xA7,       //код 0xCB, символ 'Л'
   0x4D,       //код 0xCC, символ 'М'
   0x48,       //код 0xCD, символ 'Н'
   0x4F,       //код 0xCE, символ 'О'
   0xA8,       //код 0xCF, символ 'П'
   0x50,       //код 0xD0, символ 'Р'
   0x43,       //код 0xD1, символ 'С'
   0x54,       //код 0xD2, символ 'Т'
   0xA9,       //код 0xD3, символ 'У'
   0xAA,       //код 0xD4, символ 'Ф'
   0x58,       //код 0xD5, символ 'Х'
   0xE1,       //код 0xD6, символ 'Ц'
   0xAB,       //код 0xD7, символ 'Ч'
   0xAC,       //код 0xD8, символ 'Ш'
   0xE2,       //код 0xD9, символ 'Щ'
   0xAD,       //код 0xDA, символ 'Ъ'
   0xAE,       //код 0xDB, символ 'Ы'
   0x62,       //код 0xDC, символ 'Ь'
   0xAF,       //код 0xDD, символ 'Э'
   0xB0,       //код 0xDE, символ 'Ю'
   0xB1,       //код 0xDF, символ 'Я'
   0x61,       //код 0xE0, символ 'а'
   0xB2,       //код 0xE1, символ 'б'
   0xB3,       //код 0xE2, символ 'в'
   0xB4,       //код 0xE3, символ 'г'
   0xE3,       //код 0xE4, символ 'д'
   0x65,       //код 0xE5, символ 'е'
   0xB6,       //код 0xE6, символ 'ж'
   0xB7,       //код 0xE7, символ 'з'
   0xB8,       //код 0xE8, символ 'и'
   0xB9,       //код 0xE9, символ 'й'
   0xBA,       //код 0xEA, символ 'к'
   0xBB,       //код 0xEB, символ 'л'
   0xBC,       //код 0xEC, символ 'м'
   0xBD,       //код 0xED, символ 'н'
   0x6F,       //код 0xEE, символ 'о'
   0xBE,       //код 0xEF, символ 'п'
   0x70,       //код 0xF0, символ 'р'
   0x63,       //код 0xF1, символ 'с'
   0xBF,       //код 0xF2, символ 'т'
   0x79,       //код 0xF3, символ 'у'
   0xE4,       //код 0xF4, символ 'ф'
   0x78,       //код 0xF5, символ 'х'
   0xE5,       //код 0xF6, символ 'ц'
   0xC0,       //код 0xF7, символ 'ч'
   0xC1,       //код 0xF8, символ 'ш'
   0xE6,       //код 0xF9, символ 'щ'
   0xC2,       //код 0xFA, символ 'ъ'
   0xC3,       //код 0xFB, символ 'ы'
   0xC4,       //код 0xFC, символ 'ь'
   0xC5,       //код 0xFD, символ 'э'
   0xC6,       //код 0xFE, символ 'ю'
   0xC7        //код 0xFF, символ 'я'
};

/*void _delay_loop_2(uint16_t __count)
{
	__asm__ volatile (
		"1: sbiw %0,1" "\n\t"
		"brne 1b"
		: "=w" (__count)
		: "0" (__count)
	);
}

void _delay_ms(double __ms)
{
	uint16_t __ticks;
	double __tmp = ((F_CPU) / 4e3) * __ms;
	if (__tmp < 1.0)
		__ticks = 1;
	else if (__tmp > 65535)
	{
		//	__ticks = requested delay in 1/10 ms
		__ticks = (uint16_t) (__ms * 10.0);
		while(__ticks)
		{
			// wait 1/10 ms
			_delay_loop_2(((F_CPU) / 4e3) / 10);
			__ticks --;
		}
		return;
	}
	else
		__ticks = (uint16_t)__tmp;
	_delay_loop_2(__ticks);
}
*/
uint8_t LCDstrLen(char *s)
{
	uint8_t i=0;
	while (s[i]!='\0') i++;
	return i;
}

void LCDsendChar(uint8_t ch)		//Sends Char to LCD
{
	//ch=(ch&0b00001111);
	//ch=~ch;
	LDP=(ch&0b11110000);
	LCP|=1<<LCD_RS;
	LCP|=1<<LCD_E;		
	_delay_ms(1);
	LCP&=~(1<<LCD_E);	
	LCP&=~(1<<LCD_RS);
	_delay_ms(1);
	LDP=((ch&0b00001111)<<4);
	LCP|=1<<LCD_RS;
	LCP|=1<<LCD_E;		
	_delay_ms(1);
	LCP&=~(1<<LCD_E);	
	LCP&=~(1<<LCD_RS);
	_delay_ms(1);
}
void LCDsendCommand(uint8_t cmd)	//Sends Command to LCD
{
	LDP=(cmd&0b11110000);
	LCP|=1<<LCD_E;		
	_delay_ms(1);
	LCP&=~(1<<LCD_E);
	_delay_ms(1);
	LDP=((cmd&0b00001111)<<4);	
	LCP|=1<<LCD_E;		
	_delay_ms(1);
	LCP&=~(1<<LCD_E);
	_delay_ms(1);
}
void LCDinit(void)//Initializes LCD
{
	_delay_ms(15);
	LDP=0x00;
	LCP=0x00;
	LDDR|=1<<LCD_D7|1<<LCD_D6|1<<LCD_D5|1<<LCD_D4;
	LCDR|=1<<LCD_E|1<<LCD_RW|1<<LCD_RS;
   //---------one------
	LDP=0<<LCD_D7|0<<LCD_D6|1<<LCD_D5|1<<LCD_D4; //4 bit mode
	LCP|=1<<LCD_E|0<<LCD_RW|0<<LCD_RS;		
	_delay_ms(1);
	LCP&=~(1<<LCD_E);
	_delay_ms(1);
	//-----------two-----------
	LDP=0<<LCD_D7|0<<LCD_D6|1<<LCD_D5|1<<LCD_D4; //4 bit mode
	LCP|=1<<LCD_E|0<<LCD_RW|0<<LCD_RS;		
	_delay_ms(1);
	LCP&=~(1<<LCD_E);
	_delay_ms(1);
	//-------three-------------
	LDP=0<<LCD_D7|0<<LCD_D6|1<<LCD_D5|0<<LCD_D4; //4 bit mode
	LCP|=1<<LCD_E|0<<LCD_RW|0<<LCD_RS;		
	_delay_ms(1);
	LCP&=~(1<<LCD_E);
	_delay_ms(1);
	//--------4 bit--dual line---------------
	LCDsendCommand(0b00101000);
   //-----increment address, cursor shift------
	LCDsendCommand(0b00001110);


}			
void LCDclr(void)				//Clears LCD
{
	LCDsendCommand(1<<LCD_CLR);
}
void LCDhome(void)			//LCD cursor home
{
	LCDsendCommand(1<<LCD_HOME);
}

/*void LCDstring(char* data)	//Outputs string to LCD
{
	register uint8_t i; 
	uint8_t len;

	// check to make sure we have a good pointer
	if (!data) return;
	
	len = LCDstrLen(data);

	// print data
	for(i=0; i<len; i++)
	{
		if (data[i]=='\n') LCDGotoXY(0,1);
		else LCDsendChar(data[i]);
	}
}*/

/*void LCDstring(char* data)	//Outputs string to LCD
{
	register uint8_t i=0; 
	
	// check to make sure we have a good pointer
	if (!data) return;
	
	// print data
	while (data[i]!='\0') 
	{
		if (data[i]=='\n') LCDGotoXY(0,1);
		else LCDsendChar(data[i]);
        i++;	 
	}	
	while(i++<33) LCDsendChar(' ');
}*/

void LCDstring(char* data)	//Outputs string to LCD
{
	register uint8_t i=0;//, j=0; 
//	uint8_t nline=0;
	
	// check to make sure we have a good pointer
	if (!data) return;
	
	// print data
	while (data[i] != '\0') 
	{
		/*if (data[i] == '\n') 
		  LCDGotoXY(0,1);
		else 
		{
			/*if(data[i] >= 0x80)		// якщо символ не латинський то,
		    {
		      data[i] -= 0x80;        // зменшуємо таблицю
		      data[i] = TabWin[i]; //eeprom_read_word(&TabWin[i]);     // перекодовуємо 
			}*/
			
			
			//LCDsendChar(data[i]);
		//}
		
		if (data[i] < 0xC0)
        {
          LCDsendChar(data[i]);
        }
        else
        {
          LCDsendChar(ANSI1251_CO_FF[(unsigned char)(data[i])-0xC0]);
        }
		
		i++;
    }	
}

void LCDGotoXY(uint8_t x, uint8_t y)	//Cursor to X Y position
{
	register uint8_t DDRAMAddr;
	// remap lines into proper order
	switch(y)
	{
	case 0: DDRAMAddr = LCD_LINE0_DDRAMADDR+x; break;
	case 1: DDRAMAddr = LCD_LINE1_DDRAMADDR+x; break;
	case 2: DDRAMAddr = LCD_LINE2_DDRAMADDR+x; break;
	case 3: DDRAMAddr = LCD_LINE3_DDRAMADDR+x; break;
	default: DDRAMAddr = LCD_LINE0_DDRAMADDR+x;
	}
	// set data address
	LCDsendCommand(1<<LCD_DDRAM | DDRAMAddr);
	
}
//Copies string from flash memory to LCD at x y position
//const uint8_t welcomeln1[] PROGMEM="AVR LCD DEMO\0";
//CopyStringtoLCD(welcomeln1, 3, 1);	
void CopyStringtoLCD(const uint8_t *FlashLoc, uint8_t x, uint8_t y)
{
	uint8_t i;
	LCDGotoXY(x,y);
	for(i=0;(uint8_t)pgm_read_byte(&FlashLoc[i]);i++)
	{
		LCDsendChar((uint8_t)pgm_read_byte(&FlashLoc[i]));
	}
}
//defines char symbol in CGRAM
/*
const uint8_t backslash[] PROGMEM= 
{
0b00000000,//back slash
0b00010000,
0b00001000,
0b00000100,
0b00000010,
0b00000001,
0b00000000,
0b00000000
};
LCDdefinechar(backslash,0);
*/
void LCDdefinechar(const uint8_t *pc,uint8_t char_code){
	uint8_t a, pcc;
	uint16_t i;
	a=(char_code<<3)|0x40;
	for (i=0; i<8; i++){
		pcc=pgm_read_byte(&pc[i]);
		LCDsendCommand(a++);
		LCDsendChar(pcc);
		}
}

void LCDshiftLeft(uint8_t n)	//Scrol n of characters Right
{
	for (uint8_t i=0;i<n;i++)
	{
		LCDsendCommand(0x1E);
	}
}
void LCDshiftRight(uint8_t n)	//Scrol n of characters Left
{
	for (uint8_t i=0;i<n;i++)
	{
		LCDsendCommand(0x18);
	}
}
void LCDcursorOn(void) //displays LCD cursor
{
	LCDsendCommand(0x0E);
}
void LCDcursorOnBlink(void)	//displays LCD blinking cursor
{
	LCDsendCommand(0x0F);
}
void LCDcursorOFF(void)	//turns OFF cursor
{
	LCDsendCommand(0x0C);
}
void LCDblank(void)		//blanks LCD
{
	LCDsendCommand(0x08);
}
void LCDvisible(void)		//Shows LCD
{
	LCDsendCommand(0x0C);
}
void LCDcursorLeft(uint8_t n)	//Moves cursor by n poisitions left
{
	for (uint8_t i=0;i<n;i++)
	{
		LCDsendCommand(0x10);
	}
}
void LCDcursorRight(uint8_t n)	//Moves cursor by n poisitions left
{
	for (uint8_t i=0;i<n;i++)
	{
		LCDsendCommand(0x14);
	}
}

void LCDWriteInt(int val,unsigned int field_length)
{
	/***************************************************************
	This function writes a integer type value to LCD module

	Arguments:
	1)int val	: Value to print

	2)unsigned int field_length :total length of field in which the value is printed
	must be between 1-5 if it is -1 the field length is no of digits in the val

	****************************************************************/

	char str[5]={0,0,0,0,0};
	int i=4,j=0;
	while(val)
	{
	str[i]=val%10;
	val=val/10;
	i--;
	}
	if(field_length==-1)
		while(str[j]==0) j++;
	else
		j=5-field_length;

	if(val<0) LCDsendChar('-');
	for(i=j;i<5;i++)
	{
	  LCDsendChar(48+str[i]);
	}
}

