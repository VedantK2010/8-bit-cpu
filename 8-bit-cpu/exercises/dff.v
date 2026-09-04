module dff (
    input  wire clk,
    input  wire rst,   // asynchronous reset, active-high
    input  wire d,
    output reg  q
);
    always @(posedge clk or posedge rst) begin
        if (rst)
            q <= 1'b0;
        else
            q <= d;
    end
   endmodule
