/* LCD driver routines

  CodeVisionAVR C Compiler
  (C) 1998-2007 Pavel Haiduc, HP InfoTech S.R.L.
*/

__asm__ volatile (
    .equ __lcd_direction=__lcd_port-1
    .equ __lcd_pin=__lcd_port-2
    .equ __lcd_rs=0
    .equ __lcd_rd=1
    .equ __lcd_enable=2
    .equ __lcd_busy_flag=7
);


static unsigned char _base_y[4]={0x80,0xc0};
unsigned char _lcd_x,_lcd_y,_lcd_maxx;


static void _lcd_delay(void)
{
	__asm__ volatile (
			"ldi   r31,15" "\n\t"
			"__lcd_delay0:"
			"dec   r31" "\n\t"
			"brne  __lcd_delay0"
	);
}

void _lcd_ready(void)
{
	__asm__ volatile (
		"in    r26,__lcd_direction" "\n\t"
		"andi  r26,0xf  ;set as input" "\n\t"
		"out   __lcd_direction,r26" "\n\t"
		"sbi   __lcd_port,__lcd_rd ;RD=1" "\n\t"
		"cbi   __lcd_port,__lcd_rs ;RS=0" "\n\t"
	"__lcd_busy:"
	);
	_lcd_delay();
	__asm__ volatile (
		"sbi   __lcd_port,__lcd_enable ;EN=1" "\n\t"
	);
	_lcd_delay();
	__asm__ volatile (
		"in    r26,__lcd_pin" "\n\t"
		"cbi   __lcd_port,__lcd_enable ;EN=0" "\n\t"
	);
	_lcd_delay();
	__asm__ volatile (
		"sbi   __lcd_port,__lcd_enable ;EN=1" "\n\t"
	);
	_lcd_delay();
	__asm__ volatile (
		"cbi   __lcd_port,__lcd_enable ;EN=0" "\n\t"
		"sbrc  r26,__lcd_busy_flag"
		"rjmp  __lcd_busy"
	);
}

static void _lcd_write_nibble(void)
{
	__asm__ volatile (
		"andi  r26,0xf0" "\n\t"
		"or    r26,r27" "\n\t"
		"out   __lcd_port,r26          ;write" "\n\t"
		"sbi   __lcd_port,__lcd_enable ;EN=1" "\n\t"
	);
	_lcd_delay();
	__asm__ volatile (
		"cbi   __lcd_port,__lcd_enable ;EN=0" "\n\t"
	);
	_lcd_delay();
}

void _lcd_write_data(unsigned char data)
{
	__asm__ volatile (
		"cbi  __lcd_port,__lcd_rd 	  ;RD=0" "\n\t"
		"in    r26,__lcd_direction" "\n\t"
		"ori   r26,0xf0 | (1<<__lcd_rs) | (1<<__lcd_rd) | (1<<__lcd_enable) ;set as output" "\n\t"    
		"out   __lcd_direction,r26" "\n\t"
		"in    r27,__lcd_port" "\n\t"
		"andi  r27,0xf" "\n\t"
		"ld    r26,y" "\n\t"
	);
    _lcd_write_nibble();           //RD=0, write MSN
	__asm__ volatile (
		"ld    r26,y" "\n\t"
		"swap  r26" "\n\t"
	);
    _lcd_write_nibble();           //write LSN
	__asm__ volatile (
		"sbi   __lcd_port,__lcd_rd     ;RD=1" "\n\t"
	);
}

/* write a byte to the LCD character generator or display RAM */
void lcd_write_byte(unsigned char addr, unsigned char data)
{
	_lcd_ready();
	_lcd_write_data(addr);
	_lcd_ready();
	__asm__ volatile (
		"sbi   __lcd_port,__lcd_rs     ;RS=1" "\n\t"
	);
	_lcd_write_data(data);
}

static void _lcd_read_nibble(void)
{
	__asm__ volatile (
		"sbi   __lcd_port,__lcd_enable ;EN=1" "\n\t"
	);
	_lcd_delay();
	__asm__ (
		"in    r30,__lcd_pin           ;read" "\n\t"
		"cbi   __lcd_port,__lcd_enable ;EN=0" "\n\t"
	);
	_lcd_delay();
	__asm__ volatile (
		"andi  r30,0xf0" "\n\t"
	);
}

static unsigned char lcd_read_byte0(void)
{
	_lcd_delay();
	_lcd_read_nibble();           // read MSN
	__asm__ volatile (
		"mov   r26,r30" "\n\t"
	);
	_lcd_read_nibble();           // read LSN
	__asm__ volatile (
		"cbi   __lcd_port,__lcd_rd     ;RD=0" "\n\t"
		"swap  r30" "\n\t"
		"or    r30,r26" "\n\t"
	);
}

