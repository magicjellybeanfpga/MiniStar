
#include "delay.h"

//delay ms
void delay_ms(__IO uint32_t delay_ms)
{
	for(delay_ms=(SystemCoreClock>>13)*delay_ms; delay_ms != 0; delay_ms--);
}


