module konami
   (input [0:0] clk_i
   ,input [0:0] reset_i
   ,input [0:0] up_i
   ,input [0:0] unup_i
   ,input [0:0] down_i
   ,input [0:0] undown_i
   ,input [0:0] left_i
   ,input [0:0] unleft_i
   ,input [0:0] right_i
   ,input [0:0] unright_i
   ,input [0:0] b_i
   ,input [0:0] unb_i
   ,input [0:0] a_i
   ,input [0:0] una_i
   ,input [0:0] start_i
   ,input [0:0] unstart_i
   ,output [0:0] cheat_code_unlocked_o);

   // Implement a state machine to recognize the Konami Code.
   // 
   //    https://en.wikipedia.org/wiki/Konami_Code
   //
   // The sequence is: UP UP DOWN DOWN LEFT RIGHT LEFT RIGHT B A START
   //
   // The solution must:
   // 
   //  * Use behavioral verilog, written in this file
   // 
   //  * Go to the intitial state when reset_i is one
   //
   //  * Go back to the initial state on the next input to the machine.
   //
   //  * Set cheat_code_unlocked_o to 1 when the sequence is recognized
   //
   typedef enum logic [3:0] {IDLE, UP1, UP2, DOWN1, DOWN2, LEFT1, RIGHT1, LEFT2, RIGHT2, BSTATE, ASTATE, DONE} imul_ctrl_stat;
   imul_ctrl_stat curr_state_r, next_state; 

   always_ff @(posedge clk_i) begin
	  if (reset_i) curr_state_r <= IDLE;
	  else curr_state_r <= next_state;
   end
 
   always_comb begin
         unique case(curr_state_r)
         	IDLE: begin
				next_state = IDLE;
				if(up_i) next_state = UP1;
				else next_state = IDLE;
	        end
			UP1: begin
				next_state = UP1;
				if(up_i) next_state = UP2;
				else if (down_i || left_i || right_i || b_i || a_i || start_i) next_state = IDLE;
				else next_state = UP1;
			end
			UP2: begin
				next_state = UP2;
				if(down_i) next_state = DOWN1;
				else if(up_i) next_state = UP2;
				else if(left_i || right_i || a_i || b_i || start_i) next_state = IDLE;
				else next_state = UP2;
			end
			DOWN1: begin
				next_state = DOWN1;
				if(down_i) next_state = DOWN2;
				else if(up_i) next_state = UP1;
				else if(left_i || right_i || a_i || b_i || start_i) next_state = IDLE;
				else next_state = DOWN1;
			end
			DOWN2: begin
				next_state = DOWN2;
				if(left_i) next_state = LEFT1;
				else if (up_i) next_state = UP1;
				else if (right_i || a_i || b_i || start_i) next_state = IDLE;
				else next_state = DOWN2;
			end
			LEFT1: begin
				next_state = LEFT1;
				if(right_i) next_state = RIGHT1;
				else if(up_i) next_state = UP1;
				else if(left_i || a_i || down_i || b_i || start_i) next_state = IDLE;
				else next_state = LEFT1;
			end
			RIGHT1: begin
				next_state = RIGHT1;
				if(left_i) next_state = LEFT2;
				else if(up_i) next_state = UP1;
				else if(right_i || a_i || down_i || b_i || start_i) next_state = IDLE;
				else next_state = RIGHT1;
			end
				LEFT2: begin
				next_state = LEFT2;
				if(right_i) next_state = RIGHT2;
				else if(up_i) next_state = UP1;
				else if(left_i || a_i || down_i || b_i || start_i) next_state = IDLE;
				else next_state = LEFT2;
			end
			RIGHT2: begin
				next_state = RIGHT2;
				if(b_i) next_state = BSTATE;
				else if(up_i) next_state = UP1;
				else if(left_i || right_i || a_i || down_i || start_i) next_state = IDLE;
				else next_state = RIGHT2;
			end
			BSTATE: begin
				next_state = BSTATE;
				if(a_i) next_state = ASTATE;
				else if (up_i) next_state = UP1;
				else if (left_i || right_i || down_i || b_i || start_i) next_state = IDLE;
				else next_state = BSTATE;
			end
			ASTATE: begin
				next_state = ASTATE;
				if(start_i) next_state = DONE;
				else if(up_i) next_state = UP1;
				else if(down_i || left_i || right_i || a_i || b_i) next_state = IDLE;
				else next_state = ASTATE;
			end
			DONE: begin
				next_state = DONE;
				if(up_i) next_state = UP1;
				else if (down_i || left_i || right_i || a_i || b_i || start_i || unup_i) next_state = IDLE;
				else next_state = DONE;
			end
			default: next_state = IDLE;
		endcase
 	end
 
 	assign cheat_code_unlocked_o = (next_state == DONE);


endmodule

