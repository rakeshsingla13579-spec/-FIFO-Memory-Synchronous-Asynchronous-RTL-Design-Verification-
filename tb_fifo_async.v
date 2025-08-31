`timescale 1ns/1ps
module tb_fifo_async();
    reg wr_clk=0, rd_clk=0, reset=1;
    reg wr_en=0, rd_en=0;
    reg [7:0] din;
    wire [7:0] dout;
    wire full, empty;

    fifo_async #(8,4) dut(wr_clk, rd_clk, reset, wr_en, rd_en, din, dout, full, empty);

    always #5 wr_clk = ~wr_clk;
    always #7 rd_clk = ~rd_clk;

    initial begin
        $dumpfile("fifo_async.vcd"); $dumpvars(0,dut);
        #10 reset=0;
        // Write few values
        repeat(4) begin
            @(posedge wr_clk); wr_en=1; din=$random;
        end
        @(posedge wr_clk); wr_en=0;
        // Read values
        repeat(4) begin
            @(posedge rd_clk); rd_en=1;
        end
        @(posedge rd_clk); rd_en=0;
        #50 $finish;
    end
endmodule
