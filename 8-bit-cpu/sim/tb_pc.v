`timescale 1ns/1ps

module tb_pc;
    reg        clk = 0;
    reg        rst;
    reg        jump_en;
    reg  [3:0] jump_addr;
    wire [3:0] pc_out;

    pc dut (
        .clk(clk), .rst(rst),
        .jump_en(jump_en), .jump_addr(jump_addr),
        .pc_out(pc_out)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_pc);
        $monitor("time=%0t | rst=%b jump_en=%b jump_addr=%d | pc_out=%d", $time, rst, jump_en, jump_addr, pc_out);

        rst = 1; jump_en = 0; jump_addr = 0;
        #12; rst = 0;         // pc should be 0 after this

        #40;                   // letting it free-run for 4 clock edges -- expecting pc to reach 4

        jump_en = 1; jump_addr = 4'd9;
        #10;                    // one clock edge -- expecting pc to jump straight to 9

        jump_en = 0;
        #30;                     // free-running again for 3 more edges -- expecting pc to reach 12

        $finish;
    end
endmodule
