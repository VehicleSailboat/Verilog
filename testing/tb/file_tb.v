`timescale 1ns/1ns

module tb();
reg [3:0] in1,in2;
reg in3;
wire [3:0] andl,andl1,andb,andb1;

//include testing module
file UUT(
 .in1(in1),
 .in2(in2),
 .in3(in3),
 .andl(andl),
 .andl1(andl1),
 .andb(andb),
 .andb1(andb1)
);
//include testing module

//setting sync clock
/*always begin
#10 clk=~clk;
end*/
//setting sync clock


//main part
initial begin
in1=4'b1101;
in2=4'b1011;
in3=0;
#20


$finish;
end
//main part


initial begin
  $dumpfile("file.vcd");
  $dumpvars;
end


endmodule