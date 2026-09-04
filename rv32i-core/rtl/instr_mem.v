module instr_mem (
    input  wire [31:0] addr,
    output wire [31:0] instruction
);

    // 256 words of memory, each 32 bits wide (1 Kilobyte total)
    // In a real FPGA, this gets synthesized into Block RAM (BRAM).
    reg [31:0] mem [0:255];

    integer i;
    initial begin
        // Initialize everything to 0 by default
        for (i = 0; i < 256; i = i + 1) begin
            mem[i] = 32'h00000000;
        end
    end

    // --- The Byte-Addressable Trick ---
    // RISC-V addresses go up by 4 (0, 4, 8, 12, 16...).
    // But our Verilog array goes up by 1 (index 0, 1, 2, 3, 4...).
    // By ignoring the bottom 2 bits of the address (addr[1:0]), we are effectively 
    // dividing the address by 4. (e.g., Address 12 is binary 1100. Drop the 00, 
    // and you get binary 11, which is index 3!).
    // We use bits [9:2] to safely index up to 255 without going out of bounds.
    
    assign instruction = mem[addr[9:2]];

endmodule
