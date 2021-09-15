//*****************************************************************************
//COPYRIGHT(c) 2020,Wuhan University Of Techonology
//All rights reserved
//
//Module name  :psram_control
//File name    :psram_control.v
//
//Author       :TANG
//Email        :Tangziming@whut.edu.cn
//Data         :20210507
//Version      :1.0
//
//Abstract     :
/******************************************************************************
Interface of nanoviewer recive picture
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

module psram_control
(
//INOUTS
	/*phy inout*/
    inout   [7:0]        IO_hpram_dq,
    inout   [0:0]        IO_hpram_rwds,
//INPUTS
    /*phy input*/
    input                clk,         
    input                memory_clk,
    input                pll_lock,
    input                rst_n,
    /*user input*/
    input   [7:0]        uart_rx_data,
    input                uart_rx_done,
    input   [2:0]        state,
    input   [21:0]       picture_addr,
//OUTPUTS
    /*phy output*/
    output  [0:0]        O_hpram_ck,
    output  [0:0]        O_hpram_ck_n,
    output  [0:0]        O_hpram_cs_n,
    output  [0:0]        O_hpram_reset_n,
    /*user output*/
	output               rd_data_valid,
	output 				 init_calib,
	output  reg          recv_done,
    output  reg [31:0]   picture_data
);

/********************PARAMETERS***************/
localparam WAIT1 = 3'd1;
localparam PRECV = 3'd3;
localparam SHOWP = 3'd7;
localparam IMG_WIDTH = 11'd20;
localparam IMG_HIGHT = 11'd20;
localparam MAX_ADDR  = 22'd4_000;//IMG_WIDTH*IMG_HIGHT;
/***************OUTPUT ATTRIBUTE**************/

/******************INNER SIGNAL**************/
//REGS
reg                 uart_rx_done_r1;
reg                 uart_rx_done_rise;
reg 	[4:0]	    lub_sel;
reg 	[21:0]	    pixel_cnt;
reg 	[255:0]	    pixel_data;

reg 			    writing;
reg		[2:0]	    write_cycle;
reg 			    reading;
reg 	[2:0]	    read_cycle;

reg 	[21:0]		addr;
reg 	[21:0]		addr_buf;
reg 				cmd;
reg 				cmd_en;
//WIRES
wire 	[3:0]		data_mask;
wire                clk_out;
reg	    [31:0]		wr_data;
wire 	[31:0]		rd_data;

/***************INSTANCE MODULE**************/
HyperRAM_Memory_Interface_Top u_hyper_ram(
	.clk(clk), //input clk
	.memory_clk(memory_clk), //input memory_clk
	.pll_lock(pll_lock), //input pll_lock
	.rst_n(rst_n), //input rst_n
	.O_hpram_ck(O_hpram_ck), //output [0:0] O_hpram_ck
	.O_hpram_ck_n(O_hpram_ck_n), //output [0:0] O_hpram_ck_n
	.IO_hpram_dq(IO_hpram_dq), //inout [7:0] IO_hpram_dq
	.IO_hpram_rwds(IO_hpram_rwds), //inout [0:0] IO_hpram_rwds
	.O_hpram_cs_n(O_hpram_cs_n), //output [0:0] O_hpram_cs_n
	.O_hpram_reset_n(O_hpram_reset_n), //output [0:0] O_hpram_reset_n
	.wr_data(wr_data), //input [31:0] wr_data
	.rd_data(rd_data), //output [31:0] rd_data
	.rd_data_valid(rd_data_valid), //output rd_data_valid
	.addr(addr), //input [21:0] addr
	.cmd(cmd), //input cmd
	.cmd_en(cmd_en), //input cmd_en
	.init_calib(init_calib), //output init_calib
	.clk_out(clk_out), //output clk_out
	.data_mask(data_mask) //input [3:0] data_mask
);
/******************MAIN_CODE*****************/
assign	data_mask	=	4'b0000;


always @(posedge clk_out) begin
    uart_rx_done_r1 	<=  uart_rx_done;
    uart_rx_done_rise   <=  uart_rx_done & ~uart_rx_done_r1;
end

