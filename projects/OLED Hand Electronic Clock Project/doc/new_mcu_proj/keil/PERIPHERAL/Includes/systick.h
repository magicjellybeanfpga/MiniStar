/*
 * *****************************************************************************************
 *
 * 		Copyright (C) 2014-2019 Gowin Semiconductor Technology Co.,Ltd.
 * 		
 * @file		systick.h
 * @author		Embedded Development Team
 * @version		V1.0.0
 * @date		2019-10-1 09:00:00
 * @brief		Systick header file
 ******************************************************************************************
 */
 
#ifndef SYSTICK_H
#define SYSTICK_H

#include "gw1ns4c.h"

extern volatile uint32_t RealTime_Count;

void SystickInit(void);
void Delay_Init(void);
void delay_us(uint32_t nus);
void delay_ms(uint32_t nms);


#endif
