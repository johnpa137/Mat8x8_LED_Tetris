module piece_matrix #(parameter WIDTH=8, parameter HEIGHT=8, parameter XSIZE=3, parameter YSIZE=3)
 (matrixOut, inX, inY, enable);
	output logic [HEIGHT-1:0][WIDTH-1:0] matrixOut;
	input logic [3:0][XSIZE-1:0] inX;
	input logic [3:0][YSIZE-1:0] inY;
	input logic enable;
	
	always_comb begin
		matrixOut = '0;
		if(enable) begin
			matrixOut[inY[3]][inX[3]] = 1'b1;
			matrixOut[inY[2]][inX[2]] = 1'b1;
			matrixOut[inY[1]][inX[1]] = 1'b1;
			matrixOut[inY[0]][inX[0]] = 1'b1;
		end
	end
endmodule
