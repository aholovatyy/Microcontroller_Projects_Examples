#include <MAX30100.h>
#include <MAX30100_BeatDetector.h>
#include <MAX30100_Filters.h>
#include <MAX30100_PulseOximeter.h>
#include <MAX30100_Registers.h>
#include <MAX30100_SpO2Calculator.h>
#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>

#define SCREEN_WIDTH 128 // OLED display width, in pixels
#define SCREEN_HEIGHT 64 // OLED display height, in pixels

// Comment out above, uncomment this block to use hardware SPI
#define OLED_DC     6
#define OLED_CS     7
#define OLED_RESET  8

Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT,
  &SPI, OLED_DC, OLED_RESET, OLED_CS);

#define REPORTING_PERIOD_MS     500

PulseOximeter pox;

const int numReadings=10;
float filterweight=0.5;
uint32_t tsLastReport = 0;
uint32_t last_beat=0;
int readIndex=0;
int average_beat=0;
int average_SpO2=0;
bool calculation_complete=false;
bool calculating=false;
bool initialized=false;
byte beat=0;


void onBeatDetected() //Calls back when pulse is detected
{
  viewBeat();
  last_beat=millis();
}

void viewBeat() 
{

  if (beat==0) {
   Serial.print("_");
    beat=1;
  } 
  else
  {
   Serial.print("^");
    beat=0;
  }
}

void initial_display() 
{
  if (not initialized) 
  {
    viewBeat();
  Serial.print(" MAX30100 Pulse Oximeter Test");
  Serial.println("******************************************");
  Serial.println("Place place your finger on the sensor");
  Serial.println("********************************************");
  /*display.clearDisplay(); 
  display.setCursor(0, 0);  
  display.setTextSize(1); 
  display.println(F("MAX30100 Sensor Test"));
  display.println(F("Place place your finger"));
  display.println(F("on the sensor"));
  display.display();  */
  initialized=true;
  }
}

void display_calculating(int j){

  viewBeat();
  Serial.println("Measuring"); 
  display.clearDisplay(); 
  display.setCursor(0, 0);
  display.setTextSize(2); 
  display.println(F("Measuring"));
  display.display();  
  for (int i=0;i<=j;i++) {
    Serial.print(". ");
    display.print(F("."));
    display.display();
  }  
}

void display_values()
{
  Serial.print(average_beat);
  Serial.print("| Bpm ");
  Serial.print("| SpO2 ");
  Serial.print(average_SpO2);
  Serial.print("%"); 
  display.clearDisplay(); 
  display.setCursor(0, 0);
  display.setTextSize(2); 
  display.println(F("HR & SpO2"));
  String average_beat_buff = String(average_beat);
  average_beat_buff += " bpm";
  String average_SpO2_buff = String(average_SpO2);
  average_SpO2_buff += "%";
  display.println(average_beat_buff);
  display.println(average_SpO2_buff);
  display.display();  
}

void calculate_average(int beat, int SpO2) 
{
  if (readIndex==numReadings) {
    calculation_complete=true;
    calculating=false;
    initialized=false;
    readIndex=0;
    display_values();
  }
  
  if (not calculation_complete and beat>30 and beat<220 and SpO2>50) {
    average_beat = filterweight * (beat) + (1 - filterweight ) * average_beat;
    average_SpO2 = filterweight * (SpO2) + (1 - filterweight ) * average_SpO2;
    readIndex++;
    display_calculating(readIndex);
  }
}

void setup()
{
    Serial.begin(115200);
   
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
  display.setCursor(0, 0);
  display.setTextSize(2); 
  display.println(F("Initialize"));
  display.setTextSize(1); 
  display.println(F("max30100 sensor"));
  display.print(F("..."));
  display.display();
  //delay(3000);
  pox.begin();
  pox.setOnBeatDetectedCallback(onBeatDetected);
  display.println(F("success!"));
  display.display();   
}


void loop()
{
    
    pox.update(); 
    if ((millis() - tsLastReport > REPORTING_PERIOD_MS) and (not calculation_complete)) {
        calculate_average(pox.getHeartRate(),pox.getSpO2());
        tsLastReport = millis();
    }
    if ((millis()-last_beat>10000)) {
      calculation_complete=false;
      average_beat=0;
      average_SpO2=0;
      initial_display();
    }
}
