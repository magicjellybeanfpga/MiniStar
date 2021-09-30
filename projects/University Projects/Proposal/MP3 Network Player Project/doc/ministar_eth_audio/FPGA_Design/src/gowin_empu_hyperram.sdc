//Copyright (C)2014-2021 GOWIN Semiconductor Corporation.
//All rights reserved.
//File Title: Timing Constraints file
//GOWIN Version: 1.9.7.02 Beta
//Created Time: 2021-05-02 15:45:09
//create_clock -name clk_144m -period 6.944 -waveform {0 3.472} [get_nets {clk_144M}]
create_clock -name sys_clk27m -period 37.037 -waveform {0 18.518} [get_ports {sys_clk}]
create_clock -name mii_txclk -period 40 -waveform {0 20} [get_ports {eth_tx_clk}]
create_clock -name mii_rxclk -period 40 -waveform {0 20} [get_ports {eth_rx_clk}]
