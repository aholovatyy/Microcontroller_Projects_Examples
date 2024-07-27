#include "therm_ds18b20.h"


void therm_delay(uint16_t delay)
{
	while (delay--) asm volatile("nop");
}

uint8_t therm_reset()
{
	uint8_t i;
	//�������� ������� �������� ��������� 480 ���
	THERM_LOW();
	THERM_OUTPUT_MODE();
	therm_delay(us(480));
	//��������� ���� � ������ 60 ��� �� �������
	THERM_INPUT_MODE();
	therm_delay(us(60));
	//�������� �������� �� ��� � ������ ���������� 480 ��� ������
	i=(THERM_PIN & (1<<THERM_DQ));
	therm_delay(us(420));
	if ((THERM_PIN & (1<<THERM_DQ))==i) return 1;
	//��������� ��������� ��������� (presence pulse) (0=OK, 1=WRONG)
	return 0;
}

void therm_write_bit(uint8_t bit)
{
	//���������� ���� � ���� ���. 0 �� 1 ���
	THERM_LOW();
	THERM_OUTPUT_MODE();
	therm_delay(us(1));
	//���� ������ 1, ��������� ���� (���� 0 ������� � ���� ���. 0)
	if (bit) THERM_INPUT_MODE();
	//������ 60��� � ��������� ����
	therm_delay(us(60));
	THERM_INPUT_MODE();
}

uint8_t therm_read_bit(void)
{
	uint8_t bit=0;
	//���������� ���� � ���. 0 �� 1 ���
	THERM_LOW();
	THERM_OUTPUT_MODE();
	therm_delay(us(1));
	//��������� ���� � ������ 14 ���
	THERM_INPUT_MODE();
	therm_delay(us(14));
	//������ �� � ����
	if (THERM_PIN&(1<<THERM_DQ)) bit=1;
	//������ 45 ��� �� ��������� � ������� ��������� ��������
	therm_delay(us(45));
	return bit;
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

uint8_t therm_init(int8_t temp_low, int8_t temp_high, uint8_t resolution)
{
	resolution=(resolution<<5)|0x1f;
	//���������� �����	
	if (therm_reset()) return 1;
	therm_write_byte(THERM_CMD_SKIPROM);	
	therm_write_byte(THERM_CMD_WSCRATCHPAD);
	therm_write_byte(temp_high);
	therm_write_byte(temp_low);
	therm_write_byte(resolution);
	therm_reset();
	therm_write_byte(THERM_CMD_SKIPROM);	
	therm_write_byte(THERM_CMD_CPYSCRATCHPAD);
	therm_delay(ms(15));	
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

uint8_t therm_read_temperature(float *temp)
{
	uint8_t digit, decimal, resolution, sign;
	uint16_t meas, bit_mask[4]={0x0008, 0x000c, 0x000e, 0x000f};
 
	//�������, ���������� ��������� �������� �������� ������ ROM � ������ ���������� � ������������ �����������
	if (therm_reset()) return 1;
	therm_write_byte(THERM_CMD_SKIPROM);
	therm_write_byte(THERM_CMD_CONVERTTEMP);
	//������ �� ��������� ������������
	//if (!therm_read_bit()) return 1;
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