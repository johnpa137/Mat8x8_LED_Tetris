// counter
module counter #(parameter WIDTH=1) (out, clk, reset, in);
	output logic [WIDTH-1:0] out;
	input logic clk, reset, in;
	
	logic [WIDTH-1:0] ps, ns;
	
	increment #(WIDTH) inc(.out(ns), .in(ps));
	
	always_ff @(posedge clk) begin 
		if(reset)
			ps <= 0;
		else	
			ps <= ns;
	end 
endmodule 

module counter_testbench();
	logic [2:0] out;
	logic clk, reset, in;
	
	// Set up the clock.
	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	counter #(3) dut(.out, .clk, .reset, .in);
	
	initial begin
		@(posedge clk); reset <= 1;
		@(posedge clk); reset <= 0; in <= 0;
		@(posedge clk); //0
		@(posedge clk); //0
		@(posedge clk); in <= 1; //0
		@(posedge clk); //1
		@(posedge clk); in <= 0; //2
		@(posedge clk); //2
		@(posedge clk); //2
		@(posedge clk); //2
		@(posedge clk); in <= 1;//2
		@(posedge clk); //3
		@(posedge clk); //4
		@(posedge clk); //5
		@(posedge clk); //6
		@(posedge clk); //7
		@(posedge clk); //0
		@(posedge clk); //1
		@(posedge clk); //2
		$stop;
	end
endmodule 