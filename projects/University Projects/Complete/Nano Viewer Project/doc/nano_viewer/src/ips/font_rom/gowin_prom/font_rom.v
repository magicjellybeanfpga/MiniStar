//Copyright (C)2014-2021 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: IP file
//GOWIN Version: V1.9.7.02Beta
//Part Number: GW1NSR-LV4CQN48PC6/I5
//Device: GW1NSR-4C
//Created Time: Fri May 14 11:36:32 2021

module font_rom (dout, clk, oce, ce, reset, ad);

output [0:0] dout;
input clk;
input oce;
input ce;
input reset;
input [15:0] ad;

wire lut_f_0;
wire lut_f_1;
wire lut_f_2;
wire [30:0] prom_inst_0_dout_w;
wire [0:0] prom_inst_0_dout;
wire [30:0] prom_inst_1_dout_w;
wire [0:0] prom_inst_1_dout;
wire [30:0] prom_inst_2_dout_w;
wire [0:0] prom_inst_2_dout;
wire dff_q_0;
wire dff_q_1;
wire mux_o_0;

LUT3 lut_inst_0 (
  .F(lut_f_0),
  .I0(ce),
  .I1(ad[14]),
  .I2(ad[15])
);
defparam lut_inst_0.INIT = 8'h02;
LUT3 lut_inst_1 (
  .F(lut_f_1),
  .I0(ce),
  .I1(ad[14]),
  .I2(ad[15])
);
defparam lut_inst_1.INIT = 8'h08;
LUT3 lut_inst_2 (
  .F(lut_f_2),
  .I0(ce),
  .I1(ad[14]),
  .I2(ad[15])
);
defparam lut_inst_2.INIT = 8'h20;
pROM prom_inst_0 (
    .DO({prom_inst_0_dout_w[30:0],prom_inst_0_dout[0]}),
    .CLK(clk),
    .OCE(oce),
    .CE(lut_f_0),
    .RESET(reset),
    .AD(ad[13:0])
);

