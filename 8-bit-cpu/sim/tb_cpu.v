`timescale 1ns/1ps

module tb_cpu;
    reg clk = 0;
    reg rst;
    wire [7:0] cpu_out;
    wire        out_valid;
    wire        halted;

    cpu dut (
        .clk(clk), .rst(rst),
        .cpu_out(cpu_out), .out_valid(out_valid), .halted(halted)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_cpu);
        $monitor("time=%0t | pc_out will be visible in GTKWave | cpu_out=%d out_valid=%b halted=%b",
                  $time, cpu_out, out_valid, halted);

        rst = 1;
        #12; rst = 0;

        // let the CPU run for several clock cycles -- enough to execute
        // all 5 instructions of Program 1 (LOAD, LOAD, ADD, OUT, HALT)
        #100;

        if (halted)
            $display("PASS: CPU halted as expected.");
        else
            $display("FAIL: CPU did not halt -- check your control unit / PC wiring.");

        $finish;
    end
endmodule
