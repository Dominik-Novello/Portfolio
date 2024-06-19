module adder
  #(
   // This is here to help, but we won't change it.
   parameter width_p = 32
   )
  (input [0:0] clk_i
  ,input [0:0] reset_i

  ,input [0:0] valid_i
  ,input signed [width_p - 1:0] a_i
  ,input signed [width_p - 1:0] b_i
  ,output [0:0] ready_o

  ,output [0:0] valid_o 
  ,output signed [width_p:0] c_o 
  ,input [0:0] ready_i
  );

  logic [15:0] A1_l;
  logic [15:0] A2_l;
  logic [15:0] B1_l;
  logic [15:0] B2_l;
  logic [0:0] valid_l;
  logic [0:0] en_l;

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
		  A1_l <= '0;
		  A2_l <= '0;
		  B1_l <= '0;
		  B2_l <= '0;
	  end else if (en_l) begin
		  A1_l <= a_i[31 : 16];
		  A2_l <= a_i[15 : 0];
		  B1_l <= b_i[31 : 16];
		  B2_l <= b_i[15 : 0];
	  end
  end

  SB_MAC16
   #(1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 2'b0, 2'b0, 1'b1, 2'b10, 2'b0, 2'b0, 1'b1, 2'b0, 1'b0, 1'b0, 1'b0)
  sd_inst
   (.CLK(clk_i)
   ,.CE(1'b1)
   ,.C(B1_l)
   ,.A(A1_l)
   ,.B(A2_l)
   ,.D(B2_l)
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
   ,.O(c_o[31:0])
   ,.CO(c_o[32])
   ,.ACCUMCO()
   ,.SIGNEXTOUT()
   );

  assign valid_o = valid_l; 
endmodule

