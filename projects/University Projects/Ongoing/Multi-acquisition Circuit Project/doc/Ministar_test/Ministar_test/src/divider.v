/*********************************************************************************************************
 **=======================================================================================================
 ** 模 块 名:   division
 ** 描    述:   实现时钟的分频, 分频选择系数由用户输入
 **
 ** facter: 波特率选择
 **   0:2400
 **   1:4800    
 **	2:9600;
 **   3:19200 
 **   4:38400
 **   5:57600    
 **	6:115200;
 **   7:230400
 **	8:384000
 **   9:460800
 **
 ** 系数a：为前15次分频系数   
 ** 系数b：为第16次分频系数，通过第16次将前15次分频小数部分的误差频率补齐。 
 ** a＝fCLK/baudRate/16 取整。 b＝a＋16×小数部分(舍去为正，进位为负)。
 ** 作 者:   
 **    
 **
 **=======================================================================================================
 ********************************************************************************************************/


module divider (
    clk, 
    rst, 
    factor, 
    tick_out, 
    enable
);

input               clk;                                        //  全局时钟线, (系统时钟)
input               rst;                                        //  全局复位线

input               enable;                                    //  模块使能线
input   [15 : 0]    factor;                                    //  分频选择系数
output              tick_out;                                   //  分频输出



reg     [9 : 0]    rCnt;
reg                 rPlsTick;


/********************************************************************************************************
 ** 软件仿真时初始化寄存器值
 ********************************************************************************************************/
initial
begin
    rCnt <= 10'h0;
    rPlsTick <= 1'b0;
end

reg[9:0] a;
reg[9:0] b;

always@(posedge clk or posedge rst)
	if(rst) begin
		a<=10'd33;
		b<=10'd26;
	end
   else begin
		case(factor)
		0:begin       //2400
			a<=10'd651;
			b<=10'd652;
		end
		1:begin        //4800
			a<=10'd325;
			b<=10'd333;
		end
		2:begin         //9600
			a<=10'd175;  
			b<=10'd187;
		end
		3:begin        //19200
			a<=10'd81;
			b<=10'd87;
		end
		4:begin        //38400
			a<=10'd41;
			b<=10'd36;
		end
		5:begin         //57600
			a<=10'd27;
			b<=10'd29;
		end
		6:begin        //115200
			a<=10'd14;
			b<=10'd7;
		end
		7:begin        //230400
			a<=10'd7;
			b<=10'd3;
		end
		8:begin         //384000
			a<=10'd4;
			b<=10'd6;
		end
		9:begin         //460800
			a<=10'd3;
			b<=10'd9;
		end

		default:begin    //57600
			a<=10'd27;
			b<=10'd29;
		end
		endcase
	end


reg[3:0] rCountBaud;
/********************************************************************************************************
 ** 计数分频计数器, 输出分频结果脉冲
 ********************************************************************************************************/
always @(posedge clk or posedge rst)
begin : DIV_CNT
    if (rst) begin
        rCnt    <= 10'h0;
        rPlsTick <= 1'b0;
		  rCountBaud<=4'h0;
    end
    else 
	 if (enable) begin	 
		if(rCountBaud==4'hf)begin
			if (rCnt >= b-1'b1) begin
				rPlsTick <= 1'b1;
				rCnt    <= 10'h0;
				rCountBaud<=4'b0;
			end
			else begin
				rPlsTick <= 1'b0;
				rCnt    <= rCnt +10'h1;
			end 
		end
		else begin
			if (rCnt >= a-1) begin
				rPlsTick <= 1'b1;
				rCnt    <= 10'h0;
				rCountBaud<=rCountBaud+4'b1;
			end
			else begin
				rPlsTick <= 1'b0;
				rCnt    <= rCnt +10'h1;
			end 
	   end
    end 
    else begin 
		 rPlsTick <= 1'b0;
		 rCnt     <= 16'h0;
    end
	
end


/*
 *  输出信号
 */
assign  tick_out = rPlsTick;

endmodule

/*********************************************************************************************************
 ** End Of File
 ********************************************************************************************************/

