`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/09/2025 03:11:10 PM
// Design Name: 
// Module Name: alu
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module alu(
    input clk,
    input reset,
    input start,
    input [4:0] opcode,
    input [31:0] op1,
    input [31:0] op2,
    
    output reg [31:0] out1,
    output reg [31:0] out2,
    output reg [3:0] flags,
    output reg done

    );
    
   //operations 
    parameter ADD = 5'd0;       
    parameter SUB = 5'd1;  
    parameter ADDC = 5'd2;
    parameter MULS = 5'd3;
    parameter MULU = 5'd4;
    parameter DIVS = 5'd5;
    parameter DIVU = 5'd6;
    parameter AND = 5'd7;
    parameter OR = 5'd8;
    parameter XOR = 5'd9;
    parameter NOT = 5'd10;
    parameter SL = 5'd11;
    parameter SR = 5'd12;
    parameter ASR = 5'd13;
    parameter INC = 5'd14;
    parameter DEC = 5'd15;
    parameter MODS = 5'd16;
    parameter MODU = 5'd17;
    parameter ABS = 5'd18;
    parameter CMP = 5'd19;
        
  
        
    
    //adder input wires    
    reg [31:0] adder_op1;
    reg [31:0] adder_op2;
    reg adder_sub; 
    reg adder_cin;
    
    //adder output wires
    wire [3:0] adder_flags;
    wire [31:0] adder_output;
    
    adder alu_adder (
        .clk(clk),
        .reset(reset),
        .in1(adder_op1),
        .in2(adder_op2),
        .sub(adder_sub),
        .carry_in(adder_cin),
        .negative(adder_flags[0]),
        .zero(adder_flags[1]),
        .overflow_signed(adder_flags[2]),
        .carry_out(adder_flags[3]),
        .sum(adder_output)
    );
    
    
    //multiplier inputs
    reg mult_start;
    reg [31:0] mult_op1;
    reg [31:0] mult_op2;
    reg mult_sign;
    reg mult_ack;
    
    //multiplier outputs
    wire [63:0] mult_result;
    wire mult_product_ready;
    wire [1:0] mult_flags;

              
    multiplier alu_mult(
        .clk(clk),
        .reset(reset),
        .in1(mult_op1),
        .in2(mult_op2),
        .sign(mult_sign),
        .start(mult_start),
        .ack(mult_ack),
        .result(mult_result),
        .product_ready(mult_product_ready),
        .neg(mult_flags[0]),
        .zero(mult_flags[1])    
    );
    
    
    
    
    //unsigned divider inputs
    reg [31:0] divu_op1;
    reg [31:0] divu_op2;
    reg divu_start;
    reg divu_ack;
    
    //unsiged divider outputs
    wire divu_done;
    wire [31:0] divu_quot;
    wire [31:0] divu_remain;
    wire divu_div_by_zero;
    wire divu_zero_flag;
    
    divider_unsigned alu_divu(
        .clk(clk),
        .reset(reset),
        .a(divu_op1),
        .b(divu_op2),
        .start(divu_start),
        .ack(divu_ack),
        .done(divu_done),
        .quot(divu_quot),
        .remainder(divu_remainder),
        .div_by_zero(divu_div_by_zero),
        .zero(divu_zero_flag)
    );
    
    
    
    
      
    //signed divider inputs
    reg [31:0] divs_op1;
    reg [31:0] divs_op2;
    reg divs_start;
    reg divs_ack;
    
    //signed divider outputs
    wire divs_done;
    wire [31:0] divs_quot;
    wire [31:0] divs_remain;
    wire divs_div_by_zero;
    wire divs_zero_flag;
    wire divs_neg_flag;
    
    divider_signed alu_divs(
        .clk(clk),
        .reset(reset),
        .a(divs_op1),
        .b(divs_op2),
        .start(divs_start),
        .ack(divs_ack),
        .done(divs_done),
        .quot(divs_quot),
        .remainder(divs_remainder),
        .div_by_zero(divs_div_by_zero),
        .zero(divs_zero_flag),
        .neg(divs_neg_flag)
    );
    
          
     //states
     parameter IDLE = 2'b00;
     parameter WAITING  =2'b01;
     parameter DONE = 2'b10;
     parameter ONE_DELAY = 2'b11;
     
     reg [1:0] state;
     
     
     reg internal_done;
     reg internal_start;
     reg internal_ack;
     
     
    
    always @(posedge clk) begin
        if (reset) begin
            adder_op1 <= 0; 
            adder_op2 <= 0;  
            adder_sub <= 0;         
            adder_cin <= 0;    
            
            mult_start <= 0;             
            mult_op1 <= 0;
            mult_op2 <= 0;
            mult_sign <= 0;      
            mult_ack <= 0;
            
            divu_op1 <=0; 
            divu_op2 <=0;
            divu_start <= 0;           
            divu_ack <= 0; 
            
            divs_op1 <=0 ;  
            divs_op2 <=0;        
            divs_start <=0;
            divs_ack <= 0; 
            
            out1 <= 0; 
            out2 <= 0;
            flags <= 0;
            state <= IDLE;
        end
        else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        case (opcode)
                            ADD: begin
                                adder_op1 <= op1;
                                adder_op2 <= op2;
                                adder_cin <= 1'b0;
                                adder_sub <= 1'b0;
                                out1 <= adder_output;
                                flags <= adder_flags;
                                state  <= DONE;
                            end
                            SUB : begin
                                adder_op1 <= op1;
                                adder_op2 <= op2;
                                adder_cin <= 1'b0;
                                adder_sub <= 1'b1;
                                out1 <= adder_output;
                                flags <= adder_flags;
                                state <= DONE;
                            end
                            ADDC  : begin
                                adder_op1 <= op1;
                                adder_op2 <= op2;
                                adder_cin <= flags[3];
                                adder_sub <= 1'b0;
                                out1 <= adder_output;
                                flags <= adder_flags;
                                state <= DONE;    
                            end
                            MULS, MULU  : begin
                            end
                            
                            DIVS  : begin
                            end
                            DIVU  : begin
                            end
                            AND   : begin
                                out1 <= op1 & op2;
                            end
                            OR    : begin
                                out1 <= op1 | op2;
                            end
                            XOR   : begin
                                out1 <= op1 ^ op2;
                            end
                            NOT   : begin
                                out1 <= ~op1;
                            end
                            SL    : begin
                                out1 <= op1 << op2;
                            end
                            SR    : begin
                                out1 <= op1 >> op2;
                            end
                            ASR   : begin
                                out1 <= op1 >>> op2;
                            end
                            INC   : begin
                                adder_op1 <= op1;
                                adder_op2 <= 32'b1;
                                adder_cin <= 1'b0;
                                adder_sub <= 1'b0;
                                out1 <= adder_output;
                                flags <= adder_flags;
                                state <= DONE;  
                            end
                            DEC   : begin
                                adder_op1 <= op1;
                                adder_op2 <= 32'b1;
                                adder_cin <= 1'b0;
                                adder_sub <= 1'b1;
                                out1 <= adder_output;
                                flags <= adder_flags;
                                state <= DONE;  
                            end
                            MODS  : begin
                            end
                            MODU  : begin
                            end
                            ABS   : begin
                                out1 <= (op1 < 0) ? -op1 : op1;
                            end
                            CMP   : begin
                                adder_op1 <= op1;
                                adder_op2 <= op2;
                                adder_cin <= 1'b0;
                                adder_sub <= 1'b1;
                                flags <= adder_flags;
                                state <= DONE;
                            end
                            
                        endcase
                    end
                end
                

                
                WAITING: begin
                end
                
                
                DONE: begin
                end
                
            endcase
        end
    end
    
    
    
    
    
    
    
    
    
    
endmodule
