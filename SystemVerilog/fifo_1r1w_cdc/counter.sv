module counter
  #(parameter width_p = 4,
    // Students: Using lint_off/lint_on commands to avoid lint checks,
    // will result in 0 points for the lint grade.
    /* verilator lint_off WIDTHTRUNC */
    parameter [width_p-1:0] reset_val_p = '0)
    /* verilator lint_on WIDTHTRUNC */
   (input [0:0] clk_i
   ,input [0:0] reset_i
   ,input [0:0] up_i
   ,input [0:0] down_i
   ,output [width_p-1:0] count_o);

   logic [width_p-1:0] countin_l;
   logic [width_p:0] countout_l;
   logic [width_p-1:0] add_l;
   
   assign add_l[0] = (up_i && ~down_i) || (down_i && ~up_i);
  
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
      ,.en_i(1'b1)
      ,.q_o(countin_l[j])
      );
    end

    assign count_o = countin_l;   
endmodule
