/*
 * MP3模块测试程序
 * 
 * 用途：MP3模块测试程序
 *       vs1003 的硬件测试程序，主控芯片为STC12LE5A60S2
 *       其他的微处理器(带SPI接口的)只需稍加修改即可适用
 *       对于不带硬SPI接口的微处理器可以用IO进行SPI的时序模拟
 * 
 * 作者					日期				备注
 * Huafeng Lin			20010/09/10			新增
 * Huafeng Lin			20010/09/10			修改
 * 
 */
 
#include "vs1003b.h" 
#include "MusicDataMP3.c"
#include "delay.h"
#include <stdio.h>









/**********************************************************/
/*  函数名称 :   MSPI_Init                                */
/*  函数功能 ： 初始化SPI接口，设置为主机。               */
/*  参数     :  无                                        */
/*  返回值   :  无                                        */
/*--------------------------------------------------------*/
void  MSPI_Init(void)
{  
/*
	PINSEL0 = (PINSEL0 & 0xFFFF00FF) | 0x00005500;	//选择 SPI 
        S0SPCCR = 0x08;		                        // SPI 时钟设置
 	S0SPCR  = (0 << 3) |				// CPHA = 0, 
 		  (0 << 4) |				// CPOL = 0, 
 		  (1 << 5) |				// MSTR = 1, 
 		  (0 << 6) |				// LSBF = 0, 
 	          (0 << 7);				// SPIE = 0, 
*/
	GPIO_InitTypeDef GPIO_InitType;
	
	GPIO_InitType.GPIO_Pin = MP3_XRESET;
	GPIO_InitType.GPIO_Mode = GPIO_Mode_OUT;
	GPIO_InitType.GPIO_Int = GPIO_Int_Disable;
	GPIO_Init(GPIO0,&GPIO_InitType);
  GPIO_SetBit(GPIO0,MP3_XRESET);
	
	GPIO_InitType.GPIO_Pin = MP3_XCS;
	GPIO_Init(GPIO0,&GPIO_InitType);
  GPIO_SetBit(GPIO0,MP3_XCS);	

	GPIO_InitType.GPIO_Pin = MP3_DREQ;
	GPIO_Init(GPIO0,&GPIO_InitType);
  GPIO_SetBit(GPIO0,MP3_DREQ);	
	
	GPIO_InitType.GPIO_Pin = MP3_XDCS;
	GPIO_Init(GPIO0,&GPIO_InitType);
  GPIO_SetBit(GPIO0,MP3_XDCS);		
	
	GPIO_InitType.GPIO_Pin = SPI_MISO;
	GPIO_Init(GPIO0,&GPIO_InitType);
  GPIO_SetBit(GPIO0,SPI_MISO);	

	GPIO_InitType.GPIO_Pin = SPI_MOSI;
	GPIO_Init(GPIO0,&GPIO_InitType);
  GPIO_SetBit(GPIO0,SPI_MOSI);

	GPIO_InitType.GPIO_Pin = SPI_CLK;
	GPIO_Init(GPIO0,&GPIO_InitType);
  GPIO_SetBit(GPIO0,SPI_CLK);

	Macro_Set_SO_High();
	Macro_DREQ_High();

}

/**********************************************************/
/*  函数名称 :  InitPortVS1003                            */
/*  函数功能 ： MCU与vs1003接口的初始化                   */
/*  参数     :  无                                        */
/*  返回值   :  无                                        */
/*--------------------------------------------------------*/
void  InitPortVS1003(void)
{
	MSPI_Init();//SPI口的初始化
//	IODIR &= 0xfffeffff;   //其他接口线的设置，其中dreq 为输入口
//	IODIR |= MP3_XRESET | MP3_XCS | MP3_XDCS;//xRESET，xCS，xDS均为输出口
//	IOSET |= MP3_XRESET | MP3_XCS | MP3_XDCS;//xRESET，xCS，xDS默认输出高电平	
	Macro_DREQ_High();		//置为输入

	Mp3ReleaseFromReset();
	Mp3DeselectControl();
	Mp3DeselectData();
}

//uint8_t SD_SPI_ReadByte(void);
//void SD_SPI_WriteByte(uint8_t ucSendData);

