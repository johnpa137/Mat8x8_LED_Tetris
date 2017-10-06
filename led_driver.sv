module led_driver(fixed, active, landed, activate, fix, off, destruct, moveOkay, gravity, clk, reset, upLedF, downLedF, leftLedF, rightLedF, upLedA, leftLedA, rightLedA, left, right, down, moveLeft, moveRight, moveDown);
	// active leds are what's falling and controlled by player
	// fixed leds are placed leds
	output logic fixed; // sent to tetrimino_driver for fixed led matrix
	output logic active; // sent to tetrimino_driver for active led matrix
	output logic landed; // sent to tetrimino_driver to fix current active leds
	output logic moveOkay; // sent to tetrimino_driver to say that there's no obstructions for this led
	input logic activate; // sent by tetrimino_driver when it needs to create a new piece, individual
	input logic fix; // sent by the tetrimino_driver when landed is sent by one of the active leds, individual
	input logic off; // sent by the tetrimino_driver specifically for spin commands, individual
	input logic destruct; // sent by the tetrimino_driver when a row is completed, full row, this and all rows above should check above them if the leds above them are fixed or off
	input logic gravity; // clk by which the leds fall by
	input logic clk, reset; // clk that player controls follow, global reset for leds
	input logic upLedF, downLedF, leftLedF, rightLedF; // checks fixed leds for movement
	input logic upLedA, leftLedA, rightLedA; // check up led if active
	input logic left, right, down; // player controls
	input logic moveLeft, moveRight, moveDown; // movement input after check with tetrimino manager
	
	// 2'b00 off
	// 2'b01 activeOn, green
	// 2'b10 fixedOn, red
	logic [1:0] ps, ns;
	
	always_comb begin
		fixed = ps[1];
		active = ps[0];
		landed = 1'b0;
		ns = ps;
		moveOkay = 1'b1;
		case(ps)
		2'b00: begin
		if(activate | 
			(upLedA & moveDown) | 
			(leftLedA & moveRight) |
			(rightLedA & moveLeft))
			ns = 2'b01;
		if(destruct & upLedF)
			ns = 2'b10;
		end
		2'b01: begin
		if(fix)
			ns = 2'b10;
		else if((off & ~activate) | 
			(~upLedA & moveDown & ~downLedF) | 
			(~leftLedA & moveRight & ~rightLedF) |
			(~rightLedA & moveLeft & ~leftLedF))
			ns = 2'b00;
		if(~((~upLedA & (gravity | down) & ~downLedF) | 
			(~leftLedA & right & ~rightLedF) |
			(~rightLedA & left & ~leftLedF)))
			moveOkay = 1'b0;
		if((gravity | down) & downLedF)
			landed = 1'b1;
		end
		2'b10: begin
		if(destruct)
			ns = 2'b00;
		end
		endcase
	end
	
	always_ff @(posedge clk)
		if(reset)
			ps <= 2'b00;
		else 
			ps <= ns;
endmodule 