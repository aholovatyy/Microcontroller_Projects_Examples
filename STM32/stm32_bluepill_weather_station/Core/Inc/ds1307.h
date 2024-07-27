/* An STM32 HAL library written for the DS1307 real-time clock IC. */
/* Library by @eepj www.github.com/eepj */
#ifndef __DS1307_STM32_H
#define __DS1307_STM32_H
#include "main.h"
/*----------------------------------------------------------------------------*/
#define DS1307_I2C_ADDR 	0x68
#define DS1307_REG_SECOND 	0x00
#define DS1307_REG_MINUTE 	0x01
#define DS1307_REG_HOUR  	0x02
#define DS1307_REG_DOW    	0x03
#define DS1307_REG_DATE   	0x04
#define DS1307_REG_MONTH  	0x05
#define DS1307_REG_YEAR   	0x06
#define DS1307_REG_CONTROL 	0x07
#define DS1307_REG_UTC_HR	0x08
#define DS1307_REG_UTC_MIN	0x09
#define DS1307_REG_CENT    	0x10
#define DS1307_REG_RAM   	0x11
#define DS1307_TIMEOUT		1000
/*----------------------------------------------------------------------------*/
extern I2C_HandleTypeDef *_ds1307_ui2c;

typedef enum DS1307_Rate{
	DS1307_1HZ, DS1307_4096HZ, DS1307_8192HZ, DS1307_32768HZ
} DS1307_Rate;

typedef enum DS1307_SquareWaveEnable{
	DS1307_DISABLED, DS1307_ENABLED
} DS1307_SquareWaveEnable;

void ds1307_init(I2C_HandleTypeDef *hi2c);

void ds1307_set_clock_halt(uint8_t halt);
uint8_t ds1307_get_clock_halt(void);


void ds1307_set_reg_byte(uint8_t regAddr, uint8_t val);
uint8_t ds1307_get_reg_byte(uint8_t regAddr);

void ds1307_set_enable_square_wave(DS1307_SquareWaveEnable mode);
void ds1307_set_interrupt_rate(DS1307_Rate rate);

uint8_t ds1307_get_day_of_week(void);
uint8_t ds1307_get_date(void);
uint8_t ds1307_get_month(void);
uint16_t ds1307_get_year(void);

uint8_t ds1307_get_hour(void);
uint8_t ds1307_get_minute(void);
uint8_t ds1307_get_second(void);
int8_t ds1307_get_time_zone_hour(void);
uint8_t ds1307_get_time_zone_min(void);

void ds1307_set_day_of_week(uint8_t dow);
void ds1307_set_date(uint8_t date);
void ds1307_set_month(uint8_t month);
void ds1307_set_year(uint16_t year);

void ds1307_set_hour(uint8_t hour_24mode);
void ds1307_set_minute(uint8_t minute);
void ds1307_set_second(uint8_t second);
void ds1307_set_time_zone(int8_t hr, uint8_t min);

uint8_t ds1307_decode_BCD(uint8_t bin);
uint8_t ds1307_encode_BCD(uint8_t dec);

#endif
