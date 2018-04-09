module piece_generator #(parameter XSIZE=3, parameter YSIZE=3) (outX, outY, spinX, spinY, pieceType, inX, inY);
	output logic [3:0][XSIZE:0] outX; // parent module should compare these to 
	output logic [3:0][YSIZE:0] outY; // maxX and maxY's
	output logic [3:0][XSIZE:0] spinX; // spin values added during zero spin state
	output logic [3:0][YSIZE:0] spinY; // these are interchanged depending on the spin state
	input logic [2:0] pieceType;
	input logic [XSIZE:0] inX; // coords on grid top left corner or the grid the piece occupies
	input logic [YSIZE:0] inY; // must unsigned integers
	// Ex. 0011 0X11
	//     0110 0110
	//     0000 0000
	//     0000 0000
	// X indicates top left corner which should be the value of inX and inY
	
	// adder values
	logic [3:0][XSIZE:0] bX;
	logic [3:0][YSIZE:0] bY;
	logic [3:0][XSIZE:0] aX;
	logic [3:0][YSIZE:0] aY;
	assign aX = {4{inX}};
	assign aY = {4{inY}};
	
	piece_placer #(XSIZE+1, YSIZE+1) placer (outX, outY, aX, bX, aY, bY);
	
	// pivot is always the third piece i.e. x[1] and y[1]
	always_comb begin
		spinX[3] = {(XSIZE+1){1'b0}}; 
		spinY[3] = {(YSIZE+1){1'b0}}; 
		spinX[2] = {(XSIZE+1){1'b0}}; 
		spinY[2] = {(YSIZE+1){1'b0}}; 
		spinX[1] = {(XSIZE+1){1'b0}}; // no spin movement on pivot
		spinY[1] = {(YSIZE+1){1'b0}}; 
		spinX[0] = {(XSIZE+1){1'b0}}; 
		spinY[0] = {(YSIZE+1){1'b0}}; 
		case(pieceType)
			3'd0: begin // T has double frequency
				bX[3] = {(XSIZE+1){1'b1}}; // 0X0
				bY[3] = {(YSIZE+1){1'b0}}; // 111
				spinX[3] = {(XSIZE+1){1'b1}}; // right
				spinY[3] = {(YSIZE+1){1'b1}}; // down
				bX[2] = {(XSIZE+1){1'b0}};
				bY[2] = {(YSIZE+1){1'b1}};
				spinX[2] = {(XSIZE+1){1'b1}}; // right
				spinY[2] = {{(YSIZE){1'b0}}, 1'b1}; // up
				bX[1] = {(XSIZE+1){1'b1}};
				bY[1] = {(YSIZE+1){1'b1}};
				bX[0] = {{(XSIZE){1'b1}}, 1'b0}; 
				bY[0] = {{(YSIZE){1'b1}}};
				spinX[0] = {{(XSIZE){1'b0}}, 1'b1}; // left
				spinY[0] = {(YSIZE+1){1'b1}}; // down
			end
			3'd1: begin // L Piece
				bX[3] = {(XSIZE+1){1'b0}};
				bY[3] = {(YSIZE+1){1'b0}};
				spinX[3] = {(XSIZE+1){1'b1}}; // right
				spinY[3] = {(YSIZE+1){1'b1}}; // down
				bX[2] = {(XSIZE+1){1'b0}};
				bY[2] = {(XSIZE+1){1'b1}};
				bX[1] = {(XSIZE+1){1'b0}};
				bY[1] = {{(YSIZE){1'b1}}, 1'b0};
				spinX[1] = {{(XSIZE){1'b0}}, 1'b1}; // left
				spinY[1] = {{(YSIZE){1'b0}}, 1'b1}; // up
				bX[0] = {(XSIZE+1){1'b1}};
				bY[0] = {{(XSIZE){1'b1}}, 1'b0};
				spinX[0] = {{(XSIZE-1){1'b0}}, 2'b10}; // 2-left
			end
			3'd2: begin // O piece
				bX[3] = {(XSIZE+1){1'b0}};
				bY[3] = {(YSIZE+1){1'b0}};
				bX[2] = {(XSIZE+1){1'b1}};
				bY[2] = {(YSIZE+1){1'b0}};
				bX[1] = {(XSIZE+1){1'b0}};
				bY[1] = {(YSIZE+1){1'b1}};
				bX[0] = {(XSIZE+1){1'b1}};
				bY[0] = {(YSIZE+1){1'b1}};
			end
			3'd3: begin // S piece
				bX[3] = {(XSIZE+1){1'b1}};
				bY[3] = {(YSIZE+1){1'b0}};
				spinX[3] = {(XSIZE+1){1'b1}}; // right
				spinY[3] = {(YSIZE+1){1'b1}}; // down
				bX[2] = {{(XSIZE){1'b1}}, 1'b0};
				bY[2] = {(YSIZE+1){1'b0}};
				spinY[2] = {{(YSIZE){1'b1}}, 1'b0}; // 2-down
				bX[1] = {(XSIZE+1){1'b1}};
				bY[1] = {(YSIZE+1){1'b1}};
				bX[0] = {(XSIZE+1){1'b0}};
				bY[0] = {(YSIZE+1){1'b1}};
				spinX[0] = {(XSIZE+1){1'b1}}; // right
				spinY[0] = {{(YSIZE){1'b0}}, 1'b1}; // up
			end
			3'd4: begin // T piece
				bX[3] = {(XSIZE+1){1'b1}}; // 0X0
				bY[3] = {(YSIZE+1){1'b0}}; // 111
				spinX[3] = {(XSIZE+1){1'b1}}; // right
				spinY[3] = {(YSIZE+1){1'b1}}; // down
				bX[2] = {(XSIZE+1){1'b0}};
				bY[2] = {(YSIZE+1){1'b1}};
				spinX[2] = {(XSIZE+1){1'b1}}; // right
				spinY[2] = {{(YSIZE){1'b0}}, 1'b1}; // up
				bX[1] = {(XSIZE+1){1'b1}};
				bY[1] = {(YSIZE+1){1'b1}};
				bX[0] = {{(XSIZE){1'b1}}, 1'b0}; 
				bY[0] = {{(YSIZE){1'b1}}};
				spinX[0] = {{(XSIZE){1'b0}}, 1'b1}; // left
				spinY[0] = {(YSIZE+1){1'b1}}; // down
			end
			3'd5: begin // Z piece
				bX[3] = {(XSIZE+1){1'b0}};
				bY[3] = {(YSIZE+1){1'b0}};
				spinX[3] = {{(XSIZE){1'b1}}, 1'b0}; // 2-right
				bX[2] = {(XSIZE+1){1'b1}};
				bY[2] = {(YSIZE+1){1'b0}};
				spinX[2] = {(XSIZE+1){1'b1}}; // right
				spinY[2] = {(YSIZE+1){1'b1}}; // down
				bX[1] = {(XSIZE+1){1'b1}};
				bY[1] = {(YSIZE+1){1'b1}};
				bX[0] = {{(XSIZE){1'b1}}, 1'b0};
				bY[0] = {(YSIZE+1){1'b1}};
				spinX[0] = {{(XSIZE){1'b0}}, 1'b1}; // left
				spinY[0] = {(YSIZE+1){1'b1}}; // down
			end
			3'd6: begin // I piece
				bX[3] = {(XSIZE+1){1'b0}};
				bY[3] = {(YSIZE+1){1'b0}};
				spinX[3] = {{(XSIZE){1'b1}}, 1'b0}; // 2-right
				spinY[3] = {{(YSIZE){1'b1}}, 1'b0}; // 2-down
				bX[2] = {(XSIZE+1){1'b0}};
				bY[2] = {(YSIZE+1){1'b1}};
				spinX[2] = {(XSIZE+1){1'b1}}; // right
				spinY[2] = {(YSIZE+1){1'b1}}; // down
				bX[1] = {(XSIZE+1){1'b0}};
				bY[1] = {{(YSIZE){1'b1}}, 1'b0};
				bX[0] = {(XSIZE+1){1'b0}};
				bY[0] = {{(YSIZE-1){1'b1}}, 2'b01};
				spinX[0] = {{(XSIZE){1'b0}}, 1'b1}; // left
				spinY[0] = {{(YSIZE){1'b0}}, 1'b1}; // up
			end
			3'd7: begin // J piece
				bX[3] = {(XSIZE+1){1'b1}};
				bY[3] = {(YSIZE+1){1'b0}};
				spinX[3] = {(XSIZE+1){1'b1}}; // right
				spinY[3] = {(YSIZE+1){1'b1}}; // down
				bX[2] = {(XSIZE+1){1'b1}};
				bY[2] = {(YSIZE+1){1'b1}};
				bX[1] = {(XSIZE+1){1'b1}};
				bY[1] = {{(YSIZE){1'b1}}, 1'b0};
				spinX[1] = {{(XSIZE){1'b0}}, 1'b1}; // left
				spinY[1] = {{(YSIZE){1'b0}}, 1'b1}; // up
				bX[0] = {(XSIZE+1){1'b0}};
				bY[0] = {{(YSIZE){1'b1}}, 1'b0};
				spinY[0] = {{(YSIZE-1){1'b0}}, 2'b10}; // 2-left
			end
		endcase
	end
endmodule 