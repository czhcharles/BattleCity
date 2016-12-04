/*
Module to control the game state
*/
module game_state (	input  Reset, 
									 frame_clk, 
									 score,
									 playing,
									 readyToStart,
									 ready,
							input [7:0] key,
							output ready,
							output [10:0] total score,
							output gameover
)

enum logic [4:0]{Menu, Start, Playing, Dead, Won, GameOver} curr_state, next_state;

logic [10:0] score;
logic [5:0] numEnemies;
logic [2:0] HP;
logic scoring, hit;
logic _gameover;

						
always_ff @ (posedge Reset or posedge frame_clk  )
begin : Assign_Next_State
	if (Reset) 
		curr_state <= Menu;
	else 
		curr_state <= next_state;
end	


//Next State assignment
always_comb
begin
	next_state = curr_state;
	
	unique case (curr_state)
		Menu: 							//at the main menu
			if (ready)
				next_state = Start;
		Start: next_state = Playing;		//beginning of a new game
		Playing:									
		begin
			if (HP == 1'b0)					//If the player has lost all health, tank is destroyed
				next_state = Dead;
			if (numEnemies == 1'b0)			//If no more enemies, player won
				next_state = Won;
		end
		Won: next_state = GameOver;		//The player has won
		Dead: next_state = GameOver;		//The player tank is destroyed
		default: ;
	endcase
end


//Actions at each state
always_ff @ (posedge frame_clk)
begin
	
	case(curr_state)
		Menu: ;				//no action needed at menu
		Start:				//reset the game score and everything at start state
		begin
			score = 0;
			HP = 3;
		end
		Playing:				//score and HP keeping keeping
		begin
			if (scoring == 1'b1)				//If player has hit enemy tank
			begin
				score++;
				numEnemies--;
			end
			if (hit == 1'b1)					//If the player has been hit
				HP--;
		end
end






endmodule




