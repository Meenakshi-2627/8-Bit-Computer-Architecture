`timescale 1ns / 1ps

module alu(
    input clk , rst , alu_out,
    input [7:0] a_reg,
    input [7:0] b_reg,
    input [2:0] alu_op, 
    output reg  carry_out,
    output reg zero_out,
    output [7:0]result_out
);
    reg [7:0]result;

always@(posedge clk)
begin
     if(rst)begin
        carry_out <=0;
        zero_out <=0;
        result<=8'h00;
     end
     else begin
        case(alu_op)
           3'b000:{carry_out , result} <=a_reg + b_reg;
           3'b001:result<=a_reg - b_reg;
           3'b010:result<=a_reg << b_reg;
           3'b011:result<=a_reg >>> b_reg;
           3'b100:result<=a_reg & b_reg;
           3'b101:result<=a_reg | b_reg;
           3'b110:result<=a_reg ^ b_reg;
           default:result<=8'b0;
        endcase
     end
     if(result == 8'd0)
       zero_out <= 1; 
end
assign result_out = alu_out ? result : 8'bz ;
endmodule
