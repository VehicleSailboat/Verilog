module lab2 (
	input CLK50,
	input  [1:0] KEY,
	input  [9:0] SW,
	output [6:0] HEX0,HEX1,
	output [9:0] LEDR
);
//clicks

reg [2:0] button1_syncroniser, button2_syncroniser;
wire sbutton1, button2;

always @(posedge CLK50) begin
	button1_syncroniser[0] <= KEY[0];
	button1_syncroniser[1] <= button1_syncroniser[0];
	button1_syncroniser[2] <= button1_syncroniser[1];
end
assign sbutton1 = (~button1_syncroniser[2] & button1_syncroniser[1]);
 
 always @(posedge CLK50) begin
	button2_syncroniser[0] <= KEY[1];
	button2_syncroniser[1] <= button2_syncroniser[0];
	button2_syncroniser[2] <= button2_syncroniser[1];
end
assign button2 = (~button2_syncroniser[2] & button2_syncroniser[1]);

//both_click_defence

wire button1;
assign button1 = (~button2 & sbutton1);

//reg

reg [9:0] tencount;
always @(posedge CLK50 or posedge button2) begin
	if (button2) tencount <= 0;
	else if (button1) tencount <= SW;
end

//event
reg sw_event;
always @(SW) begin
	if ((SW>10'd10)&(SW<10'd20)) sw_event <= 1'b1;
	else sw_event <= 1'b0;
end

reg [7:0] counter;
always @(posedge button1 or posedge button2) begin
	if (button2) counter <= 0;
	else if (sw_event) counter <= counter + 1;
end

////////out
//HEX
reg [7:0] fhex1,fhex2;
reg [6:0] HEXX1,HEXX0;
always @(counter)
begin
	fhex1 = (counter >> 4);
	fhex2 = (counter-(fhex1 << 4));
	//1 razr
	case (fhex1)
		8'h0 : HEXX0 = 7'b1000000;
		8'h1 : HEXX0 = 7'b0110000;
		8'h2 : HEXX0 = 7'b1101101;
		8'h3 : HEXX0 = 7'b1111001;
		8'h3 : HEXX0 = 7'b1111001;
		8'h4 : HEXX0 = 7'b0110011;
		8'h5 : HEXX0 = 7'b1011011;
		8'h6 : HEXX0 = 7'b1011111;
		8'h7 : HEXX0 = 7'b1110000;
		8'h8 : HEXX0 = 7'b1111111;
		8'h9 : HEXX0 = 7'b1111011;
		8'hA : HEXX0 = 7'b1110111;
		8'hB : HEXX0 = 7'b0011111;
		8'hC : HEXX0 = 7'b1001110;
		8'hD : HEXX0 = 7'b0111101;
		8'hE : HEXX0 = 7'b1001111;
		8'hF : HEXX0 = 7'b1000111;
	endcase
	//2 razr
	case (fhex2)
		8'h0 : HEXX1 = 7'b1000000;
		8'h1 : HEXX1 = 7'b0110000;
		8'h2 : HEXX1 = 7'b1101101;
		8'h3 : HEXX1 = 7'b1111001;
		8'h3 : HEXX1 = 7'b1111001;
		8'h4 : HEXX1 = 7'b0110011;
		8'h5 : HEXX1 = 7'b1011011;
		8'h6 : HEXX1 = 7'b1011111;
		8'h7 : HEXX1 = 7'b1110000;
		8'h8 : HEXX1 = 7'b1111111;
		8'h9 : HEXX1 = 7'b1111011;
		8'hA : HEXX1 = 7'b1110111;
		8'hB : HEXX1 = 7'b0011111;
		8'hC : HEXX1 = 7'b1001110;
		8'hD : HEXX1 = 7'b0111101;
		8'hE : HEXX1 = 7'b1001111;
		8'hF : HEXX1 = 7'b1000111;
	endcase		
end
assign HEX0=HEXX0;
assign HEX1=HEXX1;

//LEDR
assign LEDR=(~tencount);


endmodule