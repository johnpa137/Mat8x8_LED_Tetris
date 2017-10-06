// downKey can be held but is stopped when the piece lands and a new piece is created
// out can't be true again until the button is let go and pressed again
module downKeyInput(out, in, clk, reset, resetPiece);
	output logic out;
	input logic in, resetPiece;
	input logic clk, reset;
	
	logic [1:0] ps, ns;
	logic in0, in1;
	
	always_comb begin
		out = 1'b0;
		case(ps)
			2'b00: begin // not pressed
				if(in1) begin
					ns = 2'b01;
					out = 1'b1;
				end else begin
					ns = 1'b0;
				end
			end
			2'b01: begin // pressed
				if(resetPiece) begin
					ns = 2'b10;
				end else if(in1) begin
					ns = 2'b01;
					out = 1'b1;
				end else begin
					ns = 2'b00;
				end
			end
			2'b10: begin
				if(in1)
					ns = 2'b10;
				else
					ns = 2'b00;
			end
		endcase
	end
	
	always_ff @(posedge clk) begin
		if(reset) begin
			ps <= 2'b00;
			in0 <= 1'b0;
			in1 <= 1'b0;
		end else begin
			ps <= ns;
			in0 <= in;
			in1 <= in0;
		end
	end
endmodule 

module downKeyInput_testbench();
	logic clk, reset;
	logic out, in, resetPiece;
	
	// Set up the clock.
	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	downKeyInput dut(.out, .clk, .reset, .in, .resetPiece);
	
	initial begin
		@(posedge clk); reset <= 1;
		@(posedge clk); reset <= 0; in <= 0; resetPiece <= 0;
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
		@(posedge clk); resetPiece <= 1;
		@(posedge clk); resetPiece <= 0;
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
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk); 
		$stop;
	end
endmodule