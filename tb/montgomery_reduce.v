module montgomery_reduce (
    input  wire signed [31:0] a,
    output wire signed [15:0] t
);

    parameter signed [15:0] Q     = 3329;
    parameter [15:0] QINV  = 62209; // -q^(-1) mod 2^16

    wire signed [15:0] t1;
    wire signed [31:0] u;

    assign t1 = (a * QINV) & 16'hFFFF;
    assign u = (a - t1 * Q) >>> 16;
    assign t = u[15:0];  

endmodule

