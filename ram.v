`timescale 1ns / 1ps
module ram(
   input clk,rst,ram_out,ram_in,
   input SET,
   input [7:0]b_in,
   input [3:0]addr,
   input [3:0]addr_mar,
   input [7:0]din,
   output [7:0]b_out
   );
reg [7:0]mem[15:0];

integer i;

always@(posedge clk)
    begin
      if(rst)
        begin
          for(i=0;i<16;i=i+1)
            mem[i] <= 0;
        end
      else if(SET)
        begin
        mem[addr] <= din;
        end     
      else if(ram_in)
         begin
          mem[addr_mar] <= b_in ;
         end     
     end  
             
  assign b_out = (ram_out) ? mem[addr_mar] : 8'bz;             
endmodule
