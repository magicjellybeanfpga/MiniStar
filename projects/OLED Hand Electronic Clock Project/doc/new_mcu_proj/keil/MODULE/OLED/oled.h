#ifndef __OLED_H
#define __OLED_H
#include "gw1ns4c_i2c.h"
#include <math.h>

#define Max_Column	128
#define Max_Row		64
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
 		     
#define OLED_CMD  0
#define OLED_DATA 1


// OLED control function
void Write_IIC_Command(u8 IIC_Command);
void Write_IIC_Data(u8 IIC_Data);
void OLED_WR_Byte(u8 dat,u8 cmd);
void OLED_WR_Data(u8 *dat,u16 data_num);
void OLED_Init(void);

/**
 * @brief Draw a point into the GRAM
 * @param x column 0~127
 * @param y row 0~63
 */
void OLED_DrawPoint(u8 x, u8 y);

/**
 * @brief Draw a line into the GRAM
 * @param x0 column of starting point
 * @param y0 row of starting point
 * @param x1 column of ending point
 * @param y1 row of ending point
 */
void OLED_DrawLine(u8 x0, u8 y0, u8 x1, u8 y1);

/**
 * @brief Draw a line into the GRAM
 * @param x0 column of starting point
 * @param y0 row of starting point
 * @param angle angle of the line in degree
 * @param len length of the line
 */
void OLED_DrawLineAngle(u8 x0, u8 y0, u16 angle, u8 len);

/**
 * @brief Draw symmetric point of a circle
 */
void OLED_DrawCirclePoint(u8 x0, u8 y0, u8 x, u8 y);

/**
 * @brief Draw a point into the GRAM
 * @param x0 central column 0~127
 * @param y0 central row 0~63
 * @param r  radius
 */
void OLED_DrawCircle(u8 x0, u8 y0, u8 r);

/**
 * @brief Draw the hand of clock into the GRAM
 * @param orient orientation of the hand
 * @param len length of the hand
 */
void OLED_DrawClockHand(u8 orient, u8 len);

/**
 * @brief Draw a character into the GRAM
 * @param x column
 * @param y row of character
 */
void OLED_DrawChar(u8 x, u8 y, char ch);

/**
 * @brief Draw a string into the GRAM
 * @param x column
 * @param y row of character
 * @param string string to draw
 */
void OLED_DrawString(u8 x, u8 y, char *string);

/**
 * @brief Clear the GRAM
 */
void OLED_ClearGRAM(void);

/**
 * @brief Write the GRAM to OLED
 */
void OLED_WriteFrame(void);

#endif