defparam prom_inst_0.READ_MODE = 1'b0;
defparam prom_inst_0.BIT_WIDTH = 1;
defparam prom_inst_0.RESET_MODE = "SYNC";
defparam prom_inst_0.INIT_RAM_00 = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
defparam prom_inst_0.INIT_RAM_01 = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
defparam prom_inst_0.INIT_RAM_02 = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
defparam prom_inst_0.INIT_RAM_03 = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
defparam prom_inst_0.INIT_RAM_04 = 256'h780003000001FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
defparam prom_inst_0.INIT_RAM_05 = 256'h0FC0FFE0780003000001FFFFFE000FC0FFE0780003000001FFFFFF800FC1FFE0;
defparam prom_inst_0.INIT_RAM_06 = 256'hFFFFF87F0FC07FC07FFFC3FFC3FFFFFFF83F0FC07FC07FFFC3FFC3FFFFFFFC00;
defparam prom_inst_0.INIT_RAM_07 = 256'hC3FFC3FFFFFFF0FF0FC23F887FFFC3FFC3FFFFFFF07F0FC27F887FFFC3FFC3FF;
defparam prom_inst_0.INIT_RAM_08 = 256'h1F187FFFC3FFC3FFFFE1F0FF0FC31F187FFFC3FFC3FFFFE1F0FF0FC23F887FFF;
defparam prom_inst_0.INIT_RAM_09 = 256'hF87F0FC38E387C0003FFC3FFFFE1F0FF0FC39E387FFFC3FFC3FFFFE1F0FF0FC3;
defparam prom_inst_0.INIT_RAM_0A = 256'hC3FFFFFFFC1F0FC3C4787C0003FFC3FFFFFFF87F0FC38C387C0003FFC3FFFFE1;
defparam prom_inst_0.INIT_RAM_0B = 256'h7FFFC3FFC3FFFFFFFF000FC3E0F87FFFC3FFC3FFFFFFFC000FC3C4787FFFC3FF;
defparam prom_inst_0.INIT_RAM_0C = 256'h0FC3F1F87FFFC3FFC3FFFFFFFFFF0FC3F0F87FFFC3FFC3FFFFFFFFC00FC3E0F8;
defparam prom_inst_0.INIT_RAM_0D = 256'hFFFFFFFF0FC3FFF87FFFC3FFC3FFFFFFFFFF0FC3F1F87FFFC3FFC3FFFFFFFFFF;
defparam prom_inst_0.INIT_RAM_0E = 256'hC3FFC3FFFFE1FFFF0FC3FFF87FFFC3FFC3FFFFFFFFFF0FC3FFF87FFFC3FFC3FF;
defparam prom_inst_0.INIT_RAM_0F = 256'hFFF8780003FFC3FFFFE1FFFF0FC3FFF8780003FFC3FFFFE1FFFF0FC3FFF87FFF;
defparam prom_inst_0.INIT_RAM_10 = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFE1FFFF0FC3FFF8780003FFC3FFFFE1FFFF0FC3;
defparam prom_inst_0.INIT_RAM_11 = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
defparam prom_inst_0.INIT_RAM_12 = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
defparam prom_inst_0.INIT_RAM_13 = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
defparam prom_inst_0.INIT_RAM_14 = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
defparam prom_inst_0.INIT_RAM_15 = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
defparam prom_inst_0.INIT_RAM_16 = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
defparam prom_inst_0.INIT_RAM_17 = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
defparam prom_inst_0.INIT_RAM_18 = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
defparam prom_inst_0.INIT_RAM_19 = 256'h0FFF0F87FF0FFFFFFFFFF07FF81F0FFF0F87FF0FFFFFFFFFFFFFFFFFFFFFFFFF;
defparam prom_inst_0.INIT_RAM_1A = 256'hF01FF01F0FFF0F87FF0FFFFFFFFFF03FF81F0FFF0F87FF0FFFFFFFFFF03FF81F;
defparam prom_inst_0.INIT_RAM_1B = 256'hFFFFFFFFF09FE21F0FFF0F87FF0FFFFFFFFFF01FF01F0FFF0F87FF0FFFFFFFFF;
defparam prom_inst_0.INIT_RAM_1C = 256'h0F87FF0FFFF87FFFF08FE21F0FFF0F87FF0FFFFFFFFFF08FE21F0FFF0F87FF0F;
defparam prom_inst_0.INIT_RAM_1D = 256'h8E1F0FFF0F87FF0FFFF87FFFF0C7C61F0FFF0F87FF0FFFF87FFFF0C7C61F0FFF;
defparam prom_inst_0.INIT_RAM_1E = 256'hFFFFF0E30E1F0FFF0F80000FFFF87FFFF0E38E1F0FFF0F80000FFFF87FFFF0E7;
defparam prom_inst_0.INIT_RAM_1F = 256'hFF0FFFFFFFFFF0F11E1F0FFF0F87FF0FFFFFFFFFF0F11E1F0FFF0F80000FFFFF;
defparam prom_inst_0.INIT_RAM_20 = 256'h0FFF0F87FF0FFFFFFFFFF0F83E1F0FFF0F87FF0FFFFFFFFFF0F83E1F0FFF0F87;
defparam prom_inst_0.INIT_RAM_21 = 256'hF0FC7E1F0FFF0F87FF0FFFFFFFFFF0FC7E1F0FFF0F87FF0FFFFFFFFFF0FC3E1F;
defparam prom_inst_0.INIT_RAM_22 = 256'hFFFFFFFFF0FFFE1F87FE1F87FF0FFFFFFFFFF0FFFE1F0FFF0F87FF0FFFFFFFFF;
defparam prom_inst_0.INIT_RAM_23 = 256'h7F87FF0FFFF87FFFF0FFFE1FC1F83F87FF0FFFF87FFFF0FFFE1F83FC1F87FF0F;
defparam prom_inst_0.INIT_RAM_24 = 256'hFE1FFC03FF87FF0FFFF87FFFF0FFFE1FF000FF87FF0FFFF87FFFF0FFFE1FE000;
defparam prom_inst_0.INIT_RAM_25 = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF87FFFF0FF;
defparam prom_inst_0.INIT_RAM_26 = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
defparam prom_inst_0.INIT_RAM_27 = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
defparam prom_inst_0.INIT_RAM_28 = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
defparam prom_inst_0.INIT_RAM_29 = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
defparam prom_inst_0.INIT_RAM_2A = 256'hF00FFFFFFFFFFC3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
defparam prom_inst_0.INIT_RAM_2B = 256'hFFFFC7E3FFFFFFFFC7E3FFFFFFFFC3C3FFFFFFFFE187FFFFFFFFE007FFFFFFFF;
defparam prom_inst_0.INIT_RAM_2C = 256'hFFF8FF83FC3FFFF83F03F00FFFF8000FE007FFFE001FE387FFFF807FC7C3FFFF;
defparam prom_inst_0.INIT_RAM_2D = 256'h7FFFFFFFFFF07FFFFFFFFFF0FFFFFFFFFFF0FFFFFFFBFFE0FFFFFFF9FFC1FFFF;
defparam prom_inst_0.INIT_RAM_2E = 256'hFFF87FFFFFFFFFF87FFFFFFFFFF87FFFFFFFFFF87FFFFFFFFFF87FFFFFFFFFF8;
defparam prom_inst_0.INIT_RAM_2F = 256'hFFFFFFF0FFFFFFFFFFF0FFFFFFFFFFF07FFFFFFFFFF87FFFFFFFFFF87FFFFFFF;
defparam prom_inst_0.INIT_RAM_30 = 256'hFFFFFFF80007FFFFFFF83F03FFFFFFF8FF83FFFFFFF9FFC1FFFFFFFBFFE0FFFF;
defparam prom_inst_0.INIT_RAM_31 = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC07FFFFFFFFE001F;
defparam prom_inst_0.INIT_RAM_32 = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
defparam prom_inst_0.INIT_RAM_33 = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
defparam prom_inst_0.INIT_RAM_34 = 256'hC7FE00FFFFFFFFFF83FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
defparam prom_inst_0.INIT_RAM_35 = 256'hFFFFF8F8FE3FFFFFF1F8FE3FFFFFF1F8FE3FFFFFE3FC7C7FFFFFE3FC387FFFFF;
defparam prom_inst_0.INIT_RAM_36 = 256'h7C7FFFFFFE38FE3FFFFFFE38FE3FFFFFFC78FE3FFFFFFC78FE3FFFFFF8F8FE3F;
defparam prom_inst_0.INIT_RAM_37 = 256'hF1C7FFFFFFC7F18FFFFFFFE3E38F83FFFFE1C30E00FFFFF0071C387FFFFC1F1C;
defparam prom_inst_0.INIT_RAM_38 = 256'hFFC7F1F1FFFFFFC7F1F1FFFFFFC7F1E3FFFFFFC7F1E3FFFFFFC7F1C7FFFFFFC7;
defparam prom_inst_0.INIT_RAM_39 = 256'hFFFFFFFC1FFE3FFFFFF007FC7FFFFFE1C3FC7FFFFFE3E3F8FFFFFFC7F1F8FFFF;
defparam prom_inst_0.INIT_RAM_3A = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
defparam prom_inst_0.INIT_RAM_3B = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
defparam prom_inst_0.INIT_RAM_3C = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
defparam prom_inst_0.INIT_RAM_3D = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
defparam prom_inst_0.INIT_RAM_3E = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
defparam prom_inst_0.INIT_RAM_3F = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFF0FFFFF0FFFFF0FFFFF0FFFFF0FFFFFFFFFFFFF;

