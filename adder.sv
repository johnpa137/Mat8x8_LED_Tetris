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

module adder_testbench();
	logic [3:0] sum;
	logic overflow;
	logic [3:0] a, b;
	logic cin;
	
	adder #(4) dut (sum, overflow, a, b, cin);
	
	initial begin
		a <= 4'h5; b <= 4'h0; cin <= 1'b0; #100; // 5
		a <= 4'h6; b <= 4'h0; cin <= 1'b1; #100; // 7
		a <= 4'h4; b <= 4'h2; cin <= 1'b0; #100; // 6 
		a <= 4'h5; b <= 4'hf; cin <= 1'b0; #100; // 4 with overflow
		$stop;
	end
endmodule 