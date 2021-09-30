/*
 * *****************************************************************************************
 *
 * 		Copyright (C) 2014-2019 Gowin Semiconductor Technology Co.,Ltd.
 * 		
 * @file        gw1ns4c_rtc.c
 * @author	    Embedded Development Team
 * @version	    V1.0.0
 * @date        2019-10-1 09:00:00
 * @brief       This file contains all the functions prototypes for the RTC firmware library.
 ******************************************************************************************
 */

 /* Includes ------------------------------------------------------------------*/
#include "gw1ns4c_rtc.h"

volatile uint8_t RealTime_Hour;
volatile uint8_t RealTime_Minute;
volatile uint8_t RealTime_Second;
volatile uint8_t Update_Time;

//THE CLOCK OF RTC is 1HZ
uint32_t Get_Current_Value(void)
{
	return RTC->RTC_CURRENT_DATA;
}

void Set_Match_Value(uint32_t match_value)
{
	RTC->RTC_MATCH_VALUE =match_value;
}

uint32_t Get_Match_Value(void)
{
	return RTC->RTC_MATCH_VALUE;
}

void Set_Load_Value(uint32_t load_value)
{
	RTC->RTC_LOAD_VALUE = load_value;
}

uint32_t Get_Load_Value(void)
{
	return RTC->RTC_LOAD_VALUE;
}

void Start_RTC(void)
{
	RTC->RTC_CTROLLER_REG =0x01;
}

void Close_RTC(void)
{
	RTC->RTC_CTROLLER_REG =0x00;
}

uint8_t Get_RTC_Control_value(void)
{
	return RTC->RTC_CTROLLER_REG;
}

void RTC_Inter_Mask_Set(void)
{
	RTC->RTC_IMSC = 0x01;
}

void RTC_Inter_Mask_Clr(void)//MASK Interrupt FLAG
{
	RTC->RTC_IMSC = 0x00;
}

uint8_t Get_RTC_Inter_Mask_value(void)
{
	return RTC->RTC_IMSC;
}

void Clear_RTC_interrupt(void)
{
	RTC->RTC_INTR_CLEAR = 0x01;
}

void RTC_init(void)
{
	Set_Match_Value(30);
	Set_Load_Value(10);
	RTC_Inter_Mask_Set();
	Start_RTC();
}

void Set_RealTime(uint8_t hour, uint8_t minute, uint8_t second){
	RealTime_Hour = hour;
	RealTime_Minute = minute;
	RealTime_Second = second;
}

void Count_RealTime(void){
	Clear_RTC_interrupt();
	if(RealTime_Second == 59) {
		RealTime_Second = 0;
		if(RealTime_Minute == 59) {
			RealTime_Minute = 0;
			if(RealTime_Hour == 23)
				RealTime_Hour = 0;
			else
				RealTime_Hour++;
		}
		else
			RealTime_Minute++;
	}
	else
		RealTime_Second++;
	Set_Load_Value(0);
}

/************************GowinSemiconductor******END OF FILE*******************/
