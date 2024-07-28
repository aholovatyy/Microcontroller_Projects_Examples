/*************************************************** 
  This is an example for the SHT31-D Humidity & Temp Sensor

  Designed specifically to work with the SHT31-D sensor from Adafruit
  ----> https://www.adafruit.com/products/2857

  These sensors use I2C to communicate, 2 pins are required to  
  interface
 ****************************************************/
 
#include <Arduino.h>
#include <Wire.h>
#include "Adafruit_SHT31.h"
#include <SPI.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>

Adafruit_SHT31 sht31 = Adafruit_SHT31();

#define SCREEN_WIDTH 128 // OLED display width, in pixels
#define SCREEN_HEIGHT 64 // OLED display height, in pixels

// Comment out above, uncomment this block to use hardware SPI
#define OLED_DC     6
#define OLED_CS     7
#define OLED_RESET  8

Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT,
  &SPI, OLED_DC, OLED_RESET, OLED_CS);


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
  
  display.setTextSize(2);             // Draw 2X-scale text
  display.setTextColor(SSD1306_WHITE);
  display.setCursor(0, 0);
  
  Serial.println("SHT31 test");
  display.println(F("SHT31 test"));
  display.print(F("..."));
  display.display();
  
  if (! sht31.begin(0x44)) { // Set to 0x45 for alternate i2c addr
    Serial.println("Couldn't find SHT31");
    display.setTextSize(1); 
    display.println(); 
    display.print(F("Couldn't find SHT31"));
    display.display();
    while (1) delay(1);
  }
  display.println(F("ok!"));
  display.display();
  delay(2000);
}


void loop() {
  float t = sht31.readTemperature();
  float h = sht31.readHumidity();
  
  /*display.clearDisplay();
  display.setTextSize(2);
  display.setTextColor(SSD1306_WHITE);
  display.setCursor(0, 0);
  display.println(F("Tmp & Hum"));
  display.display();
  */
  
  /*if (! isnan(t)) {  // check if 'is not a number'
    Serial.print("Temp *C = "); Serial.println(t);
    char temp_disp_buff[11];    
    dtostrf(t, 2, 1, temp_disp_buff);    
    strcat(temp_disp_buff, " °C");
    display.println(temp_disp_buff); 
    //display.display();
  } else { 
    Serial.println("Failed to read temperature");
    display.println("Failed to read temperature");
  }
  
  if (! isnan(h)) {  // check if 'is not a number'
    Serial.print("Hum. % = "); Serial.println(h);
    char hum_disp_buff[11];
    dtostrf(h, 2, 1, hum_disp_buff);
    strcat(hum_disp_buff, "% RH")
    display.println(hum_disp_buff); 
    //display.display();
  } else { 
    Serial.println("Failed to read humidity");
    display.println("Failed to read humidity");
  }
  display.display(); // Update screen
  */

  if (isnan(t) || isnan(h)) {
    Serial.println("Failed to read temperature or humidity");
  }
  else {
    String temp_disp_buff = String(t);
    String hum_disp_buff = String(h);
    temp_disp_buff += ' ';  temp_disp_buff += (char)247;  temp_disp_buff += 'C';    
    hum_disp_buff += " %RH";  
    Serial.print("Temp *C = "); Serial.println(t);
    Serial.print("Hum. % = "); Serial.println(h);
    //display.print((char)247); // degree symbol 
    //display.println("C");
    //
    display.clearDisplay();
    display.setTextSize(2);
    display.setTextColor(SSD1306_WHITE);
    display.setCursor(0, 0);
    display.println(F("Temp & Hum"));
    display.println(temp_disp_buff);
    display.println(hum_disp_buff);
    display.display();
  }  
  Serial.println();
  delay(1000);
}
