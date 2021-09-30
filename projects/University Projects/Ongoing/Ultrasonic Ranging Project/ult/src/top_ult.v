`timescale 1ns / 1ps
`define UD #1
module top_ult
(
	input clk,//12MHZ 
	input echo,
	input rstn,
    output trig,
	output reg [3:0]dig,
	output reg [7:0]smg
);




/*===================================================
					触发与距离计数
===================================================*/
wire [3:0] count_one;
wire [3:0] count_ten;
wire [3:0] count_hundred;
wire [3:0] count_thousand;

cnt cnt
(
	.clk(clk),
	.echo(echo ),
	.trig(trig),
    .rstn(rstn),
    .count_one(count_one),
    .count_ten(count_ten),
    .count_hundred(count_hundred),
    .count_thousand(count_thousand)
);


/*===================================================
					时钟分频
===================================================*/
wire clk_1khz;
div_clk div_clk
(
	.clk		(clk),
	.clk_1khz (clk_1khz)
);
/*===================================================
					数码管显示
===================================================*/
reg  [1:0]sel=0;
wire [3:0]dig0;
wire [7:0]smg0;

always @(posedge clk_1khz)
begin
	sel <= `UD sel+1'b1;
end 

seq_control seq_control_0
(
	.sel(2'd3),
	.key(count_one),
	.dig(dig0),
	.smg(smg0)
);

wire [3:0]dig1;
wire [7:0]smg1;

seq_control seq_control_1
(
	.sel(2'd2),
	.key(count_ten),
	.dig(dig1),
	.smg(smg1)
);

wire [3:0]dig2;
wire [7:0]smg2;

seq_control seq_control_2
(
	.sel(2'd1),
	.key(count_hundred),
	.dig(dig2),
	.smg(smg2)
);

wire [3:0]dig3;
wire [7:0]smg3;

seq_control seq_control_3
(
	.sel(2'd0),
	.key(count_thousand),
	.dig(dig3),
	.smg(smg3)
);


always @(posedge clk_1khz)
begin
	if(sel==2'b00)
		dig <= `UD dig0;
	else if(sel==2'b01)
		dig <= `UD dig1;
	else if(sel==2'b10)
		dig <= `UD dig2;
	else if(sel==2'b11)
		dig <= `UD dig3;
end 


always @(posedge clk_1khz)
begin
	if(sel==2'b00)
		smg <= `UD smg0;
	else if(sel==2'b01)
		smg <= `UD smg1;
	else if(sel==2'b10)
		smg <= `UD smg2;
	else if(sel==2'b11)
		smg <= `UD smg3;
end
endmodule 