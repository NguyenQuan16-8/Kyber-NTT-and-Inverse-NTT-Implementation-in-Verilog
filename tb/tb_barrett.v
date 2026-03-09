module tb_barrett;
    reg signed [15:0] a;
    wire signed [15:0] r;

    barrett_reduce uut (
        .a(a),
        .r(r)
    );

    initial begin
             a = 3329;        #10 $display("%12d | %d", a, r);
        a = 3328;        #10 $display("%12d | %d", a, r);
        a = 6658;        #10 $display("%12d | %d", a, r);
        a = (1 << 16);   #10 $display("%12d | %d", a, r);
        a = (1 << 16)+1; #10 $display("%12d | %d", a, r);
        a = -3329;       #10 $display("%12d | %d", a, r);
        a = -1;          #10 $display("%12d | %d", a, r);
        a = 123456789;   #10 $display("%12d | %d", a, r);
a = 43562343;   #10 $display("%12d | %d", a, r);
a = -43562343;   #10 $display("%12d | %d", a, r);
a = 32323232;   #10 $display("%12d | %d", a, r);
a = -32323232;   #10 $display("%12d | %d", a, r);
        $finish;
    end
endmodule

