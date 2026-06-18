`timescale 1ns / 1ps
module mem_addr_reg(
    input clk,rst,mar_in,
    input [3:0]b,
    output reg[3:0]mem_out
 );
  always@(posedge clk)
  begin
     if(rst)
       mem_out <= 4'd0;
     else if(mar_in)
       mem_out <= b;  
  end          
endmodule
