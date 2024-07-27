/***********************************************************************************
Project:          SHTxx library
Filename:         shtxx.c
Processor:        AVR family
Author:           (C) Andriy Holovatyy
***********************************************************************************/

#if (ARDUINO >= 100)
#include <Arduino.h>
#else
#include <WProgram.h>
#endif

#include "shtxx.h"
//#include <math.h>   //math library  

/* ��������� ��� ���������� ����������� � �������� */                                    
//const float C1=-4.0;              // for 12 Bit
//const float C2=+0.0405;           // for 12 Bit
//const float C3=-0.0000028;        // for 12 Bit
  
/*const float C1=-2.0468;           // for 12 Bit
const float C2=+0.0367;           // for 12 Bit
const float C3=-0.0000015955;     // for 12 Bit 
       
const float T1=+0.01;             // for 14 Bit @ 5V
const float T2=+0.00008;           // for 14 Bit @ 5V
  
*/

const float C1=-2.0468;           // for 8 Bit
const float C2=+0.5872;           // for 8 Bit
const float C3=-0.00040845;       // for 8 Bit 
       
const float T1=+0.01;             // for 12 Bit @ 5V
const float T2=+0.00128;          // for 12 Bit @ 5V

void sht_init(void)
{
  //SHT_PORT=0x00;
  //SHT_DDR=1<<SHT_SCK;   
  pinMode(SHT_SCK_PIN, OUTPUT);
  digitalWrite(SHT_SCK_PIN, LOW);
}  

//----------------------------------------------------------------------------------
char s_write_byte(unsigned char value)
//----------------------------------------------------------------------------------
// writes a byte on the Sensibus and checks the acknowledge 
{ 
  unsigned char i,error=0;  
  SHT_OUTPUT_MODE();    
  for (i=0x80;i>0;i/=2)             //shift bit for masking
  { 
    if (i & value) SHT_DATA_HIGH(); //masking value with i , write to SENSI-BUS
    else 
     SHT_DATA_LOW();
    delayMicroseconds(1);                             
    SHT_SCK_HIGH(); //clk for SENSI-BUS
	delayMicroseconds(5);    //pulswith approx. 5 us  	   
    SHT_SCK_LOW();
  }
  SHT_INPUT_MODE(); //release DATA-line    
  delayMicroseconds(1);
  SHT_SCK_HIGH(); //clk #9 for ack 
  delayMicroseconds(1);
  //error=(SHT_PIN&(1<<SHT_DATA));   //check ack (DATA will be pulled down by SHT11)
  error = digitalRead(SHT_DATA_PIN);                       //check ack (DATA will be pulled down by SHT11)
  SHT_SCK_LOW();
  delayMicroseconds(1);
  return error;                     //error=1 in case of no acknowledge
}

//----------------------------------------------------------------------------------
char s_read_byte(unsigned char ack)
//----------------------------------------------------------------------------------
// reads a byte form the Sensibus and gives an acknowledge in case of "ack=1" 
{ 
  unsigned char i,val=0;
  SHT_INPUT_MODE(); //release DATA-line
  for (i=0x80;i>0;i/=2)  //shift bit for masking
  { 
    SHT_SCK_HIGH();    //clk for SENSI-BUS
	delayMicroseconds(1);
    //if ((SHT_PIN & (1<<SHT_DATA))) val=(val | i);        //read bit  
	if (digitalRead(SHT_DATA_PIN)) val = (val | i);      //read bit  
    SHT_SCK_LOW();   
	delayMicroseconds(1);
  }   
  if (ack) //in case of "ack==1" pull down DATA-Line
  {
   SHT_OUTPUT_MODE();   
   SHT_DATA_LOW();
   delayMicroseconds(1);
  }
  SHT_SCK_HIGH();        //clk #9 for ack
  delayMicroseconds(5);  //pulswith approx. 5 us 
  SHT_SCK_LOW(); 
  delayMicroseconds(1);
  SHT_INPUT_MODE(); //release DATA-line
  return val;
}

//----------------------------------------------------------------------------------
void s_transstart(void)
//----------------------------------------------------------------------------------
// generates a transmission start 
//       _____         ________
// DATA:      |_______|
//           ___     ___
// SCK : ___|   |___|   |______
{                
  //Initial state
  SHT_OUTPUT_MODE(); 
  SHT_DATA_HIGH();
  SHT_SCK_LOW(); 
  delayMicroseconds(1);
 
  SHT_SCK_HIGH(); 
  delayMicroseconds(1);
  
  SHT_DATA_LOW();
  delayMicroseconds(1);
   
  SHT_SCK_LOW();
  delayMicroseconds(5);
   
  SHT_SCK_HIGH();
  delayMicroseconds(1);
   
  SHT_DATA_HIGH();
  delayMicroseconds(1);
  SHT_SCK_LOW();
  delayMicroseconds(1);
}

