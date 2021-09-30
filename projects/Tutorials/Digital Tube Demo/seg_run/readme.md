# Digital Tube Demo

You will learn how to use GPIO as the output to control the digital tube to display numbers by this demo. As shown in Figure 1, the four 7-segment digital tubes on the extension board are used to achieve the cyclic display of numbers 0 to 9.


<img src="/projects/Tutorials/Digital Tube Demo/seg_run/pic/Board pic (1).png" width= "400">

Figure 1 Mini-Star Development Board(GW1NSR-LV4CQN48P)and Extension

This demo introduction includes four parts:

1. GPIO Introduction
2. Hardware Design
3. Software Design
4. Download and Verification

## GPIO Introduction

Gowin GW1NSR-LV4CQN48P is used as the platform in this demo. From DS861, GW1NSR series of FPGA Products Datasheet, you can learn the GPIO module and know there is a Cortex-M3 RISC embedded in this chip. The key to this demo is how to control the GPIO as the output. The design information listed below is excerpted from the datasheet.

<img src="/projects/Tutorials/Digital Tube Demo/seg_run/pic/SOC (2).png" width= "400">

The following table lists GPIO registers.

<img src="/projects/Tutorials/Digital Tube Demo/seg_run/pic/registers (3).png" width= "400">

## Hardware Design

<img src="/projects/Tutorials/Digital Tube Demo/seg_run/pic/Hardware design (4).png" width= "400">

In Figure 2, it is a common anode 8-segment digital tube, and the common terminal DIG1, DIG2, DIG3, and DIG4 control four digital tubes respectively, active-high. The other terminal is controlled by A, B, C, D, E, F, G, and DP, active-low.

The relationship between the field and code of the common anode 7-segment digital tube is shown in Figure 3.

<img src="/projects/Tutorials/Digital Tube Demo/seg_run/pic/Figure 3 (5).png" width= "400">

The control signals of the digital tube are connected to the FPGA pins, after programming, you can observe a digital tube displaying the numbers 0~9. The pin connection is shown in Figure 4 and Table 1, and the digital tube and FPGA connection is as shown in Figure 5.

<img src="/projects/Tutorials/Digital Tube Demo/seg_run/pic/Figure 4 (6).png" width= "400">


<img src="/projects/Tutorials/Digital Tube Demo/seg_run/pic/table 1 pin definition (7).png" width= "400">

<img src="/projects/Tutorials/Digital Tube Demo/seg_run/pic/figure 5 (8).png" width= "400">

## Software Design

The software design includes two parts: FPGA internal hardware logic and Cotex-M3 software control code, which can be modified on the basis of the led project.

### FPGA Internal Logic Design

This HDL code does not need to be modified, and you only need to modify the pin connection according to the table, which has been described above. The pin configuration is shown in Figure 6.

<img src="/projects/Tutorials/Digital Tube Demo/seg_run/pic/figure 6 (9).png" width= "400">


Then click Place & Route to generate the logic file fpga_led.fs.

### Cotex-M3 Software Control Design

You can modify this design on the basis of the led project. Open Led.uvprojx in the Keil_led\PROJECT folder.

1. Set GPIO register; set GPIO[15: 0] as the output.

<img src="/projects/Tutorials/Digital Tube Demo/seg_run/pic/code 1 (10).png" width= "400">

2. Set the GPIO->DATAOUT output data register, and the digital tube can display numbers.


According to the coding in Figure 3 and the pin definition in Table 1, the
A to DP of the digital tube correspond to GPIO[7:0], and the DIG1 to DIG4 correspond to GPIO[11:8], so the upper 8 bits need to be set to high level, and the lower 8 bits correspond to the coding in Figure 3. For example, the number 0 corresponds to the code 0xc0, and the upper bit is 0xff, which corresponds to the code 0xffc0, so that four digital tubes can display the number 0 at the same time. The reference code is shown in Figure 7.

<img src="/projects/Tutorials/Digital Tube Demo/seg_run/pic/figure 7 (11).png" width= "400">

3. Use the array to code the digital tube, and it is also possible to display the numbers 0-9. The reference code is shown in Figure 8. 

<img src="/projects/Tutorials/Digital Tube Demo/seg_run/pic/figure 8 (12).png" width= "400">

Note!

ARM core is a 32-bit processor, and different types of data correspond to different types of storage; ARM system in non-aligned storage access will generate data acquisition issues, and you will learn the coding and address alignment issue in this case.

4. After bulid, the download file led.bin is generated.

## Download and Verification


Use Gowin Software to download, and the running is as shown in Figure 9. The FPGA hardware platform file is fpga_led.fs, and the Cotex-M3 software file is led.bin, so be careful to choose the correct file path and bulid file.

<img src="/projects/Tutorials/Digital Tube Demo/seg_run/pic/figure 9 (13).png" width= "400">
