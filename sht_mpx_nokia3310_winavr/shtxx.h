#include <avr/io.h> 
//#include <avr/iom32.h>
#include <util/delay.h>

/*#ifndef F_CPU
	#define F_CPU 8000000UL 		// частота тактового генератора в Гц (8 МГц тут)
#endif*/

#define SHT_PORT PORTC // порт на якому причеплено сенсор температури і вологості SHTXX
#define SHT_DDR DDRC // регістр налаштування порта для сенсора температури і вологості SHTXX
#define SHT_PIN PINC // пін порта
#define	SHT_DATA 1  // дані 
#define	SHT_SCK 0   // синхронізація

#define noACK 0
#define ACK   1    

#define SHT_INPUT_MODE() SHT_DDR&=~(1<<SHT_DATA)
#define SHT_OUTPUT_MODE() SHT_DDR|=(1<<SHT_DATA)
#define SHT_DATA_LOW() SHT_PORT&=~(1<<SHT_DATA)
#define SHT_DATA_HIGH() SHT_PORT|=(1<<SHT_DATA)
#define SHT_SCK_LOW() SHT_PORT&=~(1<<SHT_SCK)
#define SHT_SCK_HIGH() SHT_PORT|=(1<<SHT_SCK)

/* список команд сенсора SHTXX */
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

/* функції */
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


