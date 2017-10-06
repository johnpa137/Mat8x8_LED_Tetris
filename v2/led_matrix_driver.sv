module led_matrix_driver(red_driver, green_driver, row_sink, clk, reset, red_array, green_array);
	output logic [7:0] red_driver, green_driver, row_sink;
	input logic [7:0][7:0] red_array, green_array;
	input logic clk, reset;
	
	logic [2:0] p_row, n_row; // present row and next row
	
	increment #(.WIDTH(3)) inc (.out(n_row), .in(p_row));
	
	always_comb
		case(p_row)
			3'b000: row_sink = 8'b11111110;
			3'b001: row_sink = 8'b11111101;
			3'b010: row_sink = 8'b11111011;
			3'b011: row_sink = 8'b11110111;
			3'b100: row_sink = 8'b11101111;
			3'b101: row_sink = 8'b11011111;
			3'b110: row_sink = 8'b10111111;
			3'b111: row_sink = 8'b01111111;
		endcase
	
	always_ff @(posedge clk)
		if(reset)
			p_row <= 3'b000;
		else
			p_row <= n_row;
			
	assign red_driver = red_array[p_row];
	assign green_driver = green_array[p_row];
endmodule 

module led_matrix_driver_testbench();
	logic [7:0] red_driver, green_driver, row_sink;
	logic [7:0][7:0] red_array, green_array;
	logic clk, reset;

	assign red_array[7] = 8'b11111111;
	assign red_array[6] = 8'b01010101;
	assign red_array[5] = 8'b01010101;
	assign red_array[4] = 8'b01010101;
	assign red_array[3] = 8'b01010101;
	assign red_array[2] = 8'b01010101;
	assign red_array[1] = 8'b01010101;
	assign red_array[0] = 8'b01010101;
	
	assign green_array[7] = 8'b00000000;
	assign green_array[6] = 8'b10101010;
	assign green_array[5] = 8'b10101010;
	assign green_array[4] = 8'b10101010;
	assign green_array[3] = 8'b10101010;
	assign green_array[2] = 8'b10101010;
	assign green_array[1] = 8'b10101010;
	assign green_array[0] = 8'b10101010;
	
	// Set up the clock.
	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	led_matrix_driver dut (.red_driver, .green_driver, .row_sink, .clk, .reset, .red_array, .green_array);
	
	initial begin
		@(posedge clk); reset <= 1;
		@(posedge clk); reset <= 0;
		@(posedge clk); 
		@(posedge clk); 
		@(posedge clk); 
		@(posedge clk); 
		@(posedge clk); 
		@(posedge clk); 
		@(posedge clk); 
		@(posedge clk); 
		@(posedge clk); 
		@(posedge clk); 
		@(posedge clk); 
		@(posedge clk); 
		@(posedge clk); 
		@(posedge clk); 
		@(posedge clk); 
		@(posedge clk); 
		$stop;
	end
endmodule 