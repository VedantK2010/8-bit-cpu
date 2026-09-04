`timescale 1ns/1ps

module tb_mux2to1;
    reg  a, b, sel;
    wire y;

    mux2to1 dut (
        .a(a),
        .b(b),
        .sel(sel),
        .y(y)
    );

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_mux2to1);

        $display(" a  b  sel | y   (expected)");

        a = 0; b = 1; sel = 0; #10;
        $display(" %b  %b   %b  | %b   (y=0, should pick a)", a, b, sel, y);

        a = 0; b = 1; sel = 1; #10;
        $display(" %b  %b   %b  | %b   (y=1, should pick b)", a, b, sel, y);

        a = 1; b = 0; sel = 0; #10;
        $display(" %b  %b   %b  | %b   (y=1, should pick a)", a, b, sel, y);

        a = 1; b = 0; sel = 1; #10;
        $display(" %b  %b   %b  | %b   (y=0, should pick b)", a, b, sel, y);

        $finish;
    end
endmodule
