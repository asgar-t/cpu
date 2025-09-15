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
    input sign, //signed or unsigned multiplication
    
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
        if (reset) begin //reset values
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
            //if start signal is set, and we are not currently multiplying anything than
            //we can begin multiplying
            if (start && !busy && !ack && !product_ready) begin
                //signed or unsigned 
                multiplicand <= (sign && in1[31]) ? -in1 : in1;
                //count number of cycles
                count        <= 6'd0;
                //initialize result register for multiplicatoin
                result <= (sign && in2[31]) ? {32'd0, -in2} : {32'd0, in2};
                
                //set status flags
                busy         <= 1'b1;
                op_done         <= 1'b0;
                product_ready <= 1'b0;
                zero <= 1'b0;
                neg <= 1'b0;

                //for final step
                prod_sign <= (in2[31] ^ in1[31]) && sign;

            end
            else if (busy) begin //multiplying state
                
                if (result[0]) begin
                    temp = (result + {multiplicand, 32'b0}) >> 1; // add and shift
                end 
                else begin
                    temp = result >> 1; //just shift, as per multiplying algorithm
                end
                count <= count + 1; //increment
                
                if (count == 6'd31) begin //done with multiplying
                
                    product_ready <= 1'b1; //set flag
                    
                    //blocking assignment so we do not have to wait an extra cycle
                    temp1= prod_sign ? -temp : temp; 
                    
                    result <= temp1; //store
                    neg <= temp1[63]; //flag

                    zero <= (temp1 == 64'b0); // flag
                    busy <= 1'b0; //internal flag
                end
                else begin
                    result <= temp; //update value, continue multiplying if not done
                end
            end
            else if (product_ready) begin
                busy <= 1'b0;
                //wait for acknowledgement, reset values
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

    
endmodule
