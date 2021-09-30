module gw_gao(
    \ch1_wave_select_Z[3] ,
    \ch1_wave_select_Z[2] ,
    \ch1_wave_select_Z[1] ,
    \ch1_wave_select_Z[0] ,
    \ch2_wave_select_Z[3] ,
    \ch2_wave_select_Z[2] ,
    \ch2_wave_select_Z[1] ,
    \ch2_wave_select_Z[0] ,
    \ch1_FREQ_CTRL_Z[24] ,
    \ch1_FREQ_CTRL_Z[23] ,
    \ch1_FREQ_CTRL_Z[22] ,
    \ch1_FREQ_CTRL_Z[21] ,
    \ch1_FREQ_CTRL_Z[20] ,
    \ch1_FREQ_CTRL_Z[19] ,
    \ch1_FREQ_CTRL_Z[18] ,
    \ch1_FREQ_CTRL_Z[17] ,
    \ch1_FREQ_CTRL_Z[16] ,
    \ch1_FREQ_CTRL_Z[15] ,
    \ch1_FREQ_CTRL_Z[14] ,
    \ch1_FREQ_CTRL_Z[13] ,
    \ch1_FREQ_CTRL_Z[12] ,
    \ch1_FREQ_CTRL_Z[11] ,
    \ch1_FREQ_CTRL_Z[10] ,
    \ch1_FREQ_CTRL_Z[9] ,
    \ch1_FREQ_CTRL_Z[8] ,
    \ch1_FREQ_CTRL_Z[7] ,
    \ch1_FREQ_CTRL_Z[6] ,
    \ch1_FREQ_CTRL_Z[5] ,
    \ch1_FREQ_CTRL_Z[4] ,
    \ch1_FREQ_CTRL_Z[3] ,
    \ch1_FREQ_CTRL_Z[2] ,
    \ch1_FREQ_CTRL_Z[1] ,
    \ch1_FREQ_CTRL_Z[0] ,
    \ch2_FREQ_CTRL_Z[24] ,
    \ch2_FREQ_CTRL_Z[23] ,
    \ch2_FREQ_CTRL_Z[22] ,
    \ch2_FREQ_CTRL_Z[21] ,
    \ch2_FREQ_CTRL_Z[20] ,
    \ch2_FREQ_CTRL_Z[19] ,
    \ch2_FREQ_CTRL_Z[18] ,
    \ch2_FREQ_CTRL_Z[17] ,
    \ch2_FREQ_CTRL_Z[16] ,
    \ch2_FREQ_CTRL_Z[15] ,
    \ch2_FREQ_CTRL_Z[14] ,
    \ch2_FREQ_CTRL_Z[13] ,
    \ch2_FREQ_CTRL_Z[12] ,
    \ch2_FREQ_CTRL_Z[11] ,
    \ch2_FREQ_CTRL_Z[10] ,
    \ch2_FREQ_CTRL_Z[9] ,
    \ch2_FREQ_CTRL_Z[8] ,
    \ch2_FREQ_CTRL_Z[7] ,
    \ch2_FREQ_CTRL_Z[6] ,
    \ch2_FREQ_CTRL_Z[5] ,
    \ch2_FREQ_CTRL_Z[4] ,
    \ch2_FREQ_CTRL_Z[3] ,
    \ch2_FREQ_CTRL_Z[2] ,
    \ch2_FREQ_CTRL_Z[1] ,
    \ch2_FREQ_CTRL_Z[0] ,
    \ch1_PHASE_CTRL_Z[9] ,
    \ch1_PHASE_CTRL_Z[8] ,
    \ch1_PHASE_CTRL_Z[7] ,
    \ch1_PHASE_CTRL_Z[6] ,
    \ch1_PHASE_CTRL_Z[5] ,
    \ch1_PHASE_CTRL_Z[4] ,
    \ch1_PHASE_CTRL_Z[3] ,
    \ch1_PHASE_CTRL_Z[2] ,
    sys_clk,
    tms_pad_i,
    tck_pad_i,
    tdi_pad_i,
    tdo_pad_o
);

