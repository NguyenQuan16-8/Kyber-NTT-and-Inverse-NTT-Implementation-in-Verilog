`define KYBER_Q 3329 
`define V 20159
module barrett_reduce (
input wire signed [15:0] a,
output wire signed [15:0] r
);
wire signed [31:0] t1 = `V*a;
wire signed [31:0] t2 =t1 +32'sd33554432;
wire signed [31:0] t3 = t2 >>> 26;
wire signed [31:0] t4 = t3*`KYBER_Q;
wire signed [31:0] b = (a-t4);
assign r = b[15:0];

endmodule

