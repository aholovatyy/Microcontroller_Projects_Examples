/* Data logger using HTU21D Humidity Sensor 
 By: Andriy Holovatyy
 Date: February 16th, 2020
 
 Uses the HTU21D library to display the current humidity and temperature 
 Open serial monitor at 9600 baud to see readings. Errors 998 if not sensor is detected. Error 999 if CRC is bad.
  
 HTU21D connections (Breakoutboard to Arduino):
 VCC = 3.3V
 GND = GND
 SDA = A4 (use inline 10k resistor if your board is 5V)
 SCL = A5 (use inline 10k resistor if your board is 5V)

 SD card attached to SPI bus as follows:
 MOSI - pin 11
 MISO - pin 12
 CLK - pin 13
 CS - pin 9 
 */

#include <Wire.h>
#include <TimeLib.h>
#include <DS1307RTC.h>
//#include "HTU21D.h"
#include "shtxx.h"
#include <LiquidCrystal.h>
#include <SPI.h>
#include <SD.h>

#define RS 10 // register select
#define EN 8 // enable
#define D4 5 // data pin 4
#define D5 4 // data pin 5
#define D6 3 // data pin 6
#define D7 2 // data pin 7
#define SD_CARD_CHIP_SELECT 9
#define TIME_INTERVAL 1 // 2 хв. 

LiquidCrystal lcd(RS, EN, D4, D5, D6, D7);

/*const int rs = 10, en = 8, d4 = 5, d5 = 4, d6 = 3, d7 = 2;
LiquidCrystal lcd(rs, en, d4, d5, d6, d7);
const int SDcardChipSelect = 9, timeInterval = 3;
*/

//HTU21D myHumidity;
value humi_val, temp_val;
float t=0, dew_point = 0;
unsigned char error, checksum, val = 1;

char directory[8], filepath[16];
char filename[] = "00000000.csv";
File dataFile;

tmElements_t tm;
uint8_t logDay, logMonth, logHour, logMinute;
uint16_t logYear; 
int16_t lastTimestamp;

void setSQW(uint8_t value) {
  Wire.beginTransmission(0x68);
  Wire.write(7);
  Wire.write(value);
  Wire.endTransmission();
}

void setup() {
  Serial.begin(9600);
  while (!Serial) ; // wait for serial
  delay(200);    
  // виставляємо кількість стовпців і рядків в LCD:
  lcd.begin(16, 2);
  /*lcd.print("Datalogger built");
  lcd.setCursor(0,1);
  lcd.print("on HTU21D sensor");*/
  lcd.setCursor(1,0);
  lcd.print("* Temp & Hum *");
  lcd.setCursor(2,1);
  lcd.print("Data logger");
  delay(500);
  lcd.clear();
  // ініціалізація давача вологості і температури SHT75   
  sht_init();  
  s_connectionreset();  
  //set SHTXX sensor resolution for temperature 12 bit and for humidity 8 bit 
  s_write_statusreg(&val);
  s_read_statusreg(&val, &checksum);
   
  //Serial.println(F("Даталогер з використанням RTC DS1307, сенсора HTU21D і microSD карти пам'яті"));
  Serial.println(F("Datalogger using RTC DS1307, HTU21D sensor and microSD memory card"));
  //myHumidity.begin();
  
  //Serial.print(F("Ініціалізація SD карти пам'яті..."));
  Serial.print("Initializing SD card...");

  if (!SD.begin(SD_CARD_CHIP_SELECT)) { //!SD.begin(SDCardChipSelect)
    //Serial.println(F("невдалося проініціалізувату карту пам'яті SD."));
    Serial.println("Card failed, or not present");
    while (1);
  }
  //Serial.println(F("карту проініціалізовано."));
  Serial.println("card initialized.");
  
  if (RTC.read(tm))
  {
    logMinute = tm.Minute;
    logHour = tm.Hour;
    logDay = tm.Day;
    logMonth = tm.Month;
    logYear = tmYearToCalendar(tm.Year);
    lastTimestamp = tm.Hour*60 + tm.Minute; 
    sprintf(directory, "%u", logMonth);    
    /*if (!SD.exists(directory))
     SD.mkdir(directory);*/
    /*filename[0] = 48 + tm.Day/10; або '0' + tm.Day/10;
    filename[1] = 48 + tm.Day%10;
    filename[2] = 48 + tm.Month/10;
    filename[3] = 48 + tm.Month%10;
    filename[4] = 48 + logYear/1000;
    filename[5] = 48 + (logYear/100)%10;
    filename[6] = 48 + (logYear/10)%10;
    filename[7] = 48 + logYear%10;*/    
    sprintf(filename, "%u%u%u%u%u%u%u%u.CSV", tm.Day/10,tm.Day%10, tm.Month/10,tm.Month%10, logYear/1000,(logYear/100)%10,(logYear/10)%10,logYear%10);
    sprintf(filepath, "%s/%s", directory, filename); 
    if (!SD.exists(filename))
    {
      dataFile = SD.open(filename, FILE_WRITE);
      dataFile.println("Timestamp; Temperature; Humidity");
      dataFile.close();
    }
  }  
  // 1Hz
  setSQW(0x10);
}

