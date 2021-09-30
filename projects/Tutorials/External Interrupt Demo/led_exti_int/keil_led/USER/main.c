
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

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void GPIOInit(void);

void Delay(__IO uint32_t nCount)//25M 1s = 8333000
{
	for(; nCount != 0; nCount--);
}

int main(void)
{
	NVIC_PriorityGroupConfig(NVIC_PriorityGroup_3);
	SystemInit();
  GPIOInit();
	
	while(1)
	{
//		GPIO_SetBit(GPIO0,GPIO_Pin_0);
//		Delay(8333000);
//		GPIO_ResetBit(GPIO0,GPIO_Pin_0);
//		Delay(8333000);
	}
  
}



//Initializes GPIO
void GPIOInit(void)
{
	GPIO_InitTypeDef GPIO_InitType;
	NVIC_InitTypeDef InitTypeDef_NVIC;
	
	GPIO_InitType.GPIO_Pin = GPIO_Pin_0;
	GPIO_InitType.GPIO_Mode = GPIO_Mode_OUT;
	GPIO_InitType.GPIO_Int = GPIO_Int_Disable;

	GPIO_Init(GPIO0,&GPIO_InitType);

  GPIO_SetBit(GPIO0,GPIO_Pin_0);
	
	//GPIO_15  IN: KEY1 interrupt
	GPIO_InitType.GPIO_Pin = GPIO_Pin_15;
	GPIO_InitType.GPIO_Mode = GPIO_Mode_AF;
	GPIO_InitType.GPIO_Int = GPIO_Int_Rising_Edge;  
	GPIO_Init(GPIO0,&GPIO_InitType);
	
	//Enable PORT0_15_IRQn interrupt handler
	InitTypeDef_NVIC.NVIC_IRQChannel = PORT0_15_IRQn;
  InitTypeDef_NVIC.NVIC_IRQChannelPreemptionPriority = 1;
  InitTypeDef_NVIC.NVIC_IRQChannelSubPriority = 0;
  InitTypeDef_NVIC.NVIC_IRQChannelCmd = ENABLE;
  NVIC_Init(&InitTypeDef_NVIC);	
}




