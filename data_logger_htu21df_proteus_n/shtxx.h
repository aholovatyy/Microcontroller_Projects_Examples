//#include <avr/io.h> 
//#include <avr/iom32.h>
//#include <util/delay.h>

/*#ifndef F_CPU
	#define F_CPU 8000000UL 		// ������� ��������� ���������� � �� (8 ��� ���)
#endif*/

#ifndef shtxx_h
#define shtxx_h

#if (ARDUINO >= 100)
#include <Arduino.h>
#else
#include <WProgram.h>
#endif

#include <stdint.h>
#include "Arduino.h"

//#define SHT_PORT PORTC // ���� �� ����� ���������� ������ ����������� � �������� SHTXX
//#define SHT_DDR DDRC // ������ ������������ ����� ��� ������� ����������� � �������� SHTXX
//#define SHT_PIN PINC // �� �����
#define	SHT_DATA_PIN 15  // ��� 
#define	SHT_SCK_PIN 14  // ������������

#define noACK 0
#define ACK   1    

//#define SHT_INPUT_MODE() SHT_DDR&=~(1<<SHT_DATA)
#define SHT_INPUT_MODE() pinMode(SHT_DATA_PIN, INPUT)

//#define SHT_OUTPUT_MODE() SHT_DDR|=(1<<SHT_DATA)
#define SHT_OUTPUT_MODE() pinMode(SHT_DATA_PIN, OUTPUT)

//#define SHT_DATA_LOW() SHT_PORT&=~(1<<SHT_DATA)
#define SHT_DATA_LOW() digitalWrite(SHT_DATA_PIN, LOW)

//#define SHT_DATA_HIGH() SHT_PORT|=(1<<SHT_DATA)
#define SHT_DATA_HIGH() digitalWrite(SHT_DATA_PIN, HIGH)

//#define SHT_SCK_LOW() SHT_PORT&=~(1<<SHT_SCK)
#define SHT_SCK_LOW() digitalWrite(SHT_SCK_PIN, LOW)

//#define SHT_SCK_HIGH() SHT_PORT|=(1<<SHT_SCK)
#define SHT_SCK_HIGH() digitalWrite(SHT_SCK_PIN, HIGH)

/* ������ ������ ������� SHTXX */
                       //adr  command  r/w
#define STATUS_REG_W 0x06   //000   0011    0
#define STATUS_REG_R 0x07   //000   0011    1
#define MEASURE_TEMP 0x03   //000   0001    1
#define MEASURE_HUMI 0x05   //000   0010    1
#define RESET        0x1e   //000   1111    0
 
typedef union 
{ unsigned int i;
  float f;
} value;

enum {TEMP,HUMI};

/* ������� */
void sht_init(void);
char s_write_byte(unsigned char value);
char s_read_byte(unsigned char ack);
void s_transstart(void);
void s_connectionreset(void);
char s_softreset(void);
char s_read_statusreg(unsigned char *p_value, unsigned char *p_checksum);
char s_write_statusreg(unsigned char *p_value);
char s_measure(unsigned char *p_value, unsigned char *p_checksum, unsigned char mode);
void calc_sth11(float *p_humidity ,float *p_temperature);
float calc_dewpoint(float h,float t);


#endif // #ifndef shtxx_h
