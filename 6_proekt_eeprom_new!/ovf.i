/*****************************************************
CodeWizardAVR V1.25.8 Professional

Project :  PWM_LED & ADC
Chip type           : ATmega128
Clock frequency     : 3,680000 MHz
*****************************************************/
// CodeVisionAVR C Compiler
// (C) 1998-2004 Pavel Haiduc, HP InfoTech S.R.L.
// I/O registers definitions for the ATmega128
#pragma used+
#pragma used+
sfrb PINF=0;
sfrb PINE=1;
sfrb DDRE=2;
sfrb PORTE=3;
sfrb ADCL=4;
sfrb ADCH=5;
sfrw ADCW=4;      // 16 bit access
sfrb ADCSRA=6;
sfrb ADMUX=7;
sfrb ACSR=8;
sfrb UBRR0L=9;
sfrb UCSR0B=0xa;
sfrb UCSR0A=0xb;
sfrb UDR0=0xc;
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
sfrb SFIOR=0x20;
sfrb WDTCR=0x21;
sfrb OCDR=0x22;
sfrb OCR2=0x23;
sfrb TCNT2=0x24;
sfrb TCCR2=0x25;
sfrb ICR1L=0x26;
sfrb ICR1H=0x27;
sfrw ICR1=0x26;   // 16 bit access
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
sfrb ASSR=0x30;
sfrb OCR0=0x31;
sfrb TCNT0=0x32;
sfrb TCCR0=0x33;
sfrb MCUCSR=0x34;
sfrb MCUCR=0x35;
sfrb TIFR=0x36;
sfrb TIMSK=0x37;
sfrb EIFR=0x38;
sfrb EIMSK=0x39;
sfrb EICRB=0x3a;
sfrb RAMPZ=0x3b;
sfrb XDIV=0x3c;
sfrb SPL=0x3d;
sfrb SPH=0x3e;
sfrb SREG=0x3f;
#pragma used-
// Interrupt vectors definitions
// Needed by the power management functions (sleep.h)
#asm
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
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
#pragma used+
#pragma used+
 //прототипы функций
 //предварительное объявление   
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
   //реализация функций ( определение )
 //функции можно распологать и делать вызовы из других функций в любом порядке
 void lcd_strobe (void) //Функция стробирования на на выводе E
{
PORTC.6     =1;
delay_ms(2);
PORTC.6     =0;
}   
//Функция посылки кода на выводы D4-D7, байт делется на две части, 
//сначала передается старшая тетрада, потом - младшая
void lcd_write (unsigned char c){
if(c&0x10) PORTA.0     =1; else PORTA.0     =0;
if(c&0x20) PORTA.1     =1; else PORTA.1     =0;
if(c&0x40) PORTA.2     =1; else PORTA.2     =0;
if(c&0x80) PORTA.3     =1; else PORTA.3     =0;
lcd_strobe();
delay_ms(5);
if(c&0x1) PORTA.0     =1; else PORTA.0     =0;
if(c&0x2) PORTA.1     =1; else PORTA.1     =0;
if(c&0x4) PORTA.2     =1; else PORTA.2     =0;
if(c&0x8) PORTA.3     =1; else PORTA.3     =0;
lcd_strobe();
delay_ms(5);
}
void lcd_putchar (unsigned char c){
PORTC.5     =1;
lcd_write(c);
}
void lcd_cmd (unsigned char c){
PORTC.5     =0;
lcd_write(c);
}
void lcd_clear (void){
PORTC.5     =0;
lcd_write(0x01);
delay_ms(5);
}
//Вивід на LCD info з FLASH-памяті
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
//Инициализация диспелея в 4-х битовом режимею. Три раза выводим код 0010.
delay_ms(25);//Выдержуем паузу не менее 15мс
PORTC.5     =0;//Передача команды
PORTA.3     =0;
PORTA.2     =0;
PORTA.1     =1;
PORTA.0     =0;
lcd_strobe();
delay_ms(5);
PORTA.3     =0;
PORTA.2     =0;
PORTA.1     =1;
PORTA.0     =0;
lcd_strobe();
delay_ms(5);
PORTA.3     =0;
PORTA.2     =0;
PORTA.1     =1;
PORTA.0     =0;
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
   PORTC.5     =0;
   lcd_cmd(0x0E); // курсор!
 }
void cursor_off (void) 
 { 
    PORTC.5     =0;
    lcd_cmd(0x0C); 
 }
 #pragma used-
 //налаштування АЦП
                                                       //кнопки  MENU/ENTER, SELECT+, SELECT-, ESC/EXIT
