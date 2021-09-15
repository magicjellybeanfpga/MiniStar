`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/23 10:12:49
// Design Name: 
// Module Name: TestTop_DigitalTube
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


module TestTop_DigitalTube(
                        I_sys_clk,
                        I_rst_n,
                        //I_en,
                        //I_start,
                        //I_disp_data,

                        //O_sel,
                        //O_seg,
                        //O_data0,
                        //O_data1,
                        //O_done
                        uart_tx,
                        uart_rx,
                        O_led

    );

input I_sys_clk;
input I_rst_n;
// input I_en;
// input I_start;
// input [15:0] I_disp_data;

// output [3:0] O_sel;
// output [7:0] O_seg;
// output [31:0] O_data0;
// output [31:0] O_data1;
// output O_done;
output uart_tx;
input uart_rx;
output O_led;

wire [3:0] O_sel;
wire [7:0] O_seg;
reg [15:0] R_disp_data;
reg R_en;

wire lock_o;
wire grst_n;
wire clkout_50M;

assign grst_n = lock_o & I_rst_n;

Gowin_PLLVR pll_inst0(
        .clkout(clkout_50M), //output clkout
        .lock(lock_o), //output lock
        .reset(~I_rst_n), //input reset
        .clkin(I_sys_clk) //input clkin
    );



always @(posedge clkout_50M or negedge grst_n) begin
    if(~grst_n) begin
        R_en <= 0;
        R_disp_data <= 0;
    end
    else begin
        R_en <= 1;
        R_disp_data <= 16'hEC1D;
    end
end



Digital_Tube dut_inst0(
                .I_sys_clk(clkout_50M),
                .I_rst_n(grst_n),
                .I_en(R_en),

                .I_disp_data(R_disp_data),

                .O_sel(O_sel),
                .O_seg(O_seg)
    );

Control_TOP MeaDut_inst0(
                .I_sys_clk(clkout_50M),
                .I_rst_n(grst_n),

                .I_clk_fx(),

                .I_digtube_en(R_en),
                .I_digtube_sel(O_sel),
                .I_digtube_seg(O_seg),
                .I_digtube_disp_data(R_disp_data),

                .uart_tx(uart_tx),
                .uart_rx(uart_rx),
                .O_led(O_led)
    );

endmodule
