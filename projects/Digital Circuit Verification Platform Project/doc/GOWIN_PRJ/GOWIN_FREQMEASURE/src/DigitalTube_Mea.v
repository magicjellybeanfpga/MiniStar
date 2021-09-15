`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/23 09:50:24
// Design Name: 
// Module Name: DigitalTube_Mea
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


module DigitalTube_Mea(
                    I_sys_clk,
                    I_rst_n,

                    I_start,

                    I_test_en,
                    I_test_sel,
                    I_test_seg,
                    I_test_disp_data,

                    O_data0,
                    O_data1,
                    O_done
    );

input I_sys_clk;
input I_rst_n;
input I_start;

input I_test_en;
input [3:0] I_test_sel;
input [7:0] I_test_seg;
input [15:0] I_test_disp_data;

output reg [31:0] O_data0;
output reg [31:0] O_data1;
output O_done;

reg R_start_en;
reg [1:0] R_start_buf;
reg R_done_flag;
reg [3:0] R_test_num;

wire W_start_pos;

always @(posedge I_sys_clk or negedge I_rst_n) begin
    if(~I_rst_n) begin
        R_start_buf <= 0;
    end
    else begin
        R_start_buf <= {R_start_buf[0],I_start};
    end
end

assign W_start_pos = (R_start_buf == 2'b01) ? 1 : 0;

always @(posedge I_sys_clk or negedge I_rst_n) begin
    if(~I_rst_n) begin
        R_start_en <= 0;
    end
    else begin
        if(W_start_pos) begin
            R_start_en <= 1;
        end
        else begin
            if(R_done_flag) begin
                R_start_en <= 0;
            end
            else begin
                R_start_en <= R_start_en;
            end
        end
    end
end

reg R_01_flag;
reg R_02_flag;
reg R_03_flag;
reg R_04_flag;

always @(posedge I_sys_clk or negedge I_rst_n) begin
    if(~I_rst_n) begin
        R_test_num <= 0;
        O_data1 <= 0;
        O_data0 <= 0;
        R_01_flag <= 1'b0;
        R_02_flag <= 1'b0;
        R_03_flag <= 1'b0;
        R_04_flag <= 1'b0;
    end
    else begin
        if(R_start_en & I_test_en) begin
            case (I_test_sel)
                4'b0001 : begin
                    O_data1[15:0] <= I_test_disp_data;
                    O_data0[7:0] <= I_test_seg;
                    R_01_flag <= 1'b1;
                    if(R_01_flag) begin
                        R_test_num <= R_test_num;
                    end
                    else begin
                        R_test_num <= R_test_num + 1;
                    end
                    
                end 
                4'b0010 : begin
                    O_data0[15:8] <= I_test_seg;
                    R_02_flag <= 1'b1;
                    if(R_02_flag) begin
                        R_test_num <= R_test_num;
                    end
                    else begin
                        R_test_num <= R_test_num + 1;
                    end
                end 
                4'b0100 : begin
                    O_data0[23:16] <= I_test_seg;
                    R_03_flag <= 1'b1;
                    if(R_03_flag) begin
                        R_test_num <= R_test_num;
                    end
                    else begin
                        R_test_num <= R_test_num + 1;
                    end
                end 
                4'b1000 : begin
                    O_data0[31:24] <= I_test_seg;
                    R_04_flag <= 1'b1;
                    if(R_04_flag) begin
                        R_test_num <= R_test_num;
                    end
                    else begin
                        R_test_num <= R_test_num + 1;
                    end
                end 
            default: O_data0 <= O_data0;
            endcase
        end
        else  begin
            if(I_test_en) begin
                R_test_num <= R_test_num;
                O_data1 <= O_data1;
                O_data0 <= O_data0;
            end
            else begin
                R_test_num <= 0;
                O_data1 <= 0;
                O_data0 <= 0;
                R_01_flag <= 1'b0;
                R_02_flag <= 1'b0;
                R_03_flag <= 1'b0;
                R_04_flag <= 1'b0;
            end
        end
    end
end

always @(posedge I_sys_clk or negedge I_rst_n) begin
    if(~I_rst_n) begin
        R_done_flag <= 0;
    end
    else begin
        if(R_test_num == 4'd4) begin
            R_done_flag <= 1;
        end
        else begin
            R_done_flag <= 0;
        end
    end
end

assign O_done = R_done_flag;

endmodule
