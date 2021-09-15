`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/23 09:31:22
// Design Name: 
// Module Name: Digital_Tube
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


module Digital_Tube(
                    I_sys_clk,
                    I_rst_n,
                    I_en,

                    I_disp_data,

                    O_sel,
                    O_seg
    );


input I_sys_clk;
input I_rst_n;
input I_en;
input [15:0] I_disp_data;

output [3:0] O_sel;
output reg [7:0] O_seg;

parameter CLK_DIV = 16'd249;

reg [15:0] R_drive_cnt;
reg clk_div;

reg [3:0] R_sel;
reg [3:0] data_tmp;

always @(posedge I_sys_clk or negedge I_rst_n) begin
    if(~I_rst_n) begin
        R_drive_cnt <= 0;
    end
    else begin
        if(I_en) begin
            if(R_drive_cnt == CLK_DIV) begin
                R_drive_cnt <= 0;
            end
            else begin
                R_drive_cnt <= R_drive_cnt + 1;
            end
        end
        else begin
            R_drive_cnt <= 0;
        end
    end
end


always @(posedge I_sys_clk or negedge I_rst_n) begin
    if(~I_rst_n) begin
        clk_div <= 0;
    end
    else begin
        if(R_drive_cnt == CLK_DIV) begin
            clk_div <= ~clk_div;
        end
        else begin
            clk_div <= clk_div;
        end
    end 
end


assign O_sel = (I_en) ? R_sel : 4'b0000;

always @(posedge clk_div or negedge I_rst_n) begin
    if(~I_rst_n) begin
        R_sel <= 4'b0001;
    end
    else if(R_sel == 4'b1000) begin
        R_sel <= 4'b0001;
    end
    else begin
        R_sel <= R_sel << 1;
    end
end

always @(R_sel) begin
    case (R_sel)
        4'b0001 : data_tmp <=  I_disp_data[3:0];
        4'b0010 : data_tmp <=  I_disp_data[7:4];
        4'b0100 : data_tmp <=  I_disp_data[11:8];
        4'b1000 : data_tmp <=  I_disp_data[15:12];
        default: data_tmp <=  4'b0000;
    endcase
end

always @(data_tmp) begin
    case (data_tmp)
        4'h0 : O_seg = 8'b11000000;
		4'h1 : O_seg = 8'b11111001;
		4'h2 : O_seg = 8'b10100100;
		4'h3 : O_seg = 8'b10110000;
		4'h4 : O_seg = 8'b10011001;
		4'h5 : O_seg = 8'b10010010;
		4'h6 : O_seg = 8'b10000010;
		4'h7 : O_seg = 8'b11111000;
		4'h8 : O_seg = 8'b10000000;
		4'h9 : O_seg = 8'b10010000;
		4'ha : O_seg = 8'b10001000;
		4'hb : O_seg = 8'b10000011;
		4'hc : O_seg = 8'b11000110;
		4'hd : O_seg = 8'b10100001;
		4'he : O_seg = 8'b10000110;
		4'hf : O_seg = 8'b10001110;
    endcase
end


endmodule
