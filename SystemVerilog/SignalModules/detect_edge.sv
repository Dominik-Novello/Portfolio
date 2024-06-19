module detect_edge
   (input [0:0] clk_i
    // reset_i will go low at least one cycle before a button is pushed.
   ,input [0:0] reset_i
   ,input [0:0] button_i
    // Should go high for 1 cycle, after a positive edge
   ,output [0:0] button_o
    // Should go high for 1 cycle, after a negative edge
   ,output [0:0] unbutton_o
   );

   logic [1:0] previous_l;

   always_ff @(posedge clk_i, negedge clk_i) begin
	   if (reset_i) begin
		   previous_l <= {1'b0,1'b0};
	   end else begin
		   previous_l <= {previous_l[0],button_i};
	   end
   end

   assign button_o = previous_l[0] && ~previous_l[1];
   assign unbutton_o = ~previous_l[0] && previous_l[1];

endmodule
