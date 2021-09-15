`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:28:15 03/14/2020 
// Design Name: 
// Module Name:    USART_Band 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module USART_Band(
                    clk,
                    rst_n,
                    clkb
                );
parameter BandRate = 4800;
parameter CNT = 50000000/(BandRate*16);
input clk;
input rst_n;
output clkb;

reg clkb;
reg [9:0] cnt;

always@(posedge clk)
begin
    if(~rst_n)
        begin
            cnt <= 10'd0;
        end
    else
        begin
            if(cnt == CNT/2)
                begin
                    clkb <= 1'b1;
                    cnt <= cnt+1'b1;
                end
            else if(cnt == CNT)
                    begin
                        clkb <= 1'b0;
                        cnt <= 10'd0;
                    end
            else
                begin
                    cnt <= cnt+1'b1;
                end
        end
end

endmodule
