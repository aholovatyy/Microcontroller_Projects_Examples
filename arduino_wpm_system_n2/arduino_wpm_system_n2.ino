/* SFE_BMP180 library example sketch

This sketch shows how to use the SFE_BMP180 library to read the
Bosch BMP180 barometric pressure sensor.
https://www.sparkfun.com/products/11824

Like most pressure sensors, the BMP180 measures absolute pressure.
This is the actual ambient pressure seen by the device, which will
vary with both altitude and weather.

Before taking a pressure reading you must take a temparture reading.
This is done with startTemperature() and getTemperature().
The result is in degrees C.

Once you have a temperature reading, you can take a pressure reading.
This is done with startPressure() and getPressure().
The result is in millibar (mb) aka hectopascals (hPa).

If you'll be monitoring weather patterns, you will probably want to
remove the effects of altitude. This will produce readings that can
be compared to the published pressure readings from other locations.
To do this, use the sealevel() function. You will need to provide
the known altitude at which the pressure was measured.

If you want to measure altitude, you will need to know the pressure
at a baseline altitude. This can be average sealevel pressure, or
a previous pressure reading at your altitude, in which case
subsequent altitude readings will be + or - the initial baseline.
This is done with the altitude() function.

Hardware connections:

- (GND) to GND
+ (VDD) to 3.3V

(WARNING: do not connect + to 5V or the sensor will be damaged!)

You will also need to connect the I2C pins (SCL and SDA) to your
Arduino. The pins are different on different Arduinos:

Any Arduino pins labeled:  SDA  SCL
Uno, Redboard, Pro:        A4   A5
Mega2560, Due:             20   21
Leonardo:                   2    3

Leave the IO (VDDIO) pin unconnected. This pin is for connecting
the BMP180 to systems with lower logic levels such as 1.8V

Have fun! -Your friends at SparkFun.

The SFE_BMP180 library uses floating-point equations developed by the
Weather Station Data Logger project: http://wmrx00.sourceforge.net/

Our example code uses the "beerware" license. You can do anything
you like with this code. No really, anything. If you find it useful,
buy me a beer someday.

V10 Mike Grusin, SparkFun Electronics 10/24/2013
V1.1.2 Updates for Arduino 1.6.4 5/2015
*/

/*
  Мікроконтролерний пристрій для вимірювання основних параметрів погоди
  (Microcontroller device for measuring the main weather parameters)   
*/

// бібліотека LCD - рідкокристалічного дисплею
#include <LiquidCrystal.h>
//#include <LiquidCrystalRus.h>
#include <SFE_BMP180.h> // бібліотека давача тиску BMP180
#include <Wire.h> // біблотека для комунікації з пристроями підключиними по шині I2C/TWI
#include "dht.h"

const char iot_device_banner[] = "IoT based weather device using Arduino and ESP8266 Wi-Fi module";
const char author_info[]        = "(C) 2020, developed by Andriy Holovatyy";

#define ALTITUDE 289.0 // Середня висота Львова над рівнем моря в метрах

// You will need to create an SFE_BMP180 object, here called "pressure":
SFE_BMP180 pressure;
double bmp180Temperature, bmp180Pressure;

#define DHT11_PIN 7
dht DHT;
float dht11Temperature, dht11Humidity;

struct
{
    uint32_t total;
    uint32_t ok;
    uint32_t crc_error;
    uint32_t time_out;
    uint32_t connect;
    uint32_t ack_l;
    uint32_t ack_h;
    uint32_t unknown;
} stat = { 0,0,0,0,0,0,0,0};

float lm35Temp;
int pInd =0, tInd = 0;

// ініціалізація бібліотеки номерами інтерфейсних пінів
LiquidCrystal lcd(12, 11, 6, 5, 4, 3);
//LiquidCrystalRus lcd(12, 11, 6, 5, 4, 3);

// constants won't change. They're used here to set pin numbers:
/*const int menuButtonPin = 13;     // the number of the pushbutton pin
const int selectPlusButtonPin = 10;
const int selectMinusButtonPin = 9;
const int exitButtonPin = 8;*/

#define MENU_BUTTON_PIN 2
#define SELECT_PLUS_BUTTON_PIN 10
#define SELECT_MINUS_BUTTON_PIN 9
#define EXIT_BUTTON_PIN 8

#define INTERRUPT_PIN 2

volatile bool mainMenuInvoke = false;

