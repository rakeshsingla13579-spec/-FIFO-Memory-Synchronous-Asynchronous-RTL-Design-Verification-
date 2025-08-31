# FIFO Memory (Sync + Async)

This project implements simple **synchronous** and **asynchronous FIFOs** in Verilog, with basic testbenches.

## Files
- `fifo_sync.v` – single-clock FIFO
- `fifo_async.v` – dual-clock FIFO (with CDC)
- `tb_fifo_sync.v` – testbench for sync FIFO
- `tb_fifo_async.v` – testbench for async FIFO

## Run (Icarus Verilog)
```bash
# Sync FIFO
iverilog -o fifo_sync fifo_sync.v tb_fifo_sync.v
vvp fifo_sync
gtkwave fifo_sync.vcd

# Async FIFO
iverilog -o fifo_async fifo_async.v tb_fifo_async.v
vvp fifo_async
gtkwave fifo_async.vcd
```

Works in EDA Playground too (put RTL in "Design", testbench in "Testbench").
