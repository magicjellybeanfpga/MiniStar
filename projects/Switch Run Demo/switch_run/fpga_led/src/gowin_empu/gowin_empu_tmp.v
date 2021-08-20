//Copyright (C)2014-2020 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: Template file for instantiation
//GOWIN Version: GowinSynthesis V1.9.7Beta
//Part Number: GW1NSR-LV4CQN48GC7/I6
//Device: GW1NSR-4C
//Created Time: Fri May 14 08:12:19 2021

//Change the instance name and port connections to the signal names
//--------Copy here to design--------

	Gowin_EMPU_Top your_instance_name(
		.sys_clk(sys_clk_i), //input sys_clk
		.gpio(gpio_io), //inout [15:0] gpio
		.reset_n(reset_n_i) //input reset_n
	);

//--------Copy end-------------------