input \ch1_wave_select_Z[3] ;
input \ch1_wave_select_Z[2] ;
input \ch1_wave_select_Z[1] ;
input \ch1_wave_select_Z[0] ;
input \ch2_wave_select_Z[3] ;
input \ch2_wave_select_Z[2] ;
input \ch2_wave_select_Z[1] ;
input \ch2_wave_select_Z[0] ;
input \ch1_FREQ_CTRL_Z[24] ;
input \ch1_FREQ_CTRL_Z[23] ;
input \ch1_FREQ_CTRL_Z[22] ;
input \ch1_FREQ_CTRL_Z[21] ;
input \ch1_FREQ_CTRL_Z[20] ;
input \ch1_FREQ_CTRL_Z[19] ;
input \ch1_FREQ_CTRL_Z[18] ;
input \ch1_FREQ_CTRL_Z[17] ;
input \ch1_FREQ_CTRL_Z[16] ;
input \ch1_FREQ_CTRL_Z[15] ;
input \ch1_FREQ_CTRL_Z[14] ;
input \ch1_FREQ_CTRL_Z[13] ;
input \ch1_FREQ_CTRL_Z[12] ;
input \ch1_FREQ_CTRL_Z[11] ;
input \ch1_FREQ_CTRL_Z[10] ;
input \ch1_FREQ_CTRL_Z[9] ;
input \ch1_FREQ_CTRL_Z[8] ;
input \ch1_FREQ_CTRL_Z[7] ;
input \ch1_FREQ_CTRL_Z[6] ;
input \ch1_FREQ_CTRL_Z[5] ;
input \ch1_FREQ_CTRL_Z[4] ;
input \ch1_FREQ_CTRL_Z[3] ;
input \ch1_FREQ_CTRL_Z[2] ;
input \ch1_FREQ_CTRL_Z[1] ;
input \ch1_FREQ_CTRL_Z[0] ;
input \ch2_FREQ_CTRL_Z[24] ;
input \ch2_FREQ_CTRL_Z[23] ;
input \ch2_FREQ_CTRL_Z[22] ;
input \ch2_FREQ_CTRL_Z[21] ;
input \ch2_FREQ_CTRL_Z[20] ;
input \ch2_FREQ_CTRL_Z[19] ;
input \ch2_FREQ_CTRL_Z[18] ;
input \ch2_FREQ_CTRL_Z[17] ;
input \ch2_FREQ_CTRL_Z[16] ;
input \ch2_FREQ_CTRL_Z[15] ;
input \ch2_FREQ_CTRL_Z[14] ;
input \ch2_FREQ_CTRL_Z[13] ;
input \ch2_FREQ_CTRL_Z[12] ;
input \ch2_FREQ_CTRL_Z[11] ;
input \ch2_FREQ_CTRL_Z[10] ;
input \ch2_FREQ_CTRL_Z[9] ;
input \ch2_FREQ_CTRL_Z[8] ;
input \ch2_FREQ_CTRL_Z[7] ;
input \ch2_FREQ_CTRL_Z[6] ;
input \ch2_FREQ_CTRL_Z[5] ;
input \ch2_FREQ_CTRL_Z[4] ;
input \ch2_FREQ_CTRL_Z[3] ;
input \ch2_FREQ_CTRL_Z[2] ;
input \ch2_FREQ_CTRL_Z[1] ;
input \ch2_FREQ_CTRL_Z[0] ;
input \ch1_PHASE_CTRL_Z[9] ;
input \ch1_PHASE_CTRL_Z[8] ;
input \ch1_PHASE_CTRL_Z[7] ;
input \ch1_PHASE_CTRL_Z[6] ;
input \ch1_PHASE_CTRL_Z[5] ;
input \ch1_PHASE_CTRL_Z[4] ;
input \ch1_PHASE_CTRL_Z[3] ;
input \ch1_PHASE_CTRL_Z[2] ;
input sys_clk;
input tms_pad_i;
input tck_pad_i;
input tdi_pad_i;
output tdo_pad_o;

