
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
//	uint16_t  segcode[]={0xffc0,0xff99,0xff92,0xff82,     //0
//	                        0xfff9,0xfff9,0xffa4,0xffb0,     //1
//	                        0xffa4,0xff90,0xff80,0xff90,     //2
//	                        0xffb0,0xff90,0xff80,0xff90,     //3
//		                      0xff99,0xff92,0xff82,0xfff8,     //4
//		                      0xff92,0xff92,0xff82,0xfff8,     //5
//		                      0xff82,0xff90,0xff80,0xff90,     //6
//		                      0xfff8,0xff90,0xff80,0xff90,     //7
//		                      0xff80,0xff90,0xff80,0xff90,     //8
//		                      0xff90,0xff80,0xff90,0xff90      //9
//	                       };   
	uint16_t a[] = {0xff99,0xffc0,0xff82,0xff90};


	unsigned char segcode[]={0xc0,0xf9,0xa4,0xb0,     //0,1,2,3
		                       0xc0,0xf9,0xa4,0xb0,     //cannot read
		                       0xc0,0xf9,0xa4,0xb0,
		                       0xc0,0xf9,0xa4,0xb0,
		                       0x99,0x92,0x82,0xf8,     //4,5,6,7
		                       0x99,0x92,0x82,0xf8,
		                       0x99,0x92,0x82,0xf8,
		                       0x99,0x92,0x82,0xf8,
		                       0x80,0x90,0x80,0x90     //8,9,8,9	
	                       };  												 
		

	unsigned char i;
	unsigned int s,key1,key2,key3,key4;
  unsigned char sw1,sw2,sw3,sw4;
	
	SystemInit();
												 
//	GPIO0->OUTENSET = 0x0fff; 	

//	while(1)
//	{
//		s = (GPIO0->DATA) & 0x4000;
//		GPIO0->DATAOUT = (s>>8) | 0x0f00; 
//		Delay(833300);
//	}		

  GPIO0->OUTENSET = 0x0fff;    //IO[15:12]: input for sw1-4  IO[11:0]: output  for 7seg1-4
//test1
//	while(1)
//	{
//		  s = (GPIO0->DATA>>4) & 0xff00;
//		  GPIO0->DATAOUT = s; 
//		  Delay(1000);
//		  GPIO0->DATAOUT = s | 0xf000;
//	}		
		
//test2												 
		key1=0;	
		key2=0;	
    key3=0;	
    key4=0;													 
		while(1)
		{	
			GPIO0->DATAOUT = s | 0xf000;
			sw1= (GPIO0->DATA>>8) & 0x80;     
			sw2= (GPIO0->DATA>>8) & 0x40;
			sw3= (GPIO0->DATA>>8) & 0x20;
			sw4= (GPIO0->DATA>>8) & 0x10;
			
			if(sw1!=0) key1= 0x08;			
			else key1= 0x00;
			
			if(sw2!=0) key2= 0x04;
			else key2= 0x00;
			
			if(sw3!=0) key3= 0x02;
			else key3= 0x00;
			
			if(sw4!=0) key4= 0x01;
			else key4= 0x00;
			
			
		 s=	(key1<<8) | 0x00f9;			 //1	
     GPIO0->DATAOUT = s;       
	   Delay(833300);
	   //Delay(833300);	
			
		s=	(key2<<8) | 0x00a4;			 //2	
     GPIO0->DATAOUT = s;       
	   Delay(833300);
	   //Delay(833300);		
			
		s=	(key3<<8) | 0x00b0;			 //3	
     GPIO0->DATAOUT = s;       
	   Delay(833300);
	   //Delay(833300);

		s=	(key4<<8) | 0x0099;			 //4	
     GPIO0->DATAOUT = s;       
	   Delay(833300);
	  // Delay(833300);
		 
		}	 
  
}



