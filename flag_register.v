`timescale 1ns / 1ps

module flag_reg(
    input clk,
    input rst,
    input flag_en,
    input carry_out,zero_out,
    output reg  zero_f,
    output reg  carry_f
);

always @(posedge clk)
 begin
  if (rst) begin
    zero_f  <= 1'b0;
    carry_f <= 1'b0;
  end
  else if (flag_en) 
      begin
        zero_f  <=zero_out;
       carry_f <= carry_out;
      end
end
endmodule
