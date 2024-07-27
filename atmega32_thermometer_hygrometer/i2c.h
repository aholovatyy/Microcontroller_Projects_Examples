#ifndef _I2C_INCLUDED_
#define _I2C_INCLUDED_

#include <avr/io.h>
#include <util/twi.h>

#ifndef F_CPU
	#define F_CPU 8000000UL 	//system clock frequency 8 MHz
#endif

#define MR_DATA_ACK 0x50
#define MR_DATA_NAK 0x58
#define ACK_i2c 0x01
#define NAK_i2c 0x00
#define SCL_CLOCK  100000L

void i2c_init(void);
//unsigned char i2c_start(unsigned int dev_id, unsigned int dev_addr, unsigned char rw_type);
unsigned char i2c_start(unsigned char address);
void i2c_start_wait(unsigned char address);
//unsigned char i2c_rep_start(unsigned int dev_id, unsigned int dev_addr, unsigned char rw_type);
unsigned char i2c_rep_start(unsigned char address);
void i2c_stop(void);
unsigned char i2c_write(unsigned char data);
unsigned char i2c_read(unsigned char acknak);

#endif