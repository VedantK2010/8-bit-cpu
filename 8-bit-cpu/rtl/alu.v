module alu (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire [2:0] opcode,
    output reg  [7:0] result,
    output wire        zero     
);
    // Opcode encoding
    localparam ADD = 3'b000;
    localparam SUB = 3'b001;
    localparam AND = 3'b010;
    localparam OR  = 3'b011;
    localparam XOR = 3'b100;

    always @(*) begin
        case (opcode)
            ADD: result = a + b;
            SUB: result = a-b;  
            AND: result = a&b; 
            OR:  result = a|b;  
            XOR: result = a^b;  
            default: result = 8'b0;
        endcase
    end
    assign zero = !(|result);

endmodule