//int buttonState;             // the current reading from the input pin
//int lastButtonState = LOW;   // the previous reading from the input pin

// the following variables are unsigned longs because the time, measured in
// milliseconds, will quickly become a bigger number than can be stored in an int.
//unsigned long lastDebounceTime = 0;  // останній час, коли вихідний пін був переключений
unsigned long debounceDelay = 50;    // час деренчання; збільшити якщо вихід деренчить (шумить)

#define NUMBUTTONS 4
unsigned long lastDebounceTime[NUMBUTTONS] = {0, 0, 0, 0};

int lastButtonState[NUMBUTTONS] = {LOW, LOW, LOW, LOW};
int buttonState[NUMBUTTONS];
int buttonsArray[NUMBUTTONS] = {MENU_BUTTON_PIN, SELECT_PLUS_BUTTON_PIN, SELECT_MINUS_BUTTON_PIN, EXIT_BUTTON_PIN}; 

// button array pos
int buttonToPos(uint8_t BUTTON) 
{
   for (int i=0; i<NUMBUTTONS; i++) {
     if (buttonsArray[i] == BUTTON) {
       return i;
     }
   }
   return -1;
}

bool isButtonPressed(int buttonPin)
{
  // читаємо пін кнопки, якщо кнопка натиснута буде високим, якщо ні буде низьким
  int value = digitalRead(buttonPin);
  int pos = buttonToPos(buttonPin);
  
  /*  випалку якщо зчитане значення не рівне останьому стану кнопки, то встановити останній час деренчання (брязкотіння) у поточний час в мілісекундках, 
  що пройшоа з початку викоання програми millis() */
  if (value != lastButtonState[pos])  {
    lastDebounceTime[pos] = millis();
  }
  // перевірити різницю між поточним часом і останнім зареєстрованим часом натиснення кнопки, якшо він більший встановленого часу затримки, то означає що натиснута кнопка 
  if ((millis()-lastDebounceTime[pos]) > debounceDelay) {
    if (value != buttonState[pos]) {
      buttonState[pos] = value;
    if (buttonState[pos] == HIGH) {
         return true;
      }
    }
  }
  //зберегти зчитане значення стан кнопки. наступного ращу в циклі зчитаний стан кнопки буде вже як lastButtonState
  lastButtonState[pos] = value; 
  return false;
}

void setPressureUnit()
{
  const char *pressureUnits[] = {" mb ", "mmHg", "inHg", "hPa "};
  const char pressureUnitsMenuTitle[] = " Pressure Unit ";
  int ind = 0; 
  
  lcd.clear();
  lcd.setCursor(0,0);
  lcd.print(pressureUnitsMenuTitle);
  lcd.setCursor(0,1);
  lcd.print("<");
  lcd.setCursor(15,1);
  lcd.print(">");
   
  while(1)
  {
    lcd.setCursor(6,1);
    lcd.print(pressureUnits[ind]);
    
    if (isButtonPressed(SELECT_PLUS_BUTTON_PIN))
      if (ind == 3) ind = 0;
      else ind++;     
    
    if (isButtonPressed(SELECT_MINUS_BUTTON_PIN))
      if (ind == 0) ind = 3;
      else ind--;
    
    if(isButtonPressed(MENU_BUTTON_PIN))
    {
      pInd = ind;
      return;     
    }
    if (isButtonPressed(EXIT_BUTTON_PIN))
      return;
  }
}

void setTemperatureUnit()
{
  const char *temperatureUnits[] = {"C", "F", "K"};
  const char temperatureUnitsMenuTitle[] = "Temperature Unit";
  int ind = 0; 
  
  lcd.clear();
  lcd.setCursor(0,0);
  lcd.print(temperatureUnitsMenuTitle);
  lcd.setCursor(0,1);
  lcd.print("<");
  lcd.setCursor(15,1);
  lcd.print(">");
   
  while(1)
  {
    lcd.setCursor(6,1);
    lcd.print(char(223));  
    lcd.print(temperatureUnits[ind]);
    
    if (isButtonPressed(SELECT_PLUS_BUTTON_PIN))
      if (ind == 2) ind = 0;
      else ind++;     
    
    if (isButtonPressed(SELECT_MINUS_BUTTON_PIN))
      if (ind == 0) ind = 2;
      else ind--;
    
    if(isButtonPressed(MENU_BUTTON_PIN))
    {
      tInd = ind;
      return;     
    }
    if (isButtonPressed(EXIT_BUTTON_PIN))
      return;
  }
}

