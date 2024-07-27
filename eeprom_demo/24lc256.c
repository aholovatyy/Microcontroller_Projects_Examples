 #include "24lc256.h"
 #include <util/delay.h>

void write_ext_eeprom(unsigned int eeprom_address, char data)
{
    //i2c_start(EEPROM_ID,EEPROM_ADDR,TW_WRITE);
   	i2c_start(0xa0);    
	// Send the High 8-bit of I2C Address
	i2c_write(eeprom_address>>8);
	// Send the Low 8-bit of I2C Address
	i2c_write(eeprom_address);   	
	i2c_write(data);	
	i2c_stop();
	_delay_ms(5);
}

char read_ext_eeprom(unsigned int eeprom_address)
{
    char data;
	
	//i2c_start(EEPROM_ID,EEPROM_ADDR,TW_WRITE);
    i2c_start(0xa0);    
	// Send the High 8-bit of I2C Address
	i2c_write(eeprom_address>>8);	
	 // Send the Low 8-bit of I2C Address
	i2c_write(eeprom_address);
	//i2c_start(EEPROM_ID,EEPROM_ADDR,TW_READ);
    i2c_start(0xa1);    
	data=i2c_read(0);
	i2c_stop();
	return data;
}


void write_float_ext_eeprom(long int n, float data)
{ 
	char i;
	for (i=0; i<4; i++) 
		write_ext_eeprom(i + n, *(&data + i) ) ; 
}


float read_float_ext_eeprom(long int n)
{ 
  char i; 
  float data;
  
  for (i=0; i<4; i++) 
	 *(&data + i) = read_ext_eeprom(i + n);

  return (data); 
}


char test_eeprom(void)
{
/* char buffer[34]=
	{0b00001111,
	 0b11110000,
     0b00000001,
     0b00000011,
     0b00000110,
     0b00001100,
     0b00011001,
     0b00110011,
     0b01100110,
     0b11001100,
     0b10011000,
     0b00110000,
     0b01100000,
     0b11000000,
     0b10000000,
     0b00000000,
     0b00000000,
     0b00000000,
     0b10000000,
     0b11000000,
     0b01100000,
     0b00110000,
     0b10011000,
     0b11001100,
     0b01100110,
     0b00110011,
     0b00011001,
     0b00001100,
     0b00000110,
     0b00000011,
     0b00000001,
     0b00000000,
     0b00000000,
     0b00000000,
    };	*/
  char n[4]={1,2,3,4};
	
  char data=0;//,id1,id2;
  unsigned int dev_address,i;//,idelay;
  
 
	//Set up TWI Module
	//TWBR = 5;
	//TWSR &= (~((1<<TWPS1)|(1<<TWPS0)));

  // Read the EEPROM ID
  dev_address=0;              // Start at Address 0
  //id1=read_ext_eeprom(dev_address);
  //id2=read_ext_eeprom(dev_address+1);
 
  // Write to EEPROM if no ID defined
  //if (id1 != buffer[0] || id2 != buffer[1]) {
    for(i=0;i < 4;i++) {
      write_ext_eeprom((dev_address+i), n[i]);
      _delay_us(1);
    }
	for(i=0;i < 4; i++) { //0 2 4 6
      data=read_ext_eeprom((dev_address+i));
      _delay_us(1);
	 // return data;
    }
  //}   
  //data=0;
  return data;
} 
