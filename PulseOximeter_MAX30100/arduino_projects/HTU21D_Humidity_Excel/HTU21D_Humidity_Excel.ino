/* 
 HTU21D Humidity Sensor Example Code
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
#include "HTU21D.h"

//Create an instance of the object
HTU21D myHumidity;

unsigned long time_seconds = 0;

void setup()
{
  Serial.begin(9600);
  //Serial.println("HTU21D Example!");
  myHumidity.begin();
  Serial.println("CLEARDATA");
  Serial.println("LABEL,Date,Time,Seconds,Temperature,Humidity");

  // Get true random value from Excel to feed into RandomNumberGenerator from Arduino (randomSeed())
   // Serial.println("GETRANDOM,0,32323");
   // int rndseed = Serial.readStringUntil(10).toInt();
  //  Serial.println( (String) "Got random value '" + rndseed + "' from Excel" );
  //  randomSeed(rndseed);
}

void loop()
{
  float humd = myHumidity.readHumidity();
  float temp = myHumidity.readTemperature();

  /*Serial.print("Time:");
  Serial.print(millis());
  Serial.print(" Temperature:");
  Serial.print(temp, 1);
  Serial.print("C");
  Serial.print(" Humidity:");
  Serial.print(humd, 1);
  Serial.print("%");

  Serial.println();*/
  time_seconds = millis()/500;
  Serial.println( (String) "DATA,DATE,TIME," + time_seconds + "," + temp + "," + humd);
  //Serial.print(temp, 1);
  //Serial.print(",");
  //Serial.println(humd, 1);
  delay(500);
}
