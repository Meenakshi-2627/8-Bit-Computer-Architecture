`timescale 1ns / 1ps

module b_reg(
    input breg_in,rst,clk,
    inout [7:0]b,
    output [7:0]bwire
    );
    reg [7:0] b_reg;
    always@(posedge clk)begin
    if(rst)
        b_reg<=0;
    else begin
        if(breg_in)begin
        b_reg<=b;
        end
    end
    end
    assign bwire = b_reg;
endmodule
