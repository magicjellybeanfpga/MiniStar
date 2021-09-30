### LED Demo

You will learn how to use GPIO as the output by this demo. You can write code to control the eight LEDs LED1 (D1) ~ LED8 (D8) on the board to blink one by one.

<img src="/projects/Tutorials/Led Demo/led_run/pic/board pic (1).png" width= "400">


This demo introduction includes four parts:

1. GPIO Introduction
2. Hardware Design
3. Software Design
4. Download and Verification


## GPIO Introduction

Gowin GW1NSR-LV4CQN48P is used as the platform in this demo. From DS861, GW1NSR series of FPGA Products Datasheet, you can learn the GPIO module and know there is a Cortex-M3 RISC embedded in this chip. The key to this demo is how to control the GPIO as the output. The design information listed below is excerpted from the datasheet.

<img src="/projects/Tutorials/Led Demo/led_run/pic/soc (2).png" width= "400">

The following table lists GPIO registers.

<img src="/projects/Tutorials/Led Demo/led_run/pic/register (3).png" width= "400">

## Hardware Design

<img src="/projects/Tutorials/Led Demo/led_run/pic/hardware design (4).png" width= "400">

Figure 4 FPGA Pins

In Figure 2, one end of the LED is connected to the power supply via a current-limiting resistor, and the other end is connected to the pin in Figure 3 (low level, on; high level, off). Use DuPont wire to connect the LED1~LED8 signals to the FPGA pins such as pins 48~35 in Figure 4 (you can also choose other pins). The connection is as shown in Figure 5.


<img src="/projects/Tutorials/Led Demo/led_run/pic/figure 5 (5).png" width= "400">

## Software Design

The software design includes two parts: FPGA internal hardware logic and Cotex-M3 software control code, and you can refer to IPUG930, Gowin_EMPU (GW1NS-4C) Quick Design Reference Manual.

### FPGA Internal Logic Design

Software: Gowin_V1.9.7.02Beta and above. The reference template is the fpga_led folder as shown in Figure 6.

<img src="/projects/Tutorials/Led Demo/led_run/pic/figure 6 (6).png" width= "400">

Use Gowin Software to open fpga_led.gprj as shown in Figure 7.

<img src="/projects/Tutorials/Led Demo/led_run/pic/figure 7 (7).png" width= "400">

Click top.v and the interface is as shown in Figure 8; the embedded Cotex-M3 core provides a 16-bit GPIO interface.

<img src="/projects/Tutorials/Led Demo/led_run/pic/figure 8 (8).png" width= "400">

Click "Process" in Figure 9 and then select "FloorPlanner"to open I/O constraints as shown in Figure 10.

<img src="/projects/Tutorials/Led Demo/led_run/pic/figure 9 (9).png" width= "400">

Click steps 1-5 in turn on the interface in Figure 10 to set the FPGA pin number and power supply voltage of LED according to the connection in Figure 3 and Figure 4, and save the settings when finished.

<img src="/projects/Tutorials/Led Demo/led_run/pic/figure 10 (10).png" width= "400">

Then click "Synthesize" and "Place & Route" in Figure 11 to generate the logic file.

<img src="/projects/Tutorials/Led Demo/led_run/pic/figure 11 (11).png" width= "400">


<img src="/projects/Tutorials/Led Demo/led_run/pic/figure 12 (12).png" width= "400">

### Cotex-M3 Software Control Design

Software: ARM Keil MDK V5.26 and above. The reference template is the Keil_led folder as shown in Figure 13.

<img src="/projects/Tutorials/Led Demo/led_run/pic/figure 13 (13).png" width= "400">


Open led.uvprojx in the PROJECT folder as shown in Figure 14.

<img src="/projects/Tutorials/Led Demo/led_run/pic/figure 14 (14).png" width= "400">

Set GPIO-> OUTENSET register to realize the output function.

<img src="/projects/Tutorials/Led Demo/led_run/pic/code line 1 (15).png" width= "400">

Set GPIO-> DATAOUT register to implement LED blinking one by one.

<img src="/projects/Tutorials/Led Demo/led_run/pic/code line 2 (16).png" width= "400">

After bulid, the download file led.bin is generated as shown in Figure 15.

<img src="/projects/Tutorials/Led Demo/led_run/pic/figure 15 (17).png" width= "400">

## Download and Verification

Use Gowin Software to download as shown in Figure 16. The FPGA hardware platform file is fpga_led.fs, and the Cotex-M3 software file is led.bin, so be careful to choose the correct file path and bulid file.

<img src="/projects/Tutorials/Led Demo/led_run/pic/figure 16 (18).png" width= "400">

<img src="/projects/Tutorials/Led Demo/led_run/pic/figure 17 (19).png" width= "400">
