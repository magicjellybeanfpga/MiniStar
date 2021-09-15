//*****************************************************************************
//COPYRIGHT(c) 2020,Wuhan University Of Techonology
//All rights reserved
//
//Module name  :state_transfer
//File name    :state_transfer.v
//
//Author       :TANG
//Email        :Tangziming@whut.edu.cn
//Data         :20210507
//Version      :1.0
//
//Abstract     :
/******************************************************************************
state transfer of nano viewer 
******************************************************************************/
//Called by    :nano_viewer
//
//Modification history
/******************************************************************************
modifications
******************************************************************************/

//******************
//DEFINES
//******************

//******************
//INCLOUDS
//******************

module state_transfer
(
//INPUTS
    input                sys_clk,       //
    input                sys_rst_n,     //
    input    [7:0]       uart_rx_data,  //
    input                uart_rx_done,  //
    input                pic_rx_done,   //
//OUTPUTS
    output reg  [2:0]    state          //
);

/********************PARAMETERS***************/
localparam READY = 3'd0;
localparam WAIT1 = 3'd1;
localparam WAIT2 = 3'd2;
localparam PRECV = 3'd3;
localparam GAWE1 = 3'd4;
localparam GAWE2 = 3'd5;
localparam GAMED = 3'd6;
localparam SHOWP = 3'd7;
/***************OUTPUT ATTRIBUTE**************/

/******************INNER SIGNAL**************/
//REGS
reg                uart_rx_done_r1    ;//
reg                uart_rx_done_rise  ;//
//WIRES

/***************INSTANCE MODULE**************/

/******************MAIN_CODE*****************/
always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)begin
        uart_rx_done_r1 <=  1'b0;
        uart_rx_done_rise   <=  1'b0;
    end
    else begin
        uart_rx_done_r1 <=  uart_rx_done;
        uart_rx_done_rise   <=  uart_rx_done & ~uart_rx_done_r1;
    end
end

initial begin
    state   <=  READY;
end

always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)begin
        state   <=  READY;
    end
    else if(uart_rx_done_rise) begin
        case(state)
            READY:  state<= (uart_rx_data == 8'hAA)? WAIT1:(uart_rx_data  == 8'hEE)? GAWE1:READY;
            WAIT1:  state<= (uart_rx_data == 8'hBB)? WAIT2:READY;
            WAIT2:  state<= (uart_rx_data == 8'hCC)? PRECV:READY;
            PRECV:  state<= (pic_rx_done  == 1'b1 )? SHOWP:PRECV;
            GAWE1:  state<= (uart_rx_data == 8'hDD)? GAWE2:READY;
            GAWE2:  state<= (uart_rx_data == 8'hCC)? GAMED:READY;
            GAMED:  state<= (uart_rx_data == 8'hAA)? WAIT1:(uart_rx_data  == 8'hFF)? SHOWP:GAMED;
            SHOWP:  state<= (uart_rx_data == 8'hAA)? WAIT1:(uart_rx_data  == 8'hEE)? GAWE1:SHOWP;
        endcase
    end
end

endmodule   