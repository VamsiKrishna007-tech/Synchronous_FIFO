// Generator 

class generator;
transaction trans;
mailbox #(transaction) mbx;   //Mailbox to driver
event next;  //To know when to send next transaction
event done;     //Conveys completion of requested no. of transactions
int count=0;
int i=0;

function new( mailbox #(transaction) mbx);
	this.mbx = mbx;
endfunction

task main();
	repeat(count) 
	begin
	trans = new();
	assert(trans.randomize()) else $display("Randomization Failed");
	i++;
	mbx.put(trans);
	$display("[GEN] : Oper = %0d, \t Iteration = %0d",trans.oper, i);
	@(next);            // wait till scoreboard completes its process
	end
-> done;
endtask

endclass
