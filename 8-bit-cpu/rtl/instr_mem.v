module instr_mem (
    input  wire [3:0] addr,
    output reg  [7:0] instr
);

    // The ROM itself: 16 addressable locations, 8 bits each.
    reg [7:0] rom [0:15];

    // Program 1: add two numbers, output result.
    //   0: LOAD  R0, [2]
    //   1: LOAD  R1, [3]
    //   2: ADD   R0, R1
    //   3: OUT   R0
    //   4: HALT
    //
    // Format: opcode(4) + operand(4)
    //   LOAD  = 0000, operand = [Rd(2)][Addr(2)]
    //   ADD   = 0010, operand = [Rd(2)][Rs(2)]
    //   OUT   = 0110, operand = [Rs(2)][unused(2)]
    //   HALT  = 1111, operand = unused
    initial begin
        // LOAD R0, [2]
        // opcode 0000, Rd=00 (R0), Addr=10 (address 2)
        rom[0] = 8'b0000_0010;

        // LOAD R1, [3]
        // opcode 0000, Rd=01 (R1), Addr=11 (address 3)
        rom[1] = 8'b0000_0111; 

        // ADD R0, R1
        // opcode 0010, Rd=00 (R0), Rs=01 (R1)
        rom[2] = 8'b0010_0001; 

        // OUT R0
        // opcode 0110, Rs=00 (R0), unused=00
        rom[3] = 8'b0110_0000; 

        // HALT
        // opcode 1111, operand unused (all 0)
        rom[4] = 8'b1111_0000;  
    end

    // no clock needed, since fetching shouldn't wait for anything.
    always @(*) begin
        instr = rom[addr];
    end

endmodule
