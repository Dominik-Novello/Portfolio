module half_add
  (input [0:0] a_i
  ,input [0:0] b_i
  ,output [0:0] carry_o
  ,output [0:0] sum_o);

  wire [0:0] carry_nand_w;
  wire [0:0] nand_w;
  wire [0:0] nand2_w;
  wire [0:0] nor_w;
  wire [0:0] inv1_w;

  //First NAND
  nand2
   #()
  nand2_inst
   (.a_i(a_i)
   ,.b_i(b_i)
   ,.c_o(nand_w)
   );
  //First NAND

  //NOR for OR, to be sent to inverter 1
  nor2
   #()
  nor2_inst
   (.a_i(a_i)
   ,.b_i(b_i)
   ,.c_o(nor_w)
   );
  //NOR for OR, to be sent to inverter 1

  // Inverter 1
   nand2
    #()
   inv_nand2_inst
    (.a_i(nor_w)
    ,.b_i(nor_w)
    ,.c_o(inv1_w)
    );
  // Inverter 1

  //NAND for final AND, to be sent to inverter 2
   nand2
    #()
   fin_nand2_inst
    (.a_i(inv1_w)
    ,.b_i(nand_w)
    ,.c_o(nand2_w)
    );
  //NAND for final AND, to be sent to inverter 2
   
   //Inverter to be sent to c_o 
   nand2
    #()
   inv2_nand_inst
    (.a_i(nand2_w)
    ,.b_i(nand2_w)
    ,.c_o(sum_o)
    );

  

  nand2
   #()
  carry_nand_inst
   (.a_i(a_i)
   ,.b_i(b_i)
   ,.c_o(carry_nand_w)
   );

  nand2
   #()
  carry_inv_inst
   (.a_i(carry_nand_w)
   ,.b_i(carry_nand_w)
   ,.c_o(carry_o)
   );

endmodule
