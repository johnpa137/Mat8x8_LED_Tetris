// drives the four pieces that are active
module tetrimino_driver(matrixOut, enableDisplay, clk, reset, gravityClk, left, right, down, spinLeft, spinRight, matrixIn);
	output logic [7:0][7:0] matrixOut;
	output logic enableDisplay;
	input logic gravityClk;
	input logic left, right, down, spinLeft, spinRight;
	input logic clk, reset;
	input logic [7:0][7:0] matrixIn; // fixed matrix of the leds
	
	// intermediate matrix
	logic [7:0][7:0] matrix;
	
	// x, y positions of each block in tetrimino
	logic [2:0] block_x [3:0];
	logic [2:0] block_y [3:0];
	logic [2:0] block_x_new [3:0];
	logic [2:0] block_y_new [3:0];
	
	// different types of tetriminoes
	// in order: I, J, L, O, S, T, Z
	logic [2:0] pieceType, nextPiece;
	// game states
	// in order: start, newPiece, falling, fixing
	logic [1:0] ps, ns;
	// storer for the random number
	logic [9:0] rndNumber;
	// storer for next randomized piece
	logic [2:0] nextRndPiece;
	
	assign nextRndPiece = rndNumber[9:7];
	LFSR_10 rnd(.out(rndNumber), .clk, .reset);
	tetrimino_creator tc0 (.outX3(block_x_new[3]), .outX2(block_x_new[2]), .outX1(block_x_new[1]), .outX0(block_x_new[0]), 
		.outY3(block_y_new[3]), .outY2(block_y_new[2]), .outY1(block_y_new[1]), .outY0(block_y_new[0]), .inType(pieceType));
	// tetrimino_rightSpinner(.outX3(block_x_new[3]), .outX2(block_x_new[2]), .outX1(block_x_new[1]), .outX0(block_x_new[0]), 
	//		.outX3(block_y_new[3]), .outX2(block_y_new[2]), .outX1(block_y_new[1]), .outX0(block_y_new[0]), .inType(pieceType));
	// tetrimino_leftSpinner(.outX3(block_x_new[3]), .outX2(block_x_new[2]), .outX1(block_x_new[1]), .outX0(block_x_new[0]), 
	//		.outX3(block_y_new[3]), .outX2(block_y_new[2]), .outX1(block_y_new[1]), .outX0(block_y_new[0]), .inType(pieceType));
	
	// we'll need to use 8 8-bit numbers for this
	tetrimino_locator tl0 (.matrixOut(matrix), .inX3(block_x[3]), .inX2(block_x[2]), .inX1(block_x[1]), .inX0(block_x[0]),
		.inY3(block_y[3]), .inY2(block_y[2]), .inY1(block_y[1]), .inY0(block_y[0]));
	
	always_comb begin
		case(ps)
			2'b00: begin
				nextPiece = nextRndPiece;
				ns = 2'b01; // newPiece
				block_x = block_x_new;
				block_y = block_y_new;
				enableDisplay = 1'b0;
			end
			2'b01: begin
				nextPiece = pieceType;
				ns = 2'b10; // falling
				block_x = block_x_new;
				block_y = block_y_new;
				enableDisplay = 1'b1;
			end
			2'b10: begin
				nextPiece = pieceType;
				//if(gravityClk)
					
			end
		endcase
	end
	
	
	always_ff @(posedge clk)
		if(reset) begin
			pieceType <= 3'b000;
			ps <= 2'b00;
		end else begin
			pieceType <= nextPiece;
			ps <= ns;
		end
endmodule 