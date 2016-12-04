module Tank
(
		input 			Reset, frame_clk,
		input  [15:0]	keycode,
		input				up, down, left, right,
		output [9:0]	TankX, TankY, TankS_X, TankS_Y,
		output [2:0]	Direction
);

	logic [9:0] Tank_X_Pos, Tank_X_Motion, Tank_Y_Pos, Tank_Y_Motion, Tank_Size_X, Tank_Size_Y;
	logic [2:0] direction;

	parameter [9:0] X_Min=0;
	parameter [9:0] X_Max=639;
	parameter [9:0] Y_Min=0;
	parameter [9:0] Y_Max=479;
	parameter [9:0] Tank_X_Start=320;
	parameter [9:0] Tank_Y_Start=240;
	parameter [9:0] Tank_X_Step=5;
	parameter [9:0] Tank_Y_Step=5;

	assign Tank_Size_X = 32;
	assign Tank_Size_Y = 32;
	
	always_ff @ (posedge Reset or posedge frame_clk)
	begin
		if(Reset)
		begin
			Tank_X_Motion <= 10'd0;
			Tank_Y_Motion <= 10'd0;
			Tank_X_Pos <= Tank_X_Start;
			Tank_Y_Pos <= Tank_Y_Start;
			direction <= 2'b00;
		end
		else 
		begin
			case (keycode[7:0])
				8'h1a:	//W
				begin
						Tank_X_Motion <= 10'd0;
						Tank_Y_Motion <= (~ (Tank_Y_Step) + 1'b1);
						direction <= 3'b000;
				end
				8'h16:	//S
				begin
						Tank_X_Motion <= 10'd0;
						Tank_Y_Motion <= Tank_Y_Step;
						direction <= 3'b010;
				end
				8'h04:	//A
				begin
						Tank_X_Motion <= (~ (Tank_X_Step) + 1'b1);
						Tank_Y_Motion <= 10'd0;
						direction <= 3'b100;
				end
				8'h07:	//D
				begin
						Tank_X_Motion <= Tank_X_Step;
						Tank_Y_Motion <= 10'd0;
						direction <= 3'b110;
				end
				default:
				begin
						Tank_X_Motion <= 10'd0;
						Tank_Y_Motion <= 10'd0;
						direction <= direction;
				end
			endcase

			if (((Tank_Y_Pos + Tank_Size_Y) >= Y_Max) || down == 1'b0)
			begin
					Tank_X_Motion <= Tank_X_Motion;
					Tank_Y_Motion <= 10'd0;
					direction <= direction;
			end
			else if(((Tank_Y_Pos - Tank_Size_Y) <= Y_Min) || up == 1'b0)
			begin
					Tank_X_Motion <= Tank_X_Motion;
					Tank_Y_Motion <= 10'd0;
					direction <= direction;
			end
			if (((Tank_X_Pos + Tank_Size_X) >= X_Max) || right == 1'b0)
			begin
					Tank_X_Motion <= 10'd0;
					Tank_Y_Motion <= Tank_Y_Motion;
					direction <= direction;
			end
			else if(((Tank_X_Pos - Tank_Size_X) <= X_Min) || left == 1'b0)
			begin
					Tank_X_Motion <= 10'd0;
					Tank_Y_Motion <= Tank_Y_Motion;
					direction <= direction;
			end

			Tank_X_Pos <= (Tank_X_Pos + Tank_X_Motion);
			Tank_Y_Pos <= (Tank_Y_Pos + Tank_Y_Motion);
		end  
	end

    assign TankX = Tank_X_Pos;

    assign TankY = Tank_Y_Pos;

    assign TankS_X = Tank_Size_X;
 
	 assign TankS_Y = Tank_Size_Y;

	 assign Direction = direction;

	 
endmodule