wire \ch1_wave_select_Z[3] ;
wire \ch1_wave_select_Z[2] ;
wire \ch1_wave_select_Z[1] ;
wire \ch1_wave_select_Z[0] ;
wire \ch2_wave_select_Z[3] ;
wire \ch2_wave_select_Z[2] ;
wire \ch2_wave_select_Z[1] ;
wire \ch2_wave_select_Z[0] ;
wire \ch1_FREQ_CTRL_Z[24] ;
wire \ch1_FREQ_CTRL_Z[23] ;
wire \ch1_FREQ_CTRL_Z[22] ;
wire \ch1_FREQ_CTRL_Z[21] ;
wire \ch1_FREQ_CTRL_Z[20] ;
wire \ch1_FREQ_CTRL_Z[19] ;
wire \ch1_FREQ_CTRL_Z[18] ;
wire \ch1_FREQ_CTRL_Z[17] ;
wire \ch1_FREQ_CTRL_Z[16] ;
wire \ch1_FREQ_CTRL_Z[15] ;
wire \ch1_FREQ_CTRL_Z[14] ;
wire \ch1_FREQ_CTRL_Z[13] ;
wire \ch1_FREQ_CTRL_Z[12] ;
wire \ch1_FREQ_CTRL_Z[11] ;
wire \ch1_FREQ_CTRL_Z[10] ;
wire \ch1_FREQ_CTRL_Z[9] ;
wire \ch1_FREQ_CTRL_Z[8] ;
wire \ch1_FREQ_CTRL_Z[7] ;
wire \ch1_FREQ_CTRL_Z[6] ;
wire \ch1_FREQ_CTRL_Z[5] ;
wire \ch1_FREQ_CTRL_Z[4] ;
wire \ch1_FREQ_CTRL_Z[3] ;
wire \ch1_FREQ_CTRL_Z[2] ;
wire \ch1_FREQ_CTRL_Z[1] ;
wire \ch1_FREQ_CTRL_Z[0] ;
wire \ch2_FREQ_CTRL_Z[24] ;
wire \ch2_FREQ_CTRL_Z[23] ;
wire \ch2_FREQ_CTRL_Z[22] ;
wire \ch2_FREQ_CTRL_Z[21] ;
wire \ch2_FREQ_CTRL_Z[20] ;
wire \ch2_FREQ_CTRL_Z[19] ;
wire \ch2_FREQ_CTRL_Z[18] ;
wire \ch2_FREQ_CTRL_Z[17] ;
wire \ch2_FREQ_CTRL_Z[16] ;
wire \ch2_FREQ_CTRL_Z[15] ;
wire \ch2_FREQ_CTRL_Z[14] ;
wire \ch2_FREQ_CTRL_Z[13] ;
wire \ch2_FREQ_CTRL_Z[12] ;
wire \ch2_FREQ_CTRL_Z[11] ;
wire \ch2_FREQ_CTRL_Z[10] ;
wire \ch2_FREQ_CTRL_Z[9] ;
wire \ch2_FREQ_CTRL_Z[8] ;
wire \ch2_FREQ_CTRL_Z[7] ;
wire \ch2_FREQ_CTRL_Z[6] ;
wire \ch2_FREQ_CTRL_Z[5] ;
wire \ch2_FREQ_CTRL_Z[4] ;
wire \ch2_FREQ_CTRL_Z[3] ;
wire \ch2_FREQ_CTRL_Z[2] ;
wire \ch2_FREQ_CTRL_Z[1] ;
wire \ch2_FREQ_CTRL_Z[0] ;
wire \ch1_PHASE_CTRL_Z[9] ;
wire \ch1_PHASE_CTRL_Z[8] ;
wire \ch1_PHASE_CTRL_Z[7] ;
wire \ch1_PHASE_CTRL_Z[6] ;
wire \ch1_PHASE_CTRL_Z[5] ;
wire \ch1_PHASE_CTRL_Z[4] ;
wire \ch1_PHASE_CTRL_Z[3] ;
wire \ch1_PHASE_CTRL_Z[2] ;
wire sys_clk;
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

