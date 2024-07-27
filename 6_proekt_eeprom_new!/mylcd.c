#pragma used+

 //��������� �������
 //��������������� ����������   
 
 
#define RS PORTC.5     //  LCD  
#define E  PORTC.6     //  LCD 

#define D4 PORTA.0     //  LCD  data
#define D5 PORTA.1     //  LCD  data
#define D6 PORTA.2     //  LCD  data
#define D7 PORTA.3     //  LCD  data
 
 void lcd_cmd (unsigned char c);
 void lcd_strobe (void);
 void lcd_write (unsigned char c);   
 void lcd_putchar (unsigned char c);
 void lcd_cmd (unsigned char c);
 void lcd_clear (void);
 void lcd_putsf(unsigned char __flash *str);
 void lcd_puts(unsigned char *str); 
 void lcd_gotoxy(unsigned char x, unsigned char y);
 void lcd_init (void);
 void cursor_on (void); 
 void cursor_off (void); 
 
  //���������� ������� ( ����������� )
 //������� ����� ����������� � ������ ������ �� ������ ������� � ����� �������
 void lcd_strobe (void) //������� ������������� �� �� ������ E
{
E=1;
delay_ms(2);
E=0;
}   

//������� ������� ���� �� ������ D4-D7, ���� ������� �� ��� �����, 
//������� ���������� ������� �������, ����� - �������
void lcd_write (unsigned char c){
if(c&0x10) D4=1; else D4=0;
if(c&0x20) D5=1; else D5=0;
if(c&0x40) D6=1; else D6=0;
if(c&0x80) D7=1; else D7=0;
lcd_strobe();
delay_ms(5);
if(c&0x1) D4=1; else D4=0;
if(c&0x2) D5=1; else D5=0;
if(c&0x4) D6=1; else D6=0;
if(c&0x8) D7=1; else D7=0;
lcd_strobe();
delay_ms(5);
}

void lcd_putchar (unsigned char c){
RS=1;
lcd_write(c);
}

void lcd_cmd (unsigned char c){
RS=0;
lcd_write(c);
}

void lcd_clear (void){
RS=0;
lcd_write(0x01);
delay_ms(5);
}

//���� �� LCD info � FLASH-�����
void lcd_putsf(unsigned char __flash *str)
{
unsigned char Count=0;

while (str[Count]!=0x00)
  {
  lcd_putchar(str[Count]);
  Count++;
  }
}

void lcd_puts(unsigned char *str)
{
unsigned char Count=0;

while (str[Count]!=0x00)
  {
  lcd_putchar(str[Count]);
  Count++;
  }
}


void lcd_gotoxy(unsigned char x, unsigned char y)
{
unsigned char Temp;

   Temp=0x80;
   if(y==1) Temp=0xc0;
   lcd_cmd (Temp+x);
}

void lcd_init (void){
//������������� �������� � 4-� ������� �������. ��� ���� ������� ��� 0010.
delay_ms(25);//��������� ����� �� ����� 15��
RS=0;//�������� �������
D7=0;
D6=0;
D5=1;
D4=0;
lcd_strobe();
delay_ms(5);
D7=0;
D6=0;
D5=1;
D4=0;
lcd_strobe();
delay_ms(5);
D7=0;
D6=0;
D5=1;
D4=0;
lcd_strobe();
delay_ms(5);
lcd_cmd(0x28);
delay_ms(5);
lcd_cmd(0x01);
delay_ms(5);
lcd_cmd(0x0C);
}

void   cursor_on (void) 
 { 
   RS=0;
   lcd_cmd(0x0E); // ������!
 }

void cursor_off (void) 
 { 
    RS=0;
    lcd_cmd(0x0C); 
 }



 #pragma used-