void mainMenu()
{
  //char *mainMenuItems[] = {"  Temp Format  ", "Pressure Format ", "   Bluetooth    ", "      Exit      "};
  char *mainMenuItems[] = {"  Temp Format  ", "Pressure Format ", "      Exit      "};
  char menuTitle[] = "** MAIN MENU **";
  int i = 0; 
  bool lcdPrint = false; 
  
  lcd.clear();
  lcd.setCursor(0,0);
  lcd.print(menuTitle);
  lcd.setCursor(0,1);
  lcd.print(mainMenuItems[i]);  
  
  while(1)
  {
   // if (lcdPrint)
   // {
      lcd.setCursor(0,1);
      lcd.print(mainMenuItems[i]);
      //lcdPrint = !lcdPrint;
  //  }
    if (isButtonPressed(SELECT_PLUS_BUTTON_PIN))
    {      
      if(i == 2) i = 0;
      else i++;
      lcdPrint = !lcdPrint; 
    }
    if (isButtonPressed(SELECT_MINUS_BUTTON_PIN))
    {
      if (i == 0) i = 2;
      else i--;
      lcdPrint = !lcdPrint; 
    }
    if(isButtonPressed(MENU_BUTTON_PIN))
    {
      switch(i)
      {
        case 0: setTemperatureUnit(); break; 
        case 1: setPressureUnit(); break;
        case 2: return;       
        default: break;
      }
      lcd.clear();
      lcd.setCursor(0,0);
      lcd.print(menuTitle);
      lcd.setCursor(0,1);
      lcd.print(mainMenuItems[i]);      
    }
    if (isButtonPressed(EXIT_BUTTON_PIN))
    {
      lcd.clear();
      mainMenuInvoke = 0;
      attachInterrupt(digitalPinToInterrupt(INTERRUPT_PIN), pin_ISR, CHANGE);
      return;
    }
  }
}

void scrollTextOutput()
{
  lcd.print(io_device_banner);
  lcd.setCursor(0,1);
  lcd.print(author_info);
  //delay(300);
  for(int posCount = 0; posCount < 47; posCount++)
  {
    lcd.scrollDisplayLeft(); //builtin command to scroll left the text
    delay(150); // затримка на 150 мс
  }
}

void setup()
{
  // ініціалізація пінів кнопок як входи:
  pinMode(MENU_BUTTON_PIN, INPUT);
  pinMode(SELECT_PLUS_BUTTON_PIN, INPUT);
  pinMode(SELECT_MINUS_BUTTON_PIN, INPUT);
  pinMode(EXIT_BUTTON_PIN, INPUT);
  // встановлення кількості стовпців і рядків LCD:
  lcd.begin(16, 2);
  lcd.clear();
  scrollTextOutput();
  // ініціалізація послідовного інтерфейсу
  Serial.begin(9600);  
  Serial.println("*** Weather parameters measurement system ***");
  lcd.print("  *** WPMS *** ");
  lcd.setCursor(1,1);
  lcd.print("2019, Yura Kit");
  //lcd.print("2019, Юра Кiт");
  delay(1000);
  // ініціалізація давача тиску BMP180 (важливо отримати калібровочні значення збережені в пристрої).
  if (pressure.begin())
  {
    Serial.println("BMP180 init success");
    lcd.clear();
    lcd.setCursor(0,0);
    lcd.print("BMP180");
    lcd.setCursor(0,1);
    lcd.print("init success");
    delay(500);
    lcd.clear();
  }
  else
  {
    // щось пішло не так, зазвичай проблеми з підключенням,
    Serial.println("BMP180 init fail\n\n");
    lcd.clear();
    lcd.setCursor(0,0);
    lcd.print("BMP180");
    lcd.setCursor(0,1);
    lcd.print("init fail");
    while(1); // Pause forever.
  }
  pinMode(A0, INPUT); // сенсор LM35 підключаємо до аналогового входу A0  
  // Attach an interrupt to the ISR vector
  attachInterrupt(digitalPinToInterrupt(INTERRUPT_PIN), pin_ISR, CHANGE);
}

