/*****************************************************
CodeWizardAVR V1.25.8 Professional

Project :  PWM_LED & ADC
Chip type           : ATmega128
Clock frequency     : 3,680000 MHz
*****************************************************/

#include <mega128.h>  
#include <stdio.h>
#include <delay.h>   
#include "mylcd.c"     // ��� �������� ��� LCD  
 
#define SYS_FREQ        3680000UL    // ������� ������� 3.68 MHz   

//������������ ���
#define ADC_VREF_TYPE  0x00   //  Bit 5 - ADLAR=0 - 10 ��  ������������� ADCH � ADCL
#define REFS0   6             // selector Vref  - ������� ������� ������ �������
#define REFS1   7             // selector Vref     
                                                       
//������  MENU/ENTER, SELECT+, SELECT-, ESC/EXIT
#define BTNS_PORT              PORTF    //  for buttons on  PORTF  
#define BTNS_PORT_DDR          DDRF     //  for  buttons on PORTF
#define MENU_ENTER_BTN       3          //  kn-menu 
#define SELECT_PLUS_BTN      4          //  kn- MAX
#define SELECT_MINUS_BTN     1          //  kn - min
#define ESC_BTN              2          //  kn -esc
#define CNTREPEAT            300        //  ��������� �����

// Declare your global variables here     
unsigned char k, PREV_PINF = 0xff;                         // menu 1111 1111
unsigned int gSelectPlusCounter=0, gSelectMinusCounter=0;  // menu c�������        

volatile  unsigned int  hour = 0;    // ������� ����������� ����
volatile  unsigned int start_p=0;    // ����������� �������   

// eeprom float rom_fxx;      //  ������� � ROM     
eeprom float   rom_fxx;      //  ������� � ROM 
eeprom unsigned int   rom_speed;  //  delay � ROM - ��� ����� �������� ��� �������� ����������



char  buffer[33];               // for LCD convertion      
char N=1; // prescaler
volatile unsigned long int  fx=0, tx=0;  // ������� � ����� 
volatile float  fxx=22.2;  // ������ �������- ����� ���������� �� 1... 29999 ��
volatile unsigned char  redpwml=0,redpwmh=0, greenpwml=0,greenpwmh=0, bluepwml=0,bluepwmh=0;  // pwm , pwm_val  
volatile unsigned int ICR3top=0;     
volatile unsigned int speed=10;   // �������� � ms - ��� ����� �������� ��� �������� ����������

              
unsigned int ICR3, RedPwm, GreenPwm, BluePwm ; 
unsigned int Dred, Dgreen, Dblue;  // duty = red green blue     

unsigned int adc_in;          // ����� ��� ADC - ���
float indication=0, tinf=0;      
char ADC_INPUT = 0x05;       // ���� � ����� ������ Analog signal = PF5(ADC5)   
char vref=5;                 // ������ �������
char od='m'  ;       

volatile unsigned char value[5] = {0, 0, 0, 0, 0};      

volatile unsigned int A0,A1,A2,A3,A4;
volatile unsigned int V0,V1,V2,V3,V4;



//  key - �������  ������ ������ ������  
  unsigned char get_key_status(unsigned char key)    //  key - ����� ������  �� �����
{
   return (!(PINF & (1<<key)));  
}              


// ������� ��������� ������ ������  
unsigned char get_prev_key_status(unsigned char key)  // key - ����� ������  �� �����
{
  return (!(PREV_PINF & (1<<key)));  
}


// Timer 2 overflow interrupt service routine  ��������������� ��� ����!!! 
interrupt [TIM2_OVF] void timer2_ovf_isr(void)                       
{     
    if ( get_key_status(SELECT_PLUS_BTN) )  // ����� ���������� ������ SELECT+
      {
         if (gSelectPlusCounter < CNTREPEAT) 
            gSelectPlusCounter++;
       }
    else  gSelectPlusCounter = 0;
  
  if ( get_key_status(SELECT_MINUS_BTN) )  // ����� ���������� ������ SELECT-
  {
    if (gSelectMinusCounter < CNTREPEAT)
        gSelectMinusCounter++;
  }
  else gSelectMinusCounter = 0;       
}  
  

