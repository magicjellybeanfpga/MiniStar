#ifndef __SYS_H
#define __SYS_H	
#include "gw1ns4c.h"


															    
	 
//位带操作,实现51类似的GPIO控制功能
//具体实现思想,参考<<CM3权威指南>>第五章(87页~92页).
//IO口操作宏定义
#define BITBAND(addr, bitnum) ((addr & 0xF0000000)+0x2000000+((addr &0xFFFFF)<<5)+(bitnum<<2)) 
#define MEM_ADDR(addr)  *((volatile unsigned long  *)(addr)) 
#define BIT_ADDR(addr, bitnum)   MEM_ADDR(BITBAND(addr, bitnum)) 
//IO口地址映射
#define GPIO0_ODR_Addr    (GPIO0_BASE+12) //0x4001080C 
   
#define GPIO0_IDR_Addr    (GPIO0_BASE+8) //0x40010808 

 
//IO口操作,只对单一的IO口!
//确保n的值小于16!
#define P0out(n)   BIT_ADDR(GPIO0_ODR_Addr,n)  //输出 
#define P0in(n)    BIT_ADDR(GPIO0_IDR_Addr,n)  //输入 


//以下为汇编函数
void WFI_SET(void);		//执行WFI指令
void INTX_DISABLE(void);//关闭所有中断
void INTX_ENABLE(void);	//开启所有中断
void MSR_MSP(uint32_t addr);	//设置堆栈地址

#endif
