`timescale 1ns / 1ps
module prgm_counter(
     input clk,rst,
     input pc_l,pc_e,pc_o,  
     inout [7:0]b 
 );
  reg [3:0]pc_out; 
 always@(posedge clk)
     begin
       if(rst)
           pc_out <= 0;
       else if(pc_e)
           pc_out <= pc_out +1;
       else if(pc_l)
          pc_out <= b;
     end  
   assign b = (pc_o) ?{4'b0, pc_out} : 8'bzzzz;                     
endmodule
