// stores the fixed led matrix
module piece_locker #(parameter WIDTH=8, parameter HEIGHT=8, parameter XSIZE=3, parameter YSIZE=3)
	(matrixOut, fixdone, destructed, clk, reset, inX, inY, fix);
	output logic [HEIGHT-1:0][WIDTH-1:0] matrixOut;
	output logic fixdone, destructed;
	input logic [3:0][XSIZE-1:0] inX;
	input logic [3:0][YSIZE-1:0] inY;
	input logic fix;
	input logic clk, reset;
	
	logic [HEIGHT-1:0][WIDTH-1:0] matrix, dmatrix;
	
	logic [YSIZE-1:0] destroyRow;
	// logic [HEIGHT-1:0][YSIZE-1:0] destructIndices;
	// logic [HEIGHT-1:0] rows;
	logic destruct, destructTriggered;
	
	// assign destruct = |rows;
	//assign destroyRow = |(destructIndices[HEIGHT-1:0]);
	
	genvar i, j;
	generate
	for(i = 0; i < HEIGHT; i++) begin : rowChecks
			// row_checker #(YSIZE) rc (rows[i], destructIndices[i], &(matrixOut[i]), i[YSIZE-1:0]);
			if(i == HEIGHT - 1)
				matrixRow #(WIDTH, YSIZE) dr (dmatrix[i], '0, matrixOut[i], destroyRow, i[YSIZE-1:0]);
			else
				matrixRow #(WIDTH, YSIZE) dr (dmatrix[i], matrixOut[i+1], matrixOut[i], destroyRow, i[YSIZE-1:0]);
		end
	endgenerate
	
	logic [1:0] ps, ns;
	logic [YSIZE-1:0] rowCheck;
	
	always_comb begin
		ns = ps;
		matrix = matrixOut;
		destructTriggered = destructed;
		rowCheck = destroyRow;
		fixdone = 1'b0;
		case(ps)
		'd0: begin
			fixdone = 1'b1;
			if(fix) begin
				fixdone = 1'b0;
				destructTriggered = 1'b0;
				matrix[inY[3]][inX[3]] = 1'b1;
				matrix[inY[2]][inX[2]] = 1'b1;
				matrix[inY[1]][inX[1]] = 1'b1;
				matrix[inY[0]][inX[0]] = 1'b1;
				ns = 'd1;
			end
		end
		'd1: begin
			destructTriggered = 1'b0;
			rowCheck = destroyRow + {{(YSIZE-1){1'b0}}, 1'b1};
			if(&matrixOut[destroyRow]) begin
				matrix = dmatrix;
				rowCheck = '0;
				destructTriggered = 1'b1;
			end
			if(&destroyRow) begin
				ns = 'd0;
				rowCheck = '0;
			end
			/*
			if(destruct) begin
				matrix[destroyRow] = '0;
				destructTriggered = 1'b1;
				ns = 'd2;
			end
		end
		'd2: begin 
			ns = 'd0;
			destructTriggered = 1'b1;
			matrix = dmatrix;
			if(destruct) begin
				ns = 'd1;
			end*/
		end
		
		default: ns = 'd0;
		endcase
	end
	
	always_ff @(posedge clk) begin
		if(reset) begin
			matrixOut <= '0;
			destructed <= 1'b0;
			destroyRow <= '0;
			ps <= '0;
		end else begin
			matrixOut <= matrix;
			destructed <= destructTriggered;
			destroyRow <= rowCheck;
			ps <= ns;
		end
	end
endmodule 

module row_checker #(parameter YSIZE=3)(out, indexOut, in, index);
	output logic out;
	output logic [YSIZE-1:0] indexOut;
	input logic [YSIZE-1:0] index;
	input logic in;
	
	always_comb begin
		indexOut = '0;
		out = 1'b0;
		if(in) begin
			indexOut = index;
			out = 1'b1;
		end
	end
endmodule 