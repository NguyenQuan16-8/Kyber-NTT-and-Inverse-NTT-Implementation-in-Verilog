module fqmul (
    input wire signed [15:0] a,
    input wire signed [15:0] b,
    output wire signed [15:0] out
);
    wire signed [31:0] tmp;
    wire signed [15:0] montgomery_out;

    assign tmp = a * b;

    montgomery_reduce mont (
        .a(tmp),
        .t(montgomery_out)
    );

    assign out = montgomery_out;
endmodule
