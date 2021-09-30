
//AHB TOARM
//Default is Burst 16 -> 4 word

module Gowin_AHB_TOARM_Top
(
	//AHB bus IO
	output	wire	[31:0]			 AHB_HRDATA,
	output	wire					 AHB_HREADY,
	output	wire					 AHB_HRESP,
	input	wire	[1:0]  		     AHB_HTRANS,
	input	wire	[2:0]  	    	 AHB_HBURST,
	input	wire	[3:0]  		     AHB_HPROT,
	input	wire	[2:0]			 AHB_HSIZE,
	input	wire					 AHB_HWRITE,
	input	wire					 AHB_HMASTLOCK,
	input	wire	[3:0]			 AHB_HMASTER,
	input	wire	[31:0]			 AHB_HADDR,
	input	wire	[31:0]  		 AHB_HWDATA,
	input	wire					 AHB_HSEL,
	input	wire					 AHB_HCLK,
	input	wire					 AHB_HRESETn,

	// user IO
    input   wire                     hpram_base_clk,
    input   wire                     hpram_memory_clk,
    output  wire                     led_init
);

//The AHB BUS is always ready
assign AHB_HREADY = 1'b1;

//Response OKAY
assign AHB_HRESP  = 1'b0;

//Define Reg for AHB BUS
reg [11:0]  ahb_address;
reg 		ahb_control;
reg         ahb_sel;
reg         ahb_htrans;

always @(posedge AHB_HCLK or negedge AHB_HRESETn)
begin
	if(~AHB_HRESETn)
        begin
            ahb_address  <= 12'b0;
            ahb_control  <= 1'b0;
            ahb_sel      <= 1'b0;
            ahb_htrans   <= 1'b0;
        end
	else              //Select The AHB Device 
        begin			  //Get the Address of reg
            ahb_address  <= AHB_HADDR[11:0];
            ahb_control  <= AHB_HWRITE;
            ahb_sel      <= AHB_HSEL;
            ahb_htrans   <= AHB_HTRANS[1];
        end
end

wire write_enable = ahb_htrans & ahb_control    & ahb_sel;
wire read_enable  = ahb_htrans & (!ahb_control) & ahb_sel;

//Write to AHB register
reg  		reg_wr_en;
reg [31:0]  reg_data_in0;
		
//write data to register	
always @(posedge AHB_HCLK or negedge AHB_HRESETn)
begin
	if(~AHB_HRESETn)
	begin
		reg_wr_en  		<= 1'b0;
		reg_data_in0	<= 32'b0;
        reg_init_done <= 1'b1;   // init ok
	end
	else if(write_enable)
	begin
		case (ahb_address[11:2])
			10'h000: reg_wr_en 		<= AHB_HWDATA[0];
			10'h001: reg_data_in0	<= AHB_HWDATA;
			default: ;
		endcase
	end
end
// test
assign led_init = reg_data_in0[0];


//read data from FPGA
reg  		reg_rd_en;
reg [31:0]  reg_data_len;
reg  		reg_init_done;

reg [31:0]  reg_data_out0;
reg [31:0]	ahb_rdata;

//read data from AHB
always @(*)
begin
	if(read_enable)
	begin
		case (ahb_address[11:2])
		10'h000: ahb_rdata = {31'h0,reg_wr_en};
        10'h001: ahb_rdata = reg_data_in0;
		10'h002: ahb_rdata = {31'h0,reg_rd_en};
		10'h003: ahb_rdata = reg_data_len;
		10'h004: ahb_rdata = reg_data_out0;
        10'h005: ahb_rdata = {31'b0,reg_init_done};
		default: ahb_rdata = 32'hFFFFFFFF;
		endcase
	end
	else
	begin
		ahb_rdata = 32'hFFFFFFFF;
	end
end
assign AHB_HRDATA = ahb_rdata;



wire wire_init;
//cross the clk domain -init sig
//user clk -> ahb clk
reg cross_wire_init1,cross_wire_init2;

always @(posedge AHB_HCLK or negedge AHB_HRESETn)
begin
    if(~AHB_HRESETn)
    begin
        cross_wire_init1  <= 1'b0;
        cross_wire_init2  <= 1'b0;
    end
    else
    begin
        cross_wire_init1  <= wire_init;
        cross_wire_init2  <= cross_wire_init1;
    end
end
//cross_wire_init2 will be read


//cross the rd valid user clk -> ahb clk
reg cross_rd_valid1,cross_rd_valid2;
wire rd_valid;

always @(posedge AHB_HCLK or negedge AHB_HRESETn)
begin
    if(~AHB_HRESETn)
        begin
            cross_rd_valid1  <= 1'b0;
            cross_rd_valid2  <= 1'b0;
        end
    else
        begin
            cross_rd_valid1  <= rd_valid;
            cross_rd_valid2  <= cross_rd_valid1;
        end
end





endmodule