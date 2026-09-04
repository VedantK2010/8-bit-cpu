`timescale 1ns/1ps

module tb_imm_generator;

    reg  [31:0] instruction;
    reg  [2:0]  imm_src;
    wire [31:0] imm_ext;

    // Instantiate Immediate Generator
    imm_generator uut (
        .instruction(instruction),
        .imm_src(imm_src),
        .imm_ext(imm_ext)
    );

    initial begin
        $dumpfile("wave_imm.vcd");
        $dumpvars(0, tb_imm_generator);

        // 1. Test I-Type (addi x5, x0, -2)
        // Immediate is -2 (12-bit hex: FFE)
        instruction = {12'hFFE, 5'd0, 3'b000, 5'd5, 7'b0010011};
        imm_src = 3'b000;
        #10;
        // In 32-bit two's complement, -2 is FFFFFFFE
        if (imm_ext !== 32'hFFFF_FFFE) $display("FAIL: I-Type Sign Extension. Was %h", imm_ext);
        else $display("PASS: I-Type successfully extracted and sign-extended -2");

        // 2. Test S-Type (sw x5, 20(x1))
        // Immediate is 20. Bits [11:5] are 0000000, Bits [4:0] are 10100
        instruction = {7'b0000000, 5'd5, 5'd1, 3'b010, 5'b10100, 7'b0100011};
        imm_src = 3'b001;
        #10;
        if (imm_ext !== 32'd20) $display("FAIL: S-Type extraction. Was %d", imm_ext);
        else $display("PASS: S-Type successfully extracted positive 20");

        // 3. Test U-Type (lui x5, 4096)
        // Immediate is 4096 (1000 hex). It lives in bits [31:12].
        instruction = {20'h01000, 5'd5, 7'b0110111};
        imm_src = 3'b100;
        #10;
        // The output should be 1000 shifted left by 12 bits -> 0x01000000
        if (imm_ext !== 32'h0100_0000) $display("FAIL: U-Type extraction. Was %h", imm_ext);
        else $display("PASS: U-Type successfully placed in upper 20 bits");

        $display("All Immediate Generator tests completed!");
        $finish;
    end

endmodule
