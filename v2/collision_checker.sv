// WIDTH AND HEIGHT are the dimensions of the grid and XSIZE and YSIZE and the bitsizes of the coordinates
// computation needs 2 clock cycles to complete after reset
module collision_checker #(parameter WIDTH=8, parameter HEIGHT=8, parameter XSIZE=3, parameter YSIZE=3) 
	(out, done, clk, reset, matrixIn, inX, inY, left, right, down, load, check);
	output logic out; // if there was a collisin or not
	output logic done; // if the computation is complete
	input logic [HEIGHT-1:0][WIDTH-1:0] matrixIn;
	input logic [3:0][XSIZE:0] inX;
	input logic [3:0][YSIZE:0] inY;
	input logic left, right, down, load;
	input logic clk, reset;
	input logic check;
	
	logic [3:0][XSIZE:0] outX;
	logic [3:0][YSIZE:0] outY;
	// inputs to tetrimino
	logic tleft, tright, tdown, tload;
	logic [1:0] ps, ns;
	
	logic [((2**(YSIZE))-1):0][((2**(XSIZE))-1):0] matrix;
	
	genvar i, j;
	generate
	for(i = 0; i < HEIGHT; i++) begin : rows
		for(j = 0; j < WIDTH; j++) begin : cols
			assign matrix[i][j] = matrixIn[i][j];
		end
	end
	endgenerate
	
	tetrimino #(XSIZE+1, YSIZE+1) t(.outX, .outY, .spinXOut( ), .spinYOut( ), .spinStateOut( ), .activeOut( ), 
		.clk, .reset, .left(tleft), 
		.right(tright), .down(tdown), .load(tload), .inX, .inY, .spinXIn('0), .spinYIn('0), .spinStateIn('0));
	
	always_comb begin
		out = (	matrix[outY[3][YSIZE-1:0]][outX[3][XSIZE-1:0]] | 
					matrix[outY[2][YSIZE-1:0]][outX[2][XSIZE-1:0]] | 
					matrix[outY[1][YSIZE-1:0]][outX[1][XSIZE-1:0]] | 
					matrix[outY[0][YSIZE-1:0]][outX[0][XSIZE-1:0]] |
					outY[3][XSIZE] | outX[3][YSIZE] | // out of bounds
					outY[2][XSIZE] | outX[2][YSIZE] | // out of bounds
					outY[1][XSIZE] | outX[1][YSIZE] | // out of bounds
					outY[0][XSIZE] | outX[0][YSIZE] // out of bounds
					);
		done = ps[1];
		ns = ps;
		tleft = 1'b0;
		tright = 1'b0;
		tdown = 1'b0;
		tload = 1'b0;
		case(ps)
			2'b00: begin
				tload = 1'b1;
				if(check)
					ns = 1'b1;
			end
			2'b01: begin // piece loaded in
				ns = 2'b1x;
				if(~load) begin
					if(left)
						tleft = 1'b1;
					else if(right)
						tright = 1'b1;
					else if(down) begin
						tdown = 1'b1;
					end
				end
			end
			default: ; // calculation done, wait for reset
		endcase
	end
	
	always_ff @(posedge clk) begin
		if(reset)
			ps <= 2'b00;
		else
			ps <= ns;
	end
endmodule 