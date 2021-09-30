# HDMI Display Engine IP Project

By: Zhexiong Huang

## Project Design

Gowin GW1NSR-4C has the following features compared to similar products.

1. Integrated Cortex-M3 hardcore with clock frequency up to 80MHz and various interactions with FPGA, which can support high data transfer.

2. Integrated HyperRAM with 64Mbits, theoretical transfer speed up to 166MHz*8Bits*2=333MB/s, ideal for high bandwidth data storage such as images.

3. True LVDS with clock frequency up to 400MHz and 4 pairs of TX/RX in QFN48 package, which can transfer 720p@60Hz video.

In order to take advantage of the GW1NSR-4C as much as possible, I design a display engine that supports HDMI output, which can write the output image to HyperRAM by software and output the image through HDMI in the FPGA.

Display Engine IP diagram is as shown below, and it is mounted on the AHB-Lite bus, with the functions of image storage and video output.

<img src="/projects/University Projects/Ongoing/HDMI Display Engine IP Project/pic/pic (1).png" width= "400">

It can be seen that the structure includes Processing System (PS) and Programming Logic (PL).

MCU is provided by Gowin _EMPU_Top, with the following configuration. 

* Cortex-M3 (EMCU primitive)
* 32KB Flash
* 16KB SRAM (using 8 Block RAMs)
* TARGEXP0 bus (0xA0000000-0xA000FFFF, AHB-Lite, 64KB total) 

HDMI Display Engine is configured via AHB-Lite bus with the following functions.

* AHB Slave InteRFace is used to interact with the AHB bus host and can configure the Display Engine using the register.
* DispRAM Controller is used for HyperRAM data transfer, which can be written by MCU and read by VGA Controller.
* VGA Controller is used to output video in VGA timing, which is provided to Gowin DVI_TX to convert to the format supported by HDMI.
* VGA Clock Generator is used to generate the clocks for VGA and HDMI, where the HDMI clock needs to be 5 times the pixel clock.

Gowin IP Cores used by HDMI Display Engine includes:

* Synchronous and asynchronous FIFO: provides continuous transmission support for DispRAM; provides conversion of clock domain and bit width.
* HyperRAM Controller: controls HyperRAM data read/write.
* PLL and CLKDIV: PLL is used to generate the clock for VGA, and CLKDIV
is used to generate the divide-by-five clock for DVI_TX.
* DVI_TX: converts the display signal from VGA timing to DVI, which is the HDMI signal.

After implementing the above functions, you can then store the display data on the MCU side to HyperRAM and output by HDMI. Due to the high bandwidth of HyperRAM, it can achieve 720p@60Hz transmission without lag.
