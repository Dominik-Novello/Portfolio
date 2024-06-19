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

  logic [delay_p-1:0] wr_address_l;
  logic [delay_p-1:0] rd_address_l;
  logic[0:0] valid_l;
  logic[0:0] en_l;
  logic[width_p-1:0] data_l;

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
		  rd_address_l <= '0;
		  wr_address_l <= '0;
	  end else if (en_l) begin
		  wr_address_l <= (wr_address_l + 1'b1) % (delay_p);
		  rd_address_l <= (rd_address_l + 1'b1) % (delay_p);
	 end
  end
	
  ram_1r1w_sync
   #(width_p, delay_p)
  ram_inst
   (.clk_i(clk_i)
   ,.reset_i(reset_i)
   ,.wr_valid_i(en_l)
   ,.wr_data_i(data_i)
   ,.wr_addr_i(wr_address_l)
   ,.rd_valid_i(en_l)
   ,.rd_addr_i(rd_address_l)
   ,.rd_data_o(data_l)
   );

   assign data_o = data_l;

   assign valid_o = valid_l;


endmodule
