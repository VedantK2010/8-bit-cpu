module traffic_light (
    input  wire       clk,
    input  wire       rst,     // synchronous reset, active-high -- resets to RED
    output wire [1:0] light    // 2'b00 = RED, 2'b01 = YELLOW, 2'b10 = GREEN
);

    // State encoding
    localparam RED    = 2'b00;
    localparam YELLOW = 2'b01;
    localparam GREEN  = 2'b10;

    // How many clock cycles to stay in each state
    localparam RED_TIME    = 3'd4;
    localparam GREEN_TIME  = 3'd4;
    localparam YELLOW_TIME = 3'd2;

    reg [1:0] state;
    reg [2:0] counter;   // counts how many cycles we've spent in the current state

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state   <= RED;
            counter <= 0;
        end else begin
            case (state)

                // WORKED EXAMPLE -- study this branch carefully, then
                // write the GREEN and YELLOW branches below following
                // the exact same pattern.
                RED: begin
                    if (counter == RED_TIME - 1) begin
                        state   <= GREEN;   // time's up, move to next state
                        counter <= 0;        // reset counter for the new state
                    end else begin
                        counter <= counter + 1;  // still waiting, keep counting
                    end
                end

                // TODO: GREEN state.
                // After GREEN_TIME cycles, move to YELLOW (not RED!).
                // Follow the exact same if/else shape as the RED branch above.
                GREEN: begin
                    if (counter==GREEN_TIME-1) begin
                        state<=YELLOW;
                        counter<=0;
                    end else begin
                        counter<=counter+1;
                    end
                end

                // TODO: YELLOW state.
                // After YELLOW_TIME cycles, move back to RED, completing the cycle.
                YELLOW: begin
                    if (counter==YELLOW_TIME-1) begin
                        state<=RED;
                        counter<=0;
                    end else begin
                        counter<=counter+1;
                    end
                end

                default: begin
                    state   <= RED;
                    counter <= 0;
                end
            endcase
        end
    end

    assign light = state;

endmodule
