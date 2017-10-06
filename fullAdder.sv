// full adder
module fullAdder(sum, cout, a, b, cin);
	output logic sum, cout;
	input logic a, b, cin;
	
	logic x; // xor output
	
	always_comb begin
		x = a ^ b;
		cout = (x & cin) | (a & b);
		sum = a ^ b ^ cin;
	end
endmodule 

module fullAdder_testbench();
	logic sum, cout;
	logic a, b, cin;
	
	fullAdder dut(.sum, .cout, .a, .b, .cin);
	
	integer i;
	initial begin
	for(i = 0; i < 8; i++) begin
		{a, b, cin} = i; #100;
	end
	$stop;
	end
endmodule 