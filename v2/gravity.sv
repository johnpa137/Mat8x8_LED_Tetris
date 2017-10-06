module gravity #(parameter WIDTH=1) (out, clk, reset);
	output logic out;
	input logic clk, reset;
	
	logic [WIDTH-1:0] count, countNext, incOut;
	
	increment #(WIDTH) inc (.out(countNext), .in(count));
	
	assign out = &count;
	
	always_ff @(posedge clk) begin
		if(reset)
			count <= '0;
		else
			count <= countNext;
	end
endmodule 