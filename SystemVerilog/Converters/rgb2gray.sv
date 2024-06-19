module rgb2gray
  #(
   // This is here to help, but we won't change it.
   parameter width_p = 8
   )
  (input [0:0] clk_i
  ,input [0:0] reset_i

  ,input [0:0] valid_i
  ,input [width_p - 1:0] red_i
  ,input [width_p - 1:0] blue_i
  ,input [width_p - 1:0] green_i
  ,output [0:0] ready_o

  ,output [0:0] valid_o
  ,output [width_p - 1:0] gray_o
  ,input [0:0] ready_i
  );

   // The testbench uses this function to test your code. How many
   // fractional bits are needed to enode these values?

   // gray = 0.2989 * r + 0.5870 * g + 0.1140 * b

   logic [-1:-8] red_co_l = 8'b01001100;
   logic [-1:-8] green_co_l = 8'b10010110;
   logic [-1:-8] blue_co_l = 8'b00011101;

   logic [width_p - 1 : -16] red_calc_l;
   logic [width_p - 1 : -16] green_calc_l;
   logic [width_p - 1 : -16] blue_calc_l;

   logic [width_p - 1 : -8] red_hold_l;
   logic [width_p - 1 : -8] green_hold_l;
   logic [width_p - 1 : -8] blue_hold_l;

   logic [0:0] valid_l;
   logic [0:0] en_l;

   assign ready_o = ~valid_o || ready_i;
   assign en_l = ready_o && valid_i;

   assign red_hold_l[width_p - 1 : 0] = red_i;
   assign green_hold_l[width_p - 1 : 0] = green_i;
   assign blue_hold_l[width_p - 1 : 0] = blue_i;

   assign red_hold_l[-1:-8] = '0;
   assign green_hold_l[-1:-8] = '0;
   assign blue_hold_l[-1:-8] = '0;

   always_ff @(posedge clk_i) begin
	   if (reset_i) begin
		   valid_l <= 1'b0;
	   end else if (ready_o) begin
		   valid_l <= en_l;
	   end
   end

   always_ff @(posedge clk_i) begin
	   if (reset_i) begin
		   red_calc_l <= '0;
		   green_calc_l <= '0;
		   blue_calc_l <= '0;
	   end else if (en_l) begin
		   red_calc_l <=  red_co_l  * red_hold_l;
		   green_calc_l <= green_co_l * green_hold_l;
		   blue_calc_l <=  blue_co_l * blue_hold_l;
	   end 
   end
   assign valid_o = valid_l;

   assign gray_o = red_calc_l[width_p-1:0] + green_calc_l[width_p-1:0] + blue_calc_l[width_p-1:0] + 1;
endmodule

