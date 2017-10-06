module tetrimino_manager(fix, activeLedMatrixOut, offLedMatrixOut, destructArray, enableDisplay, moveDown, moveLeft, moveRight, clk, reset, spin, fixedLedMatrixIn, activeLedMatrixIn, landed, fastClk, moveOkay, left, right, down);
	output logic fix; // connected to fix of led_drivers
	output logic [7:0][7:0] activeLedMatrixOut; // connected to activate of led_drivers
	output logic [7:0][7:0] offLedMatrixOut; // connected to off of led_drivers
	output logic [7:0] destructArray; // connected to destruct of led drivers
	output logic [7:0][7:0] enableDisplay; // connected to matrix driver
	output logic moveDown, moveLeft, moveRight;
	input logic clk, reset, fastClk;
	input logic spin; // delayed 
	input logic landed; // sent by led_driver to indicate that the active tetrimino has reached landed on a fixed block
	input logic [7:0][7:0] fixedLedMatrixIn;
	input logic [7:0][7:0] activeLedMatrixIn;
	input logic [7:0][7:0] moveOkay;
	input logic left, right, down; // player controls delayed by one cycle
	
	logic [7:0][7:0] zeros;
	
	assign zeros[7] = 8'h0000;
	assign zeros[6] = 8'h0000;
	assign zeros[5] = 8'h0000;
	assign zeros[4] = 8'h0000;
	assign zeros[3] = 8'h0000;
	assign zeros[2] = 8'h0000;
	assign zeros[1] = 8'h0000;
	assign zeros[0] = 8'h0000;
	
	// original pieces and their spins
	logic [4:0] pieceNow, pieceNext, pieceSpinNow, pieceSpinNext;
	
	logic [1:0] ps, ns;
	
	logic [9:0] rndNumber;
	logic [2:0] nextRndPiece; // storer for next randomized piece
	logic [7:0][7:0] createMatrix;
	logic [7:0][7:0] spinMatrixActive, spinMatrixOff;
	
	assign nextRndPiece = rndNumber[9:7];
	LFSR_10 rnd(.out(rndNumber), .clk, .reset);
	tetrimino_creator tc0 (.matrixOut(createMatrix), .inType(pieceNow[2:0]));
	tetrimino_spinner ts0 (.activeMatrixOut(spinMatrixActive), .newSpin(pieceSpinNext), .offMatrixOut(spinMatrixOff), .activeLedMatrixIn, .fixedLedMatrixIn, .spinType(pieceSpinNow), .clk, .reset);
	
	logic movable;
	assign movable = 
	(moveOkay[7] == 8'hff) & 
	(moveOkay[6] == 8'hff) & 
	(moveOkay[5] == 8'hff) & 
	(moveOkay[4] == 8'hff) & 
	(moveOkay[3] == 8'hff) & 
	(moveOkay[2] == 8'hff) & 
	(moveOkay[1] == 8'hff) & 
	(moveOkay[0] == 8'hff) ;
	
	assign destructArray[7] = (fixedLedMatrixIn[7] == 8'hff);
	assign destructArray[6] = (fixedLedMatrixIn[7] == 8'hff);
	assign destructArray[5] = (fixedLedMatrixIn[7] == 8'hff);
	assign destructArray[4] = (fixedLedMatrixIn[7] == 8'hff);
	assign destructArray[3] = (fixedLedMatrixIn[7] == 8'hff);
	assign destructArray[2] = (fixedLedMatrixIn[7] == 8'hff);
	assign destructArray[1] = (fixedLedMatrixIn[7] == 8'hff);
	assign destructArray[0] = (fixedLedMatrixIn[7] == 8'hff);
	
	always_comb begin
		pieceNext = pieceNow;
		pieceSpinNext = pieceSpinNow;
		fix = 1'b0;
		enableDisplay = 1'b1;
		moveLeft = 1'b0;
		moveRight = 1'b0;
		moveDown = 1'b0;
		activeLedMatrixOut = zeros;
		offLedMatrixOut = zeros;
		case(ps)
			2'b00: begin // start
				if(nextRndPiece == 3'b000)
					nextRndPiece = 3'b001;
				pieceNext = {2'b00, nextRndPiece};
				pieceSpinNext = pieceNext;
				ns = 2'b01; // newPiece
				activeLedMatrixOut = zeros;
				enableDisplay = 1'b0;
			end
			2'b01: begin // new piece
				ns = 2'b10; // falling
				activeLedMatrixOut = createMatrix;
				enableDisplay = 1'b0;
			end
			2'b10: begin // falling
				ns = 2'b10;
				activeLedMatrixOut = activeLedMatrixIn;
				if(landed) begin
					fix = 1'b1;
					ns = 2'b00;
				end
				if(movable) begin
					if(down)
						moveDown = 1'b1;
					else if (right)
						moveRight = 1'b1;
					else if (left)
						moveLeft = 1'b1;
				end
				if(spin) begin
					activeLedMatrixOut = spinMatrixActive;
					offLedMatrixOut = spinMatrixOff;
				end
			end
		endcase
	end
	
	always_ff @(posedge clk)
		if(reset) begin
			pieceNow <= 5'b00000;
			pieceSpinNow <= 5'b00000;
			ps <= 2'b00;
		end else begin
			pieceNow <= pieceNext;
			pieceSpinNow <= pieceSpinNext;
			ps <= ns;
		end
endmodule 