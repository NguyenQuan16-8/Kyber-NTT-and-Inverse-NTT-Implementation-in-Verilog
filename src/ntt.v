module ntt(
    input clk, reset,
    input start,

    // Handshake input
    input              data_in_valid,
    output reg         data_in_ready,
    input  signed [15:0] data_in,

    // Handshake output
    output reg signed [15:0] data_out,
    output reg               data_out_valid,
    input                    data_out_ready,

    output reg done
);

reg signed [15:0] r [0:255];
reg signed [15:0] t, zeta;
reg [7:0] len;
reg [8:0] start_idx;
reg [8:0] j;
reg [7:0] k;
reg [8:0] write_idx;
reg [8:0] read_idx;
wire signed [15:0] fqmul_out;
wire signed [15:0] zeta_out;
reg [3:0] state;
reg [1:0] counter_done;

zeta_rom zeta_rom_inst(
    .index(k),
    .zeta_out(zeta_out)
);

fqmul fqmul_inst(
    .a(zeta),
    .b(r[j + len]),
    .out(fqmul_out)
);

parameter WAIT        = 4'd0;
parameter LOAD_DATA   = 4'd1;
parameter LOOP_3      = 4'd2;
parameter LOOP_2      = 4'd3;
parameter LOOP_1      = 4'd4;
parameter WAIT_FQMUL  = 4'd5;
parameter UPDATE      = 4'd6;
parameter WRITE_DATA  = 4'd7;
parameter DONE        = 4'd8;

// Logic
always @(posedge clk or posedge reset) begin
    if (reset) begin
        len <= 0;
        t <= 0;
        zeta <= 0;
        k <= 0;
        write_idx <= 0;
        read_idx <= 0;
        done <= 0;
        start_idx <= 0;
        j <= 0;
        data_out <= 0;
        counter_done <= 0;
        data_out_valid <= 0;
        data_in_ready  <= 0;
        state <= WAIT;
    end else begin
        case (state)
            WAIT: begin
                len <= 8'd128;
                t <= 0;
                zeta <= 0;
                k <= 1; 
                write_idx <= 0;
                read_idx <= 0;
                done <= 0;
                start_idx <= 0;
                j <= 0;
                data_out <= 0;
                counter_done <= 2;
                data_out_valid <= 0;
                data_in_ready  <= 0;
                if (start) begin
                    data_in_ready <= 1;   // cho phép nh?n input
                    state <= LOAD_DATA;
                end else begin
                    state <= WAIT;
                end
            end

            LOAD_DATA: begin
                if (data_in_valid && data_in_ready) begin
                    r[write_idx] <= data_in;
                    write_idx <= write_idx + 1;

                    if (write_idx == 255) begin
                        data_in_ready <= 0; // ng?ng nh?n thêm
                        state <= LOOP_3;
                    end else begin
                    	data_in_ready <= 1;
                        state <= LOAD_DATA;
                    end
                end
            end

            LOOP_3: begin	
                if (len >= 2) begin
                    start_idx <= 0;
                    state <= LOOP_2;
                end else begin
                    state <= WRITE_DATA;
                end
            end

            LOOP_2: begin
                if (start_idx < 256) begin
                    zeta <= zeta_out;
                    j <= start_idx;
                    state <= LOOP_1;
                end else begin
                    len <= len >> 1;
                    state <= LOOP_3;
                end
            end

            LOOP_1: begin
                if (j < start_idx + len) begin
                    state <= WAIT_FQMUL;
                end else begin
                    k <= k + 1; 
                    start_idx <= j + len;
                    state <= LOOP_2;
                end
            end

            WAIT_FQMUL: begin	
                t     <= fqmul_out;
                state <= UPDATE;
            end

            UPDATE: begin
                r[j + len] <= r[j] - t;
                r[j]       <= r[j] + t;
                j <= j + 1;
                state <= LOOP_1;
            end

            WRITE_DATA: begin
                if (!data_out_valid) begin
                    if (read_idx < 256) begin
                        data_out <= r[read_idx];
                        data_out_valid <= 1;
                    end else begin
                        data_out_valid <= 0;
                        state <= DONE;
                    end
                end else if (data_out_valid && data_out_ready) begin
                    read_idx <= read_idx + 1;
                    data_out_valid <= 0;
                end
            end

            DONE: begin
                if (counter_done > 0) begin
                    done <= 1;
                    counter_done <= counter_done - 1;
                    state <= DONE;
                end else begin
                    state <= WAIT;
                end
            end
        endcase
    end
end
endmodule

