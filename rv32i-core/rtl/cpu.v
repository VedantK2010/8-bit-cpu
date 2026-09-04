module cpu (
    input wire clk,
    input wire rst
);

    // ==========================================
    // 1. INTERNAL WIRES
    // ==========================================
    
    // PC & Instruction
    wire [31:0] PC, PCPlus4, PCTarget;
    wire [31:0] Instr;
    
    // Control Signals
    wire       RegWrite, ALUSrc, MemWrite, Branch, Jump, Zero, PCSrc;
    wire [1:0] ResultSrc;
    wire [2:0] ImmSrc;
    wire [3:0] ALUControl;
    
    // Data Wires
    wire [31:0] ImmExt;
    wire [31:0] RD1, RD2;
    wire [31:0] SrcB;
    wire [31:0] ALUResult;
    wire [31:0] ReadData;
    wire [31:0] Result;

    // ==========================================
    // 2. FETCH STAGE
    // ==========================================
    
    // PC Logic Adders
    assign PCPlus4 = PC + 32'd4;
    assign PCTarget = PC + ImmExt; // Branch/Jump target address
    
    // PCSrc determines if we step forward by 4, or jump!
    assign PCSrc = Jump | (Branch & Zero);
    
    pc pc_inst (
        .clk(clk),
        .rst(rst),
        .pc_src(PCSrc),
        .target_addr(PCTarget),
        .pc_out(PC)
    );

    instr_mem imem (
        .addr(PC),
        .instruction(Instr)
    );

    // ==========================================
    // 3. DECODE & CONTROL STAGE
    // ==========================================
    
    control_unit cu (
        .opcode(Instr[6:0]),
        .funct3(Instr[14:12]),
        .funct7_b5(Instr[30]),
        .RegWrite(RegWrite),
        .ImmSrc(ImmSrc),
        .ALUSrc(ALUSrc),
        .MemWrite(MemWrite),
        .ResultSrc(ResultSrc),
        .Branch(Branch),
        .Jump(Jump),
        .ALUControl(ALUControl)
    );

    register_file rf (
        .clk(clk),
        .rst(rst),
        .we(RegWrite),
        .waddr(Instr[11:7]),   // rd
        .wdata(Result),        // Data writing back to register
        .raddr1(Instr[19:15]), // rs1
        .raddr2(Instr[24:20]), // rs2
        .rdata1(RD1),
        .rdata2(RD2)
    );

    imm_generator imm_gen (
        .instruction(Instr),
        .imm_src(ImmSrc),
        .imm_ext(ImmExt)
    );

    // ==========================================
    // 4. EXECUTE STAGE
    // ==========================================
    
    // ALUSrc Multiplexer (MUX): 0 = Read from Register, 1 = Read Immediate
    assign SrcB = ALUSrc ? ImmExt : RD2;

    alu alu_inst (
        .a(RD1),
        .b(SrcB),
        .alu_ctrl(ALUControl),
        .result(ALUResult),
        .zero(Zero)
    );

    // ==========================================
    // 5. MEMORY STAGE
    // ==========================================
    
    data_mem dmem (
        .clk(clk),
        .we(MemWrite),
        .addr(ALUResult),
        .wdata(RD2), // For stores, we write the raw second register
        .rdata(ReadData)
    );

    // ==========================================
    // 6. WRITEBACK STAGE
    // ==========================================
    
    // ResultSrc Multiplexer (MUX): What data do we save back to the register?
    // 00 = ALU Math Result
    // 01 = Data Memory Load
    // 10 = PC+4 (For Jumps, so we can return later)
    assign Result = (ResultSrc == 2'b01) ? ReadData :
                    (ResultSrc == 2'b10) ? PCPlus4 : 
                                           ALUResult;

endmodule
