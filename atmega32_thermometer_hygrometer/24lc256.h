/*
  24LC256 I2C Bus EEPROM functions
*/

#ifndef _24LC256_INCLUDED_
#define _24LC256_INCLUDED_

#include "i2c.h"

#define EEPROM_ID    0xA0        // I2C 24AA128 EEPROM Device Identifier
#define EEPROM_ADDR  0x00        // I2C 24AA128 EEPROM Device Address

void write_ext_eeprom(unsigned int eeprom_address, char data);
char read_ext_eeprom(unsigned int eeprom_address);
char test_eeprom(void);

void write_float_ext_eeprom(long int n, float data);
float read_float_ext_eeprom(long int n);

#endif