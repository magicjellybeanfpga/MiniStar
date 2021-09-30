`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/19 11:33:21
// Design Name: 
// Module Name: MeasureFreq
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


module MeasureFreq(
                    I_sys_clk,
                    I_clk_fx,
                    I_rst_n,
                    I_start,

                    O_done,
                    O_f0_cnt,
                    O_fx_cnt

    );

input I_sys_clk;
input I_rst_n;
input I_clk_fx;
input I_start;

output O_done;
output reg [31:0] O_f0_cnt;
output reg [31:0] O_fx_cnt;

parameter SET_1S_PERD = 49_999_999;  //50MHz sys clk
//parameter SET_1S_PERD = 49_999;  //simulink,50KHz sys clk

reg [31:0] gate_cnt;
reg gate_time_pre;
reg R_done_pre;
reg R_start;

wire W_start_pos;
reg [1:0] R_start_buf;

always @(posedge I_sys_clk) begin
    R_start_buf[1] <= R_start_buf[0];
    R_start_buf[0] <= I_start;
end

assign W_start_pos = (R_start_buf == 2'b01) ? 1 : 0;

always @(posedge I_sys_clk or negedge I_rst_n) begin
    if(!I_rst_n) begin
        gate_cnt <= 32'd0;
        R_done_pre <= 0;
        gate_time_pre <= 0;
        R_start <= 0;
    end
    else begin
        if(W_start_pos) begin
            R_start <= 1;
        end
        if(R_start) begin
            if(gate_cnt == SET_1S_PERD) begin
                gate_time_pre <= 0;
                R_done_pre <= 1;
                R_start <= 0;
            end
            else begin
                gate_cnt <= gate_cnt + 32'd1;
                gate_time_pre <= 1;
                R_done_pre <= 0;
            end
        end
        else begin
            gate_time_pre <= 0;
            gate_cnt <= 32'd0;
            R_done_pre <= R_done_pre;
        end
    end
end

reg gate_time;

always @(posedge I_clk_fx or negedge I_rst_n) begin
    if(!I_rst_n) begin
        gate_time <= 0;
    end
    else begin
        gate_time <= gate_time_pre;
    end
    
end

assign O_done = ({R_done_pre,gate_time} == 2'b10) ? 1 : 0;

always @(posedge I_clk_fx or negedge I_rst_n) begin
    if((!I_rst_n)) begin
        O_fx_cnt <= 32'd0;
    end
    else begin
        if(gate_time) begin
            O_fx_cnt <= O_fx_cnt + 32'd1;
        end
        else begin
            O_fx_cnt <= O_fx_cnt;
        end
    end
end

always @(posedge I_sys_clk or negedge I_rst_n) begin
    if((!I_rst_n)) begin
        O_f0_cnt <= 32'd0;
    end
    else begin
        if(gate_time) begin
            O_f0_cnt <= O_f0_cnt + 32'd1;
        end
        else begin
            O_f0_cnt <= O_f0_cnt;
        end
    end
end





endmodule
