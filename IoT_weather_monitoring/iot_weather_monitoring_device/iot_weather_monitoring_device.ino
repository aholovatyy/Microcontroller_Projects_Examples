/*
  IoT - пристрій моніторингу метеопараметрів з використанням платформи Arduino та Wi-Fi модуля ESP8266
  (IoT based weather monitoring device using Arduino and ESP8266 Wi-Fi module)
  Розробила: студентка групи КН-41з, Лілія Войчишин    
*/

#include <Wire.h> // бібліотека для роботи з різними пристроями по інтерфейсу I2C/TWI
#include <Adafruit_Sensor.h> // бібліотека-драйвер для роботм з різними сенсорами
#include <Adafruit_BME280.h> // бібліотека для роботи з сенсором температури, вологості і тиску BME280
#include <LiquidCrystalRus.h> //<LiquidCrystal.h>
#include <ArduinoJson.h> // бібліотека для роботи з форматом JSON
#include <WiFiEsp.h> // бібліотека для роботи з Wi-Fi модулем ESP8266
#include <WiFiEspClient.h>
#include <WiFiEspUdp.h> 
#include <PubSubClient.h> // MQTT-клієнт "Publisher-Subscriber"

// ініціалізуємо кнопки
#define NUM_OF_BTNS 4
#define MENU_BTN_PIN 19
#define SELECT_PLUS_BTN_PIN 23
#define SELECT_MINUS_BTN_PIN 22
#define EXIT_BTN_PIN 24

unsigned long lastDebounceTime[NUM_OF_BTNS] = {0, 0, 0, 0}; // останній час, коли вихідний пін був переключений

int lastBtnState[NUM_OF_BTNS] = {LOW, LOW, LOW, LOW};
int btnState[NUM_OF_BTNS];
int btnsArray[NUM_OF_BTNS] = {MENU_BTN_PIN, SELECT_PLUS_BTN_PIN, SELECT_MINUS_BTN_PIN, EXIT_BTN_PIN}; 

const char *WiFi_ssid[] = {"GoldNew", "ASUS_Network", "TP_LINK_49F6F2"}; // назва Wi-Fi точки доступу
const char *WiFi_passwd[] = {"qwerty12345678", "12345678Lv", "Test12345678"}; // пароль до Wi-Fi точки доступу

int status = WL_IDLE_STATUS;
unsigned long lastSend;

const char *mqtt_server[] = {"192.168.0.100" /* Mosquitto broker */, "demo.thingsboard.io" /* сервіс Thingsboard */};
const int mqtt_port = 1883;
const char *token[] = {"", "BME280_SENSOR_TOKEN"}; // BME280_SENSOR_TOKEN

const char *topic[] = {"weather/data", "v1/devices/me/telemetry"};
float temp, humidity, pressure, altetude; 
char jsonBuffer[512];
size_t jsonMessageSize;

// створюємо та ініціалізуємо об'єкти WiFiEspClient, PubSubClient 
WiFiEspClient espClient;
PubSubClient client(espClient);

// створюємо значки температури, вологості і тиску для LCD
byte tempChar[] = { // lcd значок/іконка температури
  0x04,
  0x0A,
  0x0A,
  0x0A,
  0x0E,
  0x1F,
  0x1F,
  0x0E
};
byte humidityChar[] = { // lcd значок вологості
  0x04,
  0x04,
  0x0A,
  0x0A,
  0x11,
  0x11,
  0x11,
  0x0E
};
byte pressureChar[] = { // lcd значок тиску 
  0x0E,
  0x0A,
  0x0A,
  0x0A,
  0x0E,
  0x1F,
  0x1F,
  0x0E
};
//ініціалізуємо бібліотеку номерами пінів плати Arduino до яких підключені відповідні інтерфейсні піни LCD 
const int rs = 2, en = 3, d4 = 4, d5 = 5, d6 = 6, d7 = 7;
LiquidCrystalRus lcd(rs, en, d4, d5, d6, d7);

