`timescale 1ns / 1ps

module alu(
    input clk , areg_in , areg_out , breg_in , rst , alu_out,
    input [7:0] a_reg,
    input [7:0] b_reg,
    input [2:0] alu_op,
    output  reg [7:0]result,
    output reg  carry,
    output [7:0]result_out
);

always@(posedge clk)
begin
     if(rst)begin
        carry<=0;
        result<=8'h00;
     end
     else begin
        case(alu_op)
           3'b000:{carry , result} <=a_reg + b_reg;
           3'b001:result<=a_reg - b_reg;
           3'b010:result<=a_reg << b_reg;
           3'b011:result<=a_reg >>> b_reg;
           3'b100:result<=a_reg & b_reg;
           3'b101:result<=a_reg | b_reg;
           3'b110:result<=a_reg ^ b_reg;
           default:result<=8'b0;
        endcase
     end
end
assign result_out = alu_out ? result : 8'bz ;
endmodule
