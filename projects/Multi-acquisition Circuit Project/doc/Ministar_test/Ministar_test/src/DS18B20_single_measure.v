`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:39:46 10/10/2013 
// Design Name: 
// Module Name:    DS18B20_single_measure 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module DS18B20_single_measure(start,sysclk,clk1mhz_en,dq_in,dq_out,temp_data);
input start,sysclk,clk1mhz_en,dq_in;
output dq_out;
output [15:0] temp_data;

reg [15:0] temp_data;
reg [71:0] receive_data=72'd0;
reg dq_out=1'b1;
reg rdy=1'b0;
reg [7:0] crc=8'h00;
reg [7:0] error_num=8'h00;

parameter       IDLE=6'b000001; // ����״̬
parameter       INIT=6'b000010; // ��ʼ��
parameter   SKIP_ROM=6'b000100; // ����
parameter    CONVERT=6'b001000; // ת��
parameter  READ_TEMP=6'b010000; // ��ȡ�¶�ֵ
parameter        END=6'b100000; // ����

reg [5:0] state=6'b000001;   
reg [15:0] t=16'd0;
reg [7:0]  i=8'd0;

reg convert_end=1'd0;
reg read_temp_end=1'd0;
reg convert_end_reg=1'd0;
reg send_convert_end=1'd0;
reg send_read_end=1'd0;
reg send_skip_end=1'd0;
reg [7:0] convert_command=8'hff;
reg [7:0] read_temp_command=8'hff;
reg [7:0] skip_command=8'hff;
reg init_end=1'd0;
reg init_f1=1'd0;
reg init_f2=1'd0;
reg init_f3=1'd0;

	

 
always@(posedge sysclk ) begin
if(start) begin
    	    convert_command<=8'h44;
	       read_temp_command<=8'hbe;
	       skip_command<=8'hcc;
       	 end
end 

always @(posedge sysclk )begin
case(state)
	       IDLE:if(start) begin
					state<=INIT;					
					end               					
	       INIT:if(init_end==1) begin
			      state<=SKIP_ROM;
               end					
      SKIP_ROM:if(send_skip_end==1'b1) begin
	            if(convert_end==0)	  
	            state<=CONVERT;   
               else  state<=READ_TEMP; 					
               end	              	
       CONVERT:if(convert_end==1'b1) begin
					state<=INIT;
					end
	  READ_TEMP:if(read_temp_end==1'b1) begin
	            state<=END;
               end					
           END:state<=IDLE;					
		 default:state<=IDLE;
endcase
end

always@(posedge sysclk) begin
case(state)
    IDLE: begin
	       	dq_out<=1'b1;
				rdy<=0;
				t<=0;
				i<=0;
				init_end<=0;
				convert_end<=0;
				read_temp_end<=0;
				init_f1<=0;
				init_f2<=0;
				init_f3<=0;
				convert_end_reg<=0;
				send_convert_end<=0;				
				send_read_end<=0;
				send_skip_end<=0;
				crc<=8'h00;
			 end
	 INIT: if(clk1mhz_en) begin
		    if(init_f1==0)
		     case(t)
					  16'd0:begin 
							  t<=t+1'b1;
							  dq_out<=0;
							  end
					16'd600:begin
							  t<=t+1'b1;
							  dq_out<=1'b1;						 
							  end								  
				   16'd660:begin
				           t<=0;
				           if(dq_in==0) 
							  init_f1<=1'b1;
							  end
					default:begin
					        t<=t+1'b1;
							  if((dq_in==0)&&(t>615)) begin
							  init_f1<=1'b1;
							  t<=0;
							  end
							  end
            endcase
            else if(init_f2==0) begin
                 if(dq_in==0)  t<=t+1'b1;
                 else if(t<60) 
                 begin
                 init_f1<=0;
                 t<=0;
                 end					  
                 else begin
					  init_f2<=1'b1;
					  t<=0;
					  end
					  end
			   else if(init_f3==0) begin
				     t<=t+1'b1;
					  if(t==420) begin
					  init_end<=1'b1;
					  t<=0;
					//rdy<=1'b1;
					  end
					  end			 
				  end
SKIP_ROM: if(clk1mhz_en)  begin
          if(send_skip_end==0) begin
			 if(i<8)
			 case(t)
					16'd0:  begin
							  t<=t+1'b1;
							  dq_out<=0;
							  end
				   16'd5:  begin
							  t<=t+1'b1;
							  dq_out<=skip_command[i];
							  end
				  16'd60:  begin
							  dq_out<=1'b1;
							  t<=t+1'b1;
							  end
				  16'd63:  begin
				           t<=0;
							  i<=i+1'b1;
                       end 
					
				 default:  t<=t+1'b1;
			 endcase
   		 else begin
			 i<=8'b0;
			 send_skip_end<=1'b1;
			 t<=0;			 
          end 
			 end
			 end
CONVERT:   if(clk1mhz_en)  begin
           if(send_convert_end==0) begin
			  if(i<8)
			  case(t)
					16'd0:  begin
							  t<=t+1'b1;
							  dq_out<=0;
							  end
				   16'd5:  begin
							  t<=t+1'b1;
							  dq_out<=convert_command[i];
							  end
				  16'd60:  begin
							  dq_out<=1'b1;
							  t<=t+1'b1;
							  end
				  16'd63:  begin
				           t<=0;
							  i<=i+1'b1;
                       end 
					
				 default:  t<=t+1'b1;
			   endcase
            else begin
			   i<=8'b0;			  
			   t<=0;	
            send_convert_end<=1'b1;				
            end  
			   end
			   else if(convert_end==0)
 				begin
				case(t)
				  16'd0:  begin
							 t<=t+1'b1;
							 dq_out<=0; 
							 end							 
				  16'd4:  begin
							 t<=t+1'b1;
							 dq_out<=1'b1; 
							 end
				 16'd10:  begin
							 t<=t+1'b1;
							 convert_end_reg<=dq_in;
							 end
				 16'd60:  begin 
							 t<=t+1'b1; 
							 dq_out<=1'b1;
							 end
				 16'd63:  begin
				          t<=0;
							 if(convert_end_reg==1'b1) begin
							 convert_end<=1'b1;
							 init_f1<=0;
							 init_f2<=0;
							 init_f3<=0;
							 init_end<=0;
							 send_skip_end<=0;							 
							 end
							 end
				 default:  t<=t+1'b1;
			   endcase
				end
				end          
			  
 READ_TEMP: if(clk1mhz_en)  begin
            if(send_read_end==0) begin
				if(i<8)
			   case(t)
					16'd0:  begin
							  t<=t+1'b1;
							  dq_out<=0;
							  end
				   16'd5:  begin
							  t<=t+1'b1;
							  dq_out<=read_temp_command[i];
							  end
				  16'd60:  begin
							  dq_out<=1'b1;
							  t<=t+1'b1;
							  end
				  16'd63:  begin
				           t<=0;
							  i<=i+1'b1;
                       end 
					
				 default:  t<=t+1'b1;
			   endcase
				else begin
				i<=0;
				t<=0;
				send_read_end<=1'b1;
				end
				end
			   else if(i<72)
            case(t)
				  16'd0:  begin
							 t<=t+1'b1;
							 dq_out<=0; 
							 end
							 
				  16'd4:  begin
							 t<=t+1'b1;
							 dq_out<=1'b1; 
							 end
				 16'd10:  begin
							 t<=t+1'b1;
							 receive_data[i]<=dq_in;
                      crc[0]<=crc[1];
							 crc[1]<=crc[2];
							 crc[2]<=(crc[0]^dq_in)^crc[3];
							 crc[3]<=(crc[0]^dq_in)^crc[4];
							 crc[4]<=crc[5];
							 crc[5]<=crc[6];
							 crc[6]<=crc[7];
                      crc[7]<=crc[0]^dq_in;							 
							 end
				 16'd60:  begin 
							 t<=t+1'b1; 
							 dq_out<=1'b1;
							 end
				 16'd63:  begin
							 t<=0;
							 i<=i+1'b1;
							 end
				 default: t<=t+1'b1; 
				 endcase 
				 else begin
				 i<=0;
				 t<=0;
				 if(crc==8'h00)
				 temp_data<=receive_data[15:0];
				 else error_num<=error_num+1'b1;
				 read_temp_end<=1'b1;
				 init_f1<=0;
				 init_f2<=0;
				 init_f3<=0;
				 init_end<=0;			 
				 end
				 end
	 END: 	 rdy<=1'b1;		 
endcase
end
   
  
endmodule
