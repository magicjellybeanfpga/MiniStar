`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:40:40 03/14/2020 
// Design Name: 
// Module Name:    USART_tx 
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
module USART_tx(
                clkb,
                rst_n,
                data,
                tx_en,
                tx_busy,
                tx
                );

input clkb;
input rst_n;
input [7:0] data;
input tx_en;
output tx_busy;
output tx;

reg tx_busy;
reg tx;

parameter Lframe = 4'd8;
parameter [3:0] s_idle = 4'b0000;
parameter [3:0] s_start = 4'b0001;
parameter [3:0] s_wait = 4'b0010;
parameter [3:0] s_shift = 4'b0100;
parameter [3:0] s_stop = 4'b1000;

reg [3:0] state = s_idle;
reg [2:0] tx_enbuf;
reg [3:0] cnt;
reg [3:0] dcnt;

wire tx_cmd;

//Sync Shaping Pulse for tx_en and tx_busy
always@(posedge clkb)
begin
    tx_enbuf <= {tx_enbuf[1:0],tx_en};
end

assign tx_cmd = (!tx_enbuf[2]) & tx_enbuf[1];


always@(posedge clkb)
begin
    if(~rst_n)
        begin
            state <= s_idle;
            cnt <= 0;
            dcnt <= 0;
            tx_busy <= 0;
            tx <= 1'b1;
        end
    else
        begin
            case(state)
                s_idle : 
                    begin
                        tx_busy <= 1'b0;
                        cnt <= 0;
                        tx <= 1'b1;
                        if(tx_cmd == 1)
                            state <= s_start;
                        else
                            state <= s_idle;
                    end
                s_start :
                    begin
                        tx_busy <= 1'b1;
                        tx <= 1'b0;
                        state <= s_wait;
                    end
                s_wait :
                    begin
                        tx_busy <= 1'b1;
                        if(cnt >= 4'b1110)
                            begin
                                cnt <= 0;
                                if(dcnt == Lframe)
                                    begin
                                        state <= s_stop;
                                        dcnt <= 0;
                                        tx <= 1'b1;
                                    end
                                else 
                                    begin
                                        state <= s_shift;
                                        tx <= tx;
                                    end
                            end
                        else
                            begin
                                state <= s_wait;
                                cnt <= cnt + 1'b1;
                            end
                    end
                s_shift :
                    begin
                        tx_busy <= 1'b1;
                        tx <= data[dcnt];
                        dcnt <= dcnt + 1'b1;
                        state <= s_wait;
                    end
                s_stop :
                    begin
                        tx <= 1'b1;
                        if(cnt > 4'b1110)
                            begin
                                state <= s_idle;
                                cnt <= 0;
                                tx_busy <= 1'b0;
                            end
                        else
                            begin
                                state <= s_stop;
                                cnt <= cnt +1'b1;
                            end
                    end
            endcase
        end    
end

endmodule