//#define SPI_RecByte()  SD_SPI_ReadByte()
//#define SPIPutChar(x) SD_SPI_WriteByte(x)

#if 1
/**********************************************************/
/*  函数名称 :  SPIPutChar                                */
/*  函数功能 ： 通过SPI发送一个字节的数据                 */
/*  参数     :  待发送的字节数据                          */
/*  返回值   :  无                                        */
/*--------------------------------------------------------*/
void  SPIPutChar(unsigned char ucSendData)
{      
//	S0SPDR = c;
//	while((S0SPSR & 0x80) == 0);	 //等待SPI将数据发送完毕
	uint8_t ucCount;
	uint8_t ucMaskCode;

	ucMaskCode = 0x80;
	for(ucCount=0; ucCount<8; ucCount++)
	{
		Macro_Set_CLK_Low();

		if(ucMaskCode & ucSendData)
		{
			Macro_Set_SI_High();
		}
		else
		{
			Macro_Set_SI_Low();
		}

		Macro_Set_CLK_High();
		ucMaskCode >>= 1;

	}
}

/*******************************************************************************************************************
** 函数名称: INT8U SPI_RecByte()				Name:	  INT8U SPI_RecByte()
** 功能描述: 从SPI接口接收一个字节				Function: receive a byte from SPI interface
** 输　  入: 无									Input:	  NULL
** 输 　 出: 收到的字节							Output:	  the byte that be received
********************************************************************************************************************/
static uint8_t SPI_RecByte(void)
{
	uint8_t ucReadData;
	uint8_t ucCount;

	ucReadData = 0;
	Macro_Set_SI_High();

	for(ucCount=0; ucCount<8; ucCount++)
	{
		ucReadData <<= 1;
			//降低时钟频率
		Macro_Set_CLK_Low();

	
		if(Macro_Read_SO()) 
		{
			ucReadData |= 0x01;
		}
		Macro_Set_CLK_High();

	}

	return(ucReadData);
}

#endif

/*************************************************************/
/*  函数名称 :  Mp3WriteRegister                             */
/*  函数功能 ： 写vs1003寄存器                               */
/*  参数     :  寄存器地址，待写数据的高8位，待写数据的低8位 */
/*  返回值   :  无                                           */
/*-----------------------------------------------------------*/
void Mp3WriteRegister(unsigned char addressbyte, unsigned char highbyte, unsigned char lowbyte)
{
	Mp3DeselectData();
	Mp3SelectControl();//XCS = 0
	SPIPutChar(VS_WRITE_COMMAND); //发送写寄存器命令
	SPIPutChar(addressbyte);      //发送寄存器的地址
	SPIPutChar(highbyte);         //发送待写数据的高8位
	SPIPutChar(lowbyte);          //发送待写数据的低8位
	Mp3DeselectControl();
}

/*************************************************************/
/*  函数名称 :  Mp3ReadRegister                              */
/*  函数功能 ： 写vs1003寄存器                               */
/*  参数     :  寄存器地址				     */
/*  返回值   :  vs1003的16位寄存器的值                       */
/*-----------------------------------------------------------*/
unsigned int Mp3ReadRegister(unsigned char addressbyte)
{
	unsigned int resultvalue = 0;
	uint8_t ucReadValue;

	Mp3DeselectData();
	Mp3SelectControl();//XCS = 0
	SPIPutChar(VS_READ_COMMAND); //发送读寄存器命令
	SPIPutChar((addressbyte));	 //发送寄存器的地址

//	SPIPutChar(0xff); 		//发送读时钟
//	resultvalue = (SPI_RESULT_BYTE) << 8;//读取高8位数据
	ucReadValue = SPI_RecByte();
	resultvalue = ucReadValue<<8;
//	SPIPutChar(0xff);		   //发送读时钟
//	resultvalue |= (SPI_RESULT_BYTE);  //读取低8位数据
	ucReadValue = SPI_RecByte();
	resultvalue |= ucReadValue;

	Mp3DeselectControl();              
	return resultvalue;                 //返回16位寄存器的值
}