// Declare your global variables here     
unsigned char k, PREV_PINF = 0xff;                         // menu 1111 1111
unsigned int gSelectPlusCounter=0, gSelectMinusCounter=0;  // menu cелектор        
volatile  unsigned int  hour = 0;    // частота встановлена ціле
volatile  unsigned int start_p=0;    // встановлена частота   
// eeprom float rom_fxx;      //  частота з ROM     
eeprom float   rom_fxx;      //  частота з ROM 
eeprom unsigned int   rom_speed;  //  delay з ROM - чим більше значення тим повільніше тестування
char  buffer[33];               // for LCD convertion      
char N=1; // prescaler
volatile unsigned long int  fx=0, tx=0;  // частота і період 
volatile float  fxx=22.2;  // опорна частота- можна встановити від 1... 29999 Гц
volatile unsigned char  redpwml=0,redpwmh=0, greenpwml=0,greenpwmh=0, bluepwml=0,bluepwmh=0;  // pwm , pwm_val  
volatile unsigned int ICR3top=0;     
volatile unsigned int speed=10;   // затримка в ms - чим більше значення тим повільніше тестування
              unsigned int ICR3, RedPwm, GreenPwm, BluePwm ; 
unsigned int Dred, Dgreen, Dblue;  // duty = red green blue     
unsigned int adc_in;          // змінна для ADC - код
float indication=0, tinf=0;      
char ADC_INPUT = 0x05;       // порт з якого читаємо Analog signal = PF5(ADC5)   
char vref=5;                 // опорна напруга
char od='m'  ;       
volatile unsigned char value[5] = {0, 0, 0, 0, 0};      
volatile unsigned int A0,A1,A2,A3,A4;
volatile unsigned int V0,V1,V2,V3,V4;
//  key - функція  біжучий статус клавіші  
  unsigned char get_key_status(unsigned char key)    //  key - номер клавіші  на порту
{
   return (!(PINF & (1<<key)));  
}              
// функція попередній статус клавіші  
unsigned char get_prev_key_status(unsigned char key)  // key - номер клавіші  на порту
{
  return (!(PREV_PINF & (1<<key)));  
}
// Timer 2 overflow interrupt service routine  використовується для меню!!! 
interrupt [11] void timer2_ovf_isr(void)                       
{     
    if ( get_key_status(4          ) )  // аналіз натискання клавіші SELECT+
      {
         if (gSelectPlusCounter < 300        ) 
            gSelectPlusCounter++;
       }
    else  gSelectPlusCounter = 0;
    if ( get_key_status(1          ) )  // аналіз натискання клавіші SELECT-
  {
    if (gSelectMinusCounter < 300        )
        gSelectMinusCounter++;
  }
  else gSelectMinusCounter = 0;       
}  
  // Timer 3 overflow interrupt service routine
interrupt [30] void timer3_ovf_isr(void)
{  
   (*(unsigned char *) 0x87)=redpwmh;  (*(unsigned char *) 0x86)=redpwml;     // RED  0E 5F = for 1000 hz icr3 = top
   (*(unsigned char *) 0x85)=greenpwmh;  (*(unsigned char *) 0x84)=greenpwml;     // GREEN
   (*(unsigned char *) 0x83)=bluepwmh;  (*(unsigned char *) 0x82)=bluepwml;     // BLUE  72F
 }
 // Read the AD conversion result
unsigned int read_adc(unsigned char adc_input)
{
   ADMUX=adc_input | (0x00    & 0xff);
   delay_us(10);      // Delay needed for the stabilization of the ADC input voltage
                      // Start the AD conversion
  ADCSRA|=0x40;
  // Wait for the AD conversion to complete
  while ((ADCSRA & 0x10)==0);
  ADCSRA|=0x10;
   return ADCW;
}
      void zvyk(void)
 {   
  DDRB.5=1;                  // управління звуком on/off 
  delay_ms(200);  
  DDRB.5=0;   
  delay_ms(200);  
 }
