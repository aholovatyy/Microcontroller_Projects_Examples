/*****************************************************
This program was produced by the
CodeWizardAVR V1.25.8 Professional
Automatic Program Generator
© Copyright 1998-2007 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 19.06.2010
Author  : Andriy                          
Company : Home                            
Comments: 


Chip type           : ATmega32
Program type        : Application
Clock frequency     : 4,000000 MHz
Memory model        : Small
External SRAM size  : 0
Data Stack size     : 512
*****************************************************/

#include <mega32.h>
#include <stdio.h>
#include <delay.h>

#asm
    .equ __lcd_port=0x12 //0x1b // порт піключення LCD, PORTA
#endasm

#include <lcd.h> // LCD library
               
#define REFS0 0
#define ADEN 7
#define ADPS0 0

#define ADSC 6
#define ADIF 4
#define ADC

void initADC(void)
{
 ADMUX=(1<<REFS0);  // For Aref=AVcc
 ADCSRA=(1<<ADEN)|(7<<ADPS0);
}                      

unsigned int readADC(unsigned char ch)
{
 //select ADC channel ch must be 0-7
 ch=ch&0b00000111;
 ADMUX|=ch;
 //start single conversion
 ADCSRA|=(1<<ADSC);
 //wait for conversion to complete
 while(!(ADCSRA&(1<<ADIF)));
 //clear ADIF by writing one to it
 ADCSRA|=(1<<ADIF);
 return (ADCW);
}   

unsigned int press_m(unsigned int vin)
{
 float press;
 float vout;
 unsigned int press_out;
 
 vout=vin*0.00488;//0.00494; //voltage in [V]
 press=(vout*22)+10.55; //calculated pressure 22.2
 //press=press*10.0; // kPa->hPa
 press_out=press;
 return press_out;
}

void main(void)
{
  char lcd_buffer[33];
  unsigned int vin, pressure;
  
  initADC();
  //ініціалізація LCD  	
  lcd_init(16); 
  lcd_putsf("MPX4115 Sensor\nDemo");
  delay_ms(1000);

  while (1)
      {
       vin=readADC(3);
       pressure=press_m(vin);
       //sprintf(lcd_buffer,"Press: %u hPa",pressure); // 1 kilopascal (kPa) = 10 hectopascal (hPa)
       sprintf(lcd_buffer,"Press: %u kPa",pressure);
       lcd_clear();
       lcd_puts(lcd_buffer);
       delay_ms(200);  
      };
}
