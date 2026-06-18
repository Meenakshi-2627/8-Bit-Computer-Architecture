`timescale 1ns / 1ps

module a_reg(
    input areg_in,areg_out,rst,clk,
    inout [7:0]b,
    output [7:0]awire
    );
    reg [7:0] a_reg;
    always@(posedge clk)begin
    if(rst)
        a_reg<=0;
    else begin
        if(areg_in)begin
        a_reg<=b;
        end
    end
    end
    assign b= areg_out ? a_reg : 8'bz;
    assign awire = a_reg;
endmodule
