`timescale 1ns/1ps

module tb_data_mem;
    reg        clk = 0;
    reg        we;
    reg  [1:0] addr;
    reg  [7:0] wdata;
    wire [7:0] rdata;

    data_mem dut (
        .clk(clk), .we(we),
        .addr(addr), .wdata(wdata),
        .rdata(rdata)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_data_mem);
        $monitor("time=%0t | we=%b addr=%b wdata=%d | rdata=%d", $time, we, addr, wdata, rdata);

        we = 0; addr = 0; wdata = 0;

        // check preloaded values (Program 1's inputs)
        addr = 2'b10; #10;   // expect rdata = 5
        addr = 2'b11; #10;   // expect rdata = 7

        // write a new value into address 0, then read it back
        we = 1; addr = 2'b00; wdata = 8'd42;
        #10;                  // clock edge -- write commits
        we = 0;
        #10;                  // expect rdata = 42

        $finish;
    end
endmodule
