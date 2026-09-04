module cpu (
    input  wire       clk,
    input  wire       rst,
    output wire [7:0] cpu_out,     // value of whatever register OUT last exposed
    output wire       out_valid,   // 1 during the cycle an OUT instruction executes
    output wire       halted        // 1 once HALT has been reached
);

    // ---- wires connecting everything together ----
    wire [3:0] pc_val;
    wire [7:0] instr;

    wire       reg_we;
    wire [1:0] reg_waddr, reg_raddr1, reg_raddr2;
    wire [2:0] alu_op;
    wire       mem_we;
    wire [1:0] mem_addr;
    wire       reg_wdata_sel;
    wire       pc_jump_en;
    wire [3:0] pc_jump_addr;

    wire [7:0] reg_rdata1, reg_rdata2;
    wire [7:0] alu_result;
    wire       alu_zero;
    wire [7:0] mem_rdata;

    wire [7:0] reg_wdata;
    wire       pc_effective_jump_en;
    wire [3:0] pc_effective_jump_addr;

    // ---- Program Counter ----
    pc pc_inst (
        .clk(clk), .rst(rst),
        .jump_en(pc_effective_jump_en),
        .jump_addr(pc_effective_jump_addr),
        .pc_out(pc_val)
    );

    // ---- Instruction Memory ----
    instr_mem imem (
        .addr(pc_val),
        .instr(instr)
    );

    // ---- Control Unit ----
    control_unit ctrl (
        .instr(instr), .zero_flag(alu_zero),
        .reg_we(reg_we), .reg_waddr(reg_waddr),
        .reg_raddr1(reg_raddr1), .reg_raddr2(reg_raddr2),
        .alu_op(alu_op), .mem_we(mem_we), .mem_addr(mem_addr),
        .reg_wdata_sel(reg_wdata_sel),
        .pc_jump_en(pc_jump_en), .pc_jump_addr(pc_jump_addr),
        .halt(halted)
    );

    // ---- Register File ----
    register_file rf (
        .clk(clk), .rst(rst),
        .we(reg_we), .waddr(reg_waddr), .wdata(reg_wdata),
        .raddr1(reg_raddr1), .raddr2(reg_raddr2),
        .rdata1(reg_rdata1), .rdata2(reg_rdata2)
    );

    // ---- ALU ----
    alu alu_inst (
        .a(reg_rdata1), .b(reg_rdata2), .opcode(alu_op),
        .result(alu_result), .zero(alu_zero)
    );

    // ---- Data Memory ----
    data_mem dmem (
        .clk(clk), .we(mem_we), .addr(mem_addr),
        .wdata(reg_rdata1),    // STORE always writes whatever reg_raddr1 read
        .rdata(mem_rdata)
    );
    assign reg_wdata = reg_wdata_sel?mem_rdata:alu_result;

    assign pc_effective_jump_en   = halted?1'b1:pc_jump_en;
    assign pc_effective_jump_addr = halted?pc_val:pc_jump_addr;

    // ---- output visibility ----
    assign cpu_out   = reg_rdata1;
    assign out_valid = (instr[7:4] == 4'b0110);   // opcode == OUT

endmodule