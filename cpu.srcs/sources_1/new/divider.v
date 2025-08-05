module divider(
    input clk,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] quot,
    output reg [31:0] remainder
    );

    // Internal wire to hold combined remainder+quotient from IP
    wire [63:0] div_result;

    
    // Separate the combined 64-bit result into remainder and quotient
    always @(posedge clk) begin
        // Assign output ports from internal wire
        quot <= div_result[31:0];
        remainder <= div_result[63:32];
    end

endmodule
