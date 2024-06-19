module debounce
  #(parameter min_delay_p = 4
    )
   (input [0:0] clk_i
   ,input [0:0] reset_i
   ,input [0:0] button_i
   ,output [0:0] button_o);

   logic [min_delay_p:0] min_l;
   logic [1 << $clog2(min_delay_p):0] max_l;

   always_ff @(posedge clk_i) begin
	   if (button_i) begin
		   min_l <= {min_l[min_delay_p-1:0], button_i};
		   max_l <= {max_l[(1<<$clog2(min_delay_p)) - 1:0], button_i};
	   end else begin
		   min_l <= {min_l[min_delay_p-1:0], 1'b0};
		   max_l <= {max_l[(1<<$clog2(min_delay_p)) - 1:0], 1'b0};
	   end
   end

   assign button_o = (&min_l) && (~(&max_l));
   
endmodule
