`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/08/07 16:36:20
// Design Name: 
// Module Name: count
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
module cnt (
	input  clk,
    input  rstn,
    input  echo,
    output reg trig,
    output reg [3:0]count_one,
    output reg [3:0]count_ten,
    output reg [3:0]count_hundred,
    output reg [3:0]count_thousand
);


		parameter  PERIOD =28'd27000000;
		parameter  FRE =5'd27;//27MHz
		parameter  TRIG_H =FRE*10;//trig持续10us计时    
		parameter  COUNT_CM =FRE*58-1;

/*===================================================
	假如速度为340m/s，距离的公式为：us/58（厘米），时钟频率为：12MHz，
    每1厘米的距离所用的时间为27*58=1566个clk周期
===================================================*/

/*===================================================
					周期计时
===================================================*/
reg[27:0] count_period;

always @ (posedge clk)
     begin 
          if(!rstn||count_period==PERIOD+TRIG_H)
            count_period<=`UD 28'd0;
          else
            count_period<=`UD count_period+1'd1;
     end
/*===================================================
					10usTRIG
===================================================*/
always @ (posedge clk)
     begin 
          if(!rstn)
            trig <=`UD 1'd0;
          else if((count_period>PERIOD)&&(count_period<=PERIOD+TRIG_H))
            trig <=`UD 1'd1;
          else
            trig <=`UD 1'd0;
     end

/*===================================================
					Echo信号计时并计算距离
===================================================*/

reg [12:0] count_echo=0;

always @ (posedge clk)
     begin
          if(!rstn||trig==1'b1||count_echo==COUNT_CM)
            count_echo <= `UD 13'd0;
          else if((echo==1'b1)&&(count_echo<COUNT_CM))//1cm计时
            count_echo <= `UD count_echo+1'd1;
          else
            count_echo <= `UD count_echo;
     end

always @ (posedge clk)
     begin
          if(!rstn||trig==1'b1||count_one==4'd10) 
            count_one<= `UD 1'd0;
          else if((count_echo==COUNT_CM)&&(count_one<=4'd9))//个位
            count_one<= `UD count_one+1'd1;
          else
            count_one<= `UD count_one;
     end

always @ (posedge clk)
     begin
          if(!rstn||trig==1'b1||count_ten==4'd10) 
            count_ten<= `UD 1'd0;
          else if((count_one==4'd10)&&(count_ten<=4'd9))//十位
            count_ten<= `UD count_ten+1'd1;      
          else
            count_ten<= `UD count_ten;
     end

always @ (posedge clk)
     begin
          if(!rstn||trig==1'b1||count_hundred==4'd10) 
            count_hundred<= `UD 1'd0;
          else if((count_ten==4'd10)&&(count_hundred<=4'd9))//百位
            count_hundred<= `UD count_hundred+1'd1;
          else
            count_hundred<= `UD count_hundred;
     end

always @ (posedge clk)
     begin
          if(!rstn||trig==1'b1||count_thousand==4'd10) 
            count_thousand<= `UD 1'd0;
          else if((count_hundred==4'd10)&&(count_thousand<=4'd9))//千位
            count_thousand<= `UD count_thousand+1'd1;
          else
            count_thousand<= `UD count_thousand;
     end
endmodule
