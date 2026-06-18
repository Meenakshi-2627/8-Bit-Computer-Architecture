`timescale 1ns / 1ps
module prgm_counter(
     input clk,rst,
     input pc_l,pc_e,pc_o,  
     output reg [3:0]pc_out,
     inout [3:0]b 
 );
   
 always@(posedge clk)
     begin
       if(rst)
           pc_out <= 0;
       else if(pc_e)
           pc_out <= pc_out +1;
       else if(pc_l)
          pc_out <= b;
     end  
   assign b = (pc_o) ? pc_out : 4'bzzzz;                     
endmodule
