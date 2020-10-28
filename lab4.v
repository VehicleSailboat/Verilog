module lab4(
input CLOCK_50,
input [9:0] SW,
output reg [6:0] HEX0,HEX1,HEX2,HEX3,
output [9:0] LEDR,
output [7:0] LEDG
);

initial
begin

end
reg [1:0] state=2'b00;


//нажатие кнопок
wire reset,a,b,c;
reg [2:0] reset_sync,a_sync,b_sync,c_sync;

always @(posedge CLOCK_50) 
begin
	reset_sync[0] <= SW[0];
	reset_sync[1] <= reset_sync[0];
	reset_sync[2] <= reset_sync[1];
end
assign reset = (~reset_sync[2] & reset_sync[1]);

always @(posedge CLOCK_50) 
begin
	a_sync[0] <= SW[1];
	a_sync[1] <= a_sync[0];
	a_sync[2] <= a_sync[1];
end
assign a = (~a_sync[2] & a_sync[1]);

always @(posedge CLOCK_50) 
begin
	b_sync[0] <= SW[2];
	b_sync[1] <= b_sync[0];
	b_sync[2] <= b_sync[1];
end
assign b = (~b_sync[2] & b_sync[1]);

always @(posedge CLOCK_50) 
begin
	c_sync[0] <= SW[3];
	c_sync[1] <= c_sync[0];
	c_sync[2] <= c_sync[1];
end
assign c = (~c_sync[2] & c_sync[1]);
//нажатие кнопок

//конечный автомат
always @(posedge CLOCK_50 or posedge reset) 
begin
	if(reset) state<=2'b00;
	else 
	begin
		case(state)
			2'b00: //1
					begin
						if(c) begin state<=2'b01; end
					end
			2'b01: //2
					begin
						if(a) begin state<=2'b10; end
					end
			2'b10: //3
					begin
						if(a) begin state<=2'b11; end
						else if(b) begin state<=2'b00;  end
						else if(c) begin state<=2'b01;  end
					end
			2'b11: //4
					begin
						if(b) begin state<=2'b10; end
					end
		endcase
	end
end
//конечный автомат

//вывод состояния автомата
always @(*) 
begin
	case (state)
		2'h0: 
			begin
				HEX0 = 7'b1111001;//1
				HEX1 = 7'b1111001;//1
				HEX2 = 7'b1111001;//1
				HEX3 = 7'b1111001;//1
			end
		2'h1: 
			begin	
				HEX0 = 7'b0100100;//2
				HEX1 = 7'b0100100;//2
				HEX2 = 7'b0100100;//2
				HEX3 = 7'b0100100;//2
			end
		2'h2: 
			begin
				HEX0 = 7'b0110000;//3
				HEX1 = 7'b0110000;//3
				HEX2 = 7'b0110000;//3
				HEX3 = 7'b0110000;//3
			end	
		2'h3: 
			begin
				HEX0 = 7'b0011001;//4
				HEX1 = 7'b0011001;//4
				HEX2 = 7'b0011001;//4
				HEX3 = 7'b0011001;//4
			end
		default: HEX0 = 7'b1111111;
	endcase
end
//вывод состояния автомата



//СТРАДАЕМ ФИГНЁЙ

//мигалка на переключалку



//проверка на изменение состояния
reg state_change=0;
reg [1:0] state1=2'b00;

always @(posedge CLOCK_50)
begin
	if(state1==state) state_change<=0;
	else
		begin
			state_change<=1;
			state1<=state;
		end
end
//проверка на изменение состояния

//счётчик для мигалки
reg blinkout=0;
reg [22:0] blink_counter = 23'd0;
always @(posedge CLOCK_50)
begin
	if(blink)
		begin
			if(blink_counter==23'd5000000) 
				begin
					blinkout <= 1;
					blink_counter <= 23'd0;
				end
			else 
				begin
					blink_counter <= blink_counter + 1;
					blinkout <=0;
				end
		end
end
//счётчик для мигалки

//управление счётчиком
reg blink=0;
always @(posedge CLOCK_50)
begin
	if(state_change) blink<=1;
	else if (blinkout) blink<=0;
end
//управление счётчиком

//мигалка на переключалку

//крутилка фонариков
reg [22:0] change_counter=23'd0;
always @(posedge CLOCK_50)
begin
	if(change_counter==23'd12500000) change_counter<=0;
	else change_counter<=change_counter+1;
end

reg [9:0] RED=10'd5;
reg [7:0] GREEN=8'd4;

always @(posedge CLOCK_50)
begin
	if(change_counter==23'd12500000)
		begin
			RED   <= {RED[8:0], RED[9]};
			GREEN <= {GREEN[6:0], GREEN[7]};
		end
end
//крутилка фонариков

//вывод на фонарики
wire [9:0] red_blink;
wire [7:0] green_blink;

assign green_blink = blink ? (8'b11111111) : (8'b00000000);
assign red_blink = blink ? (10'b1111111111) : (10'b0000000000);


assign LEDR = red_blink|RED;
assign LEDG = green_blink|GREEN;
//вывод на фонарики

//СТРАДАЕМ ФИГНЁЙ

endmodule