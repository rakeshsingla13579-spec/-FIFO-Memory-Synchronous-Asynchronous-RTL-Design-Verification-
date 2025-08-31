module fifo_async #(parameter WIDTH=8, DEPTH=8) (
    input wr_clk, rd_clk, reset,
    input wr_en, rd_en,
    input [WIDTH-1:0] din,
    output reg [WIDTH-1:0] dout,
    output reg full, empty
);
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    reg [$clog2(DEPTH):0] wr_ptr_bin, rd_ptr_bin;
    reg [$clog2(DEPTH):0] wr_ptr_gray, rd_ptr_gray;
    reg [$clog2(DEPTH):0] wr_ptr_gray_rdclk, rd_ptr_gray_wrclk;

    // Gray encode/decode
    function [$clog2(DEPTH):0] bin2gray(input [$clog2(DEPTH):0] b);
        bin2gray = b ^ (b >> 1);
    endfunction

    // Write domain
    always @(posedge wr_clk or posedge reset) begin
        if (reset) begin
            wr_ptr_bin <= 0; wr_ptr_gray <= 0; full <= 0;
        end else begin
            if (wr_en && !full) begin
                mem[wr_ptr_bin[$clog2(DEPTH)-1:0]] <= din;
                wr_ptr_bin <= wr_ptr_bin + 1;
                wr_ptr_gray <= bin2gray(wr_ptr_bin + 1);
            end
            full <= (bin2gray(wr_ptr_bin + 1) == {~rd_ptr_gray_wrclk[$clog2(DEPTH):$clog2(DEPTH)-1], rd_ptr_gray_wrclk[$clog2(DEPTH)-2:0]});
        end
    end

    // Read domain
    always @(posedge rd_clk or posedge reset) begin
        if (reset) begin
            rd_ptr_bin <= 0; rd_ptr_gray <= 0; dout <= 0; empty <= 1;
        end else begin
            if (rd_en && !empty) begin
                dout <= mem[rd_ptr_bin[$clog2(DEPTH)-1:0]];
                rd_ptr_bin <= rd_ptr_bin + 1;
                rd_ptr_gray <= bin2gray(rd_ptr_bin + 1);
            end
            empty <= (rd_ptr_gray == wr_ptr_gray_rdclk);
        end
    end

    // Simple 2FF sync for CDC (simulate)
    always @(posedge wr_clk) rd_ptr_gray_wrclk <= rd_ptr_gray;
    always @(posedge rd_clk) wr_ptr_gray_rdclk <= wr_ptr_gray;

endmodule
