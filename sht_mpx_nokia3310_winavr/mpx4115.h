#ifndef _MPX_INCLUDED_
#define _MPX_INCLUDED_

#include <avr/io.h>
#include <util/delay.h>

/*#ifndef F_CPU
	#define F_CPU 8000000UL 		// частота тактового генератора в √ц (8 ћ√ц тут)
#endif*/

/*#define REFS0 0
#define ADEN 7
#define ADPS0 0

#define ADSC 6
#define ADIF 4
#define ADC*/

void initADC(void);
unsigned int readADC(unsigned char ch);
unsigned int press_m(unsigned int vin);

#endif

