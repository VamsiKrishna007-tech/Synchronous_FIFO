// Top Block
`include "Interface.sv"
`include "Transaction.sv"
`include "Generator.sv"
`include "Driver.sv"
`include "monitor.sv"
`include "Scoreboard.sv"
`include "environment.sv"
`include "FIFO.v"

module tb_fifo;
fifo_if fifo();
environment env;

fifo DUT (.data_in(fifo.data_in), .data_out(fifo.data_out), .write_en(fifo.write_en), .clk(fifo.clk), .reset(fifo.rst), .read_en(fifo.read_en), .full(fifo.full), .empty(fifo.empty));

initial begin
 fifo.clk = 1'b0;
end

always #10 fifo.clk <= ~fifo.clk;

initial begin
  env = new(fifo);
  env.gen.count = 2;
  env.main();
end

initial begin
  $dumpfile("dump.vcd"); // Specify the VCD dump file
  $dumpvars; // Dump all variables
end
endmodule