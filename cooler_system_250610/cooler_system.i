/*****************************************************
Project : COOLER SYSTEM
Version : version 2.1 developed in CodeVisionAVR v1.25.8
Date    : 25.06.2010
Author  : Ihor Holovatyy                          
Company : INTEGRAL                            
Comments: this program is used for cooler system designed on the base of AVR ATmega32 microcontroller 

Chip type           : ATmega32
Program type        : Application
Clock frequency     : 8,000000 MHz
Memory model        : Small
External SRAM size  : 0
Data Stack size     : 512
*****************************************************/
// CodeVisionAVR C Compiler
// (C) 1998-2004 Pavel Haiduc, HP InfoTech S.R.L.
// I/O registers definitions for the ATmega32
#pragma used+
#pragma used+
sfrb TWBR=0;
sfrb TWSR=1;
sfrb TWAR=2;
sfrb TWDR=3;
sfrb ADCL=4;
sfrb ADCH=5;
sfrw ADCW=4;      // 16 bit access
sfrb ADCSRA=6;
sfrb ADCSR=6;     // for compatibility with older code
sfrb ADMUX=7;
sfrb ACSR=8;
sfrb UBRRL=9;
sfrb UCSRB=0xa;
sfrb UCSRA=0xb;
sfrb UDR=0xc;
sfrb SPCR=0xd;
sfrb SPSR=0xe;
sfrb SPDR=0xf;
sfrb PIND=0x10;
sfrb DDRD=0x11;
sfrb PORTD=0x12;
sfrb PINC=0x13;
sfrb DDRC=0x14;
sfrb PORTC=0x15;
sfrb PINB=0x16;
sfrb DDRB=0x17;
sfrb PORTB=0x18;
sfrb PINA=0x19;
sfrb DDRA=0x1a;
sfrb PORTA=0x1b;
sfrb EECR=0x1c;
sfrb EEDR=0x1d;
sfrb EEARL=0x1e;
sfrb EEARH=0x1f;
sfrw EEAR=0x1e;   // 16 bit access
sfrb UBRRH=0x20;
sfrb UCSRC=0X20;
sfrb WDTCR=0x21;
sfrb ASSR=0x22;
sfrb OCR2=0x23;
sfrb TCNT2=0x24;
sfrb TCCR2=0x25;
sfrb ICR1L=0x26;
sfrb ICR1H=0x27;
sfrb OCR1BL=0x28;
sfrb OCR1BH=0x29;
sfrw OCR1B=0x28;  // 16 bit access
sfrb OCR1AL=0x2a;
sfrb OCR1AH=0x2b;
sfrw OCR1A=0x2a;  // 16 bit access
sfrb TCNT1L=0x2c;
sfrb TCNT1H=0x2d;
sfrw TCNT1=0x2c;  // 16 bit access
sfrb TCCR1B=0x2e;
sfrb TCCR1A=0x2f;
sfrb SFIOR=0x30;
sfrb OSCCAL=0x31;
sfrb TCNT0=0x32;
sfrb TCCR0=0x33;
sfrb MCUCSR=0x34;
sfrb MCUCR=0x35;
sfrb TWCR=0x36;
sfrb SPMCR=0x37;
sfrb TIFR=0x38;
sfrb TIMSK=0x39;
sfrb GIFR=0x3a;
sfrb GICR=0x3b;
sfrb OCR0=0X3c;
sfrb SPL=0x3d;
sfrb SPH=0x3e;
sfrb SREG=0x3f;
#pragma used-
// Interrupt vectors definitions
// Needed by the power management functions (sleep.h)
#asm
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
#endasm
// CodeVisionAVR C Compiler
// (C) 1998-2006 Pavel Haiduc, HP InfoTech S.R.L.
// Prototypes for standard I/O functions
// CodeVisionAVR C Compiler
// (C) 1998-2002 Pavel Haiduc, HP InfoTech S.R.L.
// Variable length argument list macros
typedef char *va_list;
typedef char *va_list;
typedef char *va_list;
#pragma used+
char getchar(void);
void putchar(char c);
void puts(char *str);
void putsf(char flash *str);
char *gets(char *str,unsigned int len);
void printf(char flash *fmtstr,...);
void sprintf(char *str, char flash *fmtstr,...);
void snprintf(char *str, unsigned int size, char flash *fmtstr,...);
void vprintf (char flash * fmtstr, va_list argptr);
void vsprintf (char *str, char flash * fmtstr, va_list argptr);
void vsnprintf (char *str, unsigned int size, char flash * fmtstr, va_list argptr);
signed char scanf(char flash *fmtstr,...);
signed char sscanf(char *str, char flash *fmtstr,...);
                                               #pragma used-
