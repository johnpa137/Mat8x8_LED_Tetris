// converts 8 3-bit numbers to 2 8-bit numbers
module tetrimino_locator(matrixOut, inX3, inX2, inX1, inX0, inY3, inY2, inY1, inY0);
	output logic [7:0][7:0] matrixOut;
	input logic [2:0] inX3, inX2, inX1, inX0, inY3, inY2, inY1, inY0;
	
	logic [7:0] outX3, outX2, outX1, outX0, outY3, outY2, outY1, outY0;
	
	decoder3_7 dx3 (.out(outX3), .in(inX3));
	decoder3_7 dx2 (.out(outX2), .in(inX2));
	decoder3_7 dx1 (.out(outX1), .in(inX1));
	decoder3_7 dx0 (.out(outX0), .in(inX0));
	
	always_comb begin
		matrixOut[0] = 8'h00;
		matrixOut[1] = 8'h00;
		matrixOut[2] = 8'h00;
		matrixOut[3] = 8'h00;
		matrixOut[4] = 8'h00;
		matrixOut[5] = 8'h00;
		matrixOut[6] = 8'h00;
		matrixOut[7] = 8'h00;
		case(inY3)
			3'b000: matrixOut[0] = outX3;
			3'b001: matrixOut[1] = outX3;
			3'b010: matrixOut[2] = outX3;
			3'b011: matrixOut[3] = outX3;
			3'b100: matrixOut[4] = outX3;
			3'b101: matrixOut[5] = outX3;
			3'b110: matrixOut[6] = outX3;
			3'b111: matrixOut[7] = outX3;
		endcase
		case(inY2)
			3'b000: matrixOut[0] = matrixOut[0] | outX2;
			3'b001: matrixOut[1] = matrixOut[1] | outX2;
			3'b010: matrixOut[2] = matrixOut[2] | outX2;
			3'b011: matrixOut[3] = matrixOut[3] | outX2;
			3'b100: matrixOut[4] = matrixOut[4] | outX2;
			3'b101: matrixOut[5] = matrixOut[5] | outX2;
			3'b110: matrixOut[6] = matrixOut[6] | outX2;
			3'b111: matrixOut[7] = matrixOut[7] | outX2;
		endcase
		case(inY1)
			3'b000: matrixOut[0] = matrixOut[0] | outX1;
			3'b001: matrixOut[1] = matrixOut[1] | outX1;
			3'b010: matrixOut[2] = matrixOut[2] | outX1;
			3'b011: matrixOut[3] = matrixOut[3] | outX1;
			3'b100: matrixOut[4] = matrixOut[4] | outX1;
			3'b101: matrixOut[5] = matrixOut[5] | outX1;
			3'b110: matrixOut[6] = matrixOut[6] | outX1;
			3'b111: matrixOut[7] = matrixOut[7] | outX1;
		endcase
		case(inY0)
			3'b000: matrixOut[0] = matrixOut[0] | outX0;
			3'b001: matrixOut[1] = matrixOut[1] | outX0;
			3'b010: matrixOut[2] = matrixOut[2] | outX0;
			3'b011: matrixOut[3] = matrixOut[3] | outX0;
			3'b100: matrixOut[4] = matrixOut[4] | outX0;
			3'b101: matrixOut[5] = matrixOut[5] | outX0;
			3'b110: matrixOut[6] = matrixOut[6] | outX0;
			3'b111: matrixOut[7] = matrixOut[7] | outX0;
		endcase
	end
endmodule 