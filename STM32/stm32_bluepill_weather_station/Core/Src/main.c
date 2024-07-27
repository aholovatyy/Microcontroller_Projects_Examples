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
  Цифрова метеостанція на мікроконтролері STM32F103C8T6, плата STM32 Blue Pill
  (Digital weather station based on STM32F103C8T6 microcontroller, STM32 Blue Pill board)
  */
/* USER CODE END Header */
/* Includes ------------------------------------------------------------------*/
#include "main.h"

/* Private includes ----------------------------------------------------------*/
/* USER CODE BEGIN Includes */
#include "lcd16x2.h"
#include "bmp180.h"
#include "dht.h"
#include "ds1307.h"
#include "stdio.h"
#include "stdlib.h"
#include "string.h"
/* USER CODE END Includes */

/* Private typedef -----------------------------------------------------------*/
/* USER CODE BEGIN PTD */

/* USER CODE END PTD */

/* Private define ------------------------------------------------------------*/
/* USER CODE BEGIN PD */
#define MENU_BTN_PIN 8
#define SEL_PLUS_BTN_PIN 9
#define SEL_MINUS_BTN_PIN 10
#define EXIT_BTN_PIN 11
#define INTERRUPT_PIN 8

const char *temp_units_1[] = {"\xb0\C", "\xb0\F", "K"};
const char *temp_units_2[] = {"\xdf\C", "\xdf\F", "K"};
const char *pres_units[] = {"mb", "mmHg", "inHg", "hPa"};
const char *days_of_week[7] = { "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat" };

/* USER CODE END PD */

/* Private macro -------------------------------------------------------------*/
/* USER CODE BEGIN PM */

/* USER CODE END PM */

/* Private variables ---------------------------------------------------------*/
I2C_HandleTypeDef hi2c1;

TIM_HandleTypeDef htim1;

UART_HandleTypeDef huart1;

/* USER CODE BEGIN PV */
char buffer[200];
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
/* USER CODE END PV */

/* Private function prototypes -----------------------------------------------*/
void SystemClock_Config(void);
static void MX_GPIO_Init(void);
static void MX_I2C1_Init(void);
static void MX_USART1_UART_Init(void);
static void MX_TIM1_Init(void);
/* USER CODE BEGIN PFP */
//bool isButtonPressed(int buttonPin);
void set_pressure_unit();
void set_temperature_unit();
void main_menu();

volatile bool main_menu_call = false;
int8_t pInd = 3, tInd = 0;

/* USER CODE END PFP */

/* Private user code ---------------------------------------------------------*/
/* USER CODE BEGIN 0 */
void delay_us(uint16_t us)
{
    htim1.Instance->CNT = 0;
    while (htim1.Instance->CNT < us);
}

void delay_ms(volatile uint16_t ms)
{
	while(ms > 0)
	{
		htim1.Instance->CNT = 0;
		ms--;
		while (htim1.Instance->CNT < 1000);
	}
}

// EXTI Line9 External Interrupt ISR Handler CallBackFun
void HAL_GPIO_EXTI_Callback(uint16_t GPIO_Pin)
{
    if (GPIO_Pin == GPIO_PIN_8) // If The INT Source Is EXTI Line9 (A9 Pin)
    {
    	HAL_GPIO_TogglePin(GPIOB, GPIO_PIN_13); // Toggle The Output (LED) Pin
    	//mainMenu();
    	//HAL_UART_Transmit(&huart1, "interrupt", 9, 10);
    	main_menu_call = true;
    	//HAL_NVIC_EnableIRQ(EXTI9_5_IRQn);
    	HAL_NVIC_DisableIRQ(EXTI9_5_IRQn);
    }
}

void set_time(void)
{
    //RTC_TimeTypeDef rtc_time;
    unsigned char i = 0, col = 2;
    const char *time_items[] = { "hh", "mm", "ss", "^^" };
    uint8_t hours = 0, minutes = 0, seconds = 0;
 	bool lcd_output_flag = true, ok = 0;

 	hours = ds1307_get_hour();
 	minutes = ds1307_get_minute();
 	seconds = ds1307_get_second();

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

    ds1307_set_hour(hours);
    ds1307_set_minute(minutes);
    ds1307_set_second(seconds);
}

