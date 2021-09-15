# OLED Hand Eletronic Clock Project

By: Zhenyang Li 

## 1. Introduction

This project is OLED hand electronic clock based on the MiniStar development board. The main control chip of MiniStar is Gowin GW1NSR-4C, which is a low-power FPGA chip with Cortex-M3 hard core processor, internal logic resources of 4608 four-input look-up tables and 3456 FFs, and integrated with Block RAM, flash memory, multiplier, HyperRAM and other rich resources. The project mainly uses GW1NSR-4C hard-core processor to perform time calculation and control the OLED electronic clock of I2C interface.

## 2. Development Environment

This project uses Gowin Software V1.9.7.02 Beta for FPGA programming and Keil μVision V5.3.00 for software programming of the hard-core processor.

## 3. System Architecture

The Cortex-M3 in the system communicates with the FPGA core system through the AHB-Lite bus, and the two together forms a system on chip. You can invoke Gowin_EMPU IP core in Gowin Software to generate bus and peripherals to support processor, and you can also configure peripherals as needed. The system is also very extensible, with an AHB Master interface, an AHB Slave interface, and twelve APB Master interfaces on the bus. As this project is relatively simple, and only UART0, RTC and I2C are needed.

## 4. Software Design

The software design includes RTC driver, UART driver, I2C driver and OLED driver. At startup, the program communicates with the computer through the serial port to get the time, and closes the serial port to timing after succeeded. The timing is performed using the M3 core peripheral Systick, which uses a 10ms countdown timer and generates an interrupt when the count reaches 0. The program starts to draw a new frame of the electronic clock whenever the timer reaches 1 s. The OLED communicates with the host through I2C, and the host caches a frame of the OLED image and sends a frame of the image to the OLED continuously in an I2C transfer to quickly refresh the OLED screen when the screen is updated.
