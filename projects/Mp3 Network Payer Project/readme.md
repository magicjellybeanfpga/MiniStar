# MP3 Network Player Project

## Project Design

FPGA controls communication between RTL8201CP chip and computer to receive MP3 audio stream from the computer to store in FIFO. FPGA communicates with M3 hardcore through AHB bus. M3 hardcore reads the audio stream on AHB bus through SPI interface; then output the data to VS1003B chip for MP3 decoding to output analog audio.

### Environment

* Windows 10 64 bits
* VLC
* MINI_STAR_4K development board  RTL8201CP network extension board  VS1003B extension board
* Gowin Software: Win V1.9.7.03 Beta  MKD5.23
