`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/19 15:36:55
// Design Name: 
// Module Name: TOP
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module TOP(
            I_sys_clk,
            I_rst_n,

            uart_tx,
            uart_rx,
            O_led

    );

input I_sys_clk;
input I_rst_n;

input uart_rx;
output uart_tx;
output O_led;

parameter DIV_NUMBER = 249;

wire grst_n;
wire lock_o;
wire clkout_50m;

assign grst_n = lock_o & I_rst_n;

Gowin_PLLVR pll_inst0(
        .clkout(clkout_50m), //output clkout
        .lock(lock_o), //output lock
        .reset(~I_rst_n), //input reset
        .clkin(I_sys_clk) //input clkin
    );


Control_TOP ctl_inst0(
                .I_sys_clk(clkout_50m),
                .I_rst_n(grst_n),

                .I_clk_fx(clk_div),
                .I_digtube_en(),
                .I_digtube_sel(),
                .I_digtube_seg(),
                .I_digtube_disp_data(),

                .uart_tx(uart_tx),
                .uart_rx(uart_rx),
                .O_led(O_led)
    );

reg [15:0] cnt;
reg clk_div;

always @(posedge clkout_50m or negedge grst_n) begin
    if(!grst_n) begin
        cnt <= 0;
        clk_div <= 0;
    end
    else begin
        if(cnt == DIV_NUMBER) begin
            cnt <= 0;
            clk_div <= ~clk_div;
        end
        else begin
            cnt <= cnt + 1;
        end
    end
end


endmodule
