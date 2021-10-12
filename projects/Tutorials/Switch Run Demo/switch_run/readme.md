# Dip Switch Demo

[Video Tutorial of LED Demo](https://www.youtube.com/watch?v=H3cF838PDow&t=12s)

You will learn how to use GPIO as the input to identify the status of dip switches to control the digital tube to display the corresponding numbers by this demo.

As shown in Figure 1, you can use four dip switches on the extension board to control four 7-segment digital tubes to achieve the cyclic display of the numbers 1 to 4.

<img src="/projects/Tutorials/Switch Run Demo/switch_run/images/Dip_switch_ministar_board_pic.jpg" width= "400">

Figure 1 Mini-Star Development Board(GW1NSR-LV4CQN48P)and Extension

This demo introduction includes four parts:

1. GPIO Introduction
2. Hardware Design
3. Software Design
4. Download and Verification

GPIO Introduction

Gowin GW1NSR-LV4CQN48P is used as the platform in this demo. From DS861, GW1NSR series of FPGA Products Datasheet, you can learn the GPIO module and know there is a Cortex-M3 RISC embedded in this chip. The key to this demo is how to control the GPIO as the output. The design information listed below is excerpted from the datasheet.

<img src="/projects/Tutorials/Switch Run Demo/switch_run/images/SOC.png" width= "400">

The following table lists GPIO registers.

<img src="/projects/Tutorials/Switch Run Demo/switch_run/images/GPIO registers.png" width= "400">

## Hardware Design

Figure 2 shows the dip switch schematic. As shown in Figure 2, there are two statuses for the dip switch: Power VCC3V3 and GND. The signals are connected to the FPGA pins through SW1, SW2, SW3, and SW4; and the dip switch uses the input function of IO ports.


<img src="/projects/Tutorials/Switch Run Demo/switch_run/images/Hardware Design 1.png" width= "400">

The schematic of four 7-segment digital tubes is shown in Figure 3, and it is a common anode 8-segment digital tube. The common terminal DIG1, DIG2, DIG3, and DIG4 control 4 digital tubes respectively, active-high; the other terminal is controlled by A, B, C, D, E, F, G, and DP, active-low.

<img src="/projects/Tutorials/Switch Run Demo/switch_run/images/hardware design 2.png" width= "400">

The coding of common anode 7-segment digital tube is referred to the previous demo. The dip switch and digital tube control signal ports are connected to the FPGA pins. The connection is shown in Table 1 and Table 2, and the physical picture is shown in Figure 4.

<img src="/projects/Tutorials/Switch Run Demo/switch_run/images/Hardware Tables.png" width= "400">


<img src="/projects/Tutorials/Switch Run Demo/switch_run/images/Figure 4.png" width= "400">


## Software Design

The software design includes two parts: FPGA internal hardware logic and Cotex-M3 software control code, which can be modified on the basis of the digital tube project.
FPGA Internal Logic Design
This HDL code does not need to be modified, and you only need to modify the pin connection according to the table, which has been described
                                                                 
above. The pin definition modified according to Table 1 and Table 2 is shown in Figure 5.

<img src="/projects/Tutorials/Switch Run Demo/switch_run/images/Figure 5.png" width= "400">

Then click Place & Route to generate the logic file fpga_led.fs.
Cotex-M3 Software Control Design

You can modify this design on the basis of the digital tube project. Open Led.uvprojx in the Keil_led\PROJECT folder.

1. Set GPIO register; set GPIO[15:12] as the input of dip switch and GPIO[11:0] as the output of digital tube.

<img src="/projects/Tutorials/Switch Run Demo/switch_run/images/Code line 1.png" width= "200">

2. Read the status of the dip switch and save it in the upper four bits [15:12] of the input data register DATA, and shift the upper four bits data right by four bits to write the status of the dip switch in the high-byte lower four bits [11:8] of the output register, which corresponds to the common terminal DIG1, DIG2,DIG3, and DIG4 of the digital tube; then set the lower 8 bits of the output register to 0 , which means that the A to DP segment of the digital tube is all low ( the coded value of 8). The code is as follows:

<img src="/projects/Tutorials/Switch Run Demo/switch_run/images/Code line 2.png" width= "200">

When the dip switch is set to low, DIG1 to DIG4 will be low and the ommon anode digital tube will be off. When the dip switch is set to high, DIG1 to DIG4 will be high and the ommon anode digital tube will display number 8. The physical picture is shown in Figure 6, in which SW1 and SW2 are set to low, SW3 and SW4 are set to high; that is, digital tube 1 and 2 are off, digital tube 3 and 4 display.

<img src="/projects/Tutorials/Switch Run Demo/switch_run/images/Figure 6.png" width= "400">

3. Based on the second step, modify GPIO->DATAOUT output data register to realize digital tube displaying different numbers.
According to the coding principle of common anode digital tube, the A to DP of digital tube correspond to GPIO[7:0] (active-low); DIG1 to DIG4 correspond to GPIO[11:8] (active-high); and the numbers 1 to 4 are coded as 0xf9,0xa4,0xb0,0x99 in order.
Firstly, the status value of the dip switch is stored in the upper four bits of DATA [15:12], and the DATA register value is shifted to the right by 8 bits, and then an AND operation is performed with 0x80, 0x40, 0x20 and 0x10 in turn; the high and low level of the dip switch are judged according to whether the operation result is equal to 0; then the detected status will be corresponded to the DIG common terminal of digital tube, and the processed data will be transferred to the output register to realize different numbers display controlled by dip switches. The reference code is shown in Figure 7 below.

4. After bulid, the download file led.bin is generated.

<img src="/projects/Tutorials/Switch Run Demo/switch_run/images/Figure 7.png" width= "400">

## Download and Verification

Use Gowin Software to download, and the running is as shown in Figure 8. The FPGA hardware platform file is fpga_led.fs, and the Cotex-M3 software file is led.bin, so be careful to choose the correct file path and bulid file.

<img src="/projects/Tutorials/Switch Run Demo/switch_run/images/figure 8.png" width= "400">



