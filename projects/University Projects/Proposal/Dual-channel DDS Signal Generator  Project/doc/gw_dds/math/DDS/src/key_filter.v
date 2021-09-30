module key_filter(
	input clk,
	input rst_n,
	input key_in,
	output  reg key_out
	);
parameter count_bit=10;//计数器宽度
//parameter limit=2**(count_bit-1);
reg [count_bit-1:0] counter;
always @(posedge clk) 
begin
	if (!rst_n) 
		counter<=0;
	else 
		begin
		case(key_in)
		1'b0:begin
			if(counter==0)
				counter<=counter;
			else
				counter<=counter-1'b1;
			end
		1'b1:begin
			if(counter==(2**count_bit)-1)
				counter<=counter;
			else
				counter<=counter+1'b1;
			end
		default:counter<=0;
		endcase
		end
end
always @(posedge clk) begin
	if (!rst_n) 
		key_out<=1;
	else 
		begin
		if(counter[count_bit-1]==1'b0)	
			key_out<=1'b0;
		else
			key_out<=1'b1;
		end
end
endmodule
