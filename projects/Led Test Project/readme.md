# LED Test Project

1. Introduction

This LED demo is based on MINI_STAR_4K development board, and use
Gowin Software. The demo verifies the feasibility of the development board and EDA tool.

2. Environment

- Windows 10 64 bits
- MINI_STAR_4K development board 
- Gowin Software: Win V1.9.7.03 Beta

3. Program Design

There are two LEDs (HIGH, ON) on the development board, and you can set
four blinking modes.

* Mode one: led[0] and led[1] on/off cycle is one second, alternately
blinking.

* Mode two: led[0] and led[1] on/off cycle is half a second, alternately
blinking.

* Mode 3: led[0] and led[1] on/off cycle is half a second, on/off at the same
time.

* Mode 4: one led on/off cycle is one second, and the other on/off cycle is
half a second, one fast and one slow blinking.

LED Counter: There are two counters; one counter controls one led. When the clock frequency is 25 MHz (period, 40ns), led delay counter counts 1250000 cycles for a second, and 6250000 cycles counting is one second. The crystal oscillator on the development board is 27 MHz, and here 1250000 cycles delay is actually not enough for a second, but this test requirements are not so strict, it is available here.

<img src="/projects/Led Test Project/pic/LED test (1).png" width= "400">

<img src="/projects/Led Test Project/pic/LED test (2).png" width= "400">

Mode Counter: Mode counter 1 adds one after led[0] on/off once and counts ten times. Mode counter 2 adds one when mode counter 1 is full and counts four times.

<img src="/projects/Led Test Project/pic/LED test (3).png" width= "400">

<img src="/projects/Led Test Project/pic/LED test (4).png" width= "400">

LED Control: Using combination logic, you can modify the maximum value of the two led counters according to the value of mode counter 2,Q and control the two leds on/off. The code is as follows:

<img src="/projects/Led Test Project/pic/LED test (5).png" width= "400">

<img src="/projects/Led Test Project/pic/LED test (6).png" width= "400">

<img src="/projects/Led Test Project/pic/LED test (7).png" width= "400">
