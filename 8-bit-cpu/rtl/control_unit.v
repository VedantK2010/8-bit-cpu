module control_unit (
    input  wire [7:0] instr,       // current instruction from instr_mem
    input  wire        zero_flag,   // from ALU, needed for JZ

    output reg         reg_we,
    output reg  [1:0]  reg_waddr,
    output reg  [1:0]  reg_raddr1,
    output reg  [1:0]  reg_raddr2,
    output reg  [2:0]  alu_op,
    output reg          mem_we,
    output reg  [1:0]  mem_addr,
    output reg          reg_wdata_sel,  // 0 = write ALU result, 1 = write data_mem read value
    output reg          pc_jump_en,
    output reg  [3:0]  pc_jump_addr,
    output reg          halt
);

    // Opcode encoding
    localparam LOAD  = 4'b0000;
    localparam STORE = 4'b0001;
    localparam ADD   = 4'b0010;
    localparam SUB   = 4'b0011;
    localparam JUMP  = 4'b0100;
    localparam JZ    = 4'b0101;
    localparam OUT   = 4'b0110;
    localparam HALT  = 4'b1111;

    // ALU opcodes
    localparam ALU_ADD = 3'b000;
    localparam ALU_SUB = 3'b001;

    wire [3:0] opcode = instr[7:4];

    always @(*) begin
        reg_we        = 1'b0;
        reg_waddr     = 2'b00;
        reg_raddr1    = 2'b00;
        reg_raddr2    = 2'b00;
        alu_op        = ALU_ADD;
        mem_we        = 1'b0;
        mem_addr      = 2'b00;
        reg_wdata_sel = 1'b0;
        pc_jump_en    = 1'b0;
        pc_jump_addr  = 4'b0000;
        halt          = 1'b0;

        case (opcode)

            LOAD: begin
                // instr[3:2] = Rd, instr[1:0] = Addr
                reg_we        = 1'b1;
                reg_waddr     = instr[3:2];
                mem_addr      = instr[1:0];
                reg_wdata_sel = 1'b1;   
            end

            STORE: begin
                // instr[3:2] = Rs, instr[1:0] = Addr
                reg_raddr1 = instr[3:2];   
                mem_we     = 1'b1;
                mem_addr   = instr[1:0];
            end

            ADD: begin
                // instr[3:2] = Rd, instr[1:0] = Rs
                reg_we     = 1'b1;
                reg_waddr  = instr[3:2];
                reg_raddr1 = instr[3:2];   // Rd's current value is one ALU input
                reg_raddr2 = instr[1:0];   // Rs is the other
                alu_op     = ALU_ADD;
            end

            SUB: begin
                reg_we     = 1'b1;
                reg_waddr  = instr[3:2];
                reg_raddr1 = instr[3:2];
                reg_raddr2 = instr[1:0];
                alu_op     = ALU_SUB;
            end

            JUMP: begin
                pc_jump_en   = 1'b1;
                pc_jump_addr = instr[3:0];   // whole operand is the target address here
            end

            JZ: begin
                pc_jump_en   = zero_flag;
                pc_jump_addr = instr[3:0];
            end

            OUT: begin
                reg_raddr1 = instr[3:2];
            end

            HALT: begin
                halt = 1'b1;
            end

            default: begin
                // unrecognized opcode -- all defaults above already apply, do nothing
            end
        endcase
    end

endmodule