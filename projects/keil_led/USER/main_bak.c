
/*
 * *****************************************************************************************
 *
 * 		Copyright (C) 2014-2019 Gowin Semiconductor Technology Co.,Ltd.
 * 		
 * @file			main.c
 * @author		Embedded Development Team
 * @version		V1.0.0
 * @date			2019-10-1 09:00:00
 * @brief			Main program body.
 ******************************************************************************************
 */

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

//led all on
void led_on()
{
	s = 0x0000;  //led: on
	GPIO0->DATAOUT = s;
	Delay(833300);
}

//led on one by one
void led_1()
{
	led_off();
		 
	for(i=0;i<8;i++)
	{
		s=s<<1;   //led: one bye one on
	  GPIO0->DATAOUT = s;
	  Delay(833300);
	}
}


//led all-on  then  all-off
void led_2()
{
	led_off();
	
	led_on();
}

//led one on one time
void led_3()
{
	
	led_off();

		 
	for(i=0;i<8;i++)
	{
		s=s<<1;   //led: one bye one on
	  GPIO0->DATAOUT = ~s;
	  Delay(833300);
	}
}

//led one on one time
void led_4()
{
	
	led_off();

		 
	for(i=0;i<8;i++)
	{
		s=s>>1;   //led: one bye one on
	  GPIO0->DATAOUT = ~s;
	  Delay(833300);
	}
}


void getkeyval()
{
	key1= (GPIO0->DATA >>4 ) & 0x0080;
	key2= (GPIO0->DATA >>4 ) & 0x0040;
	key3= (GPIO0->DATA >>4 ) & 0x0020;
	key4= (GPIO0->DATA >>4 ) & 0x0010;
}


unsigned char key_scan()
{
	getkeyval();
	if(key1==0 || key2==0 || key3==0 || key4==0)
	{
		Delay(833);
		getkeyval();
		if(key1==0) return 1;
		else if (key2==0) return 2;
		      else if(key3==0) return 3;
		           else if(key4==0) return 4;
		                else return 0;
	}	
	
}

int main(void)
{
  unsigned char key;
	
	SystemInit();
  
	//GPIO0->OUTENCLR = 0xffff;
  GPIO0->OUTENSET = 0x00ff;   //IO[15:8]: input   IO[7:0]: output 
	led_off();
	  Delay(833300);
	  Delay(833300);
	  Delay(833300);
	
	  led_3();
	  Delay(833300);
	  Delay(833300);
	  Delay(833300);
		
		led_off();
	  Delay(833300);
	  Delay(833300);
	  Delay(833300);
	
		while(1)
		{			
		//s=0xfff7;   //led: one bye one on
		getkeyval();
		/*s=GPIO0->DATA>>4;
		Delay(1000);
		s=GPIO0->DATA>>4;*/	
	  GPIO0->DATAOUT = ~key1;
    Delay(833300);
		}

		
	  GPIO0->DATAOUT = GPIO0->DATA >>8;
	  Delay(833300);
	  Delay(833300);
	  Delay(833300);
		
	while(1)
	{
     //key=key_scan();
		key1= GPIO0->DATA>>8;
		Delay(100);
		//	s = 0x00;  //led: on
	  GPIO0->DATAOUT = GPIO0->DATA>>8;
		Delay(100);
	  //Delay(833300);
		/*
		 switch(key)
		 {
			 case 1: led_1();break;
			 case 2: led_2();break;
			 case 3: led_3();break;
			 case 4: led_4();break;
			 default: led_off();break;
		 }
		Delay(833);*/
	}
  
}



