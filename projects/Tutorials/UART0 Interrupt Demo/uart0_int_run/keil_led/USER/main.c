
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
void Uart0Init(void);


void Delay(__IO uint32_t nCount)//25M 1s = 8333000
{
	for(; nCount != 0; nCount--);
}

int main(void)
{
	//char i;
	
	SystemInit();
	NVIC_PriorityGroupConfig(NVIC_PriorityGroup_3);
	GPIOInit();
	Uart0Init();
	
	
	UART_SendChar(UART0, '4');
	
	while(1)
	; 
}


//Initializes GPIO
void GPIOInit(void)
{
	GPIO_InitTypeDef GPIO_InitType;
	
	GPIO_InitType.GPIO_Pin = GPIO_Pin_0;
	GPIO_InitType.GPIO_Mode = GPIO_Mode_OUT;
	GPIO_InitType.GPIO_Int = GPIO_Int_Disable;

	GPIO_Init(GPIO0,&GPIO_InitType);

  GPIO_SetBit(GPIO0,GPIO_Pin_0);
}



//Initialized UART0
void Uart0Init(void)
{
  UART_InitTypeDef UART_InitStruct;
	NVIC_InitTypeDef InitTypeDef_NVIC;
	
	//uart0 
  UART_InitStruct.UART_Mode.UARTMode_Tx = ENABLE;
  UART_InitStruct.UART_Mode.UARTMode_Rx = ENABLE;
  UART_InitStruct.UART_Int.UARTInt_Tx = DISABLE;
  UART_InitStruct.UART_Int.UARTInt_Rx = ENABLE;//Enable UART0 RX interrupt register
  UART_InitStruct.UART_Ovr.UARTOvr_Tx = DISABLE;
  UART_InitStruct.UART_Ovr.UARTOvr_Rx = DISABLE;
  UART_InitStruct.UART_Hstm = DISABLE;
  UART_InitStruct.UART_BaudRate = 115200;//Baud Rate
	
  UART_Init(UART0,&UART_InitStruct);
	
	
	
  //NVIC: Enable UART0 interrupt handler
	InitTypeDef_NVIC.NVIC_IRQChannel = UART0_IRQn;
  InitTypeDef_NVIC.NVIC_IRQChannelPreemptionPriority = 1;
  InitTypeDef_NVIC.NVIC_IRQChannelSubPriority = 1;
  InitTypeDef_NVIC.NVIC_IRQChannelCmd = ENABLE;
  NVIC_Init(&InitTypeDef_NVIC);
}
