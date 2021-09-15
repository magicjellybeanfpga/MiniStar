/*
 * *****************************************************************************************
 *
 * 		Copyright (C) 2014-2021 Gowin Semiconductor Technology Co.,Ltd.
 * 		
 * @file      main.c
 * @author    Embedded Development Team
 * @version   V1.x.x
 * @date      2021-01-01 09:00:00
 * @brief     Main function.
 ******************************************************************************************
 */

/* Includes ------------------------------------------------------------------*/
#include <stdio.h>
#include "gw1ns4c.h"
#include "ahb2_tofpga.h"
#include "vs10xx.h" 
#include "delay.h"
#include "spi_master.h"

#include "music.h"   // mp3

//Initializes UART0
void Uart0_Init(void)
{
  UART_InitTypeDef UART_InitStruct;
	
  UART_InitStruct.UART_Mode.UARTMode_Tx = ENABLE;
  UART_InitStruct.UART_Mode.UARTMode_Rx = ENABLE;
  UART_InitStruct.UART_Int.UARTInt_Tx = DISABLE;
  UART_InitStruct.UART_Int.UARTInt_Rx = DISABLE;
  UART_InitStruct.UART_Ovr.UARTOvr_Tx = DISABLE;
  UART_InitStruct.UART_Ovr.UARTOvr_Rx = DISABLE;
  UART_InitStruct.UART_Hstm = DISABLE;
  UART_InitStruct.UART_BaudRate = 115200;//Baud Rate
	
  UART_Init(UART0,&UART_InitStruct);
}




//Initializes GPIO
void GPIO0_Init(void)
{
	GPIO_InitTypeDef GPIO_InitType;
	
	GPIO_InitType.GPIO_Pin = GPIO_Pin_0;
	GPIO_InitType.GPIO_Mode = GPIO_Mode_OUT;
	GPIO_InitType.GPIO_Int = GPIO_Int_Disable;
	GPIO_Init(GPIO0,&GPIO_InitType);
	
  GPIO_SetBit(GPIO0,GPIO_Pin_0);
}

//Initializes SPI
void SPIInit(void)
{
	SPI_InitTypeDef init_spi;
	
  init_spi.CLKSEL= CLKSEL_CLK_DIV_8;		//36MHZ / 8
  init_spi.DIRECTION = ENABLE;					//MSB First
  init_spi.PHASE =DISABLE;							//ENABLE;//posedge
  init_spi.POLARITY =ENABLE;						//polarity 1
	
  SPI_Init(&init_spi);
}



/* Functions ------------------------------------------------------------------*/
int main()
{	
	// 存放MP3数据长度
//	uint32_t mp3_fifo_datalen = 0;
		uint16_t i = 0;  
	
	SystemInit();	//Initializes system
	Uart0_Init();	//Initializes UART0
	GPIO0_Init();	//Initializes GPIO

	
	printf("\r\n---------------------------------------------------------------------\r\n");
	printf("       GowinSemiconductor Gowin_EMPU(GW1NS-4C) HyperRAM Application      \r\n");
	printf("---------------------------------------------------------------------\r\n\r\n");
	
	printf("System Initialized Successfully!\r\n");
	printf("UART0 Initialized Successfully!\r\n");
	
	//Check and wait HyperRAM initialization finished
	while(FPGA_Check_Init_Status() != 1);
	
	printf("FPGA Initialized Successfully!\r\n");	
	
#if 0	
	//Write data into HyperRAM
	printf("\r\nWrite Data Into HyprRAM : \r\n");
	for(uint32_t i = 0; i < TEST_NUM; i = i+8)
	{
		for(uint16_t j = 0; j < 4; j++)
		{
			temp[j] = data_tmp++;
			
			printf("The Address 0x%x : Write Data %d.\r\n",i+j,temp[j]);
		}
		
		HPRAM_Write_Data_Buff(temp,i);
	}
	
	//Read Data From HyperRAM
	printf("\r\nRead Data From HyperRAM : \r\n");
	for(uint32_t i = 0; i < TEST_NUM; i = i+8)
	{
		HPRAM_Read_Data_Buff(rec_temp,i);
		
		for(uint16_t j = 0; j < 4; j++)
		{
			printf("The Address 0x%x : Read Data %d.\r\n",i+j,rec_temp[j]);
		}
	}
#endif	
	printf("\r\nGowin_EMPU(GW1NS-4C) HyperRAM Application Finished!\r\n");
	
	
#if 1 
	VS_Init();  //	初始化VS1003	
	VS_Set_All();	//	设置音量等 
	VS_HD_Reset();		   	//硬复位
//	VS_Soft_Reset();  		//软复位 
	
	printf("Chip ID:%d\r\n",VS_Ram_Test()); //	打印芯片ID
	VS_Sine_Test();	//	正弦测试
	VS_SPI_SpeedHigh();//高速,对VS1003B,最大值不能超过36.864/4Mhz，这里设置为9M	
		do{
				if(VS_Send_MusicData((uint8_t*) &music[i]) == 0)   //	发送MP3数据到芯片
				{
					i += 32;
					printf("send mp3 data!\r\n");
					delay_ms(5);  //	延时  这时可以做其他事情
				}	
		}while(i < 1024);
#else
	SPIInit();
  SPI_Select_Slave(0x01) ;	//Select The SPI Slave	
  SPI_WriteData(0x9F);			//Send Jedec
		while(1);
		{
		#if 0
			//if(~SPI_GetToeStatus() && SPI_GetTrdyStatus() == 1)
			//{
			//		SPI_WriteData(0x55);//Send Jedec
			//}
			//VS_SPI_WriteByte(0X55);
			printf("dq = %d\r\n",VS_DQ());
			delay_ms(1000);
			
			
		#else
			do{
				if(VS_Send_MusicData((uint8_t*) &music[i]) == 0)   //	发送MP3数据到芯片
				{
					i += 32;
					//printf("send mp3 data!\r\n");
					delay_ms(5);  //	延时  这时可以做其他事情
				}	
			}while(i < 1024);
		#endif
			
		}
#endif	
	while(1)
	{
		// 音频数据大于32字节
		//if(AHB2_Read_Datalen_ToFPGA() >= 32)
		//{
		
		//} 


		// send data to FPGA
//		AHB2_Write_Data_ToFPGA(0x00);
		GPIO_SetBit(GPIO0,GPIO_Pin_0);
		delay_ms(500);
		
		// send data to FPGA
//		AHB2_Write_Data_ToFPGA(0x01);
		GPIO_ResetBit(GPIO0,GPIO_Pin_0);
		//delay_ms(500);
		delay_ms(500);
	}
	
	return 0;
}

