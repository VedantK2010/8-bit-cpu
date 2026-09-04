module data_mem (
    input  wire        clk,
    input  wire        we,       // Write Enable: 1 = Write, 0 = Read
    input  wire [31:0] addr,     // Memory address (byte-addressed)
    input  wire [31:0] wdata,    // Data to store (for 'sw' instruction)
    output wire [31:0] rdata     // Data loaded (for 'lw' instruction)
);

    // 256 words of memory (1 Kilobyte of RAM)
    reg [31:0] mem [0:255];

    integer i;
    initial begin
        // Initialize RAM to 0
        for (i = 0; i < 256; i = i + 1) begin
            mem[i] = 32'd0;
        end
    end

    // --- WRITE LOGIC (Synchronous) ---
    // The Store Word (sw) instruction modifies memory on the clock edge
    always @(posedge clk) begin
        if (we) begin
            // Just like the Instruction Memory, we drop addr[1:0] 
            // to convert the byte address to a word index.
            mem[addr[9:2]] <= wdata;
        end
    end

    // --- READ LOGIC (Combinational) ---
    // The Load Word (lw) instruction reads memory instantly so the 
    // Register File can save it on the very same clock cycle.
    assign rdata = mem[addr[9:2]];

endmodule
