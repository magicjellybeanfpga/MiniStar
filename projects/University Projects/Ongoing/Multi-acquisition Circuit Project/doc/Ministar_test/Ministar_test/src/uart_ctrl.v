/*********************************************************************************************************
 **                                  All right reserve 2008-2009(C) 
 **                             Created &maintain by 707 
 **=======================================================================================================
 ** 模 块 名:  uart_ctrl
 ** 描    述:   本模块实现
 **
 ** 作 者: 陈星  贾廷悦 
 ** 日期：2013/4/30
 ** 版本：
 **=======================================================================================================
 ********************************************************************************************************/
module uart_ctrl(
    input clk,      
    input rst,
    input FIFO_empty,
    input [7:0] data8_in,
    input tx_ready,
	 input tx_done,
    output [7:0] data8_out,
    output TxStart,
    output FIFO_rd
    );

/*********************************************************************************************************
 ** UART发送器状态机状态定义
 ********************************************************************************************************/
`define TX_STAT_WIDTH       9
parameter   [`TX_STAT_WIDTH - 1 : 0]
    TX_IDLE          = `TX_STAT_WIDTH'b00000_0001,                //  等待发送
    READ_FIFO1        = `TX_STAT_WIDTH'b00000_0010,                //  
    READ_FIFO2        = `TX_STAT_WIDTH'b00000_0100,                //      
	 
	 TX_HIGH8         = `TX_STAT_WIDTH'b00000_1000,                //  
	 TX_HIGH         = `TX_STAT_WIDTH'b00001_0000,                //   
    TX_LOW8          = `TX_STAT_WIDTH'b00010_0000,                //  
    TX_LOW          = `TX_STAT_WIDTH'b00100_0000,                //   

    TX_LOW82          = `TX_STAT_WIDTH'b01000_0000,                //  
    TX_HIGH82         = `TX_STAT_WIDTH'b10000_0000;               //  

reg [`TX_STAT_WIDTH - 1 : 0]    rStatTxCur,                     //  UART发送器当前的状态, 默认为空闲状态
                                rStatTxNext;                    //  UART发送器下一个状态


/*********************************************************************************************************
 ** 更新当前的状态机, 并处理相关的关键数据
 ********************************************************************************************************/
 reg [7:0] rData8_in;
reg rFIFO_rd;
reg [7:0]  rData8_out;
reg [3:0] rFIFO_cnt;
reg rTxStart;

always @(posedge clk or posedge rst)
begin : TX_STAT_UPDATE
    if (rst) begin
        rStatTxCur      <= TX_IDLE;
        
    end
    else begin
        rStatTxCur      <= rStatTxNext;                         
        
    end
end

always @(
    FIFO_empty or
    tx_ready or
	 tx_done or
	 rStatTxCur or
	 rFIFO_cnt
    )
begin : TX_NEXT_STAT_JUDGE

    case (rStatTxCur)                                           
                                                                
    TX_IDLE: begin                                              
        if ((~FIFO_empty) && tx_ready)                              
            rStatTxNext = READ_FIFO1;
        else 
            rStatTxNext = TX_IDLE;
    end
 
    READ_FIFO1: begin
	 
            rStatTxNext = READ_FIFO2;                            
    end
 
    READ_FIFO2: begin
        if (rFIFO_cnt==4'd8) begin                                         
            rStatTxNext = TX_LOW8;                            
        end 
        else begin
            rStatTxNext = READ_FIFO2;
        end
    end

/*    TX_HIGH8: beginLOW

            rStatTxNext = TX_HIGH82;
    end
	 TX_HIGH82: begin

            rStatTxNext = TX_HIGH;
    end 
    TX_HIGH: begin
        if (tx_done)   begin                                      
            if(FIFO_empty & frame_odd)
					rStatTxNext = TX_IDLE;
				else
					rStatTxNext = TX_LOW8;
			end
        else
            rStatTxNext = TX_HIGH;
    end*/	 
    
    TX_LOW8:
    begin
        rStatTxNext = TX_LOW82;       
    end
    
	 TX_LOW82:
    begin
        rStatTxNext = TX_LOW;       
    end	 
	 
    TX_LOW:
    begin
        if ( tx_done ) 
                rStatTxNext = TX_IDLE;                            
        else begin
            rStatTxNext = TX_LOW;
        end
    end    
    default: begin
        rStatTxNext = TX_IDLE;
    end 

    endcase
end




always @(posedge clk or posedge rst)
begin : TX_STAT_PROCESS

    if (rst) begin

        rData8_out  <= 8'h00;
        rData8_in  <= 8'b0;
        rFIFO_rd    <= 1'b0; 
        rTxStart    <= 1'b0;		  
    end 
    else begin

        case (rStatTxCur)
        TX_IDLE: begin                                              
				rFIFO_cnt<=4'b0;
        end

        READ_FIFO1: begin
            rFIFO_rd    <= 1'b1;
        end
		  
        READ_FIFO2: begin
            rFIFO_rd    <= 1'b0;
            rData8_in  <= data8_in;
				rFIFO_cnt<=rFIFO_cnt+1'b1;
        end

/*        TX_HIGH8: begin
            rData8_out<=rData16_in[15:8];
        end

        TX_HIGH82: begin

				rTxStart<=1'b1;
        end		  
		  TX_HIGH: begin
				rTxStart<=1'b0;
				
		  end*/
		  
        TX_LOW8: begin
		      rData8_out<=rData8_in;
  
        end

        TX_LOW82: begin

				rTxStart<=1'b1;
  
        end		  
        TX_LOW: begin
		      
				rTxStart<=1'b0;
  
        end

        default: begin
            rTxStart<=1'b0; 
        end

        endcase  
    end
end

assign data8_out=rData8_out;
assign TxStart= rTxStart;
assign FIFO_rd=rFIFO_rd;

endmodule
