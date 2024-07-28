#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>

#ifndef MENUDISPLAY_H
#define MENUDISPLAY_H

class MenuDisplay
{
  public:
    MenuDisplay(Adafruit_SSD1306 *_disp);
    MenuDisplay();
    void Start();
    void Finish();
    void Title(const char text[]);
    void Item(int index, const char text[]);
    void Highlight(int index, const char text[]);
    //void MessageBox(const char text[]);
    /* функція перекодування букв кирилиці з UTF-8 в Win-1251 */
    //String utf8cyr(char source[]);
  private:
    Adafruit_SSD1306 *disp;
    // char tempBuffer[32];
};
#endif
