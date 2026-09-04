`timescale 1ns/1ps

module tb_data_mem;

    reg         clk;
    reg         we;
    reg  [31:0] addr;
    reg  [31:0] wdata;
    wire [31:0] rdata;

    // Instantiate Data Memory
    data_mem uut (
        .clk(clk),
        .we(we),
        .addr(addr),
        .wdata(wdata),
        .rdata(rdata)
    );

    // Clock generation (10ns period)
    always #5 clk = ~clk;

    initial begin
        $dumpfile("wave_dmem.vcd");
        $dumpvars(0, tb_data_mem);

        // Initialize Inputs
        clk = 0;
        we = 0;
        addr = 0;
        wdata = 0;

        #15;
        
        // 1. Initial read (Should be 0)
        addr = 32'd4;
        #10;
        if (rdata !== 32'd0) $display("FAIL: Memory at addr 4 wasn't 0");
        else $display("PASS: Memory initialized to 0");

        // 2. Write to memory (Simulating 'sw x2, 4(x1)')
        we = 1;
        addr = 32'd4;
        wdata = 32'hDEAD_BEEF;
        
        #10; // Wait for clock edge to write
        we = 0; // Turn off write enable
        
        // 3. Read it back (Simulating 'lw x5, 4(x1)')
        #10;
        if (rdata !== 32'hDEAD_BEEF) $display("FAIL: Failed to read back written data at addr 4");
        else $display("PASS: Successfully wrote and read DEADBEEF at addr 4");

        // 4. Write to a completely different address
        we = 1;
        addr = 32'd20; // Address 20 is index 5
        wdata = 32'h1234_5678;
        
        #10;
        we = 0;
        addr = 32'd20;
        #10;
        if (rdata !== 32'h1234_5678) $display("FAIL: Failed to read back from addr 20");
        else $display("PASS: Successfully wrote and read at addr 20");

        $display("All Data Memory tests completed!");
        $finish;
    end

endmodule
