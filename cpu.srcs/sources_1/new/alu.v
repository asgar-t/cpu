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
    input [4:0] opcode,
    input op1,
    input op2,
    
    output reg out1,
    output reg out2,
    output reg [3:0] flags

    );
    
    
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
    wire [31:0] adder_op1;
    wire [31:0] adder_op2;
    wire adder_sub; 
    wire adder_cin;
    
    //adder output wires
    wire [3:0] adder_flags;
    wire [31:0] adder_output;
    
    adder alu_adder (
        .in1(adder_op1),
        .in2(adder_op2),
        .sub(adder_sub),
        .carry_in(adder_cin),
        .negative(adder_flags[0]),
        .zero(adder_flags[1]),
        .overflow_signed(adder_flags[2]),
        .carry_out(adder_flags[3])
    );
    
    
        
    
    
    
    
    
    
    
    
    
    
endmodule
