
#include <avr/io.h> 
#include <math.h> 
#include <util/delay.h> 
#include <stdio.h> //input/output library 
#include "ds1307.h" // Dallas Semiconductors DS1307 I2C Bus Real Time Clock library
#include "nokia_lcd.h" // NOKIA3310 LCD library
#include <avr/pgmspace.h>

//
//#define H_N_C CYAN      	       	// Hour Needle Color
//

float cx,cy;
float radius=50;

#define S_N_L (radius-5)		// Second Needle Length
//#define S_N_C RED           		// Second needle Color
#define M_N_L (radius-10)   		// Minute Needle Length
#define M_N_C LIGHTRED      		// Minute Needle Color
#define H_N_L (radius-15) //(radius/2))   	// Hour Needle Length

//void draw_face(float radius);
//void get_time(int &h,int &m,int &s);
//void second_needle(int s);
//void minute_needle(int m,int s);
//void hour_needle(int h,int m,int s);

LcdPixelMode mode;

void draw_face(float radius)
{

	int theta=0; 
	uint8_t i; // theta is the angle variable.
	float x,y;
	/** Draw Clock Border. **/
	mode=PIXEL_ON;
		lcd_circle(cx,cy,22, mode);
		lcd_update();
		lcd_circle(cx,cy,20, mode);
		lcd_update();
	/** Draw GREEN material border. **/
	//setcolor(BROWN);	// I like a wooden frame!
	/** Paint the border. **/
	/*for (i=0;i<9;i++)
	{
	   lcd_circle(cx,cy,5+i, mode);
	   //lcd_update();
	}*/
	/** Set the color white. **/
		//setcolor(WHITE);
	/** Draw outer-inner border. **/
		//lcd_circle(cx,cy,10, mode);
		//lcd_update();
		//lcd_circle(cx,cy,8, mode);
		//lcd_update();
	/** Draw center dot. **/
		lcd_circle(cx,cy,2, mode);
		//lcd_update();
    i=0;
/** DRAW NUMERIC POINTS **/
     do{
     /** Getting (x,y) for numeric points **/
     x=cx+18*cos(theta*M_PI/180);
     y=cy+18*sin(theta*M_PI/180);
		/** Draw Numeric Points **/
		lcd_circle(x,y,1, mode);
		//lcd_update();
		/* Draw Dots around each numeric points **/
		lcd_pixel(x+1,y, mode);
		//lcd_update();
		lcd_pixel(x-1,y, mode);
		//lcd_update();
		lcd_pixel(x,y+1, mode);
		//lcd_update();
		lcd_pixel(x,y-1, mode);
		//lcd_update();
		/** Increase angle by 30 degrees, which is the circular distance between each numeric points. **/
		theta+=30;
		/** Increase i by 1. **/
		i++;

	} while(i!=12); //LIMIT NUMERIC POINTS UPTO =12= Numbers.
i=0;
/** DRAW DOTS BETWEEN NUMERIC POINTS. **/
	/*do{
	  lcd_pixel(cx+21*cos(i*M_PI/180),cy+21*sin(i*M_PI/180), mode);
	 // lcd_update();
	  i+=6;
	}while(i!=360);*/
	///lcd_update();

/** FACE COMPLETELY DRAWN. **/
}

/** Function to draw Second needle. **/
void second_needle(unsigned char s)
{

	float angle=-90;
	float sx,sy;
	//mode=PIXEL_OFF;
	mode=PIXEL_OFF;
	sx=cx+17*cos((angle+s*6-6)*M_PI/180);
	sy=cy+17*sin((angle+s*6-6)*M_PI/180);
	//lcd_line(cx, sx, cy, sy, mode);
	lcd_line(sx, cx, sy, cy, mode);
	lcd_update();
	mode=PIXEL_ON;	//setcolor(S_N_C);
	sx=cx+17*cos((angle+s*6)*M_PI/180);
	sy=cy+17*sin((angle+s*6)*M_PI/180);
	//lcd_line(cx, sx, cy, sy, mode);
	lcd_line(sx, cx, sy, cy, mode);	
	lcd_update();
}
/** Function to draw Minute needle. **/
void minute_needle(unsigned char m, unsigned char s)
{
	float angle=-90;
	float sx,sy;
	mode=PIXEL_OFF;	//setcolor(0);
	sx=cx+14*cos((angle+m*6-6)*M_PI/180);
	sy=cy+14*sin((angle+m*6-6)*M_PI/180);
	lcd_line(sx, cx, sy, cy, mode);
	lcd_update();
	mode=PIXEL_ON;//	setcolor(M_N_C);
	sx=cx+14*cos((angle+m*6/*+(s*6/60)*/)*M_PI/180);
	sy=cy+14*sin((angle+m*6/*+(s*6/60)*/)*M_PI/180);
	lcd_line(sx, cx, sy, cy, mode);
	lcd_update();
}
/** Function to draw Hour needle. **/
void hour_needle(unsigned char h, unsigned char m, unsigned char s)
{
	float angle=-90;
	float sx,sy;
	mode=PIXEL_OFF;	//setcolor(0);
	sx=cx+11*cos((angle+h*30-(m*30/60))*M_PI/180);
	sy=cy+11*sin((angle+h*30-(m*30/60))*M_PI/180);
	lcd_line(sx, cx, sy, cy, mode);
	lcd_update();
	mode=PIXEL_ON;	//setcolor(H_N_C);
	sx=cx+11*cos((angle+h*30+(m*30/60))*M_PI/180);
	sy=cy+11*sin((angle+h*30+(m*30/60))*M_PI/180);
	lcd_line(sx, cx, sy, cy, mode);	
	lcd_update();
}

int main(void)
{
   unsigned char hour=0, min=10, sec=40, wd=0;
   float x,y;
   /***********************************/
   cx=84/2.0; // cx is center x value.
   cy=48/2.0; // cy is center y value.
   /** Now the point (cx,cy) is the center of your screen. **/
   rtc_init(0,1,0);
   //LCD initialization 	
   lcd_init();
  //lcd_contrast(0x40);
   LcdClear();
   mode=PIXEL_ON; 
   draw_face(radius);
   //lcd_circle(cx,cy,22, mode);
    //lcd_update();
   //lcd_update();
   while(1)
   { 
    rtc_get_time(&hour,&min,&sec, &wd);
    //mode=PIXEL_ON; 
	second_needle(sec);
    minute_needle(min,sec);
    hour_needle(hour,min,sec);
	 //lcd_update();
	
	//lcd_circle(cx,cy,5, mode);
	//lcd_update();
	_delay_ms(200);
   }
  return 0;
}
