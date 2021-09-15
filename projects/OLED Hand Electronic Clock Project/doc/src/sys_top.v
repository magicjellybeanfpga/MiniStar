module sys_top(
    input  clk_27M,
    input  reset_n,

    input  uart0_rxd,
    output uart0_txd,

    inout  scl,
    inout  sda
);

wire sys_clk;
clk_gen u_PLLVR(
    .clkout(sys_clk), //output clkout 54MHz
    .clkin(clk_27M) //input clkin
);

reg rtc_clk;
reg [24:0] rtc_counter;
always @(posedge sys_clk or negedge reset_n) begin
    if(!reset_n) begin
        rtc_counter <= 25'd0;
        rtc_clk <= 1'b0;
    end
    else if(rtc_counter == 25'd26_999_999) begin
        rtc_counter <= 25'd0;
        rtc_clk <= ~rtc_clk;
    end
    else begin
        rtc_counter <= rtc_counter + 25'd1;
        rtc_clk <= rtc_clk;
    end
end

Gowin_EMPU_Top u_EMPU(
    .sys_clk(sys_clk),      //input sys_clk
    .rtc_clk(rtc_clk),      //input rtc_clk
    .uart0_rxd(uart0_rxd),  //input uart0_rxd
    .uart0_txd(uart0_txd),  //output uart0_txd
    .scl(scl),              //inout scl
    .sda(sda),              //inout sda
    .reset_n(reset_n)       //input reset_n
);

endmodule