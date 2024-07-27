/*
  Library:        lcd16x2 - Parallel 8/4 bits
  Written by:     Ihor Bizhyk
  Date Written:   01/05/2024
  Updated:        12/05/2024
  Description:    This is a library of the alpha-numeric 16x2 LCDs with HD44780-compatible driver, for the STM32 MCUs based on HAL libraries.
                  It performs the basic text/number outputting to 16x2 LCD, in 8 bits and 4 bits operation modes.

 */

#ifndef __LCD16X2_H_
#define __LCD16X2_H_

#include <stdbool.h>
#include "main.h"

//Floating point linker flag: -u _printf_float

//static uint32_t DWT_Delay_Init(void);

//__STATIC_INLINE void DWT_Delay_us(volatile uint32_t usec);

/**
 * @brief  ініціалізує LCD в 8-бітний режим
 * @param[in] *port_rs_e RS і EN GPIO Port (e.g. GPIOB)
 * @param[in] *port_0_3 - порт GPIO для шини даних від D0 до D3
 * @param[in] *port_4_7 - порт GPIO для шини даних від D4 до D7
 * @param[in] x_pin пін GPIO (e.g. GPIO_PIN_1)
 */
void lcd16x2_init_8bits(
    GPIO_TypeDef* port_rs_e, uint16_t rs_pin, uint16_t e_pin,
    GPIO_TypeDef* port_0_3, uint16_t d0_pin, uint16_t d1_pin, uint16_t d2_pin, uint16_t d3_pin,
    GPIO_TypeDef* port_4_7, uint16_t d4_pin, uint16_t d5_pin, uint16_t d6_pin, uint16_t d7_pin);

/**
 * @brief ініціалізує LCD в 4-бітний режим
 * @param[in] *port_4_7 порт GPIO для ліній шини від D4 до D7
 * @param[in] x_pin пін GPIO (e.g. GPIO_PIN_1)
 */
void lcd16x2_init_4bits(
    GPIO_TypeDef* port_rs_e, uint16_t rs_pin, uint16_t e_pin,
    GPIO_TypeDef* port_4_7, uint16_t d4_pin, uint16_t d5_pin, uint16_t d6_pin, uint16_t d7_pin);

/**
 * @brief встановлює крусор у задану позицію
 * @param[in] row - 0 або 1 для рядка1 або рядка2
 * @param[in] col - 0 - 15 (16 стовпців LCD)
 */
void lcd16x2_setCursor(uint8_t row, uint8_t col);
/**
 * @brief переходить на перший рядок LCD
 */
void lcd16x2_1stLine(void);
/**
 * @brief переходить на другий рядок LCD
 */
void lcd16x2_2ndLine(void);

/**
 * @brief вибирає однорядковий або дворядковий режим LCD
 */
void lcd16x2_twoLines(void);
void lcd16x2_oneLine(void);

/**
 * @brief включає/виключає показ курсора
 */
void lcd16x2_cursorShow(bool state);

/**
 * @brief очищує дисплей
 */
void lcd16x2_clear(void);

/**
 * @brief включає/виключає дисплей, приховує всі символи, але не очищає
 */
void lcd16x2_display(bool state);

/**
 * @brief зсуває вміст (контент) вправо
 */
void lcd16x2_shiftRight(uint8_t offset);

/**
 * @brief зсуває вміст (контент) вліво
 */
void lcd16x2_shiftLeft(uint8_t offset);

/**
 * @brief виводить на дисплей будь-які типи даних (наприклад: lcd16x2_printf("Value1 = %.1f", 123.45))
 */
void lcd16x2_printf(const char* str, ...);

/**
 * @brief виводить на дисплей символ
 * */
void lcd16x2_writeData(uint8_t data);

/**
 * @brief записує в CGRAM користувацький символ
 */
void lcd16x2_custom_char(uint8_t loc, unsigned char *msg);

#endif /* LCD16X2_H_ */
