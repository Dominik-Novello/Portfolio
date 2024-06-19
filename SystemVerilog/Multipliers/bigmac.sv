module bigmac
 #(parameter int_in_lp = 1
  ,parameter frac_in_lp = 11
  ,parameter int_out_lp = 10
  ,parameter frac_out_lp = 22
  ) 
  (input [0:0] clk_i
  ,input [0:0] reset_i

  ,input [int_in_lp - 1 : -frac_in_lp] a_i
  ,input [int_in_lp - 1 : -frac_in_lp] b_i
  ,input [0:0] valid_i
  ,output [0:0] ready_o 

  ,input [0:0] ready_i
  ,output [0:0] valid_o 
  ,output [int_out_lp - 1 : -frac_out_lp] data_o
  );

  logic[0:0] en_l;
  logic[0:0] valid_l;
  logic[int_out_lp - 1 : -frac_out_lp] multout_l;
  logic[15:0] A_l;
  logic[15:0] B_l;
  logic[int_out_lp - 1 : -frac_out_lp] datain_l;
  logic[int_out_lp - 1 : -frac_out_lp] datahold_l;

  assign ready_o = ~valid_o || ready_i;
  assign en_l = ready_o && valid_i;

  always_ff @(posedge clk_i) begin
	  if (reset_i) begin
		  valid_l <= 1'b0;
	  end else if (ready_o) begin
		  valid_l <= en_l;
	  end
  end

  always_ff @(posedge clk_i) begin
	  if (reset_i) begin
		  A_l <= '0;
		  B_l <= '0;
		  datain_l <= '0;
	  end else if (en_l) begin
		  A_l <= ({4'b0,a_i});
		  B_l <= ({4'b0,b_i});
		  datain_l <= datahold_l;
	  end
  end

  SB_MAC16
   #(1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 2'b11, 2'b0, 1'b1, 2'b0, 2'b11, 2'b0, 1'b1, 2'b0, 1'b0, 1'b0, 1'b0)
  multi_inst
   (.CLK(clk_i)
   ,.CE(1'b1)
   ,.C('0)
   ,.A(A_l)
   ,.B(B_l)
   ,.D('0)
   ,.AHOLD(1'b0)
   ,.BHOLD(1'b0)
   ,.CHOLD(1'b0)
   ,.DHOLD(1'b0)
   ,.IRSTTOP(1'b0)
   ,.IRSTBOT(1'b0)
   ,.ORSTTOP(1'b0)
   ,.ORSTBOT(1'b0)
   ,.OLOADTOP(1'b0)
   ,.OLOADBOT(1'b0)
   ,.ADDSUBTOP(1'b0)
   ,.ADDSUBBOT(1'b0)
   ,.OHOLDTOP(1'b0)
   ,.OHOLDBOT(1'b0)
   ,.CI(1'b0)
   ,.ACCUMCI(1'b0)
   ,.SIGNEXTIN(1'b0)
   ,.O(multout_l)
   ,.CO()
   ,.ACCUMCO()
   ,.SIGNEXTOUT()
   );

  SB_MAC16
   #(1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 2'b0, 2'b0, 1'b1, 2'b10, 2'b0, 2'b0, 1'b1, 2'b0, 1'b0, 1'b0, 1'b0)
  add_inst
   (.CLK(clk_i)
   ,.CE(1'b1)
   ,.C(datain_l[9:-6])
   ,.A(multout_l[9:-6])
   ,.B(multout_l[-7:-22])
   ,.D(datain_l[-7:-22])
   ,.AHOLD(1'b0)
   ,.BHOLD(1'b0)
   ,.CHOLD(1'b0)
   ,.DHOLD(1'b0)
   ,.IRSTTOP(1'b0)
   ,.IRSTBOT(1'b0)
   ,.ORSTTOP(1'b0)
   ,.ORSTBOT(1'b0)
   ,.OLOADTOP(1'b0)
   ,.OLOADBOT(1'b0)
   ,.ADDSUBTOP(1'b0)
   ,.ADDSUBBOT(1'b0)
   ,.OHOLDTOP(1'b0)
   ,.OHOLDBOT(1'b0)
   ,.CI(1'b0)
   ,.ACCUMCI(1'b0)
   ,.SIGNEXTIN(1'b0)
   ,.O(datahold_l[8:-22])
   ,.CO(datahold_l[9])
   ,.ACCUMCO()
   ,.SIGNEXTOUT()
   );

   assign data_o = datahold_l;
   assign valid_o = valid_l;
   
endmodule
