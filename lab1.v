module lab1 (
	input      [9:0] SW,

	output     [7:0] HEX0,
	output reg [3:0] mux_out
);

	// DC1
	reg [3:0] dc1_out;
	
	always @(*)
	begin
		case (SW[3:0])
			4'b0001 : dc1_out = 4'd1;
			4'b0010 : dc1_out = 4'd1;
			4'b0011 : dc1_out = 4'd1;
			4'b0100 : dc1_out = 4'd1;
			4'b0101 : dc1_out = 4'd2;
			4'b0110 : dc1_out = 4'd1;
			4'b0111 : dc1_out = 4'd1;
			4'b1001 : dc1_out = 4'd1;
			4'b1010 : dc1_out = 4'd1;
			4'b1011 : dc1_out = 4'd1;
			4'b1101 : dc1_out = 4'd1;
			
			default : dc1_out = 4'd0;
		endcase
	end

	// DC2
	wire [3:0] dc2_out;
	assign dc2_out = ~SW[7:4];
	
	
	// f
	wire f_out;
	
	assign f_out = ~SW[0] || ~SW[1] || ~SW[2] || ~SW[3];
	
	// MUX
	// reg [3:0] mux_out;
	
	always @(*)
	begin
		case (SW[9:8])
			2'b00 : mux_out = dc1_out;
			2'b01 : mux_out = dc2_out;
			2'b10 : mux_out = f_out;
			2'b11 : mux_out = SW[3:0];
			
			default : mux_out = 4'd0;
		endcase
	end
	
	// DC-HEX
	reg [6:0] hex_inv;
	
	always @(*)
	begin
		case (mux_out)
			4'h0 : hex_inv = 7'b0000001;
			4'h1 : hex_inv = 7'b1001111;
			4'h2 : hex_inv = 7'b0010010;
			4'h3 : hex_inv = 7'b0000110;
			4'h4 : hex_inv = 7'b1001100;
			4'h5 : hex_inv = 7'b0100100;
			4'h6 : hex_inv = 7'b0100000;
			4'h7 : hex_inv = 7'b0001111;
			4'h8 : hex_inv = 7'b0000000;
			4'h9 : hex_inv = 7'b0000100;
			4'hA : hex_inv = 7'b0001000;
			4'hB : hex_inv = 7'b1100000;
			4'hC : hex_inv = 7'b0110001;
			4'hD : hex_inv = 7'b1000010;
			4'hE : hex_inv = 7'b0110000;
			4'hF : hex_inv = 7'b0111000;
		endcase
	end

	
	assign HEX0[6] = hex_inv[0];
	assign HEX0[5] = hex_inv[1];
	assign HEX0[4] = hex_inv[2];
	assign HEX0[3] = hex_inv[3];
	assign HEX0[2] = hex_inv[4];
	assign HEX0[1] = hex_inv[5];
	assign HEX0[0] = hex_inv[6];
	
endmodule
