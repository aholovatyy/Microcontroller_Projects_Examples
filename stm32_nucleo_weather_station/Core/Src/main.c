/* USER CODE BEGIN Header */
/**
  ******************************************************************************
  * @file           : main.c
  * @brief          : Main program body
  ******************************************************************************
  * @attention
  *
  * Copyright (c) 2024 STMicroelectronics.
  * All rights reserved.
  *
  * This software is licensed under terms that can be found in the LICENSE file
  * in the root directory of this software component.
  * If no LICENSE file comes with this software, it is provided AS-IS.
  *
  ******************************************************************************
  Цифрова метеостанція на мікроконтролері STM32F042K6T6, плата STM32 NUCLEO-F042K6
  (Digital weather station based on STM32F042K6T6 microcontroller, STM32 STM32 NUCLEO-F042K6 board)
  */
/* USER CODE END Header */
/* Includes ------------------------------------------------------------------*/
#include "main.h"

/* Private includes ----------------------------------------------------------*/
/* USER CODE BEGIN Includes */
#include "lcd16x2.h"
#include "bmp180.h"
#include "dht.h"
//#include "ds1307.h"
#include "stdio.h"
//#include "stdlib.h"
//#include "string.h"
/* USER CODE END Includes */

/* Private typedef -----------------------------------------------------------*/
/* USER CODE BEGIN PTD */

/* USER CODE END PTD */

/* Private define ------------------------------------------------------------*/
/* USER CODE BEGIN PD */

/* USER CODE END PD */

/* Private macro -------------------------------------------------------------*/
/* USER CODE BEGIN PM */

/* USER CODE END PM */

/* Private variables ---------------------------------------------------------*/
I2C_HandleTypeDef hi2c1;

RTC_HandleTypeDef hrtc;

TIM_HandleTypeDef htim1;

UART_HandleTypeDef huart2;


/* USER CODE BEGIN PV */
//const char *temp_units_1[] = {"\xb0\C", "\xb0\F", "K"};
const char *temp_units_2[] = {"\xdf\C", "\xdf\F", "K "};
const char *pres_units[] = {"mb", "mmHg", "inHg", "hPa"};
int8_t pInd = 1, tInd = 0;

// створюємо значки температури, вологості і тиску для LCD
uint8_t temp_icon[] = { // lcd значок/іконка температури
  0x04, 0x0A, 0x0A, 0x0A, 0x0E, 0x1F, 0x1F, 0x0E
};

uint8_t smile_icon[] = {
  0x00, 0x0A, 0x0A, 0x00, 0x11, 0x0E, 0x00, 0x00
};

uint8_t clock_icon[] = {
  /*0x1F,
  0x15,
  0x0A,
  0x04,
  0x04,
  0x0A,
  0x15,
  0x1F*/
  0x1F, 0x15, 0x0A, 0x04, 0x0A, 0x15, 0x1F, 0x00
};

RTC_DateTypeDef rtc_date;
RTC_TimeTypeDef rtc_time;
/* масив днів тижня */
const char *days_of_week[7] = { "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat" };

//volatile bool main_menu_call = false;

char buffer[200];
/* USER CODE END PV */

/* Private function prototypes -----------------------------------------------*/
void SystemClock_Config(void);
static void MX_GPIO_Init(void);
static void MX_I2C1_Init(void);
static void MX_TIM1_Init(void);
static void MX_USART2_UART_Init(void);
static void MX_RTC_Init(void);
/* USER CODE BEGIN PFP */
void set_pressure_unit();
void set_temperature_unit();
void main_menu();
/* USER CODE END PFP */

/* Private user code ---------------------------------------------------------*/
/* USER CODE BEGIN 0 */

void delay_us(volatile uint16_t us)
{
  __HAL_TIM_SET_COUNTER(&htim1, 0);  // set the counter value a 0
  while (__HAL_TIM_GET_COUNTER(&htim1) < us);  // wait for the counter to reach the us input in the parameter
}

/*void delay_ms(volatile uint16_t ms)
{
	while(ms > 0)
	{
		__HAL_TIM_SET_COUNTER(&htim1, 0);
		ms--;
		while (__HAL_TIM_GET_COUNTER(&htim1) < 1000);
	}
}*/

