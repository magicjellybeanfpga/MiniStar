# Watchdog Demo

[Video Tutorial of Watchdog Demo](https://www.youtube.com/watch?v=NeJP00vhzqE)

You will learn the basic principle and programming of watchdog by this demo. As shown in the figure below, kick the dog by KEY1. When KEY1 is pressed, LED8 blinks, indicating the kicking dog action; when kicking dog is stopped, it will generate a watchdog interrupt, and the LED1 is always on after the system restart.

<img src="/projects/Tutorials/Watchdog Demo/wdog_run/pic/Board pic (1).png" width= "400">

This demo includes four parts:

1. Watchdog Introduction
2. Hardware Design
3. Software Design
4. Download and Verification

## Watchdog Introduction

Watchdog is actually a counter; usually given a number, the watchdog starts counting after the program starts running. If the program runs normally, after a while the CPU should issue an instruction that watchdog starts next counting. If the watchdog time out, it is considered that the program is not working normally, and the system is forced to reset.
Therefore, the watchdog is to achieve processor automatic reset (send reset signal) if no kicking signal is received (indicating that the MCU has been hung) within a certain period of time (achieved through the counter).
 
According to 3.11.9 Watchdog section of DS861, GW1NSR series of FPGA Products Datasheet, you know the development board IP has an embedded Watchdog, which can be controlled and accessed through the APB1 bus. The watchdog is based on a 32 bits down-counter that is initialized from the reload register, WDOGLOAD. The watchdog module generates a regular interrupt, WDOGINT. The counter decrements by one on each positive clock edge of WDOGCLK when the clock enable, WDOGCLKEN, is HIGH. The watchdog monitors the interrupt and asserts a reset request WDOGRES signal when the counter reaches 0. On the next enabled WDOGCLK clock edge, the counter is reloaded from the WDOGLOAD register and the countdown sequence continues. The watchdog module applies a reset to a system in the event of a software failure, providing a way to recover from software crashes. For example, if the interrupt is not cleared by the time the counter next reaches 0, the watchdog module initiates the reset signal.

The following depicts the watchdog operation:

<img src="/projects/Tutorials/Watchdog Demo/wdog_run/pic/Figure 3-41 (2).png" width= "400">

Three types of system resets are defined in gw1ns4c_syscon.h.

   #define SYSCON_RSTINFO_SYSRESETREQ_Pos 0 
   #define SYSCON_RSTINFO_WDOGRESETREQ_Pos 1 
   #define SYSCON_RSTINFO_LOCKUPRESET_Pos 2
   
/* System Reset Request bit position */
/* WatchDog Reset Requestt bit position */
/* Lockup Reset bit position */

The watchdog register is as shown below:

<img src="/projects/Tutorials/Watchdog Demo/wdog_run/pic/Table 3-20 (3).png" width= "400">

* WDOGLOCK[0]:

0: unlock Enable write access all register 1: lock Disable write access register

* WDOGCONTROL: 00:No action

01:Interrupt 10:Reset

The register structure is defined in gw1ns4c_wdog.h:


<img src="/projects/Tutorials/Watchdog Demo/wdog_run/pic/typedef struct (4).png" width= "400">

## Hardware Design

This demo can be modified on the basis of the timer interrupt project. LED is on in LOW and off in HIGH. This demo only needs two LEDs, so only three wires are needed to connect LED1, LED8, KEY1 to FPGA ports, as shown in Figure 1.

## Software Design

The software design includes two parts: FPGA internal hardware logic and Cotex-M3 software control code, which can be modified on the basis of the timer interrupt project.

### FPGA Internal Logic Design

You do not need to modify the HDL, only need to set GPIO[0], GPIO[1], and GPIO[15] in I/O Constraints. Then click Place & Route to generate the logic file fpga_led.fs.

<img src="/projects/Tutorials/Watchdog Demo/wdog_run/pic/contraints pic (5).png" width= "400">

### Cotex-M3 Software Control Design

This design can be modified on the basis of timer interrupt project. Open led.uvprojx in the Keil_led\PROJECT folder.

1. Group interrupt

NVIC_PriorityGroupConfig(NVIC_PriorityGroup_3);

2. Set GPIO0[0] and GPIO0[1] to output to drive LED1 and LED8; set GPIO0[15] to input to identify KEY1 status.
GPIO0->OUTENSET = 0x00ff; //IO[15:8]: input IO[7:0]: output

3. Initialize watchdog

<img src="/projects/Tutorials/Watchdog Demo/wdog_run/pic/watchdog_init (6).png" width= "400">

4. The main design is as shown below: when reset watchdog, light up LED1; when kick watchdog, light up LED8.


<img src="/projects/Tutorials/Watchdog Demo/wdog_run/pic/int main (7).png" width= "400">



5. After bulid, the download file led.bin is generated.


## Download and Verification


Use Gowin Software to download. The FPGA hardware platform file is fpga_led.fs, and the Cotex-M3 software file is led.bin, so be careful to choose the correct file path and bulid file, and you can see demo running in the video.



