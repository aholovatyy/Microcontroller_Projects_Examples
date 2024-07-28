/* class MenuOperation
   version: 1.0
   13.04.2021
*/

#include <avr/pgmspace.h>
#include "MenuOperation.h"
#include "MenuDisplay.h"

MenuOperation::MenuOperation(Adafruit_SSD1306 *_disp)
{
  md = MenuDisplay(_disp);
  selectedIndex = 0;
  itemCount = 0;
  firstVisible = 1;
  disp = _disp;
}

void MenuOperation::InitMenu(const char **page, int _itemCount, int _selectedIndex)
{
  currentMenu = page;
  selectedIndex = _selectedIndex;
  itemCount = _itemCount;
  //ProcessMenu(ACTION_NONE);
  ShowMenu();
}

int MenuOperation::ProcessMenu(int _action)
{
  if (_action == ACTION_DOWN)
    selectedIndex++;
  if (_action == ACTION_UP)
    selectedIndex--;
    
  if (selectedIndex > itemCount)
    selectedIndex = 1;
  if (selectedIndex < 1)
    selectedIndex = itemCount;
  
  if (_action == ACTION_SELECT)
    return selectedIndex;
  
  ShowMenu();  
  return selectedIndex;
}

void MenuOperation::ShowValues(int values[])
{
  for (int i = 0; i < itemCount-1; i++)
  {
    itoa(values[i], tempBuffer, 10);
    if (i == selectedIndex -1)
      disp->setTextColor(BLACK, WHITE);
    else 
      disp->setTextColor(WHITE, BLACK);
    disp->setCursor(35,(i*16)+20);
    disp->print(tempBuffer);
    disp->display();
  }
}

void MenuOperation::ShowMenu()
{
  if (selectedIndex > firstVisible + 2)
    firstVisible = selectedIndex - 2;
  else if (selectedIndex < firstVisible)
    firstVisible = selectedIndex;
  
  md.Start();  
  // виводимо заголовок меню
  strcpy_P(tempBuffer, (char*) pgm_read_word(&(currentMenu[0])));
  md.Title(tempBuffer);
  
  // виводимо пункти меню, 3 на сторінку екрану
  int p = 3;
  if (p > (itemCount - firstVisible + 1))
    p = itemCount - firstVisible + 1;
  for (int i = 0; i < p; i++)
  {
    strcpy_P(tempBuffer, (char*)pgm_read_word(&(currentMenu[i + firstVisible]))); // currentMenu[i + firstVisible]); 
    md.Item(i, tempBuffer);
  }
  
  // відображаємо вибраний пункт меню
  int ind = selectedIndex - firstVisible;
  //md.Highlight(selectedIndex - firstVisible, currentMenu[i + firstVisible);
  strcpy_P(tempBuffer, (char*)pgm_read_word(&(currentMenu[selectedIndex])));
  md.Highlight(ind, tempBuffer); //(char*)pgm_read_word(&(currentMenu[selectedIndex])));
  md.Finish();
}