const byte interruptPin = 19; // interrupt0 - pin 2, interrupt1 - pin 3, interrupt2 - pin 21, interrupt3 - pin 20, interrupt4 - pin 19, interrupt5 - pin 18
volatile bool mainMenuInvoke = false;
unsigned long debounceDelay = 50, delayTime;    // час деренчання; збільшити якщо вихід деренчить (шумить), час затримки
int wifi_ind = 0, mqtt_server_ind = 0;

#define SEA_LEVEL_PRESSURE_HPA (1028.00) // тиск над рівнем моря для Львова 1028 гПа

Adafruit_BME280 bme; // підключення по I2C

/*const char iot_device_banner[] = "IoT based weather monitoring device";
const char author_info[] = "(C) 2020, developed by Lilia Voychyshyn";*/
const char iot_device_banner[] = "IoT система монiторингу метеопараметрiв";
const char author_info[] = "Розробила ст. КН-41з, Лiлiя Войчишин";

void wifiInit()
{
  // ініціалізація послідовного інтерфейсу для модуля ESP8266
  Serial2.begin(9600);
  // set up the LCD's number of columns and rows:
  lcd.begin(16, 2);
  lcd.clear();
  //lcd.print("Initializing");
  lcd.print("Iнiцiалiзацiя");
  lcd.setCursor(0,1);
  //lcd.print("ESP module..");
  lcd.print("ESP модуля...");
  // ініціалізація модуля ESP8266
  WiFi.init(&Serial2);
  lcd.print("OK!");
  delay(100);
  lcd.clear();
  lcd.home();
  // перевірка чи підключений Wi-Fi шилд
  if (WiFi.status() == WL_NO_SHIELD) {
    //Serial.println(F("WiFi шилд відсутній")); 
    Serial.println("Wi-Fi shield not present"); 
    lcd.print("Wi-Fi shield");
    //lcd.print("Wi-Fi шилд");
    lcd.setCursor(0,1);
    //lcd.print("not present");
    lcd.print("не знайдено");     
    while (true); // не продовжуємо
  }
  Serial.println("Підключаємося до Wi-Fi точки доступу ..."); 
  //Serial.println("Connecting to AP ...");
  //lcd.print("Connecting to");
  lcd.print("Пiдключення до ");
  lcd.setCursor(0,1); 
  lcd.print(WiFi_ssid[wifi_ind]);
  delay(100);
  // спроба підключення до мережі WiFi
  while (status != WL_CONNECTED) {
    Serial.print(F("Спроба підключитися до WPA SSID: ")); 
    //Serial.print("Attempting to connect to WPA SSID: ");
    //lcd.clear();
    //lcd.print("WPA SSID...");
    Serial.println(WiFi_ssid[wifi_ind]);
    // підключення до мережі WPA/WPA2
    status = WiFi.begin(WiFi_ssid[wifi_ind], WiFi_passwd[wifi_ind]);
    delay(500);
  }
  if (status == WL_CONNECTED) {
    Serial.println(F("Підключено до AP"));
    //Serial.println(F("Connected to AP"));  
    lcd.clear();
    //lcd.setCursor(0,1);
    //lcd.print("connected to AP");
    lcd.print("Пiдключено");
    lcd.setCursor(0,1);
    lcd.print("до AP!");
    delay(100);
  }  
}

void reconnect() 
{
  lcd.clear();
  // цикл до тих пір поки не перепідключимося
  while (!client.connected()) {
    Serial.print("Підключаємося до MQTT-сервера..."); 
    lcd.setCursor(0,0);
    //lcd.print("Connect to MQTT");
    lcd.print("Пiдключення");
    lcd.setCursor(0,1);
    lcd.print("до сервера...");
    // Attempt to connect (clientId, username, password)
    if ( client.connect("mqttClient", token[mqtt_server_ind], NULL) ) { 
      Serial.println( F("done") );
      lcd.print("OK!");     
      delay(100);  
    } else {
      Serial.print( F("failed, rc = " )); 
      int state = client.state();      
      Serial.print(state);
      lcd.setCursor(0,1);
      lcd.print("failed, rc="); lcd.print(state); lcd.print("   ");
      Serial.println(F(": нова спроба підключення через 5 секунд]"));
      // очікування 5 секунд перед новою спробою підключення
      delay(5000);
      //lcd.clear();
    }
  }
  //lcd.clear();
}

