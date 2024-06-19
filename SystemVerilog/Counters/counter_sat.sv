module counter_sat
  #(parameter width_p = 4,
    // Students: Using lint_off/lint_on commands to avoid lint checks,
    // will result in 0 points for the lint grade.
    /* verilator lint_off WIDTHTRUNC */
    parameter [width_p-1:0] reset_val_p = '0,
    // sat_val will always be greater than reset_val_p, and less than (1<< (width_p - 1))
    parameter [width_p-1:0] sat_val_p = '0
    )
    /* verilator lint_on WIDTHTRUNC */
   (input [0:0] clk_i
   ,input [0:0] reset_i
   ,input [0:0] up_i
   ,input [0:0] down_i
   ,output [width_p-1:0] count_o);

   logic [width_p-1:0] countin_l;
   logic [width_p:0] countout_l;
   logic [width_p-1:0] add_l;
   logic [0:0] enable_l;

   assign add_l[0] = (up_i && ~down_i) || (down_i && ~up_i);
   assign enable_l = ((countin_l < sat_val_p) && up_i) || ((countin_l > 0) && down_i);

   for (genvar i = 1; i < width_p; i++) begin
	   assign add_l[i] = down_i && ~up_i;
   end

   adder
    #(width_p)
   adder_inst
    (.a_i(add_l)
    ,.b_i(countin_l)
    ,.sum_o(countout_l)
    );

   for (genvar j = 0; j < width_p; j++) begin
	   dff
	    #(reset_val_p[j])
	   dff_inst
	    (.clk_i(clk_i)
	    ,.reset_i(reset_i)
	    ,.d_i(countout_l[j])
	    ,.en_i(enable_l)
	    ,.q_o(countin_l[j])
	    );
   end

   assign count_o = countin_l;

endmodule