void set_time(void)
{
    //RTC_TimeTypeDef rtc_time;
    unsigned char i = 0, col = 2;
    const char *time_items[] = { "hh", "mm", "ss", "^^" };
    uint8_t hours = 0, minutes = 0, seconds = 0;
 	bool lcd_output_flag = true, ok = 0;

 	HAL_RTC_GetTime(&hrtc, &rtc_time, RTC_FORMAT_BIN);
    hours = rtc_time.Hours;
    minutes = rtc_time.Minutes;
    seconds = rtc_time.Seconds;

    while (!ok)
    {
    	if (lcd_output_flag)
    	{
    		lcd16x2_clear();
    		lcd16x2_setCursor(0,2);
    		sprintf(buffer, "%02d:%02d:%02d OK", hours, minutes, seconds);
    	    lcd16x2_printf(buffer);
    	    lcd16x2_setCursor(1,col);
    	    lcd16x2_printf(time_items[i]);
    	    lcd_output_flag = false;
    	}

    	if (HAL_GPIO_ReadPin(SEL_PLUS_BTN_GPIO_Port, SEL_PLUS_BTN_Pin) == GPIO_PIN_SET)
    	{
    		switch (i)
			{
				case 0:
					if (hours == 23) hours = 0;
					else hours ++;
					break;
				case 1:
					if (minutes == 59) minutes = 0;
					else minutes ++;
				break;
				case 2:
					if (seconds == 59) seconds = 0;
					else seconds ++;
				break;
				case 3:
					ok = 1;
					break;
			}
			lcd_output_flag = true;
			HAL_Delay(200);
        }

    	if (HAL_GPIO_ReadPin(SEL_MINUS_BTN_GPIO_Port, SEL_MINUS_BTN_Pin) == GPIO_PIN_SET)
    	{
    		switch (i)
    		{
	       		case 0:
	        		if (hours == 0) hours = 23;
                    else hours --;
                    break;
                case 1:
                  	if (minutes == 0) minutes = 59;
                   	else minutes --;
                    	break;
                case 2:
                    if (seconds == 0) seconds = 59;
                    else seconds--;
                    break;
                case 3:
                    ok = 1;
                    break;
            }
	        lcd_output_flag = true;
	        HAL_Delay(200);
        }

    	if (HAL_GPIO_ReadPin(MENU_BTN_GPIO_Port, MENU_BTN_Pin) == GPIO_PIN_SET)
    	{
    		if (i == 3)
    		{
    		  i = 0; col = 2;
    		}
    		else
    		{
    			i++; col += 3;
    		}
    		lcd_output_flag = true;
    		HAL_Delay(200);
         }

         if (HAL_GPIO_ReadPin(EXIT_BTN_GPIO_Port, EXIT_BTN_Pin) == GPIO_PIN_SET)
         {
           HAL_Delay(200);
           return;
         }
    }

    rtc_time.Hours = hours;
    rtc_time.Minutes = minutes;
    rtc_time.Seconds = seconds;

    HAL_StatusTypeDef res = HAL_RTC_SetTime(&hrtc, &rtc_time, RTC_FORMAT_BIN);

    /*if (res != HAL_OK) {
       //UART_Printf("HAL_RTC_SetTime failed: %d\r\n", res);
       return -1;
    }*/
}

void set_date(void)
{
	//RTC_DateTypeDef rtc_date;
	const char *date_items[] = { "dd", "mm", "yy" , "wd", "^^"};
	uint8_t day = 0, month = 0, year = 0, dow = 0;
	uint8_t i = 0, col = 0;
	bool lcd_output_flag = true, ok = 0;

	HAL_RTC_GetDate(&hrtc, &rtc_date, RTC_FORMAT_BIN);
	day = rtc_date.Date;
	month = rtc_date.Month;
	year = rtc_date.Year;
	dow = rtc_date.WeekDay;

	while (!ok)
	{
		if (lcd_output_flag)
		{
			lcd16x2_clear();
			sprintf(buffer, "%02d/%02d/%02d %s OK", day, month, year, days_of_week[dow]);
			lcd16x2_setCursor(0,0);
			lcd16x2_printf(buffer);
			lcd16x2_setCursor(1,col);
			lcd16x2_printf(date_items[i]);
			lcd_output_flag = false;
		}

        if (HAL_GPIO_ReadPin(SEL_PLUS_BTN_GPIO_Port, SEL_PLUS_BTN_Pin) == GPIO_PIN_SET)
        {
           switch (i)
           {
              case 0:
            	  if (day == 31)
            		day = 1;
                  else day ++;
                  break;
              case 1:
                  if (month == 12) month = 1;
                  else month ++;
                  break;
              case 2:
                  if (year == 99) year = 0;
                  else year ++;
                  break;
              case 3:
            	  if (dow == 6) dow = 0;
            	  else dow ++;
            	  break;
              case 4:
            	  ok = 1; break;
           }
           lcd_output_flag = true;
           HAL_Delay(200);
        }

        if (HAL_GPIO_ReadPin(SEL_MINUS_BTN_GPIO_Port, SEL_MINUS_BTN_Pin) == GPIO_PIN_SET)
        {
        	switch (i)
        	{
        		case 0:
                   	if (day == 1) day = 31;
                    else day --;
                    break;
                case 1:
                    if (month == 1) month = 12;
                    else month --;
                    break;
                case 2:
                	if (year == 0) year = 99;
                	else year--;
                   	break;
                case 3:
                	if (dow == 0) dow = 6;
                	else dow --;
                	break;
                case 4: ok = 1; break;
        	}
        	lcd_output_flag = true;
        	HAL_Delay(200);
         }

        if (HAL_GPIO_ReadPin(MENU_BTN_GPIO_Port, MENU_BTN_Pin) == GPIO_PIN_SET)
        {
        	if (i == 4)
        	{
        		i = 0; col = 0;
        	}
        	else
        	{
        		if (i == 3) col += 4;
        	    else col += 3;
        		i++;
        	}
        	lcd_output_flag = true;
        	HAL_Delay(200);
     }

     if (HAL_GPIO_ReadPin(EXIT_BTN_GPIO_Port, EXIT_BTN_Pin) == GPIO_PIN_SET)
     {
    	 HAL_Delay(200);
    	 return;
     }

	}
	rtc_date.WeekDay = dow;
	rtc_date.Year = year;
	rtc_date.Month = month;
	rtc_date.Date = day;

	HAL_StatusTypeDef res = HAL_RTC_SetDate(&hrtc, &rtc_date, RTC_FORMAT_BIN);
	/*if (res != HAL_OK) {
	   //UART_Printf("HAL_RTC_SetDate failed: %d\r\n", res);
	   return -1;
	}*/
}

