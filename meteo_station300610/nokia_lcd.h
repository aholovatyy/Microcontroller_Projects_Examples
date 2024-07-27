/*
** lcd.h
**
** LCD 3310 driver
** Target: ATMEGA :: AVR-GCC
**
** Written by Tony Myatt - 2007
** Quantum Torque - www.quantumtorque.com
*/
#ifndef _NOKIALCD_H_
#define _NOKIALCD_H_

/* Lcd screen size */
#define LCD_X_RES 84
#define LCD_Y_RES 48
#define LCD_CACHE_SIZE ((LCD_X_RES * LCD_Y_RES) / 8)

/* Pinout for LCD */
#define LCD_CLK_PIN 	(1<<4) 
#define LCD_DATA_PIN 	(1<<3)
#define LCD_DC_PIN 		(1<<2)
#define LCD_CE_PIN 		(1<<1)
#define LCD_RST_PIN 	(1<<0)
#define LCD_PORT		PORTA
#define LCD_DDR			DDRA

/* Special Chars */
#define ARROW_RIGHT	ICON(0)
#define ARROW_LEFT 	ICON(1)
#define ARROW_UP 	ICON(2)
#define ARROW_DOWN 	ICON(3)
#define STOP 		ICON(4)
#define PLAY	 	ICON(5)

/* Function for my special characters */
#define	ICON(x)		'z'+1+x

/* General constants for driver */
#define FALSE                      0
#define TRUE                       1

/* For return value */
#define OK                         0
#define OUT_OF_BORDER              1
#define OK_WITH_WRAP               2

/* Type definition */
typedef char                       bool;
typedef unsigned char              byte;
typedef unsigned int               word;

typedef enum
{
    PIXEL_OFF =  0,
    PIXEL_ON  =  1,
    PIXEL_XOR =  2

} LcdPixelMode;


void lcd_init(void);
void lcd_contrast(unsigned char contrast);
void lcd_clear(void);
void LcdClear(void);
void lcd_clear_area(unsigned char line, unsigned char startX, unsigned char endX);
void lcd_clear_line(unsigned char line);
void lcd_goto_xy(unsigned char x, unsigned char y);
void lcd_goto_xy_exact(unsigned char x, unsigned char y);
void lcd_chr(char chr);
void lcd_str(char* str);
//
void nokia_printchar(char cvar);
void nokia_printstr(char* str);
void lcd_chr_inv(char chr);	

void lcd_plot(char xnokia, char plot_value8);
void lcd_write_data_inv(char bytefornokia_data_inv);
void lcd_print_lowbatdegree(void);
void lcd_image(unsigned char *imageData);
void lcd_update (void);
uint8_t lcd_pixel(uint8_t x, uint8_t y, LcdPixelMode mode);
uint8_t lcd_line (uint8_t x1, uint8_t x2, uint8_t y1, uint8_t y2, LcdPixelMode mode );
void lcd_circle(char x, char y, char radius, LcdPixelMode mode)	;
#endif



