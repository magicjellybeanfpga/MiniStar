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
#ifndef HYPER_RAM_H
#define HYPER_RAM_H

#ifdef __cplusplus
 extern "C" {
#endif

/* Includes ------------------------------------------------------------------*/
#include "gw1ns4c.h"

/* Definitions -------------------------------------------------------------------*/
//HyperRAM typedef definitons
typedef struct
{
	__IO unsigned int CMD;                  /* Offset: 0x00 (R/W) HyperRAM command register                */
	__IO unsigned int ADDRESS;              /* Offset: 0x04 (R/W) HyperRAM address register                */
	__IO unsigned int WR_DATA0;             /* Offset: 0x08 (R/W) HyperRAM write data register 0           */
	__IO unsigned int WR_DATA1;             /* Offset: 0x0C (R/W) HyperRAM write data register 1           */
	__IO unsigned int WR_DATA2;             /* Offset: 0x10 (R/W) HyperRAM write data register 2           */
	__IO unsigned int WR_DATA3;             /* Offset: 0x14 (R/W) HyperRAM write data register 3           */
	__O  unsigned int CMD_EN;               /* Offset: 0x18 ( /W) HyperRAM command enable register         */
	__IO unsigned int READ_DONE;            /* Offset: 0x1C (R/W) HyperRAM read status register            */
	__I  unsigned int RD_DATA0;             /* Offset: 0x20 (R/ ) HyperRAM read data register 0            */
	__I  unsigned int RD_DATA1;             /* Offset: 0x24 (R/ ) HyperRAM read data register 1            */
	__I  unsigned int RD_DATA2;             /* Offset: 0x28 (R/ ) HyperRAM read data register 2            */
	__I  unsigned int RD_DATA3;             /* Offset: 0x2C (R/ ) HyperRAM read data register 3            */
	__I  unsigned int INIT_DONE;            /* Offset: 0x30 (R/ ) HyperRAM initialization status register  */
}HPRAM_TypeDef;

//Address definitions
#define HPRAM_BASE        AHB2PERIPH_BASE	/* !< HyperRAM Base Address     																*/

//Type definitions
#define HPRAM             ((HPRAM_TypeDef     *) HPRAM_BASE)

/* Macros --------------------------------------------------------------------*/
#define WRITE_MODE 1    /* Write mode      */
#define READ_MODE  0    /* Read mode       */
#define CMD_ENABLE 1    /* Enable command  */
#define CMD_UNABLE 0    /* Disable command */

/* Declarations ------------------------------------------------------------------*/
/**
  * @brief Check HyperRAM hardware initialization status.
  */
extern uint32_t HPRAM_Check_Init_Status(void);

/**
  * @brief Set HyperRAM read/write mode.
  */
extern uint32_t HPRAM_Mode_Set(uint32_t mode);

/**
  * @brief Set HyperRAM address, save data into this address.
  */
extern uint32_t HPRAM_Address_Set(uint32_t address);

/**
  * @brief Read data from HyperRAM buffer.
  */
extern uint32_t HPRAM_Read_Data_Buff(uint32_t *Buff,uint32_t address);

/**
  * @brief Enable HyperRAM command.
  */
extern void HPRAM_Cmd_Enable(void);

/**
  * @brief The flag of read HyperRAM done.
  */
extern uint32_t HPRAM_Read_Done_Flag(void);

/**
  * @brief Clear the flag of read HyperRAM done.
  */
extern void HPRAM_Clear_Read_Done_Flag(void);

/**
  * @brief Write data into HyperRAM buffer, 4 word is a cycle.
  */
extern uint32_t HPRAM_Write_Data_Buff(uint32_t *Buff,uint32_t address);

/**
  * @brief Disable HyperRAM command.
  */
extern void HPRAM_Cmd_Unable(void);

/**
  * @brief Write a package data into HyperRAM.
  */
extern uint32_t HPRAM_Write_Data_Package(uint32_t *Buff,uint32_t address,uint32_t num);

/**
  * @brief Read a package data from HyperRAM.
  */
extern uint32_t HPRAM_Read_Data_Package(uint32_t *Buff,uint32_t address,uint32_t num);

#ifdef __cplusplus
}
#endif

#endif /* HYPER_RAM_H */

/*************************GowinSemiconductor*****END OF FILE*********************/