void set_pressure_unit()
{

  const char pressure_units_menu_title[] = "PRESSURE UNITS";
  uint8_t col[] = {7, 6, 6, 6}; //{"mb", "mmHg", "inHg", "hPa"};
  uint8_t i = 0;
  bool lcd_output_flag = true;

  while(1)
  {
    if (lcd_output_flag)
    {
    	lcd16x2_clear();
    	lcd16x2_setCursor(0,1);
    	lcd16x2_printf(pressure_units_menu_title);
    	lcd16x2_setCursor(1,0);
    	lcd16x2_printf(">>");
    	lcd16x2_setCursor(1,14);
    	lcd16x2_printf("<<");
    	lcd16x2_setCursor(1,col[i]);
        lcd16x2_printf(pres_units[i]);
        lcd_output_flag = false;
    }
    if (HAL_GPIO_ReadPin(SEL_PLUS_BTN_GPIO_Port, SEL_PLUS_BTN_Pin) == GPIO_PIN_SET)
    {
      if (i == 3) i = 0;
      else i++;
      lcd_output_flag = true;
      HAL_Delay(200);
    }

    if (HAL_GPIO_ReadPin(SEL_MINUS_BTN_GPIO_Port, SEL_MINUS_BTN_Pin) == GPIO_PIN_SET)
    {
      if (i == 0) i = 3;
      else i--;
      lcd_output_flag = true;
      HAL_Delay(200);
    }

    if (HAL_GPIO_ReadPin(MENU_BTN_GPIO_Port, MENU_BTN_Pin) == GPIO_PIN_SET)
    {
      pInd = i;
      HAL_Delay(200);
      return;
    }
    if (HAL_GPIO_ReadPin(EXIT_BTN_GPIO_Port, EXIT_BTN_Pin) == GPIO_PIN_SET)
    {
      HAL_Delay(200);
      return;
    }
  }
}

void set_temperature_unit()
{

  const char temperature_units_menu_title[] = "TEMPERATURE UNIT";
  uint8_t i = 0;
  bool lcd_output_flag = true;

  lcd16x2_clear();
  lcd16x2_setCursor(0,0);
  lcd16x2_printf(temperature_units_menu_title);
  lcd16x2_setCursor(1,0);
  lcd16x2_printf(">>");
  lcd16x2_setCursor(1,14);
  lcd16x2_printf("<<");

  while(1)
  {
    if (lcd_output_flag)
    {
      lcd16x2_setCursor(1,7);
      lcd16x2_printf(temp_units_2[i]);
      lcd_output_flag = false;
    }
    if (HAL_GPIO_ReadPin(SEL_PLUS_BTN_GPIO_Port, SEL_PLUS_BTN_Pin) == GPIO_PIN_SET)
    {
      if (i == 2) i = 0;
      else i++;
      lcd_output_flag = true;
      HAL_Delay(200);
    }

    if (HAL_GPIO_ReadPin(SEL_MINUS_BTN_GPIO_Port, SEL_MINUS_BTN_Pin) == GPIO_PIN_SET)
    {
      if (i == 0) i = 2;
      else i--;
      lcd_output_flag = true;
      HAL_Delay(200);
    }

    if (HAL_GPIO_ReadPin(MENU_BTN_GPIO_Port, MENU_BTN_Pin) == GPIO_PIN_SET)
    {
      tInd = i;
      HAL_Delay(200);
      return;
    }

    if (HAL_GPIO_ReadPin(EXIT_BTN_GPIO_Port, EXIT_BTN_Pin) == GPIO_PIN_SET)
    {
      HAL_Delay(200);
      return;
    }
  }
}

