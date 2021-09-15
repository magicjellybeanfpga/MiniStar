//Copyright (C)2014-2021 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: Template file for instantiation
//GOWIN Version: GowinSynthesis V1.9.7.06Beta
//Part Number: GW1NSR-LV4CQN48PC7/I6
//Device: GW1NSR-4C
//Created Time: Tue Jun 22 13:47:47 2021

//Change the instance name and port connections to the signal names
//--------Copy here to design--------

	Gowin_EMPU_Top your_instance_name(
		.sys_clk(sys_clk_i), //input sys_clk
		.gpio(gpio_io), //inout [15:0] gpio
		.uart0_rxd(uart0_rxd_i), //input uart0_rxd
		.uart0_txd(uart0_txd_o), //output uart0_txd
		.mosi(mosi_o), //output mosi
		.miso(miso_i), //input miso
		.sclk(sclk_o), //output sclk
		.nss(nss_o), //output nss
		.reset_n(reset_n_i) //input reset_n
	);

//--------Copy end-------------------