// функція меню -   set частоту до 300 гц 
unsigned int set_page(void)  
{
  unsigned char  x[4] = { 7, 8, 9, 11 }, i = 0;            // позиції символів число з 4 значень
  char time_chars[4][2] = {"^", "^", "^", "^"};  // нижній курсор - стрілка чотири позиції
  lcd_gotoxy(x[0],1);    
  lcd_puts(time_chars[0]); 
    if (hour>3000) {hour=2999;};                              //  перше "^"  - курсор нижній  
       A0 = hour;        V0=A0/1000;
   value[0]=(unsigned char)(A0/1000); // старший-перший символ зліва
   A1=A0-V0*1000;   V1= (A1/100); 
   value[1]=(unsigned char)(A1/100);  // другий символ зліва      
   A2=A1-V1*100;    V2=A2/10; 
   value[2]=(unsigned char)(A2/10);   // третій символ зліва  
   A3=A2-V2*10;     V3=A3;
   value[3]=(unsigned char)(A3);    // четвертий символ зліва      
    // value[0]= (unsigned char)hour/1000;                       // старший-перший символ зліва
 // value[1]= (hour-value[0]*1000)/100;                        // другий символ зліва
 // value[2]= ((hour-value[0]*1000-value[1]*100)/10);         // третій символ зліва
 // value[3]= hour-value[0]*1000-value[1]*100-value[2]*10;  // четвертий символ зліва  
    while (1) {
    PREV_PINF = PINF; 
    sprintf(buffer, "%u%u%u.%u", value[0], value[1], value[2], value[3]); // чотири символи для виводу
    lcd_gotoxy(x[0],0);    
    lcd_puts(buffer);             	
        if (get_key_status(4          ))             //   select+  UP ---set_page()-
      if (!get_prev_key_status(4          ) || (gSelectPlusCounter == 300        ))
      {
        if (gSelectPlusCounter == 300        ) 
          delay_ms(80);  
                   switch (i)
         {
         case 0:                                   //  ліва_старша=нульова позиція числа page значення=( 0..2)
              if (value[0] < 2)
                 value[0]++; 
              else value[0] = 0;
         break;     
                     case 1:                                  // друга позиція зліва числа page значення =( 0..9)
               if (value[1] < 9)
                   value[1]++;
               else value[1] = 0; 
         break;   
                       case 2:                                 // третя позиція зліва числа page значення =( 0..9)
              if (value[i] < 9)     
                 value[i]++;
              else value[i] = 0;
         break;  
                       case 3:             // четверта позиція зліва числа page значення =( 0..9)
                     if (value[i] < 9)
                 value[i]++;
              else value[i] = 0;  
         break;     
         }
      }         
 //-end select+  UP ---set_page()--  
        if (get_key_status(1          ))             // select-  DOWN---set_page()--
      if (!get_prev_key_status(1          ) || (gSelectMinusCounter == 300        ))
      {            
        if (gSelectMinusCounter == 300        ) 
          delay_ms(80);
        switch (i)
        {
        case 0: 
              if (value[0] > 0)
                  value[0]--; 
              else value[0] = 2;
        break;    
                    case 1:
              if (value[1] > 0)
                value[1]--;
              else value[1] = 9;                 
        break;      
                    case 2: 
              if (value[i] > 0)
                  value[i]--;
              else value[i] = 9;
        break;   
                     case 3: 
              if (value[i] > 0)
                  value[i]--;
              else value[i] = 9;     
        break; 		
        }
     }             
//-end select-  DOWN---set_page()-     
    if (get_key_status(3          ))     // enter---set_page()-
      if (!get_prev_key_status(3          ))
      {
        if (i==3)    // кількість символів числа =4
        {    
                 hour = (unsigned int)(value[0])*1000 ; //+(unsigned int)(value[1])*100); 
         hour = hour+(unsigned int)(value[1])*100;   
          hour = hour+(unsigned int)(value[2])*10;    
          hour = hour+(unsigned int)(value[3]);  
               //  hour = (int)(value[0]*1000+value[1]*100+value[2]*10+value[3]);  // номер сторінки 
           if (hour> 2999)  
             hour=2999;   
             lcd_gotoxy(x[i],1);               // затерти курсор
             lcd_putchar(' '); 
          return(hour);                        // сформоване значення
        }    
                lcd_gotoxy(x[i],1);
        lcd_putchar(' ');       
        lcd_gotoxy(x[++i],1);    
        lcd_puts(time_chars[i]);
                              }         
  //-end enter---set_page()-     
      if (get_key_status(2          ))       // exit --set_page()-
    {
      PREV_PINF = PINF;	   
      // exitflag=1;    // натиснута клавіша exit
      return;
    }                          
  }
}   
//--end exit ---set_page()-
// функція меню -   set частоту більше 300 гц 
unsigned int set_page2(void)  
{
                       // символи числа сторінки
  unsigned char   x[5] = { 7, 8, 9, 10, 11 }, i = 0;  // позиції символів число з 5 значень
  char time_chars[5][2] = {"^", "^", "^", "^","^"};  // нижній курсор - стрілка чотири позиції    
  lcd_gotoxy(x[0],1);    
  lcd_puts(time_chars[0]);       //  перше "^"  - курсор нижній    
      A0 = hour;        V0=A0/10000;
   value[0]=(unsigned char)(A0/10000); // старший-перший символ зліва
   A1=A0-V0*10000;   V1= (A1/1000); 
   value[1]=(unsigned char)(A1/1000);  // другий символ зліва      
   A2=A1-V1*1000;    V2=A2/100; 
   value[2]=(unsigned char)(A2/100);   // третій символ зліва  
   A3=A2-V2*100;     V3=A3/10;
   value[3]=(unsigned char)(A3/10);    // четвертий символ зліва           
   A4=A3-V3*10;      V4=A4;
   value[4]=(unsigned char)A4;         // молодший -п'ятий символ зліва 
   while (1) {
    PREV_PINF = PINF; 
    sprintf(buffer, "%u%u%u%u%u", value[0], value[1], value[2], value[3], value[4]); // чотири символи для виводу
    lcd_gotoxy(x[0],0);    
    lcd_puts(buffer);             	
        if (get_key_status(4          ))             //   select+  UP ---set_page()-
      if (!get_prev_key_status(4          ) || (gSelectPlusCounter == 300        ))
      {
        if (gSelectPlusCounter == 300        ) 
          delay_ms(80);  
                   switch (i)
         {
          case 0:                     // ліва_старша= перша позиція числа page значення=( 0..2)
              if (value[0] < 2)
                 value[0]++; 
              else value[0] = 0;
          break;     
                      case 1:                    // друга позиція зліва числа page значення =( 0..9)
               if (value[1] < 9)
                   value[1]++;
               else value[1] = 0; 
          break;   
                        case 2:                    // третя позиція зліва числа page значення =( 0..9)
              if (value[2] < 9)     
                 value[2]++;
              else value[2] = 0;
          break;  
                        case 3:                    // четверта позиція зліва числа page значення =( 0..9)    
              if (value[i] < 9)
                 value[i]++;
              else value[i] = 0;  
          break;  
                   case 4:                   // п'ята позиція зліва числа page значення =( 0..9)
              if (value[i] < 9)
                 value[i]++;
              else value[i] = 0;  
          break;  
         }
      }         
     //-end select+  UP ---set_page()--  
        if (get_key_status(1          ))             // select-  DOWN---set_page()--
      if (!get_prev_key_status(1          ) || (gSelectMinusCounter == 300        ))
      {            
        if (gSelectMinusCounter == 300        ) 
          delay_ms(80);
        switch (i)
        {
         case 0: 
              if (value[0] > 0)
                  value[0]--; 
              else value[0] = 2;
         break;    
                     case 1:
              if (value[1] > 0)
                value[1]--;
              else value[1] = 9;                 
         break;      
                     case 2: 
              if (value[2] > 0)
                  value[2]--;
              else value[2] = 9;
         break;   
                      case 3: 
              if (value[3] > 0)
                  value[3]--;
              else value[3] = 9;     
         break; 	   
                 case 4: 
              if (value[4] > 0)
                  value[4]--;
              else value[4] = 9;     
         break; 	   
        }
     }             
     //-end select-  DOWN---set_page()-     
    if (get_key_status(3          ))     // enter---set_page()-
      if (!get_prev_key_status(3          ))
      {
        if (i==4)    // кількість символів числа =5
        {   
          hour = (unsigned int)(value[0]*10000+value[1]*1000); 
          hour = hour+(unsigned int)(value[2])*100;    
          hour = hour+(unsigned int)(value[3])*10+(unsigned int)(value[4]);  
                if (hour>29999)  
             hour=29999;   
             lcd_gotoxy(x[i],1);               // затерти курсор
             lcd_putchar(' '); 
          return(hour);                        // сформоване значення
        }    
                lcd_gotoxy(x[i],1);
        lcd_putchar(' ');       
        lcd_gotoxy(x[++i],1);    
        lcd_puts(time_chars[i]);
      }         
      //-end enter---set_page()-      
      if (get_key_status(2          ))       // exit --set_page()-
    {
      PREV_PINF = PINF;	   
      // exitflag=1;    // натиснута клавіша exit
      return;
    }                          
  }
}   
//--end exit ---set_page()-    
// функція меню -   set speed до 999 ms 
unsigned int set_speed(void)  
{
  unsigned char  x[3] = { 7, 8, 9 }, i = 0;            // позиції символів число з 3 значень
  char time_chars[3][2] = {"^", "^", "^"};  // нижній курсор - стрілка чотири позиції
  lcd_gotoxy(x[0],1);    
  lcd_puts(time_chars[0]); 
    if (speed>=1000) {speed=999;};                 //  перше "^"  - курсор нижній  
       A0 = speed;        V0=A0/100;
   value[0]=(unsigned char)(A0/100); // старший-перший символ зліва
   A1=A0-V0*100;   V1= (A1/10); 
   value[1]=(unsigned char)(A1/10);  // другий символ зліва      
   A2=A1-V1*10;    V2=A2; 
   value[2]=(unsigned char)(A2);   // третій символ зліва  
       while (1) {
    PREV_PINF = PINF; 
    sprintf(buffer, "%u%u%u", value[0], value[1], value[2]); // три символи для виводу
    lcd_gotoxy(x[0],0);    
    lcd_puts(buffer);             	
        if (get_key_status(4          ))             //   select+  UP --- set speed -
      if (!get_prev_key_status(4          ) || (gSelectPlusCounter == 300        ))
      {
        if (gSelectPlusCounter == 300        ) 
          delay_ms(80);  
                   switch (i)
         {
         case 0:                                   //  ліва_старша=нульова позиція числа page значення=( 0..9)
              if (value[0] < 9)
                 value[0]++; 
              else value[0] = 0;
         break;     
                     case 1:                                  // друга позиція зліва числа page значення =( 0..9)
               if (value[1] < 9)
                   value[1]++;
               else value[1] = 0; 
         break;   
                       case 2:                                 // третя позиція зліва числа page значення =( 0..9)
              if (value[i] < 9)     
                 value[i]++;
              else value[i] = 0;
         break;  
                       }
      }         
 //-end select+  UP ---set speed ()--  
        if (get_key_status(1          ))             // select-  DOWN--- set speed --
      if (!get_prev_key_status(1          ) || (gSelectMinusCounter == 300        ))
      {            
        if (gSelectMinusCounter == 300        ) 
          delay_ms(80);
        switch (i)
        {
        case 0: 
              if (value[0] > 0)
                  value[0]--; 
              else value[0] = 9;
        break;    
                    case 1:
              if (value[1] > 0)
                value[1]--;
              else value[1] = 9;                 
        break;      
                    case 2: 
              if (value[i] > 0)
                  value[i]--;
              else value[i] = 9;
        break;   
                     }
     }             
//-end select-  DOWN--- set speed ()-     
    if (get_key_status(3          ))     // enter--- set speed ()-
      if (!get_prev_key_status(3          ))
      {
        if (i==2)    // кількість символів числа =3
        {    
                 speed = (unsigned int)(value[0])*100 ; 
         speed = speed +(unsigned int)(value[1])*10;   
          speed = speed +(unsigned int)(value[2]);    
                   if (speed >= 1000)  
             speed =999;   
             lcd_gotoxy(x[i],1);               // затерти курсор
             lcd_putchar(' '); 
          return(speed);                        // сформоване значення
        }    
                lcd_gotoxy(x[i],1);
        lcd_putchar(' ');       
        lcd_gotoxy(x[++i],1);    
        lcd_puts(time_chars[i]);
                              }         
  //-end enter--- set speed
      if (get_key_status(2          ))       // exit --set_page()-
    {
      PREV_PINF = PINF;	   
      return;
    }                          
  }
}   
//--end exit --- set speed
 void  Red(unsigned int  dutyr)  // функція для PWM - red
{
    RedPwm = (ICR3/100)* dutyr;   
     if (RedPwm==0) RedPwm=1;
     redpwml=(char)(RedPwm);             // Dred% pwm  RED - low byte
     redpwmh=(char)((RedPwm)>>8);   // Dred% pwm  RED - high byte 
     return;
  }      
  void  Green(unsigned  int  dutyg)   // функція для PWM - Green
{
     GreenPwm = (ICR3/100)* dutyg;   
     if (GreenPwm==0) GreenPwm=1;
     greenpwml=(char)(GreenPwm);
     greenpwmh=(char)((GreenPwm)>>8);   //  Dgreen% pwm  GREEN - high byte 
     return;
 }  
  void  Blue (unsigned  int  dutyb)   // функція для PWM - Blue
{
     BluePwm = (ICR3/100)* dutyb;   
     if (BluePwm==0) BluePwm=1;
     bluepwml=(char)(BluePwm);
     bluepwmh=(char)((BluePwm)>>8);    // Dblue% pwm  BLUE - high byte       
     return;
  }
  void test (unsigned  int  speedx)   // тестування 
   {
    unsigned char R=0, G=0, B=0;
    for (R=0; R<100; R++)      // red від 0 до 100 %
         {
             Red(R);  
             delay_ms(speedx);
          };
     for (R=99; R>0; R--)      // red від 100% до 1%
         {
             Red(R);  
             delay_ms(speedx);
          };
    for (G=0; G<100; G++)      // Green від 0 до 100 %
         {
             Green(G);  
             delay_ms(speedx);
          };
     for (G=99; G>0; G--)      // Green від 100% до 1%
         {
             Green(G);  
             delay_ms(speedx);
          };
    for (B=0; B<100; B++)      // Blue від 0 до 100 %
         {
             Blue (B);  
             delay_ms(speedx);
          };
     for (B=99; B>0; B--)      // Blue від 100% до 1%
         {
             Blue(B);  
             delay_ms(speedx);
          }; 
               for (B=0; B<100; B++)      // Red Green Blue від 0 до 100 %
         {
             Red(B);  
             Green(B);  
             Blue (B);  
             delay_ms(speedx);
          };
     for (B=99; B>0; B--)      // Red =100% Green -Blue від 100% до 1%
         {
               Green(B);  
                Blue(B);  
                delay_ms(speedx);
          };
            for (B=0; B<100; B++)      // Blue від 0 до 100 %
         {
             Blue(B);  
             delay_ms(speedx);
          };
                 for (G=0; G<100; G++)      // Green від 0 до 100 %
         {
             Green(G);  
             delay_ms(speedx);
          };      
               for (R=99; R>0; R--)      // red від 100% до 1%
         {
             Red(R);  
             delay_ms(speedx);
          };
             for (B=99; B>49; B--)      // Red =100% Green -Blue від 100% до 1%
         {
               Green(B);  
               Blue(B); 
               R=R+1; 
               Red(R);  
                delay_ms(speedx);
          };
                                         zvyk();      
                return;  
   }
