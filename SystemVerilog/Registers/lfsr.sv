module lfsr
   (input [0:0] clk_i
   ,input [0:0] reset_i
   ,output [5:0] data_o);
   
   parameter depth_p = 6;
   parameter [5:0] reset_val_p = 6'b000001; 
 
   shift
    #(depth_p, reset_val_p)
   shift_inst
    (.clk_i(clk_i)
    ,.reset_i(reset_i)
    ,.data_i(data_o[0])
    ,.enable_i(1'b1)
    ,.data_o(data_o[5:1])
    );

    xor2
     #()
    xor2_inst
     (.a_i(data_o[1])
     ,.b_i(data_o[5])
     ,.c_o(data_o[0])
     );

endmodule
