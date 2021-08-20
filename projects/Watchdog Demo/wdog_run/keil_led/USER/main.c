
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
void Timer0Init(void);

//unsigned char flag;
//unsigned int  dio;

void Delay(__IO uint32_t nCount)//25M 1s = 8333000
{
	for(; nCount != 0; nCount--);
}

/* Watchdog initialization */
void watchdog_init(unsigned int cycle, int type)
{
  //puts   ("  Unlocking watchdog...");
  WDOG_UnlockWriteAccess();

  WDOG_RestartCounter(cycle);
  if (type==0)
  {
    //puts   ("  Set to no action");
    WDOG->CTRL = 0;
  }
  else if (type==1)
  {
    //puts   ("  Set to NMI generation");
    WDOG_SetIntEnable();
  }
  else
  {
    //puts   ("  Set to reset generation");
    WDOG_SetResetEnable();
    WDOG_SetIntEnable();
  }

  //puts   ("  Locking watchdog...");
  WDOG_LockWriteAccess();
}

int main(void)
{
	SystemInit();
	NVIC_PriorityGroupConfig(NVIC_PriorityGroup_3);	
	GPIOInit();
	
	//Timer0Init();	
	
	GPIO_SetBit(GPIO0,GPIO_Pin_0);  //off
	//whether this is watchdog reset
	if ((SYSCON_GetRstinfoWdogresetreq()) !=0)
	{
		GPIO_ResetBit(GPIO0,GPIO_Pin_0); //on
		SYSCON->RSTINFO = SYSCON_RSTINFO_WDOGRESETREQ;//clear flag
	}
	else
	{
		GPIO_SetBit(GPIO0,GPIO_Pin_0);   //off
	}
	
	GPIO_SetBit(GPIO0,GPIO_Pin_1);   //off
	watchdog_init(99999999,2); //open watchdog timer
	while(1)
	{
		if( 0x0000 == (GPIO0->DATA & 0x8000)   )   //GPIO[15]==0
		{
			GPIO_ResetBit(GPIO0,GPIO_Pin_1);  //on
			Delay(3333000);
			GPIO_SetBit(GPIO0,GPIO_Pin_1);   //off
			watchdog_init(99999999,2);      //feed wdog
			while(0x0000 == (GPIO0->DATA & 0x8000));
		} 
	}
}


//Initializes GPIO
void GPIOInit(void)
{
//	GPIO_InitTypeDef GPIO_InitType;
//	
//	GPIO_InitType.GPIO_Pin = GPIO_Pin_0;
//	GPIO_InitType.GPIO_Mode = GPIO_Mode_OUT;
//	GPIO_InitType.GPIO_Int = GPIO_Int_Disable;
//	GPIO_Init(GPIO0,&GPIO_InitType);

	GPIO0->OUTENSET = 0x00ff;       //IO[15:8]: input   IO[7:0]: output
	
  
	
}






