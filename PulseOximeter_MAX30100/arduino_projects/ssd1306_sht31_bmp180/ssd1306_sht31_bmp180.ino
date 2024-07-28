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
#include <SFE_BMP180.h> // бібліотека давача тиску BMP180
#include <SPI.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>

#define ALTITUDE 289.0 // Середня висота Львова над рівнем моря в метрах

// You will need to create an SFE_BMP180 object, here called "pressure":
SFE_BMP180 pressure;

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
  
  Serial.println("SHT31 init");
  // Clear the buffer
  display.clearDisplay();  
  display.setTextSize(2);             // Draw 2X-scale text
  display.setTextColor(SSD1306_WHITE);
  display.setCursor(0, 0);
  display.println(F("Initialize"));
  display.setTextSize(1); 
  display.println(F("SHT31 sensor"));
  display.print(F("..."));
  display.display();
  
  if (! sht31.begin(0x44)) { // Set to 0x45 for alternate i2c addr
    Serial.println("Couldn't find SHT31");
    display.println(F("fail"));
    display.display();
    while(1);
  }
  display.println(F("success!"));
  
  // Initialize the sensor (it is important to get calibration values stored on the device).
  display.println(F("BMP180 sensor"));
  display.print(F("...")); 
  display.display();
  if (pressure.begin()) {
    Serial.println("BMP180 init success");
    display.print(F("success!"));
    display.display();
  } 
  else {
    // Oops, something went wrong, this is usually a connection problem,
    // see the comments at the top of this sketch for the proper connections.
    Serial.println("BMP180 init fail\n\n");
    display.print(F("fail"));
    display.display();
    while(1); // Pause forever.
  }
  delay(3000);
}


void loop() {
  float sht31_temp, sht31_hum;
  double bmp180_temp, bmp180_press, p0, a;
  char status;
  
  sht31_temp = sht31.readTemperature();
  sht31_hum = sht31.readHumidity();

  /*display.clearDisplay();
  display.setTextSize(2);
  display.setTextColor(SSD1306_WHITE);
  display.setCursor(0, 0);
  display.println(F("Tmp & Hum"));
  display.display();
  */
  
  /*if (! isnan(sht31_temp)) {  // check if 'is not a number'
    Serial.print("Temp *C = "); Serial.println(sht31_temp);
    char temp_disp_buff[11];    
    dtostrf(t, 2, 1, temp_disp_buff);    
    strcat(temp_disp_buff, " °C");
    display.println(temp_disp_buff); 
    //display.display();
  } else { 
    Serial.println("Failed to read temperature");
    display.println("Failed to read temperature");
  }
  
  if (! isnan(sht31_hum)) {  // check if 'is not a number'
    Serial.print("Hum. % = "); Serial.println(sht31_hum);
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

  if (isnan(sht31_temp) || isnan(sht31_hum)) {
    Serial.println("Failed to read temperature or humidity");
  }
  else {
    String temp_disp_buff = String(sht31_temp);
    String hum_disp_buff = String(sht31_hum);
    temp_disp_buff += ' ';  temp_disp_buff += (char)247;  temp_disp_buff += 'C';    
    hum_disp_buff += " %RH";  
    Serial.print("Temp *C = "); Serial.println(sht31_temp);
    Serial.print("Hum. % = "); Serial.println(sht31_hum);
    //display.print((char)247); // degree symbol 
    //display.println("C");
    //
    display.clearDisplay();
    display.setTextSize(2);
    display.setTextColor(SSD1306_WHITE);
    display.setCursor(25, 0);
    display.println(F("Weather"));
    display.println(temp_disp_buff);
    display.println(hum_disp_buff);
    //display.display();
  }  

  status = pressure.startTemperature();
  if (status != 0)
  {
    // чекаємо коли завершиться вимірювання:
    delay(status);
    // зчитуємо виміряну температуру:
    // виміряне значення зберігається в змінній bmp180Temperature.
    // функція повертає 1 при успішному виконанні і 0 якщо невдача.
    status = pressure.getTemperature(bmp180_temp);
    if (status != 0)
    {
      // вивід виміряної температури :
      Serial.print("Temperature: ");
      Serial.print(bmp180_temp, 2);
      Serial.print("\xC2\xB0");
      Serial.println("C"); 
      // старт вимірювання тиску:
      // The parameter is the oversampling setting, від 0 до 3 (найбільша роздільна здатність, найдовше очікування).
      // якшо запит успішний, число мс очікування буде повернено.
      // якщо запит невдалий, повертається 0.
      status = pressure.startPressure(3);
      if (status != 0)
      {
        // очікуємо на завершення вимірювання:
        delay(status);
        // Retrieve the completed pressure measurement:
        // Note that the measurement is stored in the variable P.
        // Note also that the function requires the previous temperature measurement (T).
        // (If temperature is stable, you can do one temperature measurement for a number of pressure measurements.)
        // Function returns 1 if successful, 0 if failure.
        status = pressure.getPressure(bmp180_press, bmp180_temp);
        if (status != 0)
        {
          // виводимо виміряне значення тиску:
          Serial.print("absolute pressure: ");
          Serial.print(bmp180_press, 2);
          Serial.print(" mb, ");
          Serial.print(bmp180_press*0.0295333727, 2);
          Serial.println(" inHg");
          double press_mmHg = bmp180_press*0.0295333727*25.399999705; // 25.4
          //lcd.print(press_mmHg);
          //lcd.print(" mmHg");
          String press_disp_buff = String(press_mmHg, 1);
          press_disp_buff += " mmHg";
          display.println(press_disp_buff);
          display.display();
          // Сенсор тиску повертає абсолютний тиск, який змінюється з висотою.
          // Щоь усунути ефект висоти, потрібно використати функцію sealevel та поточну висоту.
          // Це значення зазвичай використовується в погодніх прогнозах (метеорологічних повідомленнях).
          // Parameters: P = абсолютний тиск в mb, ALTITUDE = поточна висота в m.
          // Result: p0 = тиск скомпенсований над рівнем моря в mb
          p0 = pressure.sealevel(bmp180_press, ALTITUDE); // у Львові середня висота над рівнем моря 289 метра
          Serial.print("relative (sea-level) pressure: ");
          Serial.print(p0, 2);
          Serial.print(" mb, ");
          Serial.print(p0*0.0295333727,2);
          Serial.println(" inHg");
          press_mmHg = p0*0.0295333727*25.4;
          /*String press_disp_buff = String(press_mmHg, 1);
          press_disp_buff += " mmHg";
          display.println(press_disp_buff);
          display.display();*/
          // On the other hand, if you want to determine your altitude from the pressure reading,
          // use the altitude function along with a baseline pressure (sea-level or other).
          // Parameters: bmp180Pressure = absolute pressure in mb, p0 = baseline pressure in mb.
          // Result: a = altitude in m.
          a = pressure.altitude(bmp180_press, p0);
          Serial.print("computed altitude: ");
          Serial.print(a,0);
          Serial.print(" meters, ");
          Serial.print(a*3.28084,0);
          Serial.println(" feet");          
        }
        else Serial.println("error retrieving pressure measurement\n");
      }
      else Serial.println("error starting pressure measurement\n");
    }
    else Serial.println("error retrieving temperature measurement\n");
  }
  else Serial.println("error starting temperature measurement\n"); 
  Serial.println();
  delay(1000);
}
