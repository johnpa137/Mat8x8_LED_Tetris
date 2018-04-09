module matrix8x8_vs(out, matrixIn, x, y, value);
	output logic [7:0][7:0] out;
	input logic [7:0][7:0] matrixIn;
	input logic [2:0] x, y;
	input logic value;
	
	logic [7:0][7:0] matrixInter; // intermediate matrix
	logic [7:0] row;
	
	always_comb begin
		out = matrixInter;
		matrixInter = matrixIn;
		case(y)
			3'b000: row = matrixInter[0];
			3'b001: row = matrixInter[1];
			3'b010: row = matrixInter[2];
			3'b011: row = matrixInter[3];
			3'b100: row = matrixInter[4];
			3'b101: row = matrixInter[5];
			3'b110: row = matrixInter[6];
			3'b111: row = matrixInter[7];
		endcase
		case(x)
			3'b000: row[0] = value;
			3'b001: row[1] = value;
			3'b010: row[2] = value;
			3'b011: row[3] = value;
			3'b100: row[4] = value;
			3'b101: row[5] = value;
			3'b110: row[6] = value;
			3'b111: row[7] = value;
		endcase
	end
endmodule 