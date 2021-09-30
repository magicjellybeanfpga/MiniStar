

#include "spi_master.h"
#include "delay.h"

//Initializes SPI
void SPI1_Init(void)
{
	SPI_InitTypeDef init_spi;
	
  init_spi.CLKSEL= CLKSEL_CLK_DIV_8;		//36MHZ / 8
  init_spi.DIRECTION = ENABLE;					//MSB First
  init_spi.PHASE =	ENABLE;							//ENABLE;//posedge
  init_spi.POLARITY =ENABLE;						//polarity 1

  SPI_Init(&init_spi);
	SPI_Select_Slave(0x01) ;	//Select The SPI Slave
//	SPI_WriteData(0xFF);			//Start Transmission
}



// 向SPI发送数据
void SPI_send_data(uint8_t data)
{
	// 传输没有溢出 传输准备好时才能发送数据
	if(~SPI_GetToeStatus() && SPI_GetTrdyStatus() == 1)
	{
			SPI_WriteData(data);//Send Jedec
	}	
}

// 向SPI发送数据
uint8_t SPI_read_data(void)
{
	uint8_t rxdata = 0;
	
	// 传输没有溢出 传输准备好时才能发送数据
	if(~SPI_GetRoeStatus() && SPI_GetRrdyStatus() == 1)
	{
			rxdata = SPI_ReadData();
	}
	return rxdata;
}

