`timescale 1ns/1ps

module tb_fqmul;

    reg  signed [15:0] a, b;
    wire signed [15:0] out;

    // Instantiate fqmul DUT
    fqmul uut (
        .a(a),
        .b(b),
        .out(out)
    );

    integer i, j;

    // Test vectors
    reg signed [15:0] test_a[0:7];
    reg signed [15:0] test_b[0:7];
    reg signed [15:0] expected[0:7][0:7]; // n?u có expected value, fill vào

    initial begin
        // Ví d? các giá tr? test
        test_a[0] = 3328;       test_b[0] = -1;
        test_a[1] = 3328;     test_b[1] = 1234;
        test_a[2] = 1234;    test_b[2] = -1;
        test_a[3] = 1234;    test_b[3] = 3329;
        test_a[4] = -1234;   test_b[4] = 3329;
        test_a[5] = 1234;    test_b[5] = 1234;
        test_a[6] = 0;   test_b[6] = 3329;
        test_a[7] = -1;   test_b[7] = 3329;

        $display("=== Start fqmul test ===");

        for(i = 0; i < 8; i = i + 1) begin
            a = test_a[i];
            b = test_b[i];
            #10; // wait for combinational
            $display("%d | %d | %d", a, b, out);
            // N?u có expected: if(out != expected[i]) $display("FAIL! ...");
        end

        $display("=== End fqmul test ===");
        $finish;
    end

endmodule
