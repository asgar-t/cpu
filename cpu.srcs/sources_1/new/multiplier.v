`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/28/2025 09:41:09 AM
// Design Name: 
// Module Name: multiplier
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

//test
module multiplier(
    input clk,
    input reset,
    
    input start,
    input ack,
    input [31:0] in1,
    input [31:0] in2,
    
    output reg [63:0] result,
    output reg product_ready,
    output reg zero
    );
    
    //internal - captures state on start
    reg [31:0] multiplicand;
    reg [63:0]  temp;
    reg [5:0] count;         
    reg busy;
    reg op_done;
    
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            multiplicand <= 32'd0;
            result       <= 64'd0;
            count        <= 6'd0;
            busy         <= 1'b0;
            op_done         <= 1'b0;
            product_ready   <= 1'b0;
            zero <= 1'b0;
        end
        else begin
            if (start && !busy && !ack && !product_ready) begin
                multiplicand <= in1;
                count        <= 6'd0;
                result <= {32'd0, in2};
                busy         <= 1'b1;
                op_done         <= 1'b0;
                product_ready <= 1'b0;
                zero <= 1'b0;

            end
            else if (busy) begin
                if (result[0]) begin
                    temp = (result + {multiplicand, 32'b0}) >> 1;
                end 
                else begin
                    temp = result >> 1;
                end
                result <= temp;
                count <= count + 1;
                if (count == 6'd31) begin //pretty sure can make it 30
                    product_ready <= 1'b1;
                    zero <= (temp == 64'b0);
                    busy <= 1'b0;
                end
            end
            else if (product_ready) begin
                busy <= 1'b0;

                if (ack) begin
                    product_ready <= 1'b0;
                end
            end
        end
        
    end
    
//    always @(*) begin
//        if (product[0]) begin
//            temp = product + {multiplicand, 32'b0};
//        end
//        else begin
//            temp = product;
//        end 
//    end    

    
    
endmodule
