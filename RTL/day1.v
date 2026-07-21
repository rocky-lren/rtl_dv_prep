// synchronous, active low
// so there should be five states, idle->C!->C2->C3->IDLE; C3 to idle gives output found high. 
// This is input dependent so it is a mealy machine

module day1(
    input clk,
    input rst_n,
    input din,
    output reg found
);

reg [1:0] current_state;
reg [1:0] next_state;

parameter S1 = 2'b01;
parameter S2 = 2'b10;
parameter S3 = 2'b11;
parameter IDLE = 2'b00;


// sequential block. This handles state transitions

always @(posedge clk) begin
    if (!rst_n) begin
        current_state <= IDLE;
        // found <= 1'b0; // not sure. // prevents two drivers
    end else begin
        current_state <= next_state;
    end

end

// comb block. This handles outputs and determines the next state
always @(*) begin
    // defaults to prevent latches
    next_state = current_state; 
    found = 1'b0;

    case (current_state) 
        IDLE: begin
            if (din) begin
                next_state = S1;
            end else begin
                next_state = IDLE;
            end
        end

        S1: begin
            if (din) begin
                next_state = S1; // Not going back!!!
            end else begin
                next_state = S2;
            end
        end

        S2: begin
            if (din) begin
                next_state = S3;
            end else begin
                next_state = IDLE;
            end
        end


        S3: begin
            if (din) begin
                next_state = S1;
                found = 1'b1;
            end else begin
                next_state = S2; // Not going back!!!
            end
        end
    endcase



end
endmodule