module reg8 (
    input  wire       clk,
    input  wire       rst,    // asynchronous reset, active-high
    input  wire       load,   // when 1, capture d on the next clock edge; when 0, hold current value
    input  wire [7:0] d,
    output reg  [7:0] q
);
    always @(posedge clk or posedge rst) begin
        if (rst)
            q<=8'b0;
        else if (load)
            q<=d;
        else
            q<=q;
    end
endmodule
