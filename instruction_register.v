`timescale 1ns / 1ps

module instruction_register(
    inout [7:0]b,
    input ir_in,ir_out,clk,rst,
    output [3:0]opcode
    );
    reg [7:0]instruction_register;
    
    assign b[7:0] = ir_out ? {4'b0,instruction_register[3:0]}:8'bz;
    always@(posedge clk)begin
        if(rst)
            instruction_register<=0;
        else begin
            if(ir_in)begin
                instruction_register<=b[7:0];
            end
        end
    end
    assign opcode = instruction_register[7:4];
    
endmodule
