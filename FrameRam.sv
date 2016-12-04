module  frameRAM
(
		input 			we, clk,
		input  [4:0] 	data_In,
		input  [512:0] wx, rx,
		input  [448:0]	wy, ry,
		output [4:0] 	data_Out
);

	logic [3:0] mem [0:229375];

	initial
	begin
		 $readmemh("StartPage.txt", mem);
	end
	
	always_ff @ (posedge Clk) begin
		if (we)
			mem[wx*512+wy] <= data_In;
		data_Out<= mem[rx*512+ry];
	end

endmodule
