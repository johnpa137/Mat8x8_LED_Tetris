// comparator
module greaterThan #(parameter WIDTH=1) (out, a, b);
	output logic out;
	input logic [WIDTH-1:0] a, b;
	
	logic [WIDTH:0] sum;
	logic [WIDTH-1:0] not_b;
	
	always_comb begin
		not_b = ~b;
		out = ~sum[WIDTH];
	end
	
	adder #(.WIDTH(WIDTH + 1)) a0 (.sum, .overflow( ), .a({1'b0, a}), .b({1'b1, not_b}), .cin(1'b1));
endmodule 

module greaterThan_testbench();
	logic out;
	logic [1:0] a, b;
	
	greaterThan #(10) dut(.out, .a, .b);
	
	initial begin
		#50; a = 1; b = 0;
		#100;
		#100; a = 35; b = 12;
		#100;
		#100; a = 200010; b = 300012;
		#100;
		#100; a = 36; b = 33;
		#100;
	end
endmodule 