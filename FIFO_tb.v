module fifo_tb();

// Variables required for Test bench
reg clk, reset, write_en, read_en;
reg [7:0]data_in;
wire full, empty;
wire [7:0]data_out;
integer i;

// Instantiate the design
fif0 DUT(clk, reset, data_in, write_en, read_en, data_out, empty, full);

// Clock generation
initial
 begin
  clk=0;
  forever #10 clk=~clk;
 end

//Task Initialization
task initialization();
 begin
  {clk,reset,write_en,read_en,data_in}=0;
 end
endtask

//Task Reset
task rst_dut();
 begin
  @(negedge clk);
    reset = 1'b1;
  @(negedge clk);
    reset = 1'b0;
 end
endtask

//Task Write
task write_data(input [7:0]j);
 begin
  @(negedge clk)
   write_en = 1'b1;
   data_in = j;
 end
endtask

//Task Right
task read_data();
 begin
  @(negedge clk)
   read_en = 1'b1;
 end
endtask

//Procedural Stimulus
initial 
 begin
  initialization;
  rst_dut;
  for(i=0;i<16;i=i+1)
   begin
    write_data(i);
   end
  write_en = 1'b0;
  read_data;
end

initial
#1000 $finish;

//Display
initial
begin
 $monitor($time, "\n clk=%b, reset=%b, write_enable=%b, read_enable=%b, Data_in=%b, Data_out=%b, full=%b, empty=%b",clk,reset,write_en,read_en,data_in,data_out,full,empty);
end

endmodule
