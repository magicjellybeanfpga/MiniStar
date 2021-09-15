# Dual

1. Introduction

This project uses Gowin FPGA (GW1N-LV1) as the core, and peripheral circuits such as DAC and keypad are built to realize a dual-channel DDS signal generator. The waveform, frequency and phase of each channel can be adjusted independently by pushbuttons and dip switches. With the potentiometer, the amplitude of the final output waveform of each channel can be adjusted.

2. Specification

* Number of channels: 2
* Modulation mode: DDS
* Waveform type: sine wave, square wave, triangle wave, sawtooth wave  Frequency: 1-65535Hz
* Frequency step: 1Hz
* Phase range: 0-360 degrees
* Phase step: 360/(2^8) degrees
* Output amplitude: 0-3.3V
* Output impedance: 50ohm

3. Structure

This project uses the GW1N-LV1 to output dual-channel DDS waveform signals, and the analog section to filter, amplitude adjust, and output buffer the signals.

4. Principle

## Logic

1. The signal generator uses ROM 4KB for each channel as waveform memory, and the amplitude of one cycle of each waveform (sine, square, triangle and sawtooth) occupies 1024 bytes, and these four waveforms occupy 4096 bytes.

To output a waveform, firstly, the base address needs to be determined according to the waveform type; secondly, the frequency register determines the rate of self-increment of the offset; the phase register determines the difference between the offsets of the two channels; finally, the base address and the offset are added to obtain the output voltage of the waveform in ROM.

2. Waveform parameters are set by keys and dip switches.

The 8-bit dip switch is the data input interface for setting parameters of frequency and phase, and the data range is 0x00~0xFF. The frequency input

keys are divided into high and low keys, and pressing the high key means the 8-bit dip switch data is written to the higher 8 bits of the frequency register, and pressing the low key means the 8-bit dip switch data is written to the lower 8 bits of the frequency register; and the higher and lower 8-bit registers can be used to adjust the frequency from 1Hz to 65535Hz.
There is only one phase input key, and the phase is represented by dividing 360 degrees into 256 parts, and the phase value of the waveform is set by the 8-bit dip switch.

The waveform key is used to switch the waveform. When the key is pressed, the waveform will be cyclically switched in the order of idle, sine, square, triangle, and sawtooth. CH port is connected to a dip switch whose high and low levels indicate frequency, phase, and channel selection.

3. Counting-type De-jitter Module

The de-jitter logic of many MCUs is to sample the level change and then sample it again at a short interval, and if the two levels are the same, the key is considered stable. This method is suitable for general-purpose processors, but it is not very suitable for hardware logic.

In this project, a countin-type de-jitter module is designed. A counter is defined as [n:0]. The size of n determines the degree of de-jitter, and should be chosen according to the characteristics of the key; large size leads to slow response, and small size is not enough to de-jitter.

The high and low levels of the key determine whether the counter is value +1 or -1 in each clock cycle, and the highest bit of the counter is used as the output after de-jitter. When the counter is full 0, it stops -1; when the counter is full 1, it stops +1. Key jitter is eliminated by the counting process, and the middle value of the counter determines the highest bit 01change.

## Analog

The waveform signal is output from the FPGA in 8-bit parallel and then enters the 8-bit R2R resistor network for digital-to-analog conversion. The converted signal is a high output impedance analog voltage signal of 0~3.3V, which needs to enter the op-amp and potentiometer for amplitude adjustment and output buffering.