pROM prom_inst_1 (
    .DO({prom_inst_1_dout_w[30:0],prom_inst_1_dout[0]}),
    .CLK(clk),
    .OCE(oce),
    .CE(lut_f_1),
    .RESET(reset),
    .AD(ad[13:0])
);

defparam prom_inst_1.READ_MODE = 1'b0;
defparam prom_inst_1.BIT_WIDTH = 1;
defparam prom_inst_1.RESET_MODE = "SYNC";
defparam prom_inst_1.INIT_RAM_00 = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
defparam prom_inst_1.INIT_RAM_01 = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
defparam prom_inst_1.INIT_RAM_02 = 256'h7FFFFFFFE0E0FFFFFFFFF001FFFFFFFFF803FFFFFFFFFE07FFFFFFFFFFFFFFFF;
defparam prom_inst_1.INIT_RAM_03 = 256'h87FC3FFFFFFF87FC3FFFFFFFC7FC7FFFFFFFC3F87FFFFFFFC3F87FFFFFFFE1F0;
defparam prom_inst_1.INIT_RAM_04 = 256'hFFFF87FC3FFFFFFF87FC3FFFFFFF87FC3FFFFFFF87FC3FFFFFFF87FC3FFFFFFF;
defparam prom_inst_1.INIT_RAM_05 = 256'h7FFFFFFF87FC3FFFFFFF87FC3FFFFFFF87FC3FFFFFFF87FC3FFFFFFF87FC3FFF;
defparam prom_inst_1.INIT_RAM_06 = 256'hF001FFFFFFFFE0E0FFFFFFFFC1F0FFFFFFFFC3F87FFFFFFFC3F87FFFFFFFC7FC;
defparam prom_inst_1.INIT_RAM_07 = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC07FFFFFFFFF803FFFFFFFF;
defparam prom_inst_1.INIT_RAM_08 = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
defparam prom_inst_1.INIT_RAM_09 = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
defparam prom_inst_1.INIT_RAM_0A = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
defparam prom_inst_1.INIT_RAM_0B = 256'hFFFFFFFFFC7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
defparam prom_inst_1.INIT_RAM_0C = 256'hFC01FFFFFFFFFC01FFFFFFFFFC01FFFFFFFFFC1FFFFFFFFFFC3FFFFFFFFFFC3F;
defparam prom_inst_1.INIT_RAM_0D = 256'hFFFFFC3FFFFFFFFFFC3FFFFFFFFFFC3FFFFFFFFFFC3FFFFFFFFFFC3FFFFFFFFF;
defparam prom_inst_1.INIT_RAM_0E = 256'hFFFFFFFFFC3FFFFFFFFFFC3FFFFFFFFFFC3FFFFFFFFFFC3FFFFFFFFFFC3FFFFF;
defparam prom_inst_1.INIT_RAM_0F = 256'hFC3FFFFFFFFFFC3FFFFFFFFFFC3FFFFFFFFFFC3FFFFFFFFFFC3FFFFFFFFFFC3F;
defparam prom_inst_1.INIT_RAM_10 = 256'hFFFFFFFFFFFFFFFF8001FFFFFFFF8001FFFFFFFF8001FFFFFFFFFC3FFFFFFFFF;
defparam prom_inst_1.INIT_RAM_11 = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
defparam prom_inst_1.INIT_RAM_12 = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
defparam prom_inst_1.INIT_RAM_13 = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
defparam prom_inst_1.INIT_RAM_14 = 256'h7FFFFFFFF07C7FFFFFFFF8007FFFFFFFFC007FFFFFFFFE03FFFFFFFFFFFFFFFF;
defparam prom_inst_1.INIT_RAM_15 = 256'hE1FFFFFFFFFFE1FFFFFFFFFFE1FFFFFFFFFFE1FFFFFFFFFFE1FFFFFFFFFFE0FF;
defparam prom_inst_1.INIT_RAM_16 = 256'hFFFFF83FFFFFFFFFF87FFFFFFFFFF0FFFFFFFFFFF0FFFFFFFFFFE1FFFFFFFFFF;
defparam prom_inst_1.INIT_RAM_17 = 256'hFFFFFFFFFF83FFFFFFFFFF07FFFFFFFFFE0FFFFFFFFFFE1FFFFFFFFFFC3FFFFF;
defparam prom_inst_1.INIT_RAM_18 = 256'hC0003FFFFFFFFFFC3FFFFFFFFFF87FFFFFFFFFF0FFFFFFFFFFE1FFFFFFFFFFC3;
defparam prom_inst_1.INIT_RAM_19 = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC0003FFFFFFFC0003FFFFFFF;
defparam prom_inst_1.INIT_RAM_1A = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
defparam prom_inst_1.INIT_RAM_1B = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
defparam prom_inst_1.INIT_RAM_1C = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
defparam prom_inst_1.INIT_RAM_1D = 256'h7FFFFFFFF0007FFFFFFFF8007FFFFFFFFE03FFFFFFFFFFFFFFFFFFFFFFFFFFFF;
defparam prom_inst_1.INIT_RAM_1E = 256'hE1FFFFFFFFFFE1FFFFFFFFFFE1FFFFFFFFFFE1FFFFFFFFFFE0FF7FFFFFFFF07C;
defparam prom_inst_1.INIT_RAM_1F = 256'hFFFFF807FFFFFFFFFE07FFFFFFFFF807FFFFFFFFF07FFFFFFFFFF0FFFFFFFFFF;
defparam prom_inst_1.INIT_RAM_20 = 256'hFFFFFFFFC3FFFFFFFFFFC3FFFFFFFFFFE3FFFFFFFFFFE1FFFFFFFFFFF0FFFFFF;
defparam prom_inst_1.INIT_RAM_21 = 256'hF07C3FFFFFFFE1FFBFFFFFFFC1FFFFFFFFFFC3FFFFFFFFFFC3FFFFFFFFFFC3FF;
defparam prom_inst_1.INIT_RAM_22 = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE01FFFFFFFFF8003FFFFFFFF0003FFFFFFF;
defparam prom_inst_1.INIT_RAM_23 = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
defparam prom_inst_1.INIT_RAM_24 = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
defparam prom_inst_1.INIT_RAM_25 = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
defparam prom_inst_1.INIT_RAM_26 = 256'hFFFFFFFFF03FFFFFFFFFF07FFFFFFFFFF0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
defparam prom_inst_1.INIT_RAM_27 = 256'hF0F1FFFFFFFFF0E3FFFFFFFFF0C7FFFFFFFFF08FFFFFFFFFF01FFFFFFFFFF01F;
defparam prom_inst_1.INIT_RAM_28 = 256'hFFFFF0FF1FFFFFFFF0FE3FFFFFFFF0FC7FFFFFFFF0F8FFFFFFFFF0F1FFFFFFFF;
defparam prom_inst_1.INIT_RAM_29 = 256'hFFFFFFFFF0FFFFFFFFFF80001FFFFFFF80001FFFFFFF80001FFFFFFFF0FF1FFF;
defparam prom_inst_1.INIT_RAM_2A = 256'hF0FFFFFFFFFFF0FFFFFFFFFFF0FFFFFFFFFFF0FFFFFFFFFFF0FFFFFFFFFFF0FF;
defparam prom_inst_1.INIT_RAM_2B = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0FFFFFFFFFFF0FFFFFFFFFF;
defparam prom_inst_1.INIT_RAM_2C = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
defparam prom_inst_1.INIT_RAM_2D = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
defparam prom_inst_1.INIT_RAM_2E = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
defparam prom_inst_1.INIT_RAM_2F = 256'h7FFFFFFFC0007FFFFFFFC0007FFFFFFFC0007FFFFFFFFFFFFFFFFFFFFFFFFFFF;
defparam prom_inst_1.INIT_RAM_30 = 256'hFFF87FFFFFFFFFF87FFFFFFFFFF87FFFFFFFFFF87FFFFFFFFFF87FFFFFFFFFF8;
defparam prom_inst_1.INIT_RAM_31 = 256'hFFFFE07E7FFFFFFFF0007FFFFFFFF8007FFFFFFFFE007FFFFFFFFFF87FFFFFFF;
defparam prom_inst_1.INIT_RAM_32 = 256'hFFFFFFFFC3FFFFFFFFFFC3FFFFFFFFFFC3FFFFFFFFFFC3FFFFFFFFFFE1FFFFFF;
defparam prom_inst_1.INIT_RAM_33 = 256'hF0003FFFFFFFF07C3FFFFFFFE1FFBFFFFFFFE1FFFFFFFFFFC3FFFFFFFFFFC3FF;
defparam prom_inst_1.INIT_RAM_34 = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF01FFFFFFFFFC003FFFFFFF;
defparam prom_inst_1.INIT_RAM_35 = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
defparam prom_inst_1.INIT_RAM_36 = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
defparam prom_inst_1.INIT_RAM_37 = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
defparam prom_inst_1.INIT_RAM_38 = 256'hFFFFFFFFEF83FFFFFFFFE007FFFFFFFFE00FFFFFFFFFE03FFFFFFFFFFFFFFFFF;
defparam prom_inst_1.INIT_RAM_39 = 256'hFFFC7FFFFFFFFFF87FFFFFFFFFF87FFFFFFFFFF0FFFFFFFFFFF0FFFFFFFFFFE1;
defparam prom_inst_1.INIT_RAM_3A = 256'hFFFFC3FC3FFFFFFFC1F03FFFFFFFE0003FFFFFFFF0043FFFFFFFFC1C3FFFFFFF;
defparam prom_inst_1.INIT_RAM_3B = 256'h3FFFFFFF87FC3FFFFFFF87FC3FFFFFFF87FC3FFFFFFF87FC3FFFFFFF83FC3FFF;
defparam prom_inst_1.INIT_RAM_3C = 256'hF001FFFFFFFFE1E0FFFFFFFFC3F07FFFFFFFC3F87FFFFFFF87F87FFFFFFF87FC;
defparam prom_inst_1.INIT_RAM_3D = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC0FFFFFFFFFF803FFFFFFFF;
defparam prom_inst_1.INIT_RAM_3E = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
defparam prom_inst_1.INIT_RAM_3F = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;

