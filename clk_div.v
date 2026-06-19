`timescale 1ns / 1ps

module clk_div (
    input  wire clk_in,
    input  wire rst,
    output reg  clk_out
);

    reg [24:0] count;

    always @(posedge clk_in) begin
        if (rst) begin
            count   <= 25'd0;
            clk_out <= 1'b0;
        end
        else if (count == 25'd12_499_999) begin
            count   <= 25'd0;
            clk_out <= ~clk_out;   
        end
        else begin
            count <= count + 1'b1;
        end
    end

endmodule