//----------------------------------------------------------------------------------
void s_connectionreset(void)
//----------------------------------------------------------------------------------
// communication reset: DATA-line=1 and at least 9 SCK cycles followed by transstart
//       _____________________________________________________         ________
// DATA:                                                      |_______|
//          _    _    _    _    _    _    _    _    _        ___     ___
// SCK : __| |__| |__| |__| |__| |__| |__| |__| |__| |______|   |___|   |______
{  
  unsigned char i; 
  //Initial state
  SHT_OUTPUT_MODE(); 
  SHT_DATA_HIGH();
  SHT_SCK_LOW(); 
  delayMicroseconds(1);
  for(i=0;i<9;i++)                  //9 SCK cycles
  { 
    SHT_SCK_HIGH();
	delayMicroseconds(1);
    SHT_SCK_LOW();  
	delayMicroseconds(1);
  }          
  s_transstart();                   //transmission start
}

//----------------------------------------------------------------------------------
char s_softreset(void)
//----------------------------------------------------------------------------------
// resets the sensor by a softreset 
{ 
  unsigned char error=0;  
  s_connectionreset();              //reset communication
  error+=s_write_byte(RESET);       //send RESET-command to sensor
  return error;                     //error=1 in case of no response form the sensor
}

//----------------------------------------------------------------------------------
char s_read_statusreg(unsigned char *p_value, unsigned char *p_checksum)
//----------------------------------------------------------------------------------
// reads the status register with checksum (8-bit)
{ 
  unsigned char error=0;
  s_transstart();                   //transmission start
  error=s_write_byte(STATUS_REG_R); //send command to sensor
  *p_value=s_read_byte(ACK);        //read status register (8-bit)
  *p_checksum=s_read_byte(noACK);   //read checksum (8-bit)  
  return error;                     //error=1 in case of no response form the sensor
}

//----------------------------------------------------------------------------------
char s_write_statusreg(unsigned char *p_value)
//----------------------------------------------------------------------------------
// writes the status register with checksum (8-bit)
{ 
  unsigned char error=0;
  s_transstart();                   //transmission start
  error+=s_write_byte(STATUS_REG_W);//send command to sensor
  error+=s_write_byte(*p_value);    //send value of status register
  return error;                     //error>=1 in case of no response form the sensor
}
 							   
//----------------------------------------------------------------------------------
char s_measure(unsigned char *p_value, unsigned char *p_checksum, unsigned char mode)
//----------------------------------------------------------------------------------
// makes a measurement (humidity/temperature) with checksum
{ 
  unsigned error=0;
  unsigned int i;

  s_transstart();                   //transmission start
  switch(mode){                     //send command to sensor
    case TEMP	: error+=s_write_byte(MEASURE_TEMP); break;
    case HUMI	: error+=s_write_byte(MEASURE_HUMI); break;
    default     : break;	 
  }                        
  SHT_INPUT_MODE();
  for (i=0;i<65535;i++) 
  {
	delayMicroseconds(1);
   //if((SHT_PIN & (1<<SHT_DATA))==0) break; //wait until sensor has finished the measurement
   if (digitalRead(SHT_DATA_PIN) == LOW) break; //wait until sensor has finished the measurement
  }   
  //if (SHT_PIN & (1<<SHT_DATA)) error+=1;  // or timeout (~2 sec.) is reached
  if (digitalRead(SHT_DATA_PIN) == HIGH) error += 1;  // or timeout (~2 sec.) is reached
  *(p_value+1)=s_read_byte(ACK);    //read the first byte (MSB)
  *(p_value)=s_read_byte(ACK);    //read the second byte (LSB)
  *p_checksum =s_read_byte(noACK);  //read checksum
  return error;
}

//----------------------------------------------------------------------------------------
void calc_sth11(float *p_humidity ,float *p_temperature)
//----------------------------------------------------------------------------------------
// calculates temperature [�C] and humidity [%RH] 
// input :  humi [Ticks] (12 bit) 
//          temp [Ticks] (14 bit)
// output:  humi [%RH]
//          temp [�C]
{   
  float rh=*p_humidity;             // rh:      Humidity [Ticks] 12 Bit 
  float t=*p_temperature;           // t:       Temperature [Ticks] 14 Bit
  float rh_lin;                     // rh_lin:  Humidity linear
  float rh_true;                    // rh_true: Temperature compensated humidity
  float t_C;                        // t_C   :  Temperature [�C]
  
  t_C=t*0.04 - 39.8;                  //calc. temperature from ticks to [�C]  first coeff. 0.01 for 14 bit and 0.04 for 12 bit
  rh_lin=C3*rh*rh + C2*rh + C1;     //calc. humidity from ticks to [%RH]
  rh_true=(t_C-25)*(T1+T2*rh)+rh_lin;   //calc. temperature compensated humidity [%RH]
  if(rh_true>100)rh_true=100;       //cut if the value is outside of
  if(rh_true<0.1)rh_true=0.1;       //the physical possible range

  *p_temperature=t_C;               //return temperature [�C]
  *p_humidity=rh_true;              //return humidity[%RH]
}

//--------------------------------------------------------------------
float calc_dewpoint(float h,float t)
//--------------------------------------------------------------------
// calculates dew point
// input:   humidity [%RH], temperature [�C]
// output:  dew point [�C]
{ float logEx,dew_point;
  logEx=0.66077+7.5*t/(237.3+t)+(log10(h)-2);
  dew_point = (logEx - 0.66077)*237.3/(0.66077+7.5-logEx);
  return dew_point;
}
      
