module  shell ( input Reset, frame_clk,
					input [9:0] TankX, TankY,
					input [2:0] direction,
               output [9:0]  ShellX, ShellY, ShellS_X, ShellS_Y,
					output [2:0]  Direction,
					output shell_flying,
					output shouldDisplay,
					input [15:0] keycode);
					
	logic [9:0] Shell_X_Pos, Shell_X_Motion, Shell_Y_Pos, Shell_Y_Motion,Shell_Size_X, Shell_Size_Y;
//	logic [2:0] direction;
					
	parameter [9:0] Shell_X_Center = TankX;  // Center position on the Tank center X
	parameter [9:0] Shell_Y_Center = TankY;  // Center position on the Tank center Y
	parameter [9:0] Shell_X_Min=0;       // Leftmost point on the X axis
	parameter [9:0] Shell_X_Max=639;     // Rightmost point on the X axis
	parameter [9:0] Shell_Y_Min=0;       // Topmost point on the Y axis
	parameter [9:0] Shell_Y_Max=479;     // Bottommost point on the Y axis
	parameter [9:0] Shell_X_Step=1;      // Step size on the X axis
	parameter [9:0] Shell_Y_Step=1;      // Step size on the Y axis
				
	assign Shell_Size_X = 8;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
	assign Shell_Size_Y = 16;

	logic Playing;			//Indicate that state is in playing, 
	logic shell_flying;	//Indicate that the shell has been fired, thus no change to current projectile
	
	parameter [7:0] FIRE_KEY = 8'h00;		//The fire key assignment, ##### TBD #########
	
	
	always_ff @ (posedge Reset or posedge frame_clk )
	begin: Move_Shell
		if (Reset)  // Asynchronous Reset
		begin 
			Shell_X_Motion <= 10'd0; //Shell_Y_Step;
			Shell_Y_Motion <= 10'd0; //Shell_X_Step;
			Shell_X_Pos <= Shell_X_Center;
			Shell_Y_Pos <= Shell_Y_Center;
			direction <= 2'b00;
			shell_flying = 1'b0;
			shouldDisplay = 1'b0;			//when reset should hide the shell
		end
		
		else 
		begin
			if (shell_flying == 1'b0)			//if the shell hasn't been fired
			begin
				if (keycode == FIRE_KEY) 		//if fire has been pressed
				begin
					Shell_X_Pos <= Shell_X_Center;		//reset shell's location before firing
					Shell_Y_Pos <= Shell_Y_Center;
					shell_flying <= 1'b1;		
					case (direction)				//direction is calculated from tank's direction
						2'b00:			//UP
						begin
							Shell_X_Motion <= 10'd0;
							Shell_Y_Motion <= (~ (Shell_Y_Step) + 1'b1);
						end
						2'b01:			//DOWN
						begin
							Shell_X_Motion <= 10'd0;
							Shell_Y_Motion <= Shell_Y_Step;
						end
						2'b10:			//LEFT
						begin
							Shell_X_Motion <= (~ (Shell_X_Step) + 1'b1);
							Shell_Y_Motion <= 10'd0;
						end
						2'b11:			//RIGHT
						begin
							Shell_X_Motion <= (~ (Shell_X_Step) + 1'b1);
							Shell_Y_Motion <= 10'd0;				
						end
						default:
						begin
							Shell_X_Motion <= Shell_X_Motion;
							Shell_Y_Motion <= Shell_Y_Motion;
						end
					endcase
				end
			end
			else 													//if shell is already flying
			begin													//maintain current motion
				Shell_X_Motion <= Shell_X_Motion;
				Shell_Y_Motion <= Shell_Y_Motion;				
			end
			
			//check boundry conditions
			if (((Shell_Y_Pos + Shell_Size_Y) >= Shell_Y_Max) || ((Shell_Y_Pos - Shell_Size_Y) <= Shell_Y_Min) || ((Shell_X_Pos + Shell_Size_X) >= Shell_X_Max) || ((Shell_X_Pos - Shell_Size_X) <= Shell_X_Min))
				begin
					Shell_Y_Motion <= 10'd0;  				//Reset the shell after hitting the sides	
					Shell_X_Motion <= 10'd0;
					shell_flying <= 1'b0;
					shouldDisplay <= 1'b0;
				end
				 
				Shell_Y_Pos <= (Shell_Y_Pos + Shell_Y_Motion);  // Update Shell position
				Shell_X_Pos <= (Shell_X_Pos + Shell_X_Motion);			
			
		end
end
					
					

					
endmodule