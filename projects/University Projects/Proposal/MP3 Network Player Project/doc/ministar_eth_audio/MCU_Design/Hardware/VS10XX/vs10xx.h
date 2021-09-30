#ifndef __VS10XX_H__
#define __VS10XX_H__
#include "gw1ns4c.h"
#include "gpio.h"


//////////////////////////////////////////////////////////////
//与外部的接口

//#define VS_DQ       P0in(15)  	//DREQ 
//#define VS_RST      P0out(13) 	//RST
//#define VS_XDCS     P0out(14)  	//XDCS 

#define VS_DQ() 	GPIO_ReadInputDataBit(GPIO0, GPIO_Pin_15)

//XDCS
#define VS_XDCS(x)  if(x)  \
											GPIO_SetBit(GPIO0, GPIO_Pin_12); \
										else 		\
											GPIO_ResetBit(GPIO0, GPIO_Pin_12); 	

//RST
#define VS_RST(x)  if(x)  \
											GPIO_SetBit(GPIO0, GPIO_Pin_13); \
										else 		\
											GPIO_ResetBit(GPIO0, GPIO_Pin_13); 	
										
										


//////////////////////////////////////////////////////////////

__packed typedef struct 
{							  
	uint8_t mvol;		//主音量,范围:0~254
	uint8_t bflimit;		//低音频率限定,范围:2~15(单位:10Hz)
	uint8_t bass;		//低音,范围:0~15.0表示关闭.(单位:1dB)
	uint8_t tflimit;		//高音频率限定,范围:1~15(单位:Khz)
	uint8_t treble;		//高音,范围:0~15(单位:1.5dB)(原本范围是:-8~7,通过函数修改了);
	uint8_t effect;		//空间效果设置.0,关闭;1,最小;2,中等;3,最大.

	uint8_t saveflag; 	//保存标志,0X0A,保存过了;其他,还从未保存	   
}_vs10xx_obj;


extern _vs10xx_obj vsset;		//VS10XX设置

#define VS_WRITE_COMMAND 	0x02
#define VS_READ_COMMAND 	0x03
//VS10XX寄存器定义
#define SPI_MODE        	0x00   
#define SPI_STATUS      	0x01   
#define SPI_BASS        	0x02   
#define SPI_CLOCKF      	0x03   
#define SPI_DECODE_TIME 	0x04   
#define SPI_AUDATA      	0x05   
#define SPI_WRAM        	0x06   
#define SPI_WRAMADDR    	0x07   
#define SPI_HDAT0       	0x08   
#define SPI_HDAT1       	0x09 
  
#define SPI_AIADDR      	0x0a   
#define SPI_VOL         	0x0b   
#define SPI_AICTRL0     	0x0c   
#define SPI_AICTRL1     	0x0d   
#define SPI_AICTRL2     	0x0e   
#define SPI_AICTRL3     	0x0f   
#define SM_DIFF         	0x01   
#define SM_JUMP         	0x02   
#define SM_RESET        	0x04   
#define SM_OUTOFWAV     	0x08   
#define SM_PDOWN        	0x10   
#define SM_TESTS        	0x20   
#define SM_STREAM       	0x40   
#define SM_PLUSV        	0x80   
#define SM_DACT         	0x100   
#define SM_SDIORD       	0x200   
#define SM_SDISHARE     	0x400   
#define SM_SDINEW       	0x800   
#define SM_ADPCM        	0x1000   
#define SM_ADPCM_HP     	0x2000 		 

#define I2S_CONFIG			0XC040
#define GPIO_DDR			0XC017
#define GPIO_IDATA			0XC018
#define GPIO_ODATA			0XC019



uint16_t  VS_RD_Reg(uint8_t address);				//读寄存器
uint16_t  VS_WRAM_Read(uint16_t addr);	    	//读RAM
void VS_WRAM_Write(uint16_t addr,uint16_t val);	//写RAM
void VS_WR_Data(uint8_t data);				//写数据
void VS_WR_Cmd(uint8_t address,uint16_t data);	//写命令
uint8_t   VS_HD_Reset(void);			    	//硬复位
void VS_Soft_Reset(void);           	//软复位
uint16_t VS_Ram_Test(void);             		//RAM测试	    
void VS_Sine_Test(void);            	//正弦测试
													 
void 	 VS_SPI_WriteByte(uint8_t data);
uint8_t 	 VS_SPI_ReadByte(void);

void VS_SPI_SpeedLow(void);
void VS_SPI_SpeedHigh(void);
void VS_Init(void);						//初始化VS10XX	 
void VS_Set_Speed(uint8_t t);				//设置播放速度
uint16_t  VS_Get_HeadInfo(void);     		//得到比特率
uint32_t VS_Get_ByteRate(void);				//得到字节速率
uint16_t VS_Get_EndFillByte(void);			//得到填充字节
uint8_t 	 VS_Send_MusicData(uint8_t* buf);		//向VS10XX发送32字节
uint8_t VS_Send_Nbyte_MusicData(uint8_t* buf,uint16_t len);	//	发送指定长度 MP3数据


void VS_Restart_Play(void);				//重新开始下一首歌播放	  
void VS_Reset_DecodeTime(void);			//重设解码时间
uint16_t  VS_Get_DecodeTime(void);   		//得到解码时间

void VS_Load_Patch(uint16_t *patch,uint16_t len);	//加载用户patch
uint8_t 	 VS_Get_Spec(uint16_t *p);       		//得到分析数据	   
void VS_Set_Bands(uint16_t *buf,uint8_t bands);	//设置中心频率
void VS_Set_Vol(uint8_t volx);				//设置主音量   
void VS_Set_Bass(uint8_t bfreq,uint8_t bass,uint8_t tfreq,uint8_t treble);//设置高低音
void VS_Set_Effect(uint8_t eft);				//设置音效
void VS_SPK_Set(uint8_t sw);					//板载喇叭输出开关控制
void VS_Set_All(void);

void vs10xx_read_para(_vs10xx_obj * vs10xxdev);
void vs10xx_save_para(_vs10xx_obj * vs10xxdev);

#endif

















