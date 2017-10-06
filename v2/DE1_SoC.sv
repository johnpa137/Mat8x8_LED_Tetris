// John Paul Aglubat Lab#2 EE271
// Top-level module that defines the I/Os for the DE-1 SoC board
module DE1_SoC (CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW, GPIO_0);
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	output logic [35:0] GPIO_0;
	input logic CLOCK_50;
	input logic [3:0] KEY;
	input logic [9:0] SW;
	
	logic [7:0] red_driver;
	assign {GPIO_0[22], GPIO_0[19], GPIO_0[16], GPIO_0[13], GPIO_0[10], GPIO_0[7], GPIO_0[4], GPIO_0[1]} = red_driver;
	logic [7:0] green_driver;
	assign {GPIO_0[23], GPIO_0[20], GPIO_0[17], GPIO_0[14], GPIO_0[11], GPIO_0[8], GPIO_0[5], GPIO_0[2]} = green_driver;
	logic [7:0] row_sink;
	assign {GPIO_0[21], GPIO_0[18], GPIO_0[15], GPIO_0[12], GPIO_0[9 ], GPIO_0[6], GPIO_0[3], GPIO_0[0]} = row_sink;
	
	// Default values, turns off the HEX displays
	// assign HEX0 = 7'b1111111;
	// assign HEX1 = 7'b1111111;
	// assign HEX2 = 7'b1111111;
	// assign HEX3 = 7'b1111111;
	// assign HEX4 = 7'b1111111;
	// assign HEX5 = 7'b1111111;
	
	logic [7:0][7:0] red_array;
	// assign red_array = '0;
	
	logic [7:0][7:0] green_array;
	
	logic [31:0] div_clk;
	parameter clk_763kHz = 15;
	clock_divider cd (.clk(CLOCK_50), .div_clk);
	
	logic [3:0][3-1:0] outX;
	logic [3:0][3-1:0] outY;
	logic [3:0][3:0] spinXOut;
	logic [3:0][3:0] spinYOut;
	logic [2:0] spinStateOut;
	logic activeOut;
	logic tleft, tright, tdown; 
	logic load;
	logic [3:0][3-1:0] inX;
	logic [3:0][3-1:0] inY;
	logic [3:0][3:0] spinXIn;
	logic [3:0][3:0] spinYIn;
	logic [2:0] spinStateIn;
	logic resetPiece;
	logic g;
	
	gravity #(10) grav (g, div_clk[15], SW[9]);
	
	tetrimino #(3,3) tet (.outX, .outY, .spinXOut, .spinYOut, .spinStateOut, .activeOut, .clk(div_clk[20]), .reset(SW[9] | resetPiece), .left(tleft), .right(tright), .down(tdown), .load, .inX, .inY, .spinXIn, .spinYIn, .spinStateIn);
	
	logic [3:0][3:0] outXI, outYI;
	logic [3:0][3:0] spinOutXI, spinOutYI;
	logic [3:0][3:0] spinnerX, spinnerY;
	logic [1:0] newSpin;
	logic [31:0] rndNum;
	logic [2:0] rndPiece;
	
	assign rndPiece = rndNum[31:29]
	LFSR_32 rng (.out(rndNum), .clk(div_clk[20]), .reset(SW[9]));
	
	piece_generator #(3,3) pg (.outX(outXI), .outY(outYI), .spinX(spinOutXI), .spinY(spinOutYI), .pieceType(rndPiece), .inX(3'd7), .inY(3'd7));
	piece_matrix #(8,8,3,3) pmg (.matrixOut(green_array), .inX(outX), .inY(outY), .enable(activeOut));
	piece_spinner #(3,3) psp (.newSpin(newSpin), .outX(spinnerX), .outY(spinnerY), 
	.inX({{1'b0, outX[3]}, {1'b0, outX[2]}, {1'b0, outX[1]}, {1'b0, outX[0]}}), 
	.inY({{1'b0, outY[3]}, {1'b0, outY[2]}, {1'b0, outY[1]}, {1'b0, outY[0]}}), 
	.spinX(spinXOut), .spinY(spinYOut), .spinState(spinStateOut));
	
	logic collision;
	logic collCalcDone;
	logic cleft, cright, cdown, cload;
	logic [3:0][3:0] cinX;
	logic [3:0][3:0] cinY;
	logic check;
	logic collReset;
	
	collision_checker #(8, 8, 3, 3) cc 
	(.out(collision), .done(collCalcDone), .clk(div_clk[20]), .reset(SW[9] | collReset), 
	.matrixIn(red_array), .inX(cinX), .inY(cinY), .left(cleft), .right(cright), .down(cdown), .load(cload), .check);
	
	// inputs
	logic left0, right0, down0, spin0;
	logic left, right, down, spin;
	
	logic inputReset;
	logic downKeyReset;
	// inputs
	keyInput lkey (left0, ~KEY[3], div_clk[15], SW[9]);
	keyInput rkey (right0, ~KEY[2], div_clk[15], SW[9]);
	downKeyInput dkey (down0, ~KEY[1] | g, div_clk[15], SW[9], downKeyReset);
	keyInput skey (spin0, ~KEY[0], div_clk[15], SW[9]);
	// input filter and buffer
	userInput ui (left, right, down, spin, left0, right0, down0, spin0, div_clk[15], SW[9] | inputReset);
	
	logic fixdone, destructed;
	logic fix;
	// logic [2:0] drowd;
	
	piece_locker #(8,8,3,3) locker 
	(.matrixOut(red_array), .fixdone, .destructed, .clk(div_clk[20]), .reset(SW[9]), .inX(outX), .inY(outY), .fix);
	
	logic [3:0] ps, ns; 
	
	logic [3:0] score1, scoreOut1;
	logic [3:0] score2, scoreOut2;
	logic l;
	
	seg7 s0 (scoreOut1, HEX0);
	seg7 s1 (scoreOut2, HEX1);
	
	always_comb begin
		load = 1'b0;
		LEDR[0] = down;
		LEDR[1] = div_clk[20];
		LEDR[9] = left;
		LEDR[8] = right;
		l = LEDR[4];
		inX = '0;
		inY = '0;
		spinXIn = '0;
		spinYIn = '0;
		spinStateIn = 2'd0;
		cleft = '0;
		cright = '0;
		cdown = '0;
		cload = '0;
		cinX = {{1'b0, outX[3]}, {1'b0, outX[2]}, {1'b0, outX[1]}, {1'b0, outX[0]}};
		cinY = {{1'b0, outY[3]}, {1'b0, outY[2]}, {1'b0, outY[1]}, {1'b0, outY[0]}};
		check = '0;
		collReset = '0;
		inputReset = '0;
		downKeyReset = '0;
		tleft = '0;
		tright = '0;
		tdown = '0;
		resetPiece = '0;
		fix = '0;
		HEX2 = 7'b1111111;
		HEX3 = 7'b1111111;
		HEX4 = 7'b1111111;
		HEX5 = 7'b1111111;
		score1 = scoreOut1;
		score2 = scoreOut2;
		case(ps)
			'd0: begin
				load = 1'b1;
				inX = {outXI[3][2:0], outXI[2][2:0], outXI[1][2:0], outXI[0][2:0]};
				inY = {outYI[3][2:0], outYI[2][2:0], outYI[1][2:0], outYI[0][2:0]};
				spinXIn = spinOutXI;
				spinYIn = spinOutYI;
				spinStateIn = 2'd0;
				check = 1'b1;
				cinX = outXI;
				cinY = outYI;
				ns = 'd6;
			end
			'd1: begin
				ns = 2'b01;
				if(down) begin
					check = 1'b1;
					ns = 'd2;
				end else if (left) begin
					check = 1'b1;
					ns = 'd2;
				end else if (right) begin
					check = 1'b1;
					ns = 'd2;
				end else if (spin) begin
					cinX = spinnerX;
					cinY = spinnerY;
					check = 1'b1;
					ns = 'd2;
				end
			end
			'd2: begin
				ns = 'd2;
				if(down) begin
					cdown = 1'b1;
				end else if (left) begin
					cleft = 1'b1;
				end else if (right) begin
					cright = 1'b1;
				end else if (spin) begin
					cinX = spinnerX;
					cinY = spinnerY;
				end
				if(collCalcDone) begin
					ns = 'd3;
				end
			end
			'd3: begin
				ns = 'd4;
				if(~collision) begin
					if(down) begin
						tdown = 1'b1;
					end else if (left) begin
						tleft = 1'b1;
					end else if (right) begin
						tright = 1'b1;
					end else if (spin) begin
						load = 1'b1;
						inX = {spinnerX[3][2:0], spinnerX[2][2:0], spinnerX[1][2:0], spinnerX[0][2:0]};
						inY = {spinnerY[3][2:0], spinnerY[2][2:0], spinnerY[1][2:0], spinnerY[0][2:0]};
						spinXIn = spinXOut;
						spinYIn = spinYOut;
						spinStateIn = newSpin;
					end 
				end else if(down) begin
					fix = 1'b1;
					resetPiece = 1'b1;
					ns = 'd5;
				end
			end
			'd4: begin
				collReset = 1'b1;
				inputReset = 1'b1;
				ns = 'd1;
			end
			'd5: begin
				ns = 'd5;
				if(fixdone & destructed) begin
					if(scoreOut1 != 4'd9) begin
						score1 = scoreOut1 + 4'd1;
					end else if(scoreOut2 != 4'd9) begin
						score2 = scoreOut2 + 4'd1;
						score1 = '0;
					end
					collReset = 1'b1;
					inputReset = 1'b1;
					downKeyReset = 1'b1;
					ns = 'd0;
				end else if(fixdone) begin
					collReset = 1'b1;
					inputReset = 1'b1;
					downKeyReset = 1'b1;
					ns = 'd0;
				end else if (destructed) begin
					if(scoreOut1 != 4'd9) begin
						score1 = scoreOut1 + 4'd1;
					end else if(scoreOut2 != 4'd9) begin
						score2 = scoreOut2 + 4'd1;
						score1 = '0;
					end
				end
			end
			'd6: begin
				ns = 'd6;
				if(collCalcDone)
					ns = 'd7;
			end
			'd7: begin
				ns = 'd4;
				if(collision)
					ns = 'd8;
			end
			'd8: begin // gameover
				ns = 'd8;
				resetPiece = 'b1;
				HEX2 = 7'b0000110;
				HEX3 = 7'b0010010;
				HEX4 = 7'b1000000;
				HEX5 = 7'b1000111;
			end
			default: ns = 'x;
		endcase
	end
	
	always_ff @(posedge div_clk[20]) begin
		if(SW[9]) begin
			ps <= '0;
			scoreOut1 <= '0;
			scoreOut2 <= '0;
			LEDR[4] <= '0;
		end
		else begin
			ps <= ns;
			scoreOut1 <= score1;
			scoreOut2 <= score2;
			LEDR[4] <= l;
		end
	end
	
	// led_matrix_driver lmd (.red_driver, .green_driver, .row_sink, .clk(CLOCK_50), .reset(SW[9]), .red_array, .green_array);
	led_matrix_driver lmd (.red_driver, .green_driver, .row_sink, .clk(div_clk[clk_763kHz]), .reset(SW[9]), .red_array, .green_array);
endmodule

module DE1_SoC_testbench();
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0] LEDR;
	logic [35:0] GPIO_0;
	logic CLOCK_50;
	logic [3:0] KEY;
	logic [9:0] SW;
	
	logic reset;
	assign SW[9] = reset;
	logic clk;
	assign CLOCK_50 = clk;
	
	DE1_SoC dut(.CLOCK_50, .HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .KEY, .LEDR, .SW, .GPIO_0);
	
	initial begin
		@(posedge clk); reset <= 1;
		@(posedge clk); reset <= 0;
		for(integer i = 0; i < 256; i++)
			@(posedge clk);  
		$stop;
	end

endmodule 