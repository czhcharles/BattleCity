module  color_mapper
(
		input  logic [9:0] 	TankX, TankY, DrawX, DrawY, TankS_X, TankS_Y,
		input  logic [2:0] 	Direction,
		output logic [7:0]  	Red, Green, Blue
);
    
	//start page
	logic start_on, tank_on;
	logic [511:0] start_x;
	logic [447:0] start_y;
	logic [3:0] start_data;
	parameter X_cord = 60;
	parameter Y_cord = 30;
	parameter X_size = 512;
	parameter Y_size = 448;
	
	Start_Page start(.x(start_x), .y(start_y), .data(start_data));
	
	logic [31:0] tank_x, tank_y;
	logic [3:0] tank_data;
	
	Tank_sprite tank(.x(tank_x), .y(tank_y), .Direction, .data(tank_data));
	
	always_comb
	begin:Shapes_on_proc
		if(DrawX >= X_cord && DrawX < X_cord + X_size && DrawY >= Y_cord && DrawY < Y_cord + Y_size)
		begin
			if(DrawX >= TankX && DrawX < TankX + TankS_X && DrawY >= TankY && DrawY < TankY + TankS_Y)
			begin
				start_on = 1'b0;
				tank_on = 1'b1;
				start_x = 512'b0;
				start_y = 448'b0;
				tank_x = DrawX - TankX;
				tank_y = DrawY - TankY;
			end
			else
			begin
				start_on = 1'b1;
				tank_on = 1'b0;
				start_x = DrawY - Y_cord;
				start_y = DrawX - X_cord;
				tank_x = 32'b0;
				tank_y = 32'b0;
			end
		end
		else
		begin
			start_on = 1'b0;
			tank_on = 1'b0;
			start_x = 512'b0;
			start_y = 448'b0;
			tank_x = 32'b0;
			tank_y = 32'b0;
		end
	end

   always_comb
   begin:RGB_Display
		if ((start_on == 1'b1) && start_data == 4'd1) 
      begin 
         Red = 8'hff; 
         Green = 8'hff;
         Blue = 8'hff;
      end
		else if ((start_on == 1'b1) && start_data == 4'd2) 
      begin 
         Red = 8'hbd; 
         Green = 8'h44;
         Blue = 8'h00;
      end
		else if ((tank_on == 1'b1) && start_data == 4'd1) 
      begin 
         Red = 8'hff; 
         Green = 8'hff;
         Blue = 8'hff;
      end
		else if ((tank_on == 1'b1) && start_data == 4'd2) 
      begin 
         Red = 8'he7; 
         Green = 8'he7;
         Blue = 8'h94;
      end
		else if ((tank_on == 1'b1) && start_data == 4'd3) 
      begin 
         Red = 8'he7; 
         Green = 8'h9c;
         Blue = 8'h21;
      end
		else if ((tank_on == 1'b1) && start_data == 4'd4) 
      begin 
         Red = 8'h6b; 
         Green = 8'h6b;
         Blue = 8'h00;
      end
      else 
      begin 
         Red = 8'h00; 
         Green = 8'h00;
         Blue = 8'h00;
      end    	  
	end 

endmodule
