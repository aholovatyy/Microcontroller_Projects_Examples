/*
** main.c
**
** Nokia 3310 Example Program
** Target: ATMEGA :: AVR-GCC
**
** Written by Tony Myatt - 2007
** Quantum Torque - www.quantumtorque.com
*/
#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>
#include <avr/pgmspace.h>
#include <stdio.h>
#include "lcd.h"

/* main -- Program starts here */
int main(void)
{	

	DDRD = 0xff;


	// Setup LCD
	lcd_init();
	lcd_contrast(0x40);
	
	// Print on first line
	lcd_goto_xy(1,1);
	lcd_str(" Hello! ");
	
	// Print on second line with custom characters
	lcd_goto_xy(4,2);
//	lcd_chr(ARROW_LEFT);
//	printf(" 2007 ");
//	lcd_chr(ARROW_RIGHT);
	
	while(1){
	
		if (PORTD == 0b11111111) PORTD = 0b00000000;
		else PORTD=0b11111111;
		_delay_ms(1000);

	
	
	}
}
