module mac
  #(
   // This is here to help, but we won't change it.
   parameter width_p = 24
   )
  (input [0:0] clk_i
  ,input [0:0] reset_i

  ,input [0:0] valid_i
  ,input signed [width_p - 1:0] data_i
  ,output [0:0] ready_o

  ,output [0:0] valid_o
  ,output signed [width_p - 1:0] data_o
  ,input [0:0] ready_i
  );

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

  logic signed [0:-4] b_l = 5'b01101;
  logic signed [width_p-1:0] data_prev_l;
  logic signed [width_p-1:0] data_hold_l;
  logic signed [width_p-1:-4] data_tob_l;
  logic signed [width_p-1:-8] into_add_l;
  logic signed [width_p-1:0] data_in_l;
  logic signed [width_p-1:0] data_l;

  always_ff @(posedge clk_i) begin
	  if (reset_i) begin
		  data_in_l <= '0;
		  data_prev_l <= '0;
	  end else if (en_l) begin
		  data_in_l <= data_i;
		  data_prev_l <= data_hold_l;
	  end
  end

  assign data_tob_l[width_p - 1:0] = data_in_l - data_prev_l;
  assign data_tob_l[-1:-4] = '0;

  assign into_add_l = data_tob_l * b_l;

  assign data_l = into_add_l[width_p-1:0] + data_prev_l;

  assign data_hold_l = data_l;
  assign data_o = data_hold_l;
  assign valid_o = valid_l;

endmodule

