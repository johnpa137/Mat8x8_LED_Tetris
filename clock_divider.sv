// 50 MHz clock divider
module clock_divider (clk, div_clk);
	input logic clk;
	output logic [31:0] div_clk;
	
	initial
		div_clk <= 0;
	
	always_ff @(posedge clk)
		div_clk <= div_clk + 1;
endmodule 