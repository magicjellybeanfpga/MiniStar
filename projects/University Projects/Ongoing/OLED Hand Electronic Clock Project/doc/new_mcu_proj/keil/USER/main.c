
/*
 * *****************************************************************************************
 *
 * 		Copyright (C) 2014-2019 Gowin Semiconductor Technology Co.,Ltd.
 * 		
 * @file			main.c
 * @author		Embedded Development Team
 * @version		V1.0.0
 * @date			2019-10-1 09:00:00
 * @brief			Main program body.
 ******************************************************************************************
 */

/* Includes ------------------------------------------------------------------*/
#include "gw1ns4c.h"
#include "gw1ns4c_conf.h"
#include "oled.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>


void Draw_Clock(void);

int main(void)
{
  int hh, mm, ss;
  OLED_Init();

  printf("Enter the time\nFormat hh mm ss\n");
  scanf("%d%d%d", &hh, &mm, &ss);
  SystickInit();
  Set_RealTime(hh, mm, ss);
  puts("Read over");
  printf("%d:%d:%d\n", hh, mm, ss);
  UART0->CTRL = 0;

  while(1)
  {
    if(Update_Time == UPDATE_TIME) {
      OLED_ClearGRAM();
      Draw_Clock();
      OLED_WriteFrame();
      Update_Time == UPDATE_FINISH;
    }
  }
}

void Draw_Clock(void){
  char Time[9];
  uint16_t second_hand, minute_hand, hour_hand;
  second_hand = RealTime_Second<15 ? 90-RealTime_Second*6 : 450-RealTime_Second*6;
  minute_hand = RealTime_Minute<15 ? 90-RealTime_Minute*6 : 450-RealTime_Minute*6;
  hour_hand = (RealTime_Hour%12)*30<15 ? 90-(RealTime_Hour%12)*30 : 450-(RealTime_Hour%12)*30;
  // Clock face
  OLED_DrawPoint(32, 32);
  OLED_DrawLine(32, 3, 32, 5);
  OLED_DrawLine(3, 32, 5, 32);
  OLED_DrawLine(32, 61, 32, 59);
  OLED_DrawLine(61, 32, 59, 32);
  OLED_DrawCircle(32, 32, 30);
  // Clock Hands
  OLED_DrawLineAngle(32, 32, second_hand, 25);
  OLED_DrawLineAngle(32, 32, minute_hand, 20);
  OLED_DrawLineAngle(32, 32, hour_hand, 12);
  OLED_DrawString(64, 3, "Time is:");
  sprintf(Time, "%02d:%02d:%02d", RealTime_Hour, RealTime_Minute, RealTime_Second);
  OLED_DrawString(64, 5, Time);
  OLED_WriteFrame();
  return;
}
