module file(
input [3:0] in1,in2,
input in3,
output [3:0] andl,andl1,andb,andb1
);
assign andb= (in1&&in2);
assign andb1= (in1&&in3);
assign andl= (in1&in2);
assign andl1= (in1&{in3,in3,in3,in3});

endmodule