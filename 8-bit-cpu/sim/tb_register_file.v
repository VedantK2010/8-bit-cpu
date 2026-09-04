`timescale 1ns/1ps

module tb_register_file;
    reg        clk = 0;
    reg        rst;
    reg        we;
    reg  [1:0] waddr;
    reg  [7:0] wdata;
    reg  [1:0] raddr1, raddr2;
    wire [7:0] rdata1, rdata2;

    register_file dut (
        .clk(clk), .rst(rst),
        .we(we), .waddr(waddr), .wdata(wdata),
        .raddr1(raddr1), .raddr2(raddr2),
        .rdata1(rdata1), .rdata2(rdata2)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_register_file);
        $monitor("time=%0t | we=%b waddr=%b wdata=%h | raddr1=%b raddr2=%b | rdata1=%h rdata2=%h",
                  $time, we, waddr, wdata, raddr1, raddr2, rdata1, rdata2);

        rst = 1; we = 0; waddr = 0; wdata = 0; raddr1 = 0; raddr2 = 0;
        #12; rst = 0;

        we = 1; waddr = 2'b00; wdata = 8'd5;
        #10;

        waddr = 2'b01; wdata = 8'd7;
        #10;

        we = 0;                     
        raddr1 = 2'b00;            
        raddr2 = 2'b01;             
        #10;                        

        we = 1; waddr = 2'b00; wdata = 8'd12;
        #10;

        we = 0;
        raddr1 = 2'b00;
        #10;

        $finish;
    end
endmodule
