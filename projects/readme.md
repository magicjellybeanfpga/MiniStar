# MiniStar Project Demos

## Watchdog Demo

You will learn the basic principle and programming of watchdog by this demo. As shown in the figure below, kick the dog by KEY1. When KEY1 is pressed, LED8 blinks, indicating the kicking dog action; when kicking dog is stopped, it will generate a watchdog interrupt, and the LED1 is always on after the system restart.

<img src="/projects/Watchdog Demo/wdog_run/pic/Board pic (1).png" width= "400">

[Watchdog Demo Project](https://github.com/magicjellybeanfpga/MiniStar/tree/main/projects/Watchdog%20Demo/wdog_run)

## Dip Switch Demo

You will learn how to use GPIO as the input to identify the status of dip switches to control the digital tube to display the corresponding numbers by this demo.

You can use four dip switches on the extension board to control four 7-segment digital tubes to achieve the cyclic display of the numbers 1 to 4.

<img src="/projects/Switch Run Demo/switch_run/images/Dip_switch_ministar_board_pic.jpg" width= "400">

[Dip Switch Demo Project](https://github.com/magicjellybeanfpga/MiniStar/tree/main/projects/Switch%20Run%20Demo/switch_run)

## LED Demo

You will learn how to use GPIO as the output by this demo. You can write code to control the eight LEDs LED1 (D1) ~ LED8 (D8) on the board to blink one by one.

<img src="/projects/Led Demo/led_run/pic/board pic (1).png" width= "400">

[LED Demo Project](https://github.com/magicjellybeanfpga/MiniStar/tree/main/projects/Led%20Demo/led_run)

## Keys Input Demo

You will learn how to use GPIO as the input by this demo. As shown in Figure 1, you can use the four keys KEY1~KEY4 on the extension board to control four LEDs on/off.

<img src="/projects/Keys Input Demo/keyin_run/pic/board pic (1).png" width= "400">

[Keys Input Demo Project](https://github.com/magicjellybeanfpga/MiniStar/tree/main/projects/Keys%20Input%20Demo/keyin_run)

## Digital Tube Demo

You will learn how to use GPIO as the output to control the digital tube to display numbers by this demo. As shown in Figure 1, the four 7-segment digital tubes on the extension board are used to achieve the cyclic display of numbers 0 to 9.

<img src="/projects/Digital Tube Demo/seg_run/pic/Board pic (1).png" width= "400">

[Digital Tube Demo Project](https://github.com/magicjellybeanfpga/MiniStar/tree/main/projects/Digital%20Tube%20Demo/seg_run)

## External Interrupt Demo 

You will learn how to use GPIO as external interrupt and output, and how to program the KEY1 as an external interrupt to control the LED on and off by this demo. As in Figure 1, the KEY1 on the extension board controls one LED on and off.


<img src="/projects/External Interrupt Demo/led_exti_int/pic/board 1 (1).png" width= "400">

[External Interrupt Demo Project](https://github.com/magicjellybeanfpga/MiniStar/tree/main/projects/External%20Interrupt%20Demo/led_exti_int)

## UART0 Interrupt Demo

You will learn UART and its interrupt programming by this demo. In order not to add new peripherals, use UART TX RX to control the times of LED on/off. As shown in Figure 1, short-circuit UART TX RX pins, and control the times of LED1 on/off according to the RX data.

<img src="/projects/UART0 Interrupt Demo/uart0_int_run/images/UART board pic (1).png" width= "400">

[UART0 Interrupt Demo Project](https://github.com/magicjellybeanfpga/MiniStar/tree/main/projects/UART0%20Interrupt%20Demo/uart0_int_run)
