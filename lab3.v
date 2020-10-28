module lab3(
	input CLOCK_50,
	input  [2:0] KEY,
	input [9:0] SW,
	output reg [6:0] HEX0,HEX1, HEX2, HEX3,
	output [9:0] LEDR
);

//нажатие кнопок
wire start_stop,reset,mytask;
reg [2:0] start_stop_sync, mytask_sync, reset_sync=0;

always @(posedge CLOCK_50) 
begin
	start_stop_sync[0] <= KEY[0];
	start_stop_sync[1] <= start_stop_sync[0];
	start_stop_sync[2] <= start_stop_sync[1];
end
assign start_stop = (~start_stop_sync[2] & start_stop_sync[1]);

always @(posedge CLOCK_50) 
begin
	mytask_sync[0] <= KEY[1];
	mytask_sync[1] <= mytask_sync[0];
	mytask_sync[2] <= mytask_sync[1];
end
assign mytask = (~mytask_sync[2] & mytask_sync[1]);

always @(posedge CLOCK_50) 
begin
	reset_sync[0] <= KEY[2];
	reset_sync[1] <= reset_sync[0];
	reset_sync[2] <= reset_sync[1];
end
assign reset = (~reset_sync[2] & reset_sync[1]);
//нажатие кнопок

//счетчики

//стоп/пуск
/*reg device_running=0;
always @(*) 
begin
	if(reset) device_running=0;
	else if(start_stop) device_running<=~device_running;
end*/
wire count=SW[9];
wire device_running=SW[8];
/*
reg count=1;
always @(*) 
begin
	if(reset) count=1;
	else if(mytask) count<=~count;
end
*/

//стоп/пуск

//счётчик тактов выдающий сигнал о прошествии 1/100 секунды
reg [18:0] pulse_counter = 19'd0;
wire hundredth_of_second_passed = count?(pulse_counter == 19'd499999):(pulse_counter == 19'd0);

always @(posedge CLOCK_50 or posedge reset) 
begin
	if (reset) pulse_counter <= 0;//асинхронный сброс
	else if(count)
			begin
				if ( device_running | hundredth_of_second_passed)
					if (hundredth_of_second_passed) pulse_counter <= 0;
					else pulse_counter <= pulse_counter + 1;
			end
			else
			begin
				if ( device_running | hundredth_of_second_passed)
					if (hundredth_of_second_passed) pulse_counter <= 19'd499999;
					else pulse_counter <= pulse_counter - 1;		
			end
end
//счётчик тактов выдающий сигнал о прошествии 1/100 секунды


//счётчик сотых долей выдающий сигнал о проществии 1/10 секунды
reg [3:0] hundredths_counter = 4'd0;
wire tenth_of_second_passed =count?((hundredths_counter == 4'd9) & hundredth_of_second_passed):((hundredths_counter == 4'd0) & hundredth_of_second_passed);

always @(posedge CLOCK_50 or posedge reset) 
begin
	if (reset) hundredths_counter <= 0;
	else if(count)
		begin
		if (hundredth_of_second_passed)
			if (tenth_of_second_passed) hundredths_counter <= 0;
			else hundredths_counter <= hundredths_counter + 1;
		end
	else if(~count)
		begin
		if (hundredth_of_second_passed)
			if (tenth_of_second_passed) hundredths_counter <= 9;
			else hundredths_counter <= hundredths_counter - 1;
		end
end
//счётчик сотых долей выдающий сигнал о проществии 1/10 секунды

//счётчик десятых долей выдающий сигнал о проществии 1 секунды
reg [3:0] tenths_counter = 4'd0;
wire second_passed = count ? ((tenths_counter == 4'd9) & tenth_of_second_passed) : ((tenths_counter == 4'd0) & tenth_of_second_passed);


always @(posedge CLOCK_50 or posedge reset) 
begin
	if (reset) tenths_counter <= 0;
	else if(count)
			begin
				if (tenth_of_second_passed)
					if (second_passed) tenths_counter <= 0;
					else tenths_counter <= tenths_counter + 1;
			end
			else if(~count)
			begin
				if (tenth_of_second_passed)
					if (second_passed) tenths_counter <= 9;
					else tenths_counter <= tenths_counter - 1;	
			end
end
//счётчик десятых долей выдающий сигнал о проществии 1 секунды

