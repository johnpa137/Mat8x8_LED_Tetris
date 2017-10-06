module piece_placer #(parameter XSIZE=3, parameter YSIZE=3) (sumX, sumY, inX, bX, inY, bY);
	// adder values
	output logic [3:0][XSIZE-1:0] sumX; 
	input logic [3:0][XSIZE-1:0] bX;
	input logic [3:0][XSIZE-1:0] inX;
	output logic [3:0][YSIZE-1:0] sumY; 
	input logic [3:0][YSIZE-1:0] bY;
	input logic [3:0][YSIZE-1:0] inY;
	
	genvar i;
	generate
		for(i = 0; i < 4; i++) begin : adders
			adder #(.WIDTH(XSIZE)) xAdder (.sum(sumX[i]), .overflow( ), .a(inX[i]), .b(bX[i]), .cin( ));
			adder #(.WIDTH(YSIZE)) yAdder (.sum(sumY[i]), .overflow( ), .a(inY[i]), .b(bY[i]), .cin( ));
		end
	endgenerate
endmodule 