void infoAboutDeviceOutput()
{
  lcd.clear();
  lcd.setCursor(0,0);
  lcd.print(iot_device_banner);
  lcd.setCursor(0, 1);
  lcd.print(author_info);
  for(int posCount = 0; posCount < 23; posCount++)
  {
    lcd.scrollDisplayLeft(); //builtin command to scroll left the text
    delay(300); // затримка на 300 мс
  }
  lcd.clear();
}

// button array pos
int btnToPos(uint8_t btn) 
{
   for (int i = 0; i < NUM_OF_BTNS; i++) {
     if (btnsArray[i] == btn) 
       return i;     
   }
   return -1;
}

bool isBtnPressed(int btn_pin)
{
  // читаємо пін кнопки, якщо кнопка натиснута буде високим, якщо ні буде низьким
  int value = digitalRead(btn_pin);
  int pos = btnToPos(btn_pin);  
  /*  випалку якщо зчитане значення не рівне останьому стану кнопки, то встановити останній час деренчання (брязкотіння) у поточний час в мілісекундках, 
  що пройшоа з початку викоання програми millis() */
  if (value != lastBtnState[pos])  {
    lastDebounceTime[pos] = millis();
  }
  // перевірити різницю між поточним часом і останнім зареєстрованим часом натиснення кнопки, якшо він більший встановленого часу затримки, то означає що натиснута кнопка 
  if ((millis() - lastDebounceTime[pos]) > debounceDelay) {
    if (value != btnState[pos]) {
      btnState[pos] = value;
      if (btnState[pos] == HIGH) 
        return true;      
    }
  }
  //зберегти зчитане значення стан кнопки. наступного ращу в циклі зчитаний стан кнопки буде вже як lastButtonState
  lastBtnState[pos] = value; 
  return false;
}

void setWiFiAP()
{
  const char WiFiAP_MenuTitle[] = "* Wi-Fi AP *";
  int i = 0;   
  lcd.clear();
  lcd.setCursor(2,0);
  lcd.print(WiFiAP_MenuTitle);
  lcd.setCursor(0,1);
  lcd.print("> ");
  lcd.setCursor(2,1);
  lcd.print(WiFi_ssid[i]);
  /*lcd.setCursor(15,1);
  lcd.print(">");*/
  while(1)
  {
    lcd.setCursor(2,1);
    lcd.print(WiFi_ssid[i]);
    
    if (isBtnPressed(SELECT_PLUS_BTN_PIN))
    {
      if (i == 2) i = 0;
      else i++;
      lcd.clear();
      lcd.setCursor(2,0);
      lcd.print(WiFiAP_MenuTitle); 
      lcd.setCursor(0,1);
      lcd.print("> ");
      lcd.setCursor(2,1);
      lcd.print(WiFi_ssid[i]);
    }    
    
    if (isBtnPressed(SELECT_MINUS_BTN_PIN))
    {
      if (i == 0) i = 2;
      else i--;
      lcd.clear();
      lcd.setCursor(2,0);
      lcd.print(WiFiAP_MenuTitle);
      lcd.setCursor(0,1);
      lcd.print("> ");
      lcd.setCursor(2,1);
      lcd.print(WiFi_ssid[i]);
    }
    
    if(isBtnPressed(MENU_BTN_PIN))
    {
      wifi_ind = i;
      return;     
    }
    if (isBtnPressed(EXIT_BTN_PIN))
      return;
  }
}

