`timescale 1ns/1ps

module tb_register_file;

    // Inputs
    reg clk;
    reg rst;
    reg we;
    reg [4:0] waddr;
    reg [31:0] wdata;
    reg [4:0] raddr1;
    reg [4:0] raddr2;

    // Outputs
    wire [31:0] rdata1;
    wire [31:0] rdata2;

    // Instantiate the Unit Under Test (UUT)
    register_file uut (
        .clk(clk),
        .rst(rst),
        .we(we),
        .waddr(waddr),
        .wdata(wdata),
        .raddr1(raddr1),
        .raddr2(raddr2),
        .rdata1(rdata1),
        .rdata2(rdata2)
    );

    // Clock generation (10ns period)
    always #5 clk = ~clk;

    initial begin
        // Initialize Inputs
        clk = 0;
        rst = 1;
        we = 0;
        waddr = 0;
        wdata = 0;
        raddr1 = 0;
        raddr2 = 0;

        // Open VCD file for GTKWave
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_register_file);

        // Wait 20 ns for global reset to finish
        #20;
        rst = 0;
        
        // ----------------------------------------------------
        // TEST 1: Try to write to x0 (Should be ignored)
        // ----------------------------------------------------
        #10;
        we = 1;
        waddr = 5'd0;       // target x0
        wdata = 32'hFFFF_FFFF;   // try to write all 1s
        raddr1 = 5'd0;      // immediately read it back
        
        #10;
        we = 0; // Turn off write
        #10;
        if (rdata1 !== 32'd0) $display("FAIL: x0 was overwritten!");
        else $display("PASS: x0 remains 0.");

        // ----------------------------------------------------
        // TEST 2: Write to normal register (x5) and read it
        // ----------------------------------------------------
        #10;
        we = 1;
        waddr = 5'd5;
        wdata = 32'hABCD_1234;
        
        #10;
        we = 0;
        raddr1 = 5'd5;      // Read on port 1
        raddr2 = 5'd5;      // Read on port 2
        #10;
        if (rdata1 !== 32'hABCD_1234) $display("FAIL: x5 did not hold data!");
        else $display("PASS: x5 successfully stored and read data.");

        // ----------------------------------------------------
        // TEST 3: Simultaneous read and write to different registers
        // ----------------------------------------------------
        #10;
        we = 1;
        waddr = 5'd10;
        wdata = 32'h9999_8888;
        raddr1 = 5'd5;      // Read x5 while writing x10
        
        #10;
        we = 0;
        raddr2 = 5'd10;     // Verify x10 was written
        #10;
        
        $display("All basic tests completed.");
        $finish;
    end
      
endmodule
