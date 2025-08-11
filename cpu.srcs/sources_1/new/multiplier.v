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

module multiplier(
    input clk,
    input reset,
    
    input start,
    input ack,
    input [31:0] in1,
    input [31:0] in2,
    input sign,
    
    output reg [63:0] result,
    output reg product_ready,
    output reg zero,
    output reg neg
    );
    
    //internal - captures state on start
    reg [31:0] multiplicand;
    reg [63:0]  temp, temp1;
    reg [5:0] count;         
    reg busy;
    reg op_done;
    reg prod_sign;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            multiplicand <= 32'd0;
            result       <= 64'd0;
            count        <= 6'd0;
            busy         <= 1'b0;
            op_done         <= 1'b0;
            product_ready   <= 1'b0;
            zero <= 1'b0;
            neg <= 1'b0;
            prod_sign <= 0;

        end
        else begin
            if (start && !busy && !ack && !product_ready) begin
                multiplicand <= (sign && in1[31]) ? -in1 : in1;
                count        <= 6'd0;
                result <= (sign && in2[31]) ? {32'd0, -in2} : {32'd0, in2};
                busy         <= 1'b1;
                op_done         <= 1'b0;
                product_ready <= 1'b0;
                zero <= 1'b0;
                neg <= 1'b0;

                prod_sign <= (in2[31] ^ in1[31]) && sign;

            end
            else if (busy) begin
                if (result[0]) begin
                    temp = (result + {multiplicand, 32'b0}) >> 1;
                end 
                else begin
                    temp = result >> 1;
                end
                count <= count + 1;
                if (count == 6'd31) begin //pretty sure can make it 30
                    product_ready <= 1'b1;
                    temp1= prod_sign ? -temp : temp;
                    result <= temp1;
                    neg <= temp1[63];

                    zero <= (temp == 64'b0);
                    busy <= 1'b0;
                end
                else begin
                    result <= temp;
                end
            end
            else if (product_ready) begin
                busy <= 1'b0;

                if (ack) begin
                    product_ready <= 1'b0;
                    multiplicand <= 32'd0;
                    result       <= 64'd0;
                    count        <= 6'd0;
                    busy         <= 1'b0;
                    op_done         <= 1'b0;
                    product_ready   <= 1'b0;
                    zero <= 1'b0;
                    neg <= 1'b0;
                    prod_sign <= 0;
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
