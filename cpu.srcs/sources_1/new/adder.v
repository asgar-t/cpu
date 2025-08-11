`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/24/2025 05:43:21 PM
// Design Name: 
// Module Name: adder
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


module adder(
    input [31:0] in1,
    input [31:0] in2,
    input sub,
    input carry_in,
    output negative,
    output zero,
    output overflow_signed,
    output carry_out,
    output [31:0] sum
    );
    
    wire [31:0] op2 = sub ? ~in2 : in2;
    wire carry  = sub ? 1'b1 : carry_in;
    
    assign {carry_out, sum} = in1 + op2 + carry;
    assign overflow_signed = (in1[31] == op2[31]) && (sum[31] != in1[31]);
    assign negative = sum[31] && (!sub);
    assign zero = (sum == 0);
    
    
    
    
    
endmodule
