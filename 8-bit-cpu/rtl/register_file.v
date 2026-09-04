module register_file (
    input  wire       clk,
    input  wire       rst,     // synchronous reset -- clears all 4 registers to 0
    input  wire       we,      // write enable: 1 = perform the write this cycle
    input  wire [1:0] waddr,   // which register to write (00=R0, 01=R1, 10=R2, 11=R3)
    input  wire [7:0] wdata,   // value to write

    input  wire [1:0] raddr1,  // which register to read onto rdata1
    input  wire [1:0] raddr2,  // which register to read onto rdata2
    output reg  [7:0] rdata1,
    output reg  [7:0] rdata2
);

    // The actual storage: 4 registers, 8 bits each.
    reg [7:0] regs [0:3];

    always @(posedge clk) begin
        if (rst) begin
            regs[0] <= 8'b0;
            regs[1] <= 8'b0;
            regs[2] <= 8'b0;
            regs[3] <= 8'b0;
        end else if (we) begin
            regs[waddr] <= wdata;
        end
    end

    always @(*) begin
        case (raddr1)
            2'b00: rdata1 = regs[0];
            2'b01: rdata1 = regs[1];
            2'b10: rdata1 = regs[2];
            2'b11: rdata1 = regs[3];
        endcase

        case (raddr2)
            2'b00: rdata2=regs[0];
            2'b01: rdata2=regs[1];
            2'b10: rdata2=regs[2];
            2'b11: rdata2=regs[3];
        endcase
    end

endmodule
