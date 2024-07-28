/*
 Цировий пульсоксиметр на платформі Arduino і давачі MAX30100 
 (Digital pulse oximeter based on Arduino platform and MAX30100 sensor)
 */

#include <SPI.h>
#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>
#include <MAX30100.h>
#include <MAX30100_BeatDetector.h>
//#include <MAX30100_Filters.h>
#include <MAX30100_PulseOximeter.h>
//#include <MAX30100_Registers.h>
//#include <MAX30100_SpO2Calculator.h>

#include "MenuDisplay.h"
#include "MenuOperation.h"
#include "MenuItems.h"

#define SCREEN_WIDTH 128 // ширина OLED дисплею, в пікселях
#define SCREEN_HEIGHT 64 // висота OLED дисплею, в пікселях

// апаратний інтерфейс SPI
/*#define OLED_DC     6 //
#define OLED_CS     5 // 7
#define OLED_RESET  8 //

Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT,
  &SPI, OLED_DC, OLED_RESET, OLED_CS);*/

// Declaration for SSD1306 display connected using software SPI (default case):
#define OLED_MOSI   9
#define OLED_CLK   10
#define OLED_DC    11
#define OLED_CS    12
#define OLED_RESET 13

/*#define OLED_MOSI   8
#define OLED_CLK   9
#define OLED_DC    10
#define OLED_CS    11
#define OLED_RESET 12*/

Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT,
  OLED_MOSI, OLED_CLK, OLED_DC, OLED_RESET, OLED_CS);

MenuOperation menu = MenuOperation(&display);

// визначаємо піни до яких підключені кнопки 
#define NUM_OF_BTNS 4
// Arduino Uno: A0 = pin14, A1 = pin15, A2 = pin16, A3 = pin17
#define SELECT_BUTTON_PIN 2 
#define UP_BUTTON_PIN 15
#define DOWN_BUTTON_PIN 16
#define EXIT_BUTTON_PIN 17
// Arduino Micro: A0 = pin14, A1 = pin19, A2 = pin20, A3 = pin21
/*#define SELECT_BUTTON_PIN 7 //18 
#define UP_BUTTON_PIN 19
#define DOWN_BUTTON_PIN 20
#define EXIT_BUTTON_PIN 21*/

unsigned long lastDebounceTime[NUM_OF_BTNS] = {0, 0, 0, 0}; // останній час, коли вихідний пін був переключений

int lastBtnState[NUM_OF_BTNS] = {LOW, LOW, LOW, LOW};
int btnState[NUM_OF_BTNS];
int btnsArray[NUM_OF_BTNS] = {SELECT_BUTTON_PIN, UP_BUTTON_PIN, DOWN_BUTTON_PIN, EXIT_BUTTON_PIN}; 

const byte interruptPin = 2; // interrupt0 - pin 2, interrupt1 - pin 3, interrupt2 - pin 21, interrupt3 - pin 20, interrupt4 - pin 19, interrupt5 - pin 18
volatile bool mainMenuInvoke = false;
unsigned long debounceDelay = 50; // час деренчання; збільшити якщо вихід деренчить (шумить), час затримки

#define REPORTING_PERIOD_MS  100

PulseOximeter pox;

const int numberOfSamples = 100;
float filter_weight = 0.5;
uint32_t tsLastReport = 0;
uint32_t last_beat = 0;
int sampleIndex = 0;
int average_beat = 75;
int average_SpO2 = 98;
bool isCalculationCompleted = false;
bool calculation = false;
bool initialized = false;
byte beat = 0;
int HR_values[2] = {30, 220};
int alarm_limit_SpO2 = 50;

/*int x = 0;
int lastx = 0;
int lasty = 0;*/

const char* const title[] PROGMEM = {"Digital pulseoximeter", "2021, developed by", "Andriy Holovatyy"};
const char* const text1[] PROGMEM = {"Please, ", "place your finger", "on the sensor..."};

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

void ISR_btnPressed() {
  /*buttonState = digitalRead(buttonPin);
  digitalWrite(ledPin, buttonState);.*/
  //pox.shutdown();
  // check if the pushbutton is pressed. If it is, the buttonState is HIGH:
  //if (digitalRead(SELECT_BUTTON_PIN) == HIGH) //isBtnPressed(SELECT_BUTTON_PIN))
  //{
     detachInterrupt(digitalPinToInterrupt(interruptPin));
     mainMenuInvoke = true; 
     //delay(250);    
  //}
}

