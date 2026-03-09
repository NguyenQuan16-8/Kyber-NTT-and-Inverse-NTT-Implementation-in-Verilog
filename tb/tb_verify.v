`timescale 1ns/1ps

module tb_verify;

    parameter WIDTH_DATA = 16; // ?? test nhanh, b?n ??i 8704 khi synthesize

    reg clk;
    reg reset;
    reg start;
    reg [WIDTH_DATA-1:0] a;
    reg [WIDTH_DATA-1:0] b;
    wire done;
    wire equal;

    // DUT
    verify #(
        .WIDTH_DATA(WIDTH_DATA)
    ) uut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .a(a),
        .b(b),
        .done(done),
        .equal(equal)
    );

    // clock 10ns
    always #5 clk = ~clk;

    initial begin
        // init
        clk   = 0;
        reset = 1;
        start = 0;
        a     = 0;
        b     = 0;
        #20;
        reset = 0;

        // =====================
        // TEST CASE 1: a == b
        // =====================
        a = 16'b1010101010101010;
        b = 16'b1010101010101010;
        start = 1;
        #200; // ch? ?? chu k?
        $display("Case 1: done=%0d equal=%0d (expect equal=1)", done, equal);

        // =====================
        // TEST CASE 2: a != b
        // =====================
        reset = 1; #20; reset = 0; // reset l?i
        a = 16'b1010101010101010;
        b = 16'b1010101010101011; // khác 1 bit
        start = 1;
        #200;
        $display("Case 2: done=%0d equal=%0d (expect equal=0)", done, equal);

        $finish;
    end
endmodule

