module spinPlacer(finished, spinOut, offMatrix, activeMatrix, fixedMatrixIn, nextSpin, clk, reset, addends, outX, outY, placeX, placeY, spinType, encodeDone);
	output logic finished;
	output logic [7:0][7:0] offMatrix, activeMatrix;
	output logic [4:0] spinOut;
	input logic [4:0] nextSpin, spinType; // nextSpin id if spin is okay, and current spinType
	input logic [5:0][3:0] addends; // six addends for the adder
	input logic [7:0][7:0] fixedMatrixIn;
	input logic [3:0][2:0] outX, outY; // outputs of tetrimino encoder in the order of replacement
	input logic [3:0][2:0] placeX, placeY; // the order of replacement
	input logic encodeDone;
	input logic clk, reset;
	
	logic [7:0][7:0] zeros;
	
	assign zeros[7] = 8'h0000;
	assign zeros[6] = 8'h0000;
	assign zeros[5] = 8'h0000;
	assign zeros[4] = 8'h0000;
	assign zeros[3] = 8'h0000;
	assign zeros[2] = 8'h0000;
	assign zeros[1] = 8'h0000;
	assign zeros[0] = 8'h0000;
	
	logic [3:0] addend1, addend2, addend3, addend4;
	logic [3:0] sumX, sumY;
	logic value, setter;
	logic [2:0] matX, matY, matX1, matY1, matX2, matY2;
	logic [7:0][7:0] matrixIn2, matrixIn3, matrixOut1, matrixOut2;
	logic [1:0] blockNow, blockNext;
	logic done, done0;
	logic [7:0][7:0] active1, active0, off1, off0;
	logic [4:0] newSpin, spin;
	
	adder #(.WIDTH(4)) a0 (.sum(sumX), .overflow( ), .a(addend1), .b(addend2), .cin(1'b0));
	adder #(.WIDTH(4)) a1 (.sum(sumY), .overflow( ), .a(addend3), .b(addend4), .cin(1'b0));
	matrix8x8_vc mc0 (.out(value), .matrixIn(fixedMatrixIn), .x(matX), .y(matY));
	matrix8x8_vs ms0 (.out(matrixOut1), .matrixIn(matrixIn2), .x(matX2), .y(matY2), .value(setter));
	matrix8x8_vs ms1 (.out(matrixOut2), .matrixIn(matrixIn3), .x(matX1), .y(matY1), .value(setter));
	
	always_comb begin
		finished = done;
		matX = 3'b000;
		matY = 3'b000;
		matX1 = 3'b000;
		matY1 = 3'b000;
		matX2 = 3'b000;
		matY2 = 3'b000;
		addend1 = 4'd0;
		addend2 = 4'd0;
		addend3 = 4'd0;
		addend4 = 4'd0;
		offMatrix = off1;
		activeMatrix = active1;
		active0 = active1;
		off0 = off1;
		blockNext = blockNow;
		done0 = done;
		spinOut = newSpin;
		spin = newSpin;
		setter = 1'bx;
		if(~done & encodeDone) begin
			if(blockNext == 4'd0) begin
				addend1 = {1'b0, placeX[0]};
				addend2 = addends[0];
				addend3 = {1'b0, placeY[0]};
				addend4 = addends[1];
				if(sumX[3]) begin // negative sum out of bounds
					spin = spinType;
					off0 = zeros;
					active0 = zeros;
					done0 = 1'b1;
				end else if(sumY[3]) begin
					spin = spinType;
					off0 = zeros;
					active0 = zeros;
					done0 = 1'b1;
				end else begin
					matX = sumX[2:0];
					matY = sumY[2:0];
					if(value) begin // value is occupied by fixed block
						spin = spinType; // no change
						off0 = zeros;
						active0 = zeros;
						done0 = 1'b1;
					end else begin
						blockNext = 4'd1;
						matX1 = matX;
						matY1 = matY;
						matX2 = outX[0];
						matY2 = outY[0];
						setter = 1'b1;
						off0 = matrixOut1;
						active0 = matrixOut2;
						matrixIn2 = off1;
						matrixIn3 = active1;
					end
				end
			end else if(blockNext == 4'd1) begin
				addend1 = {1'b0, placeX[1]};
				addend2 = addends[2];
				addend3 = {1'b0, placeY[1]};
				addend4 = addends[3];
				if(sumX[3]) begin // negative sum out of bounds
					spin = spinType;
					off0 = zeros;
					active0 = zeros;
					done0 = 1'b1;
				end else if(sumY[3]) begin
					spin = spinType;
					off0 = zeros;
					active0 = zeros;
					done0 = 1'b1;
				end else begin
					matX = sumX[2:0];
					matY = sumY[2:0];
					if(value) begin // value is occupied by fixed block
						spin = spinType; // no change
						off0 = zeros;
						active0 = zeros;
						done0 = 1'b1;
					end else begin
						blockNext = 4'd2;
						matX1 = matX;
						matY1 = matY;
						matX2 = outX[1];
						matY2 = outY[1];
						setter = 1'b1;
						off0 = matrixOut1;
						active0 = matrixOut2;
						matrixIn2 = off1;
						matrixIn3 = active1;
					end
				end
			end else if (blockNext == 4'd2) begin
				addend1 = {1'b0, placeX[2]};
				addend2 = addends[4];
				addend3 = {1'b0, placeY[2]};
				addend4 = addends[5];
				if(sumX[3]) begin // negative sum out of bounds
					spin = spinType;
					off0 = zeros;
					active0 = zeros;
					done0 = 1'b1;
				end else if(sumY[3]) begin
					spin = spinType;
					off0 = zeros;
					active0 = zeros;
					done0 = 1'b1;
				end else begin
					matX = sumX[2:0];
					matY = sumY[2:0];
					if(value) begin // value is occupied by fixed block
						spin = spinType; // no change
						off0 = zeros;
						active0 = zeros;
						done0 = 1'b1;
					end else begin
						blockNext = 4'd3;
						matX1 = matX;
						matY1 = matY;
						matX2 = outX[1];
						matY2 = outY[1];
						setter = 1'b1;
						off0 = matrixOut1;
						active0 = matrixOut2;
						matrixIn2 = off1;
						matrixIn3 = active1;
					end
				end
			end else if(blockNext == 4'd3) begin
				spin = nextSpin;
				matX1 = placeX[3];
				matY1 = placeY[3];
				matX2 = outX[3];
				matY2 = outY[3];
				setter = 1'b1;
				off0 = matrixOut1;
				active0 = matrixOut2;
				matrixIn2 = off1;
				matrixIn3 = active1;
				done0 = 1'b1;
			end
		end
	end
	
	always_ff @(posedge clk) begin
		if(reset) begin
			blockNow <= 4'd0;
			done <= 1'b0;
			active1 = zeros;
			off1 = zeros;
			newSpin <= spinType;
		end else begin
			blockNow <= blockNext;
			done <= done0;
			active1 <= active0;
			off1 <= off0;
			newSpin <= spin;
		end
	end
endmodule 
