// WIDTH is the size of the output
module decoder #(parameter WIDTH=2) (out, in);
	output logic [WIDTH-1:0] out;
	input logic [(2**WIDTH)-1:0] in;
	
	logic [(2**WIDTH)-2:0][WIDTH-1:0] orOut;
	logic [(2**WIDTH)-1:0][WIDTH-1:0] bitOut;
	
	assign out = orOut[(2**WIDTH)-2];
	
	genvar i;
	generate
		for(i = 0; i < (2**WIDTH)-1; i++) begin : ors
			if(i == 0)
				or or0 (orOut[i], bitOut[i+1], bitOut[i]);
			else
				or or0 (orOut[i], bitOut[i+1], orOut[i-1]);
		end
		for(i = 1; i < 2**WIDTH+1; i++) begin : dbits
			decoder_bit #(WIDTH) dbit (bitOut[i-1], in[i-1], i);
		end
	endgenerate
endmodule 

module decoder_bit #(parameter WIDTH=2)(out, in, index);
	output logic [WIDTH-1:0] out;
	input logic [WIDTH-1:0] index;
	input logic in;
	
	always_comb begin
		out = '0;
		if(in)
			out = index;
	end
endmodule 