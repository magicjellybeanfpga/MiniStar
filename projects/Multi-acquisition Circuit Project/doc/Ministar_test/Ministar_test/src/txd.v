/*********************************************************************************************************
 **                                  All right reserve 2008-2009(C) 
 **                             Created & maintain by http://www.edaok.net
 **=======================================================================================================
 ** 模 块 名:   uart.v
 ** 描    述:   实现UART的发送功能, 数据帧字节长度可设置, 支持奇偶检验功能; 实现了AVR单片机的通用异步串口
 **             的大部分功能, (没有多机通信, 同步发送方式)
 **
 ** 原 作 者:  
 ** 参 与 者:  
 **
 **=======================================================================================================
 ********************************************************************************************************/

module txd (
    clk,
    rst_n,    
    clk_en,
    data_i,
    txd_xo,
	 ctrl_i,
	 TxReady,
	 TxDone  
);

input               clk;                                        //  全局时钟时
input               rst_n;                                      //  全局复位时, 低有效

input               clk_en;
input   [7:0]       data_i;                                     //  将要发送到UART总线上的数据

output              txd_xo;                                     //  UART数据发送端口

input   [3:0]       ctrl_i;                                     //  控制信号输入




output              TxReady;                                    //  可以准备发送
output              TxDone;                                     //  发送结束
                                                                                                        

/*********************************************************************************************************
 ** UART发送器状态机状态定义
 ********************************************************************************************************/

parameter   [7 : 0]
    TX_IDLE         = 8'b0000_0001,                //  总线空闲状态, 等待发送数据
    TX_READY        = 8'b0000_0010,                //  准备发送状态, 把数据放入发送缓冲区
    TX_START        = 8'b0000_0100,                //  发送起始化状态, 把总线拉低(清0)
    TX_DATA         = 8'b0000_1000,                //  发送数据位状态, 往总线逐位输出数据, LSB
    TX_PARITY       = 8'b0001_0000,                //  发送校验位状态, 根据帧格式配置输出
    TX_STOP1        = 8'b0010_0000,                //  发送停止位状态, 往总线写"1"
    TX_STOP2        = 8'b0100_0000,
    TX_DONE         = 8'b1000_0000;                //  发送完志状态

parameter[3:0] DatWid=4'd9;

reg [7 : 0]    rStatTxCur,                     //  UART发送器当前的状态, 默认为空闲状态
                                rStatTxNext;                    //  UART发送器下一个状态

reg     [7:0]       rTxDatSft;
reg     [3:0]       rTxClkCnt;
reg     [3:0]       rTxBitCnt;
reg                 rPlsBaudTick;
reg                 rPlsStatChanged;



initial                                                         //  为仿真测试初始化
begin
    rStatTxCur      <= TX_IDLE;
    rStatTxNext     <= TX_IDLE;
    rTxDatSft       <= 8'h00;
    rTxClkCnt       <= 4'h0;
    rTxBitCnt       <= 4'h0;
    rPlsBaudTick    <= 1'b0;
    rPlsStatChanged <= 1'b0;
end


wire                wFlgParEn   = ctrl_i[3];                    //  1=使能奇偶校验位, 0=禁能
wire                wFlgParMod  = ctrl_i[2];                    //  1=奇校验, 0=偶校验
wire                wStopBits   = ctrl_i[1];                    //  1=2位停止位, 0=1位停止位


wire                wFlgTxStart = ctrl_i[0];                    //  启动发送信号

//wire    [3:0]       wDatWid     = frame_bits_i;                 //  帧的数据位长度, 实际位数为输入值-'1', 即"8"为'7'
/*
reg                 rFlgDone;                                   //  发送器完成发送标记
reg                 rFlgNewDat;                                 //  发送器的发送缓冲器数据已载入, 可以申请新的数据
reg                 rParVal;                                    //  奇偶校验的运算结果, 为偶校验结果, 奇校验则取反
*/
reg                 rTxReady;                                 
reg                 rTxDone;                                 



/*********************************************************************************************************
 ** 更新当前的状态机, 并处理相关的关键数据
 ********************************************************************************************************/
always @(posedge clk or negedge rst_n)
begin : TX_STAT_UPDATE
    if (~rst_n) begin
        rStatTxCur      <= TX_IDLE;
        rPlsStatChanged <= 1'b0;
    end
    else begin
        rStatTxCur      <= rStatTxNext;                         //  更新当前发送器的状态机状态
        rPlsStatChanged <= (rStatTxCur != rStatTxNext);
    end
end


/*********************************************************************************************************
 ** 根据多个信号和当前状态机的状态, 判断发送器状态机的下一个状态
 **
 ** [特别注意]: 
 ** 状态值使用OneHot编码, 而这种编码一般会优为移位寄存器, 为了防止状态出现00000的情况(如时钟质量差), 
 ** 在综合器中要设置'safe stat mechine = on'(安全状态机)
 ********************************************************************************************************/
 
always @(
    rPlsBaudTick or
    wFlgTxStart or
    rStatTxCur or
    rTxClkCnt or 
    rTxBitCnt or
    wFlgParEn or 
    wFlgParMod or
    clk_en or
    wStopBits
    )
