//Copyright (C)2014-2021 GOWIN Semiconductor Corporation.
//All rights reserved.
//File Title: Timing Constraints file
//GOWIN Version: 1.9.7.03 Beta
//Created Time: 2021-04-28 03:02:47
set_false_path -from [get_ports {rstn}] 
create_clock -name midclk -period 8 [get_pins {osc_inst/OSCOUT}]
create_clock -name spiclk2x -period 3.75 [get_pins {mul1/pllvr_inst/CLKOUT}]
create_clock -name spiclk -period 7.5 [get_pins {mul1/pllvr_inst/CLKOUTD}]
//create_generated_clock -name cpuclk -source [get_pins {mul1/pllvr_inst/CLKOUT}] -master_clock spiclk -divide_by 2 [get_regs {spi_clk_free}]
// 3.75+delay=6 (multicycle)
//set_input_delay -clock spiclk 2.25 -max [get_ports {spi_IO[0] spi_IO[1] spi_IO[2] spi_IO[3]}]
//set_input_delay -clock spiclk 1.2 -min [get_ports {spi_IO[0] spi_IO[1] spi_IO[2] spi_IO[3]}]
set_multicycle_path -from [get_ports {spi_IO[0] spi_IO[1] spi_IO[2] spi_IO[3]}] -to [get_clocks {spiclk}]  -setup -end 2
set_false_path -from [get_ports {adubs_MC1 adbus_MC0 adbus_AD[7] adbus_AD[6] adbus_AD[5] adbus_AD[4] adbus_AD[3] adbus_AD[2] adbus_AD[1] adbus_AD[0]}] 