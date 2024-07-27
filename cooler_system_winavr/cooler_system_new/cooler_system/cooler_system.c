#include <avr/io.h> 
#include "lcd_lib.h"
#include "therm_ds18b20.h"

#ifndef F_CPU
	#define F_CPU 8000000UL 	//частота тактового генератора в Гц (8 МГц тут)
#endif

#define T_IN_FAN_ON 22     		//внутрішня температура вмикання FAN
#define T_IN_FAN_OFF 20			//внутрішня температура вимикання FAN
#define T_OUT_FAN_OFF 26		//зовнішня температура виключення FAN

#define T_OUT_SHU_OFF_MAX 26	//максимальна зовнішня температура закриття заслонки
#define T_OUT_SHU_OFF_MIN 10	//мінімальна зовнішня температура закриття заслонки 

#define T_IN_COM_ON_MAX 26		//максимальна внутрішня температура включення кондиціонера 
#define T_IN_COM_ON_MIN 10		//мінімальна внутрішня температура включення кондиціонера 
#define T_OUT_COM_ON 10			//зовнішня температура включення кондиціонера

#define DDR(x) (*(&x - 1))

//кнопка виводу інфо. на дисплей
#define BTN_PORT PORTB
#define BTN_PIN PINB
#define BTN 1
//світлодіод на кнопку виводу інфо. 
#define BTN_LED_PORT PORTD
#define BTN_LED 6 
//алярмова кнопка
#define T_ALARM 32
#define ALRM_BTN_PORT PORTB
#define ALRM_BTN_PIN PINB  
#define ALRM_BTN 0
//вентилятор 
#define FAN_PORT PORTD
#define FAN 3
#define LED_FAN 0
//заслонка
#define SHU_PORT PORTD
#define SHU 4
#define LED_SHU 1
//кондиціонер
#define COM_PORT PORTD
#define COM 5
#define LED_COM 2

uint8_t fan=0;
float tin=0.0f, tout=0.0f; 

//робочий алгоритм роботи COOLER SYSTEM
void working_algorithm(void)
{
	//управління FAN
	if (tout>T_OUT_FAN_OFF)
	{ 
		FAN_PORT&=~(1<<FAN)&~(1<<LED_FAN); 
		fan=0;
	}
	else if (fan==0 && tin>=T_IN_FAN_ON)
		 { 
			FAN_PORT|=1<<FAN|1<<LED_FAN; 
			fan=1;
		 }
	else if (fan==1 && tin<=T_IN_FAN_OFF)
		 {
			FAN_PORT&=~(1<<FAN)&~(1<<LED_FAN); 
			fan=0;
		 }
	//управління заслонкою
	if (tout>=T_OUT_SHU_OFF_MAX) 
		SHU_PORT|=1<<SHU|1<<LED_SHU; //shu=1; заслонка закрита
    else if (tout<=T_OUT_SHU_OFF_MIN)
		SHU_PORT|=1<<SHU|1<<LED_SHU; //shu=1;
	else 
	  SHU_PORT&=~(1<<SHU)&~(1<<LED_SHU); //shu=0;	
	//управління кондиціонером
    if (tin>=T_IN_COM_ON_MAX)      
		COM_PORT|=1<<COM|1<<LED_COM; //com=1;
	else if(tin<=T_IN_COM_ON_MIN)
		COM_PORT|=1<<COM|1<<LED_COM; //com=1;
	else if(tout<T_OUT_COM_ON)
        COM_PORT|=1<<COM|1<<LED_COM; //com=1;
	else 	
	  COM_PORT&=~(1<<COM)&~(1<<LED_COM); //com=0;
}
  
//алярмовий алгоритм роботи COOLER SYSTEM
void alarm_algorithm(void)
{
	//управління FAN
	if (tout>T_ALARM)          
	{ 
		FAN_PORT&=~(1<<FAN);
		FAN_PORT&=~(1<<LED_FAN); 
		fan=0;
	}
	else if (fan==0 && tin>=T_IN_FAN_ON)
		 { 
			FAN_PORT|=1<<FAN|1<<LED_FAN; 
			fan=1;
		 }
	else if (fan==1 && tin<=T_IN_FAN_OFF)
		 {
			FAN_PORT&=~(1<<FAN)&~(1<<LED_FAN); 
			fan=0;
		 }
    //управління заслонкою 
	if (tout>=T_ALARM)      
		SHU_PORT|=1<<SHU|1<<LED_SHU; //shu=1; //заслонка закрита
	else if (tout<=T_OUT_SHU_OFF_MIN)
		SHU_PORT|=1<<SHU|1<<LED_SHU; //shu=1;
	else 
	  SHU_PORT&=~(1<<SHU)&~(1<<LED_SHU);//shu=0;
    LCDclr();
    LCDGotoXY(3,0);
    LCDstring("ALARM 220V");  
}


