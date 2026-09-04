`timescale 1ns/1ps

module tb_dff;
    reg clk = 0;
    reg rst;
    reg d;
    wire q;

    dff dut(
        .clk(clk),
        .rst(rst),
        .d(d),
        .q(q)
    );

    // clock generation: toggles every 5 time units -> 10-unit period
    always #5 clk = ~clk;

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_dff);

        $monitor("time=%0t | rst=%b d=%b q=%b", $time, rst, d, q);

        // start with reset asserted
        rst = 1; d = 0;
        #12;

        // release reset, d is still 0
        rst = 0;
        #10;

        // change d to 1 -- q should NOT change yet, only on next clock edge
        d = 1;
        #2; 

        // wait for a clock edge to pass
        #8; 

        // change d to 0
        d = 0;
        #10;

        // assert reset mid-stream, should immediately force q=0
        d = 1;
        #3; rst = 1;
        #1; 

        $finish;
    end
endmodule
