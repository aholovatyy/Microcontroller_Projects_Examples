#include "dht.h"
#include <math.h>

GPIO_TypeDef *DHT_PORT;
uint16_t DHT_PIN;

TIM_HandleTypeDef *htim;

uint8_t bits[5];  // буфер для збергіання прочитаних даних з давача DHT

/* функція налаштування GPIO піна як вихід
 * GPIOx - GPIO порт, GPIO_Pin - GPIO пін
 * */
void set_pin_output(GPIO_TypeDef *GPIOx, uint16_t GPIO_Pin)
{
	GPIO_InitTypeDef GPIO_InitStruct = {0};
	GPIO_InitStruct.Pin = GPIO_Pin;
	GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
	GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;
	HAL_GPIO_Init(GPIOx, &GPIO_InitStruct);
}

/* функція налаштування GPIO піна як вхід
 * GPIOx - GPIO порт, GPIO_Pin - GPIO пін
 * */
void set_pin_input(GPIO_TypeDef *GPIOx, uint16_t GPIO_Pin)
{
	GPIO_InitTypeDef GPIO_InitStruct = {0};
	GPIO_InitStruct.Pin = GPIO_Pin;
	GPIO_InitStruct.Mode = GPIO_MODE_INPUT;
	GPIO_InitStruct.Pull = GPIO_NOPULL;
	HAL_GPIO_Init(GPIOx, &GPIO_InitStruct);
}

/*void delay_us(uint16_t us)
{
    htim->Instance->CNT = 0;
    while (htim->Instance->CNT < us);
}

void delay_ms(volatile uint16_t ms)
{
	while(ms > 0)
	{
		htim->Instance->CNT = 0;
		ms--;
		while (htim->Instance->CNT < 1000);
	}
}*/

/* функція ініціалізації DHT
 * GPIOx - GPIO порт, GPIO_Pin - GPIO пін
 * _htim - вказівник на структуру параметрів конфігурації таймера
 * */
void dht_init(GPIO_TypeDef *GPIOx, uint16_t GPIO_Pin, TIM_HandleTypeDef *_htim)
{
	DHT_PORT = GPIOx;
	DHT_PIN = GPIO_Pin;
	htim = _htim;
}

int dht_readSensor(uint8_t wakeup_delay)
{
	//__disable_irq();
	uint8_t mask = 128;
    uint8_t idx = 0;

    // очищуємо буфер
    for (uint8_t i = 0; i < 5; i++) bits[i] = 0;

    // виконуємо запит на читання даних
    set_pin_output(DHT_PORT, DHT_PIN);
    HAL_GPIO_WritePin(DHT_PORT, DHT_PIN, 0); // переводимо пін у низький лог. рівень
    delay_us(wakeup_delay * 1000UL);
    set_pin_input(DHT_PORT, DHT_PIN);
    delay_us(50);

    // отримуємо підтвердження від давача або TIMEOUT
    htim->Instance->CNT = 0;
    while (!(HAL_GPIO_ReadPin(DHT_PORT, DHT_PIN)))
    {
       if (htim->Instance->CNT > DHTLIB_TIMEOUT)
       {
    	   return DHTLIB_ERROR_TIMEOUT;
       }
    }
    htim->Instance->CNT = 0;
    while (HAL_GPIO_ReadPin(DHT_PORT, DHT_PIN))
    {
       if (htim->Instance->CNT > DHTLIB_TIMEOUT)
       {
    	   return DHTLIB_ERROR_TIMEOUT;
       }
    }
    // читаємо дані - 40 біт => 5 байтів
    for (uint8_t i = 40; i != 0; i--)
    {
        htim->Instance->CNT = 0;
        while (!(HAL_GPIO_ReadPin(DHT_PORT, DHT_PIN)))
        {
           if (htim->Instance->CNT > DHTLIB_TIMEOUT)
           {
               return DHTLIB_ERROR_TIMEOUT;
           }
        }

        htim->Instance->CNT = 0;

        while (HAL_GPIO_ReadPin(DHT_PORT, DHT_PIN))
        {
           if (htim->Instance->CNT > DHTLIB_TIMEOUT)
           {
               return DHTLIB_ERROR_TIMEOUT;
           }
        }

        if (htim->Instance->CNT > 40)
        {
            bits[idx] |= mask;
        }
        mask >>= 1;
        if (mask == 0)   // наступний байт?
        {
            mask = 128;
            idx++;
        }
    }
    //__enable_irq();
    return DHTLIB_OK;
}

int dht_read(float *humidity, float *temperature)
{
    // читаємо дані температури і вологості
    //if (_disableIRQ) noInterrupts();
	__disable_irq();
    int rv = dht_readSensor(DHTLIB_DHT11_WAKEUP);
    __enable_irq();
    if (rv != DHTLIB_OK)
    {
        *humidity    = DHTLIB_INVALID_VALUE; // некоректне (недійсне) значення , або NaN prefered?
        *temperature = DHTLIB_INVALID_VALUE; // недійсне значення
        return rv;
    }
    // перетворюємо отримані дані у значення температури і вологості та зберігаємо їх
    *humidity = ((bits[0] << 8) | bits[1]) * 0.1;
    *temperature = ((bits[2] << 8) | bits[3]) * 0.1;
    if (bits[2] & 0x80)  // від'ємна температура
    {
        *temperature = -(*temperature);
    }
    // перевіряємо контрольну суму
    uint8_t sum = bits[0] + bits[1] + bits[2] + bits[3];
    if (bits[4] != sum)
    {
      return DHTLIB_ERROR_CHECKSUM;
    }
    return DHTLIB_OK;
}

/* функція обчислює точку роси
 * вхідні параметри: humidity [%RH], temperature [°C]
 * повертає: обчислене значення точки роси dew_point [°C]
  */
float dht_calc_dewpoint(float *humidity, float *temperature)
{
  float logEx, dew_point;
  logEx = 0.66077 + 7.5* (*temperature) / (237.3 + (*temperature))+(log10(*humidity)-2);
  dew_point = (logEx - 0.66077)*237.3 / (0.66077+7.5-logEx);
  return dew_point;
}