#pragma library stdio.lib
// CodeVisionAVR C Compiler
// (C) 1998-2000 Pavel Haiduc, HP InfoTech S.R.L.
#pragma used+
#pragma used+
void delay_us(unsigned int n);
void delay_ms(unsigned int n);
#pragma used-
/* LCD driver routines

  CodeVisionAVR C Compiler
  (C) 1998-2003 Pavel Haiduc, HP InfoTech S.R.L.

  BEFORE #include -ING THIS FILE YOU
  MUST DECLARE THE I/O ADDRESS OF THE
  DATA REGISTER OF THE PORT AT WHICH
  THE LCD IS CONNECTED!

  EXAMPLE FOR PORTB:

    #asm
        .equ __lcd_port=0x12
    #endasm
    #include <lcd.h>

*/
#pragma used+
#pragma used+
void _lcd_ready(void);
void _lcd_write_data(unsigned char data);
// write a byte to the LCD character generator or display RAM
void lcd_write_byte(unsigned char addr, unsigned char data);
// read a byte from the LCD character generator or display RAM
unsigned char lcd_read_byte(unsigned char addr);
// set the LCD display position  x=0..39 y=0..3
void lcd_gotoxy(unsigned char x, unsigned char y);
// clear the LCD
void lcd_clear(void);
void lcd_putchar(char c);
// write the string str located in SRAM to the LCD
void lcd_puts(char *str);
// write the string str located in FLASH to the LCD
void lcd_putsf(char flash *str);
// initialize the LCD controller
unsigned char lcd_init(unsigned char lcd_columns);
#pragma used-
#pragma library lcd.lib
//#include <stdio.h>
// CodeVisionAVR C Compiler
// (C) 1998-2000 Pavel Haiduc, HP InfoTech S.R.L.
/*#ifndef F_CPU
	#define F_CPU 8000000UL 		// частота тактового генератора в Гц (8 МГц тут)
#endif

#define LOOP_CYCLES 8 				// число тактів необхідних для виконання циклу
#define us(num) (num/(LOOP_CYCLES*(1/(F_CPU/1000000.0))))
#define ms(num) (num/(LOOP_CYCLES*(1/(F_CPU/1000.0))))        */
/* список команд давача температури DS18B20 */
/* константи */
typedef char int8_t;
typedef char int8_t;
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
void therm_write_bit(uint8_t bit);
uint8_t therm_read_bit(void);
uint8_t therm_read_byte(void);
void therm_write_byte(uint8_t byte);
/* функція обчислення контрольної суми */
uint8_t therm_crc8(unsigned char *data, unsigned char num_bytes);
/* функція ініціалізація давачів температури */
uint8_t therm_init(uint8_t sensor_id, int8_t temp_low, int8_t temp_high, uint8_t resolution);
/* функція зчитування температури з давача */
//uint8_t therm_read_temp_indoor(float *indoor_temp);
//uint8_t therm_read_temp_outdoor(float *outdoor_temp);
//uint8_t therm_read_temperature(float *temp);
uint8_t therm_read_temperature(uint8_t sensor_id, float *temp);
/*#ifndef F_CPU
	#define F_CPU 8000000UL 	//частота тактового генератора в Гц (8 МГц тут)
#endif*/
/*
#define T_IN_FAN_ON 22     		//внутрішня температура вмикання FAN
#define T_IN_FAN_OFF 20			//внутрішня температура вимикання FAN
#define T_OUT_FAN_OFF 26		//зовнішня температура виключення FAN

#define T_OUT_SHU_OFF_MAX 26	//максимальна зовнішня температура закриття заслонки
#define T_OUT_SHU_OFF_MIN 10	//мінімальна зовнішня температура закриття заслонки 

#define T_IN_CON_ON_MAX 26		//максимальна внутрішня температура включення кондиціонера 
#define T_IN_CON_ON_MIN 10		//мінімальна внутрішня температура включення кондиціонера 
#define T_OUT_CON_ON 10			//зовнішня температура включення кондиціонера
*/
//кнопка exit/mode change
//світлодіод на кнопку exit/mode change 
//алярмова кнопка
//вентилятор 
//заслонка
//кондиціонер
//кнопки настройки MENU/ENTER, SELECT+, SELECT-
          #asm
    .equ __lcd_port=0x1b // порт піключення LCD, PORTA
