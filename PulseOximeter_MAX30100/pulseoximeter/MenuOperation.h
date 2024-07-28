/* MenuOperation header
   version: 1.0
   13.04.2021
*/

#include "MenuDisplay.h"

#ifndef MENUOPERATION_H
#define MENUOPERATION_H

#define ACTION_NONE    0
#define ACTION_UP      1
#define ACTION_DOWN    2
#define ACTION_SELECT  3
#define ACTION_BACK    4

class MenuOperation
{
  public:
    MenuOperation(Adafruit_SSD1306 *_disp);
    void InitMenu(const char **page, int _itemCount, int _selectedIndex);
    int ProcessMenu(int _action);
    void ShowMenu();
    //void MessageBox(const char text[]) { md.MessageBox(text); };    
    void ShowValues(int values[]);
    const char **currentMenu;
    MenuDisplay md;
    //MenuDisplay md;
  private:
    int selectedIndex;
    int itemCount;
    int firstVisible;
    
    char tempBuffer[32];
    Adafruit_SSD1306 *disp;
    //MenuDisplay md;
};

#endif