void fxcalculator (void ) // функція для обчислення значень регістрів
{
 if (fxx<100)
   {
     N=64;  // для частот 1…100гц
     (*(unsigned char *) 0x8a)=0x1B;  // n=64
     ICR3top = (3680000/(fxx*N))-1;
     if (ICR3top==0) ICR3top=1;
     (*(unsigned char *) 0x81) =(char)(( ICR3top)>>8);    // - high b
     (*(unsigned char *) 0x80) =(char)( ICR3top);         // - low byte
     // ICR3H=0x01;  ICR3L=0x6f;      // 10000
    }
 else
   {
     N=1; // для частот 100…30000гц
     (*(unsigned char *) 0x8a)=0x19;    // n-prescale=1
     ICR3top= (3680000/(fxx*N))-1;
     if (ICR3top==0) ICR3top=1;
     (*(unsigned char *) 0x81) =(char)(( ICR3top)>>8);  // - high byte
     (*(unsigned char *) 0x80) =(char)( ICR3top);       // - low byte
    }
 }
 //--end fxcalculator          
   void savesetup(void)  // функція menu save_setup
  {     
     //fxx=1.2;
    rom_fxx=fxx;    // запис в ROM значення частоти
     //  tp= TMAX; 
           zvyk();  
  }
  void savespeed(void)  // функція menu save_setup
  {     
     //speed=10;        //ms
    rom_speed=speed;    // запис в ROM значення швидкості проходження тестів
     //  tp= TMAX;   
                zvyk();  
  }
   void main_menu(void)   // ГОЛОВНЕ МЕНЮ і його підменю 
{
   char *menu_items[7]=  { " SET Fx < 300Hz ", " SET Fx > 300Hz ", "SAVE SETUP", "SAVE SPEED", "SET TEST SPEED", "TEST RGB"};
   unsigned char x_pos[] = {0, 0, 3, 3, 1, 4};   // координати для items menu
   int sel=0;                                    // по замовчуванню ставити 0
    while(1)
    {
       PREV_PINF=PINF;   // кн. на порті F
       lcd_gotoxy(0,0);
       lcd_putsf("***** MENU *****");  
       lcd_gotoxy(x_pos[sel],1);
       lcd_puts(menu_items[sel]);   
       if (get_key_status(4          ))  // натиснута кл. "select+" main_menu()
        {  
          if (!get_prev_key_status(4          ) || (gSelectPlusCounter == 300        ))
           {            
             if (gSelectPlusCounter == 300        ) 
               delay_ms(80);                
             if (sel<5)       // кількість пунктів (меню - 1)
               sel++;
             else sel = 0;
             lcd_clear();
          }
        }   
       // -end "select+" - main_menu()-           
                 if (get_key_status(1          ))    // натиснута кл. "select-" main_menu()
         {  
            if (!get_prev_key_status(1          ) || (gSelectMinusCounter == 300        ))
              {            
                if (gSelectMinusCounter == 300        ) 
                   delay_ms(80);  
                if (sel>0)
                    sel--; 
                else sel = 5;   // кількість пунктів (меню - 1)
                lcd_clear(); 
             }
          }     
         // -end select(-) -main_menu()  
                     if (get_key_status(3          ))      // натиснута кл. "enter"  main_menu()
          {  
             if (!get_prev_key_status(3          ))
                {
                 //  lcd_clear();
                   switch(sel)
                     {
                       case 0:  
                          lcd_clear();             // модуль SET Fx< 300 Hz  
                          lcd_gotoxy(0,0);     
                          lcd_putsf(" Fpwm=");  
                          start_p=set_page();    
                          fxx= (float)start_p;     // значення частоти   
                          fxx=fxx/10;
                                                    fxcalculator();
                       break;                     // end модуль SET Fx 
                                                                case 1:    
                          lcd_clear();             // модуль SET Fx >300 Hz  
                          lcd_gotoxy(0,0);     
                          lcd_putsf(" Fpwm=");  
                          start_p=set_page2();  
                          fxx= (float)start_p;   // значення частоти 
                          fxcalculator();
                       break;  
                                                                  case 2: 
                         savesetup();  // записати налаштування в память     
                         lcd_clear();             // модуль SET Fx >300 Hz  
                         lcd_gotoxy(4,0); 
                         lcd_putsf("Save OK!"); 
                         delay_ms(900);          
                       break;    
                                              case 3: 
                         savespeed() ;   // записати в память значення затримки  
                         lcd_clear();             // модуль SET Fx >300 Hz  
                         lcd_gotoxy(2,0); 
                         lcd_putsf("Save speed OK!"); 
                         delay_ms(900);           
                       break;    
                                              case 4:     
                         lcd_clear();             // модуль SET Fx >300 Hz  
                         lcd_gotoxy(0,0);     
                         lcd_putsf(" DELAY=");  
                         set_speed();    
                       break;             
                                              case 5:     
                         lcd_clear();             // модуль SET Fx >300 Hz  
                         lcd_gotoxy(0,0); 
                         lcd_putsf("Testing....wait!");              
                         test (speed);
                       break;     //     вставити модуль  для п. меню  
                       default: break;    //     вставити модуль  для п. меню  
                     }
                }
           } 
           // end enter-main_menu()    
                         if (get_key_status(2          ))      // натиснута кл. "exit"  main_menu() 
             {
               if (!get_prev_key_status(2          ))
                  {
                    TIMSK&=~(1<<6);      // disable Timer 2 overflow interrupt service routine
                     return;                           // back to working mode
                   }
              }         
             //-end exit-main_menu()-
    }
 }
