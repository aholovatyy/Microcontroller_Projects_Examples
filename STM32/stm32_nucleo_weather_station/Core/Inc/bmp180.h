/* An STM32 HAL library written for the BMP180 temperature/pressure sensor. */
/* Library by @eepj www.github.com/eepj */
#ifndef __BMP180_STM32_H
#define __BMP180_STM32_H

#include "main.h"

#define BMP180_I2C_ADDR					0x77
#define BMP180_I2C_TIMEOUT				1000
#define BMP180_CONTROL_REG				0xf4
#define BMP180_MSB_REG					0xf6
#define BMP180_LSB_REG					0xf7
#define BMP180_XLSB_REG					0xf8
#define BMP180_SOFT_RESET_REG			0xe0

/* режими точності вимірювання тиску: ультра-низький, стандартний, високої роздільної здатності, ультра-високої роздільної здатності */
typedef enum BMP180_OSS {
	BMP180_LOW, BMP180_STANDARD, BMP180_HIGH, BMP180_ULTRA,
} BMP180_OSS;

/* індекси для вибірки адрес потрібних коефіцієнтів калібрування з масивів BMP180_EEPROM_ADDR_MSB, BMP180_EEPROM_ADDR_LSB */
typedef enum BMP180_cal_index {
	BMP180_INDEX_AC1,
	BMP180_INDEX_AC2,
	BMP180_INDEX_AC3,
	BMP180_INDEX_AC4,
	BMP180_INDEX_AC5,
	BMP180_INDEX_AC6,
	BMP180_INDEX_B1,
	BMP180_INDEX_B2,
	BMP180_INDEX_MB,
	BMP180_INDEX_MC,
	BMP180_INDEX_MD,
} BMP180_сal_index;

/* структура для збереження прочитаних з EEPROM значень калібрувальних коефіцієнтів */
typedef struct BMP180_EEPROM {
	short BMP180_AC1;
	short BMP180_AC2;
	short BMP180_AC3;
	unsigned short BMP180_AC4;
	unsigned short BMP180_AC5;
	unsigned short BMP180_AC6;
	short BMP180_B1;
	short BMP180_B2;
	short BMP180_MB;
	short BMP180_MC;
	short BMP180_MD;
} BMP180_EEPROM;

extern I2C_HandleTypeDef *_bmp180_ui2c;
extern BMP180_EEPROM _bmp180_eeprom;
extern BMP180_OSS _bmp180_oss;

extern const uint8_t BMP180_EEPROM_ADDR_MSB[11];
extern const uint8_t BMP180_EEPROM_ADDR_LSB[11];

extern const uint8_t BMP180_CMD_TEMP;
extern const uint8_t BMP180_DELAY_TEMP;
extern const uint8_t BMP180_CMD_PRES[4];
extern const uint8_t BMP180_DELAY_PRES[4];
extern const uint8_t BMP180_SOFT_RESET;

/* функція ініціалізації з інтерфейсом I2C */
void bmp180_init(I2C_HandleTypeDef *hi2c);

/* функція налаштування режиму вимірювання */
void bmp180_set_oversampling(BMP180_OSS oss);

/* функція зчитування калібрувальних коефіцієнтів з EEPROM */
void bmp180_update_calibration_data(void);

/* функції запису і зчитування даних регістра */
void bmp180_write_reg(uint8_t reg, uint8_t cmd);
uint8_t bmp180_read_reg(uint8_t reg);

/* функція вимірювання і обчислення значення температури */
int32_t bmp180_get_raw_temperature(void);
/* функція вимірювання і обчислення значення тиску */
int32_t bmp180_get_pressure(void);

/* функція вимірювання і обчислення температури, повертає дійсне значення */
float bmp180_get_temperature(void);

/* функція зчитування некомпенсованих даних температури */
int32_t bmp180_get_UT(void);
/* функція зчитування некомпенсованих даних тиску */
int32_t bmp180_get_UP(void);
/* функція обчислюэ значення висоти над рывнем моря */
float bmp180_get_altitude(void);
#endif