/**********************************************************/
/*  函数名称 :  Mp3SoftReset                              */
/*  函数功能 ： vs1003软件复位                            */
/*  参数     :  无                                        */
/*  返回值   :  无                                        */
/*--------------------------------------------------------*/
void Mp3SoftReset(void)
{
	Mp3WriteRegister (SPI_MODE, 0x08, 0x04); //软件复位

	delay_ms(1); //延时1ms
	while (MP3_DREQ == 0); //等待软件复位结束
	printf("dreq = 0\r\n");
	Mp3WriteRegister(SPI_CLOCKF, 0x98, 0x00);//设置vs1003的时钟,3倍频
	Mp3WriteRegister (SPI_AUDATA, 0xBB, 0x81); //采样率48k，立体声
	Mp3WriteRegister(SPI_BASS, 0x00, 0x55);//设置重音
	Mp3SetVolume(10,10);//设置音量
    delay_ms(1); //延时1ms
    	
    	//向vs1003发送4个字节无效数据，用以启动SPI发送
   	Mp3SelectData();
	SPIPutChar(0);
	SPIPutChar(0);
	SPIPutChar(0);
	SPIPutChar(0);
	Mp3DeselectData();

}
/**********************************************************/
/*  函数名称 :  Mp3Reset                                  */
/*  函数功能 ： vs1003硬件复位                            */
/*  参数     :  无                                        */
/*  返回值   :  无                                        */
/*--------------------------------------------------------*/
void Mp3Reset(void)
{	
	Mp3PutInReset();//xReset = 0   复位vs1003      
	delay_ms(200);//延时100ms
	SPIPutChar(0xff);//发送一个字节的无效数据，启动SPI传输
	Mp3DeselectControl();   //xCS = 1
	Mp3DeselectData();     //xDCS = 1
	Mp3ReleaseFromReset(); //xRESET = 1
	delay_ms(200);            //延时100ms
	while (Macro_DREQ_Read() == 0);//等待DREQ为高
printf("DREQ init OK!\r\n");	
	
	delay_ms(200);            //延时100ms
 	Mp3SetVolume(50,50);  
	Mp3SoftReset();//vs1003软复位
}


uint8_t CheckVS1003B_DRQ(void)
{
	uint8_t bResult;

	bResult = Macro_DREQ_Read();
	return(bResult);
}

/***********************************************************/
/*  函数名称 :  VsSineTest                                 */
/*  函数功能 ： vs1003正弦测试，将该函数放在while循环中，  */
/*              如果能持续听到一高一低的声音，证明测试通过 */                            
/*  参数     :  无                                         */
/*  返回值   :  无                                         */
/*---------------------------------------------------------*/
void VsSineTest(void)
{
	Mp3PutInReset();  //xReset = 0   复位vs1003
	delay_ms(200);        //延时100ms        
	SPIPutChar(0xff);//发送一个字节的无效数据，启动SPI传输
	Mp3DeselectControl();  
	Mp3DeselectData();     
	Mp3ReleaseFromReset(); 
	delay_ms(200);	               
	Mp3SetVolume(50,50);  

 	Mp3WriteRegister(SPI_MODE,0x08,0x20);//进入vs1003的测试模式
	while (Macro_DREQ_Read() == 0);     //等待DREQ为高
 	Mp3SelectData();       //xDCS = 1，选择vs1003的数据接口
 	printf("sin wave test start\r\n");
 	//向vs1003发送正弦测试命令：0x53 0xef 0x6e n 0x00 0x00 0x00 0x00
 	//其中n = 0x24, 设定vs1003所产生的正弦波的频率值，具体计算方法见vs1003的datasheet
   	SPIPutChar(0x53);      
	SPIPutChar(0xef);      
	SPIPutChar(0x6e);      
	SPIPutChar(0x24);      
	SPIPutChar(0x00);      
	SPIPutChar(0x00);
	SPIPutChar(0x00);
	SPIPutChar(0x00);
//	delay_ms(500);
	delay_ms(250);
	delay_ms(250);
	Mp3DeselectData();//程序执行到这里后应该能从耳机听到一个单一频率的声音
  
        //退出正弦测试
	Mp3SelectData();
	SPIPutChar(0x45);
	SPIPutChar(0x78);
	SPIPutChar(0x69);
	SPIPutChar(0x74);
	SPIPutChar(0x00);
	SPIPutChar(0x00);
	SPIPutChar(0x00);
	SPIPutChar(0x00);
//	delay_ms(500);
	delay_ms(250);
	delay_ms(250);

	Mp3DeselectData();

        //再次进入正弦测试并设置n值为0x44，即将正弦波的频率设置为另外的值
    Mp3SelectData();       
	SPIPutChar(0x53);      
	SPIPutChar(0xef);      
	SPIPutChar(0x6e);      
	SPIPutChar(0x44);      
	SPIPutChar(0x00);      
	SPIPutChar(0x00);
	SPIPutChar(0x00);
	SPIPutChar(0x00);
//	delay_ms(500);
	delay_ms(250);
	delay_ms(250);

	Mp3DeselectData(); 

	//退出正弦测试
	Mp3SelectData();
	SPIPutChar(0x45);
	SPIPutChar(0x78);
	SPIPutChar(0x69);
	SPIPutChar(0x74);
	SPIPutChar(0x00);
	SPIPutChar(0x00);
	SPIPutChar(0x00);
	SPIPutChar(0x00);
//	delay_ms(500);
	delay_ms(250);
	delay_ms(250);
 	printf("sin wave test end\r\n");
	
	Mp3DeselectData();
 }

