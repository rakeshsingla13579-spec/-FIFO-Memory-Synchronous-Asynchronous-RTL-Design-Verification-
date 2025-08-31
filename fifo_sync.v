module fifo_sync #(parameter WIDTH=8, DEPTH=8) (
    input clk, reset,
    input wr_en, rd_en,
    input [WIDTH-1:0] din,
    output reg [WIDTH-1:0] dout,
    output reg full, empty
);
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    reg [$clog2(DEPTH):0] wr_ptr, rd_ptr, count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            wr_ptr <= 0; rd_ptr <= 0; count <= 0;
            full <= 0; empty <= 1; dout <= 0;
        end else begin
            // Write
            if (wr_en && !full) begin
                mem[wr_ptr] <= din;
                wr_ptr <= wr_ptr + 1;
                count <= count + 1;
            end
            // Read
            if (rd_en && !empty) begin
                dout <= mem[rd_ptr];
                rd_ptr <= rd_ptr + 1;
                count <= count - 1;
            end
            full <= (count == DEPTH);
            empty <= (count == 0);
        end
    end
endmodule
