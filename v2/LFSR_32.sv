module LFSR_32(out, clk, reset);
	output logic [31:0] out;
	input clk, reset;
	
	logic xn;
	logic [31:0] ps;
	
	always_comb begin
		xn = ~(ps[31] ^ ps[21] ^ ps[1] ^ ps[0]);
		out = ps;
	end
	
	always_ff @(posedge clk)
		if(reset)
			ps <= {32{1'b0}};
		else	
			ps <= {xn, ps[31:1]};
endmodule

module LFSR_32_testbench();
	logic [31:0] out;
	logic clk, reset;
	
	// Set up the clock.
	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	LFSR_32 dut(.out, .clk, .reset);

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

