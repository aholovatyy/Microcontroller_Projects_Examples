#ifndef _LM35_INCLUDED_
#define _LM35_INCLUDED_

#include <avr/io.h>
#include <util/delay.h>

/*#ifndef F_CPU
	#define F_CPU 8000000UL 		// ������� ��������� ���������� � �� (8 ��� ���)
#endif*/

/*#define REFS0 0
#define ADEN 7
#define ADPS0 0

#define ADSC 6
#define ADIF 4
#define ADC*/

void initADC(void);
unsigned int readADC(unsigned char ch);
getTemp_lm35(unsigned int val);

#endif

