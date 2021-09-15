# Multi-Acquisition Circuit Project

### 1. Introduction

This project is based on the multi-acquisition version of MiniStar development board. The main control chip of MiniStar is Gowin GW1NSR-4C, which is a low-power FPGA chip with Cortex-M3 hard core processor, internal logic resources of 4608 four-input look-up tables and 3456 FFs, and integrated with Block RAM, flash memory, multiplier, HyperRAM and other rich resources. The project mainly relies on the FPGA (PL) of GW1NSR-4C for temperature collection and serial transmission due to time constraints, and the processor will be added in the product design to extend the application of the LOT module.

### 2. Development Environment

Gowin's FPGA chip provides a complete set of tool chain, using Gowin_V1.9.6Beta to obtain license for programming. 

### 3. System Architecture

The hardware in this project mainly consists of MiniStar development board, 18b20 digital temperature sensor, MAX3490 conversion chip. The development board is equipped with power supply system and FPGA chip, connected to the 18B20 sensor and MAX3490 TTL to RS422 chip through the IO, the whole as shown in the figure below.

<img src="/projects/Multi-acquisition Circuit Project/pic/Multi pic (1).png" width= "400">

### 4. Software Design

In this project, the ARM processor is not applied for the time being, so it is
mainly for the design and organization of FPGA logic, the main module to be realized is the communication logic of UART and I2C; firstly, the FPGA reads the temperature value at the 18B20 sensor by the IIC logic module, which is stored in the instantiated RAM, then the UART logic module reads the temperature data from the RAM and sends it to the host, which is displayed by the serial assistant. The logic is written in Verilog HDL language, and the architecture is shown in the following.

<img src="/projects/Multi-acquisition Circuit Project/pic/Multi pic (2).png" width= "400">
