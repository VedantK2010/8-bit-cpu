module pc (
    input  wire        clk,
    input  wire        rst,         // Synchronous reset -- PC starts at 0
    input  wire        pc_src,      // 1 = Load target_addr (Branch/Jump), 0 = PC + 4
    input  wire [31:0] target_addr, // Target address (usually calculated by an adder in the top level)
    output reg  [31:0] pc_out       // Current instruction address
);

    always @(posedge clk) begin
        if (rst) begin
            pc_out <= 32'h00000000;      // On reset, start at address 0
        end else if (pc_src) begin
            pc_out <= target_addr;       // If branching/jumping, go to the target
        end else begin
            pc_out <= pc_out + 32'd4;    // Otherwise, step forward to the next instruction (+4 bytes)
        end
    end

endmodule
