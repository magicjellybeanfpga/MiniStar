module key_control
(
input wire sys_clk , //系统时钟,24MHz
input wire sys_rst_n , //复位信号,低电平有效
input wire ch_sw , //通道选择，接CH1，，低电平选择CH1，高电平选择CH2
input wire wave,//波形切换，低电平有效
input wire fre_h,//频率高8位，低电平有效
input wire fre_l,//频率低8位，低电平有效
input wire pha,//相位输入，低电平有效
input wire [7:0]data_in,//数字输入，8b

output reg [3:0] ch1_wave_select, //CH1输出波形选择
output reg [31:0] ch1_FREQ_CTRL,//CH1频率控制
output reg [9:0] ch1_PHASE_CTRL,//CH1相位控制
output reg [3:0] ch2_wave_select, //CH2输出波形选择
output reg [31:0] ch2_FREQ_CTRL,//CH2频率控制
output reg [9:0] ch2_PHASE_CTRL,//CH2相位控制 
output reg fre_add_r//相位复位
);

////
//\* Parameter and Internal Signal \//
////
//parameter define
parameter 
sin_wave = 4'b0001, //正弦波
squ_wave = 4'b0010, //方波
tri_wave = 4'b0100, //三角波
saw_wave = 4'b1000, //锯齿波
idel_wave= 4'b0000;//波形关闭
/***************************************
----------------打两拍-------------------
--------------------------------------*/
reg //打两拍寄存器
ch_sw_i,ch_sw_o,//通道选择
wave_i,wave_o_f,//波形切换
fre_h_i,fre_h_o,//频率高8位
fre_l_i,fre_l_o,//频率低8位
pha_i,pha_o;//相位输入
reg [7:0]data_i;
reg [7:0]data_o;//数字输入
always@(posedge sys_clk)//输入打两拍
begin
    if(!sys_rst_n)
    begin
    ch_sw_i<=1'b1;ch_sw_o<=1'b1;
    wave_i<=1'b1;wave_o_f<=1'b1;
    fre_h_i<=1'b1;fre_h_o<=1'b1;
    fre_l_i<=1'b1;fre_l_o<=1'b1;
    pha_i<=1'b1;pha_o<=1'b1;
    data_i<=8'b0;data_o<=8'b0;
    end
    else
    begin
    ch_sw_i<=ch_sw;ch_sw_o<=ch_sw_i;
    wave_i<=wave;wave_o_f<=wave_i;
    fre_h_i<=fre_h;fre_h_o<=fre_h_i;
    fre_l_i<=fre_l;fre_l_o<=fre_l_i;
    pha_i<=pha;pha_o<=pha_i;
    data_i<=data_in;data_o<=data_i;
    end
end
/*--------------------------------------
----------------打两拍-------------------
***************************************/

/***************************************
---------------波形切换------------------
1.按一下切换一下
2.顺序：idel>sin>squ>tri>saw>idel
--------------------------------------*/
reg wave_o1;//上升沿检测
always@(posedge sys_clk)//波形切换
begin
    if(!sys_rst_n)
        begin
        ch1_wave_select<=idel_wave;
        ch1_wave_select<=idel_wave;
        wave_o1<=1'b1;
        end
    else
        begin
        wave_o1<=wave_o;
        if((~wave_o1)&&wave_o)
            begin
            if(ch_sw_o)
                begin
                case(ch2_wave_select)
                idel_wave:ch2_wave_select<=sin_wave;
                sin_wave :ch2_wave_select<=squ_wave;
                squ_wave :ch2_wave_select<=tri_wave;
                tri_wave :ch2_wave_select<=saw_wave;
                saw_wave :ch2_wave_select<=idel_wave;
                default  :ch2_wave_select<=idel_wave;
                endcase
                end
            else
                begin
                case(ch1_wave_select)
                idel_wave:ch1_wave_select<=sin_wave;
                sin_wave :ch1_wave_select<=squ_wave;
                squ_wave :ch1_wave_select<=tri_wave;
                tri_wave :ch1_wave_select<=saw_wave;
                saw_wave :ch1_wave_select<=idel_wave;
                default  :ch1_wave_select<=idel_wave;
                endcase
                end
            end
        else
            begin
            ch1_wave_select<=ch1_wave_select;
            ch2_wave_select<=ch2_wave_select;
            end
        end
end
/*--------------------------------------
---------------波形切换------------------
***************************************/

