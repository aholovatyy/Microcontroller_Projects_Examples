/***********************************************************************************
Project:    LM35 - бібліотека
Filename:   LM35.c
Processor:  AVR family
Author:     (C) Назар Куровецький
***********************************************************************************/

#include "lm35.h"
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

float getTemp_lm35(unsigned int val)
{
 float temp;
 float vout;
 
 vout = (float) val*4.88;//0.00494; //voltage in [V]
 temp = (vout/10.00); //calculated temperature in celsius
 return temp;
}