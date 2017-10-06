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