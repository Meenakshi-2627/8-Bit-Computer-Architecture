
`timescale 1ns / 1ps
module control_unit(
    input clk,rst,
    input SET,
    input [3:0]opcode,
    output reg pc_o,pc_l,pc_e,mar_in,ram_in,ram_out,out_in,flag_en,areg_in,breg_in,areg_out,ir_in,ir_out,zero_f,carry_f,alu_out,input_out,hlt_out,
    output reg [2:0]alu_op
    );
    parameter T0=3'b000,T1=3'b001,T3=3'b011,T4=3'b100,T5=3'b101,HLT=3'b010;
    reg [2:0]state,next_state;
    
    always@(posedge clk)begin
        if (rst)begin
            state<=T0;
            {pc_o,pc_l,pc_e,mar_in,ram_in,ram_out,out_in,flag_en,areg_in,breg_in,areg_out,ir_in,ir_out,zero_f,carry_f,alu_out,input_out,alu_op[2:0],hlt_out}<=0;
            end
            
        if(SET) 
          
{pc_o,pc_l,pc_e,mar_in,ram_in,ram_out,out_in,flag_en,areg_in,breg_in,areg_out,ir_in,ir_out,zero_f,carry_f,alu_out,input_out,alu_op[2:0],hlt_out}<=0;
   
        else
           begin
           state <= next_state;
           end
           end
          
           always@(*)
              begin
            {pc_o,pc_l,pc_e,mar_in,ram_in,ram_out,out_in,flag_en,areg_in,breg_in,areg_out,ir_in,ir_out,zero_f,carry_f,alu_out,input_out}<=0;
            case(state)
                T0: begin
                        pc_o=1;
                        mar_in=1;
                        next_state=T1;
                    end
                T1: begin
                        ram_out=1;
                        ir_in=1;
                        pc_e=1;
                        next_state<=T3;
                    end
               
                T3: begin
                        casex(opcode)
                            4'b0000: begin
                                input_out=1;
                                areg_in=1;
                                next_state=T0;
                                end
                            4'b0001: begin
                                areg_out=1;
                                out_in=1;
                                next_state=T0;
                                end
                            4'b0010: begin
                                ir_out=1;
                                mar_in=1;
                                next_state=T4;
                                end
                            4'b0011: begin
                                ir_out=1;
                                mar_in=1;
                                next_state=T4;
                                end
                            4'b0100: begin
                                areg_in=1;
                                ir_out=1;
                                next_state=T0;
                                end
                            4'b0101: begin
                                    hlt_out = 1;
                                    next_state = HLT;
                                end
                            4'b0110: begin
                                ir_out<=1;
                                pc_l<=1;
                                next_state<=T0;
                                end
                            4'b0111:begin
                                if(zero_f)begin 
                                    ir_out<=1;
                                    pc_l<=1;
                                    next_state<=T0;
                                    end
                                else 
                                    next_state<=T0;
                                end
                            4'b1000: begin
                                if(carry_f)begin
                                    ir_out<=1;
                                    pc_l<=1;
                                    next_state<=T0;
                                    end
                                else
                                    next_state<=T0;
                                end
                            4'b1xxx: begin
                                ir_out<=1;
                                mar_in<=1;
                                next_state<=T4;
                                if(opcode==4'b1001) alu_op<=3'b000;
                                if(opcode==4'b1010) alu_op<=3'b001;
                                if(opcode==4'b1011) alu_op<=3'b010;
                                if(opcode==4'b1100) alu_op<=3'b011;
                                if(opcode==4'b1101) alu_op<=3'b100;
                                if(opcode==4'b1110) alu_op<=3'b101;
                                if(opcode==4'b1111) alu_op<=3'b110;
                                end
                        endcase
                    end
                T4: begin
                if(opcode==4'b0010)begin
                    ram_out=1;
                    areg_in=1;
                    next_state=T0;
                    end
                if(opcode==4'b0011)begin
                    areg_out=1;
                    ram_in=1;
                    next_state=T0;
                    end
                else begin
                        ram_out<=1;
                        breg_in<=1;
                        next_state<=T5;
                    end
                    end
                T5: begin
                        alu_out<=1;
                        areg_in<=1;
                        next_state<=T0;
                    end
            endcase
        end
    
         
endmodule
