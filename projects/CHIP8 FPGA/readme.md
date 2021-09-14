# CHIP8 FPGA 

## Hardware Platform

MiniStar development board

<img src="/projects/CHIP8 FPGA/pics/CHIP8 pic (1).png" width= "200">

0.96 inch OLED12864 LCD I2C driver ssd1315

<img src="/projects/CHIP8 FPGA/pics/CHIP8 pic (2).png" width= "400">

4x4 matrix keyboard

<img src="/projects/CHIP8 FPGA/pics/CHIP8 pic (3).png" width= "400">

### System Design

CHIP8 is first implemented as a virtual machine-like language system in 4KB system such as Cosmac VIP and Telmac 1800.

### 16 8-bit registers

They are V0 to VF, and VF is also used as flag register.

### Address register I

Address register I, 16 bits, is used in memory access.

### Stack

The stack is used to store the address returned by the subroutine when it is called.

### Clocks

CHIP8 has two clocks, both executed at 60Hz, decreasing to 0

* Delay timer: used to trigger specific game events, the values can be
read and written.

* Audio timer (Sound timer): used only to play audio, when its value is
non-zero, it will beep.

### Input

4x4 16-bit keyboard 0 to F, where 8,4,6,2 are usually used for directions. There are 3 instructions for reading keyboard input, refer to the opcode table.

### Display

64x32 pixel monochrome display; the image is drawn to the screen by means of a sprite, which is 8-pixel wide and 1-pixel to 16-pixel high. The currently drawn sprite does an XOR of the existing pixels on the screen. If this operation reverses the pixels on the screen, then the VF register will save 1 and vice versa 0. This will detect whether the current drawing collides with the existing pixels on the screen.

### Sound

Play beep when audio clock is non-zero

### Opcode Table

CHIP8 has 35 opcodes, 2 bytes, and is encoded in Big-endian format as described below.

* NNN: address
* NN: 8-bit constant
* N: 4-bit constant
* X and Y: 4-bit register identifier
* PC: Instruction counter
* I: 16-bit index address register
* VN: 16 known values, can be 0 to F.

### Software Design

The diagram is as shown below.

<img src="/projects/CHIP8 FPGA/pics/CHIP8 pic (4).png" width= "400">

* Javascript CHIP8 assembler and simulator environment

https://github.com/JohnEarnest/Octo

* C8C C compiler and simulator 

https://github.com/glouw/c8c

* Project Link: (continuously updated) 

https://gitee.com/sammulk/chip8-ministar