//счётчик секунд выдающий сигнал о проществии 10 секунд
reg [3:0] seconds_counter = 4'd0;
wire ten_seconds_passed =count?((seconds_counter == 4'd9) & second_passed):((seconds_counter == 4'd0) & second_passed);

always @(posedge CLOCK_50 or posedge reset) 
begin
	if (reset) seconds_counter <= 0;
	else if(count)
			begin
				if (second_passed)
					if (ten_seconds_passed) seconds_counter <= 0;
					else seconds_counter <= seconds_counter + 1;
			end
			else if(~count)
			begin
				if (second_passed)
					if (ten_seconds_passed) seconds_counter <= 9;
					else seconds_counter <= seconds_counter - 1;
			end
end
//счётчик секунд выдающий сигнал о проществии 10 секунд


//счётчик десятков секунд
reg [3:0] ten_seconds_counter = 4'd0;

always @(posedge CLOCK_50 or posedge reset) 
begin
	if (reset) ten_seconds_counter <= 0;
	else if(count)
			begin
				if (ten_seconds_passed)
					if (ten_seconds_counter == 4'd9) ten_seconds_counter <= 0;
					else ten_seconds_counter <= ten_seconds_counter + 1;
			end
			else if(~count)
			begin
				if (ten_seconds_passed)
					if (ten_seconds_counter == 4'd0) ten_seconds_counter <= 9;
					else ten_seconds_counter <= ten_seconds_counter - 1;
			end
end
//счётчик десятков секунд

//счетчики


//вывод чисел
always @(*) 
begin
	case (hundredths_counter)
		8'h0: HEX0 = 7'b1000000;//0
		8'h1: HEX0 = 7'b1111001;//1
		8'h2: HEX0 = 7'b0100100;//2
		8'h3: HEX0 = 7'b0110000;//3
		8'h4: HEX0 = 7'b0011001;//4
		8'h5: HEX0 = 7'b0010010;//5
		8'h6: HEX0 = 7'b0000010;//6
		8'h7: HEX0 = 7'b1111000;//7
		8'h8: HEX0 = 7'b0000000;//8
		8'h9: HEX0 = 7'b0010000;//9
		default: HEX0 = 7'b1111111;
	endcase
end
always @(*) 
begin
	case (tenths_counter)
		8'h0: HEX1 = 7'b1000000;//0
		8'h1: HEX1 = 7'b1111001;//1
		8'h2: HEX1 = 7'b0100100;//2
		8'h3: HEX1 = 7'b0110000;//3
		8'h4: HEX1 = 7'b0011001;//4
		8'h5: HEX1 = 7'b0010010;//5
		8'h6: HEX1 = 7'b0000010;//6
		8'h7: HEX1 = 7'b1111000;//7
		8'h8: HEX1 = 7'b0000000;//8
		8'h9: HEX1 = 7'b0010000;//9
		default: HEX1 = 7'b1111111;
	endcase
end
always @(*) 
begin
	case (seconds_counter)
		8'h0: HEX2 = 7'b1000000;//0
		8'h1: HEX2 = 7'b1111001;//1
		8'h2: HEX2 = 7'b0100100;//2
		8'h3: HEX2 = 7'b0110000;//3
		8'h4: HEX2 = 7'b0011001;//4
		8'h5: HEX2 = 7'b0010010;//5
		8'h6: HEX2 = 7'b0000010;//6
		8'h7: HEX2 = 7'b1111000;//7
		8'h8: HEX2 = 7'b0000000;//8
		8'h9: HEX2 = 7'b0010000;//9
		default: HEX2 = 7'b1111111;
	endcase
end
always @(*) 
begin
	case (ten_seconds_counter)
		8'h0: HEX3 = 7'b1000000;//0
		8'h1: HEX3 = 7'b1111001;//1
		8'h2: HEX3 = 7'b0100100;//2
		8'h3: HEX3 = 7'b0110000;//3
		8'h4: HEX3 = 7'b0011001;//4
		8'h5: HEX3 = 7'b0010010;//5
		8'h6: HEX3 = 7'b0000010;//6
		8'h7: HEX3 = 7'b1111000;//7
		8'h8: HEX3 = 7'b0000000;//8
		8'h9: HEX3 = 7'b0010000;//9
		default: HEX3 = 7'b1111111;
	endcase
end

//вывод чисел


endmodule