void main_menu()
{
  char *main_menu_items[] = {"TEMPERATURE UNIT", " PRESSURE UNITS ", "    SET TIME    ", "    SET DATE    ", "      EXIT      "};
  char menu_title[] = "** MAIN MENU **";
  int i = 0;
  bool lcd_output_flag = false;

  lcd16x2_clear();
  lcd16x2_1stLine();
  lcd16x2_printf(menu_title);
  lcd16x2_2ndLine();
  lcd16x2_printf(main_menu_items[i]);

  while(1)
  {
    if (lcd_output_flag)
    {
	  lcd16x2_2ndLine();
	  lcd16x2_printf(main_menu_items[i]);
      lcd_output_flag = false;
    }
    if (HAL_GPIO_ReadPin(SEL_PLUS_BTN_GPIO_Port, SEL_PLUS_BTN_Pin) == GPIO_PIN_SET)
    {
      if(i == 4) i = 0;
      else i++;
      lcd_output_flag = true;
      HAL_Delay(200);
    }
    if (HAL_GPIO_ReadPin(SEL_MINUS_BTN_GPIO_Port, SEL_MINUS_BTN_Pin) == GPIO_PIN_SET)
    {
      if (i == 0) i = 4;
      else i--;
      lcd_output_flag = true;
      HAL_Delay(200);
    }
    if (HAL_GPIO_ReadPin(MENU_BTN_GPIO_Port, MENU_BTN_Pin) == GPIO_PIN_SET)
    {
      HAL_Delay(200);
      switch(i)
      {
        case 0: set_temperature_unit(); break;
        case 1: set_pressure_unit(); break;
        case 2: set_time(); break;
        case 3: set_date(); break;
        case 4: return;
        default: break;
      }
      lcd16x2_clear();
      lcd16x2_1stLine();
      lcd16x2_setCursor(0,0);
      lcd16x2_printf(menu_title);
      lcd16x2_2ndLine();
      lcd16x2_printf(main_menu_items[i]);
    }
    if (HAL_GPIO_ReadPin(EXIT_BTN_GPIO_Port, EXIT_BTN_Pin)== GPIO_PIN_SET)
    {
      HAL_Delay(200);
      return;
    }
  }
}
/* USER CODE END 0 */

/**
  * @brief  The application entry point.
  * @retval int
  */
