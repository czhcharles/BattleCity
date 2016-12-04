module Game_State
(
		
)

	enum logic [6:0] {START, } state, next_state;
	
	logic [4:0] counter;
	always_ff @ (posedge clk, negedge reset_n) 
	begin
		if (reset_n == 1'b0) 
		begin
			state <= START;
			counter <= 5'd0;
		end 
		else
		begin
			state <= next_state;
			if ()
				counter <= counter + 1'b1;
			else
				counter <= 5'd0;
		end
	end

	always_comb
	begin
		next_state = state;
		case (state)
		begin
			START:
			begin
				if ()
					next_state = ;
			end
		
		end
	end
		