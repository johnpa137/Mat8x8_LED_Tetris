// cyber player
module cyber_player(out, clk, reset, SWin);
	output logic out;
	input logic clk, reset;
	input logic [8:0] SWin;
	
	logic [9:0] LFSR_num;
	
	LFSR_10 rnd(.out(LFSR_num), .clk, .reset);
	greaterThan #(.WIDTH(10)) comp(.out, .a({1'b0, SWin}), .b(LFSR_num));
endmodule

module cyber_player_testbench();
	logic out;
	logic clk, reset;
	logic [8:0] SWin;
	
	cyber_player dut(.out, .clk, .reset, .SWin);
	
	initial begin
	@(posedge clk); reset <= 1;
	@(posedge clk); reset <= 0; SWin <= 511;
	@(posedge clk); 
	@(posedge clk); 
	@(posedge clk); 
	@(posedge clk); 
	@(posedge clk); 
	@(posedge clk); 
	@(posedge clk);  SWin <= 0;
	@(posedge clk); 
	@(posedge clk); 
	@(posedge clk); 
	@(posedge clk); 
	@(posedge clk); 
	@(posedge clk); 
	@(posedge clk); 
	@(posedge clk); 
	@(posedge clk); 
	@(posedge clk); 
	$stop;
	end
endmodule 
