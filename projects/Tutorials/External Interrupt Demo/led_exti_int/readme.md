# External Interrupt Demo

You will learn how to use GPIO as external interrupt and output, and how to program the KEY1 as an external interrupt to control the LED on and off by this demo. As in Figure 1, the KEY1 on the extension board controls one LED on and off.

<img src="/projects/External Interrupt Demo/led_exti_int/pic/board 1 (1).png" width= "400">

This demo includes four parts:

1. Interrupt Introduction
2. Hardware Design
3. Software Design
4. Download and Verification

## Interrupt Introduction

Gowin GW1NSR-LV4CQN48P is used as the platform in this demo. From DS861, GW1NSR series of FPGA Products Datasheet, you can learn the NVIC module and GPIO module, and know there is a Cortex-M3 RISC embedded in this chip.
  
NVIC supports low-latency interrupt processing, and GW1NSR-4C supports 16 interrupts as shown in Table 1.

<img src="/projects/External Interrupt Demo/led_exti_int/pic/vector table (2).png" width= "400">

A programmable priority level of 0-7 is for each interrupt. A higher level corresponds to a lower priority; for example, level 0 is the highest interrupt priority and level 7 is the lowest.

<img src="/projects/External Interrupt Demo/led_exti_int/pic/priority group (3).png" width= "400">

You can use interrupt group library function to configure.

<img src="/projects/External Interrupt Demo/led_exti_int/pic/code lines 1 (4).png" width= "400">

The interrupt attributes can be configured through structures, which are defined as follows:

<img src="/projects/External Interrupt Demo/led_exti_int/pic/code lines 2 (5).png" width= "400">

The interrupt request definition in the gw1ns4c.h file is as shown below.

<img src="/projects/External Interrupt Demo/led_exti_int/pic/code lines 3 (6).png" width= "400">

<img src="/projects/External Interrupt Demo/led_exti_int/pic/code lines 4 (7).png" width= "400">

Interrupt signal can be detected by level and pulse. For the details, you can see GPIO register shown in Table 3. The processor is automatically saved when the interrupt is entered and automatically restored when the interrupt is exited, no additional instruction is required.

<img src="/projects/External Interrupt Demo/led_exti_int/pic/register (8).png" width= "400">

External interrupt requests are sent to the NVIC module via GPIO, and external interrupts can be programmed by configuring the GPIO and NVIC.

## Hardware Design

This demo can be modified on the basis of the LED project.


<img src="/projects/External Interrupt Demo/led_exti_int/pic/hardware design (9).png" width= "400">

From the schematic, you can know LED is on in LOW and off in HIGH. When the key pressed, it is low level; when the key released, it is high level. This demo only needs one key as the external interrupt and one LED as the display. Therefore, only KEY1 and LED1 need to be connected to the corresponding FPGA ports. For example, KEY1 is connected to 45 and LED1 is connected to 40 as shown in Figure 4.

<img src="/projects/External Interrupt Demo/led_exti_int/pic/figure 4 (10).png" width= "400">

## Software Design

The software design includes two parts: FPGA internal hardware logic and Cotex-M3 software control code, which can be modified on the basis of the led project.

### FPGA Internal Logic Design

This HDL code does not need to be modified, and you only need to modify the pin connection according to the table, which has been described above. Figure 5 shows the pin definition.

<img src="/projects/External Interrupt Demo/led_exti_int/pic/figure 5 (11).png" width= "400">

Then click Place & Route to generate the logic file fpga_led.fs.

<img src="/projects/External Interrupt Demo/led_exti_int/pic/Cotex-M3 control design (12).png" width= "400">

## Download and Verification

Use Gowin Software to download, and the demo running is as shown in Figure 6. The FPGA hardware platform file is fpga_led.fs, and the Cotex-M3 software file is led.bin, so be careful to choose the correct file path and bulid file.

<img src="/projects/External Interrupt Demo/led_exti_int/pic/figure 6 (13).png" width= "400">
