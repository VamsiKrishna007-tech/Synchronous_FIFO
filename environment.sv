// Environment 
 
class environment;

generator gen;
driver drv;
monitor mon;
scoreboard sco;

event next;   //generator to scoreboard

mailbox #(transaction) gmbx;  // generator to driver
mailbox #(transaction) mmbx;  // monitor to scoreboard
virtual fifo_if fifo;          // Interface 

function new( virtual fifo_if fifo);
	// Mailbox instantiation
	gmbx = new();
	mmbx = new();
	// Conecting mailbox with components
    gen = new(gmbx);
	drv = new(gmbx);
	mon = new(mmbx);
	sco = new(mmbx);
    // Connecting Event
	gen.next = next;
	sco.next = next;
	// Connecting Interfaces
	this.fifo = fifo;
	drv.fifo = this.fifo;
	mon.fifo = this.fifo;
endfunction

task pre_test();
   drv.reset();
endtask

task test();
fork
  gen.main();
  drv.main();
  mon.main();
  sco.main();
join_any
endtask

task post_test();
  wait(gen.done.triggered);
  $display("Error Count : %0d", sco.err);
  $finish();
endtask

task main();
  pre_test();
  test();
  post_test();
endtask

endclass
