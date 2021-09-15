/*
 * **********************************************************************************************************
 *
 * 		Copyright (C) 2014-2021 Gowin Semiconductor Technology Co.,Ltd.
 * 		
 * @file        ahb2_tofpga.c
 * @author	    Embedded Development Team
 * @version	    V1.0.0
 * @date        2021-04-018 20:15:00
 * @brief       This file contains all the functions prototypes for the ahb2 to fpga firmware library.
 ***********************************************************************************************************
 */

 /* Includes ------------------------------------------------------------------*/
#include "ahb2_tofpga.h"


/**
  * @brief Check FPGA hardware initialization status.
  */
uint32_t FPGA_Check_Init_Status(void)
{
	//1 is done 0 is unready
	return FPGA->INIT_DONE;
}


/**
  * @brief Write data into FPGA buffer, 4 word is a cycle.
  */
void AHB2_Write_Data_ToFPGA(uint8_t Buff)
{
	FPGA->WR_DATA0 = Buff;
}


/**
  * @brief Read datalen from FPGA buffer.
  */
uint32_t AHB2_Read_Datalen_ToFPGA(void)
{
	uint32_t data_len = 0;
  data_len = FPGA->RD_DATA_LEN;

	return data_len;
}



/**
  * @brief Read data from FPGA buffer.
  */
void AHB2_Read_Data_ToFPGA(uint8_t *Buff)
{
	Buff[0] = FPGA->RD_DATA0 ;
}


/************************GowinSemiconductor******END OF FILE*******************/