int main(void)
{
	char title[]="COOLER SYSTEM";
	char firm[]="INTEGRAL";
	char lcd_buffer[5][33];
	uint8_t button_pressed=0, alarmBtnState=0;
    uint8_t i=0;//, flag;

	sprintf(lcd_buffer[1], "FAN T1=%d T2=%d\nT3=%d", T_OUT_FAN_OFF, T_IN_FAN_ON, T_IN_FAN_OFF);
	sprintf(lcd_buffer[2], "SHU T4=%d T5=%d", T_OUT_SHU_OFF_MAX, T_OUT_SHU_OFF_MIN);
	sprintf(lcd_buffer[3], "CON T6=%d T7=%d\nT8=%d", T_IN_COM_ON_MAX, T_IN_COM_ON_MIN, T_OUT_COM_ON); 
	sprintf(lcd_buffer[4], "ALARM T9=%d", T_ALARM);
	//ініціалізація кнопок
	//PORTB=0x03;
	//DDRB=0xFC;
    BTN_PORT|=(1<<BTN_PIN);
	DDR(BTN_PORT)&=~(1<<BTN_PIN);
	ALRM_BTN_PORT|=(1<<ALRM_BTN_PIN);
	DDR(ALRM_BTN_PORT)&=~(1<<ALRM_BTN_PIN); 
	//ініціалізація управляючих пристроїв
	//DDRD=0xFF;
	//PORTD=0x00;  
	DDR(FAN_PORT)|=(1<<FAN)|(1<<LED_FAN);
	FAN_PORT=0;
	DDR(SHU_PORT)|=(1<<SHU)|(1<<LED_SHU);
	SHU_PORT=0;
	DDR(COM_PORT)|=(1<<COM)|(1<<LED_COM);
	COM_PORT=0;
	DDR(BTN_LED_PORT)|=(1<<BTN_LED);
	BTN_PORT=0;
	//ініціалізація давачів температури
	therm_init(0, -55, 125, THERM_9BIT_RES);
	therm_init(1, -55, 125, THERM_9BIT_RES);  
	//ініціалізація LCD 
	LCDinit(); 
	LCDcursorOFF();
	LCDclr();	 
	//вивід на LCD COOLER SYSTEM i INTEGRAL
	LCDGotoXY(2,0);
	LCDstring(title);
	_delay_ms(1000);
	LCDclr();
	LCDGotoXY(4,0);
	LCDcursorOnBlink();
	LCDstring(firm);
	_delay_ms(1000);
	LCDclr(); 
	LCDcursorOFF();	
	while(1)
	{
		//flag=1;
		//міряємо температуру з давачів  
		while(therm_read_temperature(0,&tin)) 
		{
			//LCDblank();
			//LCDvisible();
			//LCDhome();
			FAN_PORT&=~(1<<FAN)&~(1<<LED_FAN);
			fan=0;
			SHU_PORT|=1<<SHU|1<<LED_SHU; 
			COM_PORT|=1<<COM|1<<LED_COM;
			//if (flag) 
			//{ 
			 //LCDclr();
			 LCDhome();
			// flag=0;
			 LCDstring("Error\nIndoor sensor");
			//}
		}   
		while(therm_read_temperature(1,&tout))
		{
			FAN_PORT&=~(1<<FAN)&~(1<<LED_FAN);
			fan=0;
			SHU_PORT|=1<<SHU|1<<LED_SHU; 
			COM_PORT|=1<<COM|1<<LED_COM;
			//LCDclr();
			//LCDhome();
			//if (flag) 
			//{ 
			// LCDclr();
			 LCDhome();
			// flag=0;
			 LCDstring("Error\nOutdoor sensor");
			//}
		}   
		//перевіряємо чи ненатиснута алярмова кнопка   
		if ((ALRM_BTN_PIN & 1<<ALRM_BTN)==0 && alarmBtnState==0)
			alarmBtnState=1; 
		if ((ALRM_BTN_PIN & 1<<ALRM_BTN))
			alarmBtnState=0;
		if (!alarmBtnState)
		{
			//перевіряємо чи ненатиснута кнопка виводу інфо. на дисплей
			if ((BTN_PIN & 1<<BTN)==0 && button_pressed==0)
			{
				_delay_ms(1);
				LCDclr();	
				if (i>3) i=0;
				else i++;
				BTN_LED_PORT|=(1<<BTN_LED);
				button_pressed=1;
			}  
			//перевіряємо чи відпущена кнопка виводу інфо. на дисплей
			if ((BTN_PIN & 1<<BTN))
			{
				BTN_LED_PORT&=~(1<<BTN_LED);
				button_pressed=0;
			}
			//виконання робочого алгоритму
			working_algorithm();
			
			if (i==0)
			  sprintf(lcd_buffer[0], "Indoor: %+.1f%cC\nOutdoor: %+.1f%cC", (double)tin, 0xdf, (double)tout, 0xdf);   
			//LCDClrs();
			LCDhome();
			LCDstring(lcd_buffer[i]);  
		}
		else
			alarm_algorithm(); 		 
     
 }
 return 0;
}

