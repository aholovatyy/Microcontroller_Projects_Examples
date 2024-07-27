/***********************************************************************************
Project:          MPX4115 library
Filename:         mpx4115.c
Processor:        AVR family
Author:           (C) Andriy Holovatyy
***********************************************************************************/

#include "mpx4115.h"
#include <math.h>   //math library  

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
 return (ADC);
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