
/*
 * *****************************************************************************************
 *
 * 		Copyright (C) 2014-2021 Gowin Semiconductor Technology Co.,Ltd.
 * 		
 * @file			main.c
 * @author		Embedded Development Team
 * @version		V1.x.x
 * @date			2021-01-01 09:00:00
 * @brief			Main program body.
 ******************************************************************************************
 */

/* Includes ------------------------------------------------------------------*/
#include "gw1ns4c.h"

/* Macros ------------------------------------------------------------------*/
#define KEY_ON	1
#define KEY_OFF	0

#define N_BLINK 5

/* Declarations ------------------------------------------------------------------*/
uint8_t Key_Scan(GPIO_TypeDef* GPIOx,uint16_t GPIO_Pin);
uint8_t GPIO_ReadInputDataBit(GPIO_TypeDef* GPIOx, uint16_t GPIO_Pin);
void delay_ms(__IO uint32_t delay_ms);
void GPIOInit(void);

/* Functions ------------------------------------------------------------------*/

int main(void)
{
	SystemInit();	//Initializes system
	GPIOInit();		//Initializes GPIO
	
  while(1)
  {
		if(Key_Scan(GPIO0,GPIO_Pin_1)==KEY_ON)
		{
				for(int i = 0;i < N_BLINK;i++)
				{
					GPIO_ResetBit(GPIO0,GPIO_Pin_0);
					delay_ms(500);
					GPIO_SetBit(GPIO0,GPIO_Pin_0);
					delay_ms(500);
				}
		}
  }
}

//Initializes GPIO
void GPIOInit(void)
{
	GPIO_InitTypeDef GPIO_InitType;
	
	//gpio pin 0 led1
	GPIO_InitType.GPIO_Pin = GPIO_Pin_1;
	GPIO_InitType.GPIO_Mode = GPIO_Mode_OUT;//out
	GPIO_InitType.GPIO_Int = GPIO_Int_Disable;
	GPIO_Init(GPIO0,&GPIO_InitType);
	
	//gpio pin 15 key1
	GPIO_InitType.GPIO_Pin = GPIO_Pin_14;
	GPIO_InitType.GPIO_Mode = GPIO_Mode_IN;//in
	GPIO_Init(GPIO0,&GPIO_InitType);
	
	GPIO_ResetBit(GPIO0,GPIO_Pin_0);//light : low level
}

//Scan key status
uint8_t Key_Scan(GPIO_TypeDef* GPIOx,uint16_t GPIO_Pin)
{			
	//whether key is press
	if(GPIO_ReadInputDataBit(GPIOx,GPIO_Pin) == KEY_ON)  
	{	 
		//wait free key
		while(GPIO_ReadInputDataBit(GPIOx,GPIO_Pin) == KEY_ON);   
		return 	KEY_ON;	 
	}
	else
		return KEY_OFF;
}

uint8_t GPIO_ReadInputDataBit(GPIO_TypeDef* GPIOx, uint16_t GPIO_Pin)
{
  uint8_t bitstatus = 0x00; 
  
  if ((GPIOx->DATA & GPIO_Pin) != 0)
  {
    bitstatus = (uint8_t)1;
  }
  else
  {
    bitstatus = (uint8_t)0;
  }
  return bitstatus;
}

//delay ms
void delay_ms(__IO uint32_t delay_ms)
{
	for(delay_ms=(SystemCoreClock>>13)*delay_ms; delay_ms != 0; delay_ms--);
}
