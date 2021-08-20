//Copyright (C)2014-2020 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: IP file
//GOWIN Version: V1.9.7Beta
//Part Number: GW1NSR-LV4CQN48GC7/I6
//Device: GW1NSR-4C
//Created Time: Thu Jul 01 22:11:00 2021

module Gowin_OSC (oscout, oscen);

output oscout;
input oscen;

OSCZ osc_inst (
    .OSCOUT(oscout),
    .OSCEN(oscen)
);

defparam osc_inst.FREQ_DIV = 4;

endmodule //Gowin_OSC
