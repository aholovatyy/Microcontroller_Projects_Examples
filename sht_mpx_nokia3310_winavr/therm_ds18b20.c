#include "therm_ds18b20.h"


void therm_delay(uint16_t delay)
{
	while (delay--) asm volatile("nop");
}

uint8_t therm_reset()
{
	uint8_t i;
	//посилаємо імпульс скидання тривалістю 480 мкс
	THERM_LOW();
	THERM_OUTPUT_MODE();
	therm_delay(us(480));
	//повертаємо шину і чекаємо 60 мкс на відповідь
	THERM_INPUT_MODE();
	therm_delay(us(60));
	//зберігаємо значення на шині і чекаємо завершення 480 мкс періода
	i=(THERM_PIN & (1<<THERM_DQ));
	therm_delay(us(420));
	if ((THERM_PIN & (1<<THERM_DQ))==i) return 1;
	//повертаємо результат виконання (presence pulse) (0=OK, 1=WRONG)
	return 0;
}

void therm_write_bit(uint8_t bit)
{
	//переводимо шину в стан лог. 0 на 1 мкс
	THERM_LOW();
	THERM_OUTPUT_MODE();
	therm_delay(us(1));
	//якщо пишемо 1, відпускаємо шину (якщо 0 тримаємо в стані лог. 0)
	if (bit) THERM_INPUT_MODE();
	//чекаємо 60мкм і відпускаємо шину
	therm_delay(us(60));
	THERM_INPUT_MODE();
}

uint8_t therm_read_bit(void)
{
	uint8_t bit=0;
	//переводимо шину в лог. 0 на 1 мкс
	THERM_LOW();
	THERM_OUTPUT_MODE();
	therm_delay(us(1));
	//відпускаємо шину і чекаємо 14 мкс
	THERM_INPUT_MODE();
	therm_delay(us(14));
	//читаємо біт з шини
	if (THERM_PIN&(1<<THERM_DQ)) bit=1;
	//чекаємо 45 мкс до закінчення і вертаємо прочитане значення
	therm_delay(us(45));
	return bit;
}

uint8_t therm_read_byte(void)
{
	uint8_t i=8, n=0;
	while (i--)
	{
		//зсуваємо на 1 розряд вправо і зберігаємо прочитане значення
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
		//пишемо молодший біт і зсуваємо на 1 розряд вправо для виводу наступного біта
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
	//ініціалізуємо давач	
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
 
	//скинути, пропустити процедуру перевірки серійного номера ROM і почати вимірювання і перетворення температури
	if (therm_reset()) return 1;
	therm_write_byte(THERM_CMD_SKIPROM);
	therm_write_byte(THERM_CMD_CONVERTTEMP);
	//чекаємо до закінчення перетворення
	//if (!therm_read_bit()) return 1;
	while(!therm_read_bit());	
	//скидаємо, пропускаємо ROM і посилаємо команду зчитування Scratchpad
	therm_reset();
	therm_write_byte(THERM_CMD_SKIPROM);	
	therm_write_byte(THERM_CMD_RSCRATCHPAD);
	if (therm_read_spd()) return 1;
	therm_reset();
	resolution=(__ds18b20_scratch_pad.conf_register>>5) & 3;
    //отримуємо молодший і старший байти температури
	meas=__ds18b20_scratch_pad.temp_lsb;  // LSB
	meas|=((uint16_t)__ds18b20_scratch_pad.temp_msb) << 8; // MSB	
	//перевіряємо на мінусову температуру 
	if (meas & 0x8000) 
	{
		sign=1;  //відмічаємо мінусову температуру
		meas^=0xffff;  //перетворюємо в плюсову
		meas++;
	}
	else sign=0;
	//зберігаємо цілу і дробову частини температури
	digit=(uint8_t)(meas >> 4); //зберігаємо цілу частину 
	decimal=(uint8_t)(meas & bit_mask[resolution]);	//отримуємо дробову частину
	*temp=digit+decimal*0.0625;	
	if (sign) *temp=-(*temp); //ставемо знак мінус, якщо мінусова температура 
	return 0;
}