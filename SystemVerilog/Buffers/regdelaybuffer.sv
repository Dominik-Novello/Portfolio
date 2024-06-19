module delaybuffer
  #(parameter [31:0] width_p = 8
   ,parameter [31:0] delay_p = 8
   )
  (input [0:0] clk_i
  ,input [0:0] reset_i

  ,input [width_p - 1:0] data_i
  ,input [0:0] valid_i
  ,output [0:0] ready_o 

  ,output [0:0] valid_o 
  ,output [width_p - 1:0] data_o 
  ,input [0:0] ready_i
  );

  logic [width_p-1:0] mem [delay_p-1:0];
  logic [delay_p-1:0] wr_address_l;
  logic [delay_p-1:0] rd_address_l = 0;
  logic [width_p-1:0] data_l;
  logic[0:0] valid_l;
  logic[0:0] en_l;

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
		  data_l <= '0;
		  rd_address_l <= 0;
		  wr_address_l <= '0;
	  end else if (en_l) begin
		  mem[wr_address_l] <= data_i;
		  wr_address_l <= (wr_address_l + 1) % delay_p;
		  data_l <= mem[rd_address_l];
		  rd_address_l <= (rd_address_l + 1) % delay_p;
	  end
  end

  assign data_o = data_l;
  assign valid_o = valid_l;
endmodule
