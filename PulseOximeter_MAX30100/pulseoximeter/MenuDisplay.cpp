#include "MenuDisplay.h"

MenuDisplay::MenuDisplay()
{
  
}

MenuDisplay::MenuDisplay(Adafruit_SSD1306 *_disp)
{
  disp = _disp;
}

void MenuDisplay::Start()
{
  disp->clearDisplay();
  //disp->setFont(7);
}

void MenuDisplay::Finish()
{
}

void MenuDisplay::Title(const char text[])
{
  //_disp.clearDisplay();
  disp->setTextSize(1);
  disp->setTextColor(SSD1306_WHITE);
  disp->setCursor(64-6*strlen(text)/2, 0);
  disp->print(text); 
  //disp->print(utf8cyr(text));
  disp->drawLine(0, 12, 128, 12, SSD1306_WHITE); // буква 10x16 пікселів (wxh)
  disp->display();
  delay(1);
}

void MenuDisplay::Item(int index, const char text[])
{
  disp->setTextSize(1);
  disp->setCursor(5,(index*16)+20);
  disp->print(text);
  //disp->print(utf8cyr(text));
  disp->display();
}

void MenuDisplay::Highlight(int index, const char text[])
{
  disp->setTextColor(BLACK, WHITE);
  disp->fillRect(2,(index*16)+18,125,12,SSD1306_WHITE);
  disp->setCursor(5,(index*16)+20);
  disp->print(text);
  //disp->print(utf8cyr(text));
  disp->display();
}

/* функція перекодування букв кирилиці з UTF-8 в Win-1251 */
/*String MenuDisplay::utf8cyr(char source[])
{
  int i,k;
  String target;
  unsigned char n;
  char m[2] = { '0', '\0' };
  k = strlen(source); i = 0;
  while (i < k) {
    n = source[i]; i++;
    if (n >= 0xC0) {
      switch (n) {
        case 0xD0: {
          n = source[i]; i++;
          if (n == 0x81) { n = 0xA8; break; }
          if (n >= 0x90 && n <= 0xBF) n = n + 0x30;
          break;
        }
        case 0xD1: {
          n = source[i]; i++;
          if (n == 0x91) { n = 0xB8; break; }
          if (n >= 0x80 && n <= 0x8F) n = n + 0x70;
          break;
        }
      }
    }
    m[0] = n; target = target + String(m);
  }
  return target;
}*/
