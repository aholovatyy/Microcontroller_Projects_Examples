/* An STM32 HAL library written for the BMP180 temperature/pressure sensor. */
/* Libraries by @eepj www.github.com/eepj */
#include "bmp180.h"
#include "main.h"
#include <math.h>

#ifdef __cplusplus
extern "C"{
#endif

#define atm_press 101325 //Pa

/* вказівник дескриптора інтерфейсу I2C */
I2C_HandleTypeDef *_bmp180_ui2c;
/* структура для збереження калібрувальних коефіцієнтів */
BMP180_EEPROM _bmp180_eeprom;
/* параметр режиму точності вимірювання тиску */
BMP180_OSS _bmp180_oss;

/* старші байти адрес EEPROM, де зберігаються коефіцієнти калібрування  */
const uint8_t BMP180_EEPROM_ADDR_MSB[11] = { 0xaa, 0xac, 0xae, 0xb0, 0xb2, 0xb4, 0xb6, 0xb8, 0xba, 0xbc, 0xbe };
/* молодші байти адрес EEPROM, де зберігаються коефіцієнти калібрування  */
const uint8_t BMP180_EEPROM_ADDR_LSB[11] = { 0xab, 0xad, 0xaf, 0xb1, 0xb3, 0xb5, 0xb7, 0xb9, 0xbb, 0xbd, 0xbf };
/* команда вимірювання температури */
const uint8_t BMP180_CMD_TEMP = 0x2e;
/* часова затримка потрібна для вимірювання температури */
const uint8_t BMP180_DELAY_TEMP = 25;
/* команди вимірювання тиску */
const uint8_t BMP180_CMD_PRES[4] = { 0x34, 0x74, 0xb4, 0xf4 };
/* часові затримки (час перетворення тиску) потрібні для вимірювання тиску, мілісек. */
const uint8_t BMP180_DELAY_PRES[4] = { 5, 8, 14, 26 };
const uint8_t BMP180_CMD_RESET = 0xb6; /* reset device */

/**
 * @brief ініціалізація давача температури і тиску BMP180
 * @param hi2c User I2C вказівник дескриптора інтерфейсу I2C.
 */
void bmp180_init(I2C_HandleTypeDef *hi2c) {
	_bmp180_ui2c = hi2c;
}

/**
 * @param oss Enum, налаштування oversampling.
 * @note доступні режими дискретизації (точності) вимірюваняя тиску: BMP180_LOW, BMP180_STANDARD, BMP180_HIGH, BMP180_ULTRA.
 * @note детально описано в розділі 3.3.1 даташиту давача
 */
void bmp180_set_oversampling(BMP180_OSS oss) {
	_bmp180_oss = oss;
}

/**
 * @brief зчитування калібрувальних коефіцієнтів з EEPROM давача BMP180
 * @note викликається один раз перед основним циклом (main loop)
 */
void bmp180_update_calibration_data(void) {
	_bmp180_eeprom.BMP180_AC1 = (bmp180_read_reg(BMP180_EEPROM_ADDR_MSB[BMP180_INDEX_AC1]) << 8) | bmp180_read_reg(BMP180_EEPROM_ADDR_LSB[BMP180_INDEX_AC1]);
	_bmp180_eeprom.BMP180_AC2 = (bmp180_read_reg(BMP180_EEPROM_ADDR_MSB[BMP180_INDEX_AC2]) << 8) | bmp180_read_reg(BMP180_EEPROM_ADDR_LSB[BMP180_INDEX_AC2]);
	_bmp180_eeprom.BMP180_AC3 = (bmp180_read_reg(BMP180_EEPROM_ADDR_MSB[BMP180_INDEX_AC3]) << 8) | bmp180_read_reg(BMP180_EEPROM_ADDR_LSB[BMP180_INDEX_AC3]);
	_bmp180_eeprom.BMP180_AC4 = (bmp180_read_reg(BMP180_EEPROM_ADDR_MSB[BMP180_INDEX_AC4]) << 8) | bmp180_read_reg(BMP180_EEPROM_ADDR_LSB[BMP180_INDEX_AC4]);
	_bmp180_eeprom.BMP180_AC5 = (bmp180_read_reg(BMP180_EEPROM_ADDR_MSB[BMP180_INDEX_AC5]) << 8) | bmp180_read_reg(BMP180_EEPROM_ADDR_LSB[BMP180_INDEX_AC5]);
	_bmp180_eeprom.BMP180_AC6 = (bmp180_read_reg(BMP180_EEPROM_ADDR_MSB[BMP180_INDEX_AC6]) << 8) | bmp180_read_reg(BMP180_EEPROM_ADDR_LSB[BMP180_INDEX_AC6]);
	_bmp180_eeprom.BMP180_B1 = (bmp180_read_reg(BMP180_EEPROM_ADDR_MSB[BMP180_INDEX_B1]) << 8) | bmp180_read_reg(BMP180_EEPROM_ADDR_LSB[BMP180_INDEX_B1]);
	_bmp180_eeprom.BMP180_B2 = (bmp180_read_reg(BMP180_EEPROM_ADDR_MSB[BMP180_INDEX_B2]) << 8) | bmp180_read_reg(BMP180_EEPROM_ADDR_LSB[BMP180_INDEX_B2]);
	_bmp180_eeprom.BMP180_MB = (bmp180_read_reg(BMP180_EEPROM_ADDR_MSB[BMP180_INDEX_MB]) << 8) | bmp180_read_reg(BMP180_EEPROM_ADDR_LSB[BMP180_INDEX_MB]);
	_bmp180_eeprom.BMP180_MC = (bmp180_read_reg(BMP180_EEPROM_ADDR_MSB[BMP180_INDEX_MC]) << 8) | bmp180_read_reg(BMP180_EEPROM_ADDR_LSB[BMP180_INDEX_MC]);
	_bmp180_eeprom.BMP180_MD = (bmp180_read_reg(BMP180_EEPROM_ADDR_MSB[BMP180_INDEX_MD]) << 8) | bmp180_read_reg(BMP180_EEPROM_ADDR_LSB[BMP180_INDEX_MD]);
}

/**
 * @brief записує байт в регістр
 * @param reg - адреса регістра, в який має бути записано
 * @param cmd - байт, який має бути записано
 */
void bmp180_write_reg(uint8_t reg, uint8_t cmd) {
	uint8_t arr[2] = { reg, cmd };
	HAL_I2C_Master_Transmit(_bmp180_ui2c, BMP180_I2C_ADDR << 1, arr, 2, BMP180_I2C_TIMEOUT);
}

/**
 * @brief зчитує байт з вказаного регістра
 * @param reg  - адреса регістра, з якого має бути виконано зчитування
 * @return повертає прочитаний байт
 */
uint8_t bmp180_read_reg(uint8_t reg) {
	HAL_I2C_Master_Transmit(_bmp180_ui2c, BMP180_I2C_ADDR << 1, &reg, 1, BMP180_I2C_TIMEOUT);
	uint8_t result;
	HAL_I2C_Master_Receive(_bmp180_ui2c, BMP180_I2C_ADDR << 1, &result, 1, BMP180_I2C_TIMEOUT);
	return result;
}

/**
 * @brief вимірює та обчислює значення температури
 * @return повертає значення температури в 0.1 (1/10) градусах Цельсія
 */
int32_t bmp180_get_raw_temperature(void) {
	bmp180_write_reg(BMP180_CONTROL_REG, BMP180_CMD_TEMP);
	HAL_Delay(BMP180_DELAY_TEMP);
	int32_t ut = (bmp180_read_reg(BMP180_MSB_REG) << 8) | bmp180_read_reg(BMP180_LSB_REG);
	int32_t x1 = (ut - _bmp180_eeprom.BMP180_AC6) * _bmp180_eeprom.BMP180_AC5 / (1 << 15);
	int32_t x2 = (_bmp180_eeprom.BMP180_MC * (1 << 11)) / (x1 + _bmp180_eeprom.BMP180_MD);
	int32_t b5 = x1 + x2;
	return (b5 + 8) / (1 << 4);
}

/**
 * @brief вимірює та обчислюєзначення температури
 * @return повертає значення температури в градусах Цельсія
 */
float bmp180_get_temperature(void) {
	int32_t temp = bmp180_get_raw_temperature();
	return temp / 10.0;
}

/**
 * @brief вимірює та обчислює значення тиску
 * @return повертає значення тиску в Паскалях (Pa)
 */
int32_t bmp180_get_pressure(void) {
	bmp180_write_reg(BMP180_CONTROL_REG, BMP180_CMD_TEMP);
	HAL_Delay(BMP180_DELAY_TEMP);
	int32_t ut = bmp180_get_UT();
	bmp180_write_reg(BMP180_CONTROL_REG, BMP180_CMD_PRES[_bmp180_oss]);
	HAL_Delay(BMP180_DELAY_PRES[_bmp180_oss]);
	int32_t up = bmp180_get_UP();
	int32_t x1 = (ut - _bmp180_eeprom.BMP180_AC6) * _bmp180_eeprom.BMP180_AC5 / (1 << 15);
	int32_t x2 = (_bmp180_eeprom.BMP180_MC * (1 << 11)) / (x1 + _bmp180_eeprom.BMP180_MD);
	int32_t b5 = x1 + x2;
	int32_t b6 = b5 - 4000;
	x1 = (_bmp180_eeprom.BMP180_B2 * (b6 * b6 / (1 << 12))) / (1 << 11);
	x2 = _bmp180_eeprom.BMP180_AC2 * b6 / (1 << 11);
	int32_t x3 = x1 + x2;
	int32_t b3 = (((_bmp180_eeprom.BMP180_AC1 * 4 + x3) << _bmp180_oss) + 2) / 4;
	x1 = _bmp180_eeprom.BMP180_AC3 * b6 / (1 << 13);
	x2 = (_bmp180_eeprom.BMP180_B1 * (b6 * b6 / (1 << 12))) / (1 << 16);
	x3 = ((x1 + x2) + 2) / 4;
	uint32_t b4 = _bmp180_eeprom.BMP180_AC4 * (uint32_t) (x3 + 32768) / (1 << 15);
	uint32_t b7 = ((uint32_t) up - b3) * (50000 >> _bmp180_oss);
	int32_t p;
	if (b7 < 0x80000000)
		p = (b7 * 2) / b4;
	else
		p = (b7 / b4) * 2;
	x1 = (p / (1 << 8)) * (p / (1 << 8));
	x1 = (x1 * 3038) / (1 << 16);
	x2 = (-7357 * p) / (1 << 16);
	p = p + (x1 + x2 + 3791) / (1 << 4);
	return p;
}

int32_t bmp180_get_UT(void)
{
	return (bmp180_read_reg(BMP180_MSB_REG) << 8) | bmp180_read_reg(BMP180_LSB_REG);
}

int32_t bmp180_get_UP(void)
{
	return ((bmp180_read_reg(BMP180_MSB_REG) << 16) | (bmp180_read_reg(BMP180_LSB_REG) << 8) | bmp180_read_reg(BMP180_XLSB_REG)) >> (8 - _bmp180_oss);
}

float bmp180_get_altitude(void)
{
	int32_t press = bmp180_get_UP();
	return 44330*(1-(pow((press/(float)atm_press), 0.19029495718)));
}

#ifdef __cplusplus
}
#endif
