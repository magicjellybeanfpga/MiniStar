module memhub (
    input spiclk, // spi clock 133MHz
    input reset,
    // from ADBus
    input mc1,
    input mc0,
    input [7:0] adin,
    output [7:0] adout,
    output reg adz,
    // to spi flash
    output spiclken, // narrow
    output spiss2, // wide
    input [3:0] spiin,
    output [3:0] spiout,
    output spiz0,
    output spiz1
);


localparam IDLE     = 4'b0001;
localparam SENDCMD  = 4'b0010;
localparam SENDADDR = 4'b0100;
localparam READDAT  = 4'b1000;

(* mark_debug = "true" *) reg [3:0] state = IDLE;
(* mark_debug = "true" *) reg [23:0] offset; // busrom, 12M
reg [7:0] spicmd;
reg [2:0] spicmdcnt = 7;
reg [2:0] spiaddrcnt = 6; // 6->1clk地址, 0 M74 | 5clk dummy + 2clk 读取
// adbus
reg ahready = 0, rwready = 0, adrw = 0, waital = 0;
(* mark_debug = "true" *) reg [15:0] addr;
reg [7:0] flashdout;
wire [3:0] quadaddr = spiaddrcnt > 2?offset[23:20]:(spiaddrcnt == 2?adin[7:4]:(spiaddrcnt == 1?addr[3:0]:4'b1110)); // M[5..4]=10  
assign spiout = (state == SENDCMD)?{3'b000, spicmd[7]}:(state == SENDADDR)?quadaddr:4'b0000;

assign spiz0 = (state != SENDCMD) && (state != SENDADDR);
assign spiz1 = (state == READDAT) || (state == SENDCMD);

// switch bank/etc
reg [7:0] io_bank_switch = 0;   // 00 r/w
reg [7:0] io_bios_bsw = 0;      // 0A r/w
reg [7:0] io_lcd_segment = 0;   // 0D r/w
reg is_4000_nor = 0;
wire is_4000 = addr[15:14] == 'b01;  // 4000..7FFF ROM/nor, ROA/BSW/vol
wire is_8000 = addr[15:14] == 'b10;  // 8000..BFFF ROM/nor, ROA/BSW/vol
wire is_bios = addr[15:13] == 'b110; // C000..DFFF ROM/nor, BBS
wire is_boot = addr[15:13] == 'b111; // E000..FFFF ROM, fixed

// free and clk
reg clk_spi = 0;
reg [2:0] mc0rwcnt;
reg [2:0] mc0alcnt;
(* mark_debug = "true" *) reg [9:0] adzcnt; // 579
reg mc0r = 1;
reg mc1r = 1;
reg spissn = 1;
assign spiclken = (state != IDLE) && (ahready) && (!waital);
assign spiss2 = (state != IDLE);

assign adout = adz?8'b0:flashdout;

// 以7.5ns误差对齐到MC0
always @(posedge spiclk) begin
    //if (reset) begin
    //    mc0r <= 1;
    //    mc1r <= 1;
    //end else begin
        mc0r <= mc0;
        mc1r <= mc1;
    //end
end
reg [5:0]sscnt;
reg bypasscmd = 0;
always @(posedge spiclk) begin
    if (reset) begin
        rwready <= 0;
        adz <= 1;
        waital <= 0;
        ahready <= 0;
    end else begin
        // MC0下降沿
        if (mc0r & ~mc0) begin
            ahready <= 1;
            mc0alcnt <= 3; // 2 clock, 15ns
            addr[15:8] <= adin; // 10ns后adin取样AL
            sscnt <= bypasscmd?14:22;
            adzcnt <= 0;
        end else if (mc1r & ~mc1) begin
            // MC1下降沿, 50ns从MC0取样RW
            mc0rwcnt <= 7;
            if (adzcnt < 15)
                adzcnt <= 15; // 13.5=101.25(135.5-35) 15=112.5(135.5-20)
            waital <= 0;
            addr[7:0] <= adin;
        end else if (mc1 & ~mc0) begin
            adzcnt <= adzcnt + 1'b1; // 统计AL区间长度
        end else if (adzcnt) begin
            adzcnt <= adzcnt - 1'b1;
        end
        if (~mc1r & mc1) begin
            // MC1上升沿
            adz <= 1;
        end
        // out of ss
        if (adzcnt == 1 & mc0r) begin
            adz <= 0;
            //adout <= flashdout; // TODO: sync
        end
        if (mc0rwcnt) begin
            mc0rwcnt <= mc0rwcnt - 1'b1;
            if (mc0rwcnt == 1)
                rwready <= 1;
        end else
            rwready <= 0; // TODO: if
        if (ahready && !waital) begin
            if (mc0alcnt)
                mc0alcnt <= mc0alcnt - 1'b1;
            if (sscnt)
                sscnt <= sscnt - 1'b1;
            if (sscnt == 0) begin
                ahready <= 0;
            end
            if (sscnt == 10 && mc1) begin
                waital <= 1'b1;
            end
        end

    end
end
// 自由运行, 133MHz
always @(posedge spiclk) begin
    if (reset) begin
        io_bank_switch <= 0;
        io_bios_bsw <= 0;
        io_lcd_segment <= 0;
        is_4000_nor <= 0;
    end else begin
        if (rwready) begin
            // 写入
            if (~mc0) begin
                // 仅响应IO
                if (addr[15:6] == 'h0) begin
                    case (addr[5:0])
                    'h00: begin
                        // 要从adin取, 不能从bankswitch!
                        is_4000_nor <= io_bios_bsw[7] == 0 && adin == 0;
                        io_bank_switch <= adin;
                    end
                    'h0A: begin
                        is_4000_nor <= adin[7] == 0 && io_bank_switch == 0;
                        io_bios_bsw <= adin;
                    end
                    'h0D: begin
                        io_lcd_segment <= adin;
                    end
                    endcase
                end
            end
        end
    end
end
// 上升沿准备数据(时钟倒置输出)+切换状态, 经过反相, 设备上升沿看来指令已在下降沿准备好
always @(posedge spiclk) begin
    if (reset) begin
        state <= IDLE;
        spicmdcnt <= 7;
        spiaddrcnt <= 6;
        bypasscmd <= 0;
    end else begin
        case (state)
            IDLE: begin
                // 响应在 0.5 clk?
                if (ahready && addr[15:14] && ~is_4000_nor) begin
                    state <= bypasscmd?SENDADDR:SENDCMD;
                    spicmd <= 'hEB;
                    bypasscmd <= 1; // W25Q128JVPIM
                    if (is_4000 || is_8000) begin
                        // delta 0-3FFF
                        if (is_4000)
                            offset <= {{1'b0,io_bank_switch[7]}+io_lcd_segment[0], 1'b1, addr[13:0]};
                        else
                            offset <= io_bios_bsw[7]?{5'b11000,io_bank_switch[3:0],1'b0,addr[13:0]}:{{1'b0,io_bank_switch[7]}+io_lcd_segment[0], 1'b0, addr[13:0]};
                    end else if (is_bios) begin
                        if (io_bios_bsw[3:0] == 1) begin
                            offset <= addr[12:0] | 'h6000;
                        end else begin
                            offset <= {io_bios_bsw[3:0] ^ 'b0010, addr[12:0]};
                        end
                    end else if (is_boot) begin
                        offset <= {4'h3, addr[12:0]};
                    end
                end
            end
            SENDCMD: begin
                spicmd <= {spicmd[6:0], 1'b0};
                spicmdcnt <= spicmdcnt - 1'b1;
                if (spicmdcnt == 0)
                    state <= SENDADDR;
            end
            SENDADDR: begin
                //spiaddrcnt <= (spiaddrcnt == 0)?6:(waital?spiaddrcnt:spiaddrcnt - 1);
                if (spiaddrcnt == 0)
                    state <= READDAT;
                if (!waital) begin
                    spiaddrcnt <= (spiaddrcnt == 0)?6:spiaddrcnt - 1'b1;
                    offset <= {offset[19:0], 4'b0};                  
                end
            end
            READDAT: begin
                // 此处的上升设备看来提前0.5-0.75时钟, 对齐设备上一时钟下降沿或提前0.25
                // IO总延迟不超过0.25时钟, 下降沿采样. 0.5时钟(0.25+0.25), +1上升沿采样
                // IO总延迟不超过1时钟,  +1下降沿采样, 超1.5, +2上升沿采样
                spicmdcnt <= spicmdcnt - 1'b1;
                if (spicmdcnt == 1)
`ifdef SIM
                    flashdout[7:4] <= $random;
`else
                    flashdout[7:4] <= spiin[3:0];
`endif
                else if (spicmdcnt == 0) begin
`ifdef SIM
                    flashdout[3:0] <= $random;
`else
                    flashdout[3:0] <= spiin[3:0];
`endif
                    state <= IDLE;
                end
            end
        endcase
    end
end

endmodule


//
// Testbench
//
// synthesis translate_off
`timescale 1ns/1ps
module memhub_tb;

reg spiclk = 0;
reg cpuclk = 0;
reg reset = 1;

reg adbus_mc1, adbus_mc0;
reg [7:0] adbus_adin;
wire [7:0] adbus_adout;
wire adbus_z;

reg [15:0] cpu_addr = 'hFFFC;
wire [7:0] rom_dat;

wire spisck, spiclken, spiss2, spissn;
wire [3:0] spi_IO;
wire [3:0] spiin, spiout;
wire spiz0, spiz1;

memhub DUT (
    .spiclk(spiclk),  // 133M
    .reset(reset),
    // cpu
    .mc1(adbus_mc1),
    .mc0(adbus_mc0),
    .adin(adbus_adin),
    .adout(adbus_adout),
    .adz(adbus_z),
    // flash
    .spiclken(spiclken),
    .spiss2(spiss2),
    .spiin(spiin),
    .spiout(spiout),
    .spiz0(spiz0),
    .spiz1(spiz1)
);

wire sck_q, ssn_q;
ODDR #(
    .DDR_CLK_EDGE("SAME_EDGE"),
    .INIT(1'b0),
    .SRTYPE("ASYNC")
) SCKODDR (
    .Q(sck_q),
    .C(~spiclk),
    .CE(1'b1),
    .D1(1'b1),
    .D2(1'b0),
    .R(~spiclken)
);
assign spisck = ~spiclk & spiclken;
ODDR #(
    .DDR_CLK_EDGE("SAME_EDGE"),
    .INIT(1'b1),
    .SRTYPE("ASYNC")
) SSODDR (
    .Q(ssn_q),
    .C(spiss2),
    .CE(1'b1),
    .D1(1'b0),
    .D2(1'b1)
);
assign spissn = ~spiss2;

IOBUF io0(.I(spiout[0]), .O(spiin[0]), .T(spiz0), .IO(spi_IO[0]));
IOBUF io1(.I(spiout[1]), .O(spiin[1]), .T(spiz1), .IO(spi_IO[1]));
IOBUF io2(.I(spiout[2]), .O(spiin[2]), .T(spiz1), .IO(spi_IO[2]));
IOBUF io3(.I(spiout[3]), .O(spiin[3]), .T(spiz1), .IO(spi_IO[3]));

initial begin
    #50 reset = 0; // 5 ticks
    // FFFA 1/4 clock
    adbus_adin = 8'hFF;
    adbus_mc1 = 1;
    adbus_mc0 = 1;
    #254;
    adbus_mc0 = 0;
    #11;
    adbus_adin = 8'hFA;
    #258;
    adbus_mc1 = 0;
    #2;
    adbus_mc0 = 1;
    #523;
    adbus_mc1 = 1;
    // FFFC, full clock
    adbus_adin = 8'hFF;
    adbus_mc1 = 1;
    adbus_mc0 = 1;
    #68;
    adbus_mc0 = 0;
    #12;
    adbus_adin = 8'hFC;
    #56;
    adbus_mc1 = 0;
    #10;
    adbus_mc0 = 1;
    #126;
    adbus_mc1 = 1;
    // FFFD
    adbus_adin = 8'hE1;
    #68;
    adbus_mc0 = 0;
    #12;
    adbus_adin = 8'h23;
    #56;
    adbus_mc1 = 0;
    #10;
    adbus_mc0 = 1;
    #126;
    adbus_mc1 = 1;
end

always #3.75 spiclk <= ~spiclk; // 133.333M
always #136 cpuclk <= ~cpuclk;

// fakecpu
always @(posedge cpuclk) begin
    if (reset) begin
        
    end else begin
        if (cpu_addr == 'hFFFE)
            cpu_addr <= 'hFFFC;
        else
            cpu_addr <= cpu_addr + 1;
    end
end

endmodule
// synthesis translate_on