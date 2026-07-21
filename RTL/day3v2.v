module pulse_sync_handshake (
    input  logic clk_src,
    input  logic rst_src_n,
    input  logic src_pulse,
    output logic src_busy,    // NEW: backpressure contract
    input  logic clk_dst,
    input  logic rst_dst_n,
    output logic dst_pulse
);
    logic toggle_src;

    // Launch only when idle. A pulse arriving while busy is REFUSED.
    always_ff @(posedge clk_src or negedge rst_src_n) begin
        if (!rst_src_n)                  toggle_src <= 1'b0;
        else if (src_pulse && !src_busy) toggle_src <= ~toggle_src;
    end

    // Forward path: src -> dst
    logic fwd_q1, fwd_q2, fwd_q3;
    always_ff @(posedge clk_dst or negedge rst_dst_n) begin
        if (!rst_dst_n) {fwd_q1, fwd_q2, fwd_q3} <= 3'b0;
        else begin
            fwd_q1 <= toggle_src;   // metastable-prone
            fwd_q2 <= fwd_q1;       // clean
            fwd_q3 <= fwd_q2;
        end
    end
    assign dst_pulse = fwd_q2 ^ fwd_q3;

    // Return path: dst echoes the clean toggle back into src domain
    logic ack_q1, ack_q2;
    always_ff @(posedge clk_src or negedge rst_src_n) begin
        if (!rst_src_n) {ack_q1, ack_q2} <= 2'b0;
        else begin
            ack_q1 <= fwd_q2;       // metastable-prone
            ack_q2 <= ack_q1;       // clean
        end
    end

    assign src_busy = toggle_src ^ ack_q2;  // mismatch == in flight
endmodule