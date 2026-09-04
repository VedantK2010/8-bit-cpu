`timescale 1ns/1ps

module tb_cpu;

    reg clk;
    reg rst;

    // Instantiate the full CPU
    cpu uut (
        .clk(clk),
        .rst(rst)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("wave_cpu.vcd");
        $dumpvars(0, tb_cpu);

        // HARDCODING A MINI RISC-V PROGRAM INTO ROM
        // 1. addi x1, x0, 5    (x1 = 5)
        uut.imem.mem[0] = 32'h00500093;
        // 2. addi x2, x0, 10   (x2 = 10)
        uut.imem.mem[1] = 32'h00A00113;
        // 3. add x3, x1, x2    (x3 = 15)
        uut.imem.mem[2] = 32'h002081B3;
        // 4. sw x3, 4(x0)      (RAM[4] = 15)
        uut.imem.mem[3] = 32'h00302223;
        // 5. lw x4, 4(x0)      (x4 = RAM[4] = 15)
        uut.imem.mem[4] = 32'h00402203;
        // 6. beq x3, x4, -4    (x3 == x4, so jump back to step 5 in an infinite loop)
        uut.imem.mem[5] = 32'hFE418EE3;

        // Reset the CPU
        clk = 0;
        rst = 1;
        #15;
        rst = 0;

        // Wait for the program to execute all 6 instructions
        #60; 

        // Verify the results
        $display("--- CPU END-TO-END VERIFICATION ---");
        
        if (uut.rf.regs[1] !== 32'd5) $display("FAIL: x1 did not equal 5");
        else $display("PASS: x1 correctly loaded immediate 5");
        
        if (uut.rf.regs[2] !== 32'd10) $display("FAIL: x2 did not equal 10");
        else $display("PASS: x2 correctly loaded immediate 10");
        
        if (uut.rf.regs[3] !== 32'd15) $display("FAIL: x3 did not equal 15");
        else $display("PASS: x3 successfully added x1 + x2 (5 + 10 = 15)");
        
        if (uut.dmem.mem[1] !== 32'd15) $display("FAIL: RAM[4] did not equal 15");
        else $display("PASS: 'sw' successfully stored x3 into RAM address 4");
        
        if (uut.rf.regs[4] !== 32'd15) $display("FAIL: x4 did not equal 15");
        else $display("PASS: 'lw' successfully loaded 15 from RAM into x4");
        
        #20;
        // Check if the branch loop worked (PC should toggle between 20 and 16)
        if (uut.PC == 32'd20 || uut.PC == 32'd16) $display("PASS: 'beq' successfully branched and caught CPU in loop!");
        else $display("FAIL: CPU did not branch properly. PC is %d", uut.PC);

        $display("ALL CPU TESTS COMPLETED!");
        $finish;
    end

endmodule
