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
    input clk,
    output reg negative,
    output reg zero,
    output reg overflow_signed,
    output reg carry_out,
    output reg [31:0] sum
    );
    
    wire [31:0] op2 = sub ? ~in2 : in2;
    wire carry  = sub ? 1'b1 : carry_in;
    
    reg [31:0] tmp_sum;
    reg tmp_carry;

    always @(*) begin

        
        {tmp_carry, tmp_sum} = in1 + op2 + carry;
    
        carry_out       = tmp_carry;
        sum             = tmp_sum;
        overflow_signed = (in1[31] == op2[31]) && (tmp_sum[31] != in1[31]);
        negative        = tmp_sum[31] && (!sub);
        zero            = (tmp_sum == 0);
    end

    
    
    
    
    
endmodule
