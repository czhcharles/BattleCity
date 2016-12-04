module vga_controller
(
		input				Clk,
							Reset,
		output logic 	hs,
							vs,
							pixel_clk,
							blank,
							sync,
		output [9:0] 	DrawX,
							DrawY 
);
    
    // 800 horizontal pixels indexed 0 to 799
    // 525 vertical pixels indexed 0 to 524
    parameter [9:0] hpixels = 10'b1100011111;
    parameter [9:0] vlines = 10'b1000001100;
	 
	 // horizontal pixel and vertical line counters
    logic [9:0] hc, vc;
    logic clkdiv;
    
	 // signal indicates if ok to display color for a pixel
	 logic display;
	 
    //Disable Composite Sync
    assign sync = 1'b0;
     
	//This cuts the 50 Mhz clock in half to generate a 25 MHz pixel clock  
    always_ff @ (posedge Clk or posedge Reset )
    begin 
        if (Reset) 
            clkdiv <= 1'b0;
        else 
            clkdiv <= ~ (clkdiv);
    end
   
	//Runs the horizontal counter  when it resets vertical counter is incremented
   always_ff @ (posedge clkdiv or posedge Reset )
	begin: counter_proc
		  if ( Reset ) 
			begin 
				 hc <= 10'b0000000000;
				 vc <= 10'b0000000000;
			end
				
		  else 
			 if ( hc == hpixels )  //If hc has reached the end of pixel count
			  begin 
					hc <= 10'b0000000000;
					if ( vc == vlines )   //if vc has reached end of line count
						 vc <= 10'b0000000000;
					else 
						 vc <= (vc + 1'b1);
			  end
			 else 
				  hc <= (hc + 1'b1);  //no statement about vc, implied vc <= vc;
	 end 
   
    assign DrawX = hc;
    assign DrawY = vc;
   
	 //horizontal sync pulse is 96 pixels long at pixels 656-752
    //(signal is registered to ensure clean output waveform)
    always_ff @ (posedge Reset or posedge clkdiv )
    begin : hsync_proc
        if ( Reset ) 
            hs <= 1'b0;
        else  
            if ((((hc + 1) >= 10'b1010010000) & ((hc + 1) < 10'b1011110000))) 
                hs <= 1'b0;
            else 
				    hs <= 1'b1;
    end
	 
    //vertical sync pulse is 2 lines(800 pixels) long at line 490-491
    //(signal is registered to ensure clean output waveform)
    always_ff @ (posedge Reset or posedge clkdiv )
    begin : vsync_proc
        if ( Reset ) 
           vs <= 1'b0;
        else 
            if ( ((vc + 1) == 9'b111101010) | ((vc + 1) == 9'b111101011) ) 
			       vs <= 1'b0;
            else 
			       vs <= 1'b1;
    end
       
    //only display pixels between horizontal 0-639 and vertical 0-479 (640x480)
    //(This signal is registered within the DAC chip, so we can leave it as pure combinational logic here)    
    always_comb
    begin 
        if ( (hc >= 10'b1010000000) | (vc >= 10'b0111100000) ) 
            display = 1'b0;
        else 
            display = 1'b1;
    end 
   
    assign blank = display;
    assign pixel_clk = clkdiv;
    

endmodule
