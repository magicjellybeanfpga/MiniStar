
/* Includes ------------------------------------------------------------------*/
#include "gw1ns4c.h"
#include "gw1ns4c_conf.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>


void Delay(__IO uint32_t nCount)//25M 1s = 8333000
{
	for(; nCount != 0; nCount--);
}

void disp0_9()
{
		 GPIO0->DATAOUT = 0xf8c0;      //0
   	 Delay(833300);
	   Delay(833300);
	

	   GPIO0->DATAOUT = 0xf4f9;      //1
	   Delay(833300);
	   Delay(833300);

	   GPIO0->DATAOUT = 0xf2a4;      //2 
	   Delay(833300);
	   Delay(833300);
	
	   GPIO0->DATAOUT = 0xf1b0;     //3
	   Delay(833300);
	   Delay(833300);
	
	   GPIO0->DATAOUT = 0xf899;     //4  
	   Delay(833300);
	   Delay(833300);

	   GPIO0->DATAOUT = 0xf492;     //5  
	   Delay(833300);
	   Delay(833300);
	
		 GPIO0->DATAOUT = 0xf282;     //6
	   Delay(833300);
	   Delay(833300);
	
	   GPIO0->DATAOUT = 0xf1f8;     //7  
	   Delay(833300);
	   Delay(833300);

	   GPIO0->DATAOUT = 0xf880;     //8  
	   Delay(833300);
	   Delay(833300);

	   GPIO0->DATAOUT = 0xf490;     //9  
	   Delay(833300);
	   Delay(833300);
		 
		 GPIO0->DATAOUT = 0xf2c0;      //0 
	   Delay(833300);
	   Delay(833300);

	   GPIO0->DATAOUT = 0xf180;      //8  
	   Delay(833300);
	   Delay(833300);
}



int main(void)
{
	unsigned int segcode[]={0xffc0,0xfff9,0xffa4,0xffb0,     //0
	                        0xfff9,0xfff9,0xffa4,0xffb0,     //1
	                        0xffa4,0xff90,0xff80,0xff90,     //2
	                        0xffb0,0xff90,0xff80,0xff90,     //3
		                      0xff99,0xff92,0xff82,0xfff8,     //4
		                      0xff92,0xff92,0xff82,0xfff8,     //5
		                      0xff82,0xff90,0xff80,0xff90,     //6
		                      0xfff8,0xff90,0xff80,0xff90,     //7
		                      0xff80,0xff90,0xff80,0xff90,     //8
		                      0xff90,0xff80,0xff90,0xff90      //9
	                       };   

	/*
	unsigned char segcode[]={0xc0,0xf9,0xa4,0xb0,     //0,1,2,3
		                       0xc0,0xf9,0xa4,0xb0,     //cannot read
		                       0xc0,0xf9,0xa4,0xb0,
		                       0xc0,0xf9,0xa4,0xb0,
		                       0x99,0x92,0x82,0xf8,     //4,5,6,7
		                       0x99,0x92,0x82,0xf8,
		                       0x99,0x92,0x82,0xf8,
		                       0x99,0x92,0x82,0xf8,
		                       0x80,0x90,0x80,0x90     //8,9,8,9	
	                       }; */ 												 
		

	unsigned char i;
	unsigned int s;
	
	SystemInit();

  GPIO0->OUTENSET = 0xffff;   //IO[15:8]: output   IO[7:0]: output 
	
		while(1)
		{	
		 disp0_9();
			
		 for(i=0;i<40;i++)
    {			
		 s=	segcode[i] | 0xff00;		
     GPIO0->DATAOUT = s;       
	   Delay(833300);
	   //Delay(833300);	
		}
			
		}	 
  
}