void mainMenu()
{
  int keycode = 0;
  int clickedItem = 0; 
  bool HRflag = 0;
 
  menu.InitMenu(mnuMain, cntMain, 1); 
  while(1)
  {
    if (isBtnPressed(UP_BUTTON_PIN))
    {
      if (HRflag)
        HR_values[clickedItem-1]++;     
      else
        menu.ProcessMenu(ACTION_UP);
      if (menu.currentMenu == mnuSubmenu1)
        menu.ShowValues(HR_values);    
    } 
    
    if (isBtnPressed(DOWN_BUTTON_PIN))
    {
       if (HRflag)
        HR_values[clickedItem-1]--;      
      else
        menu.ProcessMenu(ACTION_DOWN);
        if (menu.currentMenu == mnuSubmenu1)
          menu.ShowValues(HR_values);
    }
    
    if(isBtnPressed(SELECT_BUTTON_PIN))
    {
      clickedItem = menu.ProcessMenu(ACTION_SELECT);
      if (clickedItem > 0)
      {
       // логіка обробки пунктів головного меню
       if (menu.currentMenu == mnuMain)
       switch (clickedItem)
       {
        case 1:
          menu.InitMenu(mnuSubmenu1, cntSubmenu1, 1);
          menu.ShowValues(HR_values);
          break;
        case 2:
          menu.InitMenu(mnuSubmenu2, cntSubmenu2, 1);
          menu.ShowValues(&alarm_limit_SpO2);
          break;
        case 3:
          menu.InitMenu(mnuSubmenu3, cntSubmenu3, 1);
          break;
        case 4:
          //menu.MessageBox("Some message!");
          break; 
      }
      // логіка обробки пунктів меню HR (heart-rate) Submenu 1
      else if (menu.currentMenu == mnuSubmenu1)
        switch (clickedItem)
        {
          case 1:            
              HRflag = !HRflag;                                  
            break;
          case 2:
              HRflag = !HRflag;             
            break;
          case 3: 
            menu.InitMenu(mnuMain, cntMain, 1);
            break;
      }
      // логіка обробки пунктів меню SpO2 Submenu 2
      else if (menu.currentMenu == mnuSubmenu2)
        switch (clickedItem)
        {
          case 1:
            //menu.MessageBox("On");
            break;
          case 2:
            menu.InitMenu(mnuMain, cntMain, 2);
            break;
      }
      // логіка обробки пунктів меню зумера (buzzer) Submenu 3
      else if (menu.currentMenu == mnuSubmenu3)
        switch (clickedItem)
        {
          case 1:
            //menu.MessageBox("On");
            break;
          case 2:
            //menu.MessageBox("Off");
            break;
          case 3:
            menu.InitMenu(mnuMain, cntMain, 3);
            break;
      }
     }  
    }
    if (isBtnPressed(EXIT_BUTTON_PIN))
    {
      display.clearDisplay(); 
      display.display();
      mainMenuInvoke = 0;
      attachInterrupt(digitalPinToInterrupt(interruptPin), ISR_btnPressed, CHANGE);
      return;
    }   
  }
}

void onBeatDetected() //Calls back when pulse is detected
{
  beatView();
  last_beat = millis();
}

void beatView() 
{
  
  if (beat == 0) {
    Serial.print(F("_"));
    beat = 1;
  } 
  else
  {
    Serial.print(F("^"));
    beat = 0;
  }
}

void displayInit() // ініціалізація виводу на дисплей
{
  if (!initialized) 
  {
    beatView();
    /*Serial.println(F("*** Digital pulse oximeter based on the MAX30100 sensor ***"));
    Serial.println(F("(C) 2021, developed by Andriy Havanchak"));*/
    
    /*Serial.println("*** Цифровий пульсоксиметр на давачі MAX30100 ***");
    Serial.println("(С) 2021, розробив Андрій Гаванчак");*/  
    
    //Serial.println(F("Please, place your finger on the sensor..."));    
    //Serial.println("Покладіть, будь-ласка, палець на давач...");*/
    
    display.clearDisplay();  
    display.setTextSize(1);
    display.setTextColor(WHITE);
    display.setCursor(0,0);
    display.println((char*)pgm_read_word(&(title[0])));
    display.display();
    display.setCursor(0,20);
    display.println((char*)pgm_read_word(&(title[1])));
    display.println((char*)pgm_read_word(&(title[2])));
    /*
    display.setCursor(0,30);
    display.println(F("Digital pulseoximeter"));
    display.setCursor(0,20);
    display.println(F("2021, developed by"));
    display.println(F("Andriy Havanchak"));
    */
    /* 
    display.setCursor(0,20);
    display.print(utf8cyr("Цифровий пульсоксиметр"));
    display.println(utf8cyr("2021, розробив"));
    display.println(utf8cyr("Андрiй Гаванчак"));
    */
    display.display();
    delay(2000);  
  
    display.clearDisplay(); 
    display.setCursor(0, 20);
    display.println(F("Please, "));
    display.println(F("place your finger "));
    display.println(F("on the sensor..."));
    /*display.println((char*)pgm_read_word(&(text1[0])));
    display.println((char*)pgm_read_word(&(text1[1])));
    display.println((char*)pgm_read_word(&(text1[2])));*/
    display.display();
    delay(200);
    displayValues();
    initialized = true;
  }
}

