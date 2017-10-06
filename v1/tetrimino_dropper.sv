module tetrimino_dropper(land, outX3, outX2, outX1, outX0, outY3, outY2, outY1, outY0, inX3, inX2, inX1, inX0, inY3, inY2, inY1, inY0, matrixIn);
	output logic land;
	output logic [2:0] outX3, outX2, outX1, outX0, outY3, outY2, outY1, outY0;
	input logic [2:0] inX3, inX2, inX1, inX0, inY3, inY2, inY1, inY0;
	input logic [7:0][7:0] matrixIn;
	
	logic block3, block2, block1, block0;
	
	matrix8x8_vc vc3 (.out(block3), .matrixIn, .x(inX3), .y(inY3));
	matrix8x8_vc vc2 (.out(block2), .matrixIn, .x(inX2), .y(inY2));
	matrix8x8_vc vc1 (.out(block1), .matrixIn, .x(inX1), .y(inY1));
	matrix8x8_vc vc0 (.out(block0), .matrixIn, .x(inX0), .y(inY0));
	
	always_comb begin
		if(block3 | block2 | block1 | block0) begin
			land = 1'b1;
			outX3 = inX3;
			outX2 = inX2;
			outX1 = inX1;
			outX0 = inX0;
			outY3 = inY3;
			outY2 = inY2;
			outY1 = inY1;
			outY0 = inY0;
		end else begin
			land = 1'b0;
			outX3 = inX3;
			outX2 = inX2;
			outX1 = inX1;
			outX0 = inX0;
			outY3 = inY3 + 1;
			outY2 = inY2 + 1;
			outY1 = inY1 + 1;
			outY0 = inY0 + 1;
		end
	end
endmodule 