/* read a byte from the LCD character generator or display RAM */
unsigned char lcd_read_byte(unsigned char addr)
{
	_lcd_ready();
	_lcd_write_data(addr);
	_lcd_ready();
	__asm__ volatile (
		"in    r26,__lcd_direction" "\n\t"
		"andi  r26,0xf                 ;set as input" "\n\t"
		"out   __lcd_direction,r26" "\n\t"
		"sbi   __lcd_port,__lcd_rs     ;RS=1" "\n\t"
	);
	return lcd_read_byte0();
}

/* set the LCD display position x=0..39 y=0..3 */
void lcd_gotoxy(unsigned char x, unsigned char y)
{
	_lcd_ready(); // RS=0
	_lcd_write_data(_base_y[y]+x);
	_lcd_x=x;
	_lcd_y=y;
}

// clear the LCD
void lcd_clear(void)
{
	_lcd_ready();         // RS=0
	_lcd_write_data(2);   // cursor home
	_lcd_ready();
	_lcd_write_data(0xc); // cursor off
	_lcd_ready();
	_lcd_write_data(1);   // clear
	_lcd_x=_lcd_y=0;
}

void lcd_putchar(char c)
{
	__asm__ volatile (
		"push r30" "\n\t"
		"push r31" "\n\t"
		"ld   r26,y" "\n\t"
		"set" "\n\t"
		"cpi  r26,10" "\n\t"
		"breq __lcd_putchar1" "\n\t"
		"clt" "\n\t"
	);
	++_lcd_x;
	if (_lcd_x>_lcd_maxx)
	{
		__asm__ ("__lcd_putchar1:");
		++_lcd_y;
		lcd_gotoxy(0,_lcd_y);
		__asm__ ("brts __lcd_putchar0");
	};
	__asm__ volatile (
		"rcall __lcd_ready" "\n\t"
		"sbi  __lcd_port,__lcd_rs ;RS=1" "\n\t"
		"ld   r26,y" "\n\t"
		"st   -y,r26" "\n\t"
		"rcall __lcd_write_data" "\n\t"
		"__lcd_putchar0:" "\n\t"
		"pop  r31" "\n\t"
		"pop  r30" "\n\t"
	);
}

// write the string str located in SRAM to the LCD
void lcd_puts(char *str)
{
	char k;
	while (k=*str++) lcd_putchar(k);
}

// write the string str located in FLASH to the LCD
void lcd_putsf(char flash *str)
{
	char k;
	while (k=*str++) lcd_putchar(k);
}

static void _long_delay(void)
{
	__asm__ volatile (
		"clr   r26" "\n\t"
		"clr   r27" "\n\t"
	"__long_delay0:" "\n\t"
		"sbiw  r26,1         ;2 cycles" "\n\t"
		"brne  __long_delay0 ;2 cycles" "\n\t"
	);
}

static void _lcd_init_write(unsigned char data)
{
	__asm__ volatile (
		"cbi  __lcd_port,__lcd_rd 	  ;RD=0" "\n\t"
		"in    r26,__lcd_direction" "\n\t"
		"ori   r26,0xf7                ;set as output" "\n\t"
		"out   __lcd_direction,r26" "\n\t"
		"in    r27,__lcd_port" "\n\t"
		"andi  r27,0xf" "\n\t"
		"ld    r26,y" "\n\t"
	);
    _lcd_write_nibble();           //RD=0, write MSN
	__asm__ (
		"sbi   __lcd_port,__lcd_rd     ;RD=1"
	);
}

// initialize the LCD controller
unsigned char lcd_init(unsigned char lcd_columns)
{
	__asm__ volatile (
		"cbi   __lcd_port,__lcd_enable ;EN=0" "\n\t"
		"cbi   __lcd_port,__lcd_rs     ;RS=0" "\n\t"
	);
	_lcd_maxx=lcd_columns;
	_base_y[2]=lcd_columns+0x80;
	_base_y[3]=lcd_columns+0xc0;
	_long_delay();
	_lcd_init_write(0x30);
	_long_delay();
	_lcd_init_write(0x30);
	_long_delay();
	_lcd_init_write(0x30);
	_long_delay();
	_lcd_init_write(0x20);
	_long_delay();
	_lcd_write_data(0x28);
	_long_delay();
	_lcd_write_data(4);
	_long_delay();
	_lcd_write_data(0x85);
	_long_delay();
	__asm__ volatile (
		"in    r26,__lcd_direction" "\n\t"
		"andi  r26,0xf                 ;set as input" "\n\t"
		"out   __lcd_direction,r26"
		"sbi   __lcd_port,__lcd_rd     ;RD=1" "\n\t"
	);
	if (lcd_read_byte0()!=5) return 0;
		_lcd_ready();
		_lcd_write_data(6);
		lcd_clear();
	return 1;
}
