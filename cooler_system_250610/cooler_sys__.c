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

#include <mega32.h>
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
#include <stdio.h>
#include <delay.h>
#include <lcd.h> // ������� LCD
#include "therm_ds18b20.h"

/*#ifndef F_CPU
	#define F_CPU 8000000UL 	//������� ��������� ���������� � �� (8 ��� ���)
#endif*/

/*
#define T_IN_FAN_ON 22     		//�������� ����������� �������� FAN
#define T_IN_FAN_OFF 20			//�������� ����������� ��������� FAN
#define T_OUT_FAN_OFF 26		//�������� ����������� ���������� FAN

#define T_OUT_SHU_OFF_MAX 26	//����������� �������� ����������� �������� ��������
#define T_OUT_SHU_OFF_MIN 10	//��������� �������� ����������� �������� ��������

#define T_IN_CON_ON_MAX 26		//����������� �������� ����������� ��������� ������������
#define T_IN_CON_ON_MIN 10		//��������� �������� ����������� ��������� ������������
#define T_OUT_CON_ON 10			//�������� ����������� ��������� ������������
*/

//������ exit/mode change
#define BTN_PORT PORTB
#define BTN_PORT_DDR DDRB
#define BTN_PIN PINB
#define BTN 1
//�������� �� ������ exit/mode change
#define BTN_LED_PORT PORTD
#define BTN_LED_PORT_DDR DDRD
#define BTN_LED 6
//�������� ������
#define T_ALARM 37
#define ALRM_BTN_PORT PORTB
#define ALRM_BTN_PORT_DDR DDRB
#define ALRM_BTN_PIN PINB
#define ALRM_BTN 0
//����������
#define FAN_PORT PORTD
#define FAN_PORT_DDR DDRD
#define FAN 3
#define LED_FAN 0
//��������
#define SHU_PORT PORTD
#define SHU_PORT_DDR DDRD
#define SHU 4
#define LED_SHU 1
//�����������
#define CON_PORT PORTD
#define CON_PORT_DDR DDRD
#define CON 5
#define LED_CON 2
#define COND_PORT PORTC
#define COND_PORT_DDR DDRC
#define COND 6
#define NORMAL 7
//������ ��������� MENU/ENTER, SELECT+, SELECT-
#define BTNS_PORT PORTC
#define BTNS_PORT_DDR DDRC
#define MENU_ENTER_BTN 3
#define SELECT_PLUS_BTN 4
#define SELECT_MINUS_BTN 5

#asm
    .equ __lcd_port=0x1b // ���� ��������� LCD, PORTA
#endasm

#define CS10   0
#define CS11   1
#define CS12   2
#define OCIE1A 4 //�� ������� ����������� ��� ���������� �������� � ��������� ������ �������� � ���. A

char /*lcd_buffer[5][33],*/ buffer[33];
uint8_t mode=0, seconds=0;
bit fan=0, con=0, alarmBtnState=0, button_pressed=0;
float tinf=0.0f, toutf=0.0f;
char tin=0, tout=0;

unsigned char PREV_PINC=0xff;

char temp[]={
    26, /* T_OUT_FAN_OFF �������� ����������� ���������� FAN */
    22, /* T_IN_FAN_ON �������� ����������� �������� FAN */
    20, /* T_IN_FAN_OFF �������� ����������� ��������� FAN */
    26, /* T_OUT_SHU_OFF_MAX ����������� �������� ����������� �������� �������� */
    10, /* T_OUT_SHU_OFF_MIN ��������� �������� ����������� �������� �������� */
    26, /* T_IN_CON_ON_MAX ����������� �������� ����������� ��������� ������������ */
    10, /* T_IN_CON_ON_MIN ��������� �������� ����������� ��������� ������������ */
    10, /* T_OUT_CON_ON �������� ����������� ��������� ������������ */
    37  /* T_ALARM ������� ����������� ���������� ����������� (FAN) � �������� (SHU) */
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

    if (get_key_status(SELECT_PLUS_BTN))  //select+
    {
      if (!get_prev_key_status(SELECT_PLUS_BTN))
      {
        if (t<60)
          t++;
      }
    }

    if (get_key_status(SELECT_MINUS_BTN)) //select-
    {
      if (!get_prev_key_status(SELECT_MINUS_BTN))
      {
        if (t>10)
          t--;
      }
    }

    if (get_key_status(MENU_ENTER_BTN)) //enter
    {
      if (!get_prev_key_status(MENU_ENTER_BTN))
      {
        if (t!=temp[sel])
          temp[sel]=t;
        if (sel==8) sel=0;
        else sel++;
        t=temp[sel];
      }
    }

    if (!(BTN_PIN & (1<<BTN))) //exit
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

    if (get_key_status(SELECT_PLUS_BTN))  //select+
    {
      if (!get_prev_key_status(SELECT_PLUS_BTN))
      {
        if (selected!=8)
          selected++;
      }
    }

    if (get_key_status(SELECT_MINUS_BTN)) //select-
    {
      if (!get_prev_key_status(SELECT_MINUS_BTN))
      {
        if (selected!=0)
          selected--;
      }
    }

    if (get_key_status(MENU_ENTER_BTN)) //enter
    {
      if (!get_prev_key_status(MENU_ENTER_BTN))
      {
        lcd_clear();
        enter_temp(selected);
      }
    }

    if (!(BTN_PIN & (1<<BTN))) //exit
    {
      button_pressed=1;
      return;
    }

  }
}

