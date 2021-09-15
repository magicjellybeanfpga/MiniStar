module top (
    input  wire rst_n,
    input  wire clk_27m,
    output wire clk_pixel,
    output wire pll_disp_locked,
    output wire disp_error,
    output wire vga_vSync,
    output wire vga_hSync,
    output wire vga_colorEn,
    output wire tmds_clk_p,
    output wire tmds_clk_n,
    output wire [2:0] tmds_data_p,
    output wire [2:0] tmds_data_n,
    output wire O_hpram_reset_n,
    output wire O_hpram_ck,
    output wire O_hpram_ck_n,
    output wire O_hpram_cs_n,
    inout  wire IO_hpram_rwds,
    inout  wire [7:0] IO_hpram_dq
);

wire sync_rst_n;
wire pll_mcu_locked;
wire clk_162m;
wire clk_81m;

DFFC #(
    .INIT  (1'b0)
) sync_rst_n_reg (
    .CLEAR (!(rst_n && pll_mcu_locked)),
    .CLK   (clk_81m),
    .D     (1'b1),
    .Q     (sync_rst_n)
);

PLLVR #(
    .FCLKIN           ("27"),
    .IDIV_SEL         (1-1),
    .DYN_IDIV_SEL     ("false"),
    .FBDIV_SEL        (6-1),
    .DYN_FBDIV_SEL    ("false"),
    .ODIV_SEL         (4),
    .DYN_ODIV_SEL     ("false"),
    .PSDA_SEL         ("0000"),
    .DUTYDA_SEL       ("1000"),
    .DYN_DA_EN        ("false"),
    .DYN_SDIV_SEL     (2),
    .CLKOUT_FT_DIR    (1'b1),
    .CLKOUT_DLY_STEP  (0),
    .CLKOUTP_FT_DIR   (1'b1),
    .CLKOUTP_DLY_STEP (0),
    .CLKFB_SEL        ("internal"),
    .CLKOUTD_SRC      ("CLKOUT"),
    .CLKOUTD3_SRC     ("CLKOUT"),
    .CLKOUT_BYPASS    ("false"),
    .CLKOUTP_BYPASS   ("false"),
    .CLKOUTD_BYPASS   ("false"),
    .DEVICE           ("GW1NSR-4C")
) pll_mcu (
    .RESET    (1'b0),
    .RESET_P  (1'b0),
    .VREN     (1'b1),
    .CLKIN    (clk_27m),
    .CLKFB    (1'b0),
    .IDSEL    ({6{1'b0}}),
    .FBDSEL   ({6{1'b0}}),
    .ODSEL    ({6{1'b0}}),
    .PSDA     ({4{1'b0}}),
    .DUTYDA   ({4{1'b0}}),
    .FDLY     ({4{1'b0}}),
    .LOCK     (pll_mcu_locked),
    .CLKOUT   (clk_162m),
    .CLKOUTP  (),
    .CLKOUTD  (clk_81m),
    .CLKOUTD3 ()
);

wire ahb_hclk;
wire ahb_hrst;
wire ahb_hsel;
wire [31:0] ahb_haddr;
wire [1:0] ahb_htrans;
wire ahb_hwrite;
wire [2:0] ahb_hsize;
wire [2:0] ahb_hburst;
wire [3:0] ahb_hprot;
wire [1:0] ahb_memattr;
wire ahb_exreq;
wire [3:0] ahb_hmaster;
wire [31:0] ahb_hwdata;
wire ahb_hmastlock;
wire ahb_hreadymux;
wire ahb_hauser;
wire [3:0] ahb_hwuser;
wire [31:0] ahb_hrdata;
wire ahb_hreadyout;
wire ahb_hresp;
wire ahb_exresp;
wire [2:0] ahb_hruser;

assign ahb_exresp = 1'b0;
assign ahb_hruser = 3'b000;

Gowin_EMPU_Top mcu (
    // Reset & Clock
    .reset_n (rst_n),
    .sys_clk (clk_81m),
    // AHB
    .master_hclk (ahb_hclk),
    .master_hrst (ahb_hrst),
    .master_hsel (ahb_hsel),
    .master_haddr (ahb_haddr),
    .master_htrans (ahb_htrans),
    .master_hwrite (ahb_hwrite),
    .master_hsize (ahb_hsize),
    .master_hburst (ahb_hburst),
    .master_hprot (ahb_hprot),
    .master_memattr (ahb_memattr),
    .master_exreq (ahb_exreq),
    .master_hmaster (ahb_hmaster),
    .master_hwdata (ahb_hwdata),
    .master_hmastlock (ahb_hmastlock),
    .master_hreadymux (ahb_hreadymux),
    .master_hauser (ahb_hauser),
    .master_hwuser (ahb_hwuser),
    .master_hrdata (ahb_hrdata),
    .master_hreadyout (ahb_hreadyout),
    .master_hresp (ahb_hresp),
    .master_exresp (ahb_exresp),
    .master_hruser (ahb_hruser)
);

wire clk_hdmi;
wire vga_rst;
wire [7:0] vga_color_r;
wire [7:0] vga_color_g;
wire [7:0] vga_color_b;

DispEngine disp_engine (
    // Reset & Clock
    .reset (~sync_rst_n),
    .clk (clk_81m),
    // AHB
    .ahb_HADDR (ahb_haddr[15:0]),
    .ahb_HSEL (ahb_hsel),
    .ahb_HREADY (ahb_hreadymux),
    .ahb_HWRITE (ahb_hwrite),
    .ahb_HSIZE (ahb_hsize),
    .ahb_HBURST (ahb_hburst),
    .ahb_HPROT (ahb_hprot),
    .ahb_HTRANS (ahb_htrans),
    .ahb_HMASTLOCK (ahb_hmastlock),
    .ahb_HWDATA (ahb_hwdata),
    .ahb_HRDATA (ahb_hrdata),
    .ahb_HREADYOUT (ahb_hreadyout),
    .ahb_HRESP (ahb_hresp),
    // VGA
    .clk_in (clk_27m),
    .clk_hdmi (clk_hdmi),
    .clk_pixel (clk_pixel),
    .pll_locked (pll_disp_locked),
    .vga_rst (vga_rst),
    .vga_vSync (vga_vSync),
    .vga_hSync (vga_hSync),
    .vga_colorEn (vga_colorEn),
    .vga_color_r (vga_color_r),
    .vga_color_g (vga_color_g),
    .vga_color_b (vga_color_b),
    .vga_error (disp_error)
);

HyperRAM_Memory_Interface_Top hpram_controller (
    // Reset & Clock
    .rst_n (sync_rst_n),
    .clk (clk_27m),
    .memory_clk (clk_162m),
    .clk_out (),
    .pll_lock (pll_mcu_locked),
    // Control I/O
    .cmd (1'b0),
    .cmd_en (1'b0),
    .addr ({22{1'b0}}),
    .wr_data ({32{1'b0}}),
    .data_mask ({4{1'b0}}),
    .rd_data (),
    .rd_data_valid (),
    .init_calib (),
    // HyperBus
    .O_hpram_reset_n (O_hpram_reset_n),
    .O_hpram_cs_n (O_hpram_cs_n),
    .O_hpram_ck (O_hpram_ck),
    .O_hpram_ck_n (O_hpram_ck_n),
    .IO_hpram_rwds (IO_hpram_rwds),
    .IO_hpram_dq (IO_hpram_dq)
);

DVI_TX_Top hdmi_tx (
    .I_rst_n (~vga_rst),
    .I_serial_clk (clk_hdmi),
    .I_rgb_clk (clk_pixel),
    .I_rgb_vs (vga_vSync),
    .I_rgb_hs (vga_hSync),
    .I_rgb_de (vga_colorEn),
    .I_rgb_r (vga_color_r),
    .I_rgb_g (vga_color_g),
    .I_rgb_b (vga_color_b),
    .O_tmds_clk_p (tmds_clk_p),
    .O_tmds_clk_n (tmds_clk_n),
    .O_tmds_data_p (tmds_data_p),
    .O_tmds_data_n (tmds_data_n)
);

endmodule
