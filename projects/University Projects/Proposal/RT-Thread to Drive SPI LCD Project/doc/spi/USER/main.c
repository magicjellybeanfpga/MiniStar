
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

#include "lcd.h"
#include "gui.h"
#include "test.h"
#include "stdio.h"

/* Includes ------------------------------------------------------------------*/
void SPIInit(void);
void GPIOInit(void);
void UartInit(void);
void delay_ms(__IO uint32_t delay_ms);

/* Functions ------------------------------------------------------------------*/
int main(void)
{
  //SystemInit();		//Initializes system
	GPIOInit();
	//UartInit();
	printf("strat run\r\n");
	SPIInit();			//Initializes SPI
	
	LCD_Init();
	printf("lcd init done\r\n");
	for(int i=0;i<5;i++)
	{
		GPIO_ResetBit(GPIO0,GPIO_Pin_3);	//LED1 on
			delay_ms(500);
			
		GPIO_SetBit(GPIO0,GPIO_Pin_3);		//LED1 off
			delay_ms(500);
		printf("test led done\r\n");
	}
	
//  SPI_Select_Slave(0x01) ;	//Select The SPI Slave	
//  SPI_WriteData(0x9F);			//Send Jedec
  while(1)
  {
	  #if 0
		if(~SPI_GetToeStatus() && SPI_GetTrdyStatus() == 1)
		{
			  SPI_WriteData(0x9F);//Send Jedec
		}
		
		if(~SPI_GetRoeStatus() && SPI_GetRrdyStatus() == 1)
		{
			  UART_SendChar(UART0,SPI_ReadData());
		}
	  #endif
	main_test(); 		//²âÊÔÖ÷½çÃæ
	Test_Color();  		//¼òµ¥Ë¢ÆÁÌî³ä²âÊÔ
	Test_FillRec();		//GUI¾ØÐÎ»æÍ¼²âÊÔ
	Test_Circle(); 		//GUI»­Ô²²âÊÔ
	Test_Triangle();    //GUIÈý½ÇÐÎ»æÍ¼²âÊÔ
	English_Font_test();//Ó¢ÎÄ×ÖÌåÊ¾Àý²âÊÔ
	Chinese_Font_test();//ÖÐÎÄ×ÖÌåÊ¾Àý²âÊÔ
	Pic_test();			//Í¼Æ¬ÏÔÊ¾Ê¾Àý²âÊÔ
	Rotate_Test();   //Ðý×ªÏÔÊ¾²âÊÔ
	  printf("running\r\n");
  }  
}

//Initializes SPI
void SPIInit(void)
{
	SPI_InitTypeDef init_spi;
	
  init_spi.CLKSEL= CLKSEL_CLK_DIV_2;		//13.5MHZ / 8
  init_spi.DIRECTION = DISABLE;					//MSB First
  init_spi.PHASE =DISABLE;							//ENABLE;//posedge
  init_spi.POLARITY =DISABLE;						//polarity 0
	
  SPI_Init(&init_spi);
}

void delay_ms(__IO uint32_t delay_ms)
{
	for(delay_ms=(SystemCoreClock>>13)*delay_ms; delay_ms != 0; delay_ms--);
}

//Initializes GPIO
void GPIOInit(void)
{
	GPIO_InitTypeDef GPIO_InitType;
	//P0.0
	GPIO_InitType.GPIO_Pin = GPIO_Pin_0;
	GPIO_InitType.GPIO_Mode = GPIO_Mode_OUT;
	GPIO_InitType.GPIO_Int = GPIO_Int_Disable;

	GPIO_Init(GPIO0,&GPIO_InitType);

  GPIO_SetBit(GPIO0,GPIO_Pin_0);
	
	//P0.1
	GPIO_InitType.GPIO_Pin = GPIO_Pin_1;
	GPIO_InitType.GPIO_Mode = GPIO_Mode_OUT;
	GPIO_InitType.GPIO_Int = GPIO_Int_Disable;

	GPIO_Init(GPIO0,&GPIO_InitType);

  GPIO_SetBit(GPIO0,GPIO_Pin_1);
	
	//P0.2
	GPIO_InitType.GPIO_Pin = GPIO_Pin_2;
	GPIO_InitType.GPIO_Mode = GPIO_Mode_OUT;
	GPIO_InitType.GPIO_Int = GPIO_Int_Disable;

	GPIO_Init(GPIO0,&GPIO_InitType);

  GPIO_SetBit(GPIO0,GPIO_Pin_2);
  	//P0.3
  	GPIO_InitType.GPIO_Pin = GPIO_Pin_3;
	GPIO_InitType.GPIO_Mode = GPIO_Mode_OUT;
	GPIO_InitType.GPIO_Int = GPIO_Int_Disable;

	GPIO_Init(GPIO0,&GPIO_InitType);

  GPIO_SetBit(GPIO0,GPIO_Pin_3);
  
    	//P0.4
  	GPIO_InitType.GPIO_Pin = GPIO_Pin_4;
	GPIO_InitType.GPIO_Mode = GPIO_Mode_OUT;
	GPIO_InitType.GPIO_Int = GPIO_Int_Disable;

	GPIO_Init(GPIO0,&GPIO_InitType);

  GPIO_SetBit(GPIO0,GPIO_Pin_4);
}

//Initializes UART0
void UartInit(void)
{
  UART_InitTypeDef UART_InitStruct;
	
  UART_InitStruct.UART_Mode.UARTMode_Tx = ENABLE;
  UART_InitStruct.UART_Mode.UARTMode_Rx = ENABLE;
  UART_InitStruct.UART_Int.UARTInt_Tx = DISABLE;
  UART_InitStruct.UART_Int.UARTInt_Rx = DISABLE;
  UART_InitStruct.UART_Ovr.UARTOvr_Tx = DISABLE;
  UART_InitStruct.UART_Ovr.UARTOvr_Rx = DISABLE;
  UART_InitStruct.UART_Hstm = DISABLE;
  UART_InitStruct.UART_BaudRate = 9600;//Baud Rate
	
  UART_Init(UART0,&UART_InitStruct);
}
