// Scoreboard

class scoreboard;
transaction trans;
mailbox #(transaction) mbx;
event next;
bit [7:0] din[$];  //Queue
bit [7:0] temp;
int err = 0;

function new( mailbox #(transaction) mbx);
  this.mbx = mbx;
endfunction

task main();
  forever begin
  trans = new();
  mbx.get(trans);
  $display("Data_in = %0d, \t Data_out = %0d, \t write_en = %0d, \t read_en = %0d, \t full = %0d, \t empty = %0d",trans.data_in, trans.data_out, trans.write_en, trans.read_en, trans.full, trans.empty); 
  if(trans.write_en == 1'b1) begin
    if(trans.full == 1'b0) begin
	   din.push_front(trans.data_in);
	   $display("[SCO] : DATA STORED IN QUEUE : %0d",trans.data_in);
	end   
	else begin
	   $display("FIFO is FULL");
    end
  end
  else if(trans.read_en == 1'b1) begin
    if(trans.empty == 1'b0) begin
	   temp = din.pop_back();
	   if(trans.data_out == temp) begin
	    $display("[SCO] : DATA MATCH");
       end
	   else begin
	    $error("[SCO] : DATA MISMATCH");
		err++;
	   end
	end
	else begin
	   $display("[SCO] : FIFO IS EMPTY");
	end
  end
->next;
end
endtask

endclass