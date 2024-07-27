/*
  DS1307 I2C Bus Real Time Clock functions
*/

#ifndef _DS1307_INCLUDED_
#define _DS1307_INCLUDED_

#include "i2c.h"

#define DS1307_ID    0xD0        // I2C DS1307 Device Identifier
#define DS1307_ADDR  0x00        // I2C DS1307 Device Address

void rtc_init(unsigned char PeriodSelect, unsigned char SQWe, unsigned char OUTlevel); //(unsigned char rs,unsigned char sqwe,unsigned char out);
void rtc_get_time(unsigned char *hour,unsigned char *min,unsigned char *sec, unsigned char *wd);
void rtc_set_time(unsigned char hour, unsigned char min, unsigned char sec, unsigned char wd);
void rtc_get_date(unsigned char *date, unsigned char *month, unsigned char *year);
void rtc_set_date(unsigned char *date, unsigned char *month, unsigned char *year);

#endif