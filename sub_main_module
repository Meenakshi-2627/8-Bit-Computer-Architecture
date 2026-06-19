`timescale 1ns / 1ps

module top_mod_1(
  input clk,rst,
  input SET,
  input [7:0]data,
  input [7:0]bus_in,
  output [3:0]mem_out,
  output [7:0]bus_out,
  output ram_in,ram_out,
  output [7:0]out_disp  
 );

    wire [7:0]bus;
    wire [7:0] a_reg;
    wire pc_l,pc_e,pc_o;
    wire [3:0]pc_out;
    wire ir_in,ir_out,mar_in;
    wire [3:0]opcode;
    wire [2:0]alu_op;
    wire out_in,flag_en,areg_in,breg_in,areg_out,zero_f,carry_f,alu_out,input_out,hlt_out;
    wire [7:0]b_reg;
    wire [7:0]result;
    wire carry_out,zero_out;
    wire [7:0]out_dis,b_out;
    
    assign bus_out= b_out;
    assign bus = bus_in;
    prgm_counter PC(.b(bus),.pc_l(pc_l),.pc_o(pc_o),.pc_e(pc_e),.clk(clk),.rst(rst));
    mem_addr_reg MAR(.b(bus[3:0]),.mem_out(mem_out),.clk(clk),.rst(rst),.mar_in(mar_in));
    instruction_register IR(.b(bus),.opcode(opcode),.ir_in(ir_in),.ir_out(ir_out),.clk(clk),.rst(rst));
    control_unit CU (.clk(clk),.rst(rst),.alu_op(alu_op),.mar_in(mar_in),.ram_in(ram_in),.ram_out(ram_out),.pc_o(pc_o),.pc_l(pc_l),.pc_e(pc_e),.out_in(out_in),.flag_en(flag_en),.areg_in(areg_in),.breg_in(breg_in),.areg_out(areg_out),.zero_f(zero_f),.carry_f(carry_f),.alu_out(alu_out),.input_out(input_out),.hlt_out(hlt_out),.SET(SET),.ir_in(ir_in),.ir_out(ir_out),.opcode(opcode));
    a_reg AREG (.clk(clk),.rst(rst),.b_in(bus),.areg_in(areg_in),.areg_out(areg_out),.b_out(b_out));
    b_reg BREG (.clk(clk),.rst(rst),.b(bus),.b_reg(b_reg),.breg_in(breg_in));
    alu ALU (.rst(rst),.result_out(bus),.a_reg(a_reg),.b_reg(b_reg),.alu_out(alu_out),.alu_op(alu_op),.carry_out(carry_out),.zero_out(zero_out));
    flag_reg FR(.clk(clk),.rst(rst),.flag_en(flag_en),.carry_out(carry_out),.zero_out(zero_out),.zero_f(zero_f),.carry_f(carry_f));
    input_register INPREG(.clk(clk),.rst(rst),.input_out(input_out),.data(data),.data_out(bus));
    output_register OREG(.clk(clk),.rst(rst),.out_dis(out_disp),.b(b_out),.out_in(out_in));
   
endmodule
