`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/06/2025 05:54:48 PM
// Design Name: 
// Module Name: divider_unsigned
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


module divider_unsigned(                                                                         
    input clk,                                                                                   
    input [31:0] a,                                                                              
    input [31:0] b,                                                                              
    input start,                                                                                 
    input reset,                                                                                 
    input ack,                                                                                   
                                                                                                 
    output reg done,                                                                             
    output reg [31:0] quot,                                                                      
    output reg [31:0] remainder,                                                                 
    output div_ready,                                                                      
    output reg zero                                                                              
                                                                                                 
    );                                                                                           
    wire nreset;
    reg internal_reset;
    assign nreset = !(reset || internal_reset);                                                                                      
    parameter IDLE = 2'b00;                                                                      
    parameter DIVIDING = 2'b01;                                                                  
    parameter DONE = 2'b11;                                                                      
                                                                                                 
    wire [63:0] div_result;                                                                       
    reg [31:0] divisor;                                                                          
    reg [31:0] dividend;                                                                         
    reg internal_start;                                                                          
    wire internal_done;                                                                           
    wire divisor_ready;
    wire dividend_ready;                                                                           
    reg [1:0] state;                                                                             
                                                                                                 
    unsigned_divider divider_main(                                                               
        .aclk(clk),                                                                              
        .s_axis_divisor_tvalid(internal_start),
        .s_axis_dividend_tvalid(internal_start),                                                  
        .s_axis_divisor_tdata(divisor),                                                          
        .s_axis_dividend_tdata(dividend),                                                        
        .m_axis_dout_tdata(div_result),                                                          
        .m_axis_dout_tvalid(internal_done),                                                      
        .s_axis_divisor_tready(divisor_ready),
        .s_axis_dividend_tready(dividend_ready),
        .aresetn(nreset)                                                        
    );                                                                                           
                                                                                                 
    assign div_ready = dividend_ready && divisor_ready;
                                                                             
    always @(posedge clk) begin                                                 
                                                                                                 
        if (reset) begin                                                                         
            quot <= 0;                                                                        
            remainder <= 0;                                                                       
            done <= 0; 
            zero <= 0;                                                                  
            state <= IDLE; 
            internal_start <= 0;
                                                                      
        end 
        else begin                                                                                     
            case (state)                                                                             
                IDLE: begin
                    internal_reset <= 1'b0;                                                           
                                                                          
                    if (start || internal_start) begin  
                                                                        
                            done <= 1'b0;                                                            
                            dividend <= a;                                                           
                            divisor <= b;
                            internal_start <= 1'b1;  
                                                   
                            if (div_ready) begin                                
                                state <= DIVIDING;  
                                internal_start <= 1'b0;

                            end                                                     
                    end  
                    else begin
                        state <= IDLE;
                    end                                                                            
                end                                                                                  
                DIVIDING: begin                           
                    if (internal_done) begin                                                         
                        remainder <= div_result[31:0];                                                    
                        quot <= div_result[63:32];                                              
                        zero <= (div_result [31:0] == 0);                                            
                        done <= 1'b1;                                                                
                        state <= DONE;
                                                     
                                                             
                    end                                                                              
                end                                                                                  
                DONE: begin    
                    if (ack) begin                                                                   
                        done <= 1'b0;                                                                
                        state <= IDLE; 
                        internal_reset = 0;                                                                      

                                                                                      
                    end                                                                              
                end                                                                                  
                default: begin                                                                       
                    state <= IDLE;                                                                   
                end                                                                                  
                                                                                                     
            endcase
        end                                                                                  
    end                                                                                          
                                                                                                 
endmodule                                                                                        
                                                                                                 