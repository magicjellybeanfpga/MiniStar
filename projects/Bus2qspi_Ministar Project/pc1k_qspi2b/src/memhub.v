module memhub (
    input spiclk, // spi clock 133MHz
    input reset,
    // from ADBus
    input mc1,
    input mc0,
    input [7:0] adin,
    output reg [7:0] adout,
    output reg adz,
    // to spi flash
    output spiss, // narrow
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
(* mark_debug = "true" *) reg [23:0] aioaddr; // busrom, 12M
reg [7:0] spicmd;
reg [2:0] spicmdcnt = 7;
reg [2:0] spiaddrcnt = 6; // 6->1clk地址, 0 M74 | 5clk dummy + 2clk 读取
// adbus
reg ahready = 0, rwready = 0, adrw = 0;
reg [15:0] addr;
reg [7:0] datin;
reg [7:0] flashdout;

assign spiout = (state == SENDCMD)?{3'b000, spicmd[7]}:(state == SENDADDR)?aioaddr[23:20]:4'b0000;

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
reg [2:0] mc0rwcnt;
reg [2:0] mc0alcnt;
reg [4:0] adzcnt;
reg mc0r = 1;
reg mc1r = 1;
reg spissn = 1;
assign spiss = (state != IDLE) && (ahready);
assign spiss2 = (state != IDLE);

// 以7.5ns误差对齐到MC0
always @(posedge spiclk) begin
    if (reset) begin
        mc0r <= 1;
        mc1r <= 1;
    end else begin
        mc0r <= mc0;
        mc1r <= mc1;
    end
end
reg [5:0]sscnt;
reg bypasscmd = 0;
always @(posedge spiclk) begin
    if (reset) begin
        rwready <= 0;
        adz <= 1;
        ahready <= 0;
    end else begin
        // MC0下降沿
        if (mc0r & ~mc0) begin
            ahready <= 1;
            mc0alcnt <= 3; // 2 clock, 15ns
            addr[15:8] <= adin; // 10ns后adin取样AL
            sscnt <= bypasscmd?14:22;
        end
        // MC1下降沿, 20ns从MC0取样RW
        if (mc1r & ~mc1) begin
            mc0rwcnt <= 3;
            adzcnt <= 15; // 13.5=101.25(135.5-35) 15=112.5(135.5-20)
        end
        // MC1上升沿
        if (~mc1r & mc1) begin
            adz <= 1;
        end
        if (mc0rwcnt) begin
            mc0rwcnt <= mc0rwcnt - 1'b1;
            if (mc0rwcnt == 1)
                rwready <= 1;
        end else
            rwready <= 0; // TODO: if
        if (ahready) begin
            if (mc0alcnt)
                mc0alcnt <= mc0alcnt - 1'b1;
            if (sscnt)
                sscnt <= sscnt - 1'b1;
            if (mc0alcnt == 1) begin
                addr[7:0] <= adin;
            end
            if (sscnt == 0) begin
                ahready <= 0;
            end
        end
        // out of ss
        if (adzcnt)
            adzcnt <= adzcnt - 1'b1;
        if (adzcnt == 1 && mc0r) begin
            adz <= 0;
            adout <= flashdout; // TODO: sync
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
// 实际下降沿, 它会延迟半时钟
always @(negedge spiclk) begin
    //if (state == READDAT) begin
    //    if (spicmdcnt == 1)
    //        flashdout[7:4] <= spiin[3:0];
    //    else if (spicmdcnt == 0) begin
    //        flashdout[3:0] <= spiin[3:0];
    //    end
    //end
end
// 上升沿准备数据(时钟倒置输出)+切换状态, 经过反相, 设备上升沿看来指令已在下降沿准备好
always @(posedge spiclk) begin
    if (reset) begin
        state <= IDLE;
        spicmdcnt <= 7;
        spiaddrcnt <= 6;
        //bypasscmd <= 0; // spiflash 不复位, 持续读取特性不变
        //flashdout <= 0;
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
                            aioaddr <= {{1'b0,io_bank_switch[7]}+io_lcd_segment[0], 1'b1, addr[13:0]};
                        else
                            aioaddr <= io_bios_bsw[7]?{5'b11000,io_bank_switch[3:0],1'b0,addr[13:0]}:{{1'b0,io_bank_switch[7]}+io_lcd_segment[0], 1'b0, addr[13:0]};
                    end else if (is_bios) begin
                        if (io_bios_bsw[3:0] == 1) begin
                            aioaddr <= addr[12:0] | 'h6000;
                        end else begin
                            aioaddr <= {io_bios_bsw[3:0] ^ 'b0010, addr[12:0]};
                        end
                    end else if (is_boot) begin
                        aioaddr <= {4'h3, addr[12:0]};
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
                spiaddrcnt <= (spiaddrcnt == 0)?3'd6:spiaddrcnt - 1'b1;
                if (spiaddrcnt == 0)
                    state <= READDAT;
                if (spiaddrcnt == 4)
                    aioaddr <= {aioaddr[19:16], addr[7:0], 12'hEFF};
                else
                    aioaddr <= {aioaddr[19:0], 4'b1110}; // M[5-4]=10
            end
            READDAT: begin
                // 此处的上升设备看来提前0.5-0.75时钟, 对齐设备上一时钟下降沿或提前0.25
                // IO总延迟不超过0.25时钟, 下降沿采样. 0.5时钟(0.25+0.25), +1上升沿采样
                // IO总延迟不超过1时钟,  +1下降沿采样, 超1.5, +2上升沿采样
                spicmdcnt <= spicmdcnt - 1'b1; // +1
                //if (spicmdcnt == 0)
                //    state <= IDLE;
                if (spicmdcnt == 1)
                    flashdout[7:4] <= spiin[3:0];
                else if (spicmdcnt == 0) begin
                    flashdout[3:0] <= spiin[3:0];
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

wire spisck, spiss, spiss2, spissn;
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
    .spiss(spiss),
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
    .R(~spiss)
);
ODDR #(
    .DDR_CLK_EDGE("SAME_EDGE"),
    .INIT(1'b1),
    .SRTYPE("ASYNC")
) SSODDR (
    .Q(ssn_q),
    .C(spiss2),
    .CE(1'b1),
    .D1(1'b0),
    .D2(1'b1),
    .S()
);
assign spissn = ~spiss;

IOBUF io0(.I(spiout[0]), .O(spiin[0]), .T(spiz0), .IO(spi_IO[0]));
IOBUF io1(.I(spiout[1]), .O(spiin[1]), .T(spiz1), .IO(spi_IO[1]));
IOBUF io2(.I(spiout[2]), .O(spiin[2]), .T(spiz1), .IO(spi_IO[2]));
IOBUF io3(.I(spiout[3]), .O(spiin[3]), .T(spiz1), .IO(spi_IO[3]));

initial begin
    #50 reset = 0; // 5 ticks
    // FFFC
    adbus_adin = 8'hFF;
    adbus_mc1 = 1;
    adbus_mc0 = 1;
    #68;
    adbus_mc0 = 0;
    #12;
    adbus_adin = 8'hFC;
    #56;
    adbus_mc1 = 0;
    #20;
    adbus_mc0 = 1;
    #116;
    adbus_mc1 = 1;
    // FFFD
    adbus_adin = 8'hFF;
    #68;
    adbus_mc0 = 0;
    #12;
    adbus_adin = 8'hFD;
    #56;
    adbus_mc1 = 0;
    #20;
    adbus_mc0 = 1;
    #116;
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