void setMQTTServer()
{
  const char MQTTServerMenuTitle[] = "* MQTT-сервер *";
  const char *mqttServerName[] = {"Mosquitto" , "ThingsBoard"};
  //const uint8_t xpos[] = {2, 1};
  int i = 0;   
  lcd.clear();
  lcd.setCursor(0,0);
  lcd.print(MQTTServerMenuTitle);
  lcd.setCursor(0,1);
  lcd.print("> ");
  /*lcd.setCursor(15,1);
  lcd.print(">");*/  
  lcd.print(mqttServerName[i]); 
 
  while(1)
  {    
    if (isBtnPressed(SELECT_PLUS_BTN_PIN))
    {
      if (i == 1) i = 0;
      else i++;
      lcd.clear();
      lcd.setCursor(0,0);
      lcd.print(MQTTServerMenuTitle);
      lcd.setCursor(0,1);
      lcd.print("> ");      
      lcd.print(mqttServerName[i]);           
    }
    if (isBtnPressed(SELECT_MINUS_BTN_PIN))
    {
      if (i == 0) i = 1;
      else i--;
      lcd.clear();
      lcd.setCursor(0,0);
      lcd.print(MQTTServerMenuTitle);
      lcd.setCursor(0,1);
      lcd.print("> ");      
      lcd.print(mqttServerName[i]);
    }
    if(isBtnPressed(MENU_BTN_PIN))
    {
      mqtt_server_ind = i;
      client.setServer(mqtt_server[mqtt_server_ind], mqtt_port);
      return;     
    }
    if (isBtnPressed(EXIT_BTN_PIN))
      return;
  }
}

void ISR_BtnPressed() {
  /*buttonState = digitalRead(buttonPin);
  digitalWrite(ledPin, buttonState);.*/
  // check if the pushbutton is pressed. If it is, the buttonState is HIGH:
  if (digitalRead(MENU_BTN_PIN) == HIGH) //isBtnPressed(MENU_BTN_PIN)) 
  {
     detachInterrupt(digitalPinToInterrupt(interruptPin));
     mainMenuInvoke = true;
  }
}

void mainMenu()
{
  /*char *mainMenuItems[] = {" Wi-Fi AP  ", "MQTT broker", "Data format", "   Exit    "};
  char menuTitle[] = "** Main Menu **";*/
  char *mainMenuItems[] = {"  Wi-Fi AP ", "MQTT-сервер ", "Формат даних", "   Вихiд     "};
  char menuTitle[] = "* Головне Меню *";
  int i = 0; 
  bool lcdPrint = false;   
  lcd.clear();
  lcd.setCursor(0,0);
  lcd.print(menuTitle);
  lcd.setCursor(2,1);
  lcd.print(mainMenuItems[i]);    
  while(1)
  {
    if (lcdPrint)
    {
      lcd.setCursor(2,1);
      lcd.print(mainMenuItems[i]);
      lcdPrint = !lcdPrint;
    }
    if (isBtnPressed(SELECT_PLUS_BTN_PIN))
    {      
      if(i == 3) i = 0;
      else i++;
      lcdPrint = !lcdPrint;
      //digitalWrite(27, HIGH); // turn the LED on (HIGH is the voltage level)
    }
    if (isBtnPressed(SELECT_MINUS_BTN_PIN))
    {
      if (i == 0) i = 3;
      else i--;
      lcdPrint = !lcdPrint;
      //digitalWrite(27, LOW); // turn the LED off by making the voltage LOW
    }
    if(isBtnPressed(MENU_BTN_PIN))
    {
      switch(i)
      {
        case 0: setWiFiAP(); break; 
        case 1: setMQTTServer(); break;
        case 2: return;       
        default: break;
      }
      lcd.clear();
      //lcd.setCursor(0,0);
      lcd.print(menuTitle);
      lcd.setCursor(2,1);
      lcd.print(mainMenuItems[i]);      
    }
    if (isBtnPressed(EXIT_BTN_PIN))
    {
      lcd.clear();
      mainMenuInvoke = 0;
      attachInterrupt(digitalPinToInterrupt(interruptPin), ISR_BtnPressed, CHANGE);
      return;
    }
  }
}

