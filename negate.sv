module negate #(parameter XSIZE=3) (out, in);
	output logic [XSIZE-1:0] out;
	input logic [XSIZE-1:0] in;
	
	increment #(XSIZE) inc (out, ~in);
endmodule 