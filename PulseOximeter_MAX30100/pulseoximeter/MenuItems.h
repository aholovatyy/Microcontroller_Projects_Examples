// required for "prog_char" and "PROGMEM"
#include <avr/pgmspace.h>

// назви пунктів меню
const char back[] PROGMEM = "< Back";
const char buzzerOn[] PROGMEM = "On";
const char buzzerOff[] PROGMEM = "Off";

const char minHR[] PROGMEM = "Min: ";
const char maxHR[] PROGMEM = "Max: ";

const char SpO2LowAlarmLimit[] PROGMEM = "lim: ";

const char root[] PROGMEM = "Main menu"; //"Головне меню"; //"Root menu";
const char submenu1[] PROGMEM = "HR limits, bpm";
const char submenu2[] PROGMEM = "SpO2 low limit, %";
const char submenu3[] PROGMEM = "Buzzer control";
//const char submenu4[] PROGMEM = "Language";

// меню - першим елементом є заголовок меню і він не враховується в cnt 
const char* const mnuMain[] PROGMEM = {
  root, 
  submenu1, submenu2, submenu3};
const int cntMain PROGMEM = 3;

const char* const mnuSubmenu1[] PROGMEM = {
  submenu1, 
  minHR, maxHR, back};
const int cntSubmenu1 PROGMEM = 3;

const char* const mnuSubmenu2[] PROGMEM = {
  submenu2,
  SpO2LowAlarmLimit, back};
const int cntSubmenu2 PROGMEM = 2;

const char* const mnuSubmenu3[] PROGMEM = {
  submenu3,
  buzzerOn, buzzerOff, back};
const int cntSubmenu3 PROGMEM = 3;
 
