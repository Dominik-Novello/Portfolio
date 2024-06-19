module gray2bin
  #(parameter width_p = 5)
   (input [width_p - 1 : 0] gray_i
    ,output [width_p - 1 : 0] bin_o);
  
  assign bin_o[width_p-1] = gray_i[width_p-1];

  for (genvar i = width_p-2; i > -1; i--) begin
   assign bin_o[i] = (bin_o[i+1] && ~gray_i[i]) || (~bin_o[i+1] && gray_i[i]);
  end


endmodule
