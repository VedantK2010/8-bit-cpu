module pc (
    input  wire       clk,
    input  wire       rst,        // synchronous reset -- PC starts at 0
    input  wire       jump_en,    // 1 = load jump_addr instead of incrementing
    input  wire [3:0] jump_addr,  // target address for JUMP/JZ
    output reg  [3:0] pc_out       // current instruction address
);

    always @(posedge clk) begin
        if (rst) begin
            pc_out <= 4'b0000;          // start of the program
        end else if (jump_en) begin
            pc_out <= jump_addr;         // control unit says "go here instead"
        end else begin
            pc_out <= pc_out+1;
        end
    end

endmodule
