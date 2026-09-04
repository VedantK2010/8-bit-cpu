module data_mem (
    input  wire       clk,
    input  wire       we,       // write enable
    input  wire [1:0] addr,     // only 4 locations (2-bit), per the ISA's LOAD/STORE format
    input  wire [7:0] wdata,
    output reg  [7:0] rdata
);

    reg [7:0] ram [0:3];

    initial begin
        ram[0] = 8'd0;
        ram[1] = 8'd0;
        ram[2] = 8'd5;   
        ram[3] = 8'd7;   
    end

    // synchronous (only on a clock edge), and only when we=1.
    always @(posedge clk) begin
        if (we)
            ram[addr]<=wdata;
    end

    // reading shouldn't need to wait for a clock edge.
    always @(*) begin
        rdata = ram[addr];
    end

endmodule
