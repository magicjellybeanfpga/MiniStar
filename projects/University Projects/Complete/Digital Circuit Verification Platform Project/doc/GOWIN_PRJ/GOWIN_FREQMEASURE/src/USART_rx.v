`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:16:47 03/14/2020 
// Design Name: 
// Module Name:    USART_rx 
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
module USART_rx(
                clkb,
                rst_n,
                rx,
                rx_busy,
                rx_done,
                rxdata
            );

input clkb;
input rst_n;
input rx;
output rx_busy;
output rx_done;
output [7:0] rxdata;

reg rx_busy;
reg rx_done;
reg [7:0] rxdata;

parameter [3:0] Lframe = 8;
parameter [2:0] s_idle = 3'b000;
parameter [2:0] s_sample = 3'b001;
parameter [2:0] s_stop = 3'b010;
parameter [2:0] s_start = 3'b100;
parameter [2:0] s_done = 3'b101;

reg [2:0] state = s_start;
reg [3:0] cnt;
reg [3:0] num;
reg [3:0] dcnt;
reg rxbuf;
reg rxfall;

always@(posedge clkb)
begin
    rxbuf <= rx;
    rxfall <= rxbuf & (!rx);
end

always@(posedge clkb)
begin
    if(~rst_n)
        begin
            state <= s_start;
            cnt <= 0;
            dcnt <= 0;
            num <= 0;
            //rxdata <= 0;
            rx_busy <= 1'b0;
            rx_done <= 1'b0;
        end
    else
        begin
            case(state)
                s_start:begin
                    rx_done <= 1'b0;
                    if(rxfall) begin
                        rx_busy <= 1'b1;
                        state <= s_idle;
                    end
                    else begin
                        rx_busy <= 1'b0;
                        rxdata <= rxdata;
                    end
                end
                s_idle :begin
                            //rx_busy <= 1'b1;
                            dcnt <= 0;
                            if(cnt == 4'b1111) begin
                                cnt <= 0;
                                if(num > 7) begin
                                    state <= s_sample;
                                    num <= 0;
                                    rx_busy <= 1'b1;
                                    rxdata <= 0;
                                end
                                else begin
                                    state <= s_start;
                                    num <= 0;
                                    rx_busy <= 1'b0;
                                    rxdata <= rxdata;
                                end
                            end
                            else begin
                                cnt <= cnt + 1'b1;
                                if(rx == 1'b0) begin
                                    num <= num + 1'b1;
                                end
                                else begin
                                    num <= num;
                                end
                            end
                        
                        end
                s_sample :begin
                    rx_busy <= 1'b1;
                    if(dcnt == Lframe) begin
                        state <= s_stop;
                    end
                    else begin
                        state <= s_sample;
                        if(cnt == 4'b1111) begin
                            dcnt <= dcnt +1'b1;
                            cnt <= 0;
                            if(num > 7) begin
                                num <= 0;
                                rxdata[dcnt] <= 1;
                            end
                            else begin
                                rxdata[dcnt] <= 0;
                                num <= 0;
                            end
                        end
                        else begin
                            cnt <= cnt + 1'b1;
                            if(rx == 1'b1) begin
                                num <= num + 1'b1;
                            end
                            else begin
                                num <= num;
                            end
                        end
                    end     
                end
                s_stop : begin
                    rx_busy <= 1'b1;
                    if(cnt == 4'b1111) begin
                        cnt <= 0;
                        state <= s_done ;
                    end
                    else begin
                        cnt <= cnt + 1'b1;
                    end
                end
                s_done : begin
                    rx_busy <= 1'b0;
                    rx_done <= 1'b1;
                    state <= s_start;
                end
            endcase
        end
end

endmodule
