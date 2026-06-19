`timescale 1ns / 1ps

module flag_reg(
    input clk,
    input rst,
    input flag_en,
    input carry,
    input [7:0] rf,
    output reg  zero_f,
    output reg  carry_f
);

always @(posedge clk) begin
  if (rst) begin
    zero_f  <= 1'b0;
    carry_f <= 1'b0;
  end
  else if (flag_en) begin
      if(rf==8'b0)begin
        zero_f  <= 1'b0;
      end
    carry_f <= carry;
  end
end

endmodule
