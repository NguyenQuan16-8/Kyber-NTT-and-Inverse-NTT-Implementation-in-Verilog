`timescale 1ns/1ps

module tb_montgomery_reduce;
    reg  signed [31:0] a;
    wire signed [15:0] t;

    // Instantiate DUT
    montgomery_reduce dut (
        .a(a),
        .t(t)
    );

    // Test procedure
    initial begin
        $display("=== Test Montgomery Reduce ===");
        $display(" a (input)      | t (output)");
        $display("-------------------------------");

        // Test cases
        a = 3329;        #10 $display("%12d | %d", a, t);
        a = 3328;        #10 $display("%12d | %d", a, t);
        a = 6658;        #10 $display("%12d | %d", a, t);
        a = (1 << 16);   #10 $display("%12d | %d", a, t);
        a = (1 << 16)+1; #10 $display("%12d | %d", a, t);
        a = -3329;       #10 $display("%12d | %d", a, t);
        a = -1;          #10 $display("%12d | %d", a, t);
        a = 123456789;   #10 $display("%12d | %d", a, t);
a = 43562343;   #10 $display("%12d | %d", a, t);
a = -43562343;   #10 $display("%12d | %d", a, t);
a = 32323232;   #10 $display("%12d | %d", a, t);
a = -32323232;   #10 $display("%12d | %d", a, t);
        $finish;
    end
endmodule

