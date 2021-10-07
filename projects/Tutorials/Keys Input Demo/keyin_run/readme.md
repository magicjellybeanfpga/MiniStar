# Keys Input Demo


You will learn how to use GPIO as the input by this demo. As shown in Figure 1, you can use the four keys KEY1~KEY4 on the extension board to control four LEDs on/off.

<img src="/projects/Tutorials/Keys Input Demo/keyin_run/pic/board pic (1).png" width= "400">

Figure 1 Mini-Star Development Board(GW1NSR-LV4CQN48P)and Extension

This demo introduction includes four parts:

1. GPIO Introduction
2. Hardware Design
3. Software Design
4. Download and Verification

## GPIO Introduction

Gowin GW1NSR-LV4CQN48P is used as the platform in this demo. From DS861, GW1NSR series of FPGA Products Datasheet, you can learn the GPIO module and know there is a Cortex-M3 RISC embedded in this chip. The key to this demo is how to control the GPIO as the output. The design information listed below is excerpted from the datasheet.

<img src="/projects/Tutorials/Keys Input Demo/keyin_run/pic/soc (2).png" width= "400">

The following table lists GPIO registers.

<img src="/projects/Tutorials/Keys Input Demo/keyin_run/pic/register (3).png" width= "400">

## Hardware Design

<img src="/projects/Tutorials/Keys Input Demo/keyin_run/pic/hardware design (4).png" width= "400">

Figure 4 FPGA Pins

In the Figure 2, one end of the KEY is connected to the power supply via the current-limiting resistor, and the other end is connected to the pins in Figure 3 (low level when the key pressed; high level when the key released). Use DuPont wire to connect KEY1~KEY4 signals to FPGA pins such as 20~26 in Figure 4 (pins 1/2/8/9/47/48 have special purpose and are not recommended). The connection of KEY and FPGA is shown in Figure 5.

Pins Used for the video demo:

LED1 = pin35

LED2 = pin43

LED3 = pin33

LED4 = pin40

LED5 = pin42

LED6 = pin44

LED7= pin46

LED8 = pin45

Key1 = pin34

Key2= pin30

Key3= pin29

Key4= pin31

<img src="/projects/Tutorials/Keys Input Demo/keyin_run/pic/figure 5 (5).png" width= "400">

## Software Design

The software design includes two parts: FPGA internal hardware logic and Cotex-M3 software control code, which can be modified on the basis of the led project.

### FPGA Internal Logic Design

This HDL code does not need to be modified, and you only need to add the key pin connection. Click "Process" and then select "FloorPlanner" in Figure 6 to open I/O constraints as shown in Figure 7.

<img src="/projects/Tutorials/Keys Input Demo/keyin_run/pic/figure 6 (6).png" width= "400">

Click on steps 1-5 on the interface in Figure 7 to set LED, the FPGA pin number and power supply voltage of the KEY according to the connection in Figure 3 and Figure 4, and save the settings when finished.

<img src="/projects/Tutorials/Keys Input Demo/keyin_run/pic/figure 7 (7).png" width= "400">


Then click "Synthesize" and "Place & Route" to generate the logic file fpga_led.fs.

Note!

LED1-LED8 corresponds to GPIO[7:0]; KEY1-4 corresponds to GPIO[11:8].

### Cotex-M3 Software Control Design

You can modify this design on the basis of the led project. 

Open Led.uvprojx in the Keil_led\PROJECT folder.

1. Set GPIO register; set GPIO[7: 0] as the output and GPIO[15:8] as the input.

<img src="/projects/Tutorials/Keys Input Demo/keyin_run/pic/code line 1 (8).png" width= "400">

2. By setting the GPIO->DATAOUT output data register, you can realize LEDs blinking one by one to test the configuration.

First, write a sub-function led_1() to light up LED1-8 one by one, as shown in Figure 8. Then write a sub-function led_off() to extinguish all LEDs, as shown in Figure 9.

<img src="/projects/Tutorials/Keys Input Demo/keyin_run/pic/figure 8+9 (9).png" width= "400">

3. The KEY operation is obtained by reading GPIO->DATA input data register. The GPIO->DATA register is defined as follows.

<img src="/projects/Tutorials/Keys Input Demo/keyin_run/pic/data table (10).png" width= "400">

When KEY1 is pressed, it is in low level, that is, the GPIO[11]=0, and the other bits are unknown, marked by x, GPIO->DATA=xxxx_0xxx_xxxx_xxxx; as the LED corresponds to GPIO[7:0], shift GPIO->DATA right by 4 bits to get the result 0000_xxxx_0xxx_xxxx, which will be performed an OR operation 1111_1111_0111_1111, and the result is 0xff7f; send this result to GPIO->DATAOUT output data register, that is, light up a LED corresponding to GPIO[7].

<img src="/projects/Tutorials/Keys Input Demo/keyin_run/pic/code line 2 (11).png" width= "400">

When KEY2 is pressed, it is in low level, that is, the GPIO[10]=0, and the other bits are unknown, marked by x, GPIO->DATA=xxxx_x0xx_xxxx_xxxx; as the LED corresponds to GPIO[7:0], shift GPIO->DATA right by 4 bits to get the result 0000_xxxx_x0xx_xxxx, which will be performed an OR operation 1111_1111_1011_1111, and the result is 0xffbf; send this result to GPIO->DATAOUT output data register, that is, light up a LED corresponding to GPIO[6].

<img src="/projects/Tutorials/Keys Input Demo/keyin_run/pic/code line 3 (12).png" width= "400">

When KEY3 is pressed, it is in low level, that is, the GPIO[9]=0, and the other bits are unknown, marked by x, GPIO->DATA=xxxx_xx0x_xxxx_xxxx;as the LED corresponds to GPIO[7:0], shift GPIO->DATA right by 4 bits to get the result 0000_xxxx_xx0x_xxxx, which will be performed an OR operation 1111_1111_1101_1111, and the result is 0xffdf; send this result to GPIO->DATAOUT output data register, that is, light up a LED corresponding to GPIO[5].


<img src="/projects/Tutorials/Keys Input Demo/keyin_run/pic/code line 4 (13).png" width= "400">

When KEY4 is pressed, it is in low level, that is, the GPIO[8]=0, and the other bits are unknown, marked by x, GPIO->DATA=xxxx_xxx0_xxxx_xxxx;as the LED corresponds to GPIO[7:0], shift GPIO->DATA right by 4 bits to get the result 0000_xxxx_xxx0_xxxx, which will be performed an OR operation 1111_1111_1110_1111, and the result is 0xffef; send this result to GPIO->DATAOUT output data register, that is, light up a LED corresponding to GPIO[4].

<img src="/projects/Tutorials/Keys Input Demo/keyin_run/pic/code line 5 (14).png" width= "400">

4. After bulid, the download file led.bin is generated.

## Download and Verification

Use Gowin Software to download, and the running is as shown in Figure 10. The FPGA hardware platform file is fpga_led.fs, and the Cotex-M3 software file is led.bin, so be careful to choose the correct file path and bulid file.

<img src="/projects/Tutorials/Keys Input Demo/keyin_run/pic/figure 10 (15).png" width= "400">

