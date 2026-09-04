module register_file (
    input  wire        clk,
    input  wire        rst,     // synchronous reset -- clears all 32 registers to 0
    input  wire        we,      // write enable: 1 = perform the write this cycle
    input  wire [4:0]  waddr,   // which register to write (00000=x0 ... 11111=x31)
    input  wire [31:0] wdata,   // 32-bit value to write

    input  wire [4:0]  raddr1,  // which register to read onto rdata1
    input  wire [4:0]  raddr2,  // which register to read onto rdata2
    output reg  [31:0] rdata1,
    output reg  [31:0] rdata2
);

    // The actual storage: 32 registers, 32 bits each.
    reg [31:0] regs [0:31];
    
    integer i;

    // --- WRITE LOGIC (Sequential) ---
    always @(posedge clk) begin
        if (rst) begin
            // Reset all 32 registers using a loop
            for (i = 0; i < 32; i = i + 1) begin
                regs[i] <= 32'b0;
            end
        end else if (we) begin
            // RISC-V rule: Register 0 is hardwired to 0. 
            // We prevent writing to it if waddr == 0.
            if (waddr != 5'd0) begin
                regs[waddr] <= wdata;
            end
        end
    end

    // --- READ LOGIC (Combinational) ---
    // If the read address is 0, we force the output to 0 to be absolutely safe.
    always @(*) begin
        if (raddr1 == 5'd0) begin
            rdata1 = 32'b0;
        end else begin
            rdata1 = regs[raddr1];
        end

        if (raddr2 == 5'd0) begin
            rdata2 = 32'b0;
        end else begin
            rdata2 = regs[raddr2];
        end
    end

endmodule