//写寄存器，参数，地址和数据
void VS1003B_WriteCMD(unsigned char addr, unsigned int dat)
{
/*
	VS1003B_XDCS_H();
	VS1003B_XCS_L();
	VS1003B_WriteByte(0x02);
	//delay_Nus(20);
	VS1003B_WriteByte(addr);
	VS1003B_WriteByte(dat>>8);
	VS1003B_WriteByte(dat);
	//delay_Nus(200);
	VS1003B_XCS_H();
*/
	Mp3WriteRegister(addr,dat>>8,dat);
}

//读寄存器，参数 地址 返回内容
unsigned int VS1003B_ReadCMD(unsigned char addr)
{
/*
	unsigned int temp;
	unsigned char temp1;
	VS1003B_XDCS_H();
	VS1003B_XCS_L();
	VS1003B_WriteByte(0x03);
	//delay_Nus(20);
	VS1003B_WriteByte(addr);
	temp=  VS1003B_ReadByte();
	temp=temp<<8;
	temp1= VS1003B_ReadByte();
	temp=temp|temp1;;
	VS1003B_XCS_H();
	return temp;
*/
	return(Mp3ReadRegister(addr));
}

//写数据，音乐数据
void VS1003B_WriteDAT(unsigned char dat)
{
//	VS1003B_XDCS_L();
//	VS1003B_WriteByte(dat);
//	VS1003B_XDCS_H();
//	VS1003B_XCS_H();

   	Mp3SelectData();
	SPIPutChar(dat);
	Mp3DeselectData();
	Mp3DeselectControl();

}

//开启环绕声
void VS1003B_SetVirtualSurroundOn(void)
{
	uint8_t ucRepeatCount;
	uint16_t uiModeValue;

	ucRepeatCount =0;

	while(1)//写时钟寄存器
	{
		uiModeValue = VS1003B_ReadCMD(0x00);
		if(uiModeValue & 0x0001)
		{
			break;
		}
		else
		{
			uiModeValue |= 0x0001;
			VS1003B_WriteCMD(0,uiModeValue);
		}
		ucRepeatCount++;
		if(ucRepeatCount++ >10 )break;
	}

}

//关闭环绕声
void VS1003B_SetVirtualSurroundOff(void)
{
	uint8_t ucRepeatCount;
	uint16_t uiModeValue;

	ucRepeatCount =0;

	while(1)//写时钟寄存器
	{
		uiModeValue = VS1003B_ReadCMD(0x00);
		if(uiModeValue & 0x0001)
		{
			break;
		}
		else
		{
			uiModeValue |= 0x0001;
			VS1003B_WriteCMD(0,uiModeValue);
		}
		ucRepeatCount++;
		if(ucRepeatCount++ >10 )break;
	}

}

