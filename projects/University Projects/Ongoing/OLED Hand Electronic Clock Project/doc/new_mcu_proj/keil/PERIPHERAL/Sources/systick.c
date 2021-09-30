/*
 * *****************************************************************************************
 *
 * 		Copyright (C) 2014-2019 Gowin Semiconductor Technology Co.,Ltd.
 * 		
 * @file			systick.c
 * @author		Embedded Development Team
 * @version		V1.0.0
 * @date			2019-10-1 09:00:00
 * @brief			Systick
 ******************************************************************************************
 */
 
#include "systick.h"

uint32_t us_value;
uint32_t ms_value;
volatile uint32_t RealTime_Count=0;

//systick initialization
//start systick
void SystickInit(void)
{
	//SystemCoreClock / 1000 : 1ms interrupt
	uint32_t temp = SystemCoreClock / 100;	//10ms interrupt
	SysTick->LOAD = temp;
	SysTick->VAL = temp;//Reset current counter's value
	
	//select clock source, enable interrupt, enable counter
	SysTick->CTRL = SysTick_CTRL_CLKSOURCE_Msk | 
					SysTick_CTRL_TICKINT_Msk | 
					SysTick_CTRL_ENABLE_Msk; 
}

void Delay_Init(void) {
	SysTick_CLKSourceConfig(0);		//select HCLK
	us_value = SystemCoreClock/1000000;
	ms_value = SystemCoreClock/1000;
}

//delay n us
void delay_us(uint32_t nus)
{
	uint32_t temp;
	SysTick->LOAD = nus*us_value;
	SysTick->VAL = 0;
	SysTick->CTRL |= SysTick_CTRL_ENABLE_Msk;
	do
	{
		temp = SysTick->CTRL;
	} while ((temp&SysTick_CTRL_ENABLE_Msk) && !(temp&SysTick_CTRL_COUNTFLAG_Msk));
	SysTick->CTRL &= ~SysTick_CTRL_ENABLE_Msk;
	SysTick->VAL = 0;
	return;
}

//delay n ms, n<=300
void delay_ms(uint32_t nms)
{
	uint32_t temp;
	SysTick->LOAD = nms*ms_value;
	SysTick->VAL = 0;
	SysTick->CTRL |= SysTick_CTRL_ENABLE_Msk;
	do
	{
		temp = SysTick->CTRL;
	} while ((temp&SysTick_CTRL_ENABLE_Msk) && !(temp&SysTick_CTRL_COUNTFLAG_Msk));
	SysTick->CTRL &= ~SysTick_CTRL_ENABLE_Msk;
	SysTick->VAL = 0;
	return;
}
