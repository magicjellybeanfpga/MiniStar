//Copyright (C)2014-2021 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: Template file for instantiation
//GOWIN Version: V1.9.7.02Beta
//Part Number: GW1NSR-LV4CQN48PC6/I5
//Device: GW1NSR-4C
//Created Time: Fri May 14 19:19:08 2021

//Change the instance name and port connections to the signal names
//--------Copy here to design--------

    doge_rom your_instance_name(
        .dout(dout_o), //output [15:0] dout
        .clk(clk_i), //input clk
        .oce(oce_i), //input oce
        .ce(ce_i), //input ce
        .reset(reset_i), //input reset
        .ad(ad_i) //input [11:0] ad
    );

//--------Copy end-------------------