int main(void)
{
  /* USER CODE BEGIN 1 */
  //char title[] = "*** STM32 MCU Based Weather Station ***\r\n*** Developed by IHOR BIZHYK ***\r\n";
  float dht_temperature = 0.0f, dht_humidity = 0.0f;
  float bmp180_temperature = 0.0f;
  int32_t /*bmp180_temperature = 0,*/ bmp180_pressure = 0;
  bool flag_weather_date = 0;
  /* масив з назвами місяців */
  const char *months[12] = {"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"};
  /* USER CODE END 1 */
  /* MCU Configuration--------------------------------------------------------*/
  /* Reset of all peripherals, Initializes the Flash interface and the Systick. */
  HAL_Init();

  /* USER CODE BEGIN Init */

  /* USER CODE END Init */

  /* Configure the system clock */
  SystemClock_Config();

  /* USER CODE BEGIN SysInit */

  /* USER CODE END SysInit */

  /* Initialize all configured peripherals */
  MX_GPIO_Init();
  MX_I2C1_Init();
  MX_TIM1_Init();
  MX_USART2_UART_Init();
  MX_RTC_Init();
  /* USER CODE BEGIN 2 */
  HAL_TIM_Base_Start(&htim1);
  lcd16x2_init_4bits(GPIOA, LCD_RS_Pin, LCD_EN_Pin, GPIOA, LCD_DB4_Pin, LCD_DB5_Pin, LCD_DB6_Pin, LCD_DB7_Pin);
  lcd16x2_cursorShow(false);
  lcd16x2_1stLine();
  lcd16x2_printf("STM32 MCU BASED");
  lcd16x2_2ndLine();
  lcd16x2_printf("WEATHER STATION");
  HAL_Delay(1000);
  lcd16x2_clear();
  lcd16x2_setCursor(0, 2);
  lcd16x2_printf("DEVELOPED BY");
  lcd16x2_setCursor(1, 0);
  lcd16x2_printf("ANDRIY HOLOVATYY");
  HAL_Delay(1000);
  //HAL_UART_Transmit(&huart1, (uint8_t *)title, strlen(title), 0xff);
  lcd16x2_custom_char(0, temp_icon);
  lcd16x2_custom_char(1, clock_icon);
  //
  bmp180_init(&hi2c1);
  bmp180_set_oversampling(BMP180_STANDARD); //BMP180_ULTRA);
  //* зчитуємо калібрувальні коефіцієнти перед входженням в головний цикл */
  bmp180_update_calibration_data();
  //
  dht_init(DHT_DATA_GPIO_Port, DHT_DATA_Pin, &htim1);
  /* Start DS1307 timing. Pass user I2C handle pointer to function. */
  /*ds1307_init(&hi2c1);
  ds1307_set_interrupt_rate(DS1307_1HZ);
  ds1307_set_enable_square_wave(DS1307_ENABLED);*/
  /* To test leap year correction. */
  /*ds1307_set_time_zone(+2, 00);
  ds1307_set_date(30);
  ds1307_set_month(4);
  ds1307_set_year(2024);
  ds1307_set_day_of_week(2);
  ds1307_set_hour(23);
  ds1307_set_minute(59);
  ds1307_set_second(30);*/

  /* USER CODE END 2 */

  /* Infinite loop */
  /* USER CODE BEGIN WHILE */
  while (1)
  {
	HAL_GPIO_TogglePin(GPIOB, GPIO_PIN_3);

	if (!flag_weather_date)
    {
		/* отримуємо/визначаємо ціле значення температури з давача bmp180 */
		//bmp180_temperature = bmp180_get_raw_temperature();
		/* отримуємо/визначаємо дійсне значення температури з давача bmp180 */
		bmp180_temperature = bmp180_get_temperature();
		/* читаємо дані тиску з давача bmp180 */
		bmp180_pressure = bmp180_get_pressure();
		/* читаємо дані про вологість і температуру з давача DHT */
		dht_read(&dht_humidity, &dht_temperature);
		/* обчислюємо значення точки роси */
		float dew_point = dht_calc_dewpoint(&dht_humidity, &dht_temperature);

		switch (pInd)
		{
  			case 1:
  				bmp180_pressure = bmp180_pressure * 0.0295333727*25.399999705;
  				break;
  			case 2:
  				bmp180_pressure = bmp180_pressure*0.0295333727;
  				break;
		}
		switch (tInd)
		{
  			case 1:
  				bmp180_temperature = (9.0/5.0)*bmp180_temperature + 32.0;
  				dht_temperature = (9.0/5.0)*dht_temperature + 32.0;
  				dew_point = (9.0/5.0)*dew_point + 32.0;
  				break;
  			case 2:
  				bmp180_temperature = bmp180_temperature + 274.15;
  				dht_temperature = dht_temperature + 274.15;
  				dew_point = dew_point + 274.15;
  				break;
		}
		/* вивід у послідовний порт */
		//sprintf(buffer, "BMP180, Temp = %.1f%s, Pres = %d %s\r\n", bmp180_temperature, temp_units_1[tInd], bmp180_pressure/100, pres_units[pInd]);
		//HAL_UART_Transmit(&huart1, buffer, strlen(buffer), 0xff);
		//HAL_UART_Transmit(&huart1, "DHT22, ", 7, 0xff);
		//sprintf(buffer, "Temp = %.1f\xb0\C ", dht_temperature);
		//sprintf(buffer, "Temp = %.1f%s ", dht_temperature, temp_units_1[tInd]);
		//HAL_UART_Transmit(&huart1, (uint8_t *)buffer, strlen(buffer), 0xff);
		//sprintf(buffer, "Humi = %.1f%%\r\n", dht_humidity);
		//HAL_UART_Transmit(&huart1, (uint8_t *)buffer, strlen(buffer), 0xff);
		/* вивід на дисплей */
		//sprintf(buffer, "%d.%d%s %d %s ", (int) bmp180_temperature/10, (int) bmp180_temperature%10, temp_units_2[tInd], (int) bmp180_pressure/100, pres_units[pInd]);
		sprintf(buffer, " %d%s %d %s", (int) bmp180_temperature, temp_units_2[tInd], (int) bmp180_pressure/100, pres_units[pInd]);
		lcd16x2_clear();
		lcd16x2_1stLine();
		lcd16x2_writeData((uint8_t)0);
		lcd16x2_printf(buffer);
		//int16_t dht_temp_int_part = (int) dht_temperature;
		//int16_t dht_temp_dec_part = (dht_temperature - ((int)dht_temperature))*10.0;
		//sprintf(buffer, "%d.%d%s %d", (int) dht_temperature, (int) dht_temp_dec_part, temp_units_2[tInd], (int) dht_humidity);
		sprintf(buffer, "%d%s %d", (int) dht_temperature, temp_units_2[tInd], (int) dht_humidity);
		lcd16x2_2ndLine();
		lcd16x2_printf(buffer);
		lcd16x2_printf("%% ");
		sprintf(buffer, "DP:%d%s", (int) dew_point, temp_units_2[tInd]);
		lcd16x2_printf(buffer);
		//HAL_Delay(1000);
		//float alt = bmp180_get_altitude();
		//float dew_point = dht_calc_dewpoint(&dht_humidity, &dht_temperature);
		//int8_t alt_dec_part = (alt - ((int)alt))*10.0;
		//int8_t dew_point_dec_part = (dew_point - ((int)dew_point))*10.0;
		//sprintf(buffer, "alt = %d m", (int) alt);//, (int) alt_dec_part);
		//lcd16x2_clear();
		//lcd16x2_1stLine();
		//lcd16x2_printf(buffer);
		/*sprintf(buffer, "dew_point = %d %%", (int) dew_point);//, (int) dew_point_dec_part);
		lcd16x2_2ndLine();
		lcd16x2_printf(buffer);*/
     }
	 else {
		 /* отримуємо з RTC поточний час */
		 HAL_RTC_GetTime(&hrtc, &rtc_time, RTC_FORMAT_BIN);
		 /* отримуємо з RTC поточну дату */
		 HAL_RTC_GetDate(&hrtc, &rtc_date, RTC_FORMAT_BIN);
		 /* виводимо у послідовний порт час у форматі: hh:mm:ss */
		 //sprintf((char*)time,"%02d:%02d:%02d", rtc_time.Hours, rtc_time.Minutes, rtc_time.Seconds);
		 //HAL_UART_Transmit(&huart1, buffer, strlen(buffer), 1000);
		 /* виводимо у послідовний порт дату у форматі: dd-mm-yy */
		 //sprintf((char*)date,"%02d-%02d-%2d", rtc_date.Date, rtc_date.Month, 2000 + rtc_date.Year);
		 //HAL_UART_Transmit(&huart1, buffer, strlen(buffer), 1000);
		 /* виводимо поточний час, день тижня, дату і назву місяця на дисплей */
		 lcd16x2_clear();
		 lcd16x2_1stLine();
		 lcd16x2_writeData((uint8_t)1);
		 sprintf(buffer, " %02d:%02d:%02d %s", rtc_time.Hours, rtc_time.Minutes, rtc_time.Seconds, days_of_week[rtc_date.WeekDay]);
		 lcd16x2_printf(buffer);
		 lcd16x2_2ndLine();
		 sprintf(buffer, "%02d/%02d/%d %s", rtc_date.Date, rtc_date.Month, 2000 + rtc_date.Year, months[rtc_date.Month-1]);
		 lcd16x2_printf(buffer);
	 }
	 if (HAL_GPIO_ReadPin(MENU_BTN_GPIO_Port, MENU_BTN_Pin) == GPIO_PIN_SET)
	 {
	   //HAL_GPIO_WritePin(GPIOD, GPIO_PIN_12, GPIO_PIN_SET);
	   main_menu();
	 }

	 if (HAL_GPIO_ReadPin(EXIT_BTN_GPIO_Port, EXIT_BTN_Pin) == GPIO_PIN_SET)
	 {
	  	  flag_weather_date = !flag_weather_date;
	 }
	 HAL_Delay(700);
    /* USER CODE END WHILE */

    /* USER CODE BEGIN 3 */
  }
  /* USER CODE END 3 */
}

