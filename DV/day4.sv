

/* kind is an enumeration
*/
typedef enum {READ, WRITE, CONTROL} kind_e;

class Packet;
    rand kind_e kind;
    rand bit [7:0] src; 
    rand bit [7:0] dst; 
    rand byte payload[]; // dynamic array. Its length is also random. 
    rand int len;

    constraint no_loopback { src != dst; } // rule 1
    constraint payload_check {payload.size() inside {[1:64]};} // rule 2
    constraint control_size { kind == CONTROL -> payload.size() == 4; }
    constraint kind_mix { kind dist { WRITE := 70, READ := 20, CONTROL := 10 }; } // : gives a relative proportion
    constraint len_check { len == payload.size();} // rule 5
/* payload is a dynamic array with free bytes. 
The solver picks uniformly over all legal solutions,
 and a size-s array has 256^s possible byte-fills,
 so size 64 has astronomically more solutions than size 1. 
 Result: without help, nearly every READ/WRITE packet comes out at size 64 
 (and len with it). Fix it by telling the solver to pick the size first, 
 then the contents:
*/
    constraint size_order { solve payload.size() before payload; }
// So this gives a better distribution
endclass


module tb;
    Packet p = new();
    initial begin
        repeat (100) begin
            if (!p.randomize()) $fatal("randomize failed"); // This needs to be added for every tb check

            $display("kind=%s src=%0d dst=%0d len=%0d size=%0d",
                    p.kind.name(), p.src, p.dst, p.len, p.payload.size());
        end
    end
endmodule