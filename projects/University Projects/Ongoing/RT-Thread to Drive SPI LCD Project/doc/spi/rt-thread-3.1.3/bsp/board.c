/*
 * Copyright (c) 2006-2019, RT-Thread Development Team
 *
 * SPDX-License-Identifier: Apache-2.0
 *
 * Change Logs:
 * Date           Author       Notes
 * 2017-07-24     Tanek        the first version
 * 2018-11-12     Ernest Chen  modify copyright
 */
 
#include <stdint.h>
#include <rthw.h>
#include <rtthread.h>

//#include "gd32f350r_eval.h"
#include "gw1ns4c.h"

#define _SCB_BASE       (0xE000E010UL)
#define _SYSTICK_CTRL   (*(rt_uint32_t *)(_SCB_BASE + 0x0))
#define _SYSTICK_LOAD   (*(rt_uint32_t *)(_SCB_BASE + 0x4))
#define _SYSTICK_VAL    (*(rt_uint32_t *)(_SCB_BASE + 0x8))
#define _SYSTICK_CALIB  (*(rt_uint32_t *)(_SCB_BASE + 0xC))
#define _SYSTICK_PRI    (*(rt_uint8_t  *)(0xE000ED23UL))

// Updates the variable SystemCoreClock and must be called 
// whenever the core clock is changed during program execution.
extern void SystemCoreClockUpdate(void);

// Holds the system core clock, which is the system clock 
// frequency supplied to the SysTick timer and the processor 
// core clock.
extern uint32_t SystemCoreClock;

static uint32_t _SysTick_Config(rt_uint32_t ticks)
{
    if ((ticks - 1) > 0xFFFFFF)
    {
        return 1;
    }
    
    _SYSTICK_LOAD = ticks - 1; 
    _SYSTICK_PRI = 0xFF;
    _SYSTICK_VAL  = 0;
    _SYSTICK_CTRL = 0x07;  
    
    return 0;
}

#if defined(RT_USING_USER_MAIN) && defined(RT_USING_HEAP)
#define RT_HEAP_SIZE 1024
static uint32_t rt_heap[RT_HEAP_SIZE];     // heap default size: 4K(1024 * 4)
RT_WEAK void *rt_heap_begin_get(void)
{
    return rt_heap;
}

RT_WEAK void *rt_heap_end_get(void)
{
    return rt_heap + RT_HEAP_SIZE;
}
#endif
extern void UartInit(void);
/**
 * This function will initial your board.
 */
void rt_hw_board_init()
{
    /* System Clock Update */
    //SystemCoreClockUpdate();
    SystemInit();
    /* System Tick Configuration */
    _SysTick_Config(SystemCoreClock / RT_TICK_PER_SECOND);
	UartInit();
	//gd_eval_com_init(EVAL_COM);

    /* Call components board initial (use INIT_BOARD_EXPORT()) */
#ifdef RT_USING_COMPONENTS_INIT
    rt_components_board_init();
#endif

#if defined(RT_USING_USER_MAIN) && defined(RT_USING_HEAP)
    rt_system_heap_init(rt_heap_begin_get(), rt_heap_end_get());
#endif
}

void SysTick_Handler(void)
{
    /* enter interrupt */
    rt_interrupt_enter();

    rt_tick_increase();

    /* leave interrupt */
    rt_interrupt_leave();
}

void rt_hw_console_output(const char *str)
{
    rt_size_t i = 0, size = 0;
    char a = '\r';

    //__HAL_UNLOCK(&huart1);

    size = rt_strlen(str);
    for (i = 0; i < size; i++)
    {
        if (*(str + i) == '\n')
        {
            //HAL_UART_Transmit(&huart1, (uint8_t *)&a, 1, 1);
			UART_SendChar(UART0,(uint8_t)a);
			//while(RESET == usart_flag_get(EVAL_COM, USART_FLAG_TBE));
        }
        //HAL_UART_Transmit(&huart1, (uint8_t *)(str + i), 1, 1);
		UART_SendChar(UART0, (uint8_t)(*(str + i)));
		//while(RESET == usart_flag_get(EVAL_COM, USART_FLAG_TBE));
    }
}
#if 0
char rt_hw_console_getchar(void)
{
    /* note: ch default value < 0 */
    int ch = -1;

//    if (__HAL_UART_GET_FLAG(&huart1, UART_FLAG_RXNE) != RESET)
//    {
//        ch = huart1.Instance->RDR & 0xff;
//    }
	if (RESET != usart_flag_get(EVAL_COM, USART_FLAG_RBNE)){
        /* receive data */
        //ch = usart_data_receive(EVAL_COM);
        ch = (uint16_t)(GET_BITS(USART_RDATA(EVAL_COM), 0U, 8U));
		//if (rx_count >= rx_buffer_size){
            //usart_interrupt_disable(EVAL_COM, USART_INT_RBNE);
        //}
    }
    else
    {
        rt_thread_mdelay(10);
    }
    return ch;
}
#endif
