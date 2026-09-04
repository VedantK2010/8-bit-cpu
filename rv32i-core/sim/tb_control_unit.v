`timescale 1ns/1ps

module tb_control_unit;

    reg [6:0] opcode;
    reg [2:0] funct3;
    reg       funct7_b5;

    wire       RegWrite;
    wire [2:0] ImmSrc;
    wire       ALUSrc;
    wire       MemWrite;
    wire [1:0] ResultSrc;
    wire       Branch;
    wire       Jump;
    wire [3:0] ALUControl;

    // Instantiate Control Unit
    control_unit uut (
        .opcode(opcode),
        .funct3(funct3),
        .funct7_b5(funct7_b5),
        .RegWrite(RegWrite),
        .ImmSrc(ImmSrc),
        .ALUSrc(ALUSrc),
        .MemWrite(MemWrite),
        .ResultSrc(ResultSrc),
        .Branch(Branch),
        .Jump(Jump),
        .ALUControl(ALUControl)
    );

    initial begin
        $dumpfile("wave_cu.vcd");
        $dumpvars(0, tb_control_unit);

        // 1. Test ADD (R-Type)
        opcode = 7'b0110011; funct3 = 3'b000; funct7_b5 = 0;
        #10;
        if (RegWrite == 1 && ALUSrc == 0 && ALUControl == 4'b0000)
            $display("PASS: ADD correctly decoded");
        else $display("FAIL: ADD");

        // 2. Test SUB (R-Type)
        opcode = 7'b0110011; funct3 = 3'b000; funct7_b5 = 1;
        #10;
        if (RegWrite == 1 && ALUControl == 4'b0001)
            $display("PASS: SUB correctly decoded");
        else $display("FAIL: SUB");

        // 3. Test LW (Load Word)
        opcode = 7'b0000011; funct3 = 3'b010; funct7_b5 = 0;
        #10;
        if (RegWrite == 1 && MemWrite == 0 && ALUSrc == 1 && ResultSrc == 2'b01)
            $display("PASS: LW perfectly configured datapath routing");
        else $display("FAIL: LW");

        // 4. Test BEQ (Branch)
        opcode = 7'b1100011; funct3 = 3'b000; funct7_b5 = 0;
        #10;
        if (Branch == 1 && ALUControl == 4'b0001) // Ensure it forces SUBTRACT
            $display("PASS: BEQ correctly forces ALU to subtract");
        else $display("FAIL: BEQ");

        $display("All Control Unit tests completed!");
        $finish;
    end

endmodule
