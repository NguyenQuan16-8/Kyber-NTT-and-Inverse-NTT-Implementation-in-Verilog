module verify #(
    parameter WIDTH_DATA = 8704
)(
    input  wire        clk,
    input  wire        reset,
    input  wire        start,
    input  wire [WIDTH_DATA-1:0] a,
    input  wire [WIDTH_DATA-1:0] b,
    output reg         done,
    output reg         equal
);

    reg r;  
    reg [$clog2(WIDTH_DATA):0] count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            r     <= 0;
            count <= 0;
            done  <= 0;
            equal <= 0;
        end else if (start) begin
            if (count < WIDTH_DATA) begin
                if (count == 0) begin
                    r     <= 0;    // reset r t?i l?n b?t ??u
                    done  <= 0;
                end
                r     <= r | (a[count] ^ b[count]);
                count <= count + 1;
            end else begin
                done  <= 1;
                equal <= (r == 0); // 1 n?u b?ng nhau
            end
        end
    end
endmodule