ao_top_0  u_la0_top(
    .control(control0[9:0]),
    .trig0_i({\ch1_FREQ_CTRL_Z[24] ,\ch1_FREQ_CTRL_Z[23] ,\ch1_FREQ_CTRL_Z[22] ,\ch1_FREQ_CTRL_Z[21] ,\ch1_FREQ_CTRL_Z[20] ,\ch1_FREQ_CTRL_Z[19] ,\ch1_FREQ_CTRL_Z[18] ,\ch1_FREQ_CTRL_Z[17] ,\ch1_FREQ_CTRL_Z[16] ,\ch1_FREQ_CTRL_Z[15] ,\ch1_FREQ_CTRL_Z[14] ,\ch1_FREQ_CTRL_Z[13] ,\ch1_FREQ_CTRL_Z[12] ,\ch1_FREQ_CTRL_Z[11] ,\ch1_FREQ_CTRL_Z[10] ,\ch1_FREQ_CTRL_Z[9] ,\ch1_FREQ_CTRL_Z[8] ,\ch1_FREQ_CTRL_Z[7] ,\ch1_FREQ_CTRL_Z[6] ,\ch1_FREQ_CTRL_Z[5] ,\ch1_FREQ_CTRL_Z[4] ,\ch1_FREQ_CTRL_Z[3] ,\ch1_FREQ_CTRL_Z[2] ,\ch1_FREQ_CTRL_Z[1] ,\ch1_FREQ_CTRL_Z[0] }),
    .data_i({\ch1_wave_select_Z[3] ,\ch1_wave_select_Z[2] ,\ch1_wave_select_Z[1] ,\ch1_wave_select_Z[0] ,\ch2_wave_select_Z[3] ,\ch2_wave_select_Z[2] ,\ch2_wave_select_Z[1] ,\ch2_wave_select_Z[0] ,\ch1_FREQ_CTRL_Z[24] ,\ch1_FREQ_CTRL_Z[23] ,\ch1_FREQ_CTRL_Z[22] ,\ch1_FREQ_CTRL_Z[21] ,\ch1_FREQ_CTRL_Z[20] ,\ch1_FREQ_CTRL_Z[19] ,\ch1_FREQ_CTRL_Z[18] ,\ch1_FREQ_CTRL_Z[17] ,\ch1_FREQ_CTRL_Z[16] ,\ch1_FREQ_CTRL_Z[15] ,\ch1_FREQ_CTRL_Z[14] ,\ch1_FREQ_CTRL_Z[13] ,\ch1_FREQ_CTRL_Z[12] ,\ch1_FREQ_CTRL_Z[11] ,\ch1_FREQ_CTRL_Z[10] ,\ch1_FREQ_CTRL_Z[9] ,\ch1_FREQ_CTRL_Z[8] ,\ch1_FREQ_CTRL_Z[7] ,\ch1_FREQ_CTRL_Z[6] ,\ch1_FREQ_CTRL_Z[5] ,\ch1_FREQ_CTRL_Z[4] ,\ch1_FREQ_CTRL_Z[3] ,\ch1_FREQ_CTRL_Z[2] ,\ch1_FREQ_CTRL_Z[1] ,\ch1_FREQ_CTRL_Z[0] ,\ch2_FREQ_CTRL_Z[24] ,\ch2_FREQ_CTRL_Z[23] ,\ch2_FREQ_CTRL_Z[22] ,\ch2_FREQ_CTRL_Z[21] ,\ch2_FREQ_CTRL_Z[20] ,\ch2_FREQ_CTRL_Z[19] ,\ch2_FREQ_CTRL_Z[18] ,\ch2_FREQ_CTRL_Z[17] ,\ch2_FREQ_CTRL_Z[16] ,\ch2_FREQ_CTRL_Z[15] ,\ch2_FREQ_CTRL_Z[14] ,\ch2_FREQ_CTRL_Z[13] ,\ch2_FREQ_CTRL_Z[12] ,\ch2_FREQ_CTRL_Z[11] ,\ch2_FREQ_CTRL_Z[10] ,\ch2_FREQ_CTRL_Z[9] ,\ch2_FREQ_CTRL_Z[8] ,\ch2_FREQ_CTRL_Z[7] ,\ch2_FREQ_CTRL_Z[6] ,\ch2_FREQ_CTRL_Z[5] ,\ch2_FREQ_CTRL_Z[4] ,\ch2_FREQ_CTRL_Z[3] ,\ch2_FREQ_CTRL_Z[2] ,\ch2_FREQ_CTRL_Z[1] ,\ch2_FREQ_CTRL_Z[0] ,\ch1_PHASE_CTRL_Z[9] ,\ch1_PHASE_CTRL_Z[8] ,\ch1_PHASE_CTRL_Z[7] ,\ch1_PHASE_CTRL_Z[6] ,\ch1_PHASE_CTRL_Z[5] ,\ch1_PHASE_CTRL_Z[4] ,\ch1_PHASE_CTRL_Z[3] ,\ch1_PHASE_CTRL_Z[2] ,\ch2_wave_select_Z[3] ,\ch2_wave_select_Z[2] ,\ch2_wave_select_Z[1] ,\ch2_wave_select_Z[0] }),
    .clk_i(sys_clk)
);

endmodule
