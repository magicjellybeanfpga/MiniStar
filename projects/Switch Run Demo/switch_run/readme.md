# Dip Switch Demo

You will learn how to use GPIO as the input to identify the status of dip switches to control the digital tube to display the corresponding numbers by this demo.

As shown in Figure 1, you can use four dip switches on the extension board to control four 7-segment digital tubes to achieve the cyclic display of the numbers 1 to 4.

<img src="projects/Switch Run Demo/pic/Dip switch ministar board pic.png" align="center">

Figure 1 Mini-Star Development Board(GW1NSR-LV4CQN48P)and Extension

This demo introduction includes four parts:

1. GPIO Introduction
2. Hardware Design
3. Software Design
4. Download and Verification

GPIO Introduction

Gowin GW1NSR-LV4CQN48P is used as the platform in this demo. From DS861, GW1NSR series of FPGA Products Datasheet, you can learn the GPIO module and know there is a Cortex-M3 RISC embedded in this chip. The key to this demo is how to control the GPIO as the output. The design information listed below is excerpted from the datasheet.

