module tetris_device(greenOut, redOut, clk, reset, left, right, down, spin);
	output logic [7:0][7:0] greenOut, redOut;
	input logic reset, left, right, down, spin;
	
	logic [7:0][7:0] activeLedMatrixOut, offLedMatrixOut, fixedLedMatrix, activeLedMatrix;
	logic [7:0] destructArray;
	logic enableDisplay, landed, fix;
	
	assign greenOut = activeLedMatrix;
	assign redOut = fixedLedMatrix;
	
	tetrimino_manager tm (.fix, .activeLedMatrixOut, .offLedMatrixOut, .destructArray, .enableDisplay, 
		.clk, .reset, .spin, 
		.fixedLedMatrixIn(fixedLedMatrix), .activeLedMatrixIn(activeLedMatrix), .landed, .fastClk);
	
	genvar i, j;
	generate
		for(i=0; i < 8; i++) begin : ledRows
			for(j=0; i < 8; i++) begin : ledCols
				if(i == 7 && j == 7)
					led_driver ld (.fixed(fixedLedMatrix[i][j]), 
										.active(activeLedMatrix[i][j]), 
										.landed, 
										.activate(activeLedMatrixOut[i][j]), 
										.fix, 
										.off(offLedMatrixOut[i][j]), 
										.destruct(destructArray[i]), 
										.gravity, 
										.clk, .reset, .upLedF(1'b1), .downLedF(fixedLedMatrix[i-1][j]), .upLedA(1'b0), .leftLedA(1'b0), .rightLedA(), 
										.left, .right, .down);
			end
		end
	endgenerate
	
endmodule 