`timescale 1ns / 1ps
module ram(
   input clk,rst,ram_out,ram_in,
   input SET,
   inout [7:0]b,
   input [3:0]addr,
   input [3:0]addr_mar,
   input [7:0]din
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
          mem[addr_mar] <= b ;
         end     
     end  
             
  assign b = (ram_out) ? mem[addr_mar] : 8'bz;             
endmodule
