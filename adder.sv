
module adder #(parameter WIDTH=1) (sum, overflow, a, b, cin);
	output logic [WIDTH-1:0] sum;
	output logic overflow;
	input logic [WIDTH-1:0] a, b;
	input logic cin;
	
	logic [WIDTH:0] carries;
	
	assign carries[0] = cin;
	assign overflow = carries[WIDTH] ^ carries[WIDTH-1];
	
	genvar i;
	generate
		for(i=0; i<WIDTH; i++) begin : subAdders
			fullAdder fa(.sum(sum[i]), .cout(carries[i+1]), .a(a[i]), .b(b[i]), .cin(carries[i]));
		end
	endgenerate
endmodule 