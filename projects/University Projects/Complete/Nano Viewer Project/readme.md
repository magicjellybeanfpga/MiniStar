# Nano Viewer Project

By: Ziming Tang

## Project Introduction

Considering the development time and experience, I use MiniStar development board to implement a simple Nano Viewer project, and its main purpose is to provide a waste utilization solution to the most unused VGA monitor.

## Hardware Design

The main advantage of Nano Viewer is its small size and portability, and so the Ministar is. The MiniStar has two FPC interfaces, and the Nano Viewer extended board includes a VGA driver interface to drive the VGA display, a DHT11 temperature and humidity sensor to collect ambient temperature and humidity data, a Bluetooth transceiver module to receive images from the mobile APP, a battery charge and discharge management chip and power supply circuit as shown below.

<img src="/projects/University Projects/Complete/Nano Viewer Project/pic/pic (1).png" width= "400">

The 3D model of the circuit board is as shown below.

<img src="/projects/University Projects/Complete/Nano Viewer Project/pic/pic (2).png" width= "400">

Nano Viewer hardware is shown below.

<img src="/projects/University Projects/Complete/Nano Viewer Project/pic/pic (3).png" width= "400">

## Software Design

The Nano Viewer project software design includes FPGA programming and Android APP development.

## FPGA Programming

I use Gowin Software to implement FPGA design, and the interface is as shown below.

<img src="/projects/University Projects/Complete/Nano Viewer Project/pic/pic (4).png" width= "400">

The Nano Viewer project FPGA structure is shown below, which contains a serial port receiver module to receive and process image data and control signals from the Bluetooth module, two PLLs to generate the VGA clock and PSRAM clock, a VGA driver module and a VGA display module to drive the VGA display, a state control module, an on-chip ROM module to store the image and text, a PSRAM controller module to complete data writing and reading, a DHT11 driver module to obtain the temperature and humidity data, a game module to implement the game tasks.

<img src="/projects/University Projects/Complete/Nano Viewer Project/pic/pic (5).png" width= "400">

I call PSRAM controller IP to perform PSRAM read and write using Gowin software, and refer to the data sheet for read and write timing simulation and design. The simulation timing logic is shown below.

<img src="/projects/University Projects/Complete/Nano Viewer Project/pic/pic (6).png" width= "400">

The image write and read logic simulation diagram is shown below.

<img src="/projects/University Projects/Complete/Nano Viewer Project/pic/pic (7).png" width= "400">

But PSRAM operation still does not succeed, I has not yet found the reason, and finally use FPGA on-chip BRAM to complete the design.

## Android APP Program

App can control the Nano Viewer by sending different data after connecting to the Bluetooth module, including the transfer of images and game functions. Its interface is shown below. The demo was done using Bluetooth debugging assistant due to lack of time for final development.

<img src="/projects/University Projects/Complete/Nano Viewer Project/pic/pic (8).png" width= "400">

## Testing

Power up Nano Viewer, as shown below.

<img src="/projects/University Projects/Complete/Nano Viewer Project/pic/pic (9).png" width= "400">

VGA monitor is as shown below.

<img src="/projects/University Projects/Complete/Nano Viewer Project/pic/pic (10).png" width= "400">

Open APP, use the Bluetooth debugging tool to send the picture to the FPGA, and the FPGA will cache the received data into the PSRAM, as shown below.


<img src="/projects/University Projects/Complete/Nano Viewer Project/pic/pic (11).png" width= "400">

Since the PSRAM read/write logic has not been tested successfully so far, an image is temporarily saved for display using the internal BRAM as a cache, as shown below.

<img src="/projects/University Projects/Complete/Nano Viewer Project/pic/pic (12).png" width= "400">

In the initialization or image display, you can choose to enter the game mode,
  
I just do the interface, but does not write the control logic so it can not move, as shown below.

<img src="/projects/University Projects/Complete/Nano Viewer Project/pic/pic (13).png" width= "400">