void dht11Read()
{
    // читаємо дані темератури і вологості з сенсора dht
    Serial.println();
    Serial.println("*** Humidity and temperature sensor DHT11 ***");
    Serial.print("DHT11, \t");
    uint32_t start = micros();
    int chk = DHT.read12(DHT11_PIN);
    uint32_t stop = micros();
    
    stat.total++;
    switch (chk)
    {
    case DHTLIB_OK:
        stat.ok++;
        Serial.println("OK");   
        break;
    case DHTLIB_ERROR_CHECKSUM:
        stat.crc_error++;
        Serial.println("Checksum error");
        lcd.clear();
        lcd.setCursor(0,0);
        lcd.print("DHT11");
        lcd.setCursor(0,1);
        lcd.print("Checksum error");
        break;
    case DHTLIB_ERROR_TIMEOUT:
        stat.time_out++;
        Serial.println("Time out error");
        lcd.clear();
        lcd.setCursor(0,0);
        lcd.print("DHT11");
        lcd.setCursor(0,1);
        lcd.print("Time out error");
        break;
    default:
        stat.unknown++;        
        Serial.println("Unknown error");
        lcd.clear();
        lcd.setCursor(0,0);
        lcd.print("DHT11");
        lcd.setCursor(0,1);
        lcd.print("Unknown error");
        break;
    }
    // виводимо дані
    Serial.print("humidity: ");
    Serial.print(DHT.humidity,1);
    Serial.println("%");
    Serial.print("temperature: ");
    Serial.print(DHT.temperature,1);
    Serial.println(" degC");
    //Serial.print(stop - start);
    //Serial.println();
    dht11Temperature = DHT.temperature; dht11Humidity = DHT.humidity;
    //lcd.print(DHT.humidity, 1);
    //lcd.print(F("% "));
    //lcd.setCursor(0,1);
    //lcd.print(DHT.temperature, 1);
    //lcd.print(char(223));
    //lcd.print(F("C "));

    if (stat.total % 20 == 0)
    {
        Serial.println("\nTOT\tOK\tCRC\tTO\tUNK");
        Serial.print(stat.total);
        Serial.print("\t");
        Serial.print(stat.ok);
        Serial.print("\t");
        Serial.print(stat.crc_error);
        Serial.print("\t");
        Serial.print(stat.time_out);
        Serial.print("\t");
        Serial.print(stat.connect);
        Serial.print("\t");
        Serial.print(stat.ack_l);
        Serial.print("\t");
        Serial.print(stat.ack_h);
        Serial.print("\t");
        Serial.print(stat.unknown);
        Serial.println("\n");
    }
   delay(20);  
}

