`timescale 1ns/1ps

module tb_traffic_light;
    reg clk = 0;
    reg rst;
    wire [1:0] light;

    traffic_light dut (
        .clk(clk),
        .rst(rst),
        .light(light)
    );

    always #5 clk = ~clk;   // 10-unit clock period

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_traffic_light);

        $display("Encoding: 00=RED  01=YELLOW  10=GREEN");
        $display("Expected sequence: RED x4 cycles -> GREEN x4 cycles -> YELLOW x2 cycles -> repeat");
        $monitor("time=%0t | light=%b", $time, light);

        rst = 1;
        #12;          // hold reset through at least one clock edge
        rst = 0;

        #250;         // let it run through more than 2 full cycles (each full cycle = 10 clk periods = 100 time units)

        $finish;
    end
endmodule
