`timescale 1ns/1ps

module tb_control_unit;
    reg  [7:0] instr;
    reg        zero_flag;
    wire       reg_we;
    wire [1:0] reg_waddr, reg_raddr1, reg_raddr2;
    wire [2:0] alu_op;
    wire       mem_we;
    wire [1:0] mem_addr;
    wire       reg_wdata_sel;
    wire       pc_jump_en;
    wire [3:0] pc_jump_addr;
    wire       halt;

    control_unit dut (
        .instr(instr), .zero_flag(zero_flag),
        .reg_we(reg_we), .reg_waddr(reg_waddr),
        .reg_raddr1(reg_raddr1), .reg_raddr2(reg_raddr2),
        .alu_op(alu_op), .mem_we(mem_we), .mem_addr(mem_addr),
        .reg_wdata_sel(reg_wdata_sel),
        .pc_jump_en(pc_jump_en), .pc_jump_addr(pc_jump_addr),
        .halt(halt)
    );

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_control_unit);

        // LOAD R0, [2]  ->  8'b0000_0010
        instr = 8'b0000_0010; zero_flag = 0; #10;
        $display("LOAD:  we=%b waddr=%b mem_addr=%b wdata_sel=%b  (expect we=1 waddr=00 mem_addr=10 sel=1)",
                  reg_we, reg_waddr, mem_addr, reg_wdata_sel);

        // ADD R0, R1  ->  8'b0010_0001
        instr = 8'b0010_0001; #10;
        $display("ADD:   we=%b waddr=%b raddr1=%b raddr2=%b alu_op=%b  (expect we=1 waddr=00 r1=00 r2=01 alu=000)",
                  reg_we, reg_waddr, reg_raddr1, reg_raddr2, alu_op);

        // OUT R0  ->  8'b0110_0000
        instr = 8'b0110_0000; #10;
        $display("OUT:   raddr1=%b  (expect raddr1=00)", reg_raddr1);

        // JUMP to address 9  ->  8'b0100_1001
        instr = 8'b0100_1001; #10;
        $display("JUMP:  jump_en=%b jump_addr=%b  (expect en=1 addr=1001)", pc_jump_en, pc_jump_addr);

        // JZ to address 5, zero_flag=0 -> should NOT jump
        instr = 8'b0101_0101; zero_flag = 0; #10;
        $display("JZ(z=0): jump_en=%b  (expect en=0)", pc_jump_en);

        // JZ to address 5, zero_flag=1 -> SHOULD jump
        instr = 8'b0101_0101; zero_flag = 1; #10;
        $display("JZ(z=1): jump_en=%b jump_addr=%b  (expect en=1 addr=0101)", pc_jump_en, pc_jump_addr);

        // HALT  ->  8'b1111_0000
        instr = 8'b1111_0000; #10;
        $display("HALT:  halt=%b  (expect halt=1)", halt);

        $finish;
    end
endmodule
