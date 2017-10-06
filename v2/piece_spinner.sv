module piece_spinner #(parameter XSIZE=3, parameter YSIZE=3) 
(newSpin, outX, outY, inX, inY, spinX, spinY, spinState);
	output logic [3:0][XSIZE:0] outX; // extra bit is for negative check for parent module
	output logic [3:0][YSIZE:0] outY; // in case the new coords go out of bounds during subtraction
	output logic [1:0] newSpin;
	input logic [3:0][XSIZE:0] inX;
	input logic [3:0][YSIZE:0] inY;
	input logic [3:0][XSIZE:0] spinX;
	input logic [3:0][YSIZE:0] spinY;
	input logic [1:0] spinState; // current spin of the module
	
	// adder values
	logic [3:0][XSIZE:0] bX;
	logic [3:0][YSIZE:0] bY;
	logic [3:0][XSIZE:0] n_spinX;
	logic [3:0][YSIZE:0] n_spinY;
	
	genvar i;
	generate
	for(i = 0; i < 4; i++) begin : negators
		negate #(XSIZE+1) negX (n_spinX[i], spinX[i]);
		negate #(YSIZE+1) negY (n_spinY[i], spinY[i]);
	end
	endgenerate
	
	piece_placer #(XSIZE+1, YSIZE+1) placer (.sumX(outX), .sumY(outY), .inX, .bX, .inY, .bY);
	
	always_comb begin
		case(spinState)
		2'b00: begin // Ex. 2-right, down
		newSpin = 2'b01;
		bX[3] = spinX[3];
		bY[3] = spinY[3];
		bX[2] = spinX[2];
		bY[2] = spinY[2];
		bX[1] = spinX[1];
		bY[1] = spinY[1];
		bX[0] = spinX[0];
		bY[0] = spinY[0];
		end
		2'b01: begin // Ex. 2-down, left
		newSpin = 2'b10;
		bX[3] = n_spinY[3];
		bY[3] = spinX[3];
		bX[2] = n_spinY[2];
		bY[2] = spinX[2];
		bX[1] = n_spinY[1];
		bY[1] = spinX[1];
		bX[0] = n_spinY[0];
		bY[0] = spinX[0];
		end
		2'b10: begin // Ex. 2-left, up
		newSpin = 2'b11;
		bX[3] = n_spinX[3];
		bY[3] = n_spinY[3];
		bX[2] = n_spinX[2];
		bY[2] = n_spinY[2];
		bX[1] = n_spinX[1];
		bY[1] = n_spinY[1];
		bX[0] = n_spinX[0];
		bY[0] = n_spinY[0];
		end
		2'b11: begin // Ex. 2-up, right
		newSpin = 2'b00;
		bX[3] = spinY[3];
		bY[3] = n_spinX[3];
		bX[2] = spinY[2];
		bY[2] = n_spinX[2];
		bX[1] = spinY[1];
		bY[1] = n_spinX[1];
		bX[0] = spinY[0];
		bY[0] = n_spinX[0];
		end
		endcase
	end
endmodule 