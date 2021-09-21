# Square Wave Generation Project

By: Guowei Sun 

### Project Design

The design includes the following parts.

1. Square wave output
2. Key input
3. OLED display

FPGA drives the square wave generation, and the MCU drives the key and OLED, and the two communicate directly through the AHB bus.

Flow: OLED displays the frequency and performs key operation when a key operation is monitored, and sends the set frequency to the FPGA through AHB bus.


### MCU Program Design

Here the address 0xA0000000 is used to store the frequency to be sent to the FPGA (the data is the accumulated value converted according to the 32-bit overflow and the 27MHz clock).

1. Judge the state of the three keys. When the key is pressed, it will first de-jitter and then wait for the key to be stable. The functions includes: move the cursor, decrease the value of the frequency where the cursor is located, and increase the value of the frequency where the cursor is located.

2. Write the converted frequency to the 0xA0000000 address (frequency*2^32/27000000).

3. Modify the display on the screen

<img src="/projects/Square Wave Generation Project/pic/Square wave (1).png" width= "400">

<img src="/projects/Square Wave Generation Project/pic/Square wave (2).png" width= "400">

<img src="/projects/Square Wave Generation Project/pic/Square wave 3.png" width= "400">

### FPGA Program Design

It includes top, hardcore, AHB parsing, and square wave generation.

Top: instantiate each module.

Hardcore: use gpio and AHB2 Master, and the ip cores are very easy to configure via software.

AHB parsing: At position 0 of AHB, a 32 bit reg_freq register used to receive the frequency of the square wave sent from MCU.

<img src="/projects/Square Wave Generation Project/pic/Square wave (4).png" width= "400">

<img src="/projects/Square Wave Generation Project/pic/Square wave (5).png" width= "400">

<img src="/projects/Square Wave Generation Project/pic/Square wave (6).png" width= "400">

<img src="/projects/Square Wave Generation Project/pic/Square wave (7).png" width= "400">

Square wave generation: 32-bit accumulator, by modifying the size of the single accumulation to control the period of the waveform.

<img src="/projects/Square Wave Generation Project/pic/Square wave (8).png" width= "400">

### Resource Utilization

MCU:

<img src="/projects/Square Wave Generation Project/pic/Square wave (9).png" width= "400">
