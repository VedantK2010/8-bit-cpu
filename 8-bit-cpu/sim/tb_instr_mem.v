`timescale 1ns/1ps

module tb_instr_mem;
    reg  [3:0] addr;
    wire [7:0] instr;

    instr_mem dut (
        .addr(addr),
        .instr(instr)
    );

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_instr_mem);

        $display("addr | instr     (expected)");

        addr = 0; #10; $display(" %0d   | %b   (LOAD R0,[2]  = 00000010)", addr, instr);
        addr = 1; #10; $display(" %0d   | %b   (LOAD R1,[3]  = 00000111)", addr, instr);
        addr = 2; #10; $display(" %0d   | %b   (ADD  R0,R1   = 00100001)", addr, instr);
        addr = 3; #10; $display(" %0d   | %b   (OUT  R0      = 01100000)", addr, instr);
        addr = 4; #10; $display(" %0d   | %b   (HALT          = 11110000)", addr, instr);

        $finish;
    end
endmodule
