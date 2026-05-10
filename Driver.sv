// Driver

class driver;
 virtual fifo_if fifo;
 mailbox #(transaction) mbx;
 transaction trans;
 
 function new (mailbox #(transaction) mbx);
  this.mbx = mbx;
 endfunction
 
 // Reset Task
 task reset();
    fifo.rst <= 1'b1;
	fifo.write_en <= 1'b0;
	fifo.read_en <= 1'b0;
	fifo.data_in <= 8'b0;
	repeat(5) @(posedge fifo.clk);  // wait for 5 clock cycles
	fifo.rst <= 1'b0;
	@(posedge fifo.clk);
	$display("[DRV] : Reset Done");
	$display("------------------");
 endtask
 
 // Write Task
 task write();
    @(posedge fifo.clk);
    fifo.rst <= 1'b0;
	fifo.write_en <= 1'b1;
	fifo.read_en <= 1'b0;
	fifo.data_in <= $urandom_range(1,10);
	@(posedge fifo.clk);  
	fifo.write_en <= 1'b0;
    $display("[DRV] : Data_in = %0d", fifo.data_in);
	$display("------------------");
	@(posedge fifo.clk);
 endtask
 
 // Read Task
 task read();
    @(posedge fifo.clk);
    fifo.rst <= 1'b0;
	fifo.write_en <= 1'b0;
	fifo.read_en <= 1'b1;
	@(posedge fifo.clk);  
	fifo.read_en <= 1'b0;
    $display("[DRV] : Data_out = %0d", fifo.data_out);
	$display("------------------");
    @(posedge fifo.clk);
 endtask
 
 task main();
    forever begin
	mbx.get(trans);
	if(trans.oper == 1'b1)
	  read();
	else
	  write();
	end
  endtask
  
endclass