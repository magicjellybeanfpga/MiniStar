# RT-Thread Nano

RT-Thread Nano is  a  minimalist version of the hard real-time kernel, which is developed in    C,  with a programming dimension oriented towards the elephant, with a good code style, and is a cropped, preemptive real-time multi-task   RTOS  。 Its memory      resources take up very little, and its functions include service management, software timer, semaphore, mail box and   real-time adjustment, etc.  Field integration for    32-bit  ARM  entry-level MCUs that are heavily used in home  appliances,  consumer power, medical equipment, industrial control, and more.  

The  following image is RT-Thread Nano's software  block diagram, which contains a supported CPU architecture and kernel source, as well as a removable FinSH  component:  
 
Support architecture:ARM:Cortex M0/M3/M4/M7, RISC-V, and  others.  
Features: Line management, inter-line   synchronization and communication, clock management, interrupt management, memory management. 

## Nano's Special Features

### Simple 

1. under the simple list

The RT-Thread Nano is integrated in Keil MDK     and CubeMX as a software package and can be taken directly from the  software for  the Nano software package, as detailed in Porting RT-Thread Thread with KEIL MDK   Port RT-Thread Nano with  CubeMX.  
At the same time, there is also a way to  load nano source compression packages to facilitate porting RT-Thread Nanoin other open environments, such as USing IAR to port  RT-Thread Nano. 

2. code simple list

Unlike the full version of RT-Thread, nano does not contain the Scons  build system, does not require Kconfig  and Env configuration tools, and removes the full version of the unique device framework and components, which is only a pure  kernel.  
3. transplant simple single

 Because of nano's  minimalist nature, the nano's porting  process is extremely   simple. Add nano source to the project and you're 90 percent done with the porting.  Nano's software packages are also available in Keil MDK and Cube MX and can be added to the project at the touch of a button.  Here's how to port Nano when using different open  environments:
 
•	Use KEIL MDK  Port RT-Thread Nano
•	Use CubeMX  Port RT-Thread Nano
•	Use IAR  Port RT-Thread Nano
•	Port RT-Thread Nano to RISC-V

4. use simple list

RT-Thread Nano is also very  simple to use, giving the  starter  a friendly start-up  test. 

•	Easy to crop: Nano's profile is rtconfig.h, which lists all macros in the kernel,  some of which are implicitly  not open, if used, can be opened. Specific configurations can be found in  the RT-Thread Nano configuration tutorial for the Nano  section.  

•	 Easy to add FinSH components:FinSH     components can be easily ported on the Nano instead of relying on the device framework, and only two necessary functions are required  to complete the FinSH  porting.  

•	Drive Library of Choice: You can choose from firmware drive libraries from vendors such as  STD  libraries, HAL  libraries, LL  libraries, and so on.  

•	Perfect documentation: includes kernel      foundation,  line management (routine),   clock management (routine),  inter-line  synchronization  (routine),   inter-line  communication (   routines), memory management (routines), interrupt   management, and porting tutorials for nano   sections.  

### Small

 Small resource footprint:  Very small  sales  of RAM and ROM, ROM and in the case of support for semaphore and mailbox  features and running two lines (main-line-and-idle-line).      RAM remains very small,withRAM  taking up about 1K andROM taking up about 4K.  
 
Nano   resource   occupancy Example: ROM  and RAM remain very small in size  while running two main-line (main-idle-line)    scenarios. The following is the result of an MDK project based on Cortex M3   (Excellent  Level 3). 
    Total RO  Size (Code + RO Data)                 4000 (   3.91kB)
    Total RW  Size (RW Data + ZI Data)              1168 (   1.14kB)
    Total ROM Size (Code + RO Data + RW Data)       4092 (   4.00kB)
    
Note: If you need rich features such as   components, drivers, and software  packages,  use RT-Thread Full.  

### Open source free  (Apache 2.0).

RT-Thread Nano Real-Time Operations System follows  Apache's  proven version 2.0,  and the Real-Time Operations System kernel and all open source components can be used free of charge in commercial products without the need to publish the program source  code that should be used, and there are no potential vendors   risk. 

