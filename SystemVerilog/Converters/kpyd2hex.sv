module kpyd2hex
  (input [7:0] kpyd_i
  ,output [3:0] hex_o);

  logic [3:0] kpyd_l;
  always_comb begin
  	case (kpyd_i)
		8'b00010001: kpyd_l = 4'b0;
		8'b00100001: kpyd_l = 4'b1;
		8'b01000001: kpyd_l = 4'b10;
		8'b10000001: kpyd_l = 4'b11;
		8'b00010010: kpyd_l = 4'b100;
		8'b00100010: kpyd_l = 4'b101;
		8'b01000010: kpyd_l = 4'b110;
		8'b10000010: kpyd_l = 4'b111;
		8'b00010100: kpyd_l = 4'b1000;
		8'b00100100: kpyd_l = 4'b1001;
		8'b01000100: kpyd_l = 4'b1010;
		8'b10000100: kpyd_l = 4'b1011;
		8'b00011000: kpyd_l = 4'b1100;
		8'b00101000: kpyd_l = 4'b1101;
		8'b01001000: kpyd_l = 4'b1110;
		8'b10001000: kpyd_l = 4'b1111;
		default: kpyd_l = 4'b0;
	endcase
  end

  ram_1r1w_async
   #(4,16,"kpyd2hex.hex")
  mem_inst
   (.clk_i(1'b0)
   ,.reset_i(1'b0)
   ,.wr_valid_i(1'b0)
   ,.wr_data_i(4'b0)
   ,.wr_addr_i(4'b0)
   ,.rd_addr_i(kpyd_l)
   ,.rd_data_o(hex_o)
   );
  

endmodule
