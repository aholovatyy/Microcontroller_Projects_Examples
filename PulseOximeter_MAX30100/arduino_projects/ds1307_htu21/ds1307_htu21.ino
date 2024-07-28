/* HTU21D Humidity Sensor Example Code
 By: Nathan Seidle
 SparkFun Electronics
 Date: September 15th, 2013
 License: This code is public domain but you buy me a beer if you use this and we meet someday (Beerware license).
 
 Uses the HTU21D library to display the current humidity and temperature
 
 Open serial monitor at 9600 baud to see readings. Errors 998 if not sensor is detected. Error 999 if CRC is bad.
  
 Hardware Connections (Breakoutboard to Arduino):
 -VCC = 3.3V
 -GND = GND
 -SDA = A4 (use inline 10k resistor if your board is 5V)
 -SCL = A5 (use inline 10k resistor if your board is 5V)
 */

#include <Wire.h>
#include <TimeLib.h>
#include <DS1307RTC.h>
#include "HTU21D.h"
#include <LiquidCrystal.h>

const int rs = 12, en = 11, d4 = 5, d5 = 4, d6 = 3, d7 = 2;
LiquidCrystal lcd(rs, en, d4, d5, d6, d7);

//Create an instance of the object
HTU21D myHumidity;

void setup() {
  Serial.begin(9600);
  while (!Serial) ; // wait for serial
  delay(200);  
  // set up the LCD's number of columns and rows:
  lcd.begin(16, 2);
  Serial.println("DS1307RTC & HTU21D Read Test!");
  myHumidity.begin();
  Serial.println("-------------------");
}

void loop() {
  tmElements_t tm;
  float humd = myHumidity.readHumidity();
  float temp = myHumidity.readTemperature();
  
  String temp_disp_buff = " ";
  String hum_disp_buff = " ";
  
  temp_disp_buff += String(temp, 1);  temp_disp_buff += (char)223;  temp_disp_buff += 'C';    
  hum_disp_buff += String(humd, 1); hum_disp_buff += "%";  
    
  Serial.print("Temperature: ");
  Serial.print(temp, 1);
  Serial.print("\xC2\xB0");
  Serial.print("C, ");
  Serial.print("Humidity: ");
  Serial.print(humd, 1);
  Serial.print("%");
  Serial.println();

  if (RTC.read(tm)) {
    Serial.print("Ok, Time = "); lcd.setCursor(0, 0);
    print2digits(tm.Hour);
    Serial.write(':'); lcd.print(':');
    print2digits(tm.Minute);
    Serial.write(':'); lcd.print(':');
    print2digits(tm.Second);
    lcd.print(temp_disp_buff);
    Serial.print(", Date (D/M/Y) = "); lcd.setCursor(0, 1);
    //Serial.print(tm.Day); 
    print2digits(tm.Day);
    Serial.write('/'); lcd.print('.');
    //Serial.print(tm.Month);
    print2digits(tm.Month);
    Serial.write('/'); lcd.print('.');
    Serial.print(tmYearToCalendar(tm.Year));
    Serial.println();
    lcd.print(tmYearToCalendar(tm.Year));
    lcd.print(hum_disp_buff);    
  } else {
    if (RTC.chipPresent()) {
      Serial.println("The DS1307 is stopped.  Please run the SetTime");
      Serial.println("example to initialize the time and begin running.");
      Serial.println();
    } else {
      Serial.println("DS1307 read error!  Please check the circuitry.");
      Serial.println();
    }
    delay(9000);
  }
  
  delay(1000);
}

void print2digits(int number) {
  if (number >= 0 && number < 10) {
    Serial.write('0');
    lcd.print('0');
  }
  Serial.print(number);
  lcd.print(number);
}