pROM prom_inst_2 (
    .DO({prom_inst_2_dout_w[30:0],prom_inst_2_dout[0]}),
    .CLK(clk),
    .OCE(oce),
    .CE(lut_f_2),
    .RESET(reset),
    .AD(ad[13:0])
);

defparam prom_inst_2.READ_MODE = 1'b0;
defparam prom_inst_2.BIT_WIDTH = 1;
defparam prom_inst_2.RESET_MODE = "SYNC";
defparam prom_inst_2.INIT_RAM_00 = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
defparam prom_inst_2.INIT_RAM_01 = 256'h3FFFFFFF80003FFFFFFF80003FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
defparam prom_inst_2.INIT_RAM_02 = 256'hE1FFFFFFFFFFC1FFFFFFFFFFC3FFFFFFFFFF83FFFFFFFFFF87FFFFFFFFFF8000;
defparam prom_inst_2.INIT_RAM_03 = 256'hFFFFF87FFFFFFFFFF87FFFFFFFFFF0FFFFFFFFFFF0FFFFFFFFFFE1FFFFFFFFFF;
defparam prom_inst_2.INIT_RAM_04 = 256'hFFFFFFFFFE0FFFFFFFFFFE1FFFFFFFFFFC1FFFFFFFFFFC3FFFFFFFFFF83FFFFF;
defparam prom_inst_2.INIT_RAM_05 = 256'hFFC3FFFFFFFFFFC3FFFFFFFFFF87FFFFFFFFFF87FFFFFFFFFF07FFFFFFFFFF0F;
defparam prom_inst_2.INIT_RAM_06 = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE0FFFFFFFFFFE1FFFFFFFFFFE1FFFFFFFF;
defparam prom_inst_2.INIT_RAM_07 = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
defparam prom_inst_2.INIT_RAM_08 = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
defparam prom_inst_2.INIT_RAM_09 = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
defparam prom_inst_2.INIT_RAM_0A = 256'hFFFFFFFFF801FFFFFFFFFE07FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
defparam prom_inst_2.INIT_RAM_0B = 256'hC3FC3FFFFFFFC3FC3FFFFFFFC3FC3FFFFFFFC1F83FFFFFFFE0F07FFFFFFFF000;
defparam prom_inst_2.INIT_RAM_0C = 256'hFFFFF801FFFFFFFFF1C0FFFFFFFFE1F07FFFFFFFE3F83FFFFFFFC3FC3FFFFFFF;
defparam prom_inst_2.INIT_RAM_0D = 256'h1FFFFFFF83FE1FFFFFFFC1FC3FFFFFFFE0FC7FFFFFFFF018FFFFFFFFF801FFFF;
defparam prom_inst_2.INIT_RAM_0E = 256'hC3FC3FFFFFFF87FC1FFFFFFF87FE1FFFFFFF87FE1FFFFFFF87FE1FFFFFFF87FE;
defparam prom_inst_2.INIT_RAM_0F = 256'hFFFFFFFFFFFFFFFFFE07FFFFFFFFF800FFFFFFFFE0007FFFFFFFC0F03FFFFFFF;
defparam prom_inst_2.INIT_RAM_10 = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
defparam prom_inst_2.INIT_RAM_11 = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
defparam prom_inst_2.INIT_RAM_12 = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
defparam prom_inst_2.INIT_RAM_13 = 256'h7FFFFFFFF800FFFFFFFFFC01FFFFFFFFFF07FFFFFFFFFFFFFFFFFFFFFFFFFFFF;
defparam prom_inst_2.INIT_RAM_14 = 256'hC3FE1FFFFFFFC3FE1FFFFFFFE1FE1FFFFFFFE1FC3FFFFFFFE0FC3FFFFFFFF078;
defparam prom_inst_2.INIT_RAM_15 = 256'hFFFFC3FC3FFFFFFFC3FC1FFFFFFFC3FE1FFFFFFFC3FE1FFFFFFFC3FE1FFFFFFF;
defparam prom_inst_2.INIT_RAM_16 = 256'hFFFFFFFFE3FFFFFFFFFFC383FFFFFFFFC200FFFFFFFFC0007FFFFFFFC0F83FFF;
defparam prom_inst_2.INIT_RAM_17 = 256'hFC1F7FFFFFFFF87FFFFFFFFFF0FFFFFFFFFFF1FFFFFFFFFFE1FFFFFFFFFFE1FF;
defparam prom_inst_2.INIT_RAM_18 = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC07FFFFFFFFF007FFFFFFFFE007FFFFFFF;
defparam prom_inst_2.INIT_RAM_19 = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
defparam prom_inst_2.INIT_RAM_1A = 256'h00000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;

DFFE dff_inst_0 (
  .Q(dff_q_0),
  .D(ad[15]),
  .CLK(clk),
  .CE(ce)
);
DFFE dff_inst_1 (
  .Q(dff_q_1),
  .D(ad[14]),
  .CLK(clk),
  .CE(ce)
);
MUX2 mux_inst_0 (
  .O(mux_o_0),
  .I0(prom_inst_0_dout[0]),
  .I1(prom_inst_1_dout[0]),
  .S0(dff_q_1)
);
MUX2 mux_inst_2 (
  .O(dout[0]),
  .I0(mux_o_0),
  .I1(prom_inst_2_dout[0]),
  .S0(dff_q_0)
);
endmodule //font_rom
