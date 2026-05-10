// Monitor

class monitor;
 transaction trans;
 virtual fifo_if fifo;
 mailbox #(transaction) mbx;
 
 function new( mailbox #(transaction) mbx);
   this.mbx = mbx;
 endfunction
 
 task main();
   forever begin
   trans = new();
   repeat(2) @(posedge fifo.clk);   //Wait for 2 clock cycles, since we are waiting for 2 clock cycles in driver
   trans.write_en = fifo.write_en;
   trans.read_en = fifo.read_en;
   trans.data_in = fifo.data_in;
   trans.full = fifo.full;
   trans.empty = fifo.empty;
   trans.data_out = fifo.data_out;
   mbx.put(trans);
   $display("Data_in = %0d, \t Data_out = %0d, \t write_en = %0d, \t read_en = %0d, \t full = %0d, \t empty = %0d",trans.data_in, trans.data_out, trans.write_en, trans.read_en, trans.full, trans.empty);
   end
 endtask
 
endclass