/**
  * @brief System Clock Configuration
  * @retval None
  */
void SystemClock_Config(void)
{
  RCC_OscInitTypeDef RCC_OscInitStruct = {0};
  RCC_ClkInitTypeDef RCC_ClkInitStruct = {0};
  RCC_PeriphCLKInitTypeDef PeriphClkInit = {0};

  /** Initializes the RCC Oscillators according to the specified parameters
  * in the RCC_OscInitTypeDef structure.
  */
  RCC_OscInitStruct.OscillatorType = RCC_OSCILLATORTYPE_HSI|RCC_OSCILLATORTYPE_LSI;
  RCC_OscInitStruct.HSIState = RCC_HSI_ON;
  RCC_OscInitStruct.HSICalibrationValue = RCC_HSICALIBRATION_DEFAULT;
  RCC_OscInitStruct.LSIState = RCC_LSI_ON;
  RCC_OscInitStruct.PLL.PLLState = RCC_PLL_ON;
  RCC_OscInitStruct.PLL.PLLSource = RCC_PLLSOURCE_HSI;
  RCC_OscInitStruct.PLL.PLLMUL = RCC_PLL_MUL6;
  RCC_OscInitStruct.PLL.PREDIV = RCC_PREDIV_DIV1;
  if (HAL_RCC_OscConfig(&RCC_OscInitStruct) != HAL_OK)
  {
    Error_Handler();
  }

  /** Initializes the CPU, AHB and APB buses clocks
  */
  RCC_ClkInitStruct.ClockType = RCC_CLOCKTYPE_HCLK|RCC_CLOCKTYPE_SYSCLK
                              |RCC_CLOCKTYPE_PCLK1;
  RCC_ClkInitStruct.SYSCLKSource = RCC_SYSCLKSOURCE_PLLCLK;
  RCC_ClkInitStruct.AHBCLKDivider = RCC_SYSCLK_DIV1;
  RCC_ClkInitStruct.APB1CLKDivider = RCC_HCLK_DIV1;

  if (HAL_RCC_ClockConfig(&RCC_ClkInitStruct, FLASH_LATENCY_1) != HAL_OK)
  {
    Error_Handler();
  }
  PeriphClkInit.PeriphClockSelection = RCC_PERIPHCLK_I2C1|RCC_PERIPHCLK_RTC;
  PeriphClkInit.I2c1ClockSelection = RCC_I2C1CLKSOURCE_HSI;
  PeriphClkInit.RTCClockSelection = RCC_RTCCLKSOURCE_LSI;
  if (HAL_RCCEx_PeriphCLKConfig(&PeriphClkInit) != HAL_OK)
  {
    Error_Handler();
  }
}

/**
  * @brief I2C1 Initialization Function
  * @param None
  * @retval None
  */