#endasm
         char /*lcd_buffer[5][33],*/ buffer[33];
uint8_t mode=0, seconds=0;
bit fan=0, con=0, alarmBtnState=0, button_pressed=0; 
float tinf=0.0f, toutf=0.0f; 
char tin=0, tout=0;
unsigned char PREV_PINC=0xff;
char temp[]={ 
    26, /* T_OUT_FAN_OFF зовнішня температура виключення FAN */
    22, /* T_IN_FAN_ON внутрішня температура вмикання FAN */
    20, /* T_IN_FAN_OFF внутрішня температура вимикання FAN */
    26, /* T_OUT_SHU_OFF_MAX максимальна зовнішня температура закриття заслонки */
    10, /* T_OUT_SHU_OFF_MIN мінімальна зовнішня температура закриття заслонки */ 
    26, /* T_IN_CON_ON_MAX максимальна внутрішня температура включення кондиціонера */
    10, /* T_IN_CON_ON_MIN мінімальна внутрішня температура включення кондиціонера */
    10, /* T_OUT_CON_ON зовнішня температура включення кондиціонера */
    37  /* T_ALARM аварійна температура виключення вентилятора (FAN) і заслонки (SHU) */
}; // temperatures
unsigned char get_key_status(unsigned char key)
{
  return (!(PINC & (1<<key)));  
}
unsigned char get_prev_key_status(unsigned char key)
{
  return (!(PREV_PINC & (1<<key)));  
}
  void enter_temp(int sel)
{
  char items[9][10]={"FAN T1=", "FAN T2=", "FAN T3=", "SHU T4=", "SHU T5=", "CON T6=", "CON T7=", "CON T8=", "ALARM T9="};
  char t=temp[sel];
      while(1)
  {
    PREV_PINC=PINC;
        lcd_gotoxy(0,0);    
    lcd_puts(items[sel]);
    lcd_putchar((48+t/10));
    lcd_putchar((48+t%10));
    lcd_putsf("   ");    
    delay_ms(50);    
        if (get_key_status(4))  //select+
    {  
      if (!get_prev_key_status(4))
      {            
        if (t<60)
          t++;
      }
    }
        if (get_key_status(5)) //select-
    {  
      if (!get_prev_key_status(5))
      {    
        if (t>10)
          t--;
      }
    }             
        if (get_key_status(3)) //enter
    {  
      if (!get_prev_key_status(3))
      {                       
        if (t!=temp[sel])
          temp[sel]=t;
        if (sel==8) sel=0;
        else sel++;
        t=temp[sel]; 
      } 
    }   
        if (!(PINB & (1<<1))) //exit    
      return;   
                       }
}
void show_main_menu(void)
{
  char menu_items[9][3]={"T1", "T2", "T3", "T4", "T5", "T6", "T7", "T8", "T9"};
  int selected=0;
  lcd_gotoxy(3,0);
  lcd_putsf("MAIN MENU");  
    while(1)
  {
    PREV_PINC=PINC;   
    lcd_gotoxy(7,1);
    lcd_puts(menu_items[selected]);
    delay_ms(50);   
        if (get_key_status(4))  //select+
    {  
      if (!get_prev_key_status(4))
      {                
        if (selected!=8)
          selected++;
      }
    }   
        if (get_key_status(5)) //select-
    {  
      if (!get_prev_key_status(5))
      {                   
        if (selected!=0)
          selected--;
      }
    }     
                 if (get_key_status(3)) //enter
    {  
      if (!get_prev_key_status(3))
      {
        lcd_clear();        
        enter_temp(selected); 
      }
    }      
      if (!(PINB & (1<<1))) //exit
    {
      button_pressed=1;
      return;
    }        
      }
}
 //робочий алгоритм роботи COOLER SYSTEM
