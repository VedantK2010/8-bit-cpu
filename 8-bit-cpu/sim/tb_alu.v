`timescale 1ns/1ps

module tb_alu;
    reg  [7:0] a, b;
    reg  [2:0] opcode;
    wire [7:0] result;
    wire       zero;

    alu dut (
        .a(a),
        .b(b),
        .opcode(opcode),
        .result(result),
        .zero(zero)
    );

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_alu);

        $display("op    a    b  | result zero   (expected)");

        a = 8'd10; b = 8'd5; opcode = 3'b000; #10;  // ADD
        $display("ADD  %3d  %3d |  %3d    %b    (result=15  zero=0)", a, b, result, zero);

        a = 8'd10; b = 8'd5; opcode = 3'b001; #10;  // SUB
        $display("SUB  %3d  %3d |  %3d    %b    (result=5   zero=0)", a, b, result, zero);

        a = 8'd10; b = 8'd10; opcode = 3'b001; #10; // SUB -> equal values, tests zero flag
        $display("SUB  %3d  %3d |  %3d    %b    (result=0   zero=1)", a, b, result, zero);

        a = 8'hF0; b = 8'h0F; opcode = 3'b010; #10; // AND
        $display("AND  %3h  %3h |  %3h    %b    (result=00  zero=1)", a, b, result, zero);

        a = 8'hF0; b = 8'h0F; opcode = 3'b011; #10; // OR
        $display("OR   %3h  %3h |  %3h    %b    (result=ff  zero=0)", a, b, result, zero);

        a = 8'hFF; b = 8'h0F; opcode = 3'b100; #10; // XOR
        $display("XOR  %3h  %3h |  %3h    %b    (result=f0  zero=0)", a, b, result, zero);

        $finish;
    end
endmodule
