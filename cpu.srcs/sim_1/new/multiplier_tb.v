`timescale 1ns / 1ps

module multiplier_tb;

    // Testbench signals
    reg clk = 0;
    reg reset = 0;
    reg start = 0;
    reg ack = 0;
    reg [31:0] in1 = 0;
    reg [31:0] in2 = 0;
    reg sign;

    
    wire [63:0] result;
    wire product_ready;
    wire zero;
    wire neg;
    // Instantiate DUT
    multiplier uut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .ack(ack),
        .in1(in1),
        .in2(in2),
        .result(result),
        .product_ready(product_ready),
        .zero(zero),
        .sign(sign),
        .neg(neg)
    );

    // Clock generation
    always #5 clk = ~clk;  // 100 MHz clock (10 ns period)

    // Task to apply a test vector
    task multiply_input;
        input [31:0] a;
        input [31:0] b;
        input sign_val;
        begin
            in1 = a;
            in2 = b;
            start = 1;
            sign = sign_val;
            @(posedge clk);  // wait 1 clock
            start = 0;

            // Wait for product_ready
            while (!product_ready) @(posedge clk);

            $display("in1 = %0d, in2 = %0d, result = %0d (hex: %h)", $signed(in1), $signed(in2), $signed(result), result);

            // Acknowledge
            ack = 1;
            @(posedge clk);
            ack = 0;

            // Wait for product_ready to drop
            while (product_ready) @(posedge clk);
        end
    endtask

    // Initial test sequence
    initial begin
        // Dump waveform if using GTKWave or ModelSim
        $dumpfile("multiplier_tb.vcd");
        $dumpvars(0, multiplier_tb);

        // Apply reset
        reset = 1;
        repeat (2) @(posedge clk);
        reset = 0;

        // Test cases
        multiply_input(32'd5, 32'd3,0);
        multiply_input(32'd0, 32'd100,0);
        multiply_input(32'd123456, 32'd654321,0);
        multiply_input(-32'sd10, 32'sd12,1);
        multiply_input(32'sd10, 32'sd12,1);



        // Unsigned MSB = 1 (large unsigned)
//        multiply_input(32'hFFFF_FFFF, 32'd2);



        $display("Simulation complete.");
        $finish;
    end

endmodule
