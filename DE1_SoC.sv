// John Paul Aglubat Lab#2 EE271
// Top-level module that defines the I/Os for the DE-1 SoC board
module DE1_SoC (CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW, GPIO_0);
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	output logic [35:0] GPIO_0;
	input logic CLOCK_50;
	input logic [3:0] KEY;
	input logic [9:0] SW;
	
	logic [7:0] red_driver;
	assign {GPIO_0[22], GPIO_0[19], GPIO_0[16], GPIO_0[13], GPIO_0[10], GPIO_0[7], GPIO_0[4], GPIO_0[1]} = red_driver;
	logic [7:0] green_driver;
	assign {GPIO_0[23], GPIO_0[20], GPIO_0[17], GPIO_0[14], GPIO_0[11], GPIO_0[8], GPIO_0[5], GPIO_0[2]} = green_driver;
	logic [7:0] row_sink;
	assign {GPIO_0[21], GPIO_0[18], GPIO_0[15], GPIO_0[12], GPIO_0[9], GPIO_0[6], GPIO_0[3], GPIO_0[0]} = row_sink;
	
	// Default values, turns off the HEX displays
	assign HEX0 = 7'b1111111;
	assign HEX1 = 7'b1111111;
	assign HEX2 = 7'b1111111;
	assign HEX3 = 7'b1111111;
	assign HEX4 = 7'b1111111;
	assign HEX5 = 7'b1111111;
	
	logic [7:0][7:0] red_array;
	logic [7:0][7:0] green_array;
	
	assign red_array[7] = 8'hff;
	assign red_array[6] = 8'h00;
	assign red_array[5] = 8'hff;
	assign red_array[4] = 8'h00;
	assign red_array[3] = 8'hff;
	assign red_array[2] = 8'h00;
	assign red_array[1] = 8'hff;
	assign red_array[0] = 8'h00;
	
	assign green_array[7] = 8'h00;
	assign green_array[6] = 8'hff;
	assign green_array[5] = 8'h00;
	assign green_array[4] = 8'hff;
	assign green_array[3] = 8'h00;
	assign green_array[2] = 8'hff;
	assign green_array[1] = 8'h00;
	assign green_array[0] = 8'hff;
	
	logic [31:0] div_clk;
	parameter clk_763kHz = 15;
	clock_divider cd (.clk(CLOCK_50), .div_clk);
	
	// led_matrix_driver lmd (.red_driver, .green_driver, .row_sink, .clk(CLOCK_50), .reset(SW[9]), .red_array, .green_array);
	led_matrix_driver lmd (.red_driver, .green_driver, .row_sink, .clk(div_clk[clk_763kHz]), .reset(SW[9]), .red_array, .green_array);
endmodule

module DE1_SoC_testbench();
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0] LEDR;
	logic [35:0] GPIO_0;
	logic CLOCK_50;
	logic [3:0] KEY;
	logic [9:0] SW;
	
	logic reset;
	assign SW[9] = reset;
	logic clk;
	assign CLOCK_50 = clk;
	
	DE1_SoC dut(.CLOCK_50, .HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .KEY, .LEDR, .SW, .GPIO_0);
	
	initial begin
		@(posedge clk); reset <= 1;
		@(posedge clk); reset <= 0;
		for(integer i = 0; i < 256; i++)
			@(posedge clk);  
		$stop;
	end

endmodule 