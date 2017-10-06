// incrementer
module increment #(parameter WIDTH=1) (out, in);
	output logic [WIDTH-1:0] out;
	input logic [WIDTH-1:0] in;
	
	adder #(WIDTH) a(.sum(out), .overflow( ), .a(in), .b({WIDTH{1'b0}}), .cin(1'b1));
endmodule 