void set_date(void)
{
	//RTC_DateTypeDef rtc_date;
	const char *date_items[] = { "dd", "mm", "yy" , "wd", "^^"};
	uint8_t day = 0, month = 0, year = 0, dow = 0;
	uint8_t i = 0, col = 0;
	bool lcd_output_flag = true, ok = 0;

	day = ds1307_get_date();
	month = ds1307_get_month();
	year = ds1307_get_year();
	dow = ds1307_get_day_of_week()-1;

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
	ds1307_set_date(day);
	ds1307_set_month(month);
	ds1307_set_year(2000+year);
	ds1307_set_day_of_week(dow+1);
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

  while(1)
  {
    if (lcd_output_flag)
    {
      lcd16x2_clear();
      lcd16x2_setCursor(0,0);
      lcd16x2_printf(temperature_units_menu_title);
      lcd16x2_setCursor(1,0);
      lcd16x2_printf(">>");
      lcd16x2_setCursor(1,14);
      lcd16x2_printf("<<");
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
  char title[] = "*** STM32 MCU BASED WEATHER STATION ***\r\n*** DEVELOPED BY IHOR BIZHYK, 2024 ***\r\n";
  float dht_temperature = 0.0f, dht_humidity = 0.0f;
  float bmp180_temperature = 0.0f;
  int32_t bmp180_pressure = 0;
  bool flag_weather_date = 0;
  /* Lookup table for the days of week. */
  const char *months[12] = {"Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"};

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
  MX_USART1_UART_Init();
  MX_TIM1_Init();
  /* USER CODE BEGIN 2 */
  HAL_TIM_Base_Start(&htim1);
  lcd16x2_init_4bits(GPIOA, LCD_RS_Pin, LCD_EN_Pin,
        GPIOA, LCD_DB4_Pin, LCD_DB5_Pin, LCD_DB6_Pin, LCD_DB7_Pin);
  lcd16x2_custom_char(0, temp_icon);
  lcd16x2_custom_char(1, clock_icon);
  lcd16x2_custom_char(2, smile_icon);
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
  lcd16x2_printf("IHOR BIZHYK 2024");
  HAL_Delay(1000);

  HAL_UART_Transmit(&huart1, (uint8_t *)title, strlen(title), 0xff);
  bmp180_init(&hi2c1);
  bmp180_set_oversampling(BMP180_STANDARD); //BMP180_ULTRA);
  //* Update calibration data. Must be called once before entering main loop. */
  bmp180_update_calibration_data();
  //
  dht_init(DHT_DATA_GPIO_Port, DHT_DATA_Pin, &htim1);
  /* Start DS1307 timing. Pass user I2C handle pointer to function. */
  ds1307_init(&hi2c1);
  ds1307_set_interrupt_rate(DS1307_1HZ);
  ds1307_set_enable_square_wave(DS1307_ENABLED);
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
    /* USER CODE END WHILE */

    /* USER CODE BEGIN 3 */
	HAL_GPIO_TogglePin(GPIOB, GPIO_PIN_13);
	if (!flag_weather_date)
	{
		/* отримуємо/визначаємо ціле значення температури з давача bmp180 */
		//bmp180_temperature = bmp180_get_raw_temperature();
		/* отримуємо/визначаємо дійсне значення температури з давача bmp180 */
		bmp180_temperature = bmp180_get_temperature();
		/* читаємо дані тиску з давача bmp180 */
		bmp180_pressure = bmp180_get_pressure();
		/* читаємо дані про вологість і температуру */
		dht_read(&dht_humidity, &dht_temperature);
		/* обчислюємо значення точки роси */
		float dew_point = dht_calc_dewpoint(&dht_humidity, &dht_temperature);

		switch (pInd)
		{
			/*case 0:
	      	  bmp180_pressure = bmp180_pressure;
	   	   	   break;*/
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
		/*вивід у послідовний порт */
		sprintf(buffer, "BMP180: Temp = %.1f%s, Pres = %d %s\r\n", bmp180_temperature, temp_units_1[tInd], bmp180_pressure/100, pres_units[pInd]);
		HAL_UART_Transmit(&huart1, buffer, strlen(buffer), 0xff);
		HAL_UART_Transmit(&huart1, "DHT22: ", 7, 0xff);
		//sprintf(buffer, "Temp = %.1f\xb0\C ", dht_temperature);
		sprintf(buffer, "Temp = %.1f%s ", dht_temperature, temp_units_1[tInd]);
		HAL_UART_Transmit(&huart1, (uint8_t *)buffer, strlen(buffer), 0xff);
		sprintf(buffer, "Humi = %.1f%% ", dht_humidity);
		HAL_UART_Transmit(&huart1, (uint8_t *)buffer, strlen(buffer), 0xff);
		sprintf(buffer, "Dew Point = %.1f%s\r\n", dew_point, temp_units_1[tInd]);
		HAL_UART_Transmit(&huart1, (uint8_t *)buffer, strlen(buffer), 0xff);
		/* вивід на дисплей */
		lcd16x2_clear();
		lcd16x2_1stLine();
		lcd16x2_writeData((uint8_t)0);
		//sprintf(buffer, "%.1f\xdf\C %d hPa", bmp180_temperature, (int) bmp180_pressure / 100);
		//sprintf(buffer, "%.1f%s %d %s", bmp180_temperature, temp_units_2[tInd], (int) bmp180_pressure/100, pres_units[pInd]);
		sprintf(buffer, " %d%s %d %s", (int) bmp180_temperature, temp_units_2[tInd], (int) bmp180_pressure/100, pres_units[pInd]);
		lcd16x2_printf(buffer);
		lcd16x2_2ndLine();
		//sprintf(buffer, "%.1f%s %.1f", dht_temperature, temp_units_2[tInd], dht_humidity);
		sprintf(buffer, "%d%s %d", (int) dht_temperature, temp_units_2[tInd], (int) dht_humidity);
		lcd16x2_printf(buffer);
		lcd16x2_printf("%% ");
		sprintf(buffer, "DP:%d%s", (int) dew_point, temp_units_2[tInd]);
		lcd16x2_printf(buffer);
	} else {
		/* отримуємо з RTC DS1307 поточну дату і час */
		uint8_t date = ds1307_get_date();
		uint8_t month = ds1307_get_month();
		uint16_t year = ds1307_get_year();
		uint8_t dow = ds1307_get_day_of_week();
		uint8_t hour = ds1307_get_hour();
		uint8_t minute = ds1307_get_minute();
		uint8_t second = ds1307_get_second();
		int8_t zone_hr = ds1307_get_time_zone_hour();
		uint8_t zone_min = ds1307_get_time_zone_min();
		/* виводимо поточний час, день тижня, дату і назву місяця у послідовний порт */
		sprintf(buffer, "Date: %02d/%02d/%02d Time: %02d:%02d:%02d %s\r\n",
					date, month, year, hour, minute, second, days_of_week[dow-1]);
		HAL_UART_Transmit(&huart1, buffer, strlen(buffer), 1000);
		/* виводимо поточний час, день тижня, дату і назву місяця на дисплей */
		lcd16x2_clear();
		lcd16x2_1stLine();
		lcd16x2_writeData((uint8_t)2);
		sprintf(buffer, " %02d:%02d:%02d %s", hour, minute, second, days_of_week[dow-1]);
		lcd16x2_printf(buffer);
		lcd16x2_2ndLine();
		sprintf(buffer, "%02d/%02d/%d %s", date, month, year, months[month-1]);
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

    /*if (main_menu_call)
    {
	  HAL_NVIC_DisableIRQ(EXTI9_5_IRQn);
	  main_menu_call = false;
	  main_menu();
	  HAL_NVIC_EnableIRQ(EXTI9_5_IRQn);
    }*/
	HAL_Delay(700);
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

  /** Initializes the RCC Oscillators according to the specified parameters
  * in the RCC_OscInitTypeDef structure.
  */
  RCC_OscInitStruct.OscillatorType = RCC_OSCILLATORTYPE_HSI;
  RCC_OscInitStruct.HSIState = RCC_HSI_ON;
  RCC_OscInitStruct.HSICalibrationValue = RCC_HSICALIBRATION_DEFAULT;
  RCC_OscInitStruct.PLL.PLLState = RCC_PLL_NONE;
  if (HAL_RCC_OscConfig(&RCC_OscInitStruct) != HAL_OK)
  {
    Error_Handler();
  }

  /** Initializes the CPU, AHB and APB buses clocks
  */
  RCC_ClkInitStruct.ClockType = RCC_CLOCKTYPE_HCLK|RCC_CLOCKTYPE_SYSCLK
                              |RCC_CLOCKTYPE_PCLK1|RCC_CLOCKTYPE_PCLK2;
  RCC_ClkInitStruct.SYSCLKSource = RCC_SYSCLKSOURCE_HSI;
  RCC_ClkInitStruct.AHBCLKDivider = RCC_SYSCLK_DIV1;
  RCC_ClkInitStruct.APB1CLKDivider = RCC_HCLK_DIV1;
  RCC_ClkInitStruct.APB2CLKDivider = RCC_HCLK_DIV1;

  if (HAL_RCC_ClockConfig(&RCC_ClkInitStruct, FLASH_LATENCY_0) != HAL_OK)
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
  hi2c1.Init.ClockSpeed = 100000;
  hi2c1.Init.DutyCycle = I2C_DUTYCYCLE_2;
  hi2c1.Init.OwnAddress1 = 0;
  hi2c1.Init.AddressingMode = I2C_ADDRESSINGMODE_7BIT;
  hi2c1.Init.DualAddressMode = I2C_DUALADDRESS_DISABLE;
  hi2c1.Init.OwnAddress2 = 0;
  hi2c1.Init.GeneralCallMode = I2C_GENERALCALL_DISABLE;
  hi2c1.Init.NoStretchMode = I2C_NOSTRETCH_DISABLE;
  if (HAL_I2C_Init(&hi2c1) != HAL_OK)
  {
    Error_Handler();
  }
  /* USER CODE BEGIN I2C1_Init 2 */

  /* USER CODE END I2C1_Init 2 */

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
  htim1.Init.Prescaler = 8-1;
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
  * @brief USART1 Initialization Function
  * @param None
  * @retval None
  */
static void MX_USART1_UART_Init(void)
{

  /* USER CODE BEGIN USART1_Init 0 */

  /* USER CODE END USART1_Init 0 */

  /* USER CODE BEGIN USART1_Init 1 */

  /* USER CODE END USART1_Init 1 */
  huart1.Instance = USART1;
  huart1.Init.BaudRate = 9600;
  huart1.Init.WordLength = UART_WORDLENGTH_8B;
  huart1.Init.StopBits = UART_STOPBITS_1;
  huart1.Init.Parity = UART_PARITY_NONE;
  huart1.Init.Mode = UART_MODE_TX_RX;
  huart1.Init.HwFlowCtl = UART_HWCONTROL_NONE;
  huart1.Init.OverSampling = UART_OVERSAMPLING_16;
  if (HAL_UART_Init(&huart1) != HAL_OK)
  {
    Error_Handler();
  }
  /* USER CODE BEGIN USART1_Init 2 */

  /* USER CODE END USART1_Init 2 */

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
  __HAL_RCC_GPIOD_CLK_ENABLE();
  __HAL_RCC_GPIOA_CLK_ENABLE();
  __HAL_RCC_GPIOB_CLK_ENABLE();

  /*Configure GPIO pin Output Level */
  HAL_GPIO_WritePin(GPIOA, LCD_RS_Pin|LCD_EN_Pin|LCD_DB4_Pin|LCD_DB5_Pin
                          |LCD_DB6_Pin|LCD_DB7_Pin, GPIO_PIN_RESET);

  /*Configure GPIO pin Output Level */
  HAL_GPIO_WritePin(GPIOB, GPIO_PIN_2|DHT_DATA_Pin|LED_Pin, GPIO_PIN_RESET);

  /*Configure GPIO pins : LCD_RS_Pin LCD_EN_Pin LCD_DB4_Pin LCD_DB5_Pin
                           LCD_DB6_Pin LCD_DB7_Pin */
  GPIO_InitStruct.Pin = LCD_RS_Pin|LCD_EN_Pin|LCD_DB4_Pin|LCD_DB5_Pin
                          |LCD_DB6_Pin|LCD_DB7_Pin;
  GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;
  HAL_GPIO_Init(GPIOA, &GPIO_InitStruct);

  /*Configure GPIO pin : PB2 */
  GPIO_InitStruct.Pin = GPIO_PIN_2;
  GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_HIGH;
  HAL_GPIO_Init(GPIOB, &GPIO_InitStruct);

  /*Configure GPIO pins : SEL_MINUS_BTN_Pin EXIT_BTN_Pin SEL_PLUS_BTN_Pin */
  GPIO_InitStruct.Pin = SEL_MINUS_BTN_Pin|EXIT_BTN_Pin|SEL_PLUS_BTN_Pin;
  GPIO_InitStruct.Mode = GPIO_MODE_INPUT;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  HAL_GPIO_Init(GPIOB, &GPIO_InitStruct);

  /*Configure GPIO pins : DHT_DATA_Pin LED_Pin */
  GPIO_InitStruct.Pin = DHT_DATA_Pin|LED_Pin;
  GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;
  HAL_GPIO_Init(GPIOB, &GPIO_InitStruct);

  /*Configure GPIO pin : MENU_BTN_Pin */
  GPIO_InitStruct.Pin = MENU_BTN_Pin;
  GPIO_InitStruct.Mode = GPIO_MODE_INPUT;
  GPIO_InitStruct.Pull = GPIO_PULLDOWN;
  HAL_GPIO_Init(MENU_BTN_GPIO_Port, &GPIO_InitStruct);

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
