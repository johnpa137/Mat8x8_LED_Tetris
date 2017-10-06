module matrix8x8_vc(out, matrixIn, x, y);
	output logic out;
	input logic [7:0][7:0] matrixIn;
	input logic [2:0] x, y;
	
	logic [7:0] row;
	
	always_comb begin
		case(y)
			3'b000: row = matrixIn[0];
			3'b001: row = matrixIn[1];
			3'b010: row = matrixIn[2];
			3'b011: row = matrixIn[3];
			3'b100: row = matrixIn[4];
			3'b101: row = matrixIn[5];
			3'b110: row = matrixIn[6];
			3'b111: row = matrixIn[7];
		endcase
		case(x)
			3'b000: out = row[0];
			3'b001: out = row[1];
			3'b010: out = row[2];
			3'b011: out = row[3];
			3'b100: out = row[4];
			3'b101: out = row[5];
			3'b110: out = row[6];
			3'b111: out = row[7];
		endcase
	end
endmodule 