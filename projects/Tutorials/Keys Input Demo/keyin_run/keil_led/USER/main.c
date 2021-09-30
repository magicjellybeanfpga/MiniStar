
/* Includes ------------------------------------------------------------------*/
#include "gw1ns4c.h"
#include "gw1ns4c_conf.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

unsigned int s,i;
unsigned int key1=0xffff,key2=0xffff,key3=0xffff,key4=0xffff;

void Delay(__IO uint32_t nCount)//25M 1s = 8333000
{
	for(; nCount != 0; nCount--);
}

//led all off
void led_off()
{
	s = 0xffff;  //led: off
	GPIO0->DATAOUT = s;
	Delay(833300);
}


//led on one by one
void led_1()
{
	s = 0xffff;  //led: off
	GPIO0->DATAOUT = s;
	Delay(833300);
		 
	for(i=0;i<8;i++)
	{
		s=s<<1;   //led: one bye one on
	  GPIO0->DATAOUT = s;
	  Delay(833300);
	}
}


int main(void)
{
	SystemInit();

  GPIO0->OUTENSET = 0x00ff;   //IO[15:8]: input   IO[7:0]: output 
	
	  led_1();	
	  Delay(833300);
	  Delay(833300);
	  Delay(833300);
		
		led_off();
	  Delay(833300);
	  Delay(833300);
	  Delay(833300);
	
		while(1)
		{				
		key1= (GPIO0->DATA >>4 ) | 0xff7f;		
	  GPIO0->DATAOUT = key1;			
    Delay(1000);

		key2= (GPIO0->DATA >>4 ) | 0xffbf;		
	  GPIO0->DATAOUT = key2;			
    Delay(1000);

		key3= (GPIO0->DATA >>4 ) | 0xffdf;		
	  GPIO0->DATAOUT = key3;			
    Delay(1000);

		key4= (GPIO0->DATA >>4 ) | 0xffef;		
	  GPIO0->DATAOUT = key4;			
    Delay(1000);			
			
		}	 
  
}



