//*****************************************************************************
//COPYRIGHT(c) 2020,Wuhan University Of Techonology
//All rights reserved
//
//Module name  :nanp_viewer
//File name    :nanp_viewer.v
//
//Author       :TANG
//Email        :Tangziming@whut.edu.cn
//Data         :20210420
//Version      :1.0
//
//Abstract     :
/******************************************************************************
top module of nano_viewer
******************************************************************************/
//Called by    :none
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
module nano_viewer(
    //INOUTS
	/*psram phy inout*/
    inout   [7:0]   IO_hpram_dq,
    inout   [0:0]   IO_hpram_rwds,
    inout   [0:0]   dht11,

    //INPUTS
    input           sys_clk,        //系统时钟
    input           sys_rst_n,      //复位信号
    input           uart_rxd,       //蓝牙串口接收

    //OUTPUTS
    /*psram phy output*/
    output  [0:0]   O_hpram_ck,
    output  [0:0]   O_hpram_ck_n,
    output  [0:0]   O_hpram_cs_n,
    output  [0:0]   O_hpram_reset_n,
    /*VGA output*/                     
    output          vga_hs,         //行同步信号
    output          vga_vs,         //场同步信号
    output  [15:0]  vga_rgb,        //红绿蓝三原色输出 
    /*LED output*/
    output          test_led
    ); 

//wire define
wire          mem_clk;
wire          lock_o;
wire          clk_d;

wire          vga_clk;               //PLL得到65Mhz时钟
wire [ 15:0]  pixel_data_w;          //像素点数据
wire [ 10:0]  pixel_xpos_w;          //像素点横坐标
wire [ 10:0]  pixel_ypos_w;          //像素点纵坐标    

wire          dht11_clk;
wire          uart_rx_done;
wire [7:0]    uart_rx_data;
wire          pic_rx_done;
wire          init_calib;
wire          rd_data_valid;
wire [2:0]    state;
wire [31:0]   picture_data;
wire [21:0]   picture_addr;
wire [31:0]   dht11_data;
//*****************************************************
//**                    main code
//***************************************************** 
   
assign test_led =   dht11_clk;

mem_pll u_mem_pll
(
    .clkout(mem_clk),       //output clkout
    .clkoutd(clk_d),
    .lock(lock_o),          //output lock
    .clkin(sys_clk)         //input clkin
);

vga_pll	u_vga_pll
(           
	.clkin       (sys_clk),    
    .clkoutd     (dht11_clk),
	.clkout      (vga_clk)    //VGA时钟 65M
);

vga_driver u_vga_driver
(
    .vga_clk        (vga_clk),    
    .sys_rst_n      (1'b1),    

    .vga_hs         (vga_hs),       
    .vga_vs         (vga_vs),       
    .vga_rgb        (vga_rgb),      
    
    .pixel_data     (pixel_data_w), 
    .pixel_xpos     (pixel_xpos_w), 
    .pixel_ypos     (pixel_ypos_w)
); 
    
vga_display u_vga_display
(
    .vga_clk        (vga_clk),
    .sys_rst_n      (1'b1),
    .state          (state),
    .picture_data   (picture_data),
    .pixel_xpos     (pixel_xpos_w),
    .pixel_ypos     (pixel_ypos_w),
    .picture_addr   (picture_addr),
    .dht11_data     (dht11_data),
    .pixel_data     (pixel_data_w)
);   

uart_rxd u_uart_rxd
(
    .sys_clk        (sys_clk),  
    .sys_rst_n      (1'b1),
    .uart_rxd       (uart_rxd), 
    .uart_done      (uart_rx_done),
    .uart_data      (uart_rx_data)
);

state_transfer u_state_transfer
(
    .sys_clk        (sys_clk),     
    .sys_rst_n      (1'b1),   
    .uart_rx_data   (uart_rx_data),
    .uart_rx_done   (uart_rx_done),
    .pic_rx_done    (pic_rx_done), 
    .state          (state)        
);

dht11_driver u_dht11_driver
(
    .dht11_clk      (dht11_clk),
    .sys_rst_n      (1'b1),
    .dht11          (dht11),
    .dht11_data     (dht11_data)
);

psram_control u_psram_control
(
    .IO_hpram_dq    (IO_hpram_dq  ),
    .IO_hpram_rwds  (IO_hpram_rwds),
    .clk            (clk_d),
    .memory_clk     (mem_clk),
    .pll_lock       (lock_o),
    .rst_n          (1'b1),
    .uart_rx_data   (uart_rx_data),
    .uart_rx_done   (uart_rx_done),
    .state          (state),
    .picture_addr   (picture_addr),
    .O_hpram_ck     (O_hpram_ck),
    .O_hpram_ck_n   (O_hpram_ck_n),
    .O_hpram_cs_n   (O_hpram_cs_n),
    .O_hpram_reset_n(O_hpram_reset_n),
    .init_calib     (init_calib),
    .rd_data_valid  (rd_data_valid),
    .recv_done      (pic_rx_done),
    .picture_data   (picture_data)
);

endmodule 
