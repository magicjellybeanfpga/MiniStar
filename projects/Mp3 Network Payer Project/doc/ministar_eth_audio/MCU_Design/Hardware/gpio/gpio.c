

#include "gpio.h"

uint8_t GPIO_ReadInputDataBit(GPIO_TypeDef* GPIOx, uint16_t GPIO_Pin)
{
  uint8_t bitstatus = 0x00; 
  
  if ((GPIOx->DATA & GPIO_Pin) != 0)
  {
    bitstatus = (uint8_t)1;
  }
  else
  {
    bitstatus = (uint8_t)0;
  }
  return bitstatus;
}
