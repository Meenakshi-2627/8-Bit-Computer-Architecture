`timescale 1ns / 1ps

module input_register(
input [7:0]data,
input input_out,clk,rst,
output [7:0]data_out
    );
reg [7:0]input_register;
always@(posedge clk)begin
    if(rst)
        input_register<=0;
    else 
        input_register<=data;
end
assign data_out= input_out ? input_register : 8'bz;
endmodule
