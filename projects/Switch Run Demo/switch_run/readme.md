# Dip Switch Demo

You will learn how to use GPIO as the input to identify the status of dip switches to control the digital tube to display the corresponding numbers by this demo.

As shown in Figure 1, you can use four dip switches on the extension board to control four 7-segment digital tubes to achieve the cyclic display of the numbers 1 to 4.

<img src="/projects/Switch Run Demo/switch_run/images/Dip_switch_ministar_board_pic.jpg" width= "400">

Figure 1 Mini-Star Development Board(GW1NSR-LV4CQN48P)and Extension

This demo introduction includes four parts:

1. GPIO Introduction
2. Hardware Design
3. Software Design
4. Download and Verification

GPIO Introduction

Gowin GW1NSR-LV4CQN48P is used as the platform in this demo. From DS861, GW1NSR series of FPGA Products Datasheet, you can learn the GPIO module and know there is a Cortex-M3 RISC embedded in this chip. The key to this demo is how to control the GPIO as the output. The design information listed below is excerpted from the datasheet.

<img src="/projects/Switch Run Demo/switch_run/images/SOC.png" width= "400">

The following table lists GPIO registers.

<img src="/projects/Switch Run Demo/switch_run/images/GPIO registers.png" width= "400">

## Hardware Design

Figure 2 shows the dip switch schematic. As shown in Figure 2, there are two statuses for the dip switch: Power VCC3V3 and GND. The signals are connected to the FPGA pins through SW1, SW2, SW3, and SW4; and the dip switch uses the input function of IO ports.


<img src="/projects/Switch Run Demo/switch_run/images/Hardware Design 1.png" width= "400">

The schematic of four 7-segment digital tubes is shown in Figure 3, and it is a common anode 8-segment digital tube. The common terminal DIG1, DIG2, DIG3, and DIG4 control 4 digital tubes respectively, active-high; the other terminal is controlled by A, B, C, D, E, F, G, and DP, active-low.

<img src="/projects/Switch Run Demo/switch_run/images/hardware design 2.png" width= "400">

The coding of common anode 7-segment digital tube is referred to the previous demo. The dip switch and digital tube control signal ports are connected to the FPGA pins. The connection is shown in Table 1 and Table 2, and the physical picture is shown in Figure 4.

<img src="/projects/Switch Run Demo/switch_run/images/Hardware Tables.png" width= "400">


<img src="/projects/Switch Run Demo/switch_run/images/Figure 4.png" width= "400">


