module keyInput(out, in, clk, reset);
	output logic out;
	input logic in;
	input logic clk, reset;
	
	logic ps, ns;
	logic in0, in1;
	
	always_comb begin
		out = 1'b0;
		case(ps)
			1'b0: begin // not pressed
				if(in1) begin
					ns = 1'b1;
					out = 1'b1;
				end else begin
					ns = 1'b0;
				end
			end
			1'b1: begin // pressed
				if(in1) begin
					ns = 1'b1;
				end else begin
					ns = 1'b0;
				end
			end
		endcase
	end
	
	always_ff @(posedge clk)
		if(reset) begin
			ps <= 1'b0;
			in0 <= 1'b0;
			in1 <= 1'b0;
		end else begin
			ps <= ns;
			in0 <= in;
			in1 <= in0;
		end
endmodule 

module keyInput_testbench();
	logic clk, reset;
	logic out, in;
	
	// Set up the clock.
	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	keyInput dut(.out, .clk, .reset, .in);
	
	initial begin
		@(posedge clk); reset <= 1;
		@(posedge clk); reset <= 0; in <= 0;
		@(posedge clk); 
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk); in <= 1;
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk); 
		@(posedge clk); in <= 0;
		@(posedge clk); in <= 1;
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk); 
		$stop;
	end
endmodule