void main(void)
{
// Declare your local variables here
// Input/Output Ports initialization
PORTA=0x00;  DDRA=0x00;  // Port A initialization
PORTB=0x00;  DDRB=0x00;  // Port B initialization
PORTC=0x00;  DDRC=0x00;  // Port C initialization
PORTD=0x00;  DDRD=0x00;  // Port D initialization
PORTE=0x00; DDRE=0x38;   // Port- порт PE = 00111000 (pin5,6,7) {A,B,C}
(*(unsigned char *) 0x62)=0x00;  (*(unsigned char *) 0x61)=0x00;  // Port F initialization
(*(unsigned char *) 0x65)=0x00;  (*(unsigned char *) 0x64)=0x00;  // Port G initialization
// Timer/Counter 0 initialization
// Clock source: System Clock   // Clock value: Timer 0 Stopped
// Mode: Normal top=FFh    // OC0 output: Disconnected
ASSR=0x00;  TCCR0=0x00; TCNT0=0x00; OCR0=0x00;
// Timer/Counter 1 initialization
// Clock source: System Clock   // Clock value: Timer 1 Stopped
// Mode: Normal top=FFFFh
// OC1A output: Discon.  // OC1B output: Discon. // OC1C output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer 1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Interrupt: Off  Compare B  Interrupt: Off  Compare C  Interrupt: Off
TCCR1A=0x00; TCCR1B=0x00;
TCNT1H=0x00; TCNT1L=0x00;
ICR1H=0x00;  ICR1L=0x00;
OCR1AH=0x00; OCR1AL=0x00;   OCR1BH=0x00; OCR1BL=0x00;  (*(unsigned char *) 0x79)=0x00; (*(unsigned char *) 0x78)=0x00;
// Timer/Counter 1 initialization
// Clock source: System Clock
// sound - частота timer1   
TCCR1A=0x82;      // fast PWM = 14 
TCCR1B=0x19; 
TCNT1H=0x00; 
TCNT1L=0x00; 
ICR1H=0x07;        // частота 
ICR1L=0xCF;        // частота 
OCR1AH=0x03;  //  шпаруватість
OCR1AL=0xFF;   //  шпаруватість
OCR1BH=0x00; 
OCR1BL=0x00;
// Timer/Counter 2 initialization
  // Clock source: System Clock
  // Clock value: 8000.000 kHz  - корегувати!!!!!
  // Mode: Normal top=FFh
  // OC2 output: Disconnected
  TCNT2=0x00;   OCR2=0x00;    TCCR2=0x03; 
// Timer/Counter 3 initialization
// Clock source: System Clock
// Clock value: 3680,000 kHz
// Mode: Fast PWM top=ICR3
// Noise Canceler: Off
// Input Capture on Falling Edge
// OC3A output: Non-Inv.
// OC3B output: Non-Inv.
// OC3C output: Non-Inv.
// Timer 3 Overflow Interrupt: On
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
// Compare C Match Interrupt: Off
(*(unsigned char *) 0x8b)=0xAA;         
(*(unsigned char *) 0x8a)=0x19;    // n-prescale=1   TCCR3B=0x1A; // n=8
               (*(unsigned char *) 0x89)=0x00;  (*(unsigned char *) 0x88)=0x00;
// ICR3H=0x0E; ICR3L=0x5f;  // E5F = for 1000 hz  Top= ICR3 для FAST PWM mode=14   
// ICR3H=0x47;  ICR3L=0xdf;   // частота 200 Hz output  
(*(unsigned char *) 0x81)=0x8F;  (*(unsigned char *) 0x80)=0xBF;   // частота 100 Hz output    8FBF   
// ICR3H=0x01;  ICR3L=0x6f;   // 10000    
(*(unsigned char *) 0x87)=0x00; (*(unsigned char *) 0x86)=0x00;
(*(unsigned char *) 0x85)=0x00; (*(unsigned char *) 0x84)=0x00;
(*(unsigned char *) 0x83)=0x00; (*(unsigned char *) 0x82)=0x00;
// External Interrupt(s) initialization
// INT0: Off , INT1: Off, INT2: Off, INT3: Off, INT4: Off, INT5: Off, INT6: Off, INT7: Off
(*(unsigned char *) 0x6a)=0x00;  EICRB=0x00;  EIMSK=0x00;
// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x00;
(*(unsigned char *) 0x7d)=0x04;  // TIM3_OVF
// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;     SFIOR=0x00;   
DDRC = 0x60;	// Port C RC5, RC6 ->output used for LCD
DDRA = 0x0F;	// D0-D3 -> output used for LCD     
DDRA.7=1;  	// LED1 -> output used for LCD
PORTA.7=1;      // LED1=1 output used for LCD
DDRC.7=1;       // LWR/-> output used for LCD
PORTC.7=0;      // LWR/=0  output used for LCD
DDRD.2 = 1;     // SD5/-> включити живлення +5Х LCD
PORTD.2=1;      // SD5/=1 включити живлення +5Х LCD
//select reference voltage for ADC
ADMUX|=(0<<7             )|(0<<6             );    // AREF pin - опорна напруга 5в    
ADMUX=0x00    & 0xff;    // Bit 5 - ADLAR=0 - 10 бітне АЦП 
ADCSRA=0x85;           // Bit 7 - ADEN: ADC Enable 
                      // Bits 2:0 - ADPS2:0: ADC Prescaler Select Bits =101 -  K=32
                     // ADC Clock frequency: 4 MHz/32= 125,000 kHz (50kHz - 200kHz = normal )  
lcd_init();    // ініціалізація LCD
lcd_clear();
lcd_gotoxy(0,0);
lcd_putsf("RGB STRIP TESTER");
delay_ms (700);
delay_ms (700);       
  fxx=rom_fxx;       // прочитати опорну частоту з  памяті в змінну  fxx 
 speed=rom_speed;  // прочитати delay  з  памяті в змінну speed
  fxcalculator(); // функція для обчислення значень регістрів TCCR3B, ICR3H,  ICR3L 
  //ініціалізація кнопок menu на порті F  
(*(unsigned char *) 0x62)    =(1<<3          )|(1<<4          )|(1<<1          )|(1<<2          );
(*(unsigned char *) 0x61)      &= ~(1<<3          )&~(1<<4          )&~(1<<1          )&~(1<<2          );
 // Global enable interrupts
#asm("sei")
 while (1)
   {
// Place your code here       
    PREV_PINF=PINF;  
    k=get_key_status(3          );   // - якщо натиснути клавішу ENTER то в  МЕНЮ
         if (k==1)
           { 
              lcd_clear();  
              TIMSK |= (1<<6);   // enable Timer 2 overflow interrupt service routine    
              main_menu();      // головне меню
              TIMSK&=~(1<<6); // disable Timer 2 overflow interrupt service routine  
              lcd_clear();  
           }
         lcd_gotoxy(0,0);
     lcd_putsf("                ");  
     lcd_gotoxy(0,0);     
    // lcd_putsf("F");
     fx=(int)(*(unsigned char *) 0x80);   // частота pwm  
     ICR3 = (((*(unsigned char *) 0x81) & 0xffff)<<8)|(*(unsigned char *) 0x80);    // fx= ICR3 = ICR3H=0x0E; ICR3L=0x5f, {3679}            
// fx= SYS_FREQ/(ICR3+1)/8;   // n=8     
// fx= SYS_FREQ/(ICR3+1);     // n=1    
              if (fxx>1)
     {   
        tx=(1000000/(fxx));
        od='u';
     }
     else
     { 
       tx=(1000/fxx);
       od='m';
     };
               if (fxx<=300)
     {sprintf(buffer,"%.1fHz ", fxx);}
     else
     sprintf(buffer,"%.0fHz ", fxx);
              lcd_puts(buffer);
     delay_ms (500);   
           lcd_putsf("T");        
          if (fxx==100) 
        {tx=10000;};
     // {tx=9999;};
     sprintf(buffer,"%ld%cS", tx,od);
     lcd_puts(buffer); 
             lcd_gotoxy(0,1);   
     lcd_putsf("                ");  
     ADC_INPUT = 0x00; // порт PF0
     adc_in= read_adc(ADC_INPUT);    // міряємо і отримуємо результат перетворення
     indication=adc_in/0.1024;          // коефіцієнт залежить від опорної напруги 
     tinf= indication/1000; 
     Dgreen= (unsigned int)((tinf/2/vref)*100);  // перевірити опорну   
     lcd_gotoxy(0,1);  
     sprintf(buffer," R%u%%", Dgreen);    // buffer for LCD - ADC - Dblue  
     lcd_puts(buffer);  
            ADC_INPUT = 0x05; // порт PF5
     adc_in= read_adc(ADC_INPUT);    // міряємо і отримуємо результат перетворення
     indication=adc_in/0.1024;          // коефіцієнт залежить від опорної напруги 
     tinf= indication/1000; 
     Dred= (unsigned int)((tinf/2/vref)*100);  // перевірити опорну     
     //sprintf(buffer," G=%u", Dred);    // buffer for LCD - ADC - Dblue  
     sprintf(buffer," G%u%%", Dred);    // buffer for LCD - ADC - Dblue  
          lcd_puts(buffer);  
            ADC_INPUT = 0x06; // порт PF6    blue
     adc_in= read_adc(ADC_INPUT);    // міряємо і отримуємо результат перетворення
     indication=adc_in/0.1024;          // коефіцієнт залежить від опорної напруги 
     tinf= indication/1000; 
     Dblue= (unsigned int)((tinf/2/vref)*100);  // перевірити опорну     
     sprintf(buffer," B%u%%", Dblue);    // buffer for LCD - ADC - Dblue  
     lcd_puts(buffer);   
            RedPwm = (ICR3/100)*Dred;   
     if (RedPwm==0) RedPwm=1;
     redpwml=(char)(RedPwm);        // Dred% pwm  RED - low byte
     redpwmh=(char)((RedPwm)>>8);  // Dred% pwm  RED - high byte
             GreenPwm = (ICR3/100)*Dgreen;   
     if (GreenPwm==0) GreenPwm=1;
     greenpwml=(char)(GreenPwm);
     greenpwmh=(char)((GreenPwm)>>8);  //  Dgreen% pwm  GREEN - high byte 
             BluePwm = (ICR3/100)*Dblue;   
     if (BluePwm==0) BluePwm=1;
     bluepwml=(char)(BluePwm);
     bluepwmh=(char)((BluePwm)>>8);   // Dblue% pwm  BLUE - high byte       
           ADC_INPUT = 0x07; // порт PF7    // напруга живлення
     adc_in= read_adc(ADC_INPUT);    // міряємо і отримуємо результат перетворення
     indication=adc_in/0.1024;          // коефіцієнт залежить від опорної напруги 
     tinf= indication/1000; 
          delay_ms (700);
     delay_ms (700);
                  };
}
