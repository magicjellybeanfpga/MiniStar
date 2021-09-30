
#ifndef __SPI_MASTER_H
#define __SPI_MASTER_H

#include "gw1ns4c.h"


//Initializes SPI
void SPI1_Init(void);

// 向SPI发送数据
void SPI_send_data(uint8_t data);

// 向SPI发送数据
uint8_t SPI_read_data(void);


#endif