/***************************************
---------------频率控制------------------
output reg [31:0] ch1_FREQ_CTRL,//CH1频率控制
output reg [31:0] ch2_FREQ_CTRL,//CH2频率控制
FREQ_CTRL = 2^N * Fout / Fclk
Fout = Fclk * FREQ_CTRL /2^N
N = 32，fclk = 24MHz

ch_sw_i,ch_sw_o,//通道选择，接CH1，，低电平选择CH1，高电平选择CH2
wave_i,wave_o,//波形切换
fre_h_i,fre_h_o,//频率高8位
fre_l_i,fre_l_o,//频率低8位
pha_i,pha_o,//相位输入
[7:0]data_i,[7:0]data_o;//数字输入
--------------------------------------*/
reg [7:0]ch1_fre_h;//CH1输出频率高8位
reg [7:0]ch1_fre_l;//CH1输出频率低8位
reg [7:0]ch2_fre_h;//CH2输出频率高8位
reg [7:0]ch2_fre_l;//CH2输出频率低8位
always@(posedge sys_clk)
begin
if(!sys_rst_n)//复位输出1K
    begin
    ch1_fre_h<=8'h3;
    ch1_fre_l<=8'hE8;
    ch2_fre_h<=8'h3;
    ch2_fre_l<=8'hE8;
    end
else
    begin
    if(ch_sw_o)
        begin//CH2
        if(!fre_h_o)
            ch2_fre_h<=data_o;
        else if(!fre_l_o)
            ch2_fre_l<=data_o;
        else
            begin
            ch2_fre_h<=ch2_fre_h;
            ch2_fre_l<=ch2_fre_l;
            end
        end
    else
        begin//CH1
        if(!fre_h_o)
            ch1_fre_h<=data_o;
        else if(!fre_l_o)
            ch1_fre_l<=data_o;
        else
            begin
            ch1_fre_h<=ch1_fre_h;
            ch1_fre_l<=ch1_fre_l;
            end
        end
    end
end
always@(posedge sys_clk)
begin
if(!sys_rst_n)//复位输出1K
    begin
    ch1_FREQ_CTRL<=32'd178957;
    ch2_FREQ_CTRL<=32'd178957;
    end
else
    begin
    ch1_FREQ_CTRL<=(ch1_fre_h<<8)*179+ch1_fre_l*179;//{ch1_fre_h:ch1_fre_l}*179;
    ch2_FREQ_CTRL<=(ch2_fre_h<<8)*179+ch2_fre_l*179;//{ch2_fre_h:ch2_fre_l}*179;
    end
end
/*--------------------------------------
---------------频率控制------------------
***************************************/

/***************************************
---------------相位控制------------------
output reg [9:0] ch1_PHASE_CTRL,//CH1相位控制
output reg [9:0] ch2_PHASE_CTRL,//CH2相位控制 
PHASE_CTRL = θ / (2π / 2^M)，M=10
pha_i,pha_o,//相位输入
[7:0]data_i,[7:0]data_o;//数字输入
ch_sw_i,ch_sw_o,//通道选择，接CH1，低电平选择CH1，高电平选择CH2
--------------------------------------*/
always@(posedge sys_clk)
begin
if(!sys_rst_n)//复位输出1K
    begin
    ch1_PHASE_CTRL<=10'd0;
    ch2_PHASE_CTRL<=10'd0;
    end
else
    begin
if(ch_sw_o)
    begin//CH2
    if(!pha_o)
        ch2_PHASE_CTRL<=(data_o<<2);
    else
        ch2_PHASE_CTRL<=ch2_PHASE_CTRL;
    end
else
    begin//CH1
    if(!pha_o)
        ch1_PHASE_CTRL<=(data_o<<2);
    else
        ch1_PHASE_CTRL<=ch1_PHASE_CTRL;
    end
    end
end
/*--------------------------------------
---------------相位控制------------------
fre_add_r;//相位复位
***************************************/
always@(posedge sys_clk)
begin
if(!sys_rst_n)//复位输出1K
    fre_add_r<=1'b1;
else
    begin
    if(ch1_FREQ_CTRL==ch2_FREQ_CTRL && ~pha_o)
        fre_add_r<=1'b0;
    else
        fre_add_r<=1'b1;
    end
end
//------------- key_fifter_inst2 --------------
key_filter tb(
.clk(sys_clk),
.rst_n(sys_rst_n),
.key_in(wave_o_f),
.key_out(wave_o)
);
endmodule