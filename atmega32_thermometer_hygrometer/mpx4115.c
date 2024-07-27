/***********************************************************************************
Project:          MPX4115 library
Filename:         mpx4115.c
Processor:        AVR family
***********************************************************************************/

#include "mpx4115.h"
#include <math.h>   //math бібліотека 

void initADC(void)
{
 ADMUX=(1<<REFS0);  // для Aref=AVcc
 ADCSRA=(1<<ADEN)|(7<<ADPS0);
}                      

unsigned int readADC(unsigned char ch)
{
 //вибрати канал АЦП ch має бути 0-7
 ch=ch&0b00000111;
 ADMUX|=ch;
 //почати перетворення
 ADCSRA|=(1<<ADSC);
 //чекати на завершення перетворення
 while(!(ADCSRA&(1<<ADIF)));
 //очистит ADIF записавши в нього 1
 ADCSRA|=(1<<ADIF);
 return (ADC);
}   

unsigned int press_m(unsigned int vin)
{
 float press;
 float vout;
 unsigned int press_out;
 
 vout=vin*0.00488;//0.00494; //напруга в [V]
 press=(vout*22)+10.55; //обчислення значення тиску 22.2
 //press=press*10.0; // kPa->hPa перетворення кПа в гПа
 press_out=press;
 return press_out;
}