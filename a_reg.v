`timescale 1ns / 1ps

module a_reg(
    input areg_in,areg_out,rst,clk,
    input [7:0]b_in,
    output [7:0]b_out
    );
  reg[7:0]a_reg;
    always@(posedge clk)begin
    if(rst)
        a_reg<=0;
    else begin
        if(areg_in)begin
        a_reg<=b_in;
        end
    end
    end
    assign b_out= areg_out ? a_reg : 8'bz;

endmodule
