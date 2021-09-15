// Generator : SpinalHDL v1.4.3    git head : adf552d8f500e7419fff395b7049228e4bc5de26
// Component : DispEngine



module DispEngine (
  input      [15:0]   ahb_HADDR,
  input               ahb_HSEL,
  input               ahb_HREADY,
  input               ahb_HWRITE,
  input      [2:0]    ahb_HSIZE,
  input      [2:0]    ahb_HBURST,
  input      [3:0]    ahb_HPROT,
  input      [1:0]    ahb_HTRANS,
  input               ahb_HMASTLOCK,
  input      [31:0]   ahb_HWDATA,
  output reg [31:0]   ahb_HRDATA,
  output              ahb_HREADYOUT,
  output              ahb_HRESP,
  input               clk_in,
  output              clk_hdmi,
  output              clk_pixel,
  output              pll_locked,
  output              vga_rst,
  output              vga_vSync,
  output              vga_hSync,
  output              vga_colorEn,
  output     [7:0]    vga_color_r,
  output     [7:0]    vga_color_g,
  output     [7:0]    vga_color_b,
  output              vga_error,
  input               reset,
  input               clk
);
  wire                _zz_2;
  wire                _zz_3;
  wire                _zz_4;
  wire       [3:0]    _zz_5;
  wire       [3:0]    _zz_6;
  wire       [3:0]    _zz_7;
  wire                _zz_8;
  wire                _zz_9;
  wire                _zz_10;
  wire                _zz_11;
  wire                pllArea_pllvr_LOCK;
  wire                pllArea_pllvr_CLKOUT;
  wire                pllArea_pllvr_CLKOUTP;
  wire                pllArea_pllvr_CLKOUTD;
  wire                pllArea_pllvr_CLKOUTD3;
  wire                pllArea_clkDiv_CLKOUT;
  wire                pll_locked_buffercc_io_dataOut;
  wire                bufferCC_9_io_dataOut;
  wire                vgaArea_asyncArea_vgaCtrl_io_frameStart;
  wire                vgaArea_asyncArea_vgaCtrl_io_pixels_ready;
  wire                vgaArea_asyncArea_vgaCtrl_io_vga_vSync;
  wire                vgaArea_asyncArea_vgaCtrl_io_vga_hSync;
  wire                vgaArea_asyncArea_vgaCtrl_io_vga_colorEn;
  wire       [4:0]    vgaArea_asyncArea_vgaCtrl_io_vga_color_r;
  wire       [5:0]    vgaArea_asyncArea_vgaCtrl_io_vga_color_g;
  wire       [4:0]    vgaArea_asyncArea_vgaCtrl_io_vga_color_b;
  wire                vgaArea_asyncArea_vgaCtrl_io_error;
  wire       [11:0]   vgaArea_timings_buffercc_io_dataOut_h_syncStart;
  wire       [11:0]   vgaArea_timings_buffercc_io_dataOut_h_syncEnd;
  wire       [11:0]   vgaArea_timings_buffercc_io_dataOut_h_colorStart;
  wire       [11:0]   vgaArea_timings_buffercc_io_dataOut_h_colorEnd;
  wire                vgaArea_timings_buffercc_io_dataOut_h_polarity;
  wire       [11:0]   vgaArea_timings_buffercc_io_dataOut_v_syncStart;
  wire       [11:0]   vgaArea_timings_buffercc_io_dataOut_v_syncEnd;
  wire       [11:0]   vgaArea_timings_buffercc_io_dataOut_v_colorStart;
  wire       [11:0]   vgaArea_timings_buffercc_io_dataOut_v_colorEnd;
  wire                vgaArea_timings_buffercc_io_dataOut_v_polarity;
  wire       [15:0]   vgaArea_color_buffercc_io_dataOut;
  wire                vgaArea_softReset_buffercc_io_dataOut;
  wire                vgaArea_asyncArea_toggledOnFrameStart_buffercc_io_dataOut;
  wire                vga_colorEn_buffercc_io_dataOut;
  wire                vga_hSync_buffercc_io_dataOut;
  wire                vga_vSync_buffercc_io_dataOut;
  wire       [0:0]    _zz_12;
  wire       [0:0]    _zz_13;
  wire       [0:0]    _zz_14;
  wire       [0:0]    _zz_15;
  reg                 pllArea_pd;
  reg        [5:0]    pllArea_idiv;
  reg        [5:0]    pllArea_fbdiv;
  reg        [5:0]    pllArea_odiv;
  wire                vgaClk_clk;
  wire                vgaClk_reset;
  reg                 vgaArea_softReset;
  wire       [11:0]   vgaArea_defaultTimings_h_syncStart;
  wire       [11:0]   vgaArea_defaultTimings_h_syncEnd;
  wire       [11:0]   vgaArea_defaultTimings_h_colorStart;
  wire       [11:0]   vgaArea_defaultTimings_h_colorEnd;
  wire                vgaArea_defaultTimings_h_polarity;
  wire       [11:0]   vgaArea_defaultTimings_v_syncStart;
  wire       [11:0]   vgaArea_defaultTimings_v_syncEnd;
  wire       [11:0]   vgaArea_defaultTimings_v_colorStart;
  wire       [11:0]   vgaArea_defaultTimings_v_colorEnd;
  wire                vgaArea_defaultTimings_v_polarity;
  reg        [11:0]   vgaArea_timings_h_syncStart;
  reg        [11:0]   vgaArea_timings_h_syncEnd;
  reg        [11:0]   vgaArea_timings_h_colorStart;
  reg        [11:0]   vgaArea_timings_h_colorEnd;
  reg                 vgaArea_timings_h_polarity;
  reg        [11:0]   vgaArea_timings_v_syncStart;
  reg        [11:0]   vgaArea_timings_v_syncEnd;
  reg        [11:0]   vgaArea_timings_v_colorStart;
  reg        [11:0]   vgaArea_timings_v_colorEnd;
  reg                 vgaArea_timings_v_polarity;
  reg        [15:0]   vgaArea_color;
  wire                vgaArea_asyncArea_frameStart;
  reg                 vgaArea_asyncArea_toggledOnFrameStart;
  reg                 vgaArea_asyncArea_frameStart_regNext;
  wire       [11:0]   vgaArea_asyncArea_timingsReg_h_syncStart;
  wire       [11:0]   vgaArea_asyncArea_timingsReg_h_syncEnd;
  wire       [11:0]   vgaArea_asyncArea_timingsReg_h_colorStart;
  wire       [11:0]   vgaArea_asyncArea_timingsReg_h_colorEnd;
  wire                vgaArea_asyncArea_timingsReg_h_polarity;
  wire       [11:0]   vgaArea_asyncArea_timingsReg_v_syncStart;
  wire       [11:0]   vgaArea_asyncArea_timingsReg_v_syncEnd;
  wire       [11:0]   vgaArea_asyncArea_timingsReg_v_colorStart;
  wire       [11:0]   vgaArea_asyncArea_timingsReg_v_colorEnd;
  wire                vgaArea_asyncArea_timingsReg_v_polarity;
  wire       [15:0]   vgaArea_asyncArea_colorReg;
  wire       [4:0]    vgaArea_asyncArea_payload_r;
  wire       [5:0]    vgaArea_asyncArea_payload_g;
  wire       [4:0]    vgaArea_asyncArea_payload_b;
  wire                vgaArea_asyncArea_vga_vSync;
  wire                vgaArea_asyncArea_vga_hSync;
  wire                vgaArea_asyncArea_vga_colorEn;
  wire       [4:0]    vgaArea_asyncArea_vga_color_r;
  wire       [5:0]    vgaArea_asyncArea_vga_color_g;
  wire       [4:0]    vgaArea_asyncArea_vga_color_b;
  wire                vgaArea_toggledOnFrameStart;
  wire                _zz_1;
  reg                 _zz_1_regNext;
  reg        [15:0]   ahb_HADDR_regNextWhen;

  assign _zz_12 = ahb_HWDATA[0 : 0];
  assign _zz_13 = ahb_HWDATA[0 : 0];
  assign _zz_14 = ahb_HWDATA[0 : 0];
  assign _zz_15 = ahb_HWDATA[1 : 1];
  PLLVR #(
    .FCLKIN("27"),
    .IDIV_SEL(3),
    .DYN_IDIV_SEL("false"),
    .FBDIV_SEL(54),
    .DYN_FBDIV_SEL("false"),
    .ODIV_SEL(2),
    .DYN_ODIV_SEL("false"),
    .PSDA_SEL("0000"),
    .DUTYDA_SEL("1000"),
    .DYN_DA_EN("false"),
    .DYN_SDIV_SEL(2),
    .CLKOUT_FT_DIR(1'b1),
    .CLKOUT_DLY_STEP(0),
    .CLKOUTP_FT_DIR(1'b1),
    .CLKOUTP_DLY_STEP(0),
    .CLKFB_SEL("internal"),
    .CLKOUTD_SRC("CLKOUT"),
    .CLKOUTD3_SRC("CLKOUT"),
    .CLKOUT_BYPASS("false"),
    .CLKOUTP_BYPASS("false"),
    .CLKOUTD_BYPASS("false"),
    .DEVICE("GW1NSR-4C") 
  ) pllArea_pllvr (
    .RESET       (_zz_2                   ), //i
    .RESET_P     (pllArea_pd              ), //i
    .VREN        (_zz_3                   ), //i
    .CLKIN       (clk_in                  ), //i
    .CLKFB       (_zz_4                   ), //i
    .IDSEL       (pllArea_idiv[5:0]       ), //i
    .FBDSEL      (pllArea_fbdiv[5:0]      ), //i
    .ODSEL       (pllArea_odiv[5:0]       ), //i
    .PSDA        (_zz_5[3:0]              ), //i
    .DUTYDA      (_zz_6[3:0]              ), //i
    .FDLY        (_zz_7[3:0]              ), //i
    .LOCK        (pllArea_pllvr_LOCK      ), //o
    .CLKOUT      (pllArea_pllvr_CLKOUT    ), //o
    .CLKOUTP     (pllArea_pllvr_CLKOUTP   ), //o
    .CLKOUTD     (pllArea_pllvr_CLKOUTD   ), //o
    .CLKOUTD3    (pllArea_pllvr_CLKOUTD3  )  //o
  );
  CLKDIV #(
    .DIV_MODE("5"),
    .GSREN("false") 
  ) pllArea_clkDiv (
    .HCLKIN    (clk_hdmi               ), //i
    .RESETN    (_zz_8                  ), //i
    .CALIB     (_zz_9                  ), //i
    .CLKOUT    (pllArea_clkDiv_CLKOUT  )  //o
  );
  BufferCC pll_locked_buffercc (
    .io_dataIn     (pll_locked                      ), //i
    .io_dataOut    (pll_locked_buffercc_io_dataOut  ), //o
    .clk           (clk                             ), //i
    .reset         (reset                           )  //i
  );
  BufferCC_1 bufferCC_9 (
    .io_dataIn     (_zz_10                 ), //i
    .io_dataOut    (bufferCC_9_io_dataOut  ), //o
    .vgaClk_clk    (vgaClk_clk             ), //i
    .reset         (reset                  )  //i
  );
  VgaCtrl vgaArea_asyncArea_vgaCtrl (
    .io_softReset               (vgaArea_softReset_buffercc_io_dataOut            ), //i
    .io_timings_h_syncStart     (vgaArea_asyncArea_timingsReg_h_syncStart[11:0]   ), //i
    .io_timings_h_syncEnd       (vgaArea_asyncArea_timingsReg_h_syncEnd[11:0]     ), //i
    .io_timings_h_colorStart    (vgaArea_asyncArea_timingsReg_h_colorStart[11:0]  ), //i
    .io_timings_h_colorEnd      (vgaArea_asyncArea_timingsReg_h_colorEnd[11:0]    ), //i
    .io_timings_h_polarity      (vgaArea_asyncArea_timingsReg_h_polarity          ), //i
    .io_timings_v_syncStart     (vgaArea_asyncArea_timingsReg_v_syncStart[11:0]   ), //i
    .io_timings_v_syncEnd       (vgaArea_asyncArea_timingsReg_v_syncEnd[11:0]     ), //i
    .io_timings_v_colorStart    (vgaArea_asyncArea_timingsReg_v_colorStart[11:0]  ), //i
    .io_timings_v_colorEnd      (vgaArea_asyncArea_timingsReg_v_colorEnd[11:0]    ), //i
    .io_timings_v_polarity      (vgaArea_asyncArea_timingsReg_v_polarity          ), //i
    .io_frameStart              (vgaArea_asyncArea_vgaCtrl_io_frameStart          ), //o
    .io_pixels_valid            (_zz_11                                           ), //i
    .io_pixels_ready            (vgaArea_asyncArea_vgaCtrl_io_pixels_ready        ), //o
    .io_pixels_payload_r        (vgaArea_asyncArea_payload_r[4:0]                 ), //i
    .io_pixels_payload_g        (vgaArea_asyncArea_payload_g[5:0]                 ), //i
    .io_pixels_payload_b        (vgaArea_asyncArea_payload_b[4:0]                 ), //i
    .io_vga_vSync               (vgaArea_asyncArea_vgaCtrl_io_vga_vSync           ), //o
    .io_vga_hSync               (vgaArea_asyncArea_vgaCtrl_io_vga_hSync           ), //o
    .io_vga_colorEn             (vgaArea_asyncArea_vgaCtrl_io_vga_colorEn         ), //o
    .io_vga_color_r             (vgaArea_asyncArea_vgaCtrl_io_vga_color_r[4:0]    ), //o
    .io_vga_color_g             (vgaArea_asyncArea_vgaCtrl_io_vga_color_g[5:0]    ), //o
    .io_vga_color_b             (vgaArea_asyncArea_vgaCtrl_io_vga_color_b[4:0]    ), //o
    .io_error                   (vgaArea_asyncArea_vgaCtrl_io_error               ), //o
    .vgaClk_clk                 (vgaClk_clk                                       ), //i
    .vgaClk_reset               (vgaClk_reset                                     )  //i
  );
  BufferCC_2 vgaArea_timings_buffercc (
    .io_dataIn_h_syncStart      (vgaArea_timings_h_syncStart[11:0]                       ), //i
    .io_dataIn_h_syncEnd        (vgaArea_timings_h_syncEnd[11:0]                         ), //i
    .io_dataIn_h_colorStart     (vgaArea_timings_h_colorStart[11:0]                      ), //i
    .io_dataIn_h_colorEnd       (vgaArea_timings_h_colorEnd[11:0]                        ), //i
    .io_dataIn_h_polarity       (vgaArea_timings_h_polarity                              ), //i
    .io_dataIn_v_syncStart      (vgaArea_timings_v_syncStart[11:0]                       ), //i
    .io_dataIn_v_syncEnd        (vgaArea_timings_v_syncEnd[11:0]                         ), //i
    .io_dataIn_v_colorStart     (vgaArea_timings_v_colorStart[11:0]                      ), //i
    .io_dataIn_v_colorEnd       (vgaArea_timings_v_colorEnd[11:0]                        ), //i
    .io_dataIn_v_polarity       (vgaArea_timings_v_polarity                              ), //i
    .io_dataOut_h_syncStart     (vgaArea_timings_buffercc_io_dataOut_h_syncStart[11:0]   ), //o
    .io_dataOut_h_syncEnd       (vgaArea_timings_buffercc_io_dataOut_h_syncEnd[11:0]     ), //o
    .io_dataOut_h_colorStart    (vgaArea_timings_buffercc_io_dataOut_h_colorStart[11:0]  ), //o
    .io_dataOut_h_colorEnd      (vgaArea_timings_buffercc_io_dataOut_h_colorEnd[11:0]    ), //o
    .io_dataOut_h_polarity      (vgaArea_timings_buffercc_io_dataOut_h_polarity          ), //o
    .io_dataOut_v_syncStart     (vgaArea_timings_buffercc_io_dataOut_v_syncStart[11:0]   ), //o
    .io_dataOut_v_syncEnd       (vgaArea_timings_buffercc_io_dataOut_v_syncEnd[11:0]     ), //o
    .io_dataOut_v_colorStart    (vgaArea_timings_buffercc_io_dataOut_v_colorStart[11:0]  ), //o
    .io_dataOut_v_colorEnd      (vgaArea_timings_buffercc_io_dataOut_v_colorEnd[11:0]    ), //o
    .io_dataOut_v_polarity      (vgaArea_timings_buffercc_io_dataOut_v_polarity          ), //o
    .vgaClk_clk                 (vgaClk_clk                                              ), //i
    .vgaClk_reset               (vgaClk_reset                                            )  //i
  );
  BufferCC_3 vgaArea_color_buffercc (
    .io_dataIn       (vgaArea_color[15:0]                      ), //i
    .io_dataOut      (vgaArea_color_buffercc_io_dataOut[15:0]  ), //o
    .vgaClk_clk      (vgaClk_clk                               ), //i
    .vgaClk_reset    (vgaClk_reset                             )  //i
  );
  BufferCC_4 vgaArea_softReset_buffercc (
    .io_dataIn       (vgaArea_softReset                      ), //i
    .io_dataOut      (vgaArea_softReset_buffercc_io_dataOut  ), //o
    .vgaClk_clk      (vgaClk_clk                             ), //i
    .vgaClk_reset    (vgaClk_reset                           )  //i
  );
  BufferCC vgaArea_asyncArea_toggledOnFrameStart_buffercc (
    .io_dataIn     (vgaArea_asyncArea_toggledOnFrameStart                      ), //i
    .io_dataOut    (vgaArea_asyncArea_toggledOnFrameStart_buffercc_io_dataOut  ), //o
    .clk           (clk                                                        ), //i
    .reset         (reset                                                      )  //i
  );
  BufferCC vga_colorEn_buffercc (
    .io_dataIn     (vga_colorEn                      ), //i
    .io_dataOut    (vga_colorEn_buffercc_io_dataOut  ), //o
    .clk           (clk                              ), //i
    .reset         (reset                            )  //i
  );
  BufferCC vga_hSync_buffercc (
    .io_dataIn     (vga_hSync                      ), //i
    .io_dataOut    (vga_hSync_buffercc_io_dataOut  ), //o
    .clk           (clk                            ), //i
    .reset         (reset                          )  //i
  );
  BufferCC vga_vSync_buffercc (
    .io_dataIn     (vga_vSync                      ), //i
    .io_dataOut    (vga_vSync_buffercc_io_dataOut  ), //o
    .clk           (clk                            ), //i
    .reset         (reset                          )  //i
  );
  assign _zz_2 = 1'b0;
  assign _zz_3 = 1'b1;
  assign _zz_4 = 1'b0;
  assign _zz_5 = 4'b0000;
  assign _zz_6 = 4'b0000;
  assign _zz_7 = 4'b0000;
  assign pll_locked = pllArea_pllvr_LOCK;
  assign clk_hdmi = pllArea_pllvr_CLKOUT;
  assign _zz_8 = 1'b1;
  assign _zz_9 = 1'b0;
  assign clk_pixel = pllArea_clkDiv_CLKOUT;
  assign vgaClk_clk = clk_pixel;
  assign _zz_10 = 1'b0;
  assign vgaClk_reset = bufferCC_9_io_dataOut;
  assign vgaArea_defaultTimings_h_syncStart = 12'h027;
  assign vgaArea_defaultTimings_h_colorStart = 12'h103;
  assign vgaArea_defaultTimings_h_colorEnd = 12'h603;
  assign vgaArea_defaultTimings_h_syncEnd = 12'h671;
  assign vgaArea_defaultTimings_v_syncStart = 12'h004;
  assign vgaArea_defaultTimings_v_colorStart = 12'h018;
  assign vgaArea_defaultTimings_v_colorEnd = 12'h2e8;
  assign vgaArea_defaultTimings_v_syncEnd = 12'h2ed;
  assign vgaArea_defaultTimings_h_polarity = 1'b0;
  assign vgaArea_defaultTimings_v_polarity = 1'b0;
  assign vgaArea_asyncArea_timingsReg_h_syncStart = vgaArea_timings_buffercc_io_dataOut_h_syncStart;
  assign vgaArea_asyncArea_timingsReg_h_syncEnd = vgaArea_timings_buffercc_io_dataOut_h_syncEnd;
  assign vgaArea_asyncArea_timingsReg_h_colorStart = vgaArea_timings_buffercc_io_dataOut_h_colorStart;
  assign vgaArea_asyncArea_timingsReg_h_colorEnd = vgaArea_timings_buffercc_io_dataOut_h_colorEnd;
  assign vgaArea_asyncArea_timingsReg_h_polarity = vgaArea_timings_buffercc_io_dataOut_h_polarity;
  assign vgaArea_asyncArea_timingsReg_v_syncStart = vgaArea_timings_buffercc_io_dataOut_v_syncStart;
  assign vgaArea_asyncArea_timingsReg_v_syncEnd = vgaArea_timings_buffercc_io_dataOut_v_syncEnd;
  assign vgaArea_asyncArea_timingsReg_v_colorStart = vgaArea_timings_buffercc_io_dataOut_v_colorStart;
  assign vgaArea_asyncArea_timingsReg_v_colorEnd = vgaArea_timings_buffercc_io_dataOut_v_colorEnd;
  assign vgaArea_asyncArea_timingsReg_v_polarity = vgaArea_timings_buffercc_io_dataOut_v_polarity;
  assign vgaArea_asyncArea_colorReg = vgaArea_color_buffercc_io_dataOut;
  assign vgaArea_asyncArea_payload_r = vgaArea_asyncArea_colorReg[15 : 11];
  assign vgaArea_asyncArea_payload_g = vgaArea_asyncArea_colorReg[10 : 5];
  assign vgaArea_asyncArea_payload_b = vgaArea_asyncArea_colorReg[4 : 0];
  assign vgaArea_asyncArea_frameStart = vgaArea_asyncArea_vgaCtrl_io_frameStart;
  assign _zz_11 = 1'b1;
  assign vgaArea_asyncArea_vga_vSync = vgaArea_asyncArea_vgaCtrl_io_vga_vSync;
  assign vgaArea_asyncArea_vga_hSync = vgaArea_asyncArea_vgaCtrl_io_vga_hSync;
  assign vgaArea_asyncArea_vga_colorEn = vgaArea_asyncArea_vgaCtrl_io_vga_colorEn;
  assign vgaArea_asyncArea_vga_color_r = vgaArea_asyncArea_vgaCtrl_io_vga_color_r;
  assign vgaArea_asyncArea_vga_color_g = vgaArea_asyncArea_vgaCtrl_io_vga_color_g;
  assign vgaArea_asyncArea_vga_color_b = vgaArea_asyncArea_vgaCtrl_io_vga_color_b;
  assign vga_error = vgaArea_asyncArea_vgaCtrl_io_error;
  assign vga_rst = vgaClk_reset;
  assign vga_vSync = vgaArea_asyncArea_vga_vSync;
  assign vga_hSync = vgaArea_asyncArea_vga_hSync;
  assign vga_colorEn = vgaArea_asyncArea_vga_colorEn;
  assign vga_color_r = ({3'd0,vgaArea_asyncArea_vga_color_r} <<< 3);
  assign vga_color_g = ({2'd0,vgaArea_asyncArea_vga_color_g} <<< 2);
  assign vga_color_b = ({3'd0,vgaArea_asyncArea_vga_color_b} <<< 3);
  assign vgaArea_toggledOnFrameStart = vgaArea_asyncArea_toggledOnFrameStart_buffercc_io_dataOut;
  assign _zz_1 = ((ahb_HSEL && (ahb_HTRANS == 2'b10)) && ahb_HWRITE);
  assign ahb_HREADYOUT = 1'b1;
  assign ahb_HRESP = 1'b0;
  always @ (*) begin
    ahb_HRDATA = 32'h0;
    case(ahb_HADDR_regNextWhen)
      16'h1000 : begin
        ahb_HRDATA[0 : 0] = pllArea_pd;
        ahb_HRDATA[1 : 1] = pll_locked_buffercc_io_dataOut;
      end
      16'h1004 : begin
        ahb_HRDATA[5 : 0] = pllArea_idiv;
      end
      16'h1008 : begin
        ahb_HRDATA[5 : 0] = pllArea_fbdiv;
      end
      16'h100c : begin
        ahb_HRDATA[5 : 0] = pllArea_odiv;
      end
      16'h2000 : begin
        ahb_HRDATA[0 : 0] = vgaArea_softReset;
        ahb_HRDATA[1 : 1] = vga_colorEn_buffercc_io_dataOut;
        ahb_HRDATA[2 : 2] = vga_hSync_buffercc_io_dataOut;
        ahb_HRDATA[3 : 3] = vga_vSync_buffercc_io_dataOut;
        ahb_HRDATA[31 : 16] = vgaArea_color;
      end
      16'h2004 : begin
        ahb_HRDATA[0 : 0] = vgaArea_timings_h_polarity;
        ahb_HRDATA[1 : 1] = vgaArea_timings_v_polarity;
      end
      16'h2008 : begin
        ahb_HRDATA[11 : 0] = vgaArea_timings_h_syncStart;
        ahb_HRDATA[27 : 16] = vgaArea_timings_h_syncEnd;
      end
      16'h200c : begin
        ahb_HRDATA[11 : 0] = vgaArea_timings_h_colorStart;
        ahb_HRDATA[27 : 16] = vgaArea_timings_h_colorEnd;
      end
      16'h2010 : begin
        ahb_HRDATA[11 : 0] = vgaArea_timings_v_syncStart;
        ahb_HRDATA[27 : 16] = vgaArea_timings_v_syncEnd;
      end
      16'h2014 : begin
        ahb_HRDATA[11 : 0] = vgaArea_timings_v_colorStart;
        ahb_HRDATA[27 : 16] = vgaArea_timings_v_colorEnd;
      end
      default : begin
      end
    endcase
  end

  always @ (posedge clk or posedge reset) begin
    if (reset) begin
      pllArea_pd <= 1'b1;
      pllArea_idiv <= 6'h3c;
      pllArea_fbdiv <= 6'h09;
      pllArea_odiv <= 6'h3e;
      vgaArea_softReset <= 1'b1;
      vgaArea_timings_h_syncStart <= vgaArea_defaultTimings_h_syncStart;
      vgaArea_timings_h_syncEnd <= vgaArea_defaultTimings_h_syncEnd;
      vgaArea_timings_h_colorStart <= vgaArea_defaultTimings_h_colorStart;
      vgaArea_timings_h_colorEnd <= vgaArea_defaultTimings_h_colorEnd;
      vgaArea_timings_h_polarity <= vgaArea_defaultTimings_h_polarity;
      vgaArea_timings_v_syncStart <= vgaArea_defaultTimings_v_syncStart;
      vgaArea_timings_v_syncEnd <= vgaArea_defaultTimings_v_syncEnd;
      vgaArea_timings_v_colorStart <= vgaArea_defaultTimings_v_colorStart;
      vgaArea_timings_v_colorEnd <= vgaArea_defaultTimings_v_colorEnd;
      vgaArea_timings_v_polarity <= vgaArea_defaultTimings_v_polarity;
      vgaArea_color <= 16'hffff;
      _zz_1_regNext <= 1'b0;
    end else begin
      _zz_1_regNext <= _zz_1;
      case(ahb_HADDR_regNextWhen)
        16'h1000 : begin
          if(_zz_1_regNext)begin
            pllArea_pd <= _zz_12[0];
          end
        end
        16'h1004 : begin
          if(_zz_1_regNext)begin
            pllArea_idiv <= ahb_HWDATA[5 : 0];
          end
        end
        16'h1008 : begin
          if(_zz_1_regNext)begin
            pllArea_fbdiv <= ahb_HWDATA[5 : 0];
          end
        end
        16'h100c : begin
          if(_zz_1_regNext)begin
            pllArea_odiv <= ahb_HWDATA[5 : 0];
          end
        end
        16'h2000 : begin
          if(_zz_1_regNext)begin
            vgaArea_softReset <= _zz_13[0];
            vgaArea_color <= ahb_HWDATA[31 : 16];
          end
        end
        16'h2004 : begin
          if(_zz_1_regNext)begin
            vgaArea_timings_h_polarity <= _zz_14[0];
            vgaArea_timings_v_polarity <= _zz_15[0];
          end
        end
        16'h2008 : begin
          if(_zz_1_regNext)begin
            vgaArea_timings_h_syncStart <= ahb_HWDATA[11 : 0];
            vgaArea_timings_h_syncEnd <= ahb_HWDATA[27 : 16];
          end
        end
        16'h200c : begin
          if(_zz_1_regNext)begin
            vgaArea_timings_h_colorStart <= ahb_HWDATA[11 : 0];
            vgaArea_timings_h_colorEnd <= ahb_HWDATA[27 : 16];
          end
        end
        16'h2010 : begin
          if(_zz_1_regNext)begin
            vgaArea_timings_v_syncStart <= ahb_HWDATA[11 : 0];
            vgaArea_timings_v_syncEnd <= ahb_HWDATA[27 : 16];
          end
        end
        16'h2014 : begin
          if(_zz_1_regNext)begin
            vgaArea_timings_v_colorStart <= ahb_HWDATA[11 : 0];
            vgaArea_timings_v_colorEnd <= ahb_HWDATA[27 : 16];
          end
        end
        default : begin
        end
      endcase
    end
  end

  always @ (posedge vgaClk_clk or posedge vgaClk_reset) begin
    if (vgaClk_reset) begin
      vgaArea_asyncArea_toggledOnFrameStart <= 1'b0;
      vgaArea_asyncArea_frameStart_regNext <= 1'b0;
    end else begin
      vgaArea_asyncArea_frameStart_regNext <= vgaArea_asyncArea_frameStart;
      if((vgaArea_asyncArea_frameStart != vgaArea_asyncArea_frameStart_regNext))begin
        vgaArea_asyncArea_toggledOnFrameStart <= (! vgaArea_asyncArea_toggledOnFrameStart);
      end
    end
  end

  always @ (posedge clk) begin
    if((((ahb_HSEL && (ahb_HTRANS == 2'b10)) && (! ahb_HWRITE)) || _zz_1))begin
      ahb_HADDR_regNextWhen <= ahb_HADDR;
    end
  end


endmodule

//BufferCC replaced by BufferCC

//BufferCC replaced by BufferCC

//BufferCC replaced by BufferCC

//BufferCC replaced by BufferCC

module BufferCC_4 (
  input               io_dataIn,
  output              io_dataOut,
  input               vgaClk_clk,
  input               vgaClk_reset
);
  (* async_reg = "true" *) reg                 buffers_0;
  (* async_reg = "true" *) reg                 buffers_1;

  assign io_dataOut = buffers_1;
  always @ (posedge vgaClk_clk or posedge vgaClk_reset) begin
    if (vgaClk_reset) begin
      buffers_0 <= 1'b1;
      buffers_1 <= 1'b1;
    end else begin
      buffers_0 <= io_dataIn;
      buffers_1 <= buffers_0;
    end
  end


endmodule

module BufferCC_3 (
  input      [15:0]   io_dataIn,
  output     [15:0]   io_dataOut,
  input               vgaClk_clk,
  input               vgaClk_reset
);
  (* async_reg = "true" *) reg        [15:0]   buffers_0;
  (* async_reg = "true" *) reg        [15:0]   buffers_1;

  assign io_dataOut = buffers_1;
  always @ (posedge vgaClk_clk) begin
    buffers_0 <= io_dataIn;
    buffers_1 <= buffers_0;
  end


endmodule

module BufferCC_2 (
  input      [11:0]   io_dataIn_h_syncStart,
  input      [11:0]   io_dataIn_h_syncEnd,
  input      [11:0]   io_dataIn_h_colorStart,
  input      [11:0]   io_dataIn_h_colorEnd,
  input               io_dataIn_h_polarity,
  input      [11:0]   io_dataIn_v_syncStart,
  input      [11:0]   io_dataIn_v_syncEnd,
  input      [11:0]   io_dataIn_v_colorStart,
  input      [11:0]   io_dataIn_v_colorEnd,
  input               io_dataIn_v_polarity,
  output     [11:0]   io_dataOut_h_syncStart,
  output     [11:0]   io_dataOut_h_syncEnd,
  output     [11:0]   io_dataOut_h_colorStart,
  output     [11:0]   io_dataOut_h_colorEnd,
  output              io_dataOut_h_polarity,
  output     [11:0]   io_dataOut_v_syncStart,
  output     [11:0]   io_dataOut_v_syncEnd,
  output     [11:0]   io_dataOut_v_colorStart,
  output     [11:0]   io_dataOut_v_colorEnd,
  output              io_dataOut_v_polarity,
  input               vgaClk_clk,
  input               vgaClk_reset
);
  (* async_reg = "true" *) reg        [11:0]   buffers_0_h_syncStart;
  (* async_reg = "true" *) reg        [11:0]   buffers_0_h_syncEnd;
  (* async_reg = "true" *) reg        [11:0]   buffers_0_h_colorStart;
  (* async_reg = "true" *) reg        [11:0]   buffers_0_h_colorEnd;
  (* async_reg = "true" *) reg                 buffers_0_h_polarity;
  (* async_reg = "true" *) reg        [11:0]   buffers_0_v_syncStart;
  (* async_reg = "true" *) reg        [11:0]   buffers_0_v_syncEnd;
  (* async_reg = "true" *) reg        [11:0]   buffers_0_v_colorStart;
  (* async_reg = "true" *) reg        [11:0]   buffers_0_v_colorEnd;
  (* async_reg = "true" *) reg                 buffers_0_v_polarity;
  (* async_reg = "true" *) reg        [11:0]   buffers_1_h_syncStart;
  (* async_reg = "true" *) reg        [11:0]   buffers_1_h_syncEnd;
  (* async_reg = "true" *) reg        [11:0]   buffers_1_h_colorStart;
  (* async_reg = "true" *) reg        [11:0]   buffers_1_h_colorEnd;
  (* async_reg = "true" *) reg                 buffers_1_h_polarity;
  (* async_reg = "true" *) reg        [11:0]   buffers_1_v_syncStart;
  (* async_reg = "true" *) reg        [11:0]   buffers_1_v_syncEnd;
  (* async_reg = "true" *) reg        [11:0]   buffers_1_v_colorStart;
  (* async_reg = "true" *) reg        [11:0]   buffers_1_v_colorEnd;
  (* async_reg = "true" *) reg                 buffers_1_v_polarity;

  assign io_dataOut_h_syncStart = buffers_1_h_syncStart;
  assign io_dataOut_h_syncEnd = buffers_1_h_syncEnd;
  assign io_dataOut_h_colorStart = buffers_1_h_colorStart;
  assign io_dataOut_h_colorEnd = buffers_1_h_colorEnd;
  assign io_dataOut_h_polarity = buffers_1_h_polarity;
  assign io_dataOut_v_syncStart = buffers_1_v_syncStart;
  assign io_dataOut_v_syncEnd = buffers_1_v_syncEnd;
  assign io_dataOut_v_colorStart = buffers_1_v_colorStart;
  assign io_dataOut_v_colorEnd = buffers_1_v_colorEnd;
  assign io_dataOut_v_polarity = buffers_1_v_polarity;
  always @ (posedge vgaClk_clk) begin
    buffers_0_h_syncStart <= io_dataIn_h_syncStart;
    buffers_0_h_syncEnd <= io_dataIn_h_syncEnd;
    buffers_0_h_colorStart <= io_dataIn_h_colorStart;
    buffers_0_h_colorEnd <= io_dataIn_h_colorEnd;
    buffers_0_h_polarity <= io_dataIn_h_polarity;
    buffers_0_v_syncStart <= io_dataIn_v_syncStart;
    buffers_0_v_syncEnd <= io_dataIn_v_syncEnd;
    buffers_0_v_colorStart <= io_dataIn_v_colorStart;
    buffers_0_v_colorEnd <= io_dataIn_v_colorEnd;
    buffers_0_v_polarity <= io_dataIn_v_polarity;
    buffers_1_h_syncStart <= buffers_0_h_syncStart;
    buffers_1_h_syncEnd <= buffers_0_h_syncEnd;
    buffers_1_h_colorStart <= buffers_0_h_colorStart;
    buffers_1_h_colorEnd <= buffers_0_h_colorEnd;
    buffers_1_h_polarity <= buffers_0_h_polarity;
    buffers_1_v_syncStart <= buffers_0_v_syncStart;
    buffers_1_v_syncEnd <= buffers_0_v_syncEnd;
    buffers_1_v_colorStart <= buffers_0_v_colorStart;
    buffers_1_v_colorEnd <= buffers_0_v_colorEnd;
    buffers_1_v_polarity <= buffers_0_v_polarity;
  end


endmodule

module VgaCtrl (
  input               io_softReset,
  input      [11:0]   io_timings_h_syncStart,
  input      [11:0]   io_timings_h_syncEnd,
  input      [11:0]   io_timings_h_colorStart,
  input      [11:0]   io_timings_h_colorEnd,
  input               io_timings_h_polarity,
  input      [11:0]   io_timings_v_syncStart,
  input      [11:0]   io_timings_v_syncEnd,
  input      [11:0]   io_timings_v_colorStart,
  input      [11:0]   io_timings_v_colorEnd,
  input               io_timings_v_polarity,
  output              io_frameStart,
  input               io_pixels_valid,
  output              io_pixels_ready,
  input      [4:0]    io_pixels_payload_r,
  input      [5:0]    io_pixels_payload_g,
  input      [4:0]    io_pixels_payload_b,
  output              io_vga_vSync,
  output              io_vga_hSync,
  output              io_vga_colorEn,
  output     [4:0]    io_vga_color_r,
  output     [5:0]    io_vga_color_g,
  output     [4:0]    io_vga_color_b,
  output              io_error,
  input               vgaClk_clk,
  input               vgaClk_reset
);
  reg        [11:0]   h_counter;
  wire                h_syncStart;
  wire                h_syncEnd;
  wire                h_colorStart;
  wire                h_colorEnd;
  reg                 h_sync;
  reg                 h_colorEn;
  reg        [11:0]   v_counter;
  wire                v_syncStart;
  wire                v_syncEnd;
  wire                v_colorStart;
  wire                v_colorEnd;
  reg                 v_sync;
  reg                 v_colorEn;
  wire                colorEn;

  assign h_syncStart = (h_counter == io_timings_h_syncStart);
  assign h_syncEnd = (h_counter == io_timings_h_syncEnd);
  assign h_colorStart = (h_counter == io_timings_h_colorStart);
  assign h_colorEnd = (h_counter == io_timings_h_colorEnd);
  assign v_syncStart = (v_counter == io_timings_v_syncStart);
  assign v_syncEnd = (v_counter == io_timings_v_syncEnd);
  assign v_colorStart = (v_counter == io_timings_v_colorStart);
  assign v_colorEnd = (v_counter == io_timings_v_colorEnd);
  assign colorEn = (h_colorEn && v_colorEn);
  assign io_pixels_ready = colorEn;
  assign io_error = (colorEn && (! io_pixels_valid));
  assign io_frameStart = (v_syncStart && h_syncStart);
  assign io_vga_hSync = (h_sync ^ io_timings_h_polarity);
  assign io_vga_vSync = (v_sync ^ io_timings_v_polarity);
  assign io_vga_colorEn = colorEn;
  assign io_vga_color_r = io_pixels_payload_r;
  assign io_vga_color_g = io_pixels_payload_g;
  assign io_vga_color_b = io_pixels_payload_b;
  always @ (posedge vgaClk_clk or posedge vgaClk_reset) begin
    if (vgaClk_reset) begin
      h_counter <= 12'h0;
      h_sync <= 1'b0;
      h_colorEn <= 1'b0;
      v_counter <= 12'h0;
      v_sync <= 1'b0;
      v_colorEn <= 1'b0;
    end else begin
      if(1'b1)begin
        h_counter <= (h_counter + 12'h001);
        if(h_syncEnd)begin
          h_counter <= 12'h0;
        end
      end
      if(h_syncStart)begin
        h_sync <= 1'b1;
      end
      if(h_syncEnd)begin
        h_sync <= 1'b0;
      end
      if(h_colorStart)begin
        h_colorEn <= 1'b1;
      end
      if(h_colorEnd)begin
        h_colorEn <= 1'b0;
      end
      if(io_softReset)begin
        h_counter <= 12'h0;
        h_sync <= 1'b0;
        h_colorEn <= 1'b0;
      end
      if(h_syncEnd)begin
        v_counter <= (v_counter + 12'h001);
        if(v_syncEnd)begin
          v_counter <= 12'h0;
        end
      end
      if(v_syncStart)begin
        v_sync <= 1'b1;
      end
      if(v_syncEnd)begin
        v_sync <= 1'b0;
      end
      if(v_colorStart)begin
        v_colorEn <= 1'b1;
      end
      if(v_colorEnd)begin
        v_colorEn <= 1'b0;
      end
      if(io_softReset)begin
        v_counter <= 12'h0;
        v_sync <= 1'b0;
        v_colorEn <= 1'b0;
      end
    end
  end


endmodule

module BufferCC_1 (
  input               io_dataIn,
  output              io_dataOut,
  input               vgaClk_clk,
  input               reset
);
  (* async_reg = "true" *) reg                 buffers_0;
  (* async_reg = "true" *) reg                 buffers_1;

  assign io_dataOut = buffers_1;
  always @ (posedge vgaClk_clk or posedge reset) begin
    if (reset) begin
      buffers_0 <= 1'b1;
      buffers_1 <= 1'b1;
    end else begin
      buffers_0 <= io_dataIn;
      buffers_1 <= buffers_0;
    end
  end


endmodule

module BufferCC (
  input               io_dataIn,
  output              io_dataOut,
  input               clk,
  input               reset
);
  (* async_reg = "true" *) reg                 buffers_0;
  (* async_reg = "true" *) reg                 buffers_1;

  assign io_dataOut = buffers_1;
  always @ (posedge clk or posedge reset) begin
    if (reset) begin
      buffers_0 <= 1'b0;
      buffers_1 <= 1'b0;
    end else begin
      buffers_0 <= io_dataIn;
      buffers_1 <= buffers_0;
    end
  end


endmodule
