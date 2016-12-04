module BattleCity
(
		input					CLOCK_50,
		input  [3:0]		KEY,
		output [6:0]		HEX0, HEX1,
		//VGA Interface 
		output [7:0]		VGA_R,
								VGA_G,
								VGA_B,
		output        		VGA_CLK,
							   VGA_SYNC_N,
								VGA_BLANK_N,
								VGA_VS,
								VGA_HS,
		// CY7C67200 Interface
		inout  [15:0]  	OTG_DATA,
		output [1:0]  		OTG_ADDR,
		output        		OTG_CS_N,
								OTG_RD_N,
								OTG_WR_N,
								OTG_RST_N,
		input			 		OTG_INT,
		// SDRAM Interface for Nios II Software
		output [12:0] 		DRAM_ADDR,
		inout  [31:0]  	DRAM_DQ,
		output [1:0]  		DRAM_BA,
		output [3:0]  		DRAM_DQM,
		output			 	DRAM_RAS_N,
		output			 	DRAM_CAS_N,
		output			 	DRAM_CKE,
		output			 	DRAM_WE_N,
		output			 	DRAM_CS_N,
		output			 	DRAM_CLK
);
    
    logic Reset_h, vssig, Clk;
    logic [9:0] drawxsig, drawysig, ballxsig, ballysig, ballsizexsig, ballsizeysig;
	 logic [2:0] direction;
	 logic [15:0] keycode;
    assign VGA_VS = vssig;
	 assign Clk = CLOCK_50;
    assign {Reset_h}=~ (KEY[0]);	// The push buttons are active low
	
	 wire [1:0] hpi_addr;
	 wire [15:0] hpi_data_in, hpi_data_out;
	 wire hpi_r, hpi_w,hpi_cs;
	 
	 hpi_io_intf hpi_io_inst
	 (
			.from_sw_address(hpi_addr),
			.from_sw_data_in(hpi_data_in),
			.from_sw_data_out(hpi_data_out),
			.from_sw_r(hpi_r),
			.from_sw_w(hpi_w),
			.from_sw_cs(hpi_cs),
		 	.OTG_DATA(OTG_DATA),    
			.OTG_ADDR(OTG_ADDR),    
			.OTG_RD_N(OTG_RD_N),    
			.OTG_WR_N(OTG_WR_N),    
			.OTG_CS_N(OTG_CS_N),    
			.OTG_RST_N(OTG_RST_N),   
			.OTG_INT(OTG_INT),
			.Clk(Clk),
			.Reset(Reset_h)
	 );
	 
	 //The connections for nios_system might be named different depending on how you set up Qsys
	 nios_system nios_system
	 (
			.clk_clk(Clk),         
			.reset_reset_n(KEY[0]),   
			.sdram_wire_addr(DRAM_ADDR), 
			.sdram_wire_ba(DRAM_BA),   
			.sdram_wire_cas_n(DRAM_CAS_N),
			.sdram_wire_cke(DRAM_CKE),  
			.sdram_wire_cs_n(DRAM_CS_N), 
			.sdram_wire_dq(DRAM_DQ),   
			.sdram_wire_dqm(DRAM_DQM),  
			.sdram_wire_ras_n(DRAM_RAS_N),
			.sdram_wire_we_n(DRAM_WE_N), 
			.sdram_out_clk(DRAM_CLK),
			.keycode_export(keycode),  
			.otg_hpi_address_export(hpi_addr),
			.otg_hpi_data_in_port(hpi_data_in),
			.otg_hpi_data_out_port(hpi_data_out),
			.otg_hpi_cs_export(hpi_cs),
			.otg_hpi_r_export(hpi_r),
			.otg_hpi_w_export(hpi_w)
	 );
	
	//Fill in the connections for the rest of the modules 
	vga_controller vgasync_instance(.Clk, .Reset(Reset_h), .vs(vssig), .hs(VGA_HS), .pixel_clk(VGA_CLK), .blank(VGA_BLANK_N), .sync(VGA_SYNC_N), .DrawX(drawxsig), .DrawY(drawysig));
   
	Game_Controller game_instance(.*, .Reset(Reset_h), .frame_clk(vssig), .keycode, .DrawX(drawxsig), .DrawY(drawysig), .Red(VGA_R), .Green(VGA_G), .Blue(VGA_B));
  
	HexDriver hex_inst_0 (keycode[3:0], HEX0);
	HexDriver hex_inst_1 (keycode[7:4], HEX1);

endmodule
