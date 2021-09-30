module gw_gao(
    \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[31] ,
    \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[30] ,
    \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[29] ,
    \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[28] ,
    \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[27] ,
    \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[26] ,
    \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[25] ,
    \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[24] ,
    \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[23] ,
    \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[22] ,
    \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[21] ,
    \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[20] ,
    \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[19] ,
    \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[18] ,
    \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[17] ,
    \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[16] ,
    \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[15] ,
    \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[14] ,
    \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[13] ,
    \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[12] ,
    \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[11] ,
    \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[10] ,
    \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[9] ,
    \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[8] ,
    \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[7] ,
    \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[6] ,
    \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[5] ,
    \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[4] ,
    \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[3] ,
    \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[2] ,
    \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[1] ,
    \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[0] ,
    \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_valid_calib ,
    mem_clk,
    tms_pad_i,
    tck_pad_i,
    tdi_pad_i,
    tdo_pad_o
);

input \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[31] ;
input \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[30] ;
input \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[29] ;
input \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[28] ;
input \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[27] ;
input \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[26] ;
input \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[25] ;
input \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[24] ;
input \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[23] ;
input \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[22] ;
input \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[21] ;
input \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[20] ;
input \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[19] ;
input \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[18] ;
input \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[17] ;
input \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[16] ;
input \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[15] ;
input \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[14] ;
input \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[13] ;
input \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[12] ;
input \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[11] ;
input \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[10] ;
input \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[9] ;
input \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[8] ;
input \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[7] ;
input \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[6] ;
input \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[5] ;
input \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[4] ;
input \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[3] ;
input \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[2] ;
input \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[1] ;
input \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[0] ;
input \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_valid_calib ;
input mem_clk;
input tms_pad_i;
input tck_pad_i;
input tdi_pad_i;
output tdo_pad_o;

wire \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[31] ;
wire \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[30] ;
wire \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[29] ;
wire \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[28] ;
wire \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[27] ;
wire \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[26] ;
wire \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[25] ;
wire \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[24] ;
wire \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[23] ;
wire \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[22] ;
wire \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[21] ;
wire \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[20] ;
wire \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[19] ;
wire \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[18] ;
wire \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[17] ;
wire \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[16] ;
wire \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[15] ;
wire \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[14] ;
wire \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[13] ;
wire \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[12] ;
wire \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[11] ;
wire \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[10] ;
wire \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[9] ;
wire \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[8] ;
wire \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[7] ;
wire \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[6] ;
wire \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[5] ;
wire \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[4] ;
wire \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[3] ;
wire \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[2] ;
wire \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[1] ;
wire \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[0] ;
wire \u_psram_control/u_hyper_ram/u_hpram_top/rd_data_valid_calib ;
wire mem_clk;
wire tms_pad_i;
wire tck_pad_i;
wire tdi_pad_i;
wire tdo_pad_o;
wire tms_i_c;
wire tck_i_c;
wire tdi_i_c;
wire tdo_o_c;
wire [9:0] control0;
wire gao_jtag_tck;
wire gao_jtag_reset;
wire run_test_idle_er1;
wire run_test_idle_er2;
wire shift_dr_capture_dr;
wire update_dr;
wire pause_dr;
wire enable_er1;
wire enable_er2;
wire gao_jtag_tdi;
wire tdo_er1;
wire tdo_er2;

IBUF tms_ibuf (
    .I(tms_pad_i),
    .O(tms_i_c)
);

IBUF tck_ibuf (
    .I(tck_pad_i),
    .O(tck_i_c)
);

IBUF tdi_ibuf (
    .I(tdi_pad_i),
    .O(tdi_i_c)
);

OBUF tdo_obuf (
    .I(tdo_o_c),
    .O(tdo_pad_o)
);

GW_JTAG  u_gw_jtag(
    .tms_pad_i(tms_i_c),
    .tck_pad_i(tck_i_c),
    .tdi_pad_i(tdi_i_c),
    .tdo_pad_o(tdo_o_c),
    .tck_o(gao_jtag_tck),
    .test_logic_reset_o(gao_jtag_reset),
    .run_test_idle_er1_o(run_test_idle_er1),
    .run_test_idle_er2_o(run_test_idle_er2),
    .shift_dr_capture_dr_o(shift_dr_capture_dr),
    .update_dr_o(update_dr),
    .pause_dr_o(pause_dr),
    .enable_er1_o(enable_er1),
    .enable_er2_o(enable_er2),
    .tdi_o(gao_jtag_tdi),
    .tdo_er1_i(tdo_er1),
    .tdo_er2_i(tdo_er2)
);

gw_con_top  u_icon_top(
    .tck_i(gao_jtag_tck),
    .tdi_i(gao_jtag_tdi),
    .tdo_o(tdo_er1),
    .rst_i(gao_jtag_reset),
    .control0(control0[9:0]),
    .enable_i(enable_er1),
    .shift_dr_capture_dr_i(shift_dr_capture_dr),
    .update_dr_i(update_dr)
);

ao_top u_ao_top(
    .control(control0[9:0]),
    .data_i({\u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[31] ,\u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[30] ,\u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[29] ,\u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[28] ,\u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[27] ,\u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[26] ,\u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[25] ,\u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[24] ,\u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[23] ,\u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[22] ,\u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[21] ,\u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[20] ,\u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[19] ,\u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[18] ,\u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[17] ,\u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[16] ,\u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[15] ,\u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[14] ,\u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[13] ,\u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[12] ,\u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[11] ,\u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[10] ,\u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[9] ,\u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[8] ,\u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[7] ,\u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[6] ,\u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[5] ,\u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[4] ,\u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[3] ,\u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[2] ,\u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[1] ,\u_psram_control/u_hyper_ram/u_hpram_top/rd_data_d[0] ,\u_psram_control/u_hyper_ram/u_hpram_top/rd_data_valid_calib }),
    .clk_i(mem_clk)
);

endmodule
