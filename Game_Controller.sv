module Game_Controller
(
		input				Reset, frame_clk,
		input  [15:0]	keycode,
		input  [9:0]	DrawX, DrawY,
		//output			,
		output [7:0]	Red, Green, Blue
		//output [:]		,
);

	logic up, down, left, right;
	assign up = 1'b1;
	assign down = 1'b1;
	assign left = 1'b1;
	assign right = 1'b1;
	logic [9:0] TankX, TankY, TankS_X, TankS_Y;
	logic [2:0] Direction;
	
	//Game_State State(.*, );
	
	//frameRAM ram(.*, .clk(), .data_In(), .wx(), .wy(), .rx(), .ry(), .data_Out());
	
	Tank player1(.*);
	
	color_mapper color_instance(.*);
/*
	always_comb
	begin
		
	end
*/

endmodule
