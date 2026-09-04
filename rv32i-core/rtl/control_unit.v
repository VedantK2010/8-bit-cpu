module control_unit (
    input  wire [6:0] opcode,
    input  wire [2:0] funct3,
    input  wire       funct7_b5, // Bit 30 of the instruction (used to tell ADD from SUB)

    // Main Control Signals
    output reg        RegWrite,  // 1 = Write to Register File
    output reg [2:0]  ImmSrc,    // Tells Imm_Generator which format to use
    output reg        ALUSrc,    // 0 = ALU reads rs2, 1 = ALU reads Immediate
    output reg        MemWrite,  // 1 = Write to Data Memory
    output reg [1:0]  ResultSrc, // 00 = ALU Result, 01 = Data Memory, 10 = PC+4
    output reg        Branch,    // 1 = Conditional Branch instruction
    output reg        Jump,      // 1 = Unconditional Jump instruction
    
    // ALU Control Signal
    output reg [3:0]  ALUControl // 4-bit code telling the ALU what math to do
);

    reg [1:0] ALUOp; // Internal wire connecting Main Decoder to ALU Decoder

    // --- MAIN DECODER ---
    // Looks at the 7-bit opcode and flips the main hardware switches.
    always @(*) begin
        // Default values to prevent Verilog from creating unwanted memory (latches)
        RegWrite  = 0;
        ImmSrc    = 3'b000;
        ALUSrc    = 0;
        MemWrite  = 0;
        ResultSrc = 2'b00;
        Branch    = 0;
        Jump      = 0;
        ALUOp     = 2'b00;

        case (opcode)
            7'b0110011: begin // R-Type (Math with two registers)
                RegWrite = 1;
                ALUSrc   = 0;
                ALUOp    = 2'b10;
            end
            
            7'b0010011: begin // I-Type (Math with one register and one immediate)
                RegWrite = 1;
                ImmSrc   = 3'b000; // Extract I-Type immediate
                ALUSrc   = 1;      // Send Immediate into ALU
                ALUOp    = 2'b10;
            end
            
            7'b0000011: begin // LW (Load Word from Memory)
                RegWrite  = 1;
                ImmSrc    = 3'b000; // Extract I-Type immediate (offset)
                ALUSrc    = 1;      // Send Immediate into ALU
                ResultSrc = 2'b01;  // Take data from RAM, not ALU!
                ALUOp     = 2'b00;  // Force ALU to ADD
            end
            
            7'b0100011: begin // SW (Store Word to Memory)
                ImmSrc   = 3'b001; // Extract S-Type immediate
                ALUSrc   = 1;      // Send Immediate into ALU
                MemWrite = 1;      // Turn on RAM Write Enable
                ALUOp    = 2'b00;  // Force ALU to ADD
            end
            
            7'b1100011: begin // BEQ (Branch if Equal)
                ImmSrc = 3'b010; // Extract B-Type immediate
                Branch = 1;      // Alert the PC logic
                ALUOp  = 2'b01;  // Force ALU to SUBTRACT
            end
            
            7'b1101111: begin // JAL (Jump and Link)
                RegWrite  = 1;
                ImmSrc    = 3'b011; // Extract J-Type immediate
                Jump      = 1;      // Alert the PC logic
                ResultSrc = 2'b10;  // Save (PC + 4) into the return register!
            end
        endcase
    end

    // --- ALU DECODER ---
    // Looks at ALUOp and funct3 to generate the final 4-bit ALU instruction.
    always @(*) begin
        case (ALUOp)
            2'b00: ALUControl = 4'b0000; // Load/Store always use ADD for address calculation
            2'b01: ALUControl = 4'b0001; // Branches always use SUB for comparison
            
            2'b10: begin // R-Type or I-Type Math
                case (funct3)
                    3'b000: begin
                        // ADD and SUB share the same funct3! 
                        // We check bit 30 (funct7_b5) AND the opcode to tell them apart.
                        if (opcode == 7'b0110011 && funct7_b5)
                            ALUControl = 4'b0001; // SUB
                        else
                            ALUControl = 4'b0000; // ADD (or ADDI)
                    end
                    3'b010: ALUControl = 4'b0101; // SLT
                    3'b100: ALUControl = 4'b0100; // XOR
                    3'b110: ALUControl = 4'b0011; // OR
                    3'b111: ALUControl = 4'b0010; // AND
                    default: ALUControl = 4'b0000;
                endcase
            end
            default: ALUControl = 4'b0000;
        endcase
    end

endmodule
