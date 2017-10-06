module matrixRow #(parameter WIDTH=8, parameter YSIZE=3) (rowOut, rowUp, rowIn, destroyRow, row);
	output logic [WIDTH-1:0] rowOut;
	input logic [WIDTH-1:0] rowUp;
	input logic [WIDTH-1:0] rowIn;
	input logic [YSIZE-1:0] destroyRow;
	input logic [YSIZE-1:0] row;

	logic cmp;
	
	greaterThan #(YSIZE) comp (cmp, row, destroyRow);
	
	always_comb begin
		rowOut = rowIn;
		if(cmp)
			rowOut = rowUp;
	end
endmodule 