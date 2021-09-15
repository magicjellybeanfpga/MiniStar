`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/19 12:43:05
// Design Name: 
// Module Name: Control_TOP
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


module Control_TOP(
                I_sys_clk,
                I_rst_n,

                I_clk_fx,

                I_digtube_en,
                I_digtube_sel,
                I_digtube_seg,
                I_digtube_disp_data,

                uart_tx,
                uart_rx,
                O_led
    );

input I_sys_clk;
input I_rst_n;

input I_clk_fx;
input I_digtube_en;
input [3:0] I_digtube_sel;
input [7:0] I_digtube_seg;
input [15:0] I_digtube_disp_data;

input uart_rx;
output uart_tx;
output reg O_led;

parameter IDLE = 4'd0;
parameter RECVDATA = 4'd1;
parameter CMD = 4'd2;
parameter EXCUSE = 4'd3;
parameter WAIT = 4'd4;
parameter SENDDATA = 4'd5;
parameter DONE = 4'd6;
parameter ERR = 4'd7;


reg [2:0] rx_buf;
wire rx_neg;

always@(posedge I_sys_clk)
begin
    rx_buf <= {rx_buf[1:0],uart_rx};    
end

assign rx_neg = (~rx_buf[1]) & rx_buf[2];

//reg [63:0] Recv_64Byte;

reg [3:0] R_state;
reg [3:0] R_rxstate;
reg [3:0] R_rxjump;
reg [3:0] R_txstate;
reg [3:0] R_txjump;
reg R_recv_done;
reg [63:0] Recv_64Byte;

reg R_Freq_start;
reg R_Digtube_start;

reg [63:0] R_data0;
reg [63:0] Xmt_64Byte;
reg R_xmt_done ;
reg R_flag;
reg R_measure_1;
reg [3:0] R_rst_measure;
reg [31:0] Err_cnt;

reg [63:0] R_mark;
reg [63:0] rxdata_tmp;
reg [7:0] R_rxlength;

reg [7:0] R_txlength;
reg [7:0] txdata_tmp8;

always @(posedge I_sys_clk or negedge I_rst_n) begin
    if(!I_rst_n) begin
        R_state <= IDLE;
        R_rxstate <= 4'd0;
        R_rxjump <= 4'd0;
        R_txstate <= 4'd0;
        R_txjump <= 4'd0;
        R_recv_done <= 0;
        Recv_64Byte <= 64'd0;

        R_mark <= 64'hff;
        rxdata_tmp <= 64'h0;
        R_rxlength <= 0;
        R_txlength <= 0;
        txdata_tmp8 <= 0;

        R_Freq_start <= 1'b0;
        R_Digtube_start <= 1'b0;

        R_data0 <= 64'd0;
        Xmt_64Byte <= 64'd0;
        R_xmt_done <= 0;
        R_flag <= 0;
        R_measure_1 <= 0;
        R_rst_measure <= 0;
        Err_cnt <= 0;
        O_led <= 1'b1;
    end
    else begin
        case (R_state)
            IDLE : begin
                R_rxstate <= 4'd0;
                R_rxjump <= 4'd0;
                R_txstate <= 4'd0;
                R_txjump <= 4'd0;
                R_state <= RECVDATA;
                R_recv_done <= 0;
                Recv_64Byte <= 64'd0;

                R_mark <= 64'hff;
                rxdata_tmp <= 64'h0;
                R_rxlength <= 0;

                R_txlength <= 0;
                txdata_tmp8 <= 0;

                R_Freq_start <= 1'b0;
                R_Digtube_start <= 1'b0;

                R_data0 <= 64'd0;
                Xmt_64Byte <= 64'd0;
                R_xmt_done <= 0;
                R_flag <= 0;
                R_measure_1 <= 0;
                R_rst_measure <= 0;
                Err_cnt <= 0;
                O_led <= 1'b1;
            end 
            RECVDATA : begin
                case (R_rxstate)
                    4'd0 : begin
                        R_recv_done <= 1'b0;
                        if(rx_neg == 1) begin
                            R_rxstate <= 4'd1;
                            Recv_64Byte <= 64'd0;
                            R_mark <= 64'hff;
                            rxdata_tmp <= 64'h0;
                            R_rxlength <= 0;
                        end
                        else begin
                            R_rxstate <= 4'd0;
                        end
                    end
                    4'd1 : begin
                        if(rx_done == 1'b1) begin
                            rxdata_tmp <= {8{rxdata}};
                            
                            R_rxstate <= 4'd2;
                            // Recv_64Byte <= (Recv_64Byte | rxdata);

                        end
                        else begin
                            R_rxstate <= 4'd1;
                        end
                    end
                    // 4'd1 : begin
                    //     if(rx_done == 1'b1)begin
                    //         Recv_64Byte[7:0] <= rxdata;
                    //         R_rxstate <= 4'd2;
                    //         R_rxjump <= 4'd3;
                    //     end
                    //     else begin
                    //         R_rxstate <= 4'd1;
                    //     end
                    // end
                    4'd2 : begin
                        // if((rx_busy == 1'b0)&(rx_neg == 1)) begin
                        //     R_rxstate <= 4'd1;
                        //     R_rxlength <= R_rxlength + 1;
                        //     Recv_64Byte <= (Recv_64Byte | (rxdata_tmp & R_mark));
                        //     R_mark <= (R_mark << 8);
                        //     //Recv_64Byte <= 64'd0;
                        // end
                        // else begin
                        //     R_rxstate <= 4'd2;
                        // end
                        if(R_rxlength == 8'd7) begin
                            R_rxstate <= 4'd10;
                            Recv_64Byte[63:56] <= rxdata_tmp[7:0];
                        end
                        else begin
                            if((rx_busy == 1'b0)&(rx_neg == 1)) begin
                                R_rxstate <= 4'd1;
                                R_rxlength <= R_rxlength + 1;
                                Recv_64Byte <= (Recv_64Byte | (rxdata_tmp & R_mark));
                                R_mark <= (R_mark << 8);
                                //Recv_64Byte <= 64'd0;
                            end
                            else begin
                                R_rxstate <= 4'd2;
                            end
                        end
                    end
                    // 4'd3 : begin
                    //     if(rx_done == 1'b1)begin
                    //         Recv_64Byte[15:8] <= rxdata;
                    //         R_rxstate <= 4'd2;
                    //         R_rxjump <= 4'd4;
                    //     end
                    //     else begin
                    //         R_rxstate <= 4'd3;
                    //     end
                    // end
                    // 4'd4 : begin
                    //     if(rx_done == 1'b1)begin
                    //         Recv_64Byte[23:16] <= rxdata;
                    //         R_rxstate <= 4'd2;
                    //         R_rxjump <= 4'd5;
                    //     end
                    //     else begin
                    //         R_rxstate <= 4'd4;
                    //     end
                    // end
                    // 4'd5 : begin
                    //     if(rx_done == 1'b1)begin
                    //         Recv_64Byte[31:24] <= rxdata;
                    //         R_rxstate <= 4'd2;
                    //         R_rxjump <= 4'd6;
                    //     end
                    //     else begin
                    //         R_rxstate <= 4'd5;
                    //     end
                    // end
                    // 4'd6 : begin
                    //     if(rx_done == 1'b1)begin
                    //         Recv_64Byte[39:32] <= rxdata;
                    //         R_rxstate <= 4'd2;
                    //         R_rxjump <= 4'd7;
                    //     end
                    //     else begin
                    //         R_rxstate <= 4'd6;
                    //     end
                    // end
                    // 4'd7 : begin
                    //     if(rx_done == 1'b1)begin
                    //         Recv_64Byte[47:40] <= rxdata;
                    //         R_rxstate <= 4'd2;
                    //         R_rxjump <= 4'd8;
                    //     end
                    //     else begin
                    //         R_rxstate <= 4'd7;
                    //     end
                    // end
                    // 4'd8 : begin
                    //     if(rx_done == 1'b1)begin
                    //         Recv_64Byte[55:48] <= rxdata;
                    //         R_rxstate <= 4'd2;
                    //         R_rxjump <= 4'd9;
                    //     end
                    //     else begin
                    //         R_rxstate <= 4'd8;
                    //     end
                    // end
                    // 4'd9 : begin
                    //     if(rx_done == 1'b1)begin
                    //         Recv_64Byte[63:56] <= rxdata;
                    //         R_rxstate <= 4'd10;
                    //         //R_rxjump <= 4'd8;
                    //     end
                    //     else begin
                    //         R_rxstate <= 4'd9;
                    //     end
                    // end
                    4'd10 : begin
                        R_recv_done <= 1'b1;
                        R_rxstate <= 4'd10;
                        R_state <= CMD;
                    end
                    default: begin
                        R_state <= ERR;
                    end
                endcase
            end
            CMD : begin
                if(Recv_64Byte[63:56] == 8'hA5) begin
                    if(Recv_64Byte[7:0] == 8'hEC) begin
                        R_state <= EXCUSE;
                        R_measure_1 <= 1;
                    end
                    else begin
                        R_state <= ERR;
                    end
                end
                else begin
                    R_state <= ERR;
                end
            end
            EXCUSE : begin
                if(Recv_64Byte[55:8] == 48'h1) begin
                    if(R_rst_measure == 5) begin
                        R_rst_measure <= 0;
                        R_Freq_start <= 1;
                        R_state <= WAIT;
                    end
                    else begin
                        R_rst_measure <= R_rst_measure + 1;
                        R_state <= EXCUSE;
                    end
                end
                else if(Recv_64Byte[55:8] == 48'h2) begin
                    if(R_rst_measure == 5) begin
                        R_rst_measure <= 0;
                        R_Digtube_start <= 1;
                        R_state <= WAIT;
                    end
                    else begin
                        R_rst_measure <= R_rst_measure + 1;
                        R_state <= EXCUSE;
                    end
                end
                else begin
                    R_state <= ERR;
                end
            end
            WAIT : begin
                if(W_done) begin
                    R_data0 <= {data0,data1};
                    R_state <= SENDDATA;
                end
                else begin
                    R_state <= WAIT;
                end 
            end
            SENDDATA : begin
                case (R_txstate)
                    4'd0 : begin
                        Xmt_64Byte <= R_data0;
                        R_txstate <= 4'd1;
                        txdata_tmp8 <= 8'h5A;
                    end 
                    4'd1 : begin
                        //txdata_tmp8 <= 8'h5A;
                        if((tx_busy == 0)) begin
                            txdata <= txdata_tmp8;
                            R_txstate <= 4'd10;
                            //R_txjump <= 4'd2;
                        end
                        else begin
                            R_txstate <= 4'd1;
                        end
                    end
                    // 4'd1 : begin
                    //     if((tx_busy == 0) )begin
                    //         txdata <= Xmt_64Byte[63:56];
                    //         R_txstate <= 4'd10;
                    //         R_txjump <= 4'd2;
                    //     end
                    //     else begin
                    //         R_txstate <= 4'd1;
                    //     end
                    // end
                    // 4'd2 : begin
                    //     if((tx_busy == 0) )begin
                    //         txdata <= Xmt_64Byte[55:48];
                    //         R_txstate <= 4'd10;
                    //         R_txjump <= 4'd3;
                    //     end
                    //     else begin
                    //         R_txstate <= 4'd2;
                    //     end
                    // end
                    // 4'd3 : begin
                    //     if((tx_busy == 0) )begin
                    //         txdata <= Xmt_64Byte[47:40];
                    //         R_txstate <= 4'd10;
                    //         R_txjump <= 4'd4;
                    //     end
                    //     else begin
                    //         R_txstate <= 4'd3;
                    //     end
                    // end

                    // 4'd4:begin
                    //     if((tx_busy == 0) )begin
                    //         txdata <= Xmt_64Byte[39:32];
                    //         R_txstate <= 4'd10;
                    //         R_txjump <= 4'd5;
                    //     end
                    //     else begin
                    //         R_txstate <= 4'd4;
                    //     end
                    // end
                    // 4'd5:begin
                    //     if((tx_busy == 0) )begin
                    //         txdata <= Xmt_64Byte[31:24];
                    //         R_txstate <= 4'd10;
                    //         R_txjump <= 4'd6;
                    //     end
                    //     else begin
                    //         R_txstate <= 4'd5;
                    //     end
                    // end
                    // 4'd6:begin
                    //     if((tx_busy == 0) )begin
                    //         txdata <= Xmt_64Byte[23:16];
                    //         R_txstate <= 4'd10;
                    //         R_txjump <= 4'd7;
                    //     end
                    //     else begin
                    //         R_txstate <= 4'd6;
                    //     end
                    // end
                    // 4'd7:begin
                    //     if((tx_busy == 0) )begin
                    //         txdata <= Xmt_64Byte[15:8];
                    //         R_txstate <= 4'd10;
                    //         R_txjump <= 4'd8;
                    //     end
                    //     else begin
                    //         R_txstate <= 4'd7;
                    //     end
                    // end
                    // 4'd8:begin
                    //     if((tx_busy == 0) )begin
                    //         txdata <= Xmt_64Byte[7:0];
                    //         R_txstate <= 4'd10;
                    //         R_txjump <= 4'd9;
                    //     end
                    //     else begin
                    //         R_txstate <= 4'd8;
                    //     end
                    // end
                    4'd9:begin
                        R_xmt_done <= 1'b1;
                        R_txstate <= 4'd0;
                        R_state <= DONE;
                    end
                    4'd10:begin
                        R_flag <= 1'b1;
                        R_txstate <= 4'd11;
                        
                    end
                    4'd11:begin
                        if(pluse == 1'b1)begin
                            R_flag <= 1'b0;
                            if(R_txlength == 8'd8) begin
                                R_txstate <= 4'd9;
                            end
                            else begin
                                R_txstate <= 4'd1;
                                R_txlength <= R_txlength + 1;
                                txdata_tmp8 <= (Xmt_64Byte & 8'hFF);
                                Xmt_64Byte <= (Xmt_64Byte >> 8);
                            end
                            
                        end
                        else begin
                            R_flag <= R_flag;
                        end
                    end
                    default: R_state <= SENDDATA;
                endcase
            end
            DONE : begin
                R_state <= IDLE;
            end
            ERR : begin
                if(Err_cnt == 32'd49_999) begin
                    O_led <= 1'b0;
                    Err_cnt <= 0;
                    R_state <= IDLE;
                end
                else begin
                    Err_cnt <= Err_cnt + 1;
                    R_state <= ERR;
                end
            end
            default: begin
                R_state <= ERR;
            end
        endcase
    end
end

reg [15:0] pluse_count;
reg pluse;
reg tx_en;

always@(posedge I_sys_clk)
begin
    if(~I_rst_n) begin
        pluse_count <= 0;
        pluse <= 1'b0;
        tx_en <= 1'b0;
    end
    else begin
        if(R_flag == 1'b1) begin
            tx_en <= 1'b1;
            if(pluse_count == 16'h4E20) begin
                tx_en <= 1'b0;
                pluse <= 1'b1;
            end
            else 
                pluse_count <= pluse_count + 1'b1;
        end
        else begin
            tx_en <= 1'b0;
            pluse <= 1'b0;
            pluse_count <= 0;
        end
    end
end




wire clkb;
reg [7:0] txdata;
wire [7:0] rxdata;

USART_Band #(.BandRate(9600)) 
        USART_Band_inst1(
                    .clk(I_sys_clk),
                    .rst_n(I_rst_n),
                    .clkb(clkb)
                );

USART_tx USART_tx_inst1(
            .clkb(clkb),
            .rst_n(I_rst_n),
            .data(txdata),
            .tx_en(tx_en),
            .tx_busy(tx_busy),
            .tx(uart_tx)
            );

USART_rx USART_rx_inst1(
            .clkb(clkb),
            .rst_n(I_rst_n),
            .rx(uart_rx),
            .rx_busy(rx_busy),
            .rx_done(rx_done),
            .rxdata(rxdata)
            );
/*-------------------------------------------------------------*/
wire [31:0] data_in0;
wire [31:0] data_in1;

MeasureFreq measure_inst0(
            .I_sys_clk(I_sys_clk),
            .I_clk_fx(I_clk_fx),
            .I_rst_n((I_rst_n & R_measure_1)),
            .I_start(R_Freq_start),

            .O_done(Freq_done),
            .O_f0_cnt(data_in0),
            .O_fx_cnt(data_in1)

    );

reg [1:0] R_done_buf;
wire Freq_done_pos;

always @(posedge I_sys_clk) begin
    R_done_buf <= {R_done_buf[0],Freq_done};
end

assign Freq_done_pos = (R_done_buf == 2'b01) ? 1 : 0;
/*-------------------------------------------------------------*/

/*-------------------------------------------------------------*/
wire [31:0] data_in2;
wire [31:0] data_in3;
wire digtube_done;

DigitalTube_Mea MeaDut_inst0(
                .I_sys_clk(I_sys_clk),
                .I_rst_n(I_rst_n),

                .I_start(R_Digtube_start),

                .I_test_en(I_digtube_en),
                .I_test_sel(I_digtube_sel),
                .I_test_seg(I_digtube_seg),
                .I_test_disp_data(I_digtube_disp_data),

                .O_data0(data_in2),
                .O_data1(data_in3),
                .O_done(digtube_done)
    );

reg [1:0] R_digtube_done_buf;
wire W_digtube_done_pos;

always @(posedge I_sys_clk) begin
    R_digtube_done_buf <= {R_digtube_done_buf[0],digtube_done};
end

assign W_digtube_done_pos = (R_digtube_done_buf == 2'b01) ? 1 : 0;

/*-------------------------------------------------------------*/
wire W_done;
assign W_done = (Recv_64Byte[55:8] == 1) ? Freq_done_pos : 
                ((Recv_64Byte[55:8] == 2) ? W_digtube_done_pos : 0);


wire [31:0] data0;
wire [31:0] data1;

assign data0 = (Recv_64Byte[55:8] == 1) ? data_in0 : 
                ((Recv_64Byte[55:8] == 2) ? data_in2 : 0);

assign data1 = (Recv_64Byte[55:8] == 1) ? data_in1 : 
                ((Recv_64Byte[55:8] == 2) ? data_in3 : 0);

//ila_0 your_instance_name (
//	.clk(I_sys_clk), // input wire clk


//	.probe0(I_rst_n), // input wire [0:0]  probe0  
//	.probe1(R_Digtube_start), // input wire [0:0]  probe1 
//	.probe2(W_digtube_done_pos), // input wire [0:0]  probe2 
//	.probe3(R_state), // input wire [3:0]  probe3 
//	.probe4(R_rxstate), // input wire [3:0]  probe4 
//	.probe5(R_rxjump), // input wire [3:0]  probe5 
//	.probe6(R_txstate), // input wire [3:0]  probe6 
//	.probe7(R_txjump), // input wire [3:0]  probe7 
//	.probe8(Recv_64Byte), // input wire [63:0]  probe8 
//	.probe9(R_data0) // input wire [63:0]  probe9
//);


endmodule
