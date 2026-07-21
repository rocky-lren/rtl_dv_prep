# RTL / DV Interview Prep — Daily Log

**Target:** Apple/Nvidia-caliber **entry-level** RTL Design / Design Verification roles.
**Job search start:** ~late August 2026.
**Format:** one interview question per evening, alternating **RTL Design ↔ DV**, hints-on-tap (solution held until you attempt or ask).

**Track selection rule (for the daily task):** look at the most recent row below and alternate to the other track. If the table is empty, start with RTL Design.

| Day | Date | Track | Topic / Question | Status |
|-----|------------|----------------|-----------------------------------------------------------|-----------|
| 1 | 2026-06-29 | RTL Design | Overlapping sequence detector `1011` (Moore/Mealy, synthesizable SV) | Delivered |
| 2 | 2026-06-29 | Design Verification | SVA for `valid`/`ready` handshake: valid-persistence, data-stability, liveness | Delivered |
| 3 | 2026-06-30 | RTL Design | CDC pulse synchronizer: single-cycle pulse across async clocks (toggle vs handshake) | Delivered |
| 4 | 2026-07-01 | Design Verification | Constrained-random packet class: SV constraints (dist, implication `->`, dynamic-array size, `solve..before`) | Delivered |
| 5 | 2026-07-02 | RTL Design | Round-robin arbiter, 4 requesters (fairness, pointer update, synthesizable SV) | Delivered |
| 6 | 2026-07-03 | Design Verification | UVM scoreboard for packet DUT (in-order vs OOO matching, analysis ports, end-of-test drain) | Delivered |
| 7 | 2026-07-04 | RTL Design | Asynchronous FIFO: dual-clock, Gray-code pointers, full/empty generation | Delivered |
| 8 | 2026-07-05 | Design Verification | Implement `randc` behavior without `randc` (SV class, randomization, constraints) | Delivered |
| 9 | 2026-07-06 | RTL Design | Divide-by-3 clock divider, 50% duty cycle (odd-division, both-edge technique) | Delivered |
| 10 | 2026-07-07 | Design Verification | Functional coverage: covergroup for memory-bus txn (bins, cross, ignore/illegal bins, transition, sampling) | Delivered |
| 11 | 2026-07-08 | RTL Design | Glitch-free clock mux: switch between two async clocks without runt pulses | Delivered |
| 12 | 2026-07-09 | Design Verification | UVM driver for credit-based valid/ready channel (sequencer-driver handshake, reset handling) | Delivered |
| 13 | 2026-07-12 | RTL Design | Parameterized priority encoder: N-bit input → binary index of highest set bit + valid (synthesizable SV) | Delivered |
| 14 | 2026-07-13 | Design Verification | Synchronous FIFO SVA: overflow/underflow protection, flag correctness, pointer stability, data integrity, reset (concurrent assertions, `|->`/`|=>`, `$past`, `disable iff`) | Delivered |

**Next up:** Day 15 (2026-07-14) → **RTL Design**.
