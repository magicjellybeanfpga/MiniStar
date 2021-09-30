/*
 * **********************************************************************************************************
 *
 * 		Copyright (C) 2014-2021 Gowin Semiconductor Technology Co.,Ltd.
 * 		
 * @file        hyper_ram.c
 * @author	    Embedded Development Team
 * @version	    V1.x.x
 * @date        2021-01-01 09:00:00
 * @brief       This file contains all the functions prototypes for the HyperRAM firmware library.
 ***********************************************************************************************************
 */

 /* Includes ------------------------------------------------------------------*/
#include "hyper_ram.h"

/**
  * @brief Check HyperRAM hardware initialization status.
  */
uint32_t HPRAM_Check_Init_Status(void)
{
	//1 is done 0 is unready
	return HPRAM->INIT_DONE;
}

/**
  * @brief Set HyperRAM read/write mode.
  */
uint32_t HPRAM_Mode_Set(uint32_t mode)
{
	if(mode == 0 || mode == 1)
	{
		HPRAM->CMD = mode;
		return 0;
	}
	else
	{
		return 1; //error mode
	}
}

/**
  * @brief Set HyperRAM address, save data into this address.
  */
uint32_t HPRAM_Address_Set(uint32_t address)
{
	if(address < 0x20000)
	{
		HPRAM->ADDRESS = address;
		return 0;
	}
	else
	{
		//out of the range of the address
		return 1;
	}
}

/**
  * @brief Write data into HyperRAM buffer, 4 word is a cycle.
  */
uint32_t HPRAM_Write_Data_Buff(uint32_t *Buff,uint32_t address)
{
	HPRAM_Cmd_Unable();
	
	HPRAM->WR_DATA0 = Buff[0];
	HPRAM->WR_DATA1 = Buff[1];
	HPRAM->WR_DATA2 = Buff[2];
	HPRAM->WR_DATA3 = Buff[3];
	
	HPRAM_Address_Set(address);
	
	HPRAM_Mode_Set(WRITE_MODE);
	
	HPRAM_Cmd_Enable();
	
	return 1;
}

/**
  * @brief Read data from HyperRAM buffer.
  */
uint32_t HPRAM_Read_Data_Buff(uint32_t *Buff,uint32_t address)
{
	HPRAM_Cmd_Unable();
	
	HPRAM_Address_Set(address);
	
	HPRAM_Mode_Set(READ_MODE);
	
	HPRAM_Cmd_Enable();
	
	//wait response ready
	while((HPRAM_Read_Done_Flag() & 0x01) == 0);
	
	Buff[0] = HPRAM->RD_DATA0 ;
	Buff[1] = HPRAM->RD_DATA1 ;  
	Buff[2] = HPRAM->RD_DATA2 ;
	Buff[3] = HPRAM->RD_DATA3 ;
	
	//clear response
	HPRAM_Clear_Read_Done_Flag();

	return 1;
}

/**
  * @brief Enable HyperRAM command.
  */
void HPRAM_Cmd_Enable(void)
{
	HPRAM->CMD_EN = CMD_ENABLE;
}

/**
  * @brief Disable HyperRAM command.
  */
void HPRAM_Cmd_Unable(void)
{
	HPRAM->CMD_EN = CMD_UNABLE;
}

/**
  * @brief The flag of read HyperRAM done.
  */
uint32_t HPRAM_Read_Done_Flag(void)
{
	return HPRAM->READ_DONE; 
}

/**
  * @brief Clear the flag of read HyperRAM done.
  */
void HPRAM_Clear_Read_Done_Flag(void)
{
	HPRAM->READ_DONE = 0x00;
}

/**
  * @brief Write a package data into HyperRAM.
  *        The valid address bit is [20-0].
  */
uint32_t HPRAM_Write_Data_Package(uint32_t *Buff,uint32_t address,uint32_t num)
{
	uint32_t i;
	
	uint32_t temp_arry[4] = {0x00000000,0x00000000,0x00000000,0x00000000};
	uint32_t remainder = num & 0x03;//The hyper_ram data is align 4 word

	num = num & (~0x03);//bit invert
	
	//The address must align 8
	address = (address >> 3)<<3;

	//first send the 4 align word data
	//and the address is align 8
	for(i =0 ; i< num ; i= i+4)
	{
		HPRAM_Write_Data_Buff(&Buff[i],address + i*2);
	}
	
	//second deal with the remainder word
	if(remainder)
	{
		for(uint32_t j =0 ; j<remainder ; j++)
		{
			temp_arry[j] = *(&Buff[i] + j);
		}
	}
	
	HPRAM_Write_Data_Buff(temp_arry,address + i*2);
	
	return 1;
}

/**
  * @brief Read a package data from HyperRAM.
  *        In order to prevent the the arry overflow.
  */
uint32_t HPRAM_Read_Data_Package(uint32_t *Buff,uint32_t address,uint32_t num)
{
	uint32_t i;
	
	uint32_t temp_arry[4] = {0x00000000,0x00000000,0x00000000,0x00000000};
	uint32_t remainder = num & 0x03;//The hyper_ram data is align 4 word
	
	num = num & (~0x03);
	
	//The address must align 8
	address = (address >> 3)<<3;
	for(i =0 ; i< num ; i= i+4)
	{
		HPRAM_Read_Data_Buff(&Buff[i],address + i*2);
	}
	
	if(remainder)
	{
		HPRAM_Read_Data_Buff(temp_arry,address + i*2);
		
		for(uint32_t j =0 ; j<remainder ; j++)
		{
			//set remainder data
			*(&Buff[i] + j) = temp_arry[j];
		}
	}
	
	return 1;
}

/************************GowinSemiconductor******END OF FILE*******************/
