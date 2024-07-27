#ifndef _THERM_DS18B20_INCLUDED_
#define _THERM_DS18B20_INCLUDED_

//#include <stdio.h>
#include <mega32.h>
#include <delay.h>

/*#ifndef F_CPU
	#define F_CPU 8000000UL 		// частота тактового генератора в Гц (8 МГц тут)
#endif

#define LOOP_CYCLES 8 				// число тактів необхідних для виконання циклу
#define us(num) (num/(LOOP_CYCLES*(1/(F_CPU/1000000.0))))
#define ms(num) (num/(LOOP_CYCLES*(1/(F_CPU/1000.0))))        */

#define THERM_PORT PORTC // порт на якому причеплено давачі температури   
#define THERM_DDR DDRC	 // регістр налаштування порта для давача температури 
#define THERM_PIN PINC 
#define THERM_DQ 4  // пін на давач температури

/* Utils */
#define THERM_INPUT_MODE() THERM_DDR&=~(1<<THERM_DQ)
#define THERM_OUTPUT_MODE() THERM_DDR|=(1<<THERM_DQ)
#define THERM_LOW() THERM_PORT&=~(1<<THERM_DQ)
#define THERM_HIGH() THERM_PORT|=(1<<THERM_DQ) 

/* список команд давача температури DS18B20 */
#define THERM_CMD_CONVERTTEMP 0x44
#define THERM_CMD_RSCRATCHPAD 0xbe
#define THERM_CMD_WSCRATCHPAD 0x4e
#define THERM_CMD_CPYSCRATCHPAD 0x48
#define THERM_CMD_RECEEPROM 0xb8
#define THERM_CMD_RPWRSUPPLY 0xb4
#define THERM_CMD_SEARCHROM 0xf0
#define THERM_CMD_READROM 0x33
#define THERM_CMD_MATCHROM 0x55
#define THERM_CMD_SKIPROM 0xcc
#define THERM_CMD_ALARMSEARCH 0xec
/* константи */
#define THERM_9BIT_RES 0	// роздільна здатність давача 9 біт
#define THERM_10BIT_RES 1 	// роздільна здатність давача 10 біт
#define THERM_11BIT_RES 2	// роздільна здатність давача 11 біт
#define THERM_12BIT_RES 3	// роздільна здатність давача 12 біт

typedef char int8_t;
typedef unsigned char uint8_t;
typedef unsigned int uint16_t;

/* структура для збереження RAM */
struct __ds18b20_scratch_pad_struct
{
	uint8_t temp_lsb, 
			temp_msb,
			tem_high, 
			temp_low,
			conf_register,
			res1,
			res2,
			res3,
			crc;
};
/* функції для внутрішнього використання */
//void therm_delay(uint16_t delay);
uint8_t therm_reset(void);
void therm_write_bit(uint8_t _bit);
uint8_t therm_read_bit(void);
uint8_t therm_read_byte(void);
void therm_write_byte(uint8_t byte);
/* функція обчислення контрольної суми */
uint8_t therm_crc8(uint8_t *data, uint8_t num_bytes);
/* функція ініціалізація давачів температури */
uint8_t therm_init(int8_t temp_low, int8_t temp_high, uint8_t resolution);
/* функція зчитування температури з давача */
//uint8_t therm_read_temp_indoor(float *indoor_temp);
//uint8_t therm_read_temp_outdoor(float *outdoor_temp);
//uint8_t therm_read_temperature(float *temp);
uint8_t therm_read_temperature(float *temp);

#endif
