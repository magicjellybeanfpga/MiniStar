
`resetall

module Gowin_EMPU_Template (
    input    sys_clk,
    input    reset_n,

// rmii rtl8201cp
    input              eth_rx_clk  ,    //MII接收数据时钟
    input              eth_rxdv    ,    //MII输入数据有效信号
    input              eth_tx_clk  ,    //MII发送数据时钟
    input       [3:0]  eth_rx_data ,    //MII输入数据
    output             eth_tx_en   ,    //MII输出数据有效信号
    output      [3:0]  eth_tx_data ,    //MII输出数据          
    output             eth_rst_n   ,     //以太网芯片复位信号，低电平有效  


// spi to vs1003b
    output   spi0_clk,
    output   spi0_mosi, 
    output   spi0_nss,    
    input    spi0_miso,  

    inout   mp3_xreset,
    inout   mp3_dreq,
    inout   mp3_xdcs,

// cotex-m3 debug
    input    uart0_rxd,
    output   uart0_txd,

// test led
    inout    arm_led,
    output   led          // fpga-led
);


// AHB2 Master
wire master_hclk;
wire master_hrst;
wire master_hsel;
wire [31:0] master_haddr;
wire [1:0] master_htrans;
wire master_hwrite;
wire [2:0] master_hsize;
wire [2:0] master_hburst;
wire [3:0] master_hprot;
wire [1:0] master_memattr;
wire master_exreq;
wire [3:0] master_hmaster;
wire [31:0] master_hwdata;
wire master_hmastlock;
wire master_hreadymux;
wire master_hauser;
wire [3:0] master_hwuser;
wire [31:0] master_hrdata;
wire master_hreadyout;
wire master_hresp;

wire clk_72M ;  //mcu clock = 72MHz
wire clk_144M;  //clock = 144MHz
wire refclk_27M;   // xtal 27MHZ

// pll
Gowin_PLLVR u_Gowin_PLLVR(
    .clkout(clk_144M), //output clkout  144MHz
    .clkoutp(refclk_27M), //output clkoutp
    .clkoutd(clk_72M), //output clkoutd            72MHz
    .clkin(sys_clk) //input clkin               27MHz    
);



wire [15:0] gpio0;

// 连接GPIO0到引脚
assign arm_led  = gpio0[0];

// vs1003b
assign mp3_xreset    = gpio0[13];
assign mp3_xdcs      = gpio0[12];   
assign mp3_dreq      = gpio0[15];  


//parameter define
//开发板MAC地址 00-11-22-33-44-55
parameter  BOARD_MAC = 48'h00_11_22_33_44_55;     
//开发板IP地址 192.168.101.123       
parameter  BOARD_IP  = {8'd192,8'd168,8'd101,8'd123};  
//目的MAC地址 ff_ff_ff_ff_ff_ff
parameter  DES_MAC   = 48'h00_e0_1a_68_00_b3;    
//目的IP地址 192.168.101.132     
parameter  DES_IP    = {8'd192,8'd168,8'd101,8'd132};  

//wire define
wire            rec_pkt_done;           //以太网单包数据接收完成信号
wire            rec_en      ;           //以太网接收的数据使能信号
wire   [31:0]   rec_data    ;           //以太网接收的数据
wire   [15:0]   rec_byte_num;           //以太网接收的有效字节数 单位:byte 
wire            tx_done     ;           //以太网发送完成信号
wire            tx_req      ;           //读数据请求信号  

wire            tx_start_en ;           //以太网开始发送信号
wire   [31:0]   tx_data     ;           //以太网待发送数据 

//*****************************************************
//**                    main code
//*****************************************************

//UDP模块
udp                                     //参数例化        
   #(
    .BOARD_MAC       (BOARD_MAC),
    .BOARD_IP        (BOARD_IP ),
    .DES_MAC         (DES_MAC  ),
    .DES_IP          (DES_IP   )
    )
   u_udp(
    .eth_rx_clk      (eth_rx_clk  ),           
    .rst_n           (reset_n   ),       
    .eth_rxdv        (eth_rxdv    ),         
    .eth_rx_data     (eth_rx_data ),                   
    .eth_tx_clk      (eth_tx_clk  ),           
    .tx_start_en     (tx_start_en ),        
    .tx_data         (tx_data     ),         
    .tx_byte_num     (rec_byte_num),    
    .tx_done         (tx_done     ),        
    .tx_req          (tx_req      ),          
    .rec_pkt_done    (rec_pkt_done),    
    .rec_en          (rec_en      ),     
    .rec_data        (rec_data    ),         
    .rec_byte_num    (rec_byte_num),            
    .eth_tx_en       (eth_tx_en   ),         
    .eth_tx_data     (eth_tx_data ),             
    .eth_rst_n       (eth_rst_n   )     
    ); 

//脉冲信号同步处理模块
pulse_sync_pro u_pulse_sync_pro(
    .clk_a          (eth_rx_clk),
    .rst_n          (reset_n),
    .pulse_a        (rec_pkt_done),
    .clk_b          (eth_tx_clk),
    .pulse_b        (tx_start_en)
    );
/*
//fifo模块，用于缓存单包数据
async_fifo_2048x32b u_fifo_2048x32b(
    .aclr        (~sys_rst_n),
    .data        (rec_data  ),          //fifo写数据
    .rdclk       (eth_tx_clk),
    .rdreq       (tx_req    ),          //fifo读使能 
    .wrclk       (eth_rx_clk),          
    .wrreq       (rec_en    ),          //fifo写使能
    .q           (tx_data   ),          //fifo读数据 
    .rdempty     (),
    .wrfull      ()
    );
*/

//fifo模块，用于缓存单包数据
fifo_top your_instance_name(
    .RdClk  (eth_tx_clk ), //input RdClk
    .RdEn   (tx_req     ), //input RdEn
    .Q      (tx_data    ), //output [31:0] Q

    .WrClk  (eth_rx_clk ), //input WrClk
    .WrEn   (rec_en     ), //input WrEn
    .Data   (rec_data   ), //input [31:0] Data

    .Wnum   (), //output [11:0] Wnum
    .Rnum   (), //output [11:0] Rnum

    .Empty  (), //output Empty
    .Full   () //output Full
);


//AHB to ARM instantiation
Gowin_AHB_TOARM_Top u_Gowin_AHB_TOARM_Top (
  .hpram_base_clk(refclk_27M),     //72MHz
  .hpram_memory_clk(clk_144M), //144MHz

   .led_init(),

  .AHB_HRDATA(master_hrdata),
  .AHB_HREADY(master_hreadyout),
  .AHB_HRESP(master_hresp),
  .AHB_HTRANS(master_htrans),
  .AHB_HBURST(master_hburst),
  .AHB_HPROT(master_hprot),
  .AHB_HSIZE(master_hsize),
  .AHB_HWRITE(master_hwrite),
  .AHB_HMASTLOCK(master_hmastlock),
  .AHB_HMASTER(master_hmaster),
  .AHB_HADDR(master_haddr),
  .AHB_HWDATA(master_hwdata),
  .AHB_HSEL(master_hsel),
  .AHB_HCLK(master_hclk),
  .AHB_HRESETn(master_hrst)
);


// Cortex-M3 CPU
Gowin_EMPU_Top u_Gowin_EMPU_Top(
    .sys_clk(clk_72M), //input sys_clk
    .reset_n(reset_n), //input reset_n

    .uart0_rxd(uart0_rxd), //input uart0_rxd
    .uart0_txd(uart0_txd), //output uart0_txd
//    .uart1_rxd(), //input uart1_rxd
//    .uart1_txd(), //output uart1_txd

    .gpio(gpio0), //inout [15:0] gpio

    .mosi   (spi0_mosi), //output mosi
    .miso   (spi0_miso), //input  miso
    .sclk   (spi0_clk), //output sclk
    .nss    (spi0_nss), //output nss

// user interrupt
    .user_int_0(), //input user_int_0  

/*
//----APB Master----//
    .master_pclk(), //output master_pclk
    .master_rst(), //output master_rst
    .master_penable(), //output master_penable
    .master_paddr(), //output [7:0] master_paddr
    .master_pwrite(), //output master_pwrite
    .master_pwdata(), //output [31:0] master_pwdata
    .master_pstrb(), //output [3:0] master_pstrb
    .master_pprot(), //output [2:0] master_pprot
// APB1
    .master_psel1(), //output master_psel1
    .master_prdata1(), //input [31:0] master_prdata1
    .master_pready1(), //input master_pready1
    .master_pslverr1(), //input master_pslverr1
// APB2
    .master_psel2(), //output master_psel2
    .master_prdata2(), //input [31:0] master_prdata2
    .master_pready2(), //input master_pready2
    .master_pslverr2(), //input master_pslverr2
*/

//----AHB2 Master----//
    .master_hclk(master_hclk), //output master_hclk
    .master_hrst(master_hrst), //output master_hrst
    .master_hsel(master_hsel), //output master_hsel
    .master_haddr(master_haddr), //output [31:0] master_haddr
    .master_htrans(master_htrans), //output [1:0] master_htrans
    .master_hwrite(master_hwrite), //output master_hwrite
    .master_hsize(master_hsize), //output [2:0] master_hsize
    .master_hburst(master_hburst), //output [2:0] master_hburst
    .master_hprot(master_hprot), //output [3:0] master_hprot
    .master_memattr(master_memattr), //output [1:0] master_memattr
    .master_exreq(master_exreq), //output master_exreq
    .master_hmaster(master_hmaster), //output [3:0] master_hmaster
    .master_hwdata(master_hwdata), //output [31:0] master_hwdata
    .master_hmastlock(master_hmastlock), //output master_hmastlock
    .master_hreadymux(master_hreadymux), //output master_hreadymux
    .master_hauser(master_hauser), //output master_hauser
    .master_hwuser(master_hwuser), //output [3:0] master_hwuser
    .master_hrdata(master_hrdata), //input [31:0] master_hrdata
    .master_hreadyout(master_hreadyout), //input master_hreadyout
    .master_hresp(master_hresp), //input master_hresp
    .master_exresp(1'b0), //input master_exresp
    .master_hruser(3'b000) //input [2:0] master_hruser
 
);
/*
// fpga-led
reg         led_value;
reg [25:0]  led_cnt;
always @(posedge clk_144M or negedge reset_n)
begin
	if(~reset_n)begin
            led_value <= 1'b1;
            led_cnt <= 26'd0;
        end
	else if(led_cnt < 26'd2700_0000)begin   
            led_cnt <= led_cnt + 1'd1;
        end
    else if(led_cnt >= 26'd2700_0000)begin
            led_cnt <= 26'd0;
            led_value <= ~led_value;
        end
end

assign led = led_value;
*/

endmodule
