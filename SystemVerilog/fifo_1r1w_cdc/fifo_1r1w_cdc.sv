module fifo_1r1w_cdc
 #(parameter [31:0] width_p = 32
  ,parameter [31:0] depth_log2_p = 8
  )
   // To emphasize that the two interfaces are in different clock
   // domains i've annotated the two sides of the fifo with "c" for
   // consumer, and "p" for producer. 
  (input [0:0] cclk_i
  ,input [0:0] creset_i
  ,input [width_p - 1:0] cdata_i
  ,input [0:0] cvalid_i
  ,output [0:0] cready_o 

  ,input [0:0] pclk_i
  ,input [0:0] preset_i
  ,output [0:0] pvalid_o 
  ,output [width_p - 1:0] pdata_o 
  ,input [0:0] pready_i
  );
   
  logic[0:0] full_l;
  logic[0:0] empty_l;
  logic[depth_log2_p:0] ccount_l;
  logic[depth_log2_p:0] pcount_l;
  logic[depth_log2_p:0] pgray_l;
  logic[depth_log2_p:0] cgray_l;
  logic[depth_log2_p:0] cbin_l;
  logic[depth_log2_p:0] pbin_l;
  logic[depth_log2_p:0] creg1_l;
  logic[depth_log2_p:0] creg2_l;
  logic[depth_log2_p:0] preg1_l;
  logic[depth_log2_p:0] preg2_l;
  logic[width_p-1:0] data_l;
  
  assign pvalid_o = ~(pcount_l === cbin_l);
  assign cready_o = ~((ccount_l[depth_log2_p-1:0] === pbin_l[depth_log2_p-1:0]) && (ccount_l[depth_log2_p] !== pbin_l[depth_log2_p]));
  
  counter
   #(depth_log2_p+1)
  ccounter
   (.clk_i(cclk_i)
   ,.reset_i(creset_i)
   ,.up_i(cready_o && cvalid_i)
   ,.down_i(1'b0)
   ,.count_o(ccount_l)
   );

  counter
   #(depth_log2_p+1)
  pcounter
   (.clk_i(pclk_i)
   ,.reset_i(preset_i)
   ,.up_i(pready_i && pvalid_o)
   ,.down_i(1'b0)
   ,.count_o(pcount_l)
   );

  bin2gray
   #(depth_log2_p+1)
  cbin2gray
   (.bin_i(ccount_l)
   ,.gray_o(cgray_l)
   );

  bin2gray
   #(depth_log2_p+1)
  pbin2gray
   (.bin_i(pcount_l)
   ,.gray_o(pgray_l)
   );

   always_ff @(posedge pclk_i) begin
	   if(creset_i) begin
		  creg1_l <= '0;
		  creg2_l <= '0;
	   end else begin
		  creg1_l <= cgray_l;
		  creg2_l <= creg1_l;
	   end
   end

   always_ff @(posedge cclk_i) begin
	   if(preset_i) begin
		  preg1_l <= '0;
		  preg2_l <= '0;
	   end else begin
		  preg1_l <= pgray_l;
		  preg2_l <= preg1_l;
	   end
   end

   gray2bin
    #(depth_log2_p+1)
   cgray2bin
    (.gray_i(creg2_l)
    ,.bin_o(cbin_l)
    );

   gray2bin
    #(depth_log2_p+1)
   pgray2bin
    (.gray_i(preg2_l)
    ,.bin_o(pbin_l)
    );

   ram_1r1w_async
    #(width_p, 1<<depth_log2_p)
   ram_inst
    (.clk_i(cclk_i)
    ,.reset_i(creset_i || preset_i)
    ,.wr_valid_i(cvalid_i && cready_o)
    ,.wr_data_i(cdata_i)
    ,.wr_addr_i(ccount_l[depth_log2_p-1:0])
    ,.rd_addr_i(pcount_l[depth_log2_p-1:0])
    ,.rd_data_o(pdata_o)
    );

endmodule

