module adder
  #(parameter width_p = 5)
  // You must fill in the bit widths of a_i, b_i and sum_o. a_i and
  // b_i must be width_p bits.
  (input [width_p-1:0] a_i
  ,input [width_p-1:0] b_i
  ,output [width_p:0] sum_o);

  logic [width_p-1:0] carry_l;

  cyclonev_lcell_comb
    #(64'b0110)
   cyc_inst1
    (.dataa(a_i[0])
    ,.datab(b_i[0])
    ,.datac(1'b0)
    ,.datad(1'b0)
    ,.datae(1'b0)
    ,.dataf(1'b0)
    ,.datag(1'b0)
    ,.cin(1'b0)
    ,.sharein(1'b0)
    ,.combout(sum_o[0])
    ,.cout()
    ,.sumout()
    ,.shareout()
    );

   cyclonev_lcell_comb
    #(64'b1000)
   cyc_inst2
    (.dataa(a_i[0])
    ,.datab(b_i[0])
    ,.datac(1'b0)
    ,.datad(1'b0)
    ,.datae(1'b0)
    ,.dataf(1'b0)
    ,.datag(1'b0)
    ,.cin(1'b0)
    ,.sharein(1'b0)
    ,.combout(carry_l[0])
    ,.cout()
    ,.sumout()
    ,.shareout()
    );

   for (genvar i = 1; i < width_p; i++) begin
	   cyclonev_lcell_comb
	    #(64'b10010110)
	   cyc_inst3
	    (.dataa(a_i[i])
	    ,.datab(b_i[i])
	    ,.datac(carry_l[i-1])
	    ,.datad(1'b0)
	    ,.datae(1'b0)
	    ,.dataf(1'b0)
	    ,.datag(1'b0)
	    ,.cin(1'b0)
	    ,.sharein(1'b0)
	    ,.combout(sum_o[i])
	    ,.cout()
	    ,.sumout()
	    ,.shareout()
	    );
	   
	   cyclonev_lcell_comb
	    #(64'b11101000)
	   cyc_inst4
	    (.dataa(a_i[i])
	    ,.datab(b_i[i])
	    ,.datac(carry_l[i-1])
	    ,.datad(1'b0)
	    ,.datae(1'b0)
	    ,.dataf(1'b0)
	    ,.datag(1'b0)
	    ,.cin(1'b0)
	    ,.sharein(1'b0)
	    ,.combout(carry_l[i])
	    ,.cout()
	    ,.sumout()
	    ,.shareout()
	    );
   end

   cyclonev_lcell_comb
    #(64'b10)
   cyc_inst5
    (.dataa(carry_l[width_p-1])
    ,.datab(1'b0)
    ,.datac(1'b0)
    ,.datad(1'b0)
    ,.datae(1'b0)
    ,.dataf(1'b0)
    ,.datag(1'b0)
    ,.cin(1'b0)
    ,.sharein(1'b0)
    ,.combout(sum_o[width_p])
    ,.cout()
    ,.sumout()
    ,.shareout()
    );

endmodule
