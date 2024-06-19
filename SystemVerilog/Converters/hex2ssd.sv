module hex2ssd
  (input [3:0] hex_i
  ,output [6:0] ssd_o
  );

  ram_1r1w_async
   #(7,16,"hex2ssd.hex")
  mem_inst
   (.clk_i(1'b0)
   ,.reset_i(1'b0)
   ,.wr_valid_i(1'b0)
   ,.wr_data_i(7'b0)
   ,.wr_addr_i(4'b0)
   ,.rd_addr_i(hex_i)
   ,.rd_data_o(ssd_o)
   );


endmodule
