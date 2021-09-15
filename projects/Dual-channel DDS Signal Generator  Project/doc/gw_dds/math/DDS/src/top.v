module top_dds
(
input wire sys_clk , //系统时钟,24MHz
input wire sys_rst_n , //复位信号，低电平有效，同步
input wire ch_sw , //通道选择，接CH1，，低电平选择CH1，高电平选择CH2
input wire wave,//波形切换，低电平有效
input wire fre_h,//频率高8位，低电平有效
input wire fre_l,//频率低8位，低电平有效
input wire pha,//相位输入，低电平有效
input wire [7:0]data_in,//数字输入，8b
output wire [7:0] dac_CH1, //输入DAC模块波形数据
//output [3:0]ch1_wave_select,
output wire [7:0] dac_CH2 //输入DAC模块波形数据
);

////
//\* Parameter and Internal Signal \//
////
//wire define
wire [3:0] ch1_wave_select ; //波形选择
wire [31:0] ch1_FREQ_CTRL;//频率控制
wire [9:0] ch1_PHASE_CTRL;//相位控制

wire [3:0] ch2_wave_select ; //波形选择
wire [31:0] ch2_FREQ_CTRL;//频率控制
wire [9:0] ch2_PHASE_CTRL;//相位控制
wire fre_add_r;//相位复位
////
//\* Instantiation \//
////
//-------------------------- dds_inst -----------------------------
dds dds_CH1
(
.sys_clk (sys_clk ), //系统时钟,24MHz
.sys_rst_n (sys_rst_n ), //复位信号,低电平有效
.wave_select (ch1_wave_select), //输出波形选择
.FREQ_CTRL(ch1_FREQ_CTRL),//频率控制
.PHASE_CTRL(ch1_PHASE_CTRL),//相位控制
.fre_add_r(fre_add_r),
.data_out (dac_CH1) //波形输出
);

dds dds_CH2
(
.sys_clk (sys_clk ), //系统时钟,24MHz
.sys_rst_n (sys_rst_n ), //复位信号,低电平有效
.wave_select (ch2_wave_select), //输出波形选择
.FREQ_CTRL(ch2_FREQ_CTRL),//频率控制
.PHASE_CTRL(ch2_PHASE_CTRL),//相位控制
.fre_add_r(fre_add_r),
.data_out (dac_CH2) //波形输出
);

//----------------------- key_control_inst ------------------------
key_control key_control_inst
(
.sys_clk (sys_clk ), //系统时钟,50MHz
.sys_rst_n (sys_rst_n ), //复位信号,低电平有效
.ch_sw (ch_sw), //输入4位按键
.wave (wave),
.fre_h (fre_h),
.fre_l (fre_l),
.pha (pha),
.data_in (data_in),
.ch1_wave_select (ch1_wave_select), //CH1输出波形选择
.ch1_FREQ_CTRL (ch1_FREQ_CTRL),//CH1频率控制
.ch1_PHASE_CTRL (ch1_PHASE_CTRL),//CH1相位控制
.ch2_wave_select (ch2_wave_select), //CH2输出波形选择
.ch2_FREQ_CTRL (ch2_FREQ_CTRL),//CH2频率控制
.ch2_PHASE_CTRL (ch2_PHASE_CTRL),//CH2相位控制
.fre_add_r(fre_add_r)
);

endmodule