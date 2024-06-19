module counter
  #(parameter [31:0] max_val_p = 15
   ,parameter width_p = $clog2(max_val_p)  
    /* verilator lint_off WIDTHTRUNC */
   ,parameter [width_p-1:0] reset_val_p = '0
    )
    /* verilator lint_on WIDTHTRUNC */
   (input [0:0] clk_i
   ,input [0:0] reset_i
   ,input [0:0] up_i
   ,input [0:0] down_i
   ,output [width_p-1:0] count_o);

   localparam [width_p-1:0] max_val_lp = max_val_p[width_p-1:0];

   logic [width_p-1:0] count_l;

   always_ff @(posedge clk_i) begin
	   if(reset_i) begin
		   count_l <= reset_val_p;
	   end else if (up_i && ~down_i && (count_l < max_val_lp)) begin
		   count_l <= count_l + 1;
	   end else if (up_i && ~down_i && (count_l >= max_val_lp)) begin
		   count_l <= '0;
	   end else if (down_i && ~up_i && (count_l > 0)) begin
		   count_l <= count_l - 1;
	   end else if (down_i && ~up_i && (count_l <= 0)) begin
		   count_l <= max_val_lp;
	   end
   end
   
   assign count_o = count_l;   

endmodule
