`timescale 1ns / 1ps

module output_register(
    input [7:0]b,
    input clk,rst,out_in,
    output [7:0]out_dis
    );
    reg [7:0]output_register;
    always@(posedge clk)begin
        if(rst)
            output_register<=0;
        else if(out_in)
            output_register<=b;
    end
    assign out_dis = output_register;
endmodule
