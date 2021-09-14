# Ultrasonic Ranging Demo

In this demo, it should be noted that the tubes in the routine are connected by
common anode. Because I do not find anode digital tube for this demo, I
change some code, so that I can use the common cathode tube to display.
 
* Development tool: Gowin V1.9
* Motherboard: Gowin MINI_STAR
* Accessories: TypeC USB cable
* Routine: Gowin ultrasonic ranging demo

Follow the official instructions to install Gowin software, then download the
routine. Go to the project file and double click to open the project to see the
relevant files.

Verilog files include clock configuration, ultrasonic ranging, digital tube drive.
Here it needs to change common anode tube to common cathode tube.
Double click the seq_control.v file, and then change the bit-selection signal
and segment-selection signal values to the corresponding values of the
common cathode. Actually you just need to negate each bit in turn. The
following is the code for the common cathode.

<img src="/projects/Ultrasonic Ranging Demo/pic/Ultrasonic pic (1).png" width= "400">

<img src="/projects/Ultrasonic Ranging Demo/pic/Ultrasonic pic (2).png" width= "400">

After modification, switch menu to the "Process". Double click "Synthesize"
 and "Place & Route" in order.
 Then click "Program Device" to download, and note that you need to add
 resistor to limit the current to drive the digital tube.
