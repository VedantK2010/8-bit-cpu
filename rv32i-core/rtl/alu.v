module alu (
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [3:0]  alu_ctrl,
    
    output reg  [31:0] result,
    output wire        zero
);

    // The Zero flag is 1 if the result is exactly 0.
    // This is the magic behind RISC-V branches (like BEQ).
    assign zero = (result == 32'd0);

    always @(*) begin
        case (alu_ctrl)
            4'b0000: result = a + b;                     // ADD
            4'b0001: result = a - b;                     // SUB
            4'b0010: result = a & b;                     // AND
            4'b0011: result = a | b;                     // OR
            4'b0100: result = a ^ b;                     // XOR
            
            // SLT (Set Less Than) - Signed comparison. 
            // If a < b, result is 1. Otherwise, result is 0.
            4'b0101: result = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0; 
            
            // Shifts (Shifts a by the bottom 5 bits of b)
            4'b0110: result = a << b[4:0];               // SLL (Shift Left Logical)
            4'b0111: result = a >> b[4:0];               // SRL (Shift Right Logical)
            
            default: result = 32'd0;                     // Default fallback
        endcase
    end

endmodule
