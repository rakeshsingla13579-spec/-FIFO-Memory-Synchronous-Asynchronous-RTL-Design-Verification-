`timescale 1ns/1ps
module tb_fifo_sync();
    reg clk=0, reset=1, wr_en=0, rd_en=0;
    reg [7:0] din;
    wire [7:0] dout;
    wire full, empty;

    fifo_sync #(8,4) dut(clk, reset, wr_en, rd_en, din, dout, full, empty);

    always #5 clk = ~clk;

    initial begin
        $dumpfile("fifo_sync.vcd"); $dumpvars(0,dut);
        #10 reset=0;
        // Write data
        repeat(4) begin
            @(posedge clk); wr_en=1; din=$random;
        end
        @(posedge clk); wr_en=0;
        // Read data
        repeat(4) begin
            @(posedge clk); rd_en=1;
        end
        @(posedge clk); rd_en=0;
        #20 $finish;
    end
endmodule
