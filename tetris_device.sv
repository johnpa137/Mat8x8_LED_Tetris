module tetris_device #(parameter WIDTH=8, parameter HEIGHT=8, parameter XSIZE=3, parameter YSIZE=3) 
	(redMatrix, greenMatrix, scoreOut, leftkey, rightkey, downkey, spinkey, startX, startY, clk, reset);
	output logic [HEIGHT-1:0][WIDTH-1:0] redMatrix;
	output logic [HEIGHT-1:0][WIDTH-1:0] greenMatrix;
	output logic [20:0] scoreOut;
	input logic [XSIZE-1:0] startX;
	input logic [YSIZE-1:0] startY;
	input logic leftkey, rightkey, downkey, spinkey;
	input logic clk, reset; // 50 mHz clock
	
	logic [3:0] ps, ns;
	
	// inputs
	logic left0, right0, down0, spin0;
	logic left, right, down, spin;
	logic g; // gravity tick
	
	gravity #(21) grav (g, clk, reset);
	
	logic inputReset;
	logic downKeyReset;
	// inputs
	keyInput lkey (left0, leftkey, clk, reset);
	keyInput rkey (right0, rightkey, clk, reset);
	downKeyInput dkey (down0, downkey | g, clk, reset, downKeyReset);
	keyInput skey (spin0, spinkey, clk, reset);
	// input filter and buffer
	userInput ui (left, right, down, spin, left0, right0, down0, spin0, clk, reset | inputReset);
	
	// tetrimino inputs
	logic [3:0][XSIZE-1:0] outX;
	logic [3:0][YSIZE-1:0] outY;
	logic [3:0][XSIZE-1:0] spinXOut;
	logic [3:0][YSIZE-1:0] spinYOut;
	logic [2:0] spinStateOut;
	logic activeOut;
	logic tleft, tright, tdown, tload;
	logic [3:0][XSIZE-1:0] inX;
	logic [3:0][YSIZE-1:0] inY;
	logic [3:0][XSIZE:0] spinXIn;
	logic [3:0][YSIZE:0] spinYIn;
	logic [2:0] spinStateIn;
	logic pieceReset;
	
	tetrimino #(XSIZE, YSIZE) tet 
	(outX, outY, spinXOut, spinYOut, spinStateOut, activeOut, 
		clk, reset | pieceReset, tleft, tright, tdown, tload, 
		inX, inY, spinXIn, spinYIn, spinStateIn);
	
	logic fixdone, destructed;
	logic fix;
	
	piece_locker #(WIDTH,HEIGHT,XSIZE,YSIZE) locker 
	(.matrixOut(redMatrix), .fixdone, .destructed, .clk, .reset, .inX(outX), .inY(outY), .fix);
	
	logic collision;
	logic collCalcDone;
	logic cleft, cright, cdown, cload;
	logic [3:0][XSIZE:0] cinX;
	logic [3:0][YSIZE:0] cinY;
	logic check;
	logic collReset;
	
	collision_checker #(WIDTH, HEIGHT, XSIZE, YSIZE) cc 
	(.out(collision), .done(collCalcDone), .clk, .reset(reset | collReset), 
	.matrixIn(redMatrix), .inX(cinX), .inY(cinY), .left(cleft), .right(cright), .down(cdown), .load(cload), .check);
	
	logic [1:0] newSpin;
	logic [3:0][XSIZE:0] spinnerXOut;
	logic [3:0][YSIZE:0] spinnerYOut;
	
	piece_spinner #(XSIZE, YSIZE) spinner 
	(.newSpin, .outX(spinnerXOut), .outY(spinnerYOut), .inX({{1'b0, outX[3]}, {1'b0, outX[2]}, {1'b0, outX[1]}, {1'b0, outX[0]}}), .inY({{1'b0, outY[3]}, {1'b0, outY[2]}, {1'b0, outY[1]}, {1'b0, outY[0]}}), 
	.spinX(spinXOut), .spinY(spinYOut), .spinState(spinStateOut));
	
	logic [31:0] rndm;
	logic [2:0] rndmPieceType;
	assign rndmPieceType = rndm[31:29];
	LFSR_32 rnd (rndm, clk, reset);
	
	logic [3:0][XSIZE:0] genXOut;
	logic [3:0][YSIZE:0] genYOut;
	logic [3:0][XSIZE:0] genXSpinOut;
	logic [3:0][YSIZE:0] genYSpinOut;
	
	piece_generator #(XSIZE, YSIZE) gen 
	(.outX(genXOut), .outY(genYOut), .spinX(genXSpinOut), .spinY(genYSpinOut), 
	.pieceType(rndmPieceType), .inX({1'b0, startX}), .inY({1'b0, startY}));
	
	piece_matrix #(WIDTH, HEIGHT, XSIZE, YSIZE) pm
	(.matrixOut(greenMatrix), .inX(outX), .inY(outY), .enable(activeOut));
	
	logic [20:0] score;
	
	always_comb begin
		tload = 1'b0;
		tleft = 1'b0;
		tright = 1'b0;
		tdown = 1'b0;
		inX = '0;
		inY = '0;
		spinXIn = '0;
		spinYIn = '0;
		spinStateIn = '0;
		fix = 1'b0;
		check = 1'b0;
		cleft = 1'b0; 
		cright = 1'b0; 
		cdown = 1'b0; 
		cload = 1'b0;
		inputReset = 1'b1;
		cinX = {{1'b0, outX[3]}, {1'b0, outX[2]}, {1'b0, outX[1]}, {1'b0, outX[0]}};
		cinY = {{1'b0, outY[3]}, {1'b0, outY[2]}, {1'b0, outY[1]}, {1'b0, outY[0]}};
		score = scoreOut;
		pieceReset = 1'b0;
		collReset = 1'b0;
		downKeyReset = 1'b0;
		case(ps)
			4'b0000: begin // generate new piece
				tload = 1'b1;
				inX = {genXOut[3][XSIZE-1], genXOut[2][XSIZE-1], genXOut[1][XSIZE-1], genXOut[0][XSIZE-1]};
				inY = {genYOut[3][XSIZE-1], genYOut[2][XSIZE-1], genYOut[1][XSIZE-1], genYOut[0][XSIZE-1]};
				spinXIn = genXSpinOut;
				spinYIn = genYSpinOut;
				spinStateIn = 2'b00;
				ns = 3'b001;
			end
			4'b0001: begin // new piece loaded
			// start collision check of new piece
				check = 1'b1;
				ns = 3'b010;
			end
			4'b0010: begin 
				ns = 3'b010;
				if(collCalcDone)
					ns = 3'b011;
			end
			4'b0011: begin // check collision result for new piece
				collReset = 1'b1; // calc done reset collision checker at next clock
				if(collision)
					ns = 4'b1111; // gameover state
				else
					ns = 4'b0100;
			end
			4'b0100: begin // need input buffer
				// input check stage
				ns = 4'b0100;
				if(down) begin
					check = 1'b1;
					//cdown = 1'b1;
					ns = 4'b0101;
				end else if (left) begin
					//cleft = 1'b1;
					check = 1'b1;
					ns = 4'b0101;
				end else if (right) begin
					//cright = 1'b1;
					check = 1'b1;
					ns = 4'b0101;
				end else if (spin) begin
					cinX = spinnerXOut;
					cinY = spinnerYOut;
					check = 1'b1;
					ns = 4'b0101;
				end
			end
			4'b0101: begin
				ns = 4'b0101; // wait for collision calc
				if(down) begin
					cdown = 1'b1;
				end else if (left) begin
					cleft = 1'b1;
				end else if (right) begin
					cright = 1'b1;
				end else if (spin) begin
					cinX = spinnerXOut;
					cinY = spinnerYOut;
				end
				if(collCalcDone)
					ns = 4'b0110;
			end
			4'b0110: begin // check result of input collision check
				collReset = 1'b1;
				inputReset = 1'b1;
				ns = 4'b0100;
				if(collision & down) begin
					ns = 4'b0111;
					fix = 1'b1;
				end else begin // no collision
					if(down)
						tdown = 1'b1;
					else if (spin) begin
						tload = 1'b1;
						inX = {spinnerXOut[3][XSIZE-1], spinnerXOut[2][XSIZE-1], spinnerXOut[1][XSIZE-1], spinnerXOut[0][XSIZE-1]};
						inY = {spinnerYOut[3][XSIZE-1], spinnerYOut[2][XSIZE-1], spinnerYOut[1][XSIZE-1], spinnerYOut[0][XSIZE-1]};
						spinXIn = spinXOut;
						spinYIn = spinYOut;
						spinStateIn = newSpin;
					end else if (left) begin
						tleft = 1'b1;
					end else if (right) begin
						tright = 1'b1;
					end
				end
			end
			4'b0111: begin // fixing in place current active piece
				// wait for calc
				score = score + 20'd1;
				ns = 4'b0111;
				if(fixdone) begin
					downKeyReset = 1'b1;
					ns = 4'b0000;
					pieceReset = 1'b1;
					if(destructed)
						score = score + 20'd9;
				end
			end
			4'b1000: begin
				ns = 4'b1000;
			end
			default: ns = 4'hf; // for error checking
		endcase
	end
	
	always_ff @(posedge clk) begin
		if(reset) begin
			scoreOut <= '0;
			ps <= 4'h0;
		end else begin
			scoreOut <= score;
			ps <= ns;
		end
	end
endmodule 
