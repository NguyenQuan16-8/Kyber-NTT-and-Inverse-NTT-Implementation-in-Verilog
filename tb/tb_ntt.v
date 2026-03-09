`timescale 1ns/1ps

module tb_ntt;
    reg clk;
    reg reset;
    reg start;

    // Handshake input
    reg              data_in_valid;
    wire             data_in_ready;
    reg  signed [15:0] data_in;

    // Handshake output
    wire signed [15:0] data_out;
    wire               data_out_valid;
    reg                data_out_ready;

    wire done;

    // Instantiate DUT
    ntt dut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .data_in_valid(data_in_valid),
        .data_in_ready(data_in_ready),
        .data_in(data_in),
        .data_out(data_out),
        .data_out_valid(data_out_valid),
        .data_out_ready(data_out_ready),
        .done(done)
    );

    // Clock
    always #5 clk = ~clk; // 100MHz

    integer i;

    initial begin
        // Kh?i t?o
        clk = 0;
        reset = 1;
        start = 0;
        data_in = 0;
        data_in_valid = 0;
        data_out_ready = 1;

        #20;
        reset = 0;

        // B?t ??u
        #20;
        start = 1;
        #10;
        start = 0;

        // G?i 256 giá tr? 1..256
        for (i = 1; i <= 256; i = i + 1) begin
            @(posedge clk);
            if (data_in_ready) begin
                data_in <= i;
                data_in_valid <= 1;
                @(posedge clk);
                data_in_valid <= 0;
            end
        end

        // Nh?n d? li?u ??u ra
        i = 0;
        while (i < 256) begin
            @(posedge clk);
            if (data_out_valid) begin
                $display("Output[%0d] = %d", i, data_out);
                i = i + 1;
            end
        end

        // K?t thúc
        #100;
        $display("Simulation Done.");
        $stop;
    end

endmodule

