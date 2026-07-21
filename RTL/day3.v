// ---------------------------------------------------------------------------
// day03_pulse_sync.sv
//
// Day 3 / RTL Design -- CDC pulse synchronizer (RELAXED SPEC).
//
// Transfers a single-cycle pulse from clk_src into clk_dst, where the two
// clocks are fully asynchronous (arbitrary ratio, drifting phase).
// Each src_pulse produces exactly one single-cycle dst_pulse.
//
// ASSUMPTION (relaxed spec):
//   src_pulse events are separated by >= 2-3 clk_dst periods.
//
//   Why this is required: the destination samples toggle_src once per clk_dst
//   edge. If the toggle flips twice between two consecutive destination edges,
//   the destination observes the same value at both samples, the XOR sees no
//   change, and BOTH events are silently lost. This is a sampling/aliasing
//   limit -- NOT a setup-time limit. Setup violations at the boundary are
//   inherent and unavoidable; the 2-flop synchronizer is what makes them safe.
//
// Under the HARD spec (source faster than destination, pulses possibly on
// consecutive source cycles) this design drops events. That case requires
// closed-loop flow control -- see the handshake variant.
// ---------------------------------------------------------------------------

module pulse_sync (
    // Source domain
    input  logic clk_src,
    input  logic rst_src_n,
    input  logic src_pulse,   // 1-cycle pulse in clk_src domain

    // Destination domain
    input  logic clk_dst,
    input  logic rst_dst_n,
    output logic dst_pulse    // 1-cycle pulse in clk_dst domain
);

    // -----------------------------------------------------------------------
    // Source domain: convert each pulse into a toggle (a level *change*).
    //
    // Encoding "an event happened" as "this signal changed value" means the
    // signal never has to be cleared, which removes any cross-domain race
    // over who resets it.
    // -----------------------------------------------------------------------
    logic toggle_src;

    always_ff @(posedge clk_src or negedge rst_src_n) begin
        if (!rst_src_n)
            toggle_src <= 1'b0;
        else if (src_pulse)
            toggle_src <= ~toggle_src;
    end

    // -----------------------------------------------------------------------
    // Destination domain: 2-flop synchronizer, then edge detect.
    //
    //   sync_q1 : samples the asynchronous signal -- MAY GO METASTABLE.
    //             Must fan out to sync_q2 and nothing else. If a metastable
    //             value reaches two loads, they can resolve to opposite
    //             values and the design forks into an inconsistent state.
    //   sync_q2 : sync_q1 has had a full clk_dst period to settle -- clean.
    //   sync_q3 : NOT part of the synchronizer. An ordinary delay flop,
    //             entirely inside the destination domain, used only to
    //             compare "now" against "one cycle ago".
    //
    // Synthesis note: mark sync_q1/sync_q2 for the tools, e.g.
    //   (* ASYNC_REG = "TRUE" *)  on Xilinx, and constrain the
    //   toggle_src -> sync_q1 arc with set_false_path / set_max_delay so the
    //   timing tool does not try to close timing on an inherently async path.
    // -----------------------------------------------------------------------
    logic sync_q1, sync_q2, sync_q3;

    always_ff @(posedge clk_dst or negedge rst_dst_n) begin
        if (!rst_dst_n) begin
            sync_q1 <= 1'b0; // here sync_q1 should not fan out to anything else except sync_q2 since it is prone to metastability. 
            sync_q2 <= 1'b0;
            sync_q3 <= 1'b0;
        end else begin
            sync_q1 <= toggle_src;
            sync_q2 <= sync_q1;
            sync_q3 <= sync_q2;
        end
    end

    // Any change on the toggle -- rise OR fall -- is exactly one source event.
    assign dst_pulse = sync_q2 ^ sync_q3;

endmodule