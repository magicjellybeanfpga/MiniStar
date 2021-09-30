module top(
   input          clk, //27M 
    output  [1:0]led,
    output txd,
    inout  iic_io
);

//==============================================================================

    reg [24:0] led_light_cnt= 25'd0;
    reg [ 1:0] led_status = 2'b01;
    
    //  time counter
    always @(posedge clk)
    begin
        if(led_light_cnt == 25'd2649_9999)
            led_light_cnt <=  25'd0;
        else
            led_light_cnt <=  led_light_cnt + 25'd1; 
    end
    
    // led status change
    always @(posedge clk)
    begin
        if(led_light_cnt == 25'd1349_9999)
            led_status <=  {led_status[0],led_status[1]};
    end

    assign led = led_status;

reg [7:0] cnt_1m;

    always @(posedge clk)
    begin
        if(cnt_1m == 8'd26)
            cnt_1m <=  8'd0;
        else
            cnt_1m <=  cnt_1m + 8'd1; 
    end



////////////////温度采集/////////////////////////////
wire accx_out;
wire clk_1Hz_en,clk_1Mhz_en;
wire [15:0] temp_ax;

assign  clk_1Hz_en=(led_light_cnt == 25'd1);
assign   clk_1Mhz_en=(cnt_1m == 8'd1);
DS18B20_single_measure x_temp_measure(
.start(clk_1Hz_en),
.sysclk(clk),
.clk1mhz_en(clk_1Mhz_en),
.dq_in(iic_io),
.dq_out(accx_out),
.temp_data(temp_ax));

assign iic_io =(accx_out)? 1'bz:1'b0;




//wire accy_out;

//DS18B20_single_measure y_temp_measure(.start(clk_1Hz_en),.sysclk(clk),.clk1mhz_en(clk_1Mhz_en),
//.dq_in(acc_y_18b20_i),.dq_out(accy_out),.temp_data(temp_ay));

//assign acc_y_18b20_i =(accy_out)? 1'bz:1'b0;

//wire accz_out;

//DS18B20_single_measure z_temp_measure(.start(clk_1Hz_en),.sysclk(clk),.clk1mhz_en(clk_1Mhz_en),
//.dq_in(acc_z_18b20_i),.dq_out(accz_out),.temp_data(temp_az));

//assign acc_z_18b20_i =(accz_out)? 1'bz:1'b0;

////////////////串口发送/////////////////////////////

reg wr_en;
reg [7:0] data_in;
 always @(posedge clk)
    begin
        if(led_light_cnt == 25'd1349_9999)begin
          wr_en<=1;
          data_in<=temp_ax[15:8];
        end
        else if(led_light_cnt == 25'd1949_9999)begin
             wr_en<=1;
             data_in<=temp_ax[7:0];

              end
             else begin
             wr_en<=0;
             end
    end

UART_Tx_module  UART_Tx_module(
.clk(clk),
.rst(1'b0),
.en(1'b1),
.data_in(data_in),
.tx(txd),
.Wr(wr_en));







endmodule