void setup() { 
    Serial.begin(9600);
    while(!Serial);  // time to get serial running   
    lcd.begin(16, 2);  // виставляємо кількість стовпців і рядків LCD:
    lcd.createChar(0, tempChar);
    lcd.createChar(1, humidityChar);
    lcd.createChar(2, pressureChar);
    infoAboutDeviceOutput();
    Serial.println(F("BME280 тест..."));
    //Serial.println("BME280 test...");
    lcd.clear();
    //lcd.print("BME280 test...");
    lcd.print("BME280 тест...");
    unsigned status;    
    // налаштування за замовчуванням. Можемо також передати об'єкт бібліотеки Wire як &Wire2)
    status = bme.begin(BME280_ADDRESS_ALTERNATE);  
    if (!status) {
        /*Serial.println("Не можливо знайти робочий сенсор BME280, перевірте підлючення, адрес, ID - сенсора !");
        Serial.print("SensorID був: 0x"); Serial.println(bme.sensorID(), 16);
        Serial.println("ID 0xFF можливо означає поганий адрес, BMP 180 або BMP 085");
        Serial.println("ID 0x56-0x58 представляє сенсор BMP280");
        Serial.println("ID 0x60 представляє сенсор BME280");
        Serial.println("ID 0x61 представляє сенсор BME680");*/
        Serial.println("Could not find a valid BME280 sensor, check wiring, address, sensor ID!");
        Serial.print("SensorID was: 0x"); Serial.println(bme.sensorID(),16);
        Serial.println("ID of 0xFF probably means a bad address, a BMP 180 or BMP 085");
        Serial.println("ID of 0x56-0x58 represents a BMP 280");
        Serial.println("ID of 0x60 represents a BME 280");
        Serial.println("ID of 0x61 represents a BME 680");
        lcd.setCursor(0,1);
        lcd.print("couldn't find it");
        while (1);
    }
    Serial.println("пройдено");
    //Serial.println("done");
    lcd.setCursor(0,1);
    lcd.print("done");
    temp = 0.0f; humidity = 0.0f; pressure = 0.0f;
    delayTime = 500;       
    // ініціалізація пінів кнопок як входи:
    pinMode(MENU_BTN_PIN, INPUT);
    pinMode(SELECT_PLUS_BTN_PIN, INPUT);
    pinMode(SELECT_MINUS_BTN_PIN, INPUT);
    pinMode(EXIT_BTN_PIN, INPUT);  
    // підключаємо функцію обробки переривання - Attach an interrupt to the ISR vector
    attachInterrupt(digitalPinToInterrupt(interruptPin), ISR_BtnPressed, CHANGE);
    // ініціалізація Wi-Fi модуля і встановлення сервера
    wifiInit();
    client.setServer(mqtt_server[mqtt_server_ind], mqtt_port);
    delay(200);
    lcd.clear();     
}

