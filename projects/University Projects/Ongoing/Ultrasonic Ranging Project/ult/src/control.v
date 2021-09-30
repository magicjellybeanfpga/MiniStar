`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/08/07 16:36:20
// Design Name: 
// Module Name: control
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description:控制信号每隔一秒为超声波模块提供TRIG信号，发射超声波 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`define UD #1
module control (
	input  clk,
    input  rstn,
	output reg trig

);
     parameter  TRIG_H =12'd120;//trig持续10us计时
     parameter  PERIOD =24'd12000000;//间隔1s测量一次
/*===================================================
					周期计时
===================================================*/
reg[23:0] count_period;

always @ (posedge clk)
     begin 
          if(!rstn||count_period==PERIOD+TRIG_H)
            count_period<=`UD 24'd0;
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
endmodule
