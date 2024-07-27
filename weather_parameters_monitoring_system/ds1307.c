/*
   Dallas Semiconductors DS1307 I2C Bus Real Time Clock functions
   Written by Andriy Holovatyy - 2010
*/

#include "ds1307.h"

unsigned char bcd2bin(unsigned char x)
{
    return (((x & 0xF0)>>4)*10 + (x & 0x0F));
}

unsigned char bin2bcd(unsigned char x)
{
    return ((x%10) | ((x/10)<<4));
}

void rtc_init(unsigned char PeriodSelect,   // auai? ia?eiaa ia auoiaa OUT
                                            // 0 - 1 ao
                                            // 1 - 4096 ao
                                            // 2 - 8192 ao
                                            // 3 - 32768 ao
              unsigned char SQWe,           // aee??aiea neaiaea ia auoiaa OUT
              unsigned char OUTlevel        // o?iaaiu ia OUT, anee SQWe==0
              )
{
   
	unsigned char temp;
	PeriodSelect &= 3;
    // onoaiaaeeaaai oeaae aey caiene a ?aaeno?
	if (SQWe) PeriodSelect |= 0x10;
	if (OUTlevel) PeriodSelect |= 0x80;
    // auaiaei a oeio
	i2c_start(0xd0);
	i2c_write(7);
	i2c_write(PeriodSelect);
	temp=i2c_read(0);
	i2c_stop();
	//if(temp & (1<<CH))                                  //anee ieoaiea ?ania i?iiaaaei
	//  {
	//rtc_set_date(1,1,9);
	//rtc_set_time(0,0,0,1);
	//}
}

void rtc_set_time(unsigned char hour, unsigned char min, unsigned char sec,unsigned char wd)
{
    i2c_start(0xd0);
    i2c_write(0);
    i2c_write(bin2bcd(sec));
    i2c_write(bin2bcd(min));
    i2c_write(bin2bcd(hour));
    i2c_write(bin2bcd(wd));
	i2c_stop();
}


void rtc_get_time(unsigned char *hour, unsigned char *min,unsigned char *sec, unsigned char *wd)
{
    i2c_start(0xd0);
    i2c_write(0);
    i2c_start(0xd1);	
    *sec = bcd2bin(i2c_read(1));
    *min = bcd2bin(i2c_read(1));
    *hour = bcd2bin(i2c_read(1));   
	*wd = bcd2bin(i2c_read(0)); 	
	i2c_stop();

}

void rtc_get_date(unsigned char *date, unsigned char *month, unsigned char *year)
{
    i2c_start(0xd0);
    i2c_write(4);
    i2c_start(0xd1);    	
	*date=bcd2bin(i2c_read(1));
	*month=bcd2bin(i2c_read(1));
    *year=bcd2bin(i2c_read(0));
	i2c_stop();

}

void rtc_set_date(unsigned char *date,unsigned char *month,unsigned char *year)
{
    i2c_start(0xd0);
    i2c_write(4);
    i2c_write(bin2bcd(*date));
    i2c_write(bin2bcd(*month));
    i2c_write(bin2bcd(*year));
    i2c_stop();
}