//增强重音
//入口参数	1.强度0-15
//			2.频率0-15 (X10Hz)
void VS1003B_SetBassEnhance(uint8_t ucValue, uint16_t ucFrequencyID)
{
	uint8_t ucRepeatCount;
	uint16_t uiWriteValue;
	uint16_t uiReadValue;	

	ucRepeatCount =0;

	uiWriteValue = VS1003B_ReadCMD(0x02);

	uiWriteValue &= 0xFF00;
	uiWriteValue |= ucValue<<4;
	uiWriteValue &= (ucFrequencyID & 0x0F);

	while(1)//写时钟寄存器
	{

		VS1003B_WriteCMD(2,uiWriteValue);
		uiReadValue = VS1003B_ReadCMD(0x02);
		
		if(uiReadValue == uiWriteValue)
		{
			break;
		}
		ucRepeatCount++;
		if(ucRepeatCount++ >10 )break;
	}

}


 uint16_t uiVolumeCount;		//当前音量值

//VS1003初始化，0成功 1失败
unsigned char VS1003B_Init()
{
	unsigned char retry;
/*
	PORT_INI();
	DDRB|=0xa0;
	VS1003B_DDR &=~(1<<VS1003B_DREQ);
	//delay_Nus(50);
	VS1003B_XCS_H();
	VS1003B_XDCS_H();
	VS1003B_XRESET_L();
	VS1003B_Delay(0xffff);
	VS1003B_XRESET_H();//使能芯片
	VS1003B_SPI_Low();//先以低频操作
	VS1003B_Delay(0xffff);//延时
*/
Mp3Reset();

	retry=0;
	while(VS1003B_ReadCMD(0x00) != 0x0800)//写mode寄存器
	{
		VS1003B_WriteCMD(0x00,0x0800);
		if(retry++ >10 )break;//{PORTB|=_BV(PB1);break;}
	}
	retry=0;
	/*while(VS1003B_ReadCMD(0x02) != 0x75)//写mode寄存器
	{
		VS1003B_WriteCMD(0x02,0x75);
		if(retry++ >10 )break;//{PORTB|=_BV(PB1);break;}
	}*/
	retry=0;
	while(VS1003B_ReadCMD(0x03) != 0x9800)//写时钟寄存器
	{
		VS1003B_WriteCMD(0x03,0x9800);
		if(retry++ >10 )break;
	}
	retry=0;
//	while(VS1003B_ReadCMD(0x0b) != 0x1111)//设音量
//	{
//		VS1003B_WriteCMD(0x0b,0x1111);
//		if(retry++ >10 )break;
//	}
	while(VS1003B_ReadCMD(0x0b) != uiVolumeCount)//设音量
	{
		VS1003B_WriteCMD(0x0b,uiVolumeCount);
		if(retry++ >10 )break;
	}

//	VS1003B_SPI_High();//提高速度，全速运行
	if(retry > 10)return 1;
	return 0;
}

//VS1003软件复位
void VS1003B_SoftReset()
{
	VS1003B_WriteCMD(0x00,0x0804);//写复位
//	VS1003B_Delay(0xffff);//延时，至少1.35ms
	delay_ms(2);
}

void VS1003B_Fill2048Zero()
{
	unsigned char i,j;

	for(i=0;i<64;i++)
	{
		if(CheckVS1003B_DRQ())
		{
			Mp3SelectData();

			for(j=0;j<32;j++)
			{

				VS1003B_WriteDAT(0x00);
			}
			Mp3DeselectData();
		}
	}
}


void test_1003_PlayMP3File() 
{
  unsigned int data_pointer;unsigned char i;
	unsigned int uiCount;

	uiCount = sizeof(MusicData);
	
	data_pointer=0; 
	VS1003B_SoftReset();
	while(uiCount>0)
	{ 
		if(CheckVS1003B_DRQ())
		{
			for(i=0;i<32;i++)
			{
					VS1003B_WriteDAT(MusicData[data_pointer]);
					data_pointer++;
			}
		uiCount -= 32;
		}
	}
	VS1003B_Fill2048Zero();
}


// test
void TestVS1003B(void)
{
	Mp3Reset();
	VsSineTest();
	Mp3SoftReset();
	test_1003_PlayMP3File();
}


