/*
 * ****************************************************************************************************
 *
 * 		Copyright (C) 2014-2021 Gowin Semiconductor Technology Co.,Ltd.
 * 		
 * @file        hyper_ram.h
 * @author	    Embedded Development Team
 * @version	    V1.x.x
 * @date        2021-01-01 09:00:00
 * @brief       This file contains all the functions prototypes for the HyperRAM firmware library.
 *****************************************************************************************************
 */

/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __AHB2_TOFPGA_H
#define __AHB2_TOFPGA_H

#ifdef __cplusplus
 extern "C" {
#endif

/* Includes ------------------------------------------------------------------*/
#include "gw1ns4c.h"

/* Definitions -------------------------------------------------------------------*/
//FPGA typedef definitons
typedef struct
{
	__O  unsigned int WR_EN;              	/* Offset: 0x00 (W ) WR_EN  register                */
	__O  unsigned int WR_DATA0;             /* Offset: 0x04 (W ) FIFO write data register 0           */

	__I  unsigned int RD_EN;              	/* Offset: 0x08 (R ) RD_EN  register                */
	__I  unsigned int RD_DATA_LEN;          /* Offset: 0x0C (R ) FIFO LEN read data register            */	
	__I  unsigned int RD_DATA0;             /* Offset: 0x10 (R ) FIFO read data register 0            */

	__I  unsigned int INIT_DONE;            /* Offset: 0x14 (R ) FPGA initialization status register  */
}FPGA_TypeDef;

//Address definitions
#define FPGA_BASE        AHB2PERIPH_BASE	/* !< FPGA Base Address     																*/

//Type definitions
#define FPGA             ((FPGA_TypeDef     *) FPGA_BASE)


/* Declarations ------------------------------------------------------------------*/
/**
  * @brief Check FPGA hardware initialization status.
  */
extern uint32_t FPGA_Check_Init_Status(void);

/**
  * @brief Read data from FPGA buffer.
  */
extern void AHB2_Read_Data_ToFPGA(uint8_t *Buff);

/**
  * @brief Read datalen from FPGA buffer.
  */
extern uint32_t AHB2_Read_Datalen_ToFPGA(void);

/**
  * @brief Write data into FPGA buffer
  */
extern void AHB2_Write_Data_ToFPGA(uint8_t Buff);



#ifdef __cplusplus
}
#endif

#endif /* HYPER_RAM_H */

/*************************GowinSemiconductor*****END OF FILE*********************/
