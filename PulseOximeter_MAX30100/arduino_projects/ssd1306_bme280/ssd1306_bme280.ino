/*************************************************** 
  This is an example for the SHT31-D Humidity & Temp Sensor

  Designed specifically to work with the SHT31-D sensor from Adafruit
  ----> https://www.adafruit.com/products/2857

  These sensors use I2C to communicate, 2 pins are required to  
  interface
 ****************************************************/
 
#include <Arduino.h>
#include <Wire.h>
#include <Adafruit_BME280.h> // бібліотека для роботи з сенсором температури, вологості і тиску BME280
#include <SPI.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>

// піни плати Arduino для програмного SPI
/*#define BME_SCK 13
#define BME_MISO 12
#define BME_MOSI 11
#define BME_CS 10*/

#define SEA_LEVEL_PRESSURE_HPA (1028.00) // тиск над рівнем моря для Львова 1028 гПа

Adafruit_BME280 bme; // підключення по I2C
//Adafruit_BME280 bme(BME_CS); // апаратний SPI
//Adafruit_BME280 bme(BME_CS, BME_MOSI, BME_MISO, BME_SCK); // програмний SPI

#define SCREEN_WIDTH 128 // OLED display width, in pixels
#define SCREEN_HEIGHT 64 // OLED display height, in pixels

// Comment out above, uncomment this block to use hardware SPI
#define OLED_DC     6
#define OLED_CS     7
#define OLED_RESET  8

Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT,
  &SPI, OLED_DC, OLED_RESET, OLED_CS);
  
float temperature = 0.0f, humidity = 0.0f, pressure = 0.0f;

void setup() {
  Serial.begin(9600);
  
  //while (!Serial)
    //delay(10);     // will pause Zero, Leonardo, etc until serial console opens

  // SSD1306_SWITCHCAPVCC = generate display voltage from 3.3V internally
  if(!display.begin(SSD1306_SWITCHCAPVCC)) {
    Serial.println(F("SSD1306 allocation failed"));
    for(;;); // Don't proceed, loop forever
  }

  // Show initial display buffer contents on the screen --
  // the library initializes this with an Adafruit splash screen.
  display.display();
  delay(2000); // Pause for 2 seconds

  // Clear the buffer
  display.clearDisplay();
  
  display.setTextSize(1);             // Draw 2X-scale text
  display.setTextColor(SSD1306_WHITE);
  
  Serial.println(F("BME280 тест..."));
  display.println(F("BME280 test..."));
  display.display();
  // налаштування за замовчуванням. Можемо також передати об'єкт бібліотеки Wire як &Wire2)
  unsigned status = bme.begin(BME280_ADDRESS_ALTERNATE);  
    if (!status) {
        Serial.println("Не можливо знайти робочий сенсор BME280, перевірте підлючення, адрес, ID - сенсора !");
        Serial.print("SensorID був: 0x"); Serial.println(bme.sensorID(),16);
        Serial.print("        ID 0xFF можливо означає поганий адрес, BMP 180 або BMP 085\n");
        Serial.print("   ID 0x56-0x58 представляє сенсор BMP280,\n");
        Serial.print("        ID 0x60 представляє сенсор BME280.\n");
        Serial.print("        ID 0x61 представляє сенсор BME680.\n");
        while (1);
    }    
    Serial.println("пройдено");
    display.println(F("ok!"));
    display.display();
    delay(2000);
}

void loop() {
  // зчитуємо температуру, вологість і тиск з сенсора BME280
  temperature = bme.readTemperature();  
  humidity = bme.readHumidity();     
  pressure = bme.readPressure() / 100.0F * 0.7500616827;  
   
  /*display.clearDisplay();
  display.setTextSize(2);
  display.setTextColor(SSD1306_WHITE);
  display.setCursor(0, 0);
  display.println(F("T, H, P"));*/
  
  /*if (! isnan(temperature)) {  // check if 'is not a number'
    Serial.print("Temp *C = "); Serial.println(temperature);
    char temp_disp_buff[11];    
    dtostrf(t, 2, 1, temp_disp_buff);    
    strcat(temp_disp_buff, " °C");
    display.println(temp_disp_buff); 
    display.display();
  } else { 
    Serial.println("Failed to read temperature");
    display.println("Failed to read temperature");
  }
  
  if (! isnan(humidity)) {  // check if 'is not a number'
    Serial.print("Hum. % = "); Serial.println(humidity);
    char hum_disp_buff[11];
    dtostrf(h, 2, 1, hum_disp_buff);
    strcat(hum_disp_buff, "% RH")
    display.println(hum_disp_buff); 
    display.display();
  } else { 
    Serial.println("Failed to read humidity");
    display.println("Failed to read humidity");
  }
  
  if (! isnan(pressure)) {  // check if 'is not a number'
    Serial.print("Press. mmHg = "); Serial.println(pressure);
    char hum_disp_buff[11];
    dtostrf(h, 2, 1, press_disp_buff);
    strcat(press_disp_buff, " mmHg")
    display.println(press_disp_buff); 
    display.display();
  } else { 
    Serial.println("Failed to read pressure");
    display.println("Failed to read pressure");
  }
  */

  if (isnan(temperature) || isnan(humidity) || isnan(pressure)) {
    Serial.println("Failed to read!");
  }
  else {
    String temp_disp_buff = String(temperature);
    String hum_disp_buff = String(humidity);
    String press_disp_buff = String(pressure,1);
    temp_disp_buff += ' ';  temp_disp_buff += (char)247;  temp_disp_buff += 'C';    
    hum_disp_buff += " %RH";  
    press_disp_buff += " mmHg";
    
    
    Serial.print("Temp *C = "); Serial.println(temperature);
    Serial.print("Hum. % = "); Serial.println(humidity);
    Serial.print("Press. mmHg = "); Serial.println(pressure);

    Serial.print("Температура = ");
    Serial.print(temperature);
    Serial.write(176);
    Serial.println("C"); 

    Serial.print("Вологiсть = "); 
    Serial.print(humidity);
    Serial.println(" %");

    Serial.print("Атмосферний тиск = "); 
    Serial.print(pressure);
    Serial.println(" мм.рт.ст.");

    display.clearDisplay();
    display.setTextSize(2);
    display.setTextColor(SSD1306_WHITE);
    display.setCursor(0, 0);
    display.println(F("BME280"));
    display.println(temp_disp_buff);
    display.println(hum_disp_buff);
    //display.display();
    //display.setTextSize(1); 
    display.println(press_disp_buff);
    display.display();
  }  
  Serial.println();
  delay(1000);
}
