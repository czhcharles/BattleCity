module Start_Page
(
		input  [511:0]	x,
		input  [447:0]	y,
		output [3:0]	data
);

	logic [3:0] mem [0:229375];

	initial
	begin
		 $readmemh("StartPage.txt", mem);
	end
	assign data = mem[x*512+y];

endmodule

module Tank_sprite
(
		input  [31:0]	x,
		input  [31:0]	y,
		input  [2:0]	
		Direction,
		output [3:0]	data
);

	logic [3:0] up1 [0:1024];
	logic [3:0] up2 [0:1024];
	logic [3:0] down1 [0:1024];
	logic [3:0] down2 [0:1024];
	logic [3:0] left1 [0:1024];
	logic [3:0] left2 [0:1024];
	logic [3:0] right1 [0:1024];
	logic [3:0] right2 [0:1024];

	initial
	begin
		 $readmemh("tank_yellow_up1.txt", up1);
		 $readmemh("tank_yellow_up2.txt", up2);
		 $readmemh("tank_yellow_down1.txt", down1);
		 $readmemh("tank_yellow_down2.txt", down2);
		 $readmemh("tank_yellow_left1.txt", left1);
		 $readmemh("tank_yellow_left2.txt", left2);
		 $readmemh("tank_yellow_right1.txt", right1);
		 $readmemh("tank_yellow_right2.txt", right2);
	end
	always_comb
	begin
		case(Direction)
			3'b000: data = up1[x*32+y];
			3'b001: data = up2[x*32+y];
			3'b010: data = down1[x*32+y];
			3'b011: data = down2[x*32+y];
			3'b100: data = left1[x*32+y];
			3'b101: data = left2[x*32+y];
			3'b110: data = right1[x*32+y];
			3'b111: data = right2[x*32+y];
		endcase
	end
	
module test
(
		input  [511:0]	x,
		input  [447:0]	y,
		output [3:0]	data
);

	logic [3:0] mem [0:229375];

	initial
	begin
		 $readmemh("StartPage.txt", mem);
	end
	assign data = mem[x*512+y];

endmodule

endmodule
