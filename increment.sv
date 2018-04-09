// incrementer
module increment #(parameter WIDTH=1) (out, in);
	output logic [WIDTH-1:0] out;
	input logic [WIDTH-1:0] in;
	
	adder #(WIDTH) a(.sum(out), .overflow( ), .a(in), .b({WIDTH{1'b0}}), .cin(1'b1));
endmodule 

module increment_testbench();
	logic [3:0] out;
	logic [3:0] in;
	
	increment #(4) dut (out, in);
	
	initial begin 
	in <= 4'h0; #100; // 1
	in <= 4'h5; #100; // 6
	in <= 4'hf; #100; // 0
	$stop;
	end
endmodule 