

module top(
    inout [15:0] gpio_io,
    input reset_n,
    input  uart0_rxd,
    output  uart0_txd 
);


wire m3_clk;

    Gowin_OSC U_Gowin_OSC(
        .oscout  (m3_clk), 
        .oscen   (1)
    );



	Gowin_EMPU_Top your_instance_name(
		.sys_clk (m3_clk),  //input sys_clk
		.gpio    (gpio_io), //inout [15:0] gpio
		.reset_n (reset_n),  //input reset_n
        .uart0_rxd(uart0_rxd),        //input uart0 rxd
        .uart0_txd(uart0_txd)         //output  uart0 txd
	);


endmodule