static void MX_I2C1_Init(void)
{

  /* USER CODE BEGIN I2C1_Init 0 */

  /* USER CODE END I2C1_Init 0 */

  /* USER CODE BEGIN I2C1_Init 1 */

  /* USER CODE END I2C1_Init 1 */
  hi2c1.Instance = I2C1;
  hi2c1.Init.Timing = 0x2000090E;
  hi2c1.Init.OwnAddress1 = 0;
  hi2c1.Init.AddressingMode = I2C_ADDRESSINGMODE_7BIT;
  hi2c1.Init.DualAddressMode = I2C_DUALADDRESS_DISABLE;
  hi2c1.Init.OwnAddress2 = 0;
  hi2c1.Init.OwnAddress2Masks = I2C_OA2_NOMASK;
  hi2c1.Init.GeneralCallMode = I2C_GENERALCALL_DISABLE;
  hi2c1.Init.NoStretchMode = I2C_NOSTRETCH_DISABLE;
  if (HAL_I2C_Init(&hi2c1) != HAL_OK)
  {
    Error_Handler();
  }

  /** Configure Analogue filter
  */
  if (HAL_I2CEx_ConfigAnalogFilter(&hi2c1, I2C_ANALOGFILTER_ENABLE) != HAL_OK)
  {
    Error_Handler();
  }

  /** Configure Digital filter
  */
  if (HAL_I2CEx_ConfigDigitalFilter(&hi2c1, 0) != HAL_OK)
  {
    Error_Handler();
  }
  /* USER CODE BEGIN I2C1_Init 2 */

  /* USER CODE END I2C1_Init 2 */

}

/**
  * @brief RTC Initialization Function
  * @param None
  * @retval None
  */
static void MX_RTC_Init(void)
{

  /* USER CODE BEGIN RTC_Init 0 */

  /* USER CODE END RTC_Init 0 */

  RTC_TimeTypeDef sTime = {0};
  RTC_DateTypeDef sDate = {0};

  /* USER CODE BEGIN RTC_Init 1 */

  /* USER CODE END RTC_Init 1 */

  /** Initialize RTC Only
  */
  hrtc.Instance = RTC;
  hrtc.Init.HourFormat = RTC_HOURFORMAT_24;
  hrtc.Init.AsynchPrediv = 127;
  hrtc.Init.SynchPrediv = 255;
  hrtc.Init.OutPut = RTC_OUTPUT_DISABLE;
  hrtc.Init.OutPutPolarity = RTC_OUTPUT_POLARITY_HIGH;
  hrtc.Init.OutPutType = RTC_OUTPUT_TYPE_OPENDRAIN;
  if (HAL_RTC_Init(&hrtc) != HAL_OK)
  {
    Error_Handler();
  }

  /* USER CODE BEGIN Check_RTC_BKUP */

  /* USER CODE END Check_RTC_BKUP */

  /** Initialize RTC and set the Time and Date
  */
  sTime.Hours = 0x2;
  sTime.Minutes = 0x40;
  sTime.Seconds = 0x30;
  sTime.DayLightSaving = RTC_DAYLIGHTSAVING_NONE;
  sTime.StoreOperation = RTC_STOREOPERATION_RESET;
  if (HAL_RTC_SetTime(&hrtc, &sTime, RTC_FORMAT_BCD) != HAL_OK)
  {
    Error_Handler();
  }
  sDate.WeekDay = RTC_WEEKDAY_SATURDAY;
  sDate.Month = RTC_MONTH_MAY;
  sDate.Date = 0x4;
  sDate.Year = 0x24;

  if (HAL_RTC_SetDate(&hrtc, &sDate, RTC_FORMAT_BCD) != HAL_OK)
  {
    Error_Handler();
  }
  /* USER CODE BEGIN RTC_Init 2 */

  /* USER CODE END RTC_Init 2 */

}

/**
  * @brief TIM1 Initialization Function
  * @param None
  * @retval None
  */
static void MX_TIM1_Init(void)
{

  /* USER CODE BEGIN TIM1_Init 0 */

  /* USER CODE END TIM1_Init 0 */

  TIM_ClockConfigTypeDef sClockSourceConfig = {0};
  TIM_MasterConfigTypeDef sMasterConfig = {0};

  /* USER CODE BEGIN TIM1_Init 1 */

  /* USER CODE END TIM1_Init 1 */
  htim1.Instance = TIM1;
  htim1.Init.Prescaler = 48-1;
  htim1.Init.CounterMode = TIM_COUNTERMODE_UP;
  htim1.Init.Period = 0xFFFF-1;
  htim1.Init.ClockDivision = TIM_CLOCKDIVISION_DIV1;
  htim1.Init.RepetitionCounter = 0;
  htim1.Init.AutoReloadPreload = TIM_AUTORELOAD_PRELOAD_DISABLE;
  if (HAL_TIM_Base_Init(&htim1) != HAL_OK)
  {
    Error_Handler();
  }
  sClockSourceConfig.ClockSource = TIM_CLOCKSOURCE_INTERNAL;
  if (HAL_TIM_ConfigClockSource(&htim1, &sClockSourceConfig) != HAL_OK)
  {
    Error_Handler();
  }
  sMasterConfig.MasterOutputTrigger = TIM_TRGO_RESET;
  sMasterConfig.MasterSlaveMode = TIM_MASTERSLAVEMODE_DISABLE;
  if (HAL_TIMEx_MasterConfigSynchronization(&htim1, &sMasterConfig) != HAL_OK)
  {
    Error_Handler();
  }
  /* USER CODE BEGIN TIM1_Init 2 */

  /* USER CODE END TIM1_Init 2 */

}