void bmp180Read()
{  
  char status;
  double p0, a;
  int press_mmHg;

  // Loop here getting pressure readings every 10 seconds.
  // If you want sea-level-compensated pressure, as used in weather reports,
  // you will need to know the altitude at which your measurements are taken.
  // We're using a constant called ALTITUDE in this sketch:  
  Serial.println();
  Serial.println("*** Pressure and temperature sensor BMP180 ***");
  Serial.print("provided altitude: ");
  Serial.print(ALTITUDE,0);
  Serial.print(" meters, ");
  Serial.print(ALTITUDE*3.28084,0);
  Serial.println(" feet");  
  // If you want to measure altitude, and not pressure, you will instead need
  // to provide a known baseline pressure. This is shown at the end of the sketch.
  // You must first get a temperature measurement to perform a pressure reading.  
  // Start a temperature measurement:
  // If request is successful, the number of ms to wait is returned.
  // If request is unsuccessful, 0 is returned.
  status = pressure.startTemperature();
  if (status != 0)
  {
    // чекаємо коли завершиться вимірювання:
    delay(status);
    // зчитуємо виміряну температуру:
    // виміряне значення зберігається в змінній bmp180Temperature.
    // функція повертає 1 при успішному виконанні і 0 якщо невдача.

    status = pressure.getTemperature(bmp180Temperature);
    if (status != 0)
    {
      // вивід виміряної температури :
      Serial.print("temperature: ");
      Serial.print(bmp180Temperature, 2);
      Serial.print(" degC, ");
      Serial.print((9.0/5.0)*bmp180Temperature+32.0,2);
      Serial.println(" degF");
      //lcd.setCursor(0,0);
      //lcd.print(T, 1);
      //lcd.print(char(223));  
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
        status = pressure.getPressure(bmp180Pressure, bmp180Temperature);
        if (status != 0)
        {
          // виводимо виміряне значення тиску:
          Serial.print("absolute pressure: ");
          Serial.print(bmp180Pressure,2);
          Serial.print(" mb, ");
          Serial.print(bmp180Pressure*0.0295333727,2);
          Serial.println(" inHg");
          press_mmHg = bmp180Pressure*0.0295333727*25.399999705; // 25.4
          //lcd.print(press_mmHg);
          //lcd.print(" mmHg");

          // Сенсор тиску повертає абсолютний тиск, який змінюється з висотою.
          // Щоь усунути ефект висоти, потрібно використати функцію sealevel та поточну висоту.
          // Це значення зазвичай використовується в погодніх прогнозах (метеорологічних повідомленнях).
          // Parameters: P = абсолютний тиск в mb, ALTITUDE = поточна висота в m.
          // Result: p0 = тиск скомпенсований над рівнем моря в mb
          p0 = pressure.sealevel(bmp180Pressure,ALTITUDE); // у Львові середня висота над рівнем моря 289 метра
          Serial.print("relative (sea-level) pressure: ");
          Serial.print(p0,2);
          Serial.print(" mb, ");
          Serial.print(p0*0.0295333727,2);
          Serial.println(" inHg");
          /*press_mmHg = p0*0.0295333727*25.4;
          lcd.print(press_mmHg);
          lcd.print(" mmHg");*/

          // On the other hand, if you want to determine your altitude from the pressure reading,
          // use the altitude function along with a baseline pressure (sea-level or other).
          // Parameters: bmp180Pressure = absolute pressure in mb, p0 = baseline pressure in mb.
          // Result: a = altitude in m.
          a = pressure.altitude(bmp180Pressure,p0);
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
}

void lm35Read()
{
  int val;
  val = analogRead(A0); // змінна знаходиться в інтервалі 0 - 1023
  lm35Temp = (val/1023.0)*5.0*1000/10; // формула обчислення температури в градусах Цельсія
  Serial.println();
  Serial.println("*** Temperature sensor LM35 ***");
  Serial.print("temperature: ");
  Serial.print(lm35Temp); // виводимо значення температури на термінал
  Serial.println(" degC");
  /*lcd.setCursor(0,1);
  lcd.print(lm35Temp,1);
  lcd.print(char(223));  */ 
}

void loop()
{
  // BMP180
  bmp180Read();
  // LM35
  lm35Read();
  // DHT22
  dht11Read(); 
  lcd.setCursor(0,0);
  lcd.print(bmp180Temperature,1);
  lcd.print(char(223));  
  lcd.print("C ");
  switch (pInd)
  {
    case 0: 
       lcd.print(bmp180Pressure,1);
       lcd.print(" mb"); 
       break; 
    case 1: 
       lcd.print(bmp180Pressure*0.0295333727*25.399999705,0);
       lcd.print(" mmHg");
       break;
    case 2:
       lcd.print(bmp180Pressure*0.0295333727,1);
       lcd.print(" inHg");
       break;     
     case 3:
       lcd.print(bmp180Pressure,0);
       lcd.print(" hPa");
       break;         
  }
  //lm35Read();
  lcd.setCursor(0,1);
  switch (tInd)
  {
    case 0: 
       lcd.print(lm35Temp,1);
       lcd.print(char(223));  
       lcd.print("C "); 
       break; 
    case 1: 
       lcd.print((9.0/5.0)*lm35Temp+32.0,1);
       lcd.print(char(223));  
       lcd.print("F ");
       break;
    case 2:
       lcd.print(lm35Temp+274.15,1);
       lcd.print(char(223));  
       lcd.print("K ");
       break;       
  }
  /*lcd.setCursor(0,1);
  lcd.print(lm35Temp,1);
  lcd.print(char(223));  */
  // DHT22
  //dht22Read(); 
  lcd.print(dht11Humidity, 1);
  lcd.print(F("% RH "));
  // read the state of the pushbutton value: 
 if (mainMenuInvoke)
  mainMenu();
  //lcd.clear();
  delay(1000);  // Pause for 5 seconds.
}

void pin_ISR() {
  /*buttonState = digitalRead(buttonPin);
  digitalWrite(ledPin, buttonState);.*/
  // check if the pushbutton is pressed. If it is, the buttonState is HIGH:
  if (digitalRead(MENU_BUTTON_PIN) == HIGH) //isButtonPressed(MENU_BUTTON_PIN)) 
  {
     detachInterrupt(digitalPinToInterrupt(INTERRUPT_PIN));
     mainMenuInvoke = true;
  }
}
