// Transaction

class transaction;
rand bit oper; 
bit write_en;
bit read_en;
bit [7:0]data_in;
bit full;
bit empty;
bit [7:0]data_out;

// 50% chance for operation to be 1(read) and 50% for 0(write) 
constraint oper_ctrl { oper dist {1:/ 50 , 0:/ 50}}; 

endclass