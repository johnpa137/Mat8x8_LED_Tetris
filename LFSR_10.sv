// random number generator
module LFSR_10(out, clk, reset);
	output logic [9:0] out;
	input clk, reset;
	
	logic xn; // xnor_out
	logic [9:0] ps;
	
	always_comb begin
		xn = ~(ps[3] ^ ps[0]);
		out = ps;
	end
	
	always_ff @(posedge clk)
		if(reset)
			ps <= 10'b1000010000;
		else	
			ps <= {xn, ps[9:1]};
endmodule 

module LFSR_10_testbench();
	logic [9:0] out;
	logic clk, reset;
	
	// Set up the clock.
	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	LFSR_10 dut(.out, .clk, .reset);

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
		@(posedge clk); 
		@(posedge clk); 
		@(posedge clk); 
		@(posedge clk); 
		$stop;
	end

endmodule 