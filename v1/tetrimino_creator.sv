module tetrimino_creator(matrixOut,inType);
	output logic [7:0][7:0] matrixOut;
	input logic [2:0] inType;
	
	always_comb begin
		case(inType)
			3'b000: begin // None
				matrixOut[0] = 8'b00000000;
				matrixOut[1] = 8'b00000000;
				matrixOut[2] = 8'b00000000;
				matrixOut[3] = 8'b00000000;
				matrixOut[4] = 8'b00000000;
				matrixOut[5] = 8'b00000000;
				matrixOut[6] = 8'b00000000;
				matrixOut[7] = 8'b00000000;
				end
			3'b001: begin // L
				matrixOut[0] = 8'b00010000;
				matrixOut[1] = 8'b00010000;
				matrixOut[2] = 8'b00011000;
				matrixOut[3] = 8'b00000000;
				matrixOut[4] = 8'b00000000;
				matrixOut[5] = 8'b00000000;
				matrixOut[6] = 8'b00000000;
				matrixOut[7] = 8'b00000000;
				end
			3'b010: begin // O
				matrixOut[0] = 8'b00011000;
				matrixOut[1] = 8'b00011000;
				matrixOut[2] = 8'b00000000;
				matrixOut[3] = 8'b00000000;
				matrixOut[4] = 8'b00000000;
				matrixOut[5] = 8'b00000000;
				matrixOut[6] = 8'b00000000;
				matrixOut[7] = 8'b00000000;
				end
			3'b011: begin // S
				matrixOut[0] = 8'b00011000;
				matrixOut[1] = 8'b00110000;
				matrixOut[2] = 8'b00000000;
				matrixOut[3] = 8'b00000000;
				matrixOut[4] = 8'b00000000;
				matrixOut[5] = 8'b00000000;
				matrixOut[6] = 8'b00000000;
				matrixOut[7] = 8'b00000000;
				end
			3'b100: begin // T
				matrixOut[0] = 8'b00111000;
				matrixOut[1] = 8'b00010000;
				matrixOut[2] = 8'b00000000;
				matrixOut[3] = 8'b00000000;
				matrixOut[4] = 8'b00000000;
				matrixOut[5] = 8'b00000000;
				matrixOut[6] = 8'b00000000;
				matrixOut[7] = 8'b00000000;
				end
			3'b101: begin // Z
				matrixOut[0] = 8'b00110000;
				matrixOut[1] = 8'b00011000;
				matrixOut[2] = 8'b00000000;
				matrixOut[3] = 8'b00000000;
				matrixOut[4] = 8'b00000000;
				matrixOut[5] = 8'b00000000;
				matrixOut[6] = 8'b00000000;
				matrixOut[7] = 8'b00000000;
				end
			3'b110: begin // I
				matrixOut[0] = 8'b00001000;
				matrixOut[1] = 8'b00001000;
				matrixOut[2] = 8'b00001000;
				matrixOut[3] = 8'b00001000;
				matrixOut[4] = 8'b00000000;
				matrixOut[5] = 8'b00000000;
				matrixOut[6] = 8'b00000000;
				matrixOut[7] = 8'b00000000;
				end
			3'b111: begin // J
				matrixOut[0] = 8'b00001000;
				matrixOut[1] = 8'b00001000;
				matrixOut[2] = 8'b00011000;
				matrixOut[3] = 8'b00000000;
				matrixOut[4] = 8'b00000000;
				matrixOut[5] = 8'b00000000;
				matrixOut[6] = 8'b00000000;
				matrixOut[7] = 8'b00000000;
				end
		endcase
	end
endmodule 