void loop() {
  //float humd = myHumidity.readHumidity();
  //float temp = myHumidity.readTemperature();
  
  String temp_disp_buffer = " ";
  String hum_disp_buffer = " ";
  
  /*temp_disp_buff += String(temp, 1);  temp_disp_buff += (char)223;  temp_disp_buff += 'C';    
  hum_disp_buff += String(humd, 1); hum_disp_buff += "%";  */

  //String temp_disp_buffer = String(temp, 1);
  //String hum_disp_buffer = String(humd, 1);
  /*char temp_disp_buff[6], hum_disp_buff[6];

  sprintf(temp_disp_buff, "%.1f", temp);
  sprintf(hum_disp_buff, "%.1f", humd);*/
  
  /*temp_disp_buff += String(temp, 1);  temp_disp_buff += (char)223;  temp_disp_buff += 'C';    
  hum_disp_buff += String(humd, 1); hum_disp_buff += "%"; */
    
  /*Serial.print("Temperature = ");
  Serial.print(temp, 1);
  Serial.print("\xC2\xB0");
  Serial.print("C, ");
  Serial.print("Humidity = ");
  Serial.print(humd, 1);
  Serial.print("%");
  Serial.println();*/

  error = 0;
  error += s_measure((unsigned char*) &humi_val.i,&checksum,HUMI);  //measure humidity
  error += s_measure((unsigned char*) &temp_val.i,&checksum,TEMP);  //measure temperature
  if (error != 0) 
    s_connectionreset(); //in case of an error: connection reset
  else
  { 
    humi_val.f = (float)humi_val.i;   //converts integer to float
    temp_val.f = (float)temp_val.i;   //converts integer to float
    calc_sth11(&humi_val.f,&temp_val.f);            //calculate humidity, temperature
    dew_point = calc_dewpoint(humi_val.f, temp_val.f); //calculate dew point 
    temp_disp_buffer = String(temp_val.f, 1);
    hum_disp_buffer = String(humi_val.f, 1);
    Serial.print("Temperature = ");
    Serial.print(temp_val.f, 1);
    Serial.print("\xB0");
    Serial.print("C, ");
    Serial.print("Humidity = ");
    Serial.print(humi_val.f, 1);
    Serial.print("%");
    Serial.println();
    
    /*lcd.setCursor(0,0);
    lcd.print(temp_val.f,1);
    lcd.print(char(223));  
    lcd.print("C ");    
    //lcd.setCursor(0,1);
    lcd.print(humi_val.f,1);    
    lcd.print("% RH "); 
    // Print the values to the serial port
    Serial.print("Temperature: ");
    Serial.print(temp_val.f);
    Serial.print(" degC \t");
    Serial.print("Humidity: ");
    Serial.print(humi_val.f);
    Serial.println("% RH");*/
    /*if ((humi_val.f != last_humi) || (temp_val.f != last_temp))
      {
          sdCardWrite(temp_val.f, humi_val.f);
          last_humi = humi_val.f;
          last_temp = temp_val.f;
      }*/
    }
  

  if (RTC.read(tm)) {
    /*Serial.print("Time = "); lcd.setCursor(0, 0);
    print2digits(tm.Hour);
    Serial.write(':'); lcd.print(':');
    print2digits(tm.Minute);
    Serial.write(':'); lcd.print(':');
    print2digits(tm.Second);
    lcd.print(temp_disp_buff);
    Serial.print(" Date (D/M/Y) = "); lcd.setCursor(0, 1);
    print2digits(tm.Day);
    Serial.write('/'); lcd.print('.');
    print2digits(tm.Month);
    Serial.write('/'); lcd.print('.');
    Serial.print(tmYearToCalendar(tm.Year));
    Serial.println();
    lcd.print(tmYearToCalendar(tm.Year));
    lcd.print(hum_disp_buff); */
    
    String time_disp_buffer = String(tm.Hour/10) + String(tm.Hour%10) + ':' + String(tm.Minute/10) + String(tm.Minute%10) + ':' + String(tm.Second/10) + String(tm.Second%10);
    String date_disp_buffer = String(tm.Day/10) + String(tm.Day%10) + '.' + String(tm.Month/10) + String(tm.Month%10) + '.' + String(tmYearToCalendar(tm.Year));
    
    Serial.print("Time = ");
    Serial.print(time_disp_buffer);
    Serial.print(", Date = ");
    Serial.println(date_disp_buffer);
    
    lcd.setCursor(0, 0);
    lcd.print(time_disp_buffer);
    lcd.print(' ');  
    lcd.print(temp_disp_buffer);
    lcd.print(char(223));
    lcd.print('C');

    lcd.setCursor(0, 1);
    lcd.print(date_disp_buffer);
    lcd.print(' ');  
    lcd.print(hum_disp_buffer);
    lcd.print('%');
   
    if (logDay != tm.Day)
    {
      filename[0] = '0' + tm.Day/10;
      filename[1] = '0' + tm.Day%10;
      logDay = tm.Day;
      lastTimestamp = lastTimestamp - 1440;
    }

    if (logMonth != tm.Month)
    {
      filename[2] = '0' + tm.Month/10;
      filename[3] = '0' + tm.Month%10;
      logMonth = tm.Month;
    }

    int16_t timestamp = tm.Hour*60 + tm.Minute;
    
    if ( (timestamp - lastTimestamp) >= TIME_INTERVAL) //timeInterval
    {
       lastTimestamp = timestamp;
       //Serial.print(String(F("Запис даних у файл ")) + filename + F(" на карті пам'яті..."));
       Serial.println(String(F("Data storing into ")) + filename + F(" on the SD card..."));
       if (!SD.exists(filename))
       {
         dataFile = SD.open(filename, FILE_WRITE);
         if (dataFile) { 
           dataFile.println("Timestamp; Temperature; Humidity");
           dataFile.close();
         }
       }
       dataFile = SD.open(filename, FILE_WRITE);
       if (dataFile) {
         temp_disp_buffer.replace('.',',');  hum_disp_buffer.replace('.',',');
         String dataBuffer = time_disp_buffer.substring(0, 5) + "; " + temp_disp_buffer + "; " + hum_disp_buffer;
         dataFile.println(dataBuffer);
         dataFile.close();
         Serial.println(dataBuffer);
       }
       else {
         //Serial.println(String("помилка відкриття ") + filename + '.');
         Serial.println(String("error opening ") + filename + '.');
       }
       //Serial.println(F("запис завершено."));
       Serial.println(F("writing completed."));
     }
           
    /*if ( (tm.Minute - logMinute) >= TIME_INTERVAL) //timeInterval
    {
      logMinute = tm.Minute;
      //Serial.print(String(F("Запис даних у файл ")) + filename + F(" на карті пам'яті..."));
      Serial.println(String(F("Data storing into ")) + filename + F(" on the SD card..."));
      if (!SD.exists(filename))
      {
        dataFile = SD.open(filename, FILE_WRITE);
        if (dataFile) { 
          dataFile.println("Timestamp; Temperature; Humidity");
          dataFile.close();
        }
      }
      dataFile = SD.open(filename, FILE_WRITE);
      if (dataFile) {
        /*
        char dataBuf[18];
        sprintf(dataBuf, "%u%u:%u%u,%.1f,%.1f", tm.Hour/10, tm.Hour%10, tm.Minute/10, tm.Minute%10, temp, humd);
        */
        /*String dataBuffer = String(tm.Hour/10) + String(tm.Hour%10) + ':' + String(tm.Minute/10) + String(tm.Minute%10) + ',' 
        + String(temp, 1) + ',' String(humd, 1);*/
        /*temp_disp_buffer.replace('.',',');  hum_disp_buffer.replace('.',',');
        String dataBuff = time_disp_buff.substring(0, 5) + "; " + temp_disp_buff + "; " + hum_disp_buff;
        dataFile.println(dataBuffer);
        dataFile.close();
        Serial.println(dataBuffer);
      }
      else {
        //Serial.println(String("помилка відкриття ") + filename + '.');
        Serial.println(String("error opening ") + filename + '.');
      }*/
      //Serial.println(F("запис завершено."));
    //  Serial.println(F("writing completed."));
    //}
  } else {
    if (RTC.chipPresent()) {
      /*Serial.println(F("Чіп DS1307 зупинено.  Будь-ласка запустіть SetTime"));
      Serial.println(F("приклад ініціалізації часу і початок запуску."));
      Serial.println();*/
      Serial.println("The DS1307 is stopped.  Please run the SetTime");
      //Serial.println("example to initialize the time and begin running.");
      //Serial.println();
    } else {
      //Serial.println(F("Помилка читання з чіпа DS1307!  Будь-ласка перевірте підключення."));
      Serial.println("DS1307 read error!  Please check the circuitry.");
      //Serial.println();
    }
    delay(9000);
  }  
  delay(1000);
}

/*void print2digits(int number) {
  if (number >= 0 && number < 10) {
    Serial.write('0');
    lcd.print('0');
  }
  Serial.print(number);
  lcd.print(number);
}*/
