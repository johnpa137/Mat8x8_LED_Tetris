// changes 8x8 matrix into 4 3-bit x values and 4 3-bit y values
// clk needs to CLOCK_50 to be fast enough to do its job
// needs at minimum 64 clock cycles to complete
// needs to change logic currently diagonal
module tetrimino_encoder(outX, outY, done, matrixIn, clk, reset);
	output logic [3:0][2:0] outX;
	output logic [3:0][2:0] outY;
	output logic done; // indicates operation is done
	input logic [7:0][7:0] matrixIn;
	input logic clk, reset;
	// 8 columns
	logic [2:0] rowNow, rowNext;
	// 8 columns
	logic [2:0] colNow, colNext;
	// 4 blocks
	logic [1:0] blockNow, blockNext;
	
	logic [7:0] row;
	logic value;
	logic done1, done0;
	logic [3:0][2:0] outX0, outY0;
	logic [3:0][2:0] outX1, outY1;
	
	always_comb begin
		done = done1;
		done0 = done1;
		outX = outX1;
		outY = outY1;
		outX0 = outX1;
		outY0 = outX1;
		case(rowNow)
		3'd0: begin 
			row = matrixIn[0];
			rowNext = 3'd1;
		end
		3'd1: begin 
			row = matrixIn[1];
			rowNext = 3'd2;
		end
		3'd2: begin 
			row = matrixIn[2];
			rowNext = 3'd3;
		end
		3'd3: begin 
			row = matrixIn[3];
			rowNext = 3'd4;
		end
		3'd4: begin 
			row = matrixIn[4];
			rowNext = 3'd5;
		end
		3'd5: begin 
			row = matrixIn[5];
			rowNext = 3'd6;
		end
		3'd6: begin 
			row = matrixIn[6];
			rowNext = 3'd7;
		end
		3'd7: begin 
			row = matrixIn[7];
			rowNext = 3'd7;
		end
		endcase
		case(colNow)
		3'd0: begin 
			value = row[0];
			colNext = 3'd1;
		end
		3'd1: begin 
			value = row[1];
			colNext = 3'd2;
		end
		3'd2: begin 
			value = row[2];
			colNext = 3'd3;
		end
		3'd3: begin 
			value = row[3];
			colNext = 3'd4;
		end
		3'd4: begin 
			value = row[4];
			colNext = 3'd5;
		end
		3'd5: begin 
			value = row[5];
			colNext = 3'd6;
		end
		3'd6: begin 
			value = row[6];
			colNext = 3'd7;
		end
		3'd7: begin 
			value = row[7];
			colNext = 3'd7;
		end
		endcase
		case(blockNow)
		2'd0: begin
			outX0[0] = rowNow;
			outY0[0] = colNow;
			if(value) begin
				blockNext = 2'd1;
			end else begin
				blockNext = 2'd0;
			end
		end
		2'd1: begin
			outX0[1] = rowNow;
			outY0[1] = colNow;
			if(value) begin
				blockNext = 2'd2;
			end else begin
				blockNext = 2'd1;
			end
		end
		2'd2: begin
			outX0[2] = rowNow;
			outY0[2] = colNow;
			if(value) begin
				blockNext = 2'd3;
			end else begin
				blockNext = 2'd2;
			end
		end
		2'd3: begin
			outX0[3] = rowNow;
			outY0[3] = colNow;
			if(value & ~done) begin
				blockNext = 2'd3;
				done0 = 1'b1;
			end else begin
				blockNext = 2'd3;
			end
		end
		endcase
	end 
	
	always_ff @(posedge clk) begin
		if(reset) begin
			rowNow <= 3'd0;
			colNow <= 3'd0;
			blockNow <= 2'd0;
			outX1[0] <= 3'd0;
			outX1[1] <= 3'd0;
			outX1[2] <= 3'd0;
			outX1[3] <= 3'd0;
			outY1[0] <= 3'd0;
			outY1[1] <= 3'd0;
			outY1[2] <= 3'd0;
			outY1[3] <= 3'd0;
			done1 <= 1'b0;
		end else begin
			rowNow <= rowNext;
			colNow <= colNext;
			blockNow <= blockNext;
			outX1 <= outX0;
			outY1 <= outY0;
			done1 <= done0;
		end
	end
endmodule 