/**
  * @brief USART2 Initialization Function
  * @param None
  * @retval None
  */
static void MX_USART2_UART_Init(void)
{

  /* USER CODE BEGIN USART2_Init 0 */

  /* USER CODE END USART2_Init 0 */

  /* USER CODE BEGIN USART2_Init 1 */

  /* USER CODE END USART2_Init 1 */
  huart2.Instance = USART2;
  huart2.Init.BaudRate = 38400;
  huart2.Init.WordLength = UART_WORDLENGTH_8B;
  huart2.Init.StopBits = UART_STOPBITS_1;
  huart2.Init.Parity = UART_PARITY_NONE;
  huart2.Init.Mode = UART_MODE_TX_RX;
  huart2.Init.HwFlowCtl = UART_HWCONTROL_NONE;
  huart2.Init.OverSampling = UART_OVERSAMPLING_16;
  huart2.Init.OneBitSampling = UART_ONE_BIT_SAMPLE_DISABLE;
  huart2.AdvancedInit.AdvFeatureInit = UART_ADVFEATURE_NO_INIT;
  if (HAL_UART_Init(&huart2) != HAL_OK)
  {
    Error_Handler();
  }
  /* USER CODE BEGIN USART2_Init 2 */

  /* USER CODE END USART2_Init 2 */

}

/**
  * @brief GPIO Initialization Function
  * @param None
  * @retval None
  */
static void MX_GPIO_Init(void)
{
  GPIO_InitTypeDef GPIO_InitStruct = {0};
/* USER CODE BEGIN MX_GPIO_Init_1 */
/* USER CODE END MX_GPIO_Init_1 */

  /* GPIO Ports Clock Enable */
  __HAL_RCC_GPIOF_CLK_ENABLE();
  __HAL_RCC_GPIOA_CLK_ENABLE();
  __HAL_RCC_GPIOB_CLK_ENABLE();

  /*Configure GPIO pin Output Level */
  HAL_GPIO_WritePin(GPIOA, LCD_DB7_Pin|LCD_DB6_Pin|LCD_DB5_Pin|LCD_DB4_Pin
                          |LCD_RS_Pin|LCD_EN_Pin, GPIO_PIN_RESET);

  /*Configure GPIO pin Output Level */
  HAL_GPIO_WritePin(GPIOB, LED_GREEN_Pin|DHT_DATA_Pin, GPIO_PIN_RESET);

  /*Configure GPIO pins : LCD_DB7_Pin LCD_DB6_Pin LCD_DB5_Pin LCD_DB4_Pin
                           LCD_RS_Pin LCD_EN_Pin */
  GPIO_InitStruct.Pin = LCD_DB7_Pin|LCD_DB6_Pin|LCD_DB5_Pin|LCD_DB4_Pin
                          |LCD_RS_Pin|LCD_EN_Pin;
  GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;
  HAL_GPIO_Init(GPIOA, &GPIO_InitStruct);

  /*Configure GPIO pin : EXIT_BTN_Pin */
  GPIO_InitStruct.Pin = EXIT_BTN_Pin;
  GPIO_InitStruct.Mode = GPIO_MODE_INPUT;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  HAL_GPIO_Init(EXIT_BTN_GPIO_Port, &GPIO_InitStruct);

  /*Configure GPIO pins : MENU_BTN_Pin SEL_PLUS_BTN_Pin SEL_MINUS_BTN_Pin */
  GPIO_InitStruct.Pin = MENU_BTN_Pin|SEL_PLUS_BTN_Pin|SEL_MINUS_BTN_Pin;
  GPIO_InitStruct.Mode = GPIO_MODE_INPUT;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  HAL_GPIO_Init(GPIOB, &GPIO_InitStruct);

  /*Configure GPIO pins : LED_GREEN_Pin DHT_DATA_Pin */
  GPIO_InitStruct.Pin = LED_GREEN_Pin|DHT_DATA_Pin;
  GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;
  HAL_GPIO_Init(GPIOB, &GPIO_InitStruct);

/* USER CODE BEGIN MX_GPIO_Init_2 */
/* USER CODE END MX_GPIO_Init_2 */
}

/* USER CODE BEGIN 4 */

/* USER CODE END 4 */

/**
  * @brief  This function is executed in case of error occurrence.
  * @retval None
  */
void Error_Handler(void)
{
  /* USER CODE BEGIN Error_Handler_Debug */
  /* User can add his own implementation to report the HAL error return state */
  __disable_irq();
  while (1)
  {
  }
  /* USER CODE END Error_Handler_Debug */
}

#ifdef  USE_FULL_ASSERT
/**
  * @brief  Reports the name of the source file and the source line number
  *         where the assert_param error has occurred.
  * @param  file: pointer to the source file name
  * @param  line: assert_param error line source number
  * @retval None
  */
void assert_failed(uint8_t *file, uint32_t line)
{
  /* USER CODE BEGIN 6 */
  /* User can add his own implementation to report the file name and line number,
     ex: printf("Wrong parameters value: file %s on line %d\r\n", file, line) */
  /* USER CODE END 6 */
}
#endif /* USE_FULL_ASSERT */