begin : TX_NEXT_STAT_JUDGE

    case (rStatTxCur)                                           //  根据当前状态机的状态, 判断输入信号, 得
                                                                //  到发送器状态机的下一个状态 
    TX_IDLE: begin                                              
        if (wFlgTxStart)                              //  当模块端口的发送数据标志有效, 则启动发送事件
            rStatTxNext <= TX_READY;
        else 
            rStatTxNext <= TX_IDLE;
    end
    
    TX_READY: begin
        if (clk_en) begin                                       //  同步UART时钟
            rStatTxNext <= TX_START;                            //  进入发送器状态机的发送起始位状态
        end 
        else begin
            rStatTxNext <= TX_READY;
        end
    end

    TX_START: begin
        if (rPlsBaudTick)                                       //  持续一个波特位, 进入帧的数据位状态
            rStatTxNext <= TX_DATA;
        else
            rStatTxNext <= TX_START;
    end
    
    TX_DATA:
    begin
        if ( (rTxBitCnt == DatWid) && (rPlsBaudTick) ) begin   //  当逐位发送完帧格式设置的位数后, 进入下一状态******@@@@
            if (wFlgParEn)
                rStatTxNext <= TX_PARITY;                       //  如果使能校验位, 则进入校验状态
            else
                rStatTxNext <= TX_STOP1;                        //  否则进入停止位状态
        end
        else begin
            rStatTxNext <= TX_DATA;
        end
    end

    TX_PARITY: begin
        if (rPlsBaudTick)
            rStatTxNext <= TX_STOP1;                            //  持续一个波特位后, 进入停止位状态
        else
            rStatTxNext <= TX_PARITY;
    end

    TX_STOP1: begin
        if (rPlsBaudTick) begin
            if (wStopBits)                                      //  如果设置了2个停止位, 则再进入停止位
                rStatTxNext <= TX_STOP2;
            else
                rStatTxNext <= TX_DONE;
        end
        else begin
            rStatTxNext <= TX_STOP1;
        end
    end

    TX_STOP2: begin
        if (rPlsBaudTick)
            rStatTxNext <= TX_DONE;
        else
            rStatTxNext <= TX_STOP2;
    end

    TX_DONE: begin
        rStatTxNext <= TX_IDLE;                                 //  再次进入空闲状态
    end
    
    default: begin
        rStatTxNext <= TX_IDLE;
    end 

    endcase
end


reg             rTxdTmp;

reg             rParVal;



always @(posedge clk or negedge rst_n)
begin : TX_STAT_PROCESS

    if (~rst_n) begin

        rTxDatSft   <= 8'h00;
        rTxdTmp     <= 1'b1;


		  rTxReady    <= 1'b1;
		  rTxDone     <= 1'b0;

        rParVal     <= 1'b0;
        

        rTxClkCnt       <= 4'h0;
        rTxBitCnt       <= 4'h0;
        rPlsBaudTick    <= 1'b0;
        
    end 
    else begin

        rPlsBaudTick    <= 1'b0;

        if ( (rStatTxCur == TX_IDLE) || 
             (rStatTxCur == TX_READY) ) begin                   //  下一状态为空闲时, 复位计数器
            rTxClkCnt   <= 4'h0;
            rTxBitCnt   <= 4'h0;
				
        end
        else if (clk_en) begin 
            rTxClkCnt   <= rTxClkCnt + 4'h1;
            
            if (rTxClkCnt == 4'hF) begin                        //  UART波特率为clk_en / 16
                rTxBitCnt   <= rTxBitCnt + 4'h1;                //  发送器帧位的计数
                rPlsBaudTick   <= 1'b1;                         //  产生波特率时钟脉冲
            end
        end

        case (rStatTxCur)

        TX_IDLE: begin
            rTxdTmp <= 1'b1;
            rParVal <= 1'b0;
            
				rTxReady    <= 1'b1;
				rTxDone     <= 1'b0;
        end

        TX_READY: begin
            rTxdTmp <= 1'b1;

            if (rPlsStatChanged) begin
                rTxDatSft   <= data_i;
					 rTxReady    <= 1'b0;
                //rFlgNewDat  <= 1'b1;
            end
        end

        TX_START: begin
            rTxdTmp <= 1'b0;
        end
        
        TX_DATA: begin
            if ( (rPlsBaudTick || rPlsStatChanged) && 
                (rTxBitCnt != DatWid) ) begin

                rParVal <= rParVal ^ rTxDatSft[0];
                
                rTxdTmp <= rTxDatSft[0];
                
                rTxDatSft   <= rTxDatSft >> 1;
            end
        end

        TX_PARITY: begin
            if (~wFlgParMod)                                    //  偶校验
                rTxdTmp <= rParVal;
            else
                rTxdTmp <= ~rParVal;                            //  奇校验为偶校验的反码
        end

        TX_DONE: begin
				rTxDone     <= 1'b1;
            
        end

        default: begin
            rTxdTmp <= 1'b1;
        end

        endcase  
    end
end

assign  txd_xo  = rTxdTmp;                                      //  输出UART的发送数据 (TxD)

assign  TxDone  = rTxDone;

assign  TxReady=rTxReady;


endmodule

/*********************************************************************************************************
 ** End Of File
 ********************************************************************************************************/

