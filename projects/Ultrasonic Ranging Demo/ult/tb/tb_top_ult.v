`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/08/07 16:36:20
// Design Name: 
// Module Name: tb_cnt
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 回响信号为高电平期间进行计时，将距离用数码管显示出来
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`define UD #1
module tb_top_ult ;


	reg clk;//12MHZ 
	reg echo;
	reg rstn;
    wire trig;
	wire  [3:0]dig;
	wire  [7:0]smg;



top_ult uut
(
	.clk	(clk	),//12MHZ 
	.echo	(echo	),
	.rstn	(rstn	),
    .trig	(trig	),
	.dig	(dig	),
	.smg    (smg	)
);


initial
begin
	#0;
		clk = 1'b0;
		rstn = 1'b0;
		echo = 1'b0;
	#100;
		rstn = 1'b1;
	#500;
		echo = 1'b1;
	#30000;
		echo = 1'b0;
	//delay
	//#1000;
	//	echo = 1'b1;
	//#4000;
	//	echo = 1'b0;	
	

end 

always #10 clk = ~clk;

endmodule 