
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

void Delay(__IO uint32_t nCount)//25M 1s = 8333000
{
	for(; nCount != 0; nCount--);
}

int main(void)
{
	SystemInit();
	
	unsigned char s,i;
  GPIO0->OUTENSET = 0xffffffff;
	s = 0xff;
	//while(1);
	while(1)
	{
		 	s = 0xff;
		  GPIO0->DATAOUT = s;
		  Delay(833300);
		 
		  for(i=0;i<8;i++)
		 {
			 s=s<<1;
			GPIO0->DATAOUT = s;
			Delay(833300);
		 }
	}


  
  
}





/*
while(1)
  {
    GPIO_SetBit(GPIO0,GPIO_Pin_1|GPIO_Pin_2|GPIO_Pin_3);
    GPIO_ResetBit(GPIO0,GPIO_Pin_0);
    //GPIO0->DATAOUT = 0x1e;
    

    GPIO_SetBit(GPIO0,GPIO_Pin_0|GPIO_Pin_2|GPIO_Pin_3);
    GPIO_ResetBit(GPIO0,GPIO_Pin_1);
    //GPIO0->DATAOUT = 0xd;
    Delay(8333000);
    GPIO_SetBit(GPIO0,GPIO_Pin_1|GPIO_Pin_0|GPIO_Pin_3);
    GPIO_ResetBit(GPIO0,GPIO_Pin_2);
    //GPIO0->DATAOUT = 0x1b;
    Delay(8333000);
    GPIO_SetBit(GPIO0,GPIO_Pin_1|GPIO_Pin_2|GPIO_Pin_0);
    GPIO_ResetBit(GPIO0,GPIO_Pin_3);
    //GPIO0->DATAOUT = 0x7;
    Delay(8333000);  
}*/