always @(posedge clk_out) begin
	if(state ==	WAIT1)begin
		lub_sel	<=	5'd0;
		addr	<=	22'd0;
		pixel_cnt	<=	22'd0;
		recv_done	<=	1'b0;
		writing		<=	1'b0;
		reading		<=	1'b0;
		write_cycle	<=	3'd0;
		read_cycle	<=	3'd0;
	end
	else if(state == PRECV && init_calib)begin
		if(pixel_cnt >= MAX_ADDR)begin
			recv_done	<=	1'b1;
		end
		else if(writing == 1'b1)begin
			case(write_cycle)
				3'd0:begin//写1-2像素
					cmd		<=	1'b1;
					cmd_en	<=	1'b1;
					addr		<=	(pixel_cnt>>1) - 8;
					wr_data	<=	pixel_data[31:0];
					write_cycle <=	3'd1;
				end
				3'd1:begin//
					cmd		<=	1'b0;
					cmd_en	<=	1'b0;
					addr		<=	22'd0;
					wr_data	<=	pixel_data[63:32];
					write_cycle <=	3'd2;
				end
				3'd2:begin//
					cmd		<=	1'b0;
					cmd_en	<=	1'b0;
					addr		<=	22'd0;
					wr_data	<=	pixel_data[95:64];
					write_cycle <=	3'd3;
				end
				3'd3:begin//
					cmd		<=	1'b0;
					cmd_en	<=	1'b0;
					addr		<=	22'd0;
					wr_data	<=	pixel_data[127:96];
					write_cycle <=	3'd4;
				end
				3'd4:begin//
					cmd		<=	1'b0;
					cmd_en	<=	1'b0;
					addr		<=	22'd0;
					wr_data	<=	pixel_data[159:128];
					write_cycle <=	3'd5;
				end
				3'd5:begin//
					cmd		<=	1'b0;
					cmd_en	<=	1'b0;
					addr		<=	22'd0;
					wr_data	<=	pixel_data[191:160];
					write_cycle <=	3'd6;
				end
				3'd6:begin//
					cmd		<=	1'b0;
					cmd_en	<=	1'b0;
					addr		<=	22'd0;
					wr_data	<=	pixel_data[223:192];
					write_cycle <=	3'd7;
				end
				3'd7:begin//
					cmd		<=	1'b0;
					cmd_en	<=	1'b0;
					addr		<=	22'd0;
					wr_data	<=	pixel_data[255:224];
					write_cycle <=	3'd0;
					writing		<=	1'b0;
				end
			endcase
		end
		else if(uart_rx_done_rise)begin//像素数据采集与合并
			case(lub_sel)
				5'd0:	begin	pixel_data[7:0]			<=	uart_rx_data;	lub_sel<=lub_sel+5'd1;	end
				5'd1:	begin	pixel_data[15:8]		<=	uart_rx_data;	lub_sel<=lub_sel+5'd1;	end
				5'd2:	begin	pixel_data[23:16]		<=	uart_rx_data;	lub_sel<=lub_sel+5'd1;	end
				5'd3:	begin	pixel_data[31:24]		<=	uart_rx_data;	lub_sel<=lub_sel+5'd1;	end
				5'd4:	begin	pixel_data[39:32]		<=	uart_rx_data;	lub_sel<=lub_sel+5'd1;	end
				5'd5:	begin	pixel_data[47:40]		<=	uart_rx_data;	lub_sel<=lub_sel+5'd1;	end
				5'd6:	begin	pixel_data[55:48]		<=	uart_rx_data;	lub_sel<=lub_sel+5'd1;	end
				5'd7:	begin	pixel_data[63:56]		<=	uart_rx_data;	lub_sel<=lub_sel+5'd1;	end
				5'd8:	begin	pixel_data[71:64]		<=	uart_rx_data;	lub_sel<=lub_sel+5'd1;	end
				5'd9:	begin	pixel_data[79:72]		<=	uart_rx_data;	lub_sel<=lub_sel+5'd1;	end
				5'd10:	begin	pixel_data[87:80]		<=	uart_rx_data;	lub_sel<=lub_sel+5'd1;	end
				5'd11:	begin	pixel_data[95:88]		<=	uart_rx_data;	lub_sel<=lub_sel+5'd1;	end
				5'd12:	begin	pixel_data[103:96]		<=	uart_rx_data;	lub_sel<=lub_sel+5'd1;	end
				5'd13:	begin	pixel_data[111:104]		<=	uart_rx_data;	lub_sel<=lub_sel+5'd1;	end
				5'd14:	begin	pixel_data[119:112]		<=	uart_rx_data;	lub_sel<=lub_sel+5'd1;	end
				5'd15:	begin	pixel_data[127:120]		<=	uart_rx_data;	lub_sel<=lub_sel+5'd1;	end
				5'd16:	begin	pixel_data[135:128]		<=	uart_rx_data;	lub_sel<=lub_sel+5'd1;	end
				5'd17:	begin	pixel_data[143:136]		<=	uart_rx_data;	lub_sel<=lub_sel+5'd1;	end
				5'd18:	begin	pixel_data[151:144]		<=	uart_rx_data;	lub_sel<=lub_sel+5'd1;	end
				5'd19:	begin	pixel_data[159:152]		<=	uart_rx_data;	lub_sel<=lub_sel+5'd1;	end
				5'd20:	begin	pixel_data[167:160]		<=	uart_rx_data;	lub_sel<=lub_sel+5'd1;	end
				5'd21:	begin	pixel_data[175:168]		<=	uart_rx_data;	lub_sel<=lub_sel+5'd1;	end
				5'd22:	begin	pixel_data[183:176]		<=	uart_rx_data;	lub_sel<=lub_sel+5'd1;	end
				5'd23:	begin	pixel_data[191:184]		<=	uart_rx_data;	lub_sel<=lub_sel+5'd1;	end
				5'd24:	begin	pixel_data[199:192]		<=	uart_rx_data;	lub_sel<=lub_sel+5'd1;	end
				5'd25:	begin	pixel_data[207:200]		<=	uart_rx_data;	lub_sel<=lub_sel+5'd1;	end
				5'd26:	begin	pixel_data[215:208]		<=	uart_rx_data;	lub_sel<=lub_sel+5'd1;	end
				5'd27:	begin	pixel_data[223:216]		<=	uart_rx_data;	lub_sel<=lub_sel+5'd1;	end
				5'd28:	begin	pixel_data[231:224]		<=	uart_rx_data;	lub_sel<=lub_sel+5'd1;	end
				5'd29:	begin	pixel_data[239:232]		<=	uart_rx_data;	lub_sel<=lub_sel+5'd1;	end
				5'd30:	begin	pixel_data[247:240]		<=	uart_rx_data;	lub_sel<=lub_sel+5'd1;	end
				5'd31:	begin
					lub_sel					<=	5'd0;
					pixel_data[255:248]		<=	uart_rx_data;
					pixel_cnt				<=	pixel_cnt + 22'd16;
					writing					<=	1'b1;
				end
			endcase
		end
	end
	else if(state == SHOWP && init_calib)begin
		if(reading	==	1 && rd_data_valid)begin//读状态
			case (read_cycle)
				0:begin
					picture_data<=	rd_data[31:0];
					cmd		<=	1'b0;
					cmd_en	<=	1'b0;
					read_cycle	<=	3'd1;
				end
				1:begin
					picture_data<=	rd_data[31:0];
					cmd		<=	1'b0;
					cmd_en	<=	1'b0;
					read_cycle	<=	3'd2;
				end
				2:begin
					picture_data<=	rd_data[31:0];
					cmd		<=	1'b0;
					cmd_en	<=	1'b0;
					read_cycle	<=	3'd3;
				end
				3:begin
					picture_data<=	rd_data[31:0];
					cmd		<=	1'b0;
					cmd_en	<=	1'b0;
					read_cycle	<=	3'd4;
				end
				4:begin
					picture_data<=	rd_data[31:0];
					cmd		<=	1'b0;
					cmd_en	<=	1'b0;
					read_cycle	<=	3'd5;
				end
				5:begin
					picture_data<=	rd_data[31:0];
					cmd		<=	1'b0;
					cmd_en	<=	1'b0;
					read_cycle	<=	3'd6;
				end
				6:begin
					picture_data<=	rd_data[31:0];
					cmd		<=	1'b0;
					cmd_en	<=	1'b0;
					read_cycle	<=	3'd7;
				end
				7:begin
					picture_data<=	rd_data[31:0];
					cmd		<=	1'b0;
					cmd_en	<=	1'b0;
					read_cycle	<=	3'd0;
					reading		<=	1'b0;
				end
			endcase
		end
		else if((picture_addr ^ addr_buf) && reading == 0) begin
			reading	<=	1'b1;
			addr	<=	22'd0;//picture_addr
			cmd		<=	1'b0;
			cmd_en	<=	1'b1;
		end
		else begin
			addr_buf <=	picture_addr;
		end
	end
end

endmodule   