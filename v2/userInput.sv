// input filter make sure only up to one key is pressed at once
module userInput(leftOut, rightOut, downOut, spinOut, leftIn, rightIn, downIn, spinIn, clk, reset);
	output logic leftOut, rightOut, downOut, spinOut;
	input logic leftIn, rightIn, downIn, spinIn;
	input logic clk, reset;
	
	logic left, right, down, spin;
	logic ps, ns;
	
	always_comb begin
		left = leftOut;
		right = rightOut;
		down = downOut;
		spin = spinOut;
		case(ps)
			1'b0: begin
				ns = 1'b0;
				left = leftIn & ~(rightIn | downIn | spinIn);
				right = rightIn & ~(leftIn | downIn | spinIn);
				down = downIn;
				spin = spinIn & ~(leftIn | rightIn | downIn);
				if(left | right | down | spin)
					ns = 1'b1;
			end
			1'b1: begin
				ns = 1'b1;
			end
		endcase
	end
	
	always_ff @(posedge clk) begin
	if(reset) begin
		ps <= 1'b0;
		leftOut <= 1'b0;
		rightOut <= 1'b0;
		downOut <= 1'b0;
		spinOut <= 1'b0;
	end else begin
		ps <= ns;
		leftOut <= left;
		rightOut <= right;
		downOut <= down;
		spinOut <= spin;
	end
	end
endmodule 

module userInput_testbench();
	logic leftOut, rightOut, downOut, spinOut;
	logic leftIn, rightIn, downIn, spinIn;
	
	userInput dut(.leftOut, .rightOut, .downOut, .spinOut, .leftIn, .rightIn, .downIn, .spinIn);
	
	logic [3:0] in;
	assign {leftIn, rightIn, downIn, spinIn} = in;
	
	integer i;
	initial begin
		#50; 
		for(i = 0; i < 16; i++) begin
			in <= i; #100;
		end
		$stop;
	end
endmodule
