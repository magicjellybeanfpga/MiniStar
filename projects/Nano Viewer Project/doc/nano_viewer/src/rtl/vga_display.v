//*****************************************************************************
//COPYRIGHT(c) 2020,Wuhan University Of Techonology
//All rights reserved
//
//Module name  :vga_display
//File name    :vga_display.v
//
//Author       :TANG
//Email        :Tangziming@whut.edu.cn
//Data         :20210420
//Version      :1.0
//
//Abstract     :
/******************************************************************************
show different pictures in different state
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
module vga_display(
    input              vga_clk,                 //VGA驱动时钟
    input              sys_rst_n,               //复位信号
    input      [  2:0] state,                   //状态
    input      [ 31:0] picture_data,            //照片数据
    input      [ 10:0] pixel_xpos,              //像素点横坐标
    input      [ 10:0] pixel_ypos,              //像素点纵坐标  
    input      [ 31:0] dht11_data,              //温湿度数据 
    output reg [ 15:0] pixel_data,              //像素点数据
    output reg [ 21:0] picture_addr             //照片地址
    );    
    
parameter  H_DISP = 11'd1024;                    //分辨率——行
parameter  V_DISP = 11'd768;                    //分辨率——列

localparam WHITE  = 16'b11111_111111_11111;     //RGB565 白色
localparam BLACK  = 16'b00000_000000_00000;     //RGB565 黑色
localparam RED    = 16'b11111_000000_00000;     //RGB565 红色
localparam GREEN  = 16'b00000_111111_00000;     //RGB565 绿色
localparam BLUE   = 16'b00000_000000_11111;     //RGB565 蓝色

localparam IMG_WIDTH    =   11'd100;
localparam IMG_HIGHT    =   11'd100;


localparam READY = 3'd0;
localparam WAIT1 = 3'd1;
localparam WAIT2 = 3'd2;
localparam PRECV = 3'd3;
localparam GAWE1 = 3'd4;
localparam GAWE2 = 3'd5;
localparam GAMED = 3'd6;
localparam SHOWP = 3'd7;
//*****************************************************
//**                    main code
//*****************************************************
reg     [14:0]  rom_addr;
wire            rom_data;
wire    [14:0]  addr_offest;

reg     [15:0]  font_addr;
wire            font_data;

reg     [11:0]  doge_addr;
wire    [15:0]  doge_data;

reg     [9:0]   snake_addr;
wire    [15:0]  snake_data;
wire [3:0]	tem_x;			//温度十位
wire [3:0]	tem_b;			//温度个位
wire [3:0]	tem_c;			//温度小数点位

wire [3:0]	hum_x;			//湿度十位
wire [3:0]	hum_b;			//湿度个位
wire [3:0]	hum_c;			//湿度小数点位

snake_rom u_snake_rom(
    .dout(snake_data), //output [15:0] dout
    .clk(vga_clk), //input clk
    .oce(1'b1), //input oce
    .ce(1'b1), //input ce
    .reset(~sys_rst_n), //input reset
    .ad(snake_addr) //input [9:0] ad
);

doge_rom u_doge_rom
(
    .dout(doge_data), //output [15:0] dout
    .clk(vga_clk), //input clk
    .oce(1'b1), //input oce
    .ce(1'b1), //input ce
    .reset(~sys_rst_n), //input reset
    .ad(doge_addr) //input [11:0] ad
);

font_rom u_font_rom
(
    .dout(font_data), //output [0:0] dout
    .clk(vga_clk), //input clk
    .oce(1'b1), //input oce
    .ce(1'b1), //input ce
    .reset(~sys_rst_n), //input reset
    .ad(font_addr) //input [15:0] ad
);

img_rom u_img_rom
(
    .ad         (rom_addr),
    .clk        (vga_clk),
    .ce         (1'b1),
    .oce        (1'b1),
    .reset      (~sys_rst_n),
    .dout       (rom_data)
);

//求各数据的各位值
assign		tem_x	=	dht11_data[15:8]/4'd10	%4'd10; //温度十位
assign		tem_b	=	dht11_data[15:8]		%4'd10; //温度个位
assign		tem_c	=	dht11_data[7:0]/4'd10	%4'd10; //温度小数位

assign		hum_x	=	dht11_data[31:24]/4'd10	%4'd10; //湿度十位
assign		hum_b	=	dht11_data[31:24]		%4'd10; //湿度个位
assign		hum_c	=	dht11_data[23:16]/4'd10	%4'd10; //湿度小数位
//根据不同状态配置不同偏移地址
assign  addr_offest = (state==PRECV)? 15'd10_000:(state==GAMED)? 15'd20_000:15'd0;
//根据当前像素点坐标指定当前像素点颜色数据，在屏幕上显示图像
always @(posedge vga_clk or negedge sys_rst_n) begin
   if (!sys_rst_n)begin
       pixel_data <= 16'd0;
   end   
   else if(state == GAMED)begin//游戏模式
       if(pixel_ypos<16 | pixel_ypos>=752 | pixel_xpos<16 | pixel_xpos>=1008)begin
           snake_addr   <=  pixel_xpos[3:0] + {pixel_ypos[3:0],4'b0_000};
           pixel_data   <=  snake_data;
       end
       else if((pixel_xpos>511)&&(pixel_xpos<=527)&&(pixel_ypos>=368)&&(pixel_ypos<=383))begin
           snake_addr   <=  pixel_xpos[3:0] + {pixel_ypos[3:0],4'b0_000} + 512;
           pixel_data   <=  snake_data;
       end
       else if((pixel_xpos>527)&&(pixel_xpos<=623)&&(pixel_ypos>=368)&&(pixel_ypos<=383))begin
           snake_addr   <=  pixel_xpos[3:0] + {pixel_ypos[3:0],4'b0_000} + 768;
           pixel_data   <=  snake_data;
       end
       else begin
           snake_addr   <=  pixel_xpos[3:0] + {pixel_ypos[3:0],4'b0_000} + 256;
           pixel_data   <=  snake_data;
       end
   end
   //显示状态图像与温湿度
   else begin
       if((pixel_xpos>=50)&&(pixel_xpos<162)&&(pixel_ypos>=30)&&(pixel_ypos<78))begin//TEMP:
           font_addr  <= (pixel_xpos-50)+((pixel_ypos-30)*112)+1;
           pixel_data <= (font_data==1'b0)? BLACK:WHITE;
       end
       else if((pixel_xpos>=162)&&(pixel_xpos<210)&&(pixel_ypos>=30)&&(pixel_ypos<78))begin//温度十位
           font_addr  <= (pixel_xpos-162)+((pixel_ypos-30)*48)+(tem_x*2304)+16513;
           pixel_data <= (font_data==1'b0)? BLACK:WHITE;
       end
       else if((pixel_xpos>=210)&&(pixel_xpos<258)&&(pixel_ypos>=30)&&(pixel_ypos<78))begin//温度个位
           font_addr  <= (pixel_xpos-210)+((pixel_ypos-30)*48)+(tem_b*2304)+16513;
           pixel_data <= (font_data==1'b0)? BLACK:WHITE;
       end
       else if((pixel_xpos>=258)&&(pixel_xpos<282)&&(pixel_ypos>=30)&&(pixel_ypos<78))begin//.
           font_addr  <= (pixel_xpos-258)+((pixel_ypos-30)*24)+15361;
           pixel_data <= (font_data==1'b0)? BLACK:WHITE;
       end
       else if((pixel_xpos>=282)&&(pixel_xpos<330)&&(pixel_ypos>=30)&&(pixel_ypos<78))begin//温度小数位
           font_addr  <= (pixel_xpos-282)+((pixel_ypos-30)*48)+(tem_c*2304)+16513;
           pixel_data <= (font_data==1'b0)? BLACK:WHITE;
       end
       else if((pixel_xpos>=330)&&(pixel_xpos<378)&&(pixel_ypos>=30)&&(pixel_ypos<78))begin//℃
           font_addr  <= (pixel_xpos-330)+((pixel_ypos-30)*48)+10753;
           pixel_data <= (font_data==1'b0)? BLACK:WHITE;
       end
       else if((pixel_xpos>=632)&&(pixel_xpos<744)&&(pixel_ypos>=30)&&(pixel_ypos<78))begin//HUM:
           font_addr  <= (pixel_xpos-632)+((pixel_ypos-30)*112)+5377;
           pixel_data <= (font_data==1'b0)? BLACK:WHITE;
       end
       else if((pixel_xpos>=744)&&(pixel_xpos<792)&&(pixel_ypos>=30)&&(pixel_ypos<78))begin//湿度十位
           font_addr  <= (pixel_xpos-744)+((pixel_ypos-30)*48)+(hum_x*2304)+16513;
           pixel_data <= (font_data==1'b0)? BLACK:WHITE;
       end
       else if((pixel_xpos>=792)&&(pixel_xpos<840)&&(pixel_ypos>=30)&&(pixel_ypos<78))begin//湿度个位
           font_addr  <= (pixel_xpos-792)+((pixel_ypos-30)*48)+(hum_b*2304)+16513;
           pixel_data <= (font_data==1'b0)? BLACK:WHITE;
       end
       else if((pixel_xpos>=840)&&(pixel_xpos<864)&&(pixel_ypos>=30)&&(pixel_ypos<78))begin//.
           font_addr  <= (pixel_xpos-840)+((pixel_ypos-30)*24)+15361;
           pixel_data <= (font_data==1'b0)? BLACK:WHITE;
       end
       else if((pixel_xpos>=864)&&(pixel_xpos<912)&&(pixel_ypos>=30)&&(pixel_ypos<78))begin//湿度小数位
           font_addr  <= (pixel_xpos-864)+((pixel_ypos-30)*48)+(hum_c*2304)+16513;
           pixel_data <= (font_data==1'b0)? BLACK:WHITE;
       end
       else if((pixel_xpos>=912)&&(pixel_xpos<960)&&(pixel_ypos>=30)&&(pixel_ypos<78))begin//%
           font_addr  <= (pixel_xpos-960)+((pixel_ypos-30)*48)+13057;
           pixel_data <= (font_data==1'b0)? BLACK:WHITE;
       end
       else begin
            //显示照片
            if(state == SHOWP)begin
                if(pixel_ypos  >= 255)begin
                    //if(pixel_xpos  == 0)begin
                    //     picture_addr <=  picture_addr+22'd8;//(pixel_ypos * IMG_WIDTH) + pixel_xpos + 1;
                    //     pixel_data   <=  picture_data;
                    //end
                    picture_addr <=  22'd1;
                    doge_addr    <=  pixel_xpos[5:0] + {pixel_ypos[5:0],6'b000_000};
                    pixel_data   <=  doge_data;
                end
                else begin
                    pixel_data   <=  WHITE;
                end
            end
            //显示状态图像
            else if((pixel_xpos >= (H_DISP-IMG_WIDTH)/2) && (pixel_xpos < (H_DISP-IMG_WIDTH)/2 + IMG_WIDTH) && (pixel_ypos >= (V_DISP-IMG_HIGHT)/2) && (pixel_ypos < (V_DISP-IMG_HIGHT)/2+IMG_HIGHT) )begin
                rom_addr   <= (pixel_xpos-((H_DISP-IMG_WIDTH)/2)) + (pixel_ypos-((V_DISP-IMG_HIGHT)/2))*IMG_WIDTH  + addr_offest+1;
                pixel_data <= (rom_data==1'b0)? BLACK:WHITE;
            end
            else begin
                pixel_data <= WHITE;
            end
       end
   end
end


endmodule
