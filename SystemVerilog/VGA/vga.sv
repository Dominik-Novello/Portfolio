module vga
  #(parameter pixel_bits_p = 8)
  (input [0:0] clk_i
  ,input [0:0] reset_i

  ,output [0:0] ready_o
  ,input [2:0][pixel_bits_p-1:0] data_i

  ,output [0:0] hsync_o
  ,output [0:0] vsync_o
  ,output [0:0] disp_en_o
  ,output [2:0][pixel_bits_p-1:0] data_o
  );

  logic[23:0] v_counter;
  logic[23:0] h_counter;
  logic[2:0][pixel_bits_p-1:0] data_l;
  logic[0:0] hsync_l;
  logic[0:0] vsync_l;
  logic[0:0] disp_en_l;
  logic[0:0] ready_l;
  logic[0:0] v_up;

  always_ff @(posedge clk_i) begin
	  if(reset_i) begin
		  data_l[0] = '0;
		  data_l[1] = '0;
		  data_l[2] = '0;
	  end else begin
		  data_l = data_i;
	  end
  end

  always_ff @(posedge clk_i) begin
	  if((h_counter < 49) || (h_counter > 688) || (v_counter < 34) || (v_counter > 512)) begin
		  if(h_counter > 704) begin
			  if(v_counter > 523) begin
				 hsync_l = 1'b1;
				 vsync_l = 1'b1;
				 ready_l = 1'b0;
				 disp_en_l = 1'b0;
			  end else begin
				 vsync_l = 1'b0;
				 hsync_l = 1'b1;
				 ready_l = 1'b0;
				 disp_en_l = 1'b0;
			  end
		   end else if (v_counter > 523) begin
			  hsync_l = 1'b0;
			  vsync_l = 1'b1;
			  ready_l = 1'b0;
			  disp_en_l = 1'b0;
		   end else begin
			  hsync_l = 1'b0;
			  vsync_l = 1'b0;
			  ready_l = 1'b0;
			  disp_en_l = 1'b0;
		   end
	    end else begin
		    hsync_l = 1'b0;
		    vsync_l = 1'b0;
		    ready_l = 1'b1;
		    disp_en_l = 1'b1;
	    end
  end

  //always_ff @(posedge clk_i) begin
//	  if(h_counter !== 800) begin
//		  h_counter = h_counter + 1; 
//	  end else begin
//		  h_counter = 1;
//	  end
//
//	  if((v_counter !== 524) && (h_counter === 1)) begin
//		  v_counter = v_counter + 1;
//	  end else if((v_counter === 524) && (h_counter === 1)) begin
//		  v_counter = 1;
//	  end
  //end

  counter
   #(800, 24, 1)
  h_count
   (.clk_i(clk_i)
   ,.reset_i(reset_i)
   ,.up_i(1'b1)
   ,.down_i(1'b0)
   ,.count_o(h_counter)
   );

  counter
   #(524, 24, 1)
  v_count
   (.clk_i(clk_i)
   ,.reset_i(reset_i)
   ,.up_i((h_counter ===800))
   ,.down_i(1'b0)
   ,.count_o(v_counter)
   );
   


  assign hsync_o = hsync_l;
  assign vsync_o = vsync_l;
  assign ready_o = ready_l;
  assign disp_en_o = disp_en_l;
  assign data_o = data_l;

endmodule
