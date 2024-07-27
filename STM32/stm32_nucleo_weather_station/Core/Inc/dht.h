#ifndef __DHT_STM32_H_
#define __DHT_STM32_H_

#ifdef __cplusplus
 extern "C" {
#endif

#include "main.h"

#define DHTLIB_OK 0
#define DHTLIB_ERROR_CHECKSUM -1
#define DHTLIB_ERROR_TIMEOUT -2
#define DHTLIB_INVALID_VALUE -999
#define DHTLIB_TIMEOUT 200

#define DHTLIB_DHT11_WAKEUP 18
#define DHTLIB_DHT_WAKEUP 18

/* функція налаштування GPIO піна як вихід */
void set_pin_output (GPIO_TypeDef *GPIOx, uint16_t GPIO_Pin);
/* функція налаштування GPIO піна як вхід */
void set_pin_input (GPIO_TypeDef *GPIOx, uint16_t GPIO_Pin);
/* функція ініціалізації давача DHT */
void dht_init(GPIO_TypeDef *GPIOx, uint16_t GPIO_Pin, TIM_HandleTypeDef *htim);
/* функція зчитування даних температури і вологості з давача DHT */
int dht_read_sensor(uint8_t wakeup_delay);
/* функція опрацювання прочитаних даних температури і вологості з давача DHT */
int dht_read(float *humidity, float *temperature);
/* функція обчислює точку роси */
float dht_calc_dewpoint(float *humidity, float *temperature);
#endif
