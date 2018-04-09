// xsize and ysize are the bitsizes of the x and y coords
module tetrimino #(parameter XSIZE=3, parameter YSIZE=3)
(outX, outY, spinXOut, spinYOut, spinStateOut, activeOut, clk, reset, left, right, down, load, inX, inY, spinXIn, spinYIn, spinStateIn);
	output logic [3:0][XSIZE-1:0] outX;
	output logic [3:0][YSIZE-1:0] outY;
	output logic [3:0][XSIZE:0] spinXOut;
	output logic [3:0][YSIZE:0] spinYOut;
	output logic [2:0] spinStateOut;
	output logic activeOut;
	input logic left, right, down, load;
	input logic [3:0][XSIZE-1:0] inX;
	input logic [3:0][YSIZE-1:0] inY;
	input logic [3:0][XSIZE:0] spinXIn;
	input logic [3:0][YSIZE:0] spinYIn;
	input logic clk, reset;
	input logic [2:0] spinStateIn;
	
	logic [3:0][XSIZE-1:0] x;
	logic [3:0][YSIZE-1:0] y;
	logic [3:0][XSIZE:0] spinX;
	logic [3:0][YSIZE:0] spinY;
	logic [2:0] spinState;
	logic active;
	
	// adder values
	logic [3:0][XSIZE-1:0] sumX, aX, bX;
	logic [3:0][YSIZE-1:0] sumY, aY, bY;
	logic [3:0] cX, cY;
	
	genvar i;
	generate
		for(i = 0; i < 4; i++) begin : adders
			adder #(.WIDTH(XSIZE)) xAdder (.sum(sumX[i]), .overflow( ), .a(aX[i]), .b(bX[i]), .cin(cX[i]));
			adder #(.WIDTH(YSIZE)) yAdder (.sum(sumY[i]), .overflow( ), .a(aY[i]), .b(bY[i]), .cin(cY[i]));
		end
	endgenerate
	
	always_comb begin
		// registers
		x = outX;
		y = outY;
		active = activeOut;
		// adder values
		aX = {4*XSIZE{1'b0}};
		bX = {4*XSIZE{1'b0}};
		cX = {4{1'b0}};
		aY = {4*XSIZE{1'b0}};
		bY = {4*XSIZE{1'b0}};
		cY = {4{1'b0}};
		spinX = spinXOut;
		spinY = spinYOut;
		spinState = spinStateOut;
		if(load) begin
			x = inX;
			y = inY;
			spinX = spinXIn;
			spinY = spinYIn;
			active = 1'b1;
			spinState = spinStateIn;
		end else if(down) begin
			aY = outY;
			bY = {4*XSIZE{1'b1}}; // -1
			cY = {4{1'b0}}; // 
			y = sumY;
		end else if(left) begin
			aX = outX;
			bX = {4*XSIZE{1'b0}}; // 0
			cX = {4{1'b1}}; // adds 1
			x = sumX;
		end else if(right) begin
			aX = outX;
			bX = {4*XSIZE{1'b1}}; // -1
			cX = {4{1'b0}};
			x = sumX;
		end
	end

	always_ff @(posedge clk) begin
		if(reset) begin
			activeOut <= 1'b0;
			outX <= {4*XSIZE{1'b0}};
			outY <= {4*XSIZE{1'b0}};
			spinXOut <= '0;
			spinYOut <= '0;
			spinStateOut <= 2'b00;
		end else begin
			activeOut <= active;
			outX <= x;
			outY <= y;
			spinXOut <= spinX;
			spinYOut <= spinY;
			spinStateOut <= spinState;
		end
	end
endmodule 

module tetrimino_testbench();
	logic [3:0][2:0] outX;
	logic [3:0][2:0] outY;
	logic activeOut;
	// inputs
	logic left, right, down, load;
	logic [3:0][2:0] inX;
	logic [3:0][2:0] inY;
	logic clk, reset;
	
	// Set up the clock.
	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	// for 8x8 grid
	tetrimino #(3, 3) dut (outX, outY, activeOut, clk, reset, left, right, down, load, inX, inY);
	
	initial begin
		@(posedge clk); reset <= 1;
		@(posedge clk); reset <= 0; left <= 0; right <= 0; down <= 0; load <= 0; inX <= {12{1'b0}}; inY <= {12{1'b0}};
		@(posedge clk); inX <= {4{3'b101}}; inY <= {3'b000, 3'b001, 3'b010, 3'b011};
		@(posedge clk); load <= 1; 
		@(posedge clk); down <= 1;
		@(posedge clk); 
		@(posedge clk); 
		@(posedge clk); down <= 0; left <= 1;
		@(posedge clk); 
		@(posedge clk); left <= 0; right <= 1;
		@(posedge clk); 
		@(posedge clk); right <= 0;
		@(posedge clk); 
		@(posedge clk); 
		@(posedge clk); 
		@(posedge clk); 
		@(posedge clk); 
		@(posedge clk); 
		@(posedge clk); 
		@(posedge clk); 
		@(posedge clk); 
		$stop;
	end
endmodule

