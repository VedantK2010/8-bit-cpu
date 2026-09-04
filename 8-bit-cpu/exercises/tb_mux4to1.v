`timescale 1ns/1ps

module tb_mux4to1;
    reg  [3:0] in0, in1, in2, in3;
    reg  [1:0] sel;
    wire [3:0] y;

    mux4to1 dut (
        .in0(in0), .in1(in1), .in2(in2), .in3(in3),
        .sel(sel),
        .y(y)
    );

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_mux4to1);

        in0 = 4'hA; in1 = 4'hB; in2 = 4'hC; in3 = 4'hD;

        $display("sel | y    (expected)");

        sel = 2'b00; #10;
        $display(" %b | %h    (y=a, picks in0)", sel, y);

        sel = 2'b01; #10;
        $display(" %b | %h    (y=b, picks in1)", sel, y);

        sel = 2'b10; #10;
        $display(" %b | %h    (y=c, picks in2)", sel, y);

        sel = 2'b11; #10;
        $display(" %b | %h    (y=d, picks in3)", sel, y);

        $finish;
    end
endmodule
