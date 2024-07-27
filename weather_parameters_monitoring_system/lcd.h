
#include<avr/io.h>
#include<util/delay.h>

//The pins used are same as explained earlier
#define lcd_port   PORTA


//LCD Registers addresses
#define LCD_RS      0x01
#define LCD_RW      0x02
#define LCD_EN      0x08


void lcd_reset(void)
{
        lcd_port = 0xFF;
        _delay_ms(20);
        lcd_port = 0x30+LCD_EN;
        lcd_port = 0x30;
        _delay_ms(10);
        lcd_port = 0x30+LCD_EN;
        lcd_port = 0x30;
        _delay_ms(1);
        lcd_port = 0x30+LCD_EN;
        lcd_port = 0x30;
        _delay_ms(1);
        lcd_port = 0x20+LCD_EN;
        lcd_port = 0x20;
        _delay_ms(1);
}
void lcd_cmd (char cmd)
{
        lcd_port = (cmd & 0xF0)|LCD_EN;
        lcd_port = (cmd & 0xF0);
		
        lcd_port = ((cmd << 4) & 0xF0)|LCD_EN;
        lcd_port = ((cmd << 4) & 0xF0);

      

        _delay_ms(2);
        _delay_ms(2);
}

void lcd_init (void)
{
        lcd_reset();         // Call LCD reset
        lcd_cmd(0x28);       // 4-bit mode - 2 line - 5x7 font.
        lcd_cmd(0x0C);       // Display no cursor - no blink.
        lcd_cmd(0x06);       // Automatic Increment - No Display shift.
        lcd_cmd(0x80);       // Address DDRAM with 0 offset 80h.
 }


void lcd_data (unsigned char dat)
{
        lcd_port = ((dat & 0xF0)|LCD_EN|LCD_RS);
        lcd_port = ((dat & 0xF0)|LCD_RS);
		
		lcd_port = (((dat << 4) & 0xF0)|LCD_EN|LCD_RS);
        lcd_port = (((dat << 4) & 0xF0)|LCD_RS);
       
      

       _delay_ms(2);
       _delay_ms(2);
}
void lcd_puts(char *aaa)
{
unsigned int i;
for(i=0;aaa[i]!=0;i++)
lcd_data(aaa[i]);

}