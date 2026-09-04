`timescale 1ns/1ps

module tb_adder4;
    reg  [3:0] a, b;
    reg        cin;
    wire [3:0] sum;
    wire       cout;

    // instantiate the design under test
    adder4 dut (
        .a(a),
        .b(b),
        .cin(cin),
        .sum(sum),
        .cout(cout)
    );

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_adder4);

        $display(" a   b  cin | sum cout   (expected)");

        a = 4'd3;  b = 4'd2;  cin = 0; #10;
        $display("%2d  %2d   %b  |  %2d   %b     (sum=5  cout=0)", a, b, cin, sum, cout);

        a = 4'd15; b = 4'd1;  cin = 0; #10;
        $display("%2d  %2d   %b  |  %2d   %b     (sum=0  cout=1)", a, b, cin, sum, cout);

        a = 4'd7;  b = 4'd8;  cin = 1; #10;
        $display("%2d  %2d   %b  |  %2d   %b     (sum=0  cout=1)", a, b, cin, sum, cout);

        a = 4'd15; b = 4'd15; cin = 1; #10;
        $display("%2d  %2d   %b  |  %2d   %b     (sum=15 cout=1)", a, b, cin, sum, cout);

        $finish;
    end
endmodule
