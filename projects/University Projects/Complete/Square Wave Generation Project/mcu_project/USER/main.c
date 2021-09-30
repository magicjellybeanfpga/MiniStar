#include "gw1ns4c.h"
#include "oled.h"

const uint32_t reduce_freq[] = {1,10,100,1000,10000,100000,1000000};

void GPIOInit(void)
{
	GPIO_InitTypeDef GPIO_InitType;
	
	GPIO_InitType.GPIO_Pin = GPIO_Pin_0|GPIO_Pin_1;
	GPIO_InitType.GPIO_Mode = GPIO_Mode_OUT;
	GPIO_InitType.GPIO_Int = GPIO_Int_Disable;
	GPIO_Init(GPIO0,&GPIO_InitType);

	GPIO_SetBit(GPIO0,GPIO_Pin_0);
	GPIO_SetBit(GPIO0,GPIO_Pin_1);
	
	GPIO_InitType.GPIO_Pin = GPIO_Pin_2|GPIO_Pin_3|GPIO_Pin_4;
	GPIO_InitType.GPIO_Mode = GPIO_Mode_IN;
	GPIO_InitType.GPIO_Int = GPIO_Int_Disable;
	GPIO_Init(GPIO0,&GPIO_InitType);
	GPIO_SetBit(GPIO0,GPIO_Pin_2);
	GPIO_SetBit(GPIO0,GPIO_Pin_3);
	GPIO_SetBit(GPIO0,GPIO_Pin_4);
}

void delay_ms(__IO uint32_t delay_ms)
{
	for(delay_ms=(SystemCoreClock>>13)*delay_ms; delay_ms != 0; delay_ms--);
}

int main(void)
{
	uint32_t freq = 0; //频率
	uint8_t place = 0; //选中
	
	SystemInit();
	GPIOInit();
	
	OLED_Init();			//初始化OLED  
	OLED_Clear(); 

	while(1)
	{
		if((GPIO_ReadBits(GPIO0)&GPIO_Pin_2) == 0)
		{
			delay_ms(20);
			while((GPIO_ReadBits(GPIO0)&GPIO_Pin_2) == 0){}
			
			freq += reduce_freq[place];
		
		}
		if((GPIO_ReadBits(GPIO0)&GPIO_Pin_3) == 0)
		{
			delay_ms(20);
			while((GPIO_ReadBits(GPIO0)&GPIO_Pin_3) == 0){}
			if(freq > reduce_freq[place])
				freq -= reduce_freq[place];
			else
				freq = 0;
		
		}
		if((GPIO_ReadBits(GPIO0)&GPIO_Pin_4) == 0)
		{
			delay_ms(20);
			while((GPIO_ReadBits(GPIO0)&GPIO_Pin_4) == 0);
			
			place++;
			if(place > 7)
				place = 0;
		}
		
		*((uint32_t *)0xA0000000) = freq*159.0728628148148148;  //把频率给fpga

		{
			OLED_ShowChar(16+8*0, 3, '0'+freq/10000000%10, place==7?1:0);
			OLED_ShowChar(16+8*1, 3, '0'+freq/1000000%10, place==6?1:0);
			OLED_ShowChar(16+8*2, 3, ',',0);
			OLED_ShowChar(16+8*3, 3, '0'+freq/100000%10, place==5?1:0);
			OLED_ShowChar(16+8*4, 3, '0'+freq/10000%10, place==4?1:0);
			OLED_ShowChar(16+8*5, 3, '0'+freq/1000%10, place==3?1:0);
			OLED_ShowChar(16+8*6, 3, ',',0);
			OLED_ShowChar(16+8*7, 3, '0'+freq/100%10, place==2?1:0);
			OLED_ShowChar(16+8*8, 3, '0'+freq/10%10, place==1?1:0);
			OLED_ShowChar(16+8*9, 3, '0'+freq/1%10, place==0?1:0);
			OLED_ShowChar(16+8*10, 3 ,'H',0);
			OLED_ShowChar(16+8*11, 3 ,'z',0);
		}
	}
}


