module adder
  #(parameter width_p = 5)
  // You must fill in the bit widths of a_i, b_i and sum_o. a_i and
  // b_i must be width_p bits.
  (input [width_p-1:0] a_i
  ,input [width_p-1:0] b_i
  ,output [width_p:0] sum_o);

  logic [width_p-1:1] xor_l;
  logic [width_p-1:0] carry_l;
  //Half Adder
  assign sum_o[0] = (a_i[0] && ~b_i[0]) || (b_i[0] && ~a_i[0]);

  assign carry_l[0] = a_i[0] && b_i[0];

  //Half Adder
  //Full Adder Loop
  for (genvar i = 1; i < width_p; i++) begin
   assign xor_l[i] = (a_i[i] && ~b_i[i]) || (~a_i[i] && b_i[i]);

   assign carry_l[i] = (a_i[i] && b_i[i]) || (xor_l[i] && carry_l[i-1]);

   assign sum_o[i] = (xor_l[i] && ~carry_l[i-1]) || (~xor_l[i] && carry_l[i-1]);

  end
  assign sum_o[width_p] = carry_l[width_p-1];

endmodule
