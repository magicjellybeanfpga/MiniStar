module top(
    input        rstn, // key
    output [1:0] LED,
    // ADBus
    input  adbus_MC1,
    input  adbus_MC0,
    inout  [7:0] adbus_AD,
    // flash pins
    inout  spi_SCK,
    output spi_SS,
    inout  [3:0] spi_IO
);

wire spiclk2x;
wire midclk, spiclk;
wire spisck, spisck_fb;
wire pll_locked;
reg pll_locked_r = 0;
// 250M -> 125M
OSCZ  #(.FREQ_DIV(2)) osc_inst(
    .OSCOUT(midclk),
    .OSCEN(1'b1)
);
CLK133 mul1(.clkout(spiclk2x), .clkoutd(spiclk), .lock(pll_locked), .clkin(midclk));

wire spiss, spiss2;
assign spisck = ~spiclk & spiss;
//DHCEN dhc(.CLKIN(~spiclk), .CE(~spiss), .CLKOUT(spisck));
IOBUF sckbuf(.I(spisck), .O(spisck_fb), .OEN(1'b0), .IO(spi_SCK));
//assign spi_SCK = spisck;
assign spi_SS = ~spiss2;

wire [3:0] spiin, spiout;
wire spiz0, spiz1;
IOBUF io0(.I(spiout[0]), .O(spiin[0]), .OEN(spiz0), .IO(spi_IO[0]));
IOBUF io1(.I(spiout[1]), .O(spiin[1]), .OEN(spiz1), .IO(spi_IO[1]));
IOBUF io2(.I(spiout[2]), .O(spiin[2]), .OEN(spiz1), .IO(spi_IO[2]));
IOBUF io3(.I(spiout[3]), .O(spiin[3]), .OEN(spiz1), .IO(spi_IO[3]));
wire [7:0] adbus_adin, adbus_adout;
wire adbus_z;
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin
        IOBUF ad(.I(adbus_adout[i]), .O(adbus_adin[i]), .OEN(adbus_z), .IO(adbus_AD[i]));
    end
endgenerate

reg reset = 1'b1; // sync reset
reg [7:0] resetcnt = ~0;

memhub hub(
    .spiclk(spiclk),   // 133M
    .reset (reset),
    // adbus
    .mc1(adbus_MC1),
    .mc0(adbus_MC0),
    .adin(adbus_adin),
    .adout(adbus_adout),
    .adz(adbus_z),
    // flash
    .spiss(spiss),   // narrow
    .spiss2(spiss2), // wide
    .spiin(spiin),
    .spiout(spiout),
    .spiz0(spiz0),
    .spiz1(spiz1)
);

//always @(posedge spiclk) pll_locked_r <= pll_locked;
always @(posedge spiclk or negedge rstn) begin
    if (!rstn) begin
        reset <= 1'b1;
        // 69us debounce
        resetcnt <= ~0;
    end else begin
        if (reset == 1'b1) begin
            resetcnt <= resetcnt - 1'b1;
            if (resetcnt == 0) begin
                reset <= 1'b0;
            end
        end
    end
end

endmodule
