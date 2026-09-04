`timescale 1ns/1ps

module tb_alu;

    reg  [31:0] a;
    reg  [31:0] b;
    reg  [3:0]  alu_ctrl;
    wire [31:0] result;
    wire        zero;

    // Instantiate ALU
    alu uut (
        .a(a),
        .b(b),
        .alu_ctrl(alu_ctrl),
        .result(result),
        .zero(zero)
    );

    initial begin
        $dumpfile("wave_alu.vcd");
        $dumpvars(0, tb_alu);

        // 1. Test ADD
        a = 32'd15; b = 32'd10; alu_ctrl = 4'b0000;
        #10;
        if (result !== 32'd25) $display("FAIL: ADD");
        else $display("PASS: ADD (15 + 10 = 25)");

        // 2. Test SUB
        a = 32'd20; b = 32'd8; alu_ctrl = 4'b0001;
        #10;
        if (result !== 32'd12) $display("FAIL: SUB");
        else $display("PASS: SUB (20 - 8 = 12)");

        // 3. Test Zero Flag (used for BEQ)
        a = 32'd42; b = 32'd42; alu_ctrl = 4'b0001; // SUB
        #10;
        if (zero !== 1'b1) $display("FAIL: ZERO FLAG");
        else $display("PASS: ZERO FLAG (42 - 42 = 0, zero flag is HIGH)");

        // 4. Test AND
        a = 32'h0000_FFFF; b = 32'hFFFF_0000; alu_ctrl = 4'b0010;
        #10;
        if (result !== 32'h0000_0000) $display("FAIL: AND");
        else $display("PASS: AND bitwise logic works");

        // 5. Test SLT (Set Less Than) with Signed Numbers
        // a = -5, b = 10. (-5 < 10, so result should be 1)
        a = -32'd5; b = 32'd10; alu_ctrl = 4'b0101;
        #10;
        if (result !== 32'd1) $display("FAIL: SLT (Signed Negative)");
        else $display("PASS: SLT (Negative a < Positive b -> Result = 1)");

        // 6. Test SLT with positive numbers
        a = 32'd100; b = 32'd50; alu_ctrl = 4'b0101;
        #10;
        if (result !== 32'd0) $display("FAIL: SLT (Signed Positive)");
        else $display("PASS: SLT (100 is NOT < 50 -> Result = 0)");

        $display("All ALU tests completed!");
        $finish;
    end

endmodule
