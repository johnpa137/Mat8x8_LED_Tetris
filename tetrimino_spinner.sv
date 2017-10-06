// requires very fast clock to compute logic
// you did the wrong direction you idiot * directions have been corrected but you're still an idiot
// messed up transition between spins, fix later
module tetrimino_spinner(activeMatrixOut, newSpin, offMatrixOut, activeLedMatrixIn, fixedLedMatrixIn, spinType, clk, reset);
	output logic [7:0][7:0] activeMatrixOut;
	output logic [7:0][7:0] offMatrixOut;
	output logic [4:0] newSpin;
	input logic [7:0][7:0] activeLedMatrixIn, fixedLedMatrixIn;
	input logic [4:0] spinType;
	input logic clk, reset;
	
	logic [3:0][2:0] outX;
	logic [3:0][2:0] outY;
	logic [3:0][2:0] placeX, placeY;
	logic [4:0] spin, nextSpin, spinOut;
	
	logic [5:0][3:0] addends;
	logic value, setter;
	logic encodeDone, placerDone;
	logic [7:0][7:0] active1, active0, off1, off0;
	
	tetrimino_encoder te0 (.outX, .outY, .done(encodeDone), .matrixIn(activeLedMatrixIn), .clk, .reset);
	spinPlacer sp0 (.finished(placerDone), .spinOut, .offMatrix(off0), .activeMatrix(active0), .nextSpin, .clk, .reset, 
		.addends, .outX, .outY, .placeX, .placeY, .spinType, .encodeDone);
	
	logic [7:0][7:0] zeros;
	assign zeros[7] = 8'h0000;
	assign zeros[6] = 8'h0000;
	assign zeros[5] = 8'h0000;
	assign zeros[4] = 8'h0000;
	assign zeros[3] = 8'h0000;
	assign zeros[2] = 8'h0000;
	assign zeros[1] = 8'h0000;
	assign zeros[0] = 8'h0000;
	
	always_comb begin
		offMatrixOut = off1;
		activeMatrixOut = active1;
		active0 = active1;
		off0 = off1;
		spin = newSpin;
		addends[0] = 4'h0;
		addends[1] = 4'h0;
		addends[2] = 4'h0;
		addends[3] = 4'h0;
		addends[4] = 4'h0;
		addends[5] = 4'h0;
		placeX[0] = 3'b000;
		placeX[1] = 3'b000;
		placeX[2] = 3'b000;
		placeX[3] = 3'b000;
		placeY[0] = 3'b000;
		placeY[1] = 3'b000;
		placeY[2] = 3'b000;
		placeY[3] = 3'b000;
	if(~placerDone & encodeDone) begin
		spin = spinOut;
		case(spinType)
			5'd1: begin // L spin 0
				nextSpin = 5'd8;
				placeX[0] = outX[2];
				addends[0] = 4'h1;
				placeY[0] = outY[1];
				placeX[1] = outX[0];
				placeY[1] = outY[2];
				placeX[2] = outX[0];
				placeY[2] = outY[3];
				placeX[3] = outX[2];
				placeY[3] = outY[2];
			end
			5'd3: begin // S spin 0
				nextSpin = 5'd11;
				placeX[0] = outX[1];
				placeY[0] = outY[2];
				placeX[1] = outX[1];
				placeY[1] = outY[1];
				placeX[2] = outX[0];
				addends[4] = 4'hf; // -1
				placeY[2] = outY[0];
				placeX[3] = outX[0];
				placeY[3] = outY[0];
			end
			5'd4: begin // T spin 0
				nextSpin = 5'd12;
				placeX[0] = outX[3];
				placeY[0] = outY[3];
				placeX[1] = outX[2];
				placeY[1] = outY[2];
				placeX[2] = outX[1];
				placeY[2] = outY[1];
				addends[5] = 4'h1; // 1
				placeX[3] = outX[0];
				placeY[3] = outY[0];
			end
			5'd5: begin // Z spin 0
				nextSpin = 5'd15;
				placeX[0] = outX[2];
				placeY[0] = outY[2];
				placeX[1] = outX[3];
				placeY[1] = outY[0];
				placeX[2] = outX[3];
				placeY[2] = outY[0];
				addends[5] = 4'h1; // 1
				placeX[3] = outX[1];
				placeY[3] = outY[1];
			end
			5'd6: begin // I spin 0
				nextSpin = 5'd16;
				placeX[0] = outX[0];
				addends[0] = 4'hf; // -1
				placeY[0] = outY[1];
				placeX[1] = outX[0];
				addends[2] = 4'h1; // 1
				placeY[1] = outY[1];
				placeX[2] = outX[0];
				addends[4] = 4'h2; // 2
				placeY[2] = outY[1];
				placeX[3] = outX[1];
				placeY[3] = outY[1];
			end
			5'd7: begin // J spin 0
				nextSpin = 5'd17;
				placeX[0] = outX[1];
				placeY[0] = outY[2];
				placeX[1] = outX[0];
				addends[2] = 4'hf; // -1
				placeY[1] = outY[0];
				placeX[2] = outX[0];
				addends[4] = 4'hf; // -1
				placeY[2] = outY[2];
				placeX[3] = outX[2];
				placeY[3] = outY[2];
			end
			5'd8: begin // L spin 1
				nextSpin = 5'd9;
				placeX[0] = outX[2];
				placeY[0] = outY[3];
				placeX[1] = outX[1];
				placeY[1] = outY[3];
				placeX[2] = outX[1];
				placeY[2] = outY[0];
				addends[5] = 4'hf; // -1
				placeX[3] = outX[1];
				placeY[3] = outY[1];
			end
			5'd9: begin // L spin 2
				nextSpin = 5'd10;
				placeX[0] = outX[3];
				placeY[0] = outY[1];
				placeX[1] = outX[3];
				placeY[1] = outY[0];
				placeX[2] = outX[0];
				addends[4] = 4'hf; // -1
				placeY[2] = outY[1];
				placeX[3] = outX[1];
				placeY[3] = outY[1];
			end
			5'd10: begin // L spin 3
				nextSpin = 5'd1;
				placeX[0] = outX[1];
				placeY[0] = outY[0];
				placeX[1] = outX[2];
				placeY[1] = outY[0];
				placeX[2] = outX[2];
				placeY[2] = outY[1];
				addends[5] = 4'h1; // 1
				placeX[3] = outX[2];
				placeY[3] = outY[2];
			end
			5'd11: begin // S spin 1
				nextSpin = 5'd2;
				placeX[0] = outX[2];
				placeY[0] = outY[1];
				placeX[1] = outX[0];
				placeY[1] = outY[3];
				placeX[2] = outX[0];
				addends[4] = 4'hf; // -1
				placeY[2] = outY[3];
				placeX[3] = outX[1];
				placeY[3] = outY[1];
			end
			5'd12: begin // T spin 1
				nextSpin = 5'd13;
				placeX[0] = outX[2];
				placeY[0] = outY[2];
				placeX[1] = outX[0];
				placeY[1] = outY[0];
				placeX[2] = outX[0];
				addends[4] = 4'hf; // -1
				placeY[2] = outY[1];
				placeX[3] = outX[2];
				placeY[3] = outY[2];
			end
			5'd13: begin // T spin 2
				nextSpin = 5'd14;
				placeX[0] = outX[0];
				placeY[0] = outY[0];
				placeX[1] = outX[1];
				placeY[1] = outY[1];
				placeX[2] = outX[1];
				placeY[2] = outY[1];
				addends[5] = 4'h1; // 1
				placeX[3] = outX[2];
				placeY[3] = outY[2];
			end
			5'd14: begin // T spin 3
				nextSpin = 5'd4;
				placeX[0] = outX[1];
				placeY[0] = outY[1];
				placeX[1] = outX[3];
				placeY[1] = outY[3];
				placeX[2] = outX[0];
				addends[4] = 4'h1; // 1
				placeY[2] = outY[2];
				placeX[3] = outX[2];
				placeY[3] = outY[2];
			end
			5'd15: begin // Z spin 1
				nextSpin = 5'd5;
				placeX[0] = outX[1];
				placeY[0] = outY[1];
				placeX[1] = outX[3];
				placeY[1] = outY[3];
				placeX[2] = outX[1];
				addends[4] = 4'hf; // -1
				placeY[2] = outY[1];
				placeX[3] = outX[1];
				placeY[3] = outY[1];
			end
			5'd16: begin // I spin 1
				nextSpin = 5'd6;
				placeX[0] = outX[1];
				placeY[0] = outY[0];
				addends[1] = 4'hf; // -1
				placeX[1] = outX[1];
				placeY[1] = outY[0];
				addends[3] = 4'h1; // 1
				placeX[2] = outX[1];
				placeY[2] = outY[0];
				addends[5] = 4'h2; // 2
				placeX[3] = outX[1];
				placeY[3] = outY[0];
			end
			5'd17: begin // J spin 1
				nextSpin = 5'd18;
				placeX[0] = outX[2];
				placeY[0] = outY[0];
				placeX[1] = outX[2];
				placeY[1] = outY[1];
				addends[3] = 4'h1; // 1
				placeX[2] = outX[1];
				placeY[2] = outY[1];
				addends[5] = 4'h1; // 1
				placeX[3] = outX[2];
				placeY[3] = outY[2];
			end
			5'd18: begin // J spin 2
				nextSpin = 5'd19;
				placeX[0] = outX[2];
				placeY[0] = outY[1];
				placeX[1] = outX[0];
				addends[2] = 4'h1; // 1
				placeY[1] = outY[1];
				placeX[2] = outX[0];
				addends[4] = 4'h1; // 1
				placeY[2] = outY[2];
				placeX[3] = outX[1];
				placeY[3] = outY[1];
			end
			5'd19: begin // J spin 2
				nextSpin = 5'd7;
				placeX[0] = outX[2];
				placeY[0] = outY[1];
				placeX[1] = outX[0];
				addends[2] = 4'h1; // 1
				placeY[1] = outY[1];
				placeX[2] = outX[0];
				addends[4] = 4'h1; // 1
				placeY[2] = outY[2];
				placeX[3] = outX[1];
				placeY[3] = outY[1];
			end
		endcase
	end
	end
	
	always_ff @(posedge clk) begin
		if(reset) begin
			active1 = zeros;
			off1 = zeros;
			newSpin <= spinType;
		end else begin
			active1 <= active0;
			off1 <= off0;
			newSpin <= spin;
		end
	end
endmodule 