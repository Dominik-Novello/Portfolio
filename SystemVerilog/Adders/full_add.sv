module full_add
  (input [0:0] a_i
  ,input [0:0] b_i
  ,input [0:0] carry_i
  ,output [0:0] carry_o
  ,output [0:0] sum_o);

  cyclonev_lcell_comb
    #(64'b10010110)
   cyc_inst1
    (.dataa(a_i)
    ,.datab(b_i)
    ,.datac(carry_i)
    ,.datad(1'b0)
    ,.datae(1'b0)
    ,.dataf(1'b0)
    ,.datag(1'b0)
    ,.cin(1'b0)
    ,.sharein(1'b0)
    ,.combout(sum_o)
    ,.cout()
    ,.sumout()
    ,.shareout()
    );

   cyclonev_lcell_comb
    #(64'b11101000)
   cyc_inst2
    (.dataa(a_i)
    ,.datab(b_i)
    ,.datac(carry_i)
    ,.datad(1'b0)
    ,.datae(1'b0)
    ,.dataf(1'b0)
    ,.datag(1'b0)
    ,.cin(1'b0)
    ,.sharein(1'b0)
    ,.combout(carry_o)
    ,.cout()
    ,.sumout()
    ,.shareout()
    );

endmodule
