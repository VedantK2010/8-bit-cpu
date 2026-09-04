module mux2to1 (
    input  wire a,      // input 0
    input  wire b,      // input 1
    input  wire sel,    // select: 0 -> choose a, 1 -> choose b
    output wire y        // output
);
assign y=sel?b:a;
endmodule
