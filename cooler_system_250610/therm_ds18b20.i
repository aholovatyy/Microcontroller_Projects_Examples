//#include <stdio.h>
// CodeVisionAVR C Compiler
// (C) 1998-2000 Pavel Haiduc, HP InfoTech S.R.L.
#pragma used+
#pragma used+
#pragma used+
void delay_us(unsigned int n);
void delay_ms(unsigned int n);
#pragma used-
/*#ifndef F_CPU
	#define F_CPU 8000000UL 		// ������� ��������� ���������� � �� (8 ��� ���)
#endif

#define LOOP_CYCLES 8 				// ����� ����� ���������� ��� ��������� �����
#define us(num) (num/(LOOP_CYCLES*(1/(F_CPU/1000000.0))))
#define ms(num) (num/(LOOP_CYCLES*(1/(F_CPU/1000.0))))        */
/* ������ ������ ������ ����������� DS18B20 */
/* ��������� */
typedef char int8_t;
typedef unsigned char uint8_t;
typedef unsigned int uint16_t;
/* ��������� ��� ���������� RAM */
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
/* ������� ��� ����������� ������������ */
//void therm_delay(uint16_t delay);
uint8_t therm_reset(void);
void therm_write_bit(uint8_t bit);
uint8_t therm_read_bit(void);
uint8_t therm_read_byte(void);
void therm_write_byte(uint8_t byte);
/* ������� ���������� ���������� ���� */
uint8_t therm_crc8(unsigned char *data, unsigned char num_bytes);
/* ������� ����������� ������� ����������� */
uint8_t therm_init(uint8_t sensor_id, int8_t temp_low, int8_t temp_high, uint8_t resolution);
/* ������� ���������� ����������� � ������ */
//uint8_t therm_read_temp_indoor(float *indoor_temp);
//uint8_t therm_read_temp_outdoor(float *outdoor_temp);
//uint8_t therm_read_temperature(float *temp);
uint8_t therm_read_temperature(uint8_t sensor_id, float *temp);
struct __ds18b20_scratch_pad_struct __ds18b20_scratch_pad;
uint8_t therm_dq;
void therm_input_mode(void) 
{
	DDRC	 &=~(1<<therm_dq);
}
void therm_output_mode(void)
{ 
	DDRC	 |=(1<<therm_dq);
}
void therm_low(void)
{ 
	PORTC &=~(1<<therm_dq);
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
	//�������� �������� �� ��� � ������ ���������� 480 ��� ������
	i=(PINC  & (1<<therm_dq));
	//therm_delay(us(420));
	delay_us(420);
	if ((PINC  & (1<<therm_dq))==i) return 1;
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
	//���� ������ 1, ��������� ���� (���� 0 ������� � ���� ���. 0)
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
	if (PINC &(1<<therm_dq)) _bit=1;
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
	//���������� ����� sensor_id
	if (sensor_id) therm_dq=0 ;
    else therm_dq=1  ;
	if (therm_reset()) return 1;
	therm_write_byte(0xcc);	
	therm_write_byte(0x4e);
	therm_write_byte(temp_high);
	therm_write_byte(temp_low);
	therm_write_byte(resolution);
	therm_reset();
	therm_write_byte(0xcc);	
	therm_write_byte(0x48);	
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
	 	if (sensor_id) therm_dq=0 ;
    else therm_dq=1  ; 
	//�������, ���������� ��������� �������� �������� ������ ROM � ������ ���������� � ������������ �����������
	if (therm_reset()) return 1;
	therm_write_byte(0xcc);
	therm_write_byte(0x44);
	//������ �� ��������� ������������
	while(!therm_read_bit());	
	//�������, ���������� ROM � �������� ������� ���������� Scratchpad
	therm_reset();
	therm_write_byte(0xcc);	
	therm_write_byte(0xbe);
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
