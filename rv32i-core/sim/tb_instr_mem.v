`timescale 1ns/1ps

module tb_instr_mem;

    reg  [31:0] addr;
    wire [31:0] instruction;

    // Instantiate the ROM
    instr_mem uut (
        .addr(addr),
        .instruction(instruction)
    );

    initial begin
        $dumpfile("wave_imem.vcd");
        $dumpvars(0, tb_instr_mem);

        // "Flash" the ROM with a fake mini-program manually for the test
        uut.mem[0] = 32'hAAAA_AAAA; // Address 0
        uut.mem[1] = 32'hBBBB_BBBB; // Address 4
        uut.mem[2] = 32'hCCCC_CCCC; // Address 8
        uut.mem[3] = 32'hDDDD_DDDD; // Address 12

        // 1. Fetch from address 0
        addr = 32'd0;
        #10;
        if (instruction !== 32'hAAAA_AAAA) $display("FAIL: Addr 0");
        else $display("PASS: Fetched from Address 0");

        // 2. Fetch from address 4 (Notice we jump by 4!)
        addr = 32'd4;
        #10;
        if (instruction !== 32'hBBBB_BBBB) $display("FAIL: Addr 4");
        else $display("PASS: Fetched from Address 4");

        // 3. Fetch from address 12
        addr = 32'd12;
        #10;
        if (instruction !== 32'hDDDD_DDDD) $display("FAIL: Addr 12");
        else $display("PASS: Fetched from Address 12");

        $display("All Instruction Memory tests completed!");
        $finish;
    end

endmodule