void working_algorithm(void)
{
	//управління кондиціонером
    if (tin >= temp[5] || tin <= temp[6] || tout <= temp[7])
    {      
		PORTD&=~(1<<5);
		PORTD|=1<<2; //con=1;		
		con=1;
		PORTD&=~(1<<4)&~(1<<1);
		PORTD&=~(1<<3)&~(1<<0); 
		fan=0;    		
	}
	else 	
	{
	    if (tin <= (temp[5]-2) || tout >= (temp[7]+2))
	    {
	        PORTD|=1<<5;
	        PORTD&=~(1<<2); //con=0;	    
	        con=0;
	        //управління заслонкою
	        if (tout >= temp[3] || tout <= temp[4])  
	        {
	            PORTD&=~(1<<4)&~(1<<1); //shu=0; заслонка закрита
	            PORTD&=~(1<<3)&~(1<<0); 
		        fan=0;
            } 
	        else
	        { 
	            PORTD|=(1<<4|1<<1); //shu=1;
	            //управління FAN
	            if (tout >= temp[0] || (fan==1 && tin <= temp[2]))
	            {    
		            PORTD&=~(1<<3)&~(1<<0); 
		            fan=0;
	            }
	            else if (fan==0 && tin >= temp[1])
	            { 
	                PORTD|=1<<3|1<<0; 
		            fan=1;
	            } 
	         }
	    }	 
	}  	
   /* if (i==0)
	  sprintf(lcd_buffer[0], "Tin: %+.1f%cC   \nTout: %+.1f%cC   ", tinf, 0xdf, toutf, 0xdf);   
	lcd_gotoxy(0,0); 			
	lcd_puts(lcd_buffer[i]); */
	switch (mode)
	{
	  case 0: sprintf(buffer, "Tin: %+.1f%cC    \nTout: %+.1f%cC   ", tinf, 0xdf, toutf, 0xdf); break; 
	  case 1: sprintf(buffer, "FAN T1=%d T2=%d\nT3=%d         ", temp[0], temp[1], temp[2]); break;
	  case 2: sprintf(buffer, "SHU T4=%d T5=%d\n             ", temp[3], temp[4]); break;
	  case 3: sprintf(buffer, "CON T6=%d T7=%d\nT8=%d   ", temp[5], temp[6], temp[7]); break;
	  case 4: sprintf(buffer, "ALARM T9=%d    \n        ", temp[8]); break;
	} 
	lcd_gotoxy(0,0); 			
	lcd_puts(buffer); 
}
  //алярмовий алгоритм роботи COOLER SYSTEM
