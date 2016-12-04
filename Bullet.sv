module Bullet
(
		input 			Reset, frame_clk,
		input  [9:0]	TankX, TankY, TankS_X, TankS_Y,
		input  [2:0]	Direction,
		input  [15:0]	keycode,
		output [9:0]	BulletX, BulletY, BulletS_X, BulletS_Y
);

	logic [9:0] Bullet_X_Pos, Bullet_X_Motion, Bullet_Y_Pos, Bullet_Y_Motion, Bullet_Size_X, Bullet_Size_Y;
	
	parameter [9:0] X_Min=0;
	parameter [9:0] X_Max=639;
	parameter [9:0] Y_Min=0;
	parameter [9:0] Y_Max=479;
	parameter [9:0] Bullet_X_Start=320;
	parameter [9:0] Bullet_Y_Start=240;
	parameter [9:0] Bullet_X_Step=5;
	parameter [9:0] Bullet_Y_Step=5;
	
	assign Bullet_Size_X = 8;
	assign Bullet_Size_Y = 16;
	
	always_ff @ (posedge Reset or posedge frame_clk )
	begin:
		if (Reset)
		begin
			Bullet_X_Motion <= 10'd0;
			Bullet_Y_Motion <= 10'd0;
			Bullet_X_Pos <= 10'd0;
			Bullet_Y_Pos <= 10'd0;
			direction <= 2'b00;
		end

		else 
		begin
			case (keycode)
				16'h000d:  //J
				begin
						Bullet_X_Motion <= 10'd0;
						Bullet_Y_Motion <= 10'd0;
						direction <= direction;
				end
				16'h0d1a:  //J + W
				begin
						Bullet_X_Motion <= 10'd0;
						Bullet_Y_Motion <= (~ (Bullet_Y_Step) + 1'b1);
						direction <= 2'b00;
				end
				16'h0d16:  //J + S
				begin
						Bullet_X_Motion <= 10'd0;
						Bullet_Y_Motion <= Bullet_Y_Step;
						direction <= 2'b01;
				end
				16'h0d04:  //J + A
				begin
						Bullet_X_Motion <= (~ (Bullet_X_Step) + 1'b1);
						Bullet_Y_Motion <= 10'd0;
						direction <= 2'b10;
				end
				16'h0d07:  //J + D
				begin
						Bullet_X_Motion <= Bullet_X_Step;
						Bullet_Y_Motion <= 10'd0;
						direction <= 2'b11;
				end
				16'h1a0d:  //W + J
				begin
						Bullet_X_Motion <= 10'd0;
						Bullet_Y_Motion <= (~ (Bullet_Y_Step) + 1'b1);
						direction <= 2'b00;
				end
				16'h160d:  //S + J
				begin
						Bullet_X_Motion <= 10'd0;
						Bullet_Y_Motion <= Bullet_Y_Step;
						direction <= 2'b01;
				end
				16'h040d:  //A + J
				begin
						Bullet_X_Motion <= (~ (Bullet_X_Step) + 1'b1);
						Bullet_Y_Motion <= 10'd0;
						direction <= 2'b10;
				end
				16'h070d:  //D + J
				begin
						Bullet_X_Motion <= Bullet_X_Step;
						Bullet_Y_Motion <= 10'd0;
						direction <= 2'b11;
				end
				default:
				begin
						Bullet_X_Motion <= Bullet_X_Motion;
						Bullet_Y_Motion <= Bullet_Y_Motion;
						direction <= direction;
				end
			endcase

			if ( ((Bullet_Y_Pos + Bullet_Size_Y) >= Bullet_Y_Max) )
			begin
					Bullet_X_Motion <= Bullet_X_Motion;
					Bullet_Y_Motion <= Bullet_Y_Motion;
					direction <= direction;
			end
			else if(((Bullet_Y_Pos - Bullet_Size_Y) <= Bullet_Y_Min))
			begin
					Bullet_X_Motion <= Bullet_X_Motion;
					Bullet_Y_Motion <= Bullet_Y_Motion;
					direction <= direction;
			end
			if ( ((Bullet_X_Pos + Bullet_Size_X) >= Bullet_X_Max) )
			begin
					Bullet_X_Motion <= Bullet_X_Motion;
					Bullet_Y_Motion <= Bullet_Y_Motion;
					direction <= direction;
			end
			else if(((Bullet_X_Pos - Bullet_Size_X) <= Bullet_X_Min))
			begin
					Bullet_X_Motion <= Bullet_X_Motion;
					Bullet_Y_Motion <= Bullet_Y_Motion;
					direction <= direction;
			end

			Bullet_X_Pos <= (Bullet_X_Pos + Bullet_X_Motion);
			Bullet_Y_Pos <= (Bullet_Y_Pos + Bullet_Y_Motion);
		end  
	end

    assign BulletX = Bullet_X_Pos;

    assign BulletY = Bullet_Y_Pos;

    assign BulletS_X = Bullet_Size_X;
 
	 assign BulletS_Y = Bullet_Size_Y;

	 assign Direction = direction;

	 
endmodule
