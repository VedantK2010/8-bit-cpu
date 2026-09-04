`timescale 1ns/1ps

module tb_pc;

    reg         clk;
    reg         rst;
    reg         pc_src;
    reg  [31:0] target_addr;
    wire [31:0] pc_out;

    // Instantiate the PC
    pc uut (
        .clk(clk),
        .rst(rst),
        .pc_src(pc_src),
        .target_addr(target_addr),
        .pc_out(pc_out)
    );

    // Clock generation (10ns period)
    always #5 clk = ~clk;

    initial begin
        $dumpfile("wave_pc.vcd");
        $dumpvars(0, tb_pc);

        // Initialize Inputs
        clk = 0;
        rst = 1;
        pc_src = 0;
        target_addr = 32'd0;

        // Wait for global reset to finish
        #15;
        rst = 0;
        
        // 1. Let it count naturally for a few cycles
        // Expected: 0 -> 4 -> 8 -> 12
        #10;
        if (pc_out !== 32'd4) $display("FAIL: PC didn't increment to 4. Was %d", pc_out);
        else $display("PASS: PC incremented to 4");
        
        #10;
        if (pc_out !== 32'd8) $display("FAIL: PC didn't increment to 8. Was %d", pc_out);
        else $display("PASS: PC incremented to 8");

        #10; 
        if (pc_out !== 32'd12) $display("FAIL: PC didn't increment to 12. Was %d", pc_out);
        else $display("PASS: PC incremented to 12");

        // 2. Test Branching / Jumping
        #10;
        pc_src = 1;
        target_addr = 32'd1000; // Force a jump to address 1000
        
        #10;
        if (pc_out !== 32'd1000) $display("FAIL: PC didn't jump to 1000. Was %d", pc_out);
        else $display("PASS: PC successfully jumped to 1000");

        // 3. Test natural counting after a jump
        pc_src = 0; // Turn off jump signal
        
        #10;
        if (pc_out !== 32'd1004) $display("FAIL: PC didn't increment to 1004. Was %d", pc_out);
        else $display("PASS: PC incremented normally after jump to 1004");

        $display("All Program Counter tests completed!");
        $finish;
    end

endmodule