// Timer 3 overflow interrupt service routine
interrupt [TIM3_OVF] void timer3_ovf_isr(void)
{  
   OCR3AH=redpwmh;  OCR3AL=redpwml;     // RED  0E 5F = for 1000 hz icr3 = top
   OCR3BH=greenpwmh;  OCR3BL=greenpwml;     // GREEN
   OCR3CH=bluepwmh;  OCR3CL=bluepwml;     // BLUE  72F
 }

 // Read the AD conversion result
unsigned int read_adc(unsigned char adc_input)
{
   ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
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
  DDRB.5=1;                  // ��������� ������ on/off 
  delay_ms(200);  
  DDRB.5=0;   
  delay_ms(200);  
 }








// ������� ���� -   set ������� �� 300 �� 
unsigned int set_page(void)  
{
  unsigned char  x[4] = { 7, 8, 9, 11 }, i = 0;            // ������� ������� ����� � 4 �������
  char time_chars[4][2] = {"^", "^", "^", "^"};  // ����� ������ - ������ ������ �������

  lcd_gotoxy(x[0],1);    
  lcd_puts(time_chars[0]); 
  
  if (hour>3000) {hour=2999;};                              //  ����� "^"  - ������ �����  
  
  
   A0 = hour;        V0=A0/1000;
   value[0]=(unsigned char)(A0/1000); // �������-������ ������ ����
   A1=A0-V0*1000;   V1= (A1/100); 
   value[1]=(unsigned char)(A1/100);  // ������ ������ ����      
   A2=A1-V1*100;    V2=A2/10; 
   value[2]=(unsigned char)(A2/10);   // ����� ������ ����  
   A3=A2-V2*10;     V3=A3;
   value[3]=(unsigned char)(A3);    // ��������� ������ ����      
   
 // value[0]= (unsigned char)hour/1000;                       // �������-������ ������ ����
 // value[1]= (hour-value[0]*1000)/100;                        // ������ ������ ����
 // value[2]= ((hour-value[0]*1000-value[1]*100)/10);         // ����� ������ ����
 // value[3]= hour-value[0]*1000-value[1]*100-value[2]*10;  // ��������� ������ ����  
  
  while (1) {
    PREV_PINF = PINF; 
    sprintf(buffer, "%u%u%u.%u", value[0], value[1], value[2], value[3]); // ������ ������� ��� ������
    lcd_gotoxy(x[0],0);    
    lcd_puts(buffer);             	
    
    if (get_key_status(SELECT_PLUS_BTN))             //   select+  UP ---set_page()-
      if (!get_prev_key_status(SELECT_PLUS_BTN) || (gSelectPlusCounter == CNTREPEAT))
      {
        if (gSelectPlusCounter == CNTREPEAT) 
          delay_ms(80);  
          
         switch (i)
         {
         case 0:                                   //  ���_������=������� ������� ����� page ��������=( 0..2)
              if (value[0] < 2)
                 value[0]++; 
              else value[0] = 0;
         break;     
            
         case 1:                                  // ����� ������� ���� ����� page �������� =( 0..9)
               if (value[1] < 9)
                   value[1]++;
               else value[1] = 0; 
         break;   
              
         case 2:                                 // ����� ������� ���� ����� page �������� =( 0..9)
              if (value[i] < 9)     
                 value[i]++;
              else value[i] = 0;
         break;  
              
         case 3:             // �������� ������� ���� ����� page �������� =( 0..9)
       
              if (value[i] < 9)
                 value[i]++;
              else value[i] = 0;  
         break;     
         }
      }         
 //-end select+  UP ---set_page()--  
    
    if (get_key_status(SELECT_MINUS_BTN))             // select-  DOWN---set_page()--
      if (!get_prev_key_status(SELECT_MINUS_BTN) || (gSelectMinusCounter == CNTREPEAT))
      {            
        if (gSelectMinusCounter == CNTREPEAT) 
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

    if (get_key_status(MENU_ENTER_BTN))     // enter---set_page()-
      if (!get_prev_key_status(MENU_ENTER_BTN))
      {
        if (i==3)    // ������� ������� ����� =4
        {    
        
         hour = (unsigned int)(value[0])*1000 ; //+(unsigned int)(value[1])*100); 
         hour = hour+(unsigned int)(value[1])*100;   
          hour = hour+(unsigned int)(value[2])*10;    
          hour = hour+(unsigned int)(value[3]);  
        
       //  hour = (int)(value[0]*1000+value[1]*100+value[2]*10+value[3]);  // ����� ������� 
           if (hour> 2999)  
             hour=2999;   
             lcd_gotoxy(x[i],1);               // ������� ������
             lcd_putchar(' '); 
          return(hour);                        // ���������� ��������
        }    
        
        lcd_gotoxy(x[i],1);
        lcd_putchar(' ');       
        lcd_gotoxy(x[++i],1);    
        lcd_puts(time_chars[i]);
                        
      }         
  //-end enter---set_page()-     
  
    if (get_key_status(ESC_BTN))       // exit --set_page()-
    {
      PREV_PINF = PINF;	   
      // exitflag=1;    // ��������� ������ exit
      return;
    }                          
  }
}   
//--end exit ---set_page()-



// ������� ���� -   set ������� ����� 300 �� 
unsigned int set_page2(void)  
{
                       // ������� ����� �������
  unsigned char   x[5] = { 7, 8, 9, 10, 11 }, i = 0;  // ������� ������� ����� � 5 �������
  char time_chars[5][2] = {"^", "^", "^", "^","^"};  // ����� ������ - ������ ������ �������    

  lcd_gotoxy(x[0],1);    
  lcd_puts(time_chars[0]);       //  ����� "^"  - ������ �����    
   
   A0 = hour;        V0=A0/10000;
   value[0]=(unsigned char)(A0/10000); // �������-������ ������ ����
   A1=A0-V0*10000;   V1= (A1/1000); 
   value[1]=(unsigned char)(A1/1000);  // ������ ������ ����      
   A2=A1-V1*1000;    V2=A2/100; 
   value[2]=(unsigned char)(A2/100);   // ����� ������ ����  
   A3=A2-V2*100;     V3=A3/10;
   value[3]=(unsigned char)(A3/10);    // ��������� ������ ����           
   A4=A3-V3*10;      V4=A4;
   value[4]=(unsigned char)A4;         // �������� -�'���� ������ ���� 
 
  while (1) {
    PREV_PINF = PINF; 
    sprintf(buffer, "%u%u%u%u%u", value[0], value[1], value[2], value[3], value[4]); // ������ ������� ��� ������
    lcd_gotoxy(x[0],0);    
    lcd_puts(buffer);             	
    
    if (get_key_status(SELECT_PLUS_BTN))             //   select+  UP ---set_page()-
      if (!get_prev_key_status(SELECT_PLUS_BTN) || (gSelectPlusCounter == CNTREPEAT))
      {
        if (gSelectPlusCounter == CNTREPEAT) 
          delay_ms(80);  
          
         switch (i)
         {
          case 0:                     // ���_������= ����� ������� ����� page ��������=( 0..2)
              if (value[0] < 2)
                 value[0]++; 
              else value[0] = 0;
          break;     
            
          case 1:                    // ����� ������� ���� ����� page �������� =( 0..9)
               if (value[1] < 9)
                   value[1]++;
               else value[1] = 0; 
          break;   
              
          case 2:                    // ����� ������� ���� ����� page �������� =( 0..9)
              if (value[2] < 9)     
                 value[2]++;
              else value[2] = 0;
          break;  
              
          case 3:                    // �������� ������� ���� ����� page �������� =( 0..9)    
              if (value[i] < 9)
                 value[i]++;
              else value[i] = 0;  
          break;  
         
          case 4:                   // �'��� ������� ���� ����� page �������� =( 0..9)
              if (value[i] < 9)
                 value[i]++;
              else value[i] = 0;  
          break;  
         }
      }         
     //-end select+  UP ---set_page()--  
    
    if (get_key_status(SELECT_MINUS_BTN))             // select-  DOWN---set_page()--
      if (!get_prev_key_status(SELECT_MINUS_BTN) || (gSelectMinusCounter == CNTREPEAT))
      {            
        if (gSelectMinusCounter == CNTREPEAT) 
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

    if (get_key_status(MENU_ENTER_BTN))     // enter---set_page()-
      if (!get_prev_key_status(MENU_ENTER_BTN))
      {
        if (i==4)    // ������� ������� ����� =5
        {   
          hour = (unsigned int)(value[0]*10000+value[1]*1000); 
          hour = hour+(unsigned int)(value[2])*100;    
          hour = hour+(unsigned int)(value[3])*10+(unsigned int)(value[4]);  
     
           if (hour>29999)  
             hour=29999;   
             lcd_gotoxy(x[i],1);               // ������� ������
             lcd_putchar(' '); 
          return(hour);                        // ���������� ��������
        }    
        
        lcd_gotoxy(x[i],1);
        lcd_putchar(' ');       
        lcd_gotoxy(x[++i],1);    
        lcd_puts(time_chars[i]);
      }         
      //-end enter---set_page()-      
  
    if (get_key_status(ESC_BTN))       // exit --set_page()-
    {
      PREV_PINF = PINF;	   
      // exitflag=1;    // ��������� ������ exit
      return;
    }                          
  }
}   
//--end exit ---set_page()-    



// ������� ���� -   set speed �� 999 ms 
unsigned int set_speed(void)  
{
  unsigned char  x[3] = { 7, 8, 9 }, i = 0;            // ������� ������� ����� � 3 �������
  char time_chars[3][2] = {"^", "^", "^"};  // ����� ������ - ������ ������ �������

  lcd_gotoxy(x[0],1);    
  lcd_puts(time_chars[0]); 
  
  if (speed>=1000) {speed=999;};                 //  ����� "^"  - ������ �����  
  
  
   A0 = speed;        V0=A0/100;
   value[0]=(unsigned char)(A0/100); // �������-������ ������ ����
   A1=A0-V0*100;   V1= (A1/10); 
   value[1]=(unsigned char)(A1/10);  // ������ ������ ����      
   A2=A1-V1*10;    V2=A2; 
   value[2]=(unsigned char)(A2);   // ����� ������ ����  
   
  
  while (1) {
    PREV_PINF = PINF; 
    sprintf(buffer, "%u%u%u", value[0], value[1], value[2]); // ��� ������� ��� ������
    lcd_gotoxy(x[0],0);    
    lcd_puts(buffer);             	
    
    if (get_key_status(SELECT_PLUS_BTN))             //   select+  UP --- set speed -
      if (!get_prev_key_status(SELECT_PLUS_BTN) || (gSelectPlusCounter == CNTREPEAT))
      {
        if (gSelectPlusCounter == CNTREPEAT) 
          delay_ms(80);  
          
         switch (i)
         {
         case 0:                                   //  ���_������=������� ������� ����� page ��������=( 0..9)
              if (value[0] < 9)
                 value[0]++; 
              else value[0] = 0;
         break;     
            
         case 1:                                  // ����� ������� ���� ����� page �������� =( 0..9)
               if (value[1] < 9)
                   value[1]++;
               else value[1] = 0; 
         break;   
              
         case 2:                                 // ����� ������� ���� ����� page �������� =( 0..9)
              if (value[i] < 9)     
                 value[i]++;
              else value[i] = 0;
         break;  
              
         }
      }         
 //-end select+  UP ---set speed ()--  
    
    if (get_key_status(SELECT_MINUS_BTN))             // select-  DOWN--- set speed --
      if (!get_prev_key_status(SELECT_MINUS_BTN) || (gSelectMinusCounter == CNTREPEAT))
      {            
        if (gSelectMinusCounter == CNTREPEAT) 
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

    if (get_key_status(MENU_ENTER_BTN))     // enter--- set speed ()-
      if (!get_prev_key_status(MENU_ENTER_BTN))
      {
        if (i==2)    // ������� ������� ����� =3
        {    
        
         speed = (unsigned int)(value[0])*100 ; 
         speed = speed +(unsigned int)(value[1])*10;   
          speed = speed +(unsigned int)(value[2]);    
        
           if (speed >= 1000)  
             speed =999;   
             lcd_gotoxy(x[i],1);               // ������� ������
             lcd_putchar(' '); 
          return(speed);                        // ���������� ��������
        }    
        
        lcd_gotoxy(x[i],1);
        lcd_putchar(' ');       
        lcd_gotoxy(x[++i],1);    
        lcd_puts(time_chars[i]);
                        
      }         
  //-end enter--- set speed
  
    if (get_key_status(ESC_BTN))       // exit --set_page()-
    {
      PREV_PINF = PINF;	   
      return;
    }                          
  }
}   
//--end exit --- set speed


 void  Red(unsigned int  dutyr)  // ������� ��� PWM - red
{
    RedPwm = (ICR3/100)* dutyr;   
     if (RedPwm==0) RedPwm=1;
     redpwml=(char)(RedPwm);             // Dred% pwm  RED - low byte
     redpwmh=(char)((RedPwm)>>8);   // Dred% pwm  RED - high byte 
     return;
  }      

  void  Green(unsigned  int  dutyg)   // ������� ��� PWM - Green
{
     GreenPwm = (ICR3/100)* dutyg;   
     if (GreenPwm==0) GreenPwm=1;
     greenpwml=(char)(GreenPwm);
     greenpwmh=(char)((GreenPwm)>>8);   //  Dgreen% pwm  GREEN - high byte 
     return;
 }  

  void  Blue (unsigned  int  dutyb)   // ������� ��� PWM - Blue
{
     BluePwm = (ICR3/100)* dutyb;   
     if (BluePwm==0) BluePwm=1;
     bluepwml=(char)(BluePwm);
     bluepwmh=(char)((BluePwm)>>8);    // Dblue% pwm  BLUE - high byte       
     return;
  }


  void test (unsigned  int  speedx)   // ���������� 
   {
    unsigned char R=0, G=0, B=0;

    for (R=0; R<100; R++)      // red �� 0 �� 100 %
         {
             Red(R);  
             delay_ms(speedx);
          };

     for (R=99; R>0; R--)      // red �� 100% �� 1%
         {
             Red(R);  
             delay_ms(speedx);
          };

    for (G=0; G<100; G++)      // Green �� 0 �� 100 %

         {
             Green(G);  
             delay_ms(speedx);
          };
     for (G=99; G>0; G--)      // Green �� 100% �� 1%
         {
             Green(G);  
             delay_ms(speedx);
          };
    for (B=0; B<100; B++)      // Blue �� 0 �� 100 %

         {
             Blue (B);  
             delay_ms(speedx);
          };
     for (B=99; B>0; B--)      // Blue �� 100% �� 1%
         {
             Blue(B);  
             delay_ms(speedx);
          }; 
          
     for (B=0; B<100; B++)      // Red Green Blue �� 0 �� 100 %
         {
             Red(B);  
             Green(B);  
             Blue (B);  
             delay_ms(speedx);
          };
     for (B=99; B>0; B--)      // Red =100% Green -Blue �� 100% �� 1%
         {
               Green(B);  
                Blue(B);  
                delay_ms(speedx);
          };
    
        for (B=0; B<100; B++)      // Blue �� 0 �� 100 %

         {
             Blue(B);  
             delay_ms(speedx);
          };
             
    for (G=0; G<100; G++)      // Green �� 0 �� 100 %
         {
             Green(G);  
             delay_ms(speedx);
          };      
          
     for (R=99; R>0; R--)      // red �� 100% �� 1%
         {
             Red(R);  
             delay_ms(speedx);
          };
          
   for (B=99; B>49; B--)      // Red =100% Green -Blue �� 100% �� 1%
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




void fxcalculator (void ) // ������� ��� ���������� ������� �������
{
 if (fxx<100)
   {
     N=64;  // ��� ������ 1�100��
     TCCR3B=0x1B;  // n=64
     ICR3top = (3680000/(fxx*N))-1;
     if (ICR3top==0) ICR3top=1;
     ICR3H =(char)(( ICR3top)>>8);    // - high b
     ICR3L =(char)( ICR3top);         // - low byte
     // ICR3H=0x01;  ICR3L=0x6f;      // 10000
    }
 else
   {
     N=1; // ��� ������ 100�30000��
     TCCR3B=0x19;    // n-prescale=1
     ICR3top= (3680000/(fxx*N))-1;
     if (ICR3top==0) ICR3top=1;
     ICR3H =(char)(( ICR3top)>>8);  // - high byte
     ICR3L =(char)( ICR3top);       // - low byte
    }
 }
 //--end fxcalculator          
 
 
 void savesetup(void)  // ������� menu save_setup
  {     
     //fxx=1.2;
    rom_fxx=fxx;    // ����� � ROM �������� �������
     //  tp= TMAX; 
           zvyk();  
  }

 
 void savespeed(void)  // ������� menu save_setup
  {     
     //speed=10;        //ms
    rom_speed=speed;    // ����� � ROM �������� �������� ����������� �����
     //  tp= TMAX;   
     
           zvyk();  
  }
 
 
 


void main_menu(void)   // ������� ���� � ���� ������ 
{
   char *menu_items[7]=  { " SET Fx < 300Hz ", " SET Fx > 300Hz ", "SAVE SETUP", "SAVE SPEED", "SET TEST SPEED", "TEST RGB"};

   unsigned char x_pos[] = {0, 0, 3, 3, 1, 4};   // ���������� ��� items menu
   int sel=0;                                    // �� ������������ ������� 0

    while(1)
    {
       PREV_PINF=PINF;   // ��. �� ���� F
       lcd_gotoxy(0,0);
       lcd_putsf("***** MENU *****");  
       lcd_gotoxy(x_pos[sel],1);
       lcd_puts(menu_items[sel]);   


       if (get_key_status(SELECT_PLUS_BTN))  // ��������� ��. "select+" main_menu()
        {  
          if (!get_prev_key_status(SELECT_PLUS_BTN) || (gSelectPlusCounter == CNTREPEAT))
           {            
             if (gSelectPlusCounter == CNTREPEAT) 
               delay_ms(80);                
             if (sel<5)       // ������� ������ (���� - 1)
               sel++;
             else sel = 0;
             lcd_clear();
          }
        }   
       // -end "select+" - main_menu()-           
         
        if (get_key_status(SELECT_MINUS_BTN))    // ��������� ��. "select-" main_menu()
         {  
            if (!get_prev_key_status(SELECT_MINUS_BTN) || (gSelectMinusCounter == CNTREPEAT))
              {            
                if (gSelectMinusCounter == CNTREPEAT) 
                   delay_ms(80);  
                if (sel>0)
                    sel--; 
                else sel = 5;   // ������� ������ (���� - 1)
                lcd_clear(); 
             }
          }     
         // -end select(-) -main_menu()  
             
        if (get_key_status(MENU_ENTER_BTN))      // ��������� ��. "enter"  main_menu()
          {  
             if (!get_prev_key_status(MENU_ENTER_BTN))
                {
                 //  lcd_clear();
                   switch(sel)
                     {
                       case 0:  
                          lcd_clear();             // ������ SET Fx< 300 Hz  
                          lcd_gotoxy(0,0);     
                          lcd_putsf(" Fpwm=");  
                          start_p=set_page();    
                          fxx= (float)start_p;     // �������� �������   
                          fxx=fxx/10;
                          
                          fxcalculator();
                       break;                     // end ������ SET Fx 
                                         
                       case 1:    
                          lcd_clear();             // ������ SET Fx >300 Hz  
                          lcd_gotoxy(0,0);     
                          lcd_putsf(" Fpwm=");  
                          start_p=set_page2();  
                          fxx= (float)start_p;   // �������� ������� 
                          fxcalculator();
                       break;  
                                           
                       case 2: 
                         savesetup();  // �������� ������������ � ������     
                         lcd_clear();             // ������ SET Fx >300 Hz  
                         lcd_gotoxy(4,0); 
                         lcd_putsf("Save OK!"); 
                         delay_ms(900);          
                       break;    
                       
                       case 3: 
                         savespeed() ;   // �������� � ������ �������� ��������  
                         lcd_clear();             // ������ SET Fx >300 Hz  
                         lcd_gotoxy(2,0); 
                         lcd_putsf("Save speed OK!"); 
                         delay_ms(900);           
                       break;    
                       
                       case 4:     
                         lcd_clear();             // ������ SET Fx >300 Hz  
                         lcd_gotoxy(0,0);     
                         lcd_putsf(" DELAY=");  
                         set_speed();    
                       break;             
                       
                       case 5:     
                         lcd_clear();             // ������ SET Fx >300 Hz  
                         lcd_gotoxy(0,0); 
                         lcd_putsf("Testing....wait!");              
                         test (speed);
                       break;     //     �������� ������  ��� �. ����  
                       default: break;    //     �������� ������  ��� �. ����  
                     }
                }
           } 
           // end enter-main_menu()    
         
      
          if (get_key_status(ESC_BTN))      // ��������� ��. "exit"  main_menu() 
             {
               if (!get_prev_key_status(ESC_BTN))
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
PORTE=0x00; DDRE=0x38;   // Port- ���� PE = 00111000 (pin5,6,7) {A,B,C}
PORTF=0x00;  DDRF=0x00;  // Port F initialization
PORTG=0x00;  DDRG=0x00;  // Port G initialization

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
OCR1AH=0x00; OCR1AL=0x00;   OCR1BH=0x00; OCR1BL=0x00;  OCR1CH=0x00; OCR1CL=0x00;


// Timer/Counter 1 initialization
// Clock source: System Clock

// sound - ������� timer1   
TCCR1A=0x82;      // fast PWM = 14 
TCCR1B=0x19; 
TCNT1H=0x00; 
TCNT1L=0x00; 
ICR1H=0x07;        // ������� 
ICR1L=0xCF;        // ������� 
OCR1AH=0x03;  //  �����������
OCR1AL=0xFF;   //  �����������
OCR1BH=0x00; 
OCR1BL=0x00;







// Timer/Counter 2 initialization
  // Clock source: System Clock
  // Clock value: 8000.000 kHz  - ����������!!!!!
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
TCCR3A=0xAA;         
TCCR3B=0x19;    // n-prescale=1   TCCR3B=0x1A; // n=8
               
TCNT3H=0x00;  TCNT3L=0x00;
// ICR3H=0x0E; ICR3L=0x5f;  // E5F = for 1000 hz  Top= ICR3 ��� FAST PWM mode=14   
// ICR3H=0x47;  ICR3L=0xdf;   // ������� 200 Hz output  
ICR3H=0x8F;  ICR3L=0xBF;   // ������� 100 Hz output    8FBF   
// ICR3H=0x01;  ICR3L=0x6f;   // 10000    

OCR3AH=0x00; OCR3AL=0x00;
OCR3BH=0x00; OCR3BL=0x00;
OCR3CH=0x00; OCR3CL=0x00;

// External Interrupt(s) initialization
// INT0: Off , INT1: Off, INT2: Off, INT3: Off, INT4: Off, INT5: Off, INT6: Off, INT7: Off
EICRA=0x00;  EICRB=0x00;  EIMSK=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x00;
ETIMSK=0x04;  // TIM3_OVF

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
DDRD.2 = 1;     // SD5/-> �������� �������� +5� LCD
PORTD.2=1;      // SD5/=1 �������� �������� +5� LCD

//select reference voltage for ADC
ADMUX|=(0<<REFS1)|(0<<REFS0);    // AREF pin - ������ ������� 5�    
ADMUX=ADC_VREF_TYPE & 0xff;    // Bit 5 - ADLAR=0 - 10 ���� ��� 
ADCSRA=0x85;           // Bit 7 - ADEN: ADC Enable 
                      // Bits 2:0 - ADPS2:0: ADC Prescaler Select Bits =101 -  K=32
                     // ADC Clock frequency: 4 MHz/32= 125,000 kHz (50kHz - 200kHz = normal )  

lcd_init();    // ����������� LCD
lcd_clear();
lcd_gotoxy(0,0);
lcd_putsf("RGB STRIP TESTER");
delay_ms (700);
delay_ms (700);       

  fxx=rom_fxx;       // ��������� ������ ������� �  ����� � �����  fxx 
 speed=rom_speed;  // ��������� delay  �  ����� � ����� speed

  fxcalculator(); // ������� ��� ���������� ������� ������� TCCR3B, ICR3H,  ICR3L 
 
 //����������� ������ menu �� ���� F  
BTNS_PORT=(1<<MENU_ENTER_BTN)|(1<<SELECT_PLUS_BTN)|(1<<SELECT_MINUS_BTN)|(1<<ESC_BTN);
BTNS_PORT_DDR &= ~(1<<MENU_ENTER_BTN)&~(1<<SELECT_PLUS_BTN)&~(1<<SELECT_MINUS_BTN)&~(1<<ESC_BTN);
 
// Global enable interrupts
#asm("sei")
 

while (1)
   {
// Place your code here       

    PREV_PINF=PINF;  
    k=get_key_status(MENU_ENTER_BTN);   // - ���� ��������� ������ ENTER �� �  ����

         if (k==1)
           { 
              lcd_clear();  
              TIMSK |= (1<<6);   // enable Timer 2 overflow interrupt service routine    
              main_menu();      // ������� ����
              TIMSK&=~(1<<6); // disable Timer 2 overflow interrupt service routine  
              lcd_clear();  
           }
    
     lcd_gotoxy(0,0);
     lcd_putsf("                ");  
     lcd_gotoxy(0,0);     
    // lcd_putsf("F");
     fx=(int)ICR3L;   // ������� pwm  
     ICR3 = ((ICR3H & 0xffff)<<8)|ICR3L;    // fx= ICR3 = ICR3H=0x0E; ICR3L=0x5f, {3679}            
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
     ADC_INPUT = 0x00; // ���� PF0
     adc_in= read_adc(ADC_INPUT);    // ������ � �������� ��������� ������������
     indication=adc_in/0.1024;          // ���������� �������� �� ������ ������� 
     tinf= indication/1000; 
     Dgreen= (unsigned int)((tinf/2/vref)*100);  // ��������� ������   
     lcd_gotoxy(0,1);  
     sprintf(buffer," R%u%%", Dgreen);    // buffer for LCD - ADC - Dblue  
     lcd_puts(buffer);  
       
     ADC_INPUT = 0x05; // ���� PF5
     adc_in= read_adc(ADC_INPUT);    // ������ � �������� ��������� ������������
     indication=adc_in/0.1024;          // ���������� �������� �� ������ ������� 
     tinf= indication/1000; 
     Dred= (unsigned int)((tinf/2/vref)*100);  // ��������� ������     
     //sprintf(buffer," G=%u", Dred);    // buffer for LCD - ADC - Dblue  
     sprintf(buffer," G%u%%", Dred);    // buffer for LCD - ADC - Dblue  
     
     lcd_puts(buffer);  
       
     ADC_INPUT = 0x06; // ���� PF6    blue
     adc_in= read_adc(ADC_INPUT);    // ������ � �������� ��������� ������������
     indication=adc_in/0.1024;          // ���������� �������� �� ������ ������� 
     tinf= indication/1000; 
     Dblue= (unsigned int)((tinf/2/vref)*100);  // ��������� ������     
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
     
      ADC_INPUT = 0x07; // ���� PF7    // ������� ��������
     adc_in= read_adc(ADC_INPUT);    // ������ � �������� ��������� ������������
     indication=adc_in/0.1024;          // ���������� �������� �� ������ ������� 
     tinf= indication/1000; 
     
     delay_ms (700);
     delay_ms (700);
          
    
    };
}