void loop() {
  // зчитуємо температуру, вологість і тиск з сенсора BME280
  temp = bme.readTemperature();
  lcd.setCursor(0,0); 
  lcd.write((byte) 0); lcd.print(' ');
  lcd.print(temp,1);
  lcd.print(char(223));  
  lcd.print("C ");
  Serial.print("Температура = ");
  //Serial.print("Temperature = ");
  Serial.print(temp);
  Serial.print("\xC2\xB0");
  Serial.println("C"); 

  humidity = bme.readHumidity();
  lcd.write((byte) 1); lcd.print(' ');
  lcd.print(humidity, 1);
  lcd.print(F("% ")); //lcd.print(F("% RH "));
  Serial.print("Вологiсть = "); 
  //Serial.print("Humidity = ");
  Serial.print(humidity);
  Serial.println("%");
   
  pressure = bme.readPressure() / 100.0F * 0.7500616827;  
  lcd.setCursor(0, 1);
  lcd.write((byte) 2); lcd.print(' ');
  lcd.print(pressure, 1); //(int)pressure);
  lcd.print(" мм.рт.ст");
  //lcd.print(" mmHg");  
  Serial.print("Атмосферний тиск = "); 
  //Serial.print("Pressure = ");
  Serial.print(pressure);
  Serial.println(" мм.рт.ст.");
  //Serial.println(" mmHg");
  
  altetude = bme.readAltitude(SEA_LEVEL_PRESSURE_HPA);
  //lcd.print(altetude);
  //lcd.print(" m");
  Serial.print("Висота = ");
  //Serial.print("Approx. Altitude = ");
  Serial.print(altetude);
  Serial.println(" м");
  //Serial.println(" m");
  Serial.println();

  char jsonBuffer[512];
  size_t jsonMessageSize;
   
  if (!mqtt_server_ind)
  {
    // {"sensorId":"bme280", "data":[{"temp": 27.83}, {"humidity": 62.05}, {"pressure": 1013.25}]}
    const int capacity = JSON_ARRAY_SIZE(3) + 3*JSON_OBJECT_SIZE(1) + JSON_OBJECT_SIZE(2); 
    //StaticJsonDocument<capacity> doc; 
    DynamicJsonDocument doc(capacity);
    doc["sensorId"] = bme.sensorID();
    JsonArray data = doc.createNestedArray("data");
    JsonObject temp_obj = data.createNestedObject();
    temp_obj["temp"] = temp; 
    JsonObject humidity_obj = data.createNestedObject();
    humidity_obj["humidity"] = round(humidity*100)/100.0;
    JsonObject pressure_obj = data.createNestedObject();
    pressure_obj["pressure"] = round(pressure*10)/10.0;
    serializeJson(doc, jsonBuffer);
  }
  else {
    // {"temp": 27.83, "humidity": 62.05, "pressure": 1013.25}
    const int capacity = JSON_OBJECT_SIZE(3); 
    //StaticJsonDocument<capacity> doc; 
    DynamicJsonDocument doc(capacity);
    doc["temp"] = temp; 
    doc["humidity"] = round(humidity*100)/100.0; 
    doc["pressure"] = round(pressure*10)/10.0;  
    serializeJson(doc, jsonBuffer);
  } 
   
  Serial.println("Відсилаємо повідомлення на MQTT-сервер...");
  //Serial.println("Sending message to MQTT broker...");
  Serial.println(jsonBuffer);

  // підключення до Wi-Fi AP і передача даних на MQTT-сервер 
  status = WiFi.status();
  if (status != WL_CONNECTED) {
    while (status != WL_CONNECTED) {
      Serial.print(F("Спроба підключитися до WPA SSID: "));
      //Serial.print("Attempting to connect to WPA SSID: ");
      Serial.println(WiFi_ssid[wifi_ind]);
      // підключення до мережі WPA/WPA2
      status = WiFi.begin(WiFi_ssid[wifi_ind], WiFi_passwd[wifi_ind]);
      delay(500);
    }
    Serial.println(F("Підключено до AP")); 
    //Serial.println("Connected to AP");
  }
    
  if (!client.connected() ) {
    reconnect();
  }    
  if ( millis() - lastSend >= 1000 ) { // поновлення і відсилка даних через 1 секунду
     if (client.publish(topic[mqtt_server_ind], jsonBuffer, jsonMessageSize) == true) {
       Serial.println("Повідомлення відіслано успішно"); 
       //Serial.println("Success sending message");       
     } else {
       Serial.println("Помилка відсилання повідомлення"); 
       //Serial.println("Error sending message");
     }
     lastSend = millis();
   }
   client.loop();
   
   if (mainMenuInvoke)
     mainMenu();     
   delay(delayTime);
}