//������� �������� ������ COOLER SYSTEM
void working_algorithm(void)
{
	//��������� �������������
    if (tin >= temp[5] || tin <= temp[6] || tout <= temp[7])
    {
		CON_PORT&=~(1<<CON);
		CON_PORT|=1<<LED_CON; //con=1;
		con=1;
		SHU_PORT&=~(1<<SHU)&~(1<<LED_SHU);
		FAN_PORT&=~(1<<FAN)&~(1<<LED_FAN);
		fan=0;
	}
	else
	{
	    if (tin <= (temp[5]-2) || tout >= (temp[7]+2))
	    {
	        CON_PORT|=1<<CON;
	        CON_PORT&=~(1<<LED_CON); //con=0;
	        con=0;
	        //��������� ���������
	        if (tout >= temp[3] || tout <= temp[4])
	        {
	            SHU_PORT&=~(1<<SHU)&~(1<<LED_SHU); //shu=0; �������� �������
	            FAN_PORT&=~(1<<FAN)&~(1<<LED_FAN);
		        fan=0;
            }
	        else
	        {
	            SHU_PORT|=(1<<SHU|1<<LED_SHU); //shu=1;
	            //��������� FAN
	            if (tout >= temp[0] || (fan==1 && tin <= temp[2]))
	            {
		            FAN_PORT&=~(1<<FAN)&~(1<<LED_FAN);
		            fan=0;
	            }
	            else if (fan==0 && tin >= temp[1])
	            {
	                FAN_PORT|=1<<FAN|1<<LED_FAN;
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

//��������� �������� ������ COOLER SYSTEM
void alarm_algorithm(void)
{
	//��������� ���������
	if (tout >= temp[8] || tout <= temp[4])
	{
		SHU_PORT&=~(1<<SHU)&~(1<<LED_SHU); //shu=0; //�������� �������
		FAN_PORT&=~(1<<FAN)&~(1<<LED_FAN);
		fan=0;
	}
	else
	{
	    SHU_PORT|=1<<SHU|1<<LED_SHU; //shu=1;
	    //��������� FAN
	    if (tout > temp[8] || (fan==1 && tin <= temp[2]))
	    {
		    FAN_PORT&=~(1<<FAN)&~(1<<LED_FAN);
		    fan=0;
	    }
	    else if (fan==0 && tin >= temp[1])
	    {
	        FAN_PORT|=1<<FAN|1<<LED_FAN;
		    fan=1;
	    }
   	}
	//sprintf(lcd_buffer[0], "Tin: %+.1f%cC\nTout: %+.1f%cC", tinf, 0xdf, toutf, 0xdf);
	//lcd_clear();
	sprintf(buffer, "Tin: %+.1f%cC   \nTout: %+.1f%cC   ", tinf, 0xdf, toutf, 0xdf);
	lcd_gotoxy(0,0);
	lcd_puts(buffer);
}

//������� ������� ����������� �� �������
interrupt [TIM1_COMPA] void timer1_compa_isr(void) //����������� 1 ��� � ���.
{
	/* This interrupt service routine (ISR)*/
	TCNT1H=0;
	TCNT1L=0;
	if (++seconds>10)
	{
		TIMSK&=~(1<<OCIE1A);
		mode=0;
		BTN_LED_PORT|=(1<<BTN_LED);
		delay_ms(100);
		BTN_LED_PORT&=~(1<<BTN_LED);
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
    //char title[]="�������\n  �����������";
	char title[]="COOLER SYSTEM";
	//char firm[]="I�������";
	char firm[]="INTEGRAL";
    uint8_t meas_res_tin, meas_res_tout;

	/*sprintf(lcd_buffer[1], "FAN T1=%d T2=%d\nT3=%d         ", T_OUT_FAN_OFF, T_IN_FAN_ON, T_IN_FAN_OFF);
	sprintf(lcd_buffer[2], "SHU T4=%d T5=%d\n             ", T_OUT_SHU_OFF_MAX, T_OUT_SHU_OFF_MIN);
	sprintf(lcd_buffer[3], "CON T6=%d T7=%d\nT8=%d   ", T_IN_CON_ON_MAX, T_IN_CON_ON_MIN, T_OUT_CON_ON);
	sprintf(lcd_buffer[4], "ALARM T9=%d    \n        ", T_ALARM);
	*/

	//������������ ������
    BTN_PORT|=(1<<BTN_PIN);
	BTN_PORT_DDR&=~(1<<BTN_PIN);
	ALRM_BTN_PORT|=(1<<ALRM_BTN_PIN);
	ALRM_BTN_PORT_DDR&=~(1<<ALRM_BTN_PIN);
	//������������ ����������� ��������
	FAN_PORT_DDR|=(1<<FAN)|(1<<LED_FAN);
	FAN_PORT=0;
	SHU_PORT_DDR|=(1<<SHU)|(1<<LED_SHU);
	SHU_PORT=0;
	CON_PORT_DDR|=(1<<CON)|(1<<LED_CON);
	CON_PORT=1<<CON;
	BTNS_PORT=(1<<MENU_ENTER_BTN)|(1<<SELECT_PLUS_BTN)|(1<<SELECT_MINUS_BTN);
	BTNS_PORT_DDR&=~(1<<MENU_ENTER_BTN)&~(1<<SELECT_PLUS_BTN)&~(1<<SELECT_MINUS_BTN);
	COND_PORT_DDR|=(1<<COND)|(1<<NORMAL);
	COND_PORT|=(1<<COND)|(1<<NORMAL);
	BTN_LED_PORT_DDR|=(1<<BTN_LED);
	BTN_PORT=0;
    //������������ 16 ������ �������
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
	//������������ ��������� ����������
	//INT0: Off; INT1: Off
	GICR=0x00;
	MCUCR=0x00;
	//���������� �����������
	TIMSK&=~(1<<OCIE1A); //TIMSK=0x10;
	//Analog Comparator initialization; Analog Comparator: Off; Analog Comparator Input capture by Timer/Counter 1: Off
	ACSR=0x80;
	SFIOR=0x00;
	//���������� �����������
	#asm("sei");
	//������������ LCD
    lcd_init(16);
	//���� �� LCD COOLER SYSTEM i INTEGRAL
	lcd_gotoxy(1,0);
	lcd_puts(title);
	delay_ms(1000);
	lcd_clear();
	lcd_gotoxy(4,0);
	lcd_puts(firm);
	delay_ms(1000);
	//������������ ������� �����������
	if (therm_init(0, -55, 125, THERM_9BIT_RES))
	{
	    lcd_clear();
	    lcd_putsf("Init error\nindoor sensor");
	    FAN_PORT&=~(1<<FAN)&~(1<<LED_FAN);
	    fan=0;
	    SHU_PORT&=~(1<<SHU)&~(1<<LED_SHU);
	    CON_PORT&=~(1<<CON);
	    CON_PORT|=1<<LED_CON;
	    COND_PORT&=~(1<<COND)&~(1<<NORMAL);
	    while(1);
	}
	if (therm_init(1, -55, 125, THERM_9BIT_RES))
	{
	    lcd_clear();
	    lcd_putsf("Init error\noutdoor sensor");
	    FAN_PORT&=~(1<<FAN)&~(1<<LED_FAN);
	    fan=0;
	    SHU_PORT&=~(1<<SHU)&~(1<<LED_SHU);
	    CON_PORT&=~(1<<CON);
	    CON_PORT|=1<<LED_CON;
	    COND_PORT&=~(1<<COND)&~(1<<NORMAL);
	    while(1);
	}
	// main loop starts here
	while(1)
	{
		//���������� �� ��������� ��������
		if ((ALRM_BTN_PIN & 1<<ALRM_BTN)==0 && alarmBtnState==0)
		  alarmBtnState=1;
		if ((ALRM_BTN_PIN & 1<<ALRM_BTN) && alarmBtnState==1)
		{
		  alarmBtnState=0;
   	      lcd_gotoxy(14,0);
          lcd_putsf("  ");
		}
		//������ ����������� � �������
		meas_res_tin=therm_read_temperature(0,&tinf);
		meas_res_tout=therm_read_temperature(1,&toutf);
		if (meas_res_tin || meas_res_tout)
		{
			FAN_PORT&=~(1<<FAN)&~(1<<LED_FAN);
			fan=0;
			SHU_PORT&=~(1<<SHU)&~(1<<LED_SHU);
			CON_PORT&=~(1<<CON);
			CON_PORT|=1<<LED_CON;
			COND_PORT&=~(1<<NORMAL);
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
	                COND_PORT|=1<<NORMAL;
	                COND_PORT&=~(1<<COND);
	                //��������� ���������� ���������
		            alarm_algorithm();
	            }
	            else
			    {
			        COND_PORT|=1<<COND|1<<NORMAL;
			        //���������� �� ����������� ������ ������ ����. �� �������
			        if ((BTN_PIN & 1<<BTN)==0 && button_pressed==0)
			        {
				        //delay_ms(1);
				        TIMSK&=~(1<<OCIE1A);
				        if (mode>3) mode=0;
				        else
				        {
					        mode++;
					        TCNT1H=0;
					        TCNT1L=0;
					        seconds=0;
					        TIMSK|=(1<<OCIE1A);
				        }
				        BTN_LED_PORT|=(1<<BTN_LED);
				        button_pressed=1;
			        }
			        //���������� �� �������� ������ ������ ����. �� �������
			        if ((BTN_PIN & 1<<BTN))
			        {
				        BTN_LED_PORT&=~(1<<BTN_LED);
				        button_pressed=0;
			        }

			        if (get_key_status(MENU_ENTER_BTN)) //main menu call
                    {
                        if (!get_prev_key_status(MENU_ENTER_BTN))
                        {
                            lcd_clear();
                            show_main_menu();
                        }
                    }

			        //��������� �������� ���������
			        working_algorithm();
			    }
			}
		    else
		    {
		      COND_PORT&=~(1<<NORMAL);
		      //��������� ���������� ���������
		      alarm_algorithm();
		      print_message_alarm220();
              delay_ms(150);
		    }
	    }
 }
 //#pragma rl-
 return 0;
}
#include "therm_ds18b20.h"

struct __ds18b20_scratch_pad_struct __ds18b20_scratch_pad;
uint8_t therm_dq;

void therm_input_mode(void)
{
	THERM_DDR&=~(1<<therm_dq);
}
void therm_output_mode(void)
{
	THERM_DDR|=(1<<therm_dq);
}
void therm_low(void)
{
	THERM_PORT&=~(1<<therm_dq);
}
/*void therm_high(void)
{
	THERM_PORT|=(1<<therm_dq);
}
void therm_delay(uint16_t delay)
{
	while (delay--) #asm("nop");
}*/

uint8_t therm_reset()
{
	uint8_t i;
	//�������� ������� �������� ��������� 480 ���
	therm_low();
	therm_output_mode();
	//therm_delay(us(480));
	delay_us(480);
	//��������� ���� � ������ 60 ��� �� �������
	therm_input_mode();
	//therm_delay(us(60));
	delay_us(60);
	//�������� �������� �� ���� � ������ ���������� 480 ��� ������
	i=(THERM_PIN & (1<<therm_dq));
	//therm_delay(us(420));
	delay_us(420);
	if ((THERM_PIN & (1<<therm_dq))==i) return 1;
	//��������� ��������� ��������� (presence pulse) (0=OK, 1=WRONG)
	return 0;
}

void therm_write_bit(uint8_t _bit)
{
	//���������� ���� � ���� ���. 0 �� 1 ���
	therm_low();
	therm_output_mode();
	//therm_delay(us(1));
	delay_us(1);
	//���� ������ 1, ��������� ���� (���� 0 ������� � ����� ���. 0)
	if (_bit) therm_input_mode();
	//������ 60��� � ��������� ����
	//therm_delay(us(60));
	delay_us(60);
	therm_input_mode();
}

uint8_t therm_read_bit(void)
{
	uint8_t _bit=0;
	//���������� ���� � ���. 0 �� 1 ���
	therm_low();
	therm_output_mode();
	//therm_delay(us(1));
	delay_us(1);
	//��������� ���� � ������ 14 ���
	therm_input_mode();
	//therm_delay(us(14));
	delay_us(14);
	//������ �� � ����
	if (THERM_PIN&(1<<therm_dq)) _bit=1;
	//������ 45 ��� �� ��������� � ������� ��������� ��������
	//therm_delay(us(45));
	delay_us(45);
	return _bit;
}

uint8_t therm_read_byte(void)
{
	uint8_t i=8, n=0;
	while (i--)
	{
		//������� �� 1 ������ ������ � �������� ��������� ��������
		n>>=1;
		n|=(therm_read_bit()<<7);
	}
	return n;
}

void therm_write_byte(uint8_t byte)
{
	uint8_t i=8;
	while (i--)
	{
		//������ �������� �� � ������� �� 1 ������ ������ ��� ������ ���������� ���
		therm_write_bit(byte&1);
		byte>>=1;
	}
}

uint8_t therm_crc8(uint8_t *data, uint8_t num_bytes)
{
	uint8_t byte_ctr, cur_byte, bit_ctr, crc=0;

	for (byte_ctr=0; byte_ctr<num_bytes; byte_ctr++)
	{
		cur_byte=data[byte_ctr];
		for (bit_ctr=0; bit_ctr<8; cur_byte>>=1, bit_ctr++)
			if ((cur_byte ^ crc) & 1) crc = ((crc ^ 0x18) >> 1) | 0x80;
			else crc>>=1;
	}
	return crc;
}

uint8_t therm_init(uint8_t sensor_id, int8_t temp_low, int8_t temp_high, uint8_t resolution)
{
	resolution=(resolution<<5)|0x1f;
	//����������� ����� sensor_id
	if (sensor_id) therm_dq=OUTDOOR_THERM;
    else therm_dq=INDOOR_THERM;
	if (therm_reset()) return 1;
	therm_write_byte(THERM_CMD_SKIPROM);
	therm_write_byte(THERM_CMD_WSCRATCHPAD);
	therm_write_byte(temp_high);
	therm_write_byte(temp_low);
	therm_write_byte(resolution);
	therm_reset();
	therm_write_byte(THERM_CMD_SKIPROM);
	therm_write_byte(THERM_CMD_CPYSCRATCHPAD);
	delay_ms(15);
	return 0;
}

uint8_t therm_read_spd(void)
{
	uint8_t i=0, *p;

	p = (uint8_t*) &__ds18b20_scratch_pad;
	do
		*(p++)=therm_read_byte();
	while(++i<9);
	if (therm_crc8((uint8_t*)&__ds18b20_scratch_pad,8)!=__ds18b20_scratch_pad.crc)
		return 1;
	return 0;
}

uint8_t therm_read_temperature(uint8_t sensor_id, float *temp)
{
	uint8_t digit, decimal, resolution, sign;
	uint16_t meas, bit_mask[4]={0x0008, 0x000c, 0x000e, 0x000f};

	if (sensor_id) therm_dq=OUTDOOR_THERM;
    else therm_dq=INDOOR_THERM;
	//�������, ���������� ��������� �������� �������� ������ ROM � ������ ���������� � ������������ �����������
	if (therm_reset()) return 1;
	therm_write_byte(THERM_CMD_SKIPROM);
	therm_write_byte(THERM_CMD_CONVERTTEMP);
	//������ �� ��������� ������������
	while(!therm_read_bit());
	//�������, ���������� ROM � �������� ������� ���������� Scratchpad
	therm_reset();
	therm_write_byte(THERM_CMD_SKIPROM);
	therm_write_byte(THERM_CMD_RSCRATCHPAD);
	if (therm_read_spd()) return 1;
	therm_reset();
	resolution=(__ds18b20_scratch_pad.conf_register>>5) & 3;
    //�������� �������� � ������� ����� �����������
	meas=__ds18b20_scratch_pad.temp_lsb;  // LSB
	meas|=((uint16_t)__ds18b20_scratch_pad.temp_msb) << 8; // MSB
	//���������� �� ������� �����������
	if (meas & 0x8000)
	{
		sign=1;  //������� ������� �����������
		meas^=0xffff;  //������������ � �������
		meas++;
	}
	else sign=0;
	//�������� ���� � ������� ������� �����������
	digit=(uint8_t)(meas >> 4); //�������� ���� �������
	decimal=(uint8_t)(meas & bit_mask[resolution]);	//�������� ������� �������
	*temp=digit+decimal*0.0625;
	if (sign) *temp=-(*temp); //������� ���� ����, ���� ������� �����������
	return 0;
}
