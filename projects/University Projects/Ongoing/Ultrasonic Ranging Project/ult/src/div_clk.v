`timescale 1ns / 1ps
`define UD #1
module div_clk
(
	input clk,
	output  clk_1khz
);
//times =120 :83.33ns*120=10ms=100khz;
reg [27:0]cnt;
always @(posedge clk)
begin
	if(cnt == 28'd27000)
		cnt<= `UD 28'd0;
	else 
		cnt <= `UD cnt + 1'b1;
end  

reg flag=1'b0;
always @(posedge clk)
begin
	if(cnt == 28'd13500)
		flag <= `UD 1'b1;
	else if(cnt == 28'd27000)
		flag <= `UD 1'b0;
end 
assign clk_1khz = flag;

endmodule