/*void displayCalculation(int j)
{
  beatView();
  Serial.println("Measuring"); 
  display.clearDisplay(); 
  display.setCursor(0, 0);
  display.setTextSize(2); 
  display.println(F("Measuring"));
  display.display();  
  for (int i=0; i <= j; i++) 
  {
    Serial.print(". ");
    display.print(F("."));
    display.display();
  }  
}*/

void displayValues()
{
  String average_beat_buff = String(average_beat);
  average_beat_buff += " bpm"; 
  //average_beat_buff += " уд/хв";
  String average_SpO2_buff = String(average_SpO2);
  average_SpO2_buff += "%";
  Serial.println();
  Serial.print(F("HR: "));
  Serial.println(average_beat_buff);
  Serial.print(F("SpO2: "));
  Serial.println(average_SpO2_buff);
  display.clearDisplay(); 
  display.setCursor(0, 0);
  display.setTextSize(2); 
  display.println(F("HR & SpO2"));
  display.display();  
  display.println(F("76 bpm"));//average_beat_buff);
  display.println(F("97%"));//average_SpO2_buff);
  display.display();  
}

void averageValuesCalculation(int beat_value, int SpO2_value) 
{
  if (sampleIndex == numberOfSamples) {
    isCalculationCompleted = true;
    calculation = false;
    initialized = false;
    sampleIndex = 0;
    displayValues();
  }
  
  if (!isCalculationCompleted and beat_value > 30 and beat_value < 220 and SpO2_value > 50) 
  {
    average_beat = filter_weight * (beat_value) + (1 - filter_weight) * average_beat;
    average_SpO2 = filter_weight * (SpO2_value) + (1 - filter_weight) * average_SpO2;
    
    sampleIndex++;
    
    /*if(x > 127)  
    {
      display.clearDisplay(); 
      display.setCursor(0, 0);
      x = 0;
      lastx = x;
    }*/
    /*display.setTextColor(WHITE);
    int y=40 - (beat_value/8);
    display.writeLine(lastx, lasty, x, y, WHITE);
    lasty = y;
    lastx = x;
    x++
    */    
    // виводимо bpm (уд/хв) при вимірюванні в реальному часі
    display.setCursor(0, 50);
    display.setTextSize(2);
    display.print(beat_value);
    display.print(" bpm");
    display.display();
    // calc bpm
    //displayCalculation(sampleIndex);
  }
}

void setup()
{
  // ініціалізація послідовного інтерфейсу
  Serial.begin(9600);
  // ініціалізація пінів кнопок як входи:
  pinMode(SELECT_BUTTON_PIN, INPUT);
  pinMode(UP_BUTTON_PIN, INPUT);
  pinMode(DOWN_BUTTON_PIN, INPUT);
  pinMode(EXIT_BUTTON_PIN, INPUT);  
  // підключаємо функцію обробки переривання - Attach an interrupt to the ISR vector
  attachInterrupt(digitalPinToInterrupt(interruptPin), ISR_btnPressed, CHANGE);   
  
  // ініціалізація дисплею з драйвером SSD1306_SWITCHCAPVCC = генерує дисплейну напругу з 3.3V внутрішньо
  if (!display.begin(SSD1306_SWITCHCAPVCC)) {
    Serial.println(F("SSD1306 allocation failed!"));
    for(;;); 
  }
  delay(1000);  
  
  // ініціалізація давача MAX30100
  pox.begin();
  pox.setOnBeatDetectedCallback(onBeatDetected);
      
  displayInit();         
}

void loop()
{
    /*pox.update(); 
    if ((millis() - tsLastReport > REPORTING_PERIOD_MS) and (!isCalculationCompleted)) {
        averageValuesCalculation(pox.getHeartRate(), pox.getSpO2());
        tsLastReport = millis();
    }
    if ((millis() - last_beat > 10000)) {
      isCalculationCompleted = false;
      average_beat = 0;
      average_SpO2 = 0;
      displayInit();
    }*/
   
    if (mainMenuInvoke)
    {
      mainMenu();
    } 
}