void alarm_algorithm(void)
{
	//управління заслонкою 
	if (tout >= temp[8] || tout <= temp[4])
	{      
		PORTD&=~(1<<4)&~(1<<1); //shu=0; //заслонка закрита
		PORTD&=~(1<<3)&~(1<<0); 
		fan=0;	
	}
	else
	{ 
	    PORTD|=1<<4|1<<1; //shu=1; 
	    //управління FAN
	    if (tout > temp[8] || (fan==1 && tin <= temp[2]))          
	    { 
		    PORTD&=~(1<<3)&~(1<<0); 
		    fan=0;
	    }
	    else if (fan==0 && tin >= temp[1])
	    { 
	        PORTD|=1<<3|1<<0; 
		    fan=1;
	    }   
   	} 
	//sprintf(lcd_buffer[0], "Tin: %+.1f%cC\nTout: %+.1f%cC", tinf, 0xdf, toutf, 0xdf); 
	//lcd_clear(); 			
	sprintf(buffer, "Tin: %+.1f%cC   \nTout: %+.1f%cC   ", tinf, 0xdf, toutf, 0xdf);   
	lcd_gotoxy(0,0); 	
	lcd_puts(buffer); 	           
}
//функція обробки переривання від таймера   
interrupt [8] void timer1_compa_isr(void) //переривання 1 раз в сек.   
{
	/* This interrupt service routine (ISR)*/  
	TCNT1H=0;
	TCNT1L=0; 
	if (++seconds>10)
	{ 
		TIMSK&=~(1<<4 ); 
		mode=0;
		PORTD|=(1<<6 );
		delay_ms(100);
		PORTD&=~(1<<6 );			
	}
}              
void print_message_alarm220(void)
{
  static bit ac=0;
  lcd_gotoxy(14,0);
  if (ac)
  {       
    lcd_putsf("  "); 
    ac=0;		
  }   
  else
  { 
    lcd_putsf("AC"); // AC ERROR 220V
    ac=1;
  }    	    		
}
//#pragma rl+   
// Declare your global variables here
int main(void)
{
    //char title[]="СИСТЕМА\n  ОХОЛОДЖЕННЯ";
	char title[]="COOLER SYSTEM";
	//char firm[]="IНТЕГРАЛ";
	char firm[]="INTEGRAL";	   	 
    uint8_t meas_res_tin, meas_res_tout;
    	/*sprintf(lcd_buffer[1], "FAN T1=%d T2=%d\nT3=%d         ", T_OUT_FAN_OFF, T_IN_FAN_ON, T_IN_FAN_OFF);
	sprintf(lcd_buffer[2], "SHU T4=%d T5=%d\n             ", T_OUT_SHU_OFF_MAX, T_OUT_SHU_OFF_MIN);
	sprintf(lcd_buffer[3], "CON T6=%d T7=%d\nT8=%d   ", T_IN_CON_ON_MAX, T_IN_CON_ON_MIN, T_OUT_CON_ON); 
	sprintf(lcd_buffer[4], "ALARM T9=%d    \n        ", T_ALARM);
	*/
		//ініціалізація кнопок
    PORTB|=(1<<PINB);
	DDRB&=~(1<<PINB);
	PORTB |=(1<<PINB  );
	DDRB &=~(1<<PINB  ); 
	//ініціалізація управляючих пристроїв
	DDRD|=(1<<3)|(1<<0);
	PORTD=0;
	DDRD|=(1<<4)|(1<<1);
	PORTD=0;
	DDRD|=(1<<5)|(1<<2);
	PORTD=1<<5;         	
	PORTC=(1<<3)|(1<<4)|(1<<5);
	DDRC&=~(1<<3)&~(1<<4)&~(1<<5);  	
	DDRC|=(1<<6)|(1<<7); 		
	PORTC|=(1<<6)|(1<<7);		
	DDRD|=(1<<6 );
	PORTB=0;  
    //ініціалізація 16 бітного таймера
	TCCR1A=0x00;
	TCCR1B=0x04; //1<<CS12|~(1<<CS11)|~(1<<CS10);  //clk/256, 8MHz/256=31250Hz, TCCR1B=0x04 
	TCNT1H=0x00; 
	TCNT1L=0x00;
	ICR1H=0x00;
	ICR1L=0x00;
	OCR1AH=0x7A; //high byte of 31250=7A, high byte has to be written before low byte
	OCR1AL=0x12; //low byte of 31250=12 
	OCR1BH=0x00;
	OCR1BL=0x00;  
	//ініціалізація зовнішніх переривань 
	//INT0: Off; INT1: Off
	GICR=0x00;
	MCUCR=0x00; 
	//маскування переривання 
	TIMSK&=~(1<<4 ); //TIMSK=0x10; 	
	//Analog Comparator initialization; Analog Comparator: Off; Analog Comparator Input capture by Timer/Counter 1: Off
	ACSR=0x80; 
	SFIOR=0x00; 
	//дозволяємо переривання 
	#asm("sei");    	
	//ініціалізація LCD  	
    lcd_init(16); 
	//вивід на LCD COOLER SYSTEM i INTEGRAL	 
	lcd_gotoxy(1,0);
	lcd_puts(title);
	delay_ms(1000);
	lcd_clear();
	lcd_gotoxy(4,0);
	lcd_puts(firm);
	delay_ms(1000);
	//ініціалізація давачів температури	
	if (therm_init(0, -55, 125, 0	))
	{                                   
	    lcd_clear(); 
	    lcd_putsf("Init error\nindoor sensor");
	    PORTD&=~(1<<3)&~(1<<0);
	    fan=0;             	    
	    PORTD&=~(1<<4)&~(1<<1);
	    PORTD&=~(1<<5);
	    PORTD|=1<<2;	    
	    PORTC&=~(1<<6)&~(1<<7);
	    while(1);   
	}
	if (therm_init(1, -55, 125, 0	))
	{
	    lcd_clear(); 
	    lcd_putsf("Init error\noutdoor sensor");
	    PORTD&=~(1<<3)&~(1<<0);
	    fan=0;  	   
	    PORTD&=~(1<<4)&~(1<<1);	    
	    PORTD&=~(1<<5);
	    PORTD|=1<<2; 
	    PORTC&=~(1<<6)&~(1<<7);
	    while(1);  
	}   
	// main loop starts here
	while(1)
	{
		//перевіряємо чи непропало живлення   
		if ((PINB   & 1<<0)==0 && alarmBtnState==0)		   
		  alarmBtnState=1;                 		  
		if ((PINB   & 1<<0) && alarmBtnState==1) 
		{
		  alarmBtnState=0;
   	      lcd_gotoxy(14,0);
          lcd_putsf("  ");	
		}	
		//міряємо температуру з давачів                                                 
		meas_res_tin=therm_read_temperature(0,&tinf); 
		meas_res_tout=therm_read_temperature(1,&toutf);
		if (meas_res_tin || meas_res_tout) 
		{
			PORTD&=~(1<<3)&~(1<<0);
			fan=0;
			PORTD&=~(1<<4)&~(1<<1); 
			PORTD&=~(1<<5);
			PORTD|=1<<2;
			PORTC&=~(1<<7);			
			lcd_clear();			                 			
			if (meas_res_tin && meas_res_tout) 
		        lcd_putsf("Tin error\nTout error");
			else 
			{
			    if (meas_res_tin)
			      sprintf(buffer, "Tin error\nTout: %+.1f%cC", toutf, 0xdf);
			    else if (meas_res_tout)
			      sprintf(buffer, "Tin: %+.1f%cC\nTout error", tinf, 0xdf);
			    lcd_puts(buffer);     
			}		
			if (alarmBtnState)
			  print_message_alarm220();
			delay_ms(200);			
		}   		
	    else
		{         
		    if ((tinf-tin!=0.5) && (tinf-tin!=-0.5))
		        tin=(int)tinf; 
		    if ((toutf-tout!=0.5) && (toutf-tout!=-0.5))		
		        tout=(int)toutf;          		    	
			if (!alarmBtnState)
			{		  
			    if ((tin-temp[5] >= 2) && con==1)
			    {
	                PORTC|=1<<7;
	                PORTC&=~(1<<6);
	                //виконання алярмового алгоритму
		            alarm_algorithm();
	            }
	            else 
			    {
			        PORTC|=1<<6|1<<7;
			        //перевіряємо чи ненатиснута кнопка виводу інфо. на дисплей
			        if ((PINB & 1<<1)==0 && button_pressed==0)
			        {
				        //delay_ms(1);
				        TIMSK&=~(1<<4 );  				
				        if (mode>3) mode=0;
				        else 
				        {
					        mode++;
					        TCNT1H=0;
					        TCNT1L=0;		
					        seconds=0; 	
					        TIMSK|=(1<<4 );					
				        }
				        PORTD|=(1<<6 );
				        button_pressed=1;
			        }  
			        //перевіряємо чи відпущена кнопка виводу інфо. на дисплей
			        if ((PINB & 1<<1))
			        {
				        PORTD&=~(1<<6 );
				        button_pressed=0;
			        }  
			        			        if (get_key_status(3)) //main menu call
                    {  
                        if (!get_prev_key_status(3))
                        {
                            lcd_clear();                            
                            show_main_menu(); 
                        }
                    }      
			        			        //виконання робочого алгоритму
			        working_algorithm();
			    } 
			}			       			 				    
		    else        
		    { 
		      PORTC&=~(1<<7);
		      //виконання алярмового алгоритму
		      alarm_algorithm();		     
		      print_message_alarm220();
              delay_ms(150);			  	        			  		    
		    }
	    } 		      
 }     
 //#pragma rl-    
 return 0;
}
