`timescale 1ns/1ps

module tb_reg8;
    reg        clk = 0;
    reg        rst;
    reg        load;
    reg  [7:0] d;
    wire [7:0] q;

    reg8 dut (
        .clk(clk),
        .rst(rst),
        .load(load),
        .d(d),
        .q(q)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_reg8);
        $monitor("time=%0t | rst=%b load=%b d=%h | q=%h", $time, rst, load, d, q);

        // start in reset
        rst = 1; load = 0; d = 8'h00;
        #12;

        // release reset, load is still 0 -- q should NOT capture d even though d changes
        rst = 0;
        #3;
        d = 8'hAA;         // change d, but load is 0
        #10;               // let a clock edge pass -- q should still be 0, load was off

        // now enable load and set a new value
        load = 1;
        d = 8'h55;
        #10;               // clock edge passes -- q should now capture 0x55

        // change d again but immediately drop load -- q should hold 0x55, ignore new d
        load = 0;
        d = 8'hFF;
        #10;

        // re-enable load with a new value
        load = 1;
        d = 8'h3C;
        #10;

        // assert reset mid-stream -- q should snap to 0 immediately, ignoring load/d
        #2; rst = 1;
        #1;

        $finish;
    end
endmodule
