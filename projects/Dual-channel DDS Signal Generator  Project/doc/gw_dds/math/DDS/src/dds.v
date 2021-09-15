module dds
(
input wire sys_clk , //系统时钟,24MHz
input wire sys_rst_n , //复位信号,低电平有效
input wire [3:0] wave_select , //输出波形选择
input wire [31:0] FREQ_CTRL,//频率控制
input wire [9:0] PHASE_CTRL,//相位控制
input wire fre_add_r,//相位复位
output wire [7:0] data_out //波形输出
);

reg [31:0] fre_add ; //计数累加器
reg [9:0] rom_addr_reg; //波形地址偏移,1024,10bit
reg [11:0] rom_addr ; //ROM读地址,4096,12bit
////
//\* Parameter and Internal Signal \//
////
//parameter define
parameter 
sin_wave = 4'b0001 , //正弦波
squ_wave = 4'b0010 , //方波
tri_wave = 4'b0100 , //三角波
saw_wave = 4'b1000 , //锯齿波
idel_wave=4'b0000;//波形关闭
parameter idel_addr=12'b0;//波形关闭地址
parameter 
sin_baddr=0*12'd1024,//正弦波基地址
squ_baddr=1*12'd1024,//方波基地址
tri_baddr=2*12'd1024,//三角波基地址
saw_baddr=3*12'd1024;//锯齿波基地址
/*
parameter FREQ_CTRL_ = 32'd42949 , //相位累加器单次累加值K = 2N * fOUT / fCLK，N=32
PHASE_CTRL_ = 10'd512 ; //相位偏移量P = θ / (2π / 2M)，M=10（ROM地址宽度）
reg [31:0]FREQ_CTRL=FREQ_CTRL_;
reg [9:0]PHASE_CTRL=PHASE_CTRL_;
*/
/*
always@(posedge sys_clk )
begin
FREQ_CTRL<=FREQ_CTRL_;//频率控制
PHASE_CTRL<=PHASE_CTRL_;//相位控制
end
*/

/*---------------测试区域------------------*/
/*---------------测试区域------------------*/
/*---------------测试区域------------------*/


/*---------------测试区域------------------*/
/*---------------测试区域------------------*/
/*---------------测试区域------------------*/
////
//\* Main Code \//
////
//fre_add:相位累加器
always@(posedge sys_clk) begin
if(sys_rst_n==1'b0 || fre_add_r==1'b0)
fre_add <= 32'd0;
else
fre_add <= fre_add + FREQ_CTRL;
end
//rom_addr:ROM读地址
always@(posedge sys_clk) begin
if(sys_rst_n == 1'b0)
begin
rom_addr <= 12'd1770;
rom_addr_reg <= 10'd0;
end
else
case(wave_select)
idel_wave://初始状态
begin
rom_addr <= idel_addr;
end //波形关闭
sin_wave://正弦波
begin
rom_addr_reg <= fre_add[31:22] + PHASE_CTRL;
rom_addr <= rom_addr_reg + sin_baddr;
end //正弦波
squ_wave://方波
begin
rom_addr_reg <= fre_add[31:22] + PHASE_CTRL;
rom_addr <= rom_addr_reg + squ_baddr;
end //方波
tri_wave://三角波
begin
rom_addr_reg <= fre_add[31:22] + PHASE_CTRL;
rom_addr <= rom_addr_reg + tri_baddr;
end //三角波
saw_wave://锯齿波
begin
rom_addr_reg <= fre_add[31:22] + PHASE_CTRL;
rom_addr <= rom_addr_reg + saw_baddr;
end //锯齿波
default://默认
begin
rom_addr <= idel_addr;
end //波形关闭
endcase
end
////
//\* Instantiation \//
////


//------------------------- rom_wave_inst ------------------------//

wire [2:0]rom_init;
assign rom_init=3'b011;
Gowin_pROM DDS_ROM(
    .dout(data_out), //output [7:0] dout
    .clk(sys_clk), //input clk
    .oce(rom_init[0:0]), //input oce
    .ce(rom_init[1:1]), //input ce
    .reset(rom_init[2:2]), //input reset
    .ad(rom_addr) //input [11:0] ad
);

endmodule