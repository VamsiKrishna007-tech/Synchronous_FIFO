module fifo( clk, reset, data_in, write_en, read_en, data_out, empty, full);
input clk, reset, write_en, read_en;
input [(width-1):0]data_in;
reg [4:0]write_ptr, read_ptr;
output full, empty;
output reg [(width-1):0]data_out;
reg [(width-1):0]memory[0:(depth-1)]; // Declare 8-bit wide memory having 16 locations
integer i;

parameter depth=16,    // Depth of FIFO memory
          width=8;     // Width of FIFO memory
          
// Write Operation
always@ (posedge clk)
begin
 if(reset)                    // If Reset triggered memory is cleared and write pointer is reset to 0
  begin
   for(i=0;i<depth;i=i+1)
    memory[i] <= 0;    
    write_ptr <= 0;
  end
 else if(write_en && !full)   // If write_en is high and memory is not full
  begin
   memory[write_ptr[3:0]] <= data_in;
   write_ptr <= write_ptr+1'b1;
  end
 else
   write_ptr <= write_ptr;
end
 
// Read Operation
always@ (posedge clk)
begin
 if(reset)                    // If Reset triggered output data is cleared and read pointer is reset to 0
  begin
   data_out <= 0;
   read_ptr <= 0;
  end
 else if(read_en && !empty)   // If read_en is high and memory is not empty
  begin
   data_out <= memory[read_ptr[3:0]];
   read_ptr <= read_ptr+1'b1;
  end
 else
   read_ptr <= read_ptr;
end

// Full Condition
assign full = ((write_ptr[4] != read_ptr[4]) && (write_ptr[3:0] == read_ptr[3:0])) ? 1'b1 : 1'b0;

// Empty Condition
assign empty = (write_ptr[4:0] == read_ptr[4:0]);

endmodule