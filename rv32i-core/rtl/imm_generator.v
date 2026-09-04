module imm_generator (
    input  wire [31:0] instruction,
    input  wire [2:0]  imm_src,     // Tells the generator which format to use
    output reg  [31:0] imm_ext      // The cleanly un-scrambled 32-bit immediate
);

    always @(*) begin
        case (imm_src)
            // 000: I-Type (e.g., ADDI, LW)
            // imm[11:0] is sitting cleanly in the top 12 bits of the instruction.
            3'b000: imm_ext = {{20{instruction[31]}}, instruction[31:20]};
            
            // 001: S-Type (e.g., SW)
            // The 12-bit immediate is chopped into bits [31:25] and [11:7].
            3'b001: imm_ext = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
            
            // 010: B-Type (e.g., BEQ)
            // Highly scrambled! Notice that branches always jump in multiples of 2,
            // so we hardcode the 0th bit to 1'b0.
            3'b010: imm_ext = {{20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0};
            
            // 011: J-Type (e.g., JAL)
            // 20-bit scrambled immediate, jumping in multiples of 2.
            3'b011: imm_ext = {{12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21], 1'b0};
            
            // 100: U-Type (e.g., LUI)
            // Grabs a 20-bit immediate from the top of the instruction, and fills the bottom 12 bits with zeros.
            3'b100: imm_ext = {instruction[31:12], 12'b0};
            
            default: imm_ext = 32'b0;
        endcase
    end

endmodule
