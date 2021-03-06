
module display(row, col, red, green, blue, speed, up, down, left, right, missile, vnotactive, CLK, RST);
	input [31:0] row, col;
	input CLK, RST, speed, up, down, left, right, missile, vnotactive;
	output red, green, blue;
	reg red, green, blue;
	reg activeflag;
	reg appearflag;
	reg moveflag;
	reg moveflag_2;
	reg [1:0] endflag;
	reg [63:0] clockcounter;
	reg [7:0] board [0:15];
	reg [7:0] origin [0:15];
	reg [4:0] cell_index;
	reg [31:0] cell_position_row [0:15];
	reg [31:0] cell_position_col [0:15];
	reg [31:0] to_left [0:15];
	reg [31:0] to_right [0:15];
	reg [31:0] to_up [0:15];
	reg [31:0] to_down [0:15];
	reg [31:0] moveclocker;
	reg [31:0] movecounter;
	reg [63:0] jet_pos;
	reg clockflag;
	reg missileclockflag;
	reg [31:0] missile_col, missile_row;
	reg [2:0] missile_flag;
	parameter CELL_SIZE = 100;
	parameter BORDER_WIDTH = 10;
	
	always @(posedge CLK or negedge RST) begin
		if(!RST) begin
			{red, green, blue} <= 3'b111;
			cell_position_row[0] <= CELL_SIZE*1+BORDER_WIDTH;
			cell_position_row[4] <= CELL_SIZE*1+BORDER_WIDTH;
			cell_position_row[8] <= CELL_SIZE*1+BORDER_WIDTH;
			cell_position_row[12] <= CELL_SIZE*1+BORDER_WIDTH;
			cell_position_row[1] <= CELL_SIZE*2+BORDER_WIDTH;
			cell_position_row[5] <= CELL_SIZE*2+BORDER_WIDTH;
			cell_position_row[9] <= CELL_SIZE*2+BORDER_WIDTH;
			cell_position_row[13] <= CELL_SIZE*2+BORDER_WIDTH;
			cell_position_row[2] <= CELL_SIZE*3+BORDER_WIDTH;
			cell_position_row[6] <= CELL_SIZE*3+BORDER_WIDTH;
			cell_position_row[10] <= CELL_SIZE*3+BORDER_WIDTH;
			cell_position_row[14] <= CELL_SIZE*3+BORDER_WIDTH;
			cell_position_row[3] <= CELL_SIZE*4+BORDER_WIDTH;
			cell_position_row[7] <= CELL_SIZE*4+BORDER_WIDTH;
			cell_position_row[11] <= CELL_SIZE*4+BORDER_WIDTH;
			cell_position_row[15] <= CELL_SIZE*4+BORDER_WIDTH;
			
			cell_position_col[0] <= CELL_SIZE*2+BORDER_WIDTH;
			cell_position_col[1] <= CELL_SIZE*2+BORDER_WIDTH;
			cell_position_col[2] <= CELL_SIZE*2+BORDER_WIDTH;
			cell_position_col[3] <= CELL_SIZE*2+BORDER_WIDTH;
			cell_position_col[4] <= CELL_SIZE*3+BORDER_WIDTH;
			cell_position_col[5] <= CELL_SIZE*3+BORDER_WIDTH;
			cell_position_col[6] <= CELL_SIZE*3+BORDER_WIDTH;
			cell_position_col[7] <= CELL_SIZE*3+BORDER_WIDTH;
			cell_position_col[8] <= CELL_SIZE*4+BORDER_WIDTH;
			cell_position_col[9] <= CELL_SIZE*4+BORDER_WIDTH;
			cell_position_col[10] <= CELL_SIZE*4+BORDER_WIDTH;
			cell_position_col[11] <= CELL_SIZE*4+BORDER_WIDTH;
			cell_position_col[12] <= CELL_SIZE*5+BORDER_WIDTH;
			cell_position_col[13] <= CELL_SIZE*5+BORDER_WIDTH;
			cell_position_col[14] <= CELL_SIZE*5+BORDER_WIDTH;
			cell_position_col[15] <= CELL_SIZE*5+BORDER_WIDTH;
			
		end
		else begin
			if(col >= CELL_SIZE*2-BORDER_WIDTH && col <= CELL_SIZE*6+BORDER_WIDTH && row >= CELL_SIZE-BORDER_WIDTH && row <= CELL_SIZE*5+BORDER_WIDTH) begin
				if(row >= CELL_SIZE-BORDER_WIDTH && row <= CELL_SIZE+BORDER_WIDTH) {red, green, blue} <= 3'b000;
				else if(row >= CELL_SIZE*2-BORDER_WIDTH && row <= CELL_SIZE*2+BORDER_WIDTH) {red, green, blue} <= 3'b000;
				else if(row >= CELL_SIZE*3-BORDER_WIDTH && row <= CELL_SIZE*3+BORDER_WIDTH) {red, green, blue} <= 3'b000;
				else if(row >= CELL_SIZE*4-BORDER_WIDTH && row <= CELL_SIZE*4+BORDER_WIDTH) {red, green, blue} <= 3'b000;
				else if(row >= CELL_SIZE*5-BORDER_WIDTH && row <= CELL_SIZE*5+BORDER_WIDTH) {red, green, blue} <= 3'b000;
				else if(col >= CELL_SIZE*2-BORDER_WIDTH && col <= CELL_SIZE*2+BORDER_WIDTH) {red, green, blue} <= 3'b000;
				else if(col >= CELL_SIZE*3-BORDER_WIDTH && col <= CELL_SIZE*3+BORDER_WIDTH) {red, green, blue} <= 3'b000;
				else if(col >= CELL_SIZE*4-BORDER_WIDTH && col <= CELL_SIZE*4+BORDER_WIDTH) {red, green, blue} <= 3'b000;
				else if(col >= CELL_SIZE*5-BORDER_WIDTH && col <= CELL_SIZE*5+BORDER_WIDTH) {red, green, blue} <= 3'b000;
				else if(col >= CELL_SIZE*6-BORDER_WIDTH && col <= CELL_SIZE*6+BORDER_WIDTH) {red, green, blue} <= 3'b000;
				else if(cell_index == 5'd16) {red, green, blue} <= 3'b111;
				else if(origin[cell_index] == 8'd0) {red, green, blue} <= 3'b111;
				else if(origin[cell_index] == 8'd1) begin
					if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+3*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(3+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+2*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(2+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+7*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(7+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+2*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(2+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+1*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(1+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+3*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(3+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+2*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(2+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+3*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(3+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+6*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(6+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+3*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(3+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+7*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(7+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+3*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(3+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+1*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(1+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+4*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(4+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+5*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(5+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+4*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(4+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+7*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(7+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+4*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(4+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+1*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(1+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+5*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(5+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+2*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(2+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+5*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(5+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+5*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(5+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+5*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(5+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+7*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(7+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+5*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(5+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+3*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(3+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+6*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(6+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+4*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(4+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+6*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(6+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+7*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(7+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+6*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(6+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+7*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(7+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+7*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(7+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+7*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(7+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+8*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(8+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else {red, green, blue} <= 3'b100;
				end
				else if(origin[cell_index] == 8'd2) begin
					if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+5*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(5+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+0*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(0+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+4*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(4+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+1*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(1+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+5*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(5+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+1*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(1+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+3*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(3+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+2*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(2+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+4*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(4+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+2*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(2+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+5*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(5+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+2*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(2+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+1*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(1+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+3*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(3+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+2*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(2+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+3*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(3+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+3*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(3+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+3*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(3+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+5*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(5+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+3*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(3+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+5*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(5+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+4*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(4+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+5*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(5+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+5*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(5+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+2*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(2+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+6*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(6+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+3*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(3+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+6*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(6+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+4*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(4+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+6*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(6+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+5*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(5+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+6*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(6+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+6*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(6+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+6*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(6+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+7*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(7+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+6*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(6+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+8*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(8+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+6*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(6+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+5*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(5+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+7*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(7+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+5*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(5+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+8*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(8+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else {red, green, blue} <= 3'b010;
				end
				else if(origin[cell_index] == 8'd3) begin
					if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+2*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(2+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+2*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(2+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+3*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(3+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+2*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(2+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+5*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(5+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+2*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(2+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+6*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(6+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+2*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(2+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+7*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(7+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+2*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(2+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+1*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(1+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+3*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(3+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+4*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(4+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+3*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(3+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+8*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(8+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+3*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(3+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+1*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(1+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+4*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(4+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+4*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(4+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+4*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(4+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+8*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(8+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+4*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(4+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+1*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(1+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+5*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(5+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+4*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(4+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+5*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(5+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+8*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(8+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+5*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(5+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+2*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(2+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+6*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(6+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+3*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(3+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+6*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(6+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+5*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(5+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+6*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(6+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+6*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(6+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+6*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(6+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+7*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(7+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+6*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(6+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else {red, green, blue} <= 3'b001;
				end
				else if(origin[cell_index] == 8'd4) begin
					if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+2*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(2+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+2*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(2+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+3*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(3+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+2*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(2+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+4*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(4+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+2*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(2+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+5*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(5+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+2*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(2+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+6*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(6+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+2*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(2+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+7*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(7+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+2*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(2+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+8*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(8+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+2*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(2+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+4*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(4+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+4*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(4+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+5*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(5+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+4*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(4+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+6*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(6+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+4*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(4+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+7*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(7+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+4*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(4+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+2*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(2+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+5*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(5+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+3*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(3+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+5*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(5+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+4*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(4+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+5*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(5+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+7*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(7+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+5*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(5+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+8*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(8+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+5*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(5+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+1*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(1+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+6*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(6+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+2*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(2+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+6*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(6+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+4*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(4+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+6*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(6+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+8*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(8+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+6*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(6+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+1*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(1+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+7*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(7+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+4*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(4+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+7*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(7+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+8*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(8+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+7*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(7+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+4*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(4+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+8*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(8+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+8*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(8+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+8*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(8+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+5*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(5+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+9*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(9+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+6*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(6+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+9*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(9+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+7*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(7+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+9*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(9+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else {red, green, blue} <= 3'b110;
				end
				else if(origin[cell_index] == 8'd5) begin
					if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+2*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(2+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+0*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(0+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+3*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(3+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+0*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(0+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+7*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(7+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+0*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(0+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+8*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(8+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+0*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(0+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+1*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(1+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+1*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(1+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+2*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(2+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+1*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(1+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+8*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(8+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+1*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(1+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+1*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(1+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+2*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(2+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+2*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(2+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+2*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(2+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+5*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(5+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+2*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(2+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+8*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(8+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+2*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(2+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+2*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(2+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+3*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(3+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+4*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(4+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+3*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(3+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+5*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(5+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+3*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(3+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+6*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(6+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+3*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(3+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+8*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(8+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+3*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(3+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+2*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(2+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+4*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(4+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+3*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(3+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+4*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(4+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+4*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(4+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+4*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(4+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+6*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(6+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+4*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(4+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+7*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(7+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+4*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(4+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+8*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(8+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+4*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(4+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+2*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(2+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+6*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(6+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+3*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(3+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+6*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(6+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+6*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(6+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+6*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(6+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+7*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(7+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+6*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(6+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+8*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(8+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+6*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(6+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+2*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(2+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+7*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(7+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+5*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(5+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+7*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(7+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+6*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(6+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+7*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(7+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+8*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(8+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+7*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(7+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+2*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(2+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+8*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(8+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+3*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(3+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+8*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(8+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+4*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(4+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+8*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(8+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+5*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(5+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+8*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(8+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+8*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(8+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+8*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(8+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+8*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(8+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+9*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(9+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else {red, green, blue} <= 3'b101;
				end
				else if(origin[cell_index] == 8'd6) begin
					if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+4*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(4+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+0*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(0+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+5*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(5+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+0*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(0+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+6*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(6+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+0*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(0+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+7*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(7+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+0*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(0+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+3*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(3+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+1*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(1+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+4*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(4+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+1*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(1+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+7*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(7+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+1*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(1+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+8*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(8+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+1*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(1+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+2*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(2+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+2*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(2+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+3*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(3+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+2*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(2+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+4*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(4+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+2*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(2+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+8*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(8+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+2*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(2+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+1*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(1+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+3*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(3+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+2*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(2+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+3*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(3+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+4*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(4+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+3*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(3+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+7*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(7+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+3*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(3+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+8*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(8+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+3*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(3+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+5*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(5+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+4*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(4+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+6*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(6+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+4*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(4+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+7*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(7+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+4*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(4+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+2*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(2+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+5*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(5+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+3*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(3+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+5*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(5+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+4*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(4+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+5*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(5+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+1*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(1+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+6*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(6+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+2*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(2+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+6*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(6+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+4*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(4+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+6*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(6+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+4*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(4+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+7*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(7+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+1*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(1+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+8*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(8+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+2*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(2+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+8*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(8+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+3*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(3+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+8*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(8+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+4*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(4+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+8*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(8+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+5*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(5+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+8*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(8+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+6*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(6+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+8*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(8+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+7*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(7+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+8*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(8+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+8*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(8+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+8*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(8+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+4*6&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+10+(4+1)*6&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+9*6&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+10+(9+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else {red, green, blue} <= 3'b011;
				end
				else if(origin[cell_index] == 8'd7) begin
					if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+1*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(1+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+2*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(2+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+2*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(2+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+2*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(2+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+3*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(3+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+2*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(2+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+4*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(4+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+2*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(2+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+5*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(5+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+2*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(2+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+6*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(6+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+2*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(2+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+7*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(7+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+2*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(2+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+8*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(8+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+2*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(2+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+2*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(2+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+5*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(5+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+3*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(3+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+5*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(5+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+7*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(7+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+5*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(5+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+8*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(8+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+5*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(5+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+2*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(2+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+6*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(6+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+6*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(6+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+6*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(6+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+7*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(7+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+6*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(6+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+8*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(8+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+6*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(6+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+2*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(2+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+7*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(7+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+3*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(3+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+7*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(7+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+5*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(5+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+7*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(7+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+6*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(6+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+7*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(7+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+8*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(8+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+7*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(7+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+3*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(3+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+8*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(8+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+4*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(4+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+8*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(8+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+5*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(5+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+8*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(8+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+8*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(8+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+8*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(8+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+8*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(8+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+9*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(9+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+2*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(2+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+2*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(2+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+3*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(3+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+2*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(2+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+5*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(5+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+2*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(2+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+6*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(6+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+2*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(2+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+7*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(7+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+2*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(2+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+1*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(1+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+3*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(3+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+4*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(4+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+3*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(3+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+8*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(8+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+3*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(3+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+1*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(1+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+4*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(4+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+4*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(4+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+4*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(4+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+8*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(8+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+4*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(4+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+1*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(1+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+5*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(5+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+4*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(4+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+5*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(5+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+8*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(8+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+5*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(5+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+2*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(2+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+6*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(6+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+3*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(3+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+6*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(6+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+5*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(5+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+6*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(6+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+6*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(6+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+6*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(6+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+7*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(7+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+6*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(6+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(col-cell_position_col[cell_index]+moveflag_2*to_left[cell_index]*movecounter-moveflag_2*to_right[cell_index]*movecounter > row-cell_position_row[cell_index]+moveflag_2*to_up[cell_index]*movecounter-moveflag_2*to_down[cell_index]*movecounter) {red, green, blue} <= 3'b100;
					else {red, green, blue} <= 3'b010;
				end
				else if(origin[cell_index] == 8'd8) begin
					if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+2*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(2+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+0*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(0+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+3*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(3+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+0*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(0+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+4*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(4+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+0*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(0+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+8*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(8+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+0*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(0+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+9*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(9+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+0*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(0+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+1*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(1+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+1*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(1+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+2*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(2+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+1*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(1+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+7*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(7+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+1*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(1+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+8*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(8+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+1*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(1+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+9*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(9+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+1*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(1+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+1*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(1+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+2*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(2+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+6*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(6+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+2*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(2+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+7*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(7+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+2*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(2+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+9*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(9+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+2*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(2+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+1*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(1+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+3*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(3+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+2*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(2+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+3*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(3+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+3*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(3+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+3*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(3+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+4*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(4+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+3*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(3+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+5*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(5+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+3*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(3+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+6*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(6+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+3*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(3+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+9*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(9+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+3*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(3+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+1*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(1+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+5*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(5+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+2*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(2+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+5*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(5+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+3*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(3+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+5*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(5+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+4*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(4+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+5*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(5+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+8*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(8+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+5*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(5+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+9*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(9+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+5*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(5+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+1*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(1+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+6*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(6+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+4*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(4+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+6*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(6+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+9*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(9+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+6*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(6+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+1*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(1+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+7*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(7+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+4*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(4+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+7*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(7+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+9*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(9+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+7*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(7+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+1*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(1+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+8*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(8+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+4*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(4+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+8*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(8+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+9*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(9+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+8*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(8+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+1*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(1+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+9*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(9+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+4*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(4+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+9*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(9+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+5*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(5+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+9*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(9+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+6*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(6+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+9*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(9+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+7*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(7+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+9*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(9+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+8*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(8+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+9*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(9+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+9*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(9+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+9*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(9+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+4*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(4+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+2*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(2+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+5*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(5+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+2*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(2+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+6*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(6+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+2*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(2+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+7*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(7+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+2*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(2+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+2*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(2+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+3*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(3+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+3*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(3+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+3*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(3+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+4*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(4+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+3*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(3+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+7*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(7+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+3*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(3+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+8*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(8+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+3*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(3+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+1*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(1+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+4*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(4+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+2*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(2+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+4*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(4+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+4*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(4+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+4*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(4+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+8*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(8+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+4*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(4+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+1*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(1+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+5*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(5+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+4*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(4+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+5*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(5+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+8*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(8+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+5*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(5+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+4*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(4+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+6*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(6+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+5*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(5+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+6*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(6+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+8*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(8+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+6*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(6+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+5*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(5+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+7*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(7+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+6*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(6+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+7*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(7+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+7*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(7+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+7*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(7+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+8*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(8+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+7*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(7+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(col-cell_position_col[cell_index]+moveflag_2*to_left[cell_index]*movecounter-moveflag_2*to_right[cell_index]*movecounter > row-cell_position_row[cell_index]+moveflag_2*to_up[cell_index]*movecounter-moveflag_2*to_down[cell_index]*movecounter) {red, green, blue} <= 3'b010;
					else {red, green, blue} <= 3'b001;
				end
				else if(origin[cell_index] == 8'd9) begin
					if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+1*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(1+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+1*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(1+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+2*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(2+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+1*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(1+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+3*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(3+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+1*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(1+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+4*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(4+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+1*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(1+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+7*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(7+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+1*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(1+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+8*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(8+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+1*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(1+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+1*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(1+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+2*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(2+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+4*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(4+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+2*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(2+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+8*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(8+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+2*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(2+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+1*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(1+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+3*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(3+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+4*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(4+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+3*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(3+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+8*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(8+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+3*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(3+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+1*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(1+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+4*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(4+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+4*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(4+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+4*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(4+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+5*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(5+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+4*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(4+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+6*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(6+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+4*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(4+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+7*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(7+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+4*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(4+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+8*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(8+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+4*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(4+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+1*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(1+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+8*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(8+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+2*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(2+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+8*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(8+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+3*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(3+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+8*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(8+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+4*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(4+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+8*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(8+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+5*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(5+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+8*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(8+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+6*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(6+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+8*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(8+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+7*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(7+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+8*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(8+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+8*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(8+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+8*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(8+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+3*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(3+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+2*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(2+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+7*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(7+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+2*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(2+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+1*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(1+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+3*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(3+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+2*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(2+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+3*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(3+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+6*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(6+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+3*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(3+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+7*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(7+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+3*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(3+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+1*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(1+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+4*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(4+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+5*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(5+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+4*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(4+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+7*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(7+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+4*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(4+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+1*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(1+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+5*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(5+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+2*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(2+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+5*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(5+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+5*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(5+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+5*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(5+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+7*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(7+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+5*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(5+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+3*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(3+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+6*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(6+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+4*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(4+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+6*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(6+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+7*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(7+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+6*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(6+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+7*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(7+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+7*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(7+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+7*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(7+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+8*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(8+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(col-cell_position_col[cell_index]+moveflag_2*to_left[cell_index]*movecounter-moveflag_2*to_right[cell_index]*movecounter > row-cell_position_row[cell_index]+moveflag_2*to_up[cell_index]*movecounter-moveflag_2*to_down[cell_index]*movecounter) {red, green, blue} <= 3'b001;
					else {red, green, blue} <= 3'b100;
				end
				else if(origin[cell_index] == 8'd10) begin
					if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+1*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(1+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+1*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(1+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+2*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(2+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+1*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(1+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+3*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(3+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+1*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(1+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+4*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(4+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+1*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(1+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+5*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(5+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+1*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(1+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+6*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(6+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+1*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(1+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+7*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(7+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+1*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(1+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+8*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(8+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+1*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(1+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+1*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(1+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+5*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(5+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+2*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(2+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+5*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(5+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+3*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(3+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+5*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(5+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+4*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(4+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+5*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(5+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+5*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(5+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+5*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(5+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+6*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(6+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+5*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(5+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+7*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(7+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+5*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(5+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+8*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(8+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+5*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(5+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+1*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(1+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+6*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(6+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+8*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(8+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+6*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(6+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+1*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(1+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+7*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(7+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+8*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(8+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+7*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(7+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+1*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(1+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+8*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(8+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+8*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(8+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+8*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(8+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+1*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(1+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+9*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(9+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+2*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(2+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+9*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(9+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+3*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(3+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+9*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(9+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+4*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(4+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+9*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(9+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+5*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(5+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+9*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(9+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+6*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(6+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+9*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(9+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+7*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(7+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+9*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(9+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+8*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(8+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+9*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(9+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+1*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(1+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+0*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(0+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+2*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(2+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+0*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(0+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+6*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(6+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+0*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(0+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+7*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(7+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+0*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(0+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+8*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(8+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+0*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(0+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+1*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(1+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+1*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(1+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+5*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(5+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+1*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(1+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+6*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(6+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+1*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(1+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+8*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(8+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+1*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(1+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+1*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(1+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+2*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(2+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+4*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(4+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+2*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(2+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+5*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(5+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+2*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(2+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+8*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(8+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+2*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(2+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+1*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(1+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+3*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(3+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+2*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(2+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+3*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(3+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+3*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(3+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+3*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(3+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+4*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(4+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+3*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(3+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+8*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(8+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+3*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(3+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+3*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(3+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+5*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(5+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+4*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(4+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+5*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(5+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+1*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(1+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+6*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(6+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+2*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(2+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+6*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(6+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+4*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(4+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+6*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(6+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+4*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(4+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+7*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(7+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+1*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(1+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+8*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(8+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+2*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(2+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+8*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(8+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+3*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(3+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+8*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(8+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+4*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(4+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+8*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(8+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+5*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(5+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+8*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(8+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+6*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(6+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+8*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(8+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+7*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(7+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+8*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(8+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+8*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(8+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+8*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(8+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+4*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(4+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+9*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(9+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(col-cell_position_col[cell_index]+moveflag_2*to_left[cell_index]*movecounter-moveflag_2*to_right[cell_index]*movecounter > row-cell_position_row[cell_index]+moveflag_2*to_up[cell_index]*movecounter-moveflag_2*to_down[cell_index]*movecounter) {red, green, blue} <= 3'b110;
					else {red, green, blue} <= 3'b101;
				end
				else if(origin[cell_index] == 8'd11) begin
					if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+1*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(1+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+0*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(0+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+2*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(2+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+0*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(0+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+6*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(6+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+0*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(0+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+7*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(7+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+0*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(0+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+8*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(8+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+0*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(0+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+1*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(1+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+1*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(1+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+5*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(5+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+1*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(1+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+6*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(6+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+1*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(1+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+8*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(8+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+1*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(1+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+1*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(1+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+2*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(2+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+4*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(4+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+2*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(2+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+5*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(5+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+2*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(2+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+8*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(8+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+2*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(2+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+1*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(1+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+3*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(3+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+2*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(2+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+3*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(3+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+3*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(3+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+3*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(3+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+4*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(4+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+3*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(3+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+8*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(8+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+3*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(3+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+1*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(1+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+6*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(6+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+2*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(2+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+6*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(6+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+3*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(3+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+6*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(6+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+4*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(4+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+6*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(6+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+5*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(5+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+6*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(6+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+6*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(6+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+6*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(6+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+7*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(7+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+6*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(6+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+8*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(8+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+6*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(6+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+1*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(1+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+7*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(7+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+8*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(8+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+7*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(7+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+1*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(1+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+8*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(8+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+8*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(8+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+8*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(8+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+1*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(1+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+9*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(9+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+2*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(2+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+9*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(9+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+3*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(3+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+9*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(9+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+4*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(4+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+9*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(9+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+5*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(5+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+9*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(9+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+6*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(6+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+9*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(9+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+7*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(7+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+9*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(9+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+8*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(8+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+9*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+0+(9+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+3*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(3+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+0*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(0+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+4*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(4+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+0*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(0+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+1*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(1+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+1*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(1+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+2*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(2+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+1*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(1+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+4*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(4+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+1*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(1+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+4*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(4+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+2*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(2+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+1*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(1+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+3*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(3+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+2*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(2+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+3*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(3+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+3*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(3+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+3*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(3+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+4*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(4+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+3*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(3+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+5*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(5+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+3*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(3+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+6*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(6+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+3*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(3+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+7*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(7+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+3*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(3+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+8*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(8+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+3*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(3+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+4*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(4+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+4*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(4+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+2*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(2+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+6*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(6+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+3*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(3+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+6*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(6+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+5*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(5+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+6*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(6+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+6*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(6+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+6*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(6+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+7*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(7+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+6*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(6+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+1*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(1+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+7*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(7+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+4*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(4+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+7*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(7+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+8*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(8+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+7*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(7+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+1*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(1+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+8*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(8+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+4*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(4+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+8*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(8+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+8*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(8+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+8*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(8+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+2*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(2+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+9*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(9+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+3*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(3+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+9*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(9+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+5*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(5+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+9*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(9+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+6*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(6+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+9*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(9+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row>=cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+7*3&&row<cell_position_row[cell_index]-moveflag_2*to_up[cell_index]*movecounter+moveflag_2*to_down[cell_index]*movecounter+25+(7+1)*3&&col>=cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+9*3&&col<cell_position_col[cell_index]-moveflag_2*to_left[cell_index]*movecounter+moveflag_2*to_right[cell_index]*movecounter+8+32+(9+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(col-cell_position_col[cell_index]+moveflag_2*to_left[cell_index]*movecounter-moveflag_2*to_right[cell_index]*movecounter > row-cell_position_row[cell_index]+moveflag_2*to_up[cell_index]*movecounter-moveflag_2*to_down[cell_index]*movecounter) {red, green, blue} <= 3'b101;
					else {red, green, blue} <= 3'b011;
				end
				else {red, green, blue} <= 3'b111;
			end
			else if(missile_flag!=0&&row>=missile_row&&row<=missile_row+5&&col>=missile_col&&col<=missile_col+5) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+13*2&&row<520+13*2+2&&col>=70+jet_pos+1*2&&col<70+jet_pos+1*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+12*2&&row<520+12*2+2&&col>=70+jet_pos+2*2&&col<70+jet_pos+2*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+13*2&&row<520+13*2+2&&col>=70+jet_pos+2*2&&col<70+jet_pos+2*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+14*2&&row<520+14*2+2&&col>=70+jet_pos+2*2&&col<70+jet_pos+2*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+6*2&&row<520+6*2+2&&col>=70+jet_pos+3*2&&col<70+jet_pos+3*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+7*2&&row<520+7*2+2&&col>=70+jet_pos+3*2&&col<70+jet_pos+3*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+12*2&&row<520+12*2+2&&col>=70+jet_pos+3*2&&col<70+jet_pos+3*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+13*2&&row<520+13*2+2&&col>=70+jet_pos+3*2&&col<70+jet_pos+3*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+14*2&&row<520+14*2+2&&col>=70+jet_pos+3*2&&col<70+jet_pos+3*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+19*2&&row<520+19*2+2&&col>=70+jet_pos+3*2&&col<70+jet_pos+3*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+20*2&&row<520+20*2+2&&col>=70+jet_pos+3*2&&col<70+jet_pos+3*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+6*2&&row<520+6*2+2&&col>=70+jet_pos+4*2&&col<70+jet_pos+4*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+7*2&&row<520+7*2+2&&col>=70+jet_pos+4*2&&col<70+jet_pos+4*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+8*2&&row<520+8*2+2&&col>=70+jet_pos+4*2&&col<70+jet_pos+4*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+9*2&&row<520+9*2+2&&col>=70+jet_pos+4*2&&col<70+jet_pos+4*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+11*2&&row<520+11*2+2&&col>=70+jet_pos+4*2&&col<70+jet_pos+4*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+12*2&&row<520+12*2+2&&col>=70+jet_pos+4*2&&col<70+jet_pos+4*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+13*2&&row<520+13*2+2&&col>=70+jet_pos+4*2&&col<70+jet_pos+4*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+14*2&&row<520+14*2+2&&col>=70+jet_pos+4*2&&col<70+jet_pos+4*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+15*2&&row<520+15*2+2&&col>=70+jet_pos+4*2&&col<70+jet_pos+4*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+17*2&&row<520+17*2+2&&col>=70+jet_pos+4*2&&col<70+jet_pos+4*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+18*2&&row<520+18*2+2&&col>=70+jet_pos+4*2&&col<70+jet_pos+4*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+19*2&&row<520+19*2+2&&col>=70+jet_pos+4*2&&col<70+jet_pos+4*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+20*2&&row<520+20*2+2&&col>=70+jet_pos+4*2&&col<70+jet_pos+4*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+6*2&&row<520+6*2+2&&col>=70+jet_pos+5*2&&col<70+jet_pos+5*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+7*2&&row<520+7*2+2&&col>=70+jet_pos+5*2&&col<70+jet_pos+5*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+8*2&&row<520+8*2+2&&col>=70+jet_pos+5*2&&col<70+jet_pos+5*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+9*2&&row<520+9*2+2&&col>=70+jet_pos+5*2&&col<70+jet_pos+5*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+10*2&&row<520+10*2+2&&col>=70+jet_pos+5*2&&col<70+jet_pos+5*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+11*2&&row<520+11*2+2&&col>=70+jet_pos+5*2&&col<70+jet_pos+5*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+12*2&&row<520+12*2+2&&col>=70+jet_pos+5*2&&col<70+jet_pos+5*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+13*2&&row<520+13*2+2&&col>=70+jet_pos+5*2&&col<70+jet_pos+5*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+14*2&&row<520+14*2+2&&col>=70+jet_pos+5*2&&col<70+jet_pos+5*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+15*2&&row<520+15*2+2&&col>=70+jet_pos+5*2&&col<70+jet_pos+5*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+16*2&&row<520+16*2+2&&col>=70+jet_pos+5*2&&col<70+jet_pos+5*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+17*2&&row<520+17*2+2&&col>=70+jet_pos+5*2&&col<70+jet_pos+5*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+18*2&&row<520+18*2+2&&col>=70+jet_pos+5*2&&col<70+jet_pos+5*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+19*2&&row<520+19*2+2&&col>=70+jet_pos+5*2&&col<70+jet_pos+5*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+20*2&&row<520+20*2+2&&col>=70+jet_pos+5*2&&col<70+jet_pos+5*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+8*2&&row<520+8*2+2&&col>=70+jet_pos+6*2&&col<70+jet_pos+6*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+9*2&&row<520+9*2+2&&col>=70+jet_pos+6*2&&col<70+jet_pos+6*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+10*2&&row<520+10*2+2&&col>=70+jet_pos+6*2&&col<70+jet_pos+6*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+11*2&&row<520+11*2+2&&col>=70+jet_pos+6*2&&col<70+jet_pos+6*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+12*2&&row<520+12*2+2&&col>=70+jet_pos+6*2&&col<70+jet_pos+6*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+13*2&&row<520+13*2+2&&col>=70+jet_pos+6*2&&col<70+jet_pos+6*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+14*2&&row<520+14*2+2&&col>=70+jet_pos+6*2&&col<70+jet_pos+6*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+15*2&&row<520+15*2+2&&col>=70+jet_pos+6*2&&col<70+jet_pos+6*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+16*2&&row<520+16*2+2&&col>=70+jet_pos+6*2&&col<70+jet_pos+6*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+17*2&&row<520+17*2+2&&col>=70+jet_pos+6*2&&col<70+jet_pos+6*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+18*2&&row<520+18*2+2&&col>=70+jet_pos+6*2&&col<70+jet_pos+6*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+9*2&&row<520+9*2+2&&col>=70+jet_pos+7*2&&col<70+jet_pos+7*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+10*2&&row<520+10*2+2&&col>=70+jet_pos+7*2&&col<70+jet_pos+7*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+11*2&&row<520+11*2+2&&col>=70+jet_pos+7*2&&col<70+jet_pos+7*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+12*2&&row<520+12*2+2&&col>=70+jet_pos+7*2&&col<70+jet_pos+7*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+13*2&&row<520+13*2+2&&col>=70+jet_pos+7*2&&col<70+jet_pos+7*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+14*2&&row<520+14*2+2&&col>=70+jet_pos+7*2&&col<70+jet_pos+7*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+15*2&&row<520+15*2+2&&col>=70+jet_pos+7*2&&col<70+jet_pos+7*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+16*2&&row<520+16*2+2&&col>=70+jet_pos+7*2&&col<70+jet_pos+7*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+17*2&&row<520+17*2+2&&col>=70+jet_pos+7*2&&col<70+jet_pos+7*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+10*2&&row<520+10*2+2&&col>=70+jet_pos+8*2&&col<70+jet_pos+8*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+11*2&&row<520+11*2+2&&col>=70+jet_pos+8*2&&col<70+jet_pos+8*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+12*2&&row<520+12*2+2&&col>=70+jet_pos+8*2&&col<70+jet_pos+8*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+13*2&&row<520+13*2+2&&col>=70+jet_pos+8*2&&col<70+jet_pos+8*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+14*2&&row<520+14*2+2&&col>=70+jet_pos+8*2&&col<70+jet_pos+8*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+15*2&&row<520+15*2+2&&col>=70+jet_pos+8*2&&col<70+jet_pos+8*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+16*2&&row<520+16*2+2&&col>=70+jet_pos+8*2&&col<70+jet_pos+8*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+11*2&&row<520+11*2+2&&col>=70+jet_pos+9*2&&col<70+jet_pos+9*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+12*2&&row<520+12*2+2&&col>=70+jet_pos+9*2&&col<70+jet_pos+9*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+13*2&&row<520+13*2+2&&col>=70+jet_pos+9*2&&col<70+jet_pos+9*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+14*2&&row<520+14*2+2&&col>=70+jet_pos+9*2&&col<70+jet_pos+9*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+15*2&&row<520+15*2+2&&col>=70+jet_pos+9*2&&col<70+jet_pos+9*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+11*2&&row<520+11*2+2&&col>=70+jet_pos+10*2&&col<70+jet_pos+10*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+12*2&&row<520+12*2+2&&col>=70+jet_pos+10*2&&col<70+jet_pos+10*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+13*2&&row<520+13*2+2&&col>=70+jet_pos+10*2&&col<70+jet_pos+10*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+14*2&&row<520+14*2+2&&col>=70+jet_pos+10*2&&col<70+jet_pos+10*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+15*2&&row<520+15*2+2&&col>=70+jet_pos+10*2&&col<70+jet_pos+10*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+1*2&&row<520+1*2+2&&col>=70+jet_pos+11*2&&col<70+jet_pos+11*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+2*2&&row<520+2*2+2&&col>=70+jet_pos+11*2&&col<70+jet_pos+11*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+3*2&&row<520+3*2+2&&col>=70+jet_pos+11*2&&col<70+jet_pos+11*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+11*2&&row<520+11*2+2&&col>=70+jet_pos+11*2&&col<70+jet_pos+11*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+12*2&&row<520+12*2+2&&col>=70+jet_pos+11*2&&col<70+jet_pos+11*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+13*2&&row<520+13*2+2&&col>=70+jet_pos+11*2&&col<70+jet_pos+11*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+14*2&&row<520+14*2+2&&col>=70+jet_pos+11*2&&col<70+jet_pos+11*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+15*2&&row<520+15*2+2&&col>=70+jet_pos+11*2&&col<70+jet_pos+11*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+23*2&&row<520+23*2+2&&col>=70+jet_pos+11*2&&col<70+jet_pos+11*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+24*2&&row<520+24*2+2&&col>=70+jet_pos+11*2&&col<70+jet_pos+11*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+25*2&&row<520+25*2+2&&col>=70+jet_pos+11*2&&col<70+jet_pos+11*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+1*2&&row<520+1*2+2&&col>=70+jet_pos+12*2&&col<70+jet_pos+12*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+2*2&&row<520+2*2+2&&col>=70+jet_pos+12*2&&col<70+jet_pos+12*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+3*2&&row<520+3*2+2&&col>=70+jet_pos+12*2&&col<70+jet_pos+12*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+4*2&&row<520+4*2+2&&col>=70+jet_pos+12*2&&col<70+jet_pos+12*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+5*2&&row<520+5*2+2&&col>=70+jet_pos+12*2&&col<70+jet_pos+12*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+11*2&&row<520+11*2+2&&col>=70+jet_pos+12*2&&col<70+jet_pos+12*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+12*2&&row<520+12*2+2&&col>=70+jet_pos+12*2&&col<70+jet_pos+12*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+13*2&&row<520+13*2+2&&col>=70+jet_pos+12*2&&col<70+jet_pos+12*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+14*2&&row<520+14*2+2&&col>=70+jet_pos+12*2&&col<70+jet_pos+12*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+15*2&&row<520+15*2+2&&col>=70+jet_pos+12*2&&col<70+jet_pos+12*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+21*2&&row<520+21*2+2&&col>=70+jet_pos+12*2&&col<70+jet_pos+12*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+22*2&&row<520+22*2+2&&col>=70+jet_pos+12*2&&col<70+jet_pos+12*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+23*2&&row<520+23*2+2&&col>=70+jet_pos+12*2&&col<70+jet_pos+12*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+24*2&&row<520+24*2+2&&col>=70+jet_pos+12*2&&col<70+jet_pos+12*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+25*2&&row<520+25*2+2&&col>=70+jet_pos+12*2&&col<70+jet_pos+12*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+1*2&&row<520+1*2+2&&col>=70+jet_pos+13*2&&col<70+jet_pos+13*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+2*2&&row<520+2*2+2&&col>=70+jet_pos+13*2&&col<70+jet_pos+13*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+3*2&&row<520+3*2+2&&col>=70+jet_pos+13*2&&col<70+jet_pos+13*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+4*2&&row<520+4*2+2&&col>=70+jet_pos+13*2&&col<70+jet_pos+13*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+5*2&&row<520+5*2+2&&col>=70+jet_pos+13*2&&col<70+jet_pos+13*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+6*2&&row<520+6*2+2&&col>=70+jet_pos+13*2&&col<70+jet_pos+13*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+7*2&&row<520+7*2+2&&col>=70+jet_pos+13*2&&col<70+jet_pos+13*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+11*2&&row<520+11*2+2&&col>=70+jet_pos+13*2&&col<70+jet_pos+13*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+12*2&&row<520+12*2+2&&col>=70+jet_pos+13*2&&col<70+jet_pos+13*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+13*2&&row<520+13*2+2&&col>=70+jet_pos+13*2&&col<70+jet_pos+13*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+14*2&&row<520+14*2+2&&col>=70+jet_pos+13*2&&col<70+jet_pos+13*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+15*2&&row<520+15*2+2&&col>=70+jet_pos+13*2&&col<70+jet_pos+13*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+19*2&&row<520+19*2+2&&col>=70+jet_pos+13*2&&col<70+jet_pos+13*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+20*2&&row<520+20*2+2&&col>=70+jet_pos+13*2&&col<70+jet_pos+13*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+21*2&&row<520+21*2+2&&col>=70+jet_pos+13*2&&col<70+jet_pos+13*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+22*2&&row<520+22*2+2&&col>=70+jet_pos+13*2&&col<70+jet_pos+13*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+23*2&&row<520+23*2+2&&col>=70+jet_pos+13*2&&col<70+jet_pos+13*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+24*2&&row<520+24*2+2&&col>=70+jet_pos+13*2&&col<70+jet_pos+13*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+25*2&&row<520+25*2+2&&col>=70+jet_pos+13*2&&col<70+jet_pos+13*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+2*2&&row<520+2*2+2&&col>=70+jet_pos+14*2&&col<70+jet_pos+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+3*2&&row<520+3*2+2&&col>=70+jet_pos+14*2&&col<70+jet_pos+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+4*2&&row<520+4*2+2&&col>=70+jet_pos+14*2&&col<70+jet_pos+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+5*2&&row<520+5*2+2&&col>=70+jet_pos+14*2&&col<70+jet_pos+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+6*2&&row<520+6*2+2&&col>=70+jet_pos+14*2&&col<70+jet_pos+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+7*2&&row<520+7*2+2&&col>=70+jet_pos+14*2&&col<70+jet_pos+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+8*2&&row<520+8*2+2&&col>=70+jet_pos+14*2&&col<70+jet_pos+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+9*2&&row<520+9*2+2&&col>=70+jet_pos+14*2&&col<70+jet_pos+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+11*2&&row<520+11*2+2&&col>=70+jet_pos+14*2&&col<70+jet_pos+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+12*2&&row<520+12*2+2&&col>=70+jet_pos+14*2&&col<70+jet_pos+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+13*2&&row<520+13*2+2&&col>=70+jet_pos+14*2&&col<70+jet_pos+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+14*2&&row<520+14*2+2&&col>=70+jet_pos+14*2&&col<70+jet_pos+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+15*2&&row<520+15*2+2&&col>=70+jet_pos+14*2&&col<70+jet_pos+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+17*2&&row<520+17*2+2&&col>=70+jet_pos+14*2&&col<70+jet_pos+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+18*2&&row<520+18*2+2&&col>=70+jet_pos+14*2&&col<70+jet_pos+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+19*2&&row<520+19*2+2&&col>=70+jet_pos+14*2&&col<70+jet_pos+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+20*2&&row<520+20*2+2&&col>=70+jet_pos+14*2&&col<70+jet_pos+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+21*2&&row<520+21*2+2&&col>=70+jet_pos+14*2&&col<70+jet_pos+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+22*2&&row<520+22*2+2&&col>=70+jet_pos+14*2&&col<70+jet_pos+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+23*2&&row<520+23*2+2&&col>=70+jet_pos+14*2&&col<70+jet_pos+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+24*2&&row<520+24*2+2&&col>=70+jet_pos+14*2&&col<70+jet_pos+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+3*2&&row<520+3*2+2&&col>=70+jet_pos+15*2&&col<70+jet_pos+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+4*2&&row<520+4*2+2&&col>=70+jet_pos+15*2&&col<70+jet_pos+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+5*2&&row<520+5*2+2&&col>=70+jet_pos+15*2&&col<70+jet_pos+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+6*2&&row<520+6*2+2&&col>=70+jet_pos+15*2&&col<70+jet_pos+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+7*2&&row<520+7*2+2&&col>=70+jet_pos+15*2&&col<70+jet_pos+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+8*2&&row<520+8*2+2&&col>=70+jet_pos+15*2&&col<70+jet_pos+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+9*2&&row<520+9*2+2&&col>=70+jet_pos+15*2&&col<70+jet_pos+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+10*2&&row<520+10*2+2&&col>=70+jet_pos+15*2&&col<70+jet_pos+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+11*2&&row<520+11*2+2&&col>=70+jet_pos+15*2&&col<70+jet_pos+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+12*2&&row<520+12*2+2&&col>=70+jet_pos+15*2&&col<70+jet_pos+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+13*2&&row<520+13*2+2&&col>=70+jet_pos+15*2&&col<70+jet_pos+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+14*2&&row<520+14*2+2&&col>=70+jet_pos+15*2&&col<70+jet_pos+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+15*2&&row<520+15*2+2&&col>=70+jet_pos+15*2&&col<70+jet_pos+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+16*2&&row<520+16*2+2&&col>=70+jet_pos+15*2&&col<70+jet_pos+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+17*2&&row<520+17*2+2&&col>=70+jet_pos+15*2&&col<70+jet_pos+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+18*2&&row<520+18*2+2&&col>=70+jet_pos+15*2&&col<70+jet_pos+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+19*2&&row<520+19*2+2&&col>=70+jet_pos+15*2&&col<70+jet_pos+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+20*2&&row<520+20*2+2&&col>=70+jet_pos+15*2&&col<70+jet_pos+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+21*2&&row<520+21*2+2&&col>=70+jet_pos+15*2&&col<70+jet_pos+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+22*2&&row<520+22*2+2&&col>=70+jet_pos+15*2&&col<70+jet_pos+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+23*2&&row<520+23*2+2&&col>=70+jet_pos+15*2&&col<70+jet_pos+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+4*2&&row<520+4*2+2&&col>=70+jet_pos+16*2&&col<70+jet_pos+16*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+5*2&&row<520+5*2+2&&col>=70+jet_pos+16*2&&col<70+jet_pos+16*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+6*2&&row<520+6*2+2&&col>=70+jet_pos+16*2&&col<70+jet_pos+16*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+7*2&&row<520+7*2+2&&col>=70+jet_pos+16*2&&col<70+jet_pos+16*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+8*2&&row<520+8*2+2&&col>=70+jet_pos+16*2&&col<70+jet_pos+16*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+9*2&&row<520+9*2+2&&col>=70+jet_pos+16*2&&col<70+jet_pos+16*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+10*2&&row<520+10*2+2&&col>=70+jet_pos+16*2&&col<70+jet_pos+16*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+11*2&&row<520+11*2+2&&col>=70+jet_pos+16*2&&col<70+jet_pos+16*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+12*2&&row<520+12*2+2&&col>=70+jet_pos+16*2&&col<70+jet_pos+16*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+13*2&&row<520+13*2+2&&col>=70+jet_pos+16*2&&col<70+jet_pos+16*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+14*2&&row<520+14*2+2&&col>=70+jet_pos+16*2&&col<70+jet_pos+16*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+15*2&&row<520+15*2+2&&col>=70+jet_pos+16*2&&col<70+jet_pos+16*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+16*2&&row<520+16*2+2&&col>=70+jet_pos+16*2&&col<70+jet_pos+16*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+17*2&&row<520+17*2+2&&col>=70+jet_pos+16*2&&col<70+jet_pos+16*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+18*2&&row<520+18*2+2&&col>=70+jet_pos+16*2&&col<70+jet_pos+16*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+19*2&&row<520+19*2+2&&col>=70+jet_pos+16*2&&col<70+jet_pos+16*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+20*2&&row<520+20*2+2&&col>=70+jet_pos+16*2&&col<70+jet_pos+16*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+21*2&&row<520+21*2+2&&col>=70+jet_pos+16*2&&col<70+jet_pos+16*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+22*2&&row<520+22*2+2&&col>=70+jet_pos+16*2&&col<70+jet_pos+16*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+6*2&&row<520+6*2+2&&col>=70+jet_pos+17*2&&col<70+jet_pos+17*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+7*2&&row<520+7*2+2&&col>=70+jet_pos+17*2&&col<70+jet_pos+17*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+8*2&&row<520+8*2+2&&col>=70+jet_pos+17*2&&col<70+jet_pos+17*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+9*2&&row<520+9*2+2&&col>=70+jet_pos+17*2&&col<70+jet_pos+17*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+10*2&&row<520+10*2+2&&col>=70+jet_pos+17*2&&col<70+jet_pos+17*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+11*2&&row<520+11*2+2&&col>=70+jet_pos+17*2&&col<70+jet_pos+17*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+12*2&&row<520+12*2+2&&col>=70+jet_pos+17*2&&col<70+jet_pos+17*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+13*2&&row<520+13*2+2&&col>=70+jet_pos+17*2&&col<70+jet_pos+17*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+14*2&&row<520+14*2+2&&col>=70+jet_pos+17*2&&col<70+jet_pos+17*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+15*2&&row<520+15*2+2&&col>=70+jet_pos+17*2&&col<70+jet_pos+17*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+16*2&&row<520+16*2+2&&col>=70+jet_pos+17*2&&col<70+jet_pos+17*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+17*2&&row<520+17*2+2&&col>=70+jet_pos+17*2&&col<70+jet_pos+17*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+18*2&&row<520+18*2+2&&col>=70+jet_pos+17*2&&col<70+jet_pos+17*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+19*2&&row<520+19*2+2&&col>=70+jet_pos+17*2&&col<70+jet_pos+17*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+20*2&&row<520+20*2+2&&col>=70+jet_pos+17*2&&col<70+jet_pos+17*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+8*2&&row<520+8*2+2&&col>=70+jet_pos+18*2&&col<70+jet_pos+18*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+9*2&&row<520+9*2+2&&col>=70+jet_pos+18*2&&col<70+jet_pos+18*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+10*2&&row<520+10*2+2&&col>=70+jet_pos+18*2&&col<70+jet_pos+18*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+11*2&&row<520+11*2+2&&col>=70+jet_pos+18*2&&col<70+jet_pos+18*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+12*2&&row<520+12*2+2&&col>=70+jet_pos+18*2&&col<70+jet_pos+18*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+13*2&&row<520+13*2+2&&col>=70+jet_pos+18*2&&col<70+jet_pos+18*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+14*2&&row<520+14*2+2&&col>=70+jet_pos+18*2&&col<70+jet_pos+18*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+15*2&&row<520+15*2+2&&col>=70+jet_pos+18*2&&col<70+jet_pos+18*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+16*2&&row<520+16*2+2&&col>=70+jet_pos+18*2&&col<70+jet_pos+18*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+17*2&&row<520+17*2+2&&col>=70+jet_pos+18*2&&col<70+jet_pos+18*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+18*2&&row<520+18*2+2&&col>=70+jet_pos+18*2&&col<70+jet_pos+18*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+10*2&&row<520+10*2+2&&col>=70+jet_pos+19*2&&col<70+jet_pos+19*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+11*2&&row<520+11*2+2&&col>=70+jet_pos+19*2&&col<70+jet_pos+19*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+12*2&&row<520+12*2+2&&col>=70+jet_pos+19*2&&col<70+jet_pos+19*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+13*2&&row<520+13*2+2&&col>=70+jet_pos+19*2&&col<70+jet_pos+19*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+14*2&&row<520+14*2+2&&col>=70+jet_pos+19*2&&col<70+jet_pos+19*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+15*2&&row<520+15*2+2&&col>=70+jet_pos+19*2&&col<70+jet_pos+19*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+16*2&&row<520+16*2+2&&col>=70+jet_pos+19*2&&col<70+jet_pos+19*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+11*2&&row<520+11*2+2&&col>=70+jet_pos+20*2&&col<70+jet_pos+20*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+12*2&&row<520+12*2+2&&col>=70+jet_pos+20*2&&col<70+jet_pos+20*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+13*2&&row<520+13*2+2&&col>=70+jet_pos+20*2&&col<70+jet_pos+20*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+14*2&&row<520+14*2+2&&col>=70+jet_pos+20*2&&col<70+jet_pos+20*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+15*2&&row<520+15*2+2&&col>=70+jet_pos+20*2&&col<70+jet_pos+20*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+11*2&&row<520+11*2+2&&col>=70+jet_pos+21*2&&col<70+jet_pos+21*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+12*2&&row<520+12*2+2&&col>=70+jet_pos+21*2&&col<70+jet_pos+21*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+13*2&&row<520+13*2+2&&col>=70+jet_pos+21*2&&col<70+jet_pos+21*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+14*2&&row<520+14*2+2&&col>=70+jet_pos+21*2&&col<70+jet_pos+21*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+15*2&&row<520+15*2+2&&col>=70+jet_pos+21*2&&col<70+jet_pos+21*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+11*2&&row<520+11*2+2&&col>=70+jet_pos+22*2&&col<70+jet_pos+22*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+12*2&&row<520+12*2+2&&col>=70+jet_pos+22*2&&col<70+jet_pos+22*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+13*2&&row<520+13*2+2&&col>=70+jet_pos+22*2&&col<70+jet_pos+22*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+14*2&&row<520+14*2+2&&col>=70+jet_pos+22*2&&col<70+jet_pos+22*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+15*2&&row<520+15*2+2&&col>=70+jet_pos+22*2&&col<70+jet_pos+22*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+11*2&&row<520+11*2+2&&col>=70+jet_pos+23*2&&col<70+jet_pos+23*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+12*2&&row<520+12*2+2&&col>=70+jet_pos+23*2&&col<70+jet_pos+23*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+13*2&&row<520+13*2+2&&col>=70+jet_pos+23*2&&col<70+jet_pos+23*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+14*2&&row<520+14*2+2&&col>=70+jet_pos+23*2&&col<70+jet_pos+23*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+15*2&&row<520+15*2+2&&col>=70+jet_pos+23*2&&col<70+jet_pos+23*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+11*2&&row<520+11*2+2&&col>=70+jet_pos+24*2&&col<70+jet_pos+24*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+12*2&&row<520+12*2+2&&col>=70+jet_pos+24*2&&col<70+jet_pos+24*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+13*2&&row<520+13*2+2&&col>=70+jet_pos+24*2&&col<70+jet_pos+24*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+14*2&&row<520+14*2+2&&col>=70+jet_pos+24*2&&col<70+jet_pos+24*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+15*2&&row<520+15*2+2&&col>=70+jet_pos+24*2&&col<70+jet_pos+24*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+11*2&&row<520+11*2+2&&col>=70+jet_pos+25*2&&col<70+jet_pos+25*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+12*2&&row<520+12*2+2&&col>=70+jet_pos+25*2&&col<70+jet_pos+25*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+13*2&&row<520+13*2+2&&col>=70+jet_pos+25*2&&col<70+jet_pos+25*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+14*2&&row<520+14*2+2&&col>=70+jet_pos+25*2&&col<70+jet_pos+25*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+15*2&&row<520+15*2+2&&col>=70+jet_pos+25*2&&col<70+jet_pos+25*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+11*2&&row<520+11*2+2&&col>=70+jet_pos+26*2&&col<70+jet_pos+26*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+12*2&&row<520+12*2+2&&col>=70+jet_pos+26*2&&col<70+jet_pos+26*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+13*2&&row<520+13*2+2&&col>=70+jet_pos+26*2&&col<70+jet_pos+26*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+14*2&&row<520+14*2+2&&col>=70+jet_pos+26*2&&col<70+jet_pos+26*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+15*2&&row<520+15*2+2&&col>=70+jet_pos+26*2&&col<70+jet_pos+26*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+12*2&&row<520+12*2+2&&col>=70+jet_pos+27*2&&col<70+jet_pos+27*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+13*2&&row<520+13*2+2&&col>=70+jet_pos+27*2&&col<70+jet_pos+27*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+14*2&&row<520+14*2+2&&col>=70+jet_pos+27*2&&col<70+jet_pos+27*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+12*2&&row<520+12*2+2&&col>=70+jet_pos+28*2&&col<70+jet_pos+28*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+13*2&&row<520+13*2+2&&col>=70+jet_pos+28*2&&col<70+jet_pos+28*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos<=600&&row>=520+14*2&&row<520+14*2+2&&col>=70+jet_pos+28*2&&col<70+jet_pos+28*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+16*2&&row<520+600-jet_pos+16*2+2&&col>=670+1*2&&col<670+1*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+17*2&&row<520+600-jet_pos+17*2+2&&col>=670+1*2&&col<670+1*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+18*2&&row<520+600-jet_pos+18*2+2&&col>=670+1*2&&col<670+1*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+15*2&&row<520+600-jet_pos+15*2+2&&col>=670+2*2&&col<670+2*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+16*2&&row<520+600-jet_pos+16*2+2&&col>=670+2*2&&col<670+2*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+17*2&&row<520+600-jet_pos+17*2+2&&col>=670+2*2&&col<670+2*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+18*2&&row<520+600-jet_pos+18*2+2&&col>=670+2*2&&col<670+2*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+14*2&&row<520+600-jet_pos+14*2+2&&col>=670+3*2&&col<670+3*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+15*2&&row<520+600-jet_pos+15*2+2&&col>=670+3*2&&col<670+3*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+16*2&&row<520+600-jet_pos+16*2+2&&col>=670+3*2&&col<670+3*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+17*2&&row<520+600-jet_pos+17*2+2&&col>=670+3*2&&col<670+3*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+18*2&&row<520+600-jet_pos+18*2+2&&col>=670+3*2&&col<670+3*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+13*2&&row<520+600-jet_pos+13*2+2&&col>=670+4*2&&col<670+4*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+14*2&&row<520+600-jet_pos+14*2+2&&col>=670+4*2&&col<670+4*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+15*2&&row<520+600-jet_pos+15*2+2&&col>=670+4*2&&col<670+4*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+16*2&&row<520+600-jet_pos+16*2+2&&col>=670+4*2&&col<670+4*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+17*2&&row<520+600-jet_pos+17*2+2&&col>=670+4*2&&col<670+4*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+13*2&&row<520+600-jet_pos+13*2+2&&col>=670+5*2&&col<670+5*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+14*2&&row<520+600-jet_pos+14*2+2&&col>=670+5*2&&col<670+5*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+15*2&&row<520+600-jet_pos+15*2+2&&col>=670+5*2&&col<670+5*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+16*2&&row<520+600-jet_pos+16*2+2&&col>=670+5*2&&col<670+5*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+17*2&&row<520+600-jet_pos+17*2+2&&col>=670+5*2&&col<670+5*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+12*2&&row<520+600-jet_pos+12*2+2&&col>=670+6*2&&col<670+6*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+13*2&&row<520+600-jet_pos+13*2+2&&col>=670+6*2&&col<670+6*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+14*2&&row<520+600-jet_pos+14*2+2&&col>=670+6*2&&col<670+6*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+15*2&&row<520+600-jet_pos+15*2+2&&col>=670+6*2&&col<670+6*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+16*2&&row<520+600-jet_pos+16*2+2&&col>=670+6*2&&col<670+6*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+24*2&&row<520+600-jet_pos+24*2+2&&col>=670+6*2&&col<670+6*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+25*2&&row<520+600-jet_pos+25*2+2&&col>=670+6*2&&col<670+6*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+26*2&&row<520+600-jet_pos+26*2+2&&col>=670+6*2&&col<670+6*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+12*2&&row<520+600-jet_pos+12*2+2&&col>=670+7*2&&col<670+7*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+13*2&&row<520+600-jet_pos+13*2+2&&col>=670+7*2&&col<670+7*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+14*2&&row<520+600-jet_pos+14*2+2&&col>=670+7*2&&col<670+7*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+15*2&&row<520+600-jet_pos+15*2+2&&col>=670+7*2&&col<670+7*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+16*2&&row<520+600-jet_pos+16*2+2&&col>=670+7*2&&col<670+7*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+24*2&&row<520+600-jet_pos+24*2+2&&col>=670+7*2&&col<670+7*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+25*2&&row<520+600-jet_pos+25*2+2&&col>=670+7*2&&col<670+7*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+26*2&&row<520+600-jet_pos+26*2+2&&col>=670+7*2&&col<670+7*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+11*2&&row<520+600-jet_pos+11*2+2&&col>=670+8*2&&col<670+8*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+12*2&&row<520+600-jet_pos+12*2+2&&col>=670+8*2&&col<670+8*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+13*2&&row<520+600-jet_pos+13*2+2&&col>=670+8*2&&col<670+8*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+14*2&&row<520+600-jet_pos+14*2+2&&col>=670+8*2&&col<670+8*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+15*2&&row<520+600-jet_pos+15*2+2&&col>=670+8*2&&col<670+8*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+23*2&&row<520+600-jet_pos+23*2+2&&col>=670+8*2&&col<670+8*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+24*2&&row<520+600-jet_pos+24*2+2&&col>=670+8*2&&col<670+8*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+25*2&&row<520+600-jet_pos+25*2+2&&col>=670+8*2&&col<670+8*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+11*2&&row<520+600-jet_pos+11*2+2&&col>=670+9*2&&col<670+9*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+12*2&&row<520+600-jet_pos+12*2+2&&col>=670+9*2&&col<670+9*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+13*2&&row<520+600-jet_pos+13*2+2&&col>=670+9*2&&col<670+9*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+14*2&&row<520+600-jet_pos+14*2+2&&col>=670+9*2&&col<670+9*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+15*2&&row<520+600-jet_pos+15*2+2&&col>=670+9*2&&col<670+9*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+22*2&&row<520+600-jet_pos+22*2+2&&col>=670+9*2&&col<670+9*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+23*2&&row<520+600-jet_pos+23*2+2&&col>=670+9*2&&col<670+9*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+24*2&&row<520+600-jet_pos+24*2+2&&col>=670+9*2&&col<670+9*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+25*2&&row<520+600-jet_pos+25*2+2&&col>=670+9*2&&col<670+9*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+10*2&&row<520+600-jet_pos+10*2+2&&col>=670+10*2&&col<670+10*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+11*2&&row<520+600-jet_pos+11*2+2&&col>=670+10*2&&col<670+10*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+12*2&&row<520+600-jet_pos+12*2+2&&col>=670+10*2&&col<670+10*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+13*2&&row<520+600-jet_pos+13*2+2&&col>=670+10*2&&col<670+10*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+14*2&&row<520+600-jet_pos+14*2+2&&col>=670+10*2&&col<670+10*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+21*2&&row<520+600-jet_pos+21*2+2&&col>=670+10*2&&col<670+10*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+22*2&&row<520+600-jet_pos+22*2+2&&col>=670+10*2&&col<670+10*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+23*2&&row<520+600-jet_pos+23*2+2&&col>=670+10*2&&col<670+10*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+24*2&&row<520+600-jet_pos+24*2+2&&col>=670+10*2&&col<670+10*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+3*2&&row<520+600-jet_pos+3*2+2&&col>=670+11*2&&col<670+11*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+4*2&&row<520+600-jet_pos+4*2+2&&col>=670+11*2&&col<670+11*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+5*2&&row<520+600-jet_pos+5*2+2&&col>=670+11*2&&col<670+11*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+6*2&&row<520+600-jet_pos+6*2+2&&col>=670+11*2&&col<670+11*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+7*2&&row<520+600-jet_pos+7*2+2&&col>=670+11*2&&col<670+11*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+8*2&&row<520+600-jet_pos+8*2+2&&col>=670+11*2&&col<670+11*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+9*2&&row<520+600-jet_pos+9*2+2&&col>=670+11*2&&col<670+11*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+10*2&&row<520+600-jet_pos+10*2+2&&col>=670+11*2&&col<670+11*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+11*2&&row<520+600-jet_pos+11*2+2&&col>=670+11*2&&col<670+11*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+12*2&&row<520+600-jet_pos+12*2+2&&col>=670+11*2&&col<670+11*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+13*2&&row<520+600-jet_pos+13*2+2&&col>=670+11*2&&col<670+11*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+14*2&&row<520+600-jet_pos+14*2+2&&col>=670+11*2&&col<670+11*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+15*2&&row<520+600-jet_pos+15*2+2&&col>=670+11*2&&col<670+11*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+16*2&&row<520+600-jet_pos+16*2+2&&col>=670+11*2&&col<670+11*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+17*2&&row<520+600-jet_pos+17*2+2&&col>=670+11*2&&col<670+11*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+18*2&&row<520+600-jet_pos+18*2+2&&col>=670+11*2&&col<670+11*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+19*2&&row<520+600-jet_pos+19*2+2&&col>=670+11*2&&col<670+11*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+20*2&&row<520+600-jet_pos+20*2+2&&col>=670+11*2&&col<670+11*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+21*2&&row<520+600-jet_pos+21*2+2&&col>=670+11*2&&col<670+11*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+22*2&&row<520+600-jet_pos+22*2+2&&col>=670+11*2&&col<670+11*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+23*2&&row<520+600-jet_pos+23*2+2&&col>=670+11*2&&col<670+11*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+24*2&&row<520+600-jet_pos+24*2+2&&col>=670+11*2&&col<670+11*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+25*2&&row<520+600-jet_pos+25*2+2&&col>=670+11*2&&col<670+11*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+1*2&&row<520+600-jet_pos+1*2+2&&col>=670+12*2&&col<670+12*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+2*2&&row<520+600-jet_pos+2*2+2&&col>=670+12*2&&col<670+12*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+3*2&&row<520+600-jet_pos+3*2+2&&col>=670+12*2&&col<670+12*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+4*2&&row<520+600-jet_pos+4*2+2&&col>=670+12*2&&col<670+12*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+5*2&&row<520+600-jet_pos+5*2+2&&col>=670+12*2&&col<670+12*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+6*2&&row<520+600-jet_pos+6*2+2&&col>=670+12*2&&col<670+12*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+7*2&&row<520+600-jet_pos+7*2+2&&col>=670+12*2&&col<670+12*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+8*2&&row<520+600-jet_pos+8*2+2&&col>=670+12*2&&col<670+12*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+9*2&&row<520+600-jet_pos+9*2+2&&col>=670+12*2&&col<670+12*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+10*2&&row<520+600-jet_pos+10*2+2&&col>=670+12*2&&col<670+12*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+11*2&&row<520+600-jet_pos+11*2+2&&col>=670+12*2&&col<670+12*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+12*2&&row<520+600-jet_pos+12*2+2&&col>=670+12*2&&col<670+12*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+13*2&&row<520+600-jet_pos+13*2+2&&col>=670+12*2&&col<670+12*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+14*2&&row<520+600-jet_pos+14*2+2&&col>=670+12*2&&col<670+12*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+15*2&&row<520+600-jet_pos+15*2+2&&col>=670+12*2&&col<670+12*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+16*2&&row<520+600-jet_pos+16*2+2&&col>=670+12*2&&col<670+12*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+17*2&&row<520+600-jet_pos+17*2+2&&col>=670+12*2&&col<670+12*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+18*2&&row<520+600-jet_pos+18*2+2&&col>=670+12*2&&col<670+12*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+19*2&&row<520+600-jet_pos+19*2+2&&col>=670+12*2&&col<670+12*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+20*2&&row<520+600-jet_pos+20*2+2&&col>=670+12*2&&col<670+12*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+21*2&&row<520+600-jet_pos+21*2+2&&col>=670+12*2&&col<670+12*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+22*2&&row<520+600-jet_pos+22*2+2&&col>=670+12*2&&col<670+12*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+23*2&&row<520+600-jet_pos+23*2+2&&col>=670+12*2&&col<670+12*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+24*2&&row<520+600-jet_pos+24*2+2&&col>=670+12*2&&col<670+12*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+25*2&&row<520+600-jet_pos+25*2+2&&col>=670+12*2&&col<670+12*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+26*2&&row<520+600-jet_pos+26*2+2&&col>=670+12*2&&col<670+12*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+27*2&&row<520+600-jet_pos+27*2+2&&col>=670+12*2&&col<670+12*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+1*2&&row<520+600-jet_pos+1*2+2&&col>=670+13*2&&col<670+13*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+2*2&&row<520+600-jet_pos+2*2+2&&col>=670+13*2&&col<670+13*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+3*2&&row<520+600-jet_pos+3*2+2&&col>=670+13*2&&col<670+13*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+4*2&&row<520+600-jet_pos+4*2+2&&col>=670+13*2&&col<670+13*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+5*2&&row<520+600-jet_pos+5*2+2&&col>=670+13*2&&col<670+13*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+6*2&&row<520+600-jet_pos+6*2+2&&col>=670+13*2&&col<670+13*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+7*2&&row<520+600-jet_pos+7*2+2&&col>=670+13*2&&col<670+13*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+8*2&&row<520+600-jet_pos+8*2+2&&col>=670+13*2&&col<670+13*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+9*2&&row<520+600-jet_pos+9*2+2&&col>=670+13*2&&col<670+13*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+10*2&&row<520+600-jet_pos+10*2+2&&col>=670+13*2&&col<670+13*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+11*2&&row<520+600-jet_pos+11*2+2&&col>=670+13*2&&col<670+13*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+12*2&&row<520+600-jet_pos+12*2+2&&col>=670+13*2&&col<670+13*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+13*2&&row<520+600-jet_pos+13*2+2&&col>=670+13*2&&col<670+13*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+14*2&&row<520+600-jet_pos+14*2+2&&col>=670+13*2&&col<670+13*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+15*2&&row<520+600-jet_pos+15*2+2&&col>=670+13*2&&col<670+13*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+16*2&&row<520+600-jet_pos+16*2+2&&col>=670+13*2&&col<670+13*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+17*2&&row<520+600-jet_pos+17*2+2&&col>=670+13*2&&col<670+13*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+18*2&&row<520+600-jet_pos+18*2+2&&col>=670+13*2&&col<670+13*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+19*2&&row<520+600-jet_pos+19*2+2&&col>=670+13*2&&col<670+13*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+20*2&&row<520+600-jet_pos+20*2+2&&col>=670+13*2&&col<670+13*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+21*2&&row<520+600-jet_pos+21*2+2&&col>=670+13*2&&col<670+13*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+22*2&&row<520+600-jet_pos+22*2+2&&col>=670+13*2&&col<670+13*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+23*2&&row<520+600-jet_pos+23*2+2&&col>=670+13*2&&col<670+13*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+24*2&&row<520+600-jet_pos+24*2+2&&col>=670+13*2&&col<670+13*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+25*2&&row<520+600-jet_pos+25*2+2&&col>=670+13*2&&col<670+13*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+26*2&&row<520+600-jet_pos+26*2+2&&col>=670+13*2&&col<670+13*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+27*2&&row<520+600-jet_pos+27*2+2&&col>=670+13*2&&col<670+13*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+28*2&&row<520+600-jet_pos+28*2+2&&col>=670+13*2&&col<670+13*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+1*2&&row<520+600-jet_pos+1*2+2&&col>=670+14*2&&col<670+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+2*2&&row<520+600-jet_pos+2*2+2&&col>=670+14*2&&col<670+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+3*2&&row<520+600-jet_pos+3*2+2&&col>=670+14*2&&col<670+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+4*2&&row<520+600-jet_pos+4*2+2&&col>=670+14*2&&col<670+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+5*2&&row<520+600-jet_pos+5*2+2&&col>=670+14*2&&col<670+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+6*2&&row<520+600-jet_pos+6*2+2&&col>=670+14*2&&col<670+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+7*2&&row<520+600-jet_pos+7*2+2&&col>=670+14*2&&col<670+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+8*2&&row<520+600-jet_pos+8*2+2&&col>=670+14*2&&col<670+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+9*2&&row<520+600-jet_pos+9*2+2&&col>=670+14*2&&col<670+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+10*2&&row<520+600-jet_pos+10*2+2&&col>=670+14*2&&col<670+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+11*2&&row<520+600-jet_pos+11*2+2&&col>=670+14*2&&col<670+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+12*2&&row<520+600-jet_pos+12*2+2&&col>=670+14*2&&col<670+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+13*2&&row<520+600-jet_pos+13*2+2&&col>=670+14*2&&col<670+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+14*2&&row<520+600-jet_pos+14*2+2&&col>=670+14*2&&col<670+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+15*2&&row<520+600-jet_pos+15*2+2&&col>=670+14*2&&col<670+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+16*2&&row<520+600-jet_pos+16*2+2&&col>=670+14*2&&col<670+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+17*2&&row<520+600-jet_pos+17*2+2&&col>=670+14*2&&col<670+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+18*2&&row<520+600-jet_pos+18*2+2&&col>=670+14*2&&col<670+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+19*2&&row<520+600-jet_pos+19*2+2&&col>=670+14*2&&col<670+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+20*2&&row<520+600-jet_pos+20*2+2&&col>=670+14*2&&col<670+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+21*2&&row<520+600-jet_pos+21*2+2&&col>=670+14*2&&col<670+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+22*2&&row<520+600-jet_pos+22*2+2&&col>=670+14*2&&col<670+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+23*2&&row<520+600-jet_pos+23*2+2&&col>=670+14*2&&col<670+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+24*2&&row<520+600-jet_pos+24*2+2&&col>=670+14*2&&col<670+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+25*2&&row<520+600-jet_pos+25*2+2&&col>=670+14*2&&col<670+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+26*2&&row<520+600-jet_pos+26*2+2&&col>=670+14*2&&col<670+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+27*2&&row<520+600-jet_pos+27*2+2&&col>=670+14*2&&col<670+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+3*2&&row<520+600-jet_pos+3*2+2&&col>=670+15*2&&col<670+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+4*2&&row<520+600-jet_pos+4*2+2&&col>=670+15*2&&col<670+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+5*2&&row<520+600-jet_pos+5*2+2&&col>=670+15*2&&col<670+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+6*2&&row<520+600-jet_pos+6*2+2&&col>=670+15*2&&col<670+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+7*2&&row<520+600-jet_pos+7*2+2&&col>=670+15*2&&col<670+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+8*2&&row<520+600-jet_pos+8*2+2&&col>=670+15*2&&col<670+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+9*2&&row<520+600-jet_pos+9*2+2&&col>=670+15*2&&col<670+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+10*2&&row<520+600-jet_pos+10*2+2&&col>=670+15*2&&col<670+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+11*2&&row<520+600-jet_pos+11*2+2&&col>=670+15*2&&col<670+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+12*2&&row<520+600-jet_pos+12*2+2&&col>=670+15*2&&col<670+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+13*2&&row<520+600-jet_pos+13*2+2&&col>=670+15*2&&col<670+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+14*2&&row<520+600-jet_pos+14*2+2&&col>=670+15*2&&col<670+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+15*2&&row<520+600-jet_pos+15*2+2&&col>=670+15*2&&col<670+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+16*2&&row<520+600-jet_pos+16*2+2&&col>=670+15*2&&col<670+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+17*2&&row<520+600-jet_pos+17*2+2&&col>=670+15*2&&col<670+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+18*2&&row<520+600-jet_pos+18*2+2&&col>=670+15*2&&col<670+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+19*2&&row<520+600-jet_pos+19*2+2&&col>=670+15*2&&col<670+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+20*2&&row<520+600-jet_pos+20*2+2&&col>=670+15*2&&col<670+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+21*2&&row<520+600-jet_pos+21*2+2&&col>=670+15*2&&col<670+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+22*2&&row<520+600-jet_pos+22*2+2&&col>=670+15*2&&col<670+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+23*2&&row<520+600-jet_pos+23*2+2&&col>=670+15*2&&col<670+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+24*2&&row<520+600-jet_pos+24*2+2&&col>=670+15*2&&col<670+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+25*2&&row<520+600-jet_pos+25*2+2&&col>=670+15*2&&col<670+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+10*2&&row<520+600-jet_pos+10*2+2&&col>=670+16*2&&col<670+16*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+11*2&&row<520+600-jet_pos+11*2+2&&col>=670+16*2&&col<670+16*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+12*2&&row<520+600-jet_pos+12*2+2&&col>=670+16*2&&col<670+16*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+13*2&&row<520+600-jet_pos+13*2+2&&col>=670+16*2&&col<670+16*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+14*2&&row<520+600-jet_pos+14*2+2&&col>=670+16*2&&col<670+16*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+21*2&&row<520+600-jet_pos+21*2+2&&col>=670+16*2&&col<670+16*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+22*2&&row<520+600-jet_pos+22*2+2&&col>=670+16*2&&col<670+16*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+23*2&&row<520+600-jet_pos+23*2+2&&col>=670+16*2&&col<670+16*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+24*2&&row<520+600-jet_pos+24*2+2&&col>=670+16*2&&col<670+16*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+11*2&&row<520+600-jet_pos+11*2+2&&col>=670+17*2&&col<670+17*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+12*2&&row<520+600-jet_pos+12*2+2&&col>=670+17*2&&col<670+17*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+13*2&&row<520+600-jet_pos+13*2+2&&col>=670+17*2&&col<670+17*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+14*2&&row<520+600-jet_pos+14*2+2&&col>=670+17*2&&col<670+17*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+15*2&&row<520+600-jet_pos+15*2+2&&col>=670+17*2&&col<670+17*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+22*2&&row<520+600-jet_pos+22*2+2&&col>=670+17*2&&col<670+17*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+23*2&&row<520+600-jet_pos+23*2+2&&col>=670+17*2&&col<670+17*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+24*2&&row<520+600-jet_pos+24*2+2&&col>=670+17*2&&col<670+17*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+25*2&&row<520+600-jet_pos+25*2+2&&col>=670+17*2&&col<670+17*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+11*2&&row<520+600-jet_pos+11*2+2&&col>=670+18*2&&col<670+18*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+12*2&&row<520+600-jet_pos+12*2+2&&col>=670+18*2&&col<670+18*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+13*2&&row<520+600-jet_pos+13*2+2&&col>=670+18*2&&col<670+18*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+14*2&&row<520+600-jet_pos+14*2+2&&col>=670+18*2&&col<670+18*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+15*2&&row<520+600-jet_pos+15*2+2&&col>=670+18*2&&col<670+18*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+23*2&&row<520+600-jet_pos+23*2+2&&col>=670+18*2&&col<670+18*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+24*2&&row<520+600-jet_pos+24*2+2&&col>=670+18*2&&col<670+18*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+25*2&&row<520+600-jet_pos+25*2+2&&col>=670+18*2&&col<670+18*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+12*2&&row<520+600-jet_pos+12*2+2&&col>=670+19*2&&col<670+19*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+13*2&&row<520+600-jet_pos+13*2+2&&col>=670+19*2&&col<670+19*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+14*2&&row<520+600-jet_pos+14*2+2&&col>=670+19*2&&col<670+19*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+15*2&&row<520+600-jet_pos+15*2+2&&col>=670+19*2&&col<670+19*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+16*2&&row<520+600-jet_pos+16*2+2&&col>=670+19*2&&col<670+19*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+24*2&&row<520+600-jet_pos+24*2+2&&col>=670+19*2&&col<670+19*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+25*2&&row<520+600-jet_pos+25*2+2&&col>=670+19*2&&col<670+19*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+26*2&&row<520+600-jet_pos+26*2+2&&col>=670+19*2&&col<670+19*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+12*2&&row<520+600-jet_pos+12*2+2&&col>=670+20*2&&col<670+20*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+13*2&&row<520+600-jet_pos+13*2+2&&col>=670+20*2&&col<670+20*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+14*2&&row<520+600-jet_pos+14*2+2&&col>=670+20*2&&col<670+20*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+15*2&&row<520+600-jet_pos+15*2+2&&col>=670+20*2&&col<670+20*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+16*2&&row<520+600-jet_pos+16*2+2&&col>=670+20*2&&col<670+20*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+24*2&&row<520+600-jet_pos+24*2+2&&col>=670+20*2&&col<670+20*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+25*2&&row<520+600-jet_pos+25*2+2&&col>=670+20*2&&col<670+20*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+26*2&&row<520+600-jet_pos+26*2+2&&col>=670+20*2&&col<670+20*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+13*2&&row<520+600-jet_pos+13*2+2&&col>=670+21*2&&col<670+21*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+14*2&&row<520+600-jet_pos+14*2+2&&col>=670+21*2&&col<670+21*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+15*2&&row<520+600-jet_pos+15*2+2&&col>=670+21*2&&col<670+21*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+16*2&&row<520+600-jet_pos+16*2+2&&col>=670+21*2&&col<670+21*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+17*2&&row<520+600-jet_pos+17*2+2&&col>=670+21*2&&col<670+21*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+13*2&&row<520+600-jet_pos+13*2+2&&col>=670+22*2&&col<670+22*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+14*2&&row<520+600-jet_pos+14*2+2&&col>=670+22*2&&col<670+22*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+15*2&&row<520+600-jet_pos+15*2+2&&col>=670+22*2&&col<670+22*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+16*2&&row<520+600-jet_pos+16*2+2&&col>=670+22*2&&col<670+22*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+17*2&&row<520+600-jet_pos+17*2+2&&col>=670+22*2&&col<670+22*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+14*2&&row<520+600-jet_pos+14*2+2&&col>=670+23*2&&col<670+23*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+15*2&&row<520+600-jet_pos+15*2+2&&col>=670+23*2&&col<670+23*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+16*2&&row<520+600-jet_pos+16*2+2&&col>=670+23*2&&col<670+23*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+17*2&&row<520+600-jet_pos+17*2+2&&col>=670+23*2&&col<670+23*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+18*2&&row<520+600-jet_pos+18*2+2&&col>=670+23*2&&col<670+23*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+15*2&&row<520+600-jet_pos+15*2+2&&col>=670+24*2&&col<670+24*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+16*2&&row<520+600-jet_pos+16*2+2&&col>=670+24*2&&col<670+24*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+17*2&&row<520+600-jet_pos+17*2+2&&col>=670+24*2&&col<670+24*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+18*2&&row<520+600-jet_pos+18*2+2&&col>=670+24*2&&col<670+24*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+16*2&&row<520+600-jet_pos+16*2+2&&col>=670+25*2&&col<670+25*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+17*2&&row<520+600-jet_pos+17*2+2&&col>=670+25*2&&col<670+25*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+18*2&&row<520+600-jet_pos+18*2+2&&col>=670+25*2&&col<670+25*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+15*2&&row<20+15*2+2&&col>=670+1100-jet_pos+1*2&&col<670+1100-jet_pos+1*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+16*2&&row<20+16*2+2&&col>=670+1100-jet_pos+1*2&&col<670+1100-jet_pos+1*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+17*2&&row<20+17*2+2&&col>=670+1100-jet_pos+1*2&&col<670+1100-jet_pos+1*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+15*2&&row<20+15*2+2&&col>=670+1100-jet_pos+2*2&&col<670+1100-jet_pos+2*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+16*2&&row<20+16*2+2&&col>=670+1100-jet_pos+2*2&&col<670+1100-jet_pos+2*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+17*2&&row<20+17*2+2&&col>=670+1100-jet_pos+2*2&&col<670+1100-jet_pos+2*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+14*2&&row<20+14*2+2&&col>=670+1100-jet_pos+3*2&&col<670+1100-jet_pos+3*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+15*2&&row<20+15*2+2&&col>=670+1100-jet_pos+3*2&&col<670+1100-jet_pos+3*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+16*2&&row<20+16*2+2&&col>=670+1100-jet_pos+3*2&&col<670+1100-jet_pos+3*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+17*2&&row<20+17*2+2&&col>=670+1100-jet_pos+3*2&&col<670+1100-jet_pos+3*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+18*2&&row<20+18*2+2&&col>=670+1100-jet_pos+3*2&&col<670+1100-jet_pos+3*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+14*2&&row<20+14*2+2&&col>=670+1100-jet_pos+4*2&&col<670+1100-jet_pos+4*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+15*2&&row<20+15*2+2&&col>=670+1100-jet_pos+4*2&&col<670+1100-jet_pos+4*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+16*2&&row<20+16*2+2&&col>=670+1100-jet_pos+4*2&&col<670+1100-jet_pos+4*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+17*2&&row<20+17*2+2&&col>=670+1100-jet_pos+4*2&&col<670+1100-jet_pos+4*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+18*2&&row<20+18*2+2&&col>=670+1100-jet_pos+4*2&&col<670+1100-jet_pos+4*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+14*2&&row<20+14*2+2&&col>=670+1100-jet_pos+5*2&&col<670+1100-jet_pos+5*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+15*2&&row<20+15*2+2&&col>=670+1100-jet_pos+5*2&&col<670+1100-jet_pos+5*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+16*2&&row<20+16*2+2&&col>=670+1100-jet_pos+5*2&&col<670+1100-jet_pos+5*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+17*2&&row<20+17*2+2&&col>=670+1100-jet_pos+5*2&&col<670+1100-jet_pos+5*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+18*2&&row<20+18*2+2&&col>=670+1100-jet_pos+5*2&&col<670+1100-jet_pos+5*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+14*2&&row<20+14*2+2&&col>=670+1100-jet_pos+6*2&&col<670+1100-jet_pos+6*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+15*2&&row<20+15*2+2&&col>=670+1100-jet_pos+6*2&&col<670+1100-jet_pos+6*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+16*2&&row<20+16*2+2&&col>=670+1100-jet_pos+6*2&&col<670+1100-jet_pos+6*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+17*2&&row<20+17*2+2&&col>=670+1100-jet_pos+6*2&&col<670+1100-jet_pos+6*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+18*2&&row<20+18*2+2&&col>=670+1100-jet_pos+6*2&&col<670+1100-jet_pos+6*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+14*2&&row<20+14*2+2&&col>=670+1100-jet_pos+7*2&&col<670+1100-jet_pos+7*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+15*2&&row<20+15*2+2&&col>=670+1100-jet_pos+7*2&&col<670+1100-jet_pos+7*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+16*2&&row<20+16*2+2&&col>=670+1100-jet_pos+7*2&&col<670+1100-jet_pos+7*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+17*2&&row<20+17*2+2&&col>=670+1100-jet_pos+7*2&&col<670+1100-jet_pos+7*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+18*2&&row<20+18*2+2&&col>=670+1100-jet_pos+7*2&&col<670+1100-jet_pos+7*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+14*2&&row<20+14*2+2&&col>=670+1100-jet_pos+8*2&&col<670+1100-jet_pos+8*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+15*2&&row<20+15*2+2&&col>=670+1100-jet_pos+8*2&&col<670+1100-jet_pos+8*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+16*2&&row<20+16*2+2&&col>=670+1100-jet_pos+8*2&&col<670+1100-jet_pos+8*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+17*2&&row<20+17*2+2&&col>=670+1100-jet_pos+8*2&&col<670+1100-jet_pos+8*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+18*2&&row<20+18*2+2&&col>=670+1100-jet_pos+8*2&&col<670+1100-jet_pos+8*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+14*2&&row<20+14*2+2&&col>=670+1100-jet_pos+9*2&&col<670+1100-jet_pos+9*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+15*2&&row<20+15*2+2&&col>=670+1100-jet_pos+9*2&&col<670+1100-jet_pos+9*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+16*2&&row<20+16*2+2&&col>=670+1100-jet_pos+9*2&&col<670+1100-jet_pos+9*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+17*2&&row<20+17*2+2&&col>=670+1100-jet_pos+9*2&&col<670+1100-jet_pos+9*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+18*2&&row<20+18*2+2&&col>=670+1100-jet_pos+9*2&&col<670+1100-jet_pos+9*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+13*2&&row<20+13*2+2&&col>=670+1100-jet_pos+10*2&&col<670+1100-jet_pos+10*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+14*2&&row<20+14*2+2&&col>=670+1100-jet_pos+10*2&&col<670+1100-jet_pos+10*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+15*2&&row<20+15*2+2&&col>=670+1100-jet_pos+10*2&&col<670+1100-jet_pos+10*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+16*2&&row<20+16*2+2&&col>=670+1100-jet_pos+10*2&&col<670+1100-jet_pos+10*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+17*2&&row<20+17*2+2&&col>=670+1100-jet_pos+10*2&&col<670+1100-jet_pos+10*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+18*2&&row<20+18*2+2&&col>=670+1100-jet_pos+10*2&&col<670+1100-jet_pos+10*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+19*2&&row<20+19*2+2&&col>=670+1100-jet_pos+10*2&&col<670+1100-jet_pos+10*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+11*2&&row<20+11*2+2&&col>=670+1100-jet_pos+11*2&&col<670+1100-jet_pos+11*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+12*2&&row<20+12*2+2&&col>=670+1100-jet_pos+11*2&&col<670+1100-jet_pos+11*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+13*2&&row<20+13*2+2&&col>=670+1100-jet_pos+11*2&&col<670+1100-jet_pos+11*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+14*2&&row<20+14*2+2&&col>=670+1100-jet_pos+11*2&&col<670+1100-jet_pos+11*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+15*2&&row<20+15*2+2&&col>=670+1100-jet_pos+11*2&&col<670+1100-jet_pos+11*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+16*2&&row<20+16*2+2&&col>=670+1100-jet_pos+11*2&&col<670+1100-jet_pos+11*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+17*2&&row<20+17*2+2&&col>=670+1100-jet_pos+11*2&&col<670+1100-jet_pos+11*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+18*2&&row<20+18*2+2&&col>=670+1100-jet_pos+11*2&&col<670+1100-jet_pos+11*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+19*2&&row<20+19*2+2&&col>=670+1100-jet_pos+11*2&&col<670+1100-jet_pos+11*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+20*2&&row<20+20*2+2&&col>=670+1100-jet_pos+11*2&&col<670+1100-jet_pos+11*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+21*2&&row<20+21*2+2&&col>=670+1100-jet_pos+11*2&&col<670+1100-jet_pos+11*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+9*2&&row<20+9*2+2&&col>=670+1100-jet_pos+12*2&&col<670+1100-jet_pos+12*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+10*2&&row<20+10*2+2&&col>=670+1100-jet_pos+12*2&&col<670+1100-jet_pos+12*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+11*2&&row<20+11*2+2&&col>=670+1100-jet_pos+12*2&&col<670+1100-jet_pos+12*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+12*2&&row<20+12*2+2&&col>=670+1100-jet_pos+12*2&&col<670+1100-jet_pos+12*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+13*2&&row<20+13*2+2&&col>=670+1100-jet_pos+12*2&&col<670+1100-jet_pos+12*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+14*2&&row<20+14*2+2&&col>=670+1100-jet_pos+12*2&&col<670+1100-jet_pos+12*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+15*2&&row<20+15*2+2&&col>=670+1100-jet_pos+12*2&&col<670+1100-jet_pos+12*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+16*2&&row<20+16*2+2&&col>=670+1100-jet_pos+12*2&&col<670+1100-jet_pos+12*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+17*2&&row<20+17*2+2&&col>=670+1100-jet_pos+12*2&&col<670+1100-jet_pos+12*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+18*2&&row<20+18*2+2&&col>=670+1100-jet_pos+12*2&&col<670+1100-jet_pos+12*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+19*2&&row<20+19*2+2&&col>=670+1100-jet_pos+12*2&&col<670+1100-jet_pos+12*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+20*2&&row<20+20*2+2&&col>=670+1100-jet_pos+12*2&&col<670+1100-jet_pos+12*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+21*2&&row<20+21*2+2&&col>=670+1100-jet_pos+12*2&&col<670+1100-jet_pos+12*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+22*2&&row<20+22*2+2&&col>=670+1100-jet_pos+12*2&&col<670+1100-jet_pos+12*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+23*2&&row<20+23*2+2&&col>=670+1100-jet_pos+12*2&&col<670+1100-jet_pos+12*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+7*2&&row<20+7*2+2&&col>=670+1100-jet_pos+13*2&&col<670+1100-jet_pos+13*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+8*2&&row<20+8*2+2&&col>=670+1100-jet_pos+13*2&&col<670+1100-jet_pos+13*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+9*2&&row<20+9*2+2&&col>=670+1100-jet_pos+13*2&&col<670+1100-jet_pos+13*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+10*2&&row<20+10*2+2&&col>=670+1100-jet_pos+13*2&&col<670+1100-jet_pos+13*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+11*2&&row<20+11*2+2&&col>=670+1100-jet_pos+13*2&&col<670+1100-jet_pos+13*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+12*2&&row<20+12*2+2&&col>=670+1100-jet_pos+13*2&&col<670+1100-jet_pos+13*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+13*2&&row<20+13*2+2&&col>=670+1100-jet_pos+13*2&&col<670+1100-jet_pos+13*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+14*2&&row<20+14*2+2&&col>=670+1100-jet_pos+13*2&&col<670+1100-jet_pos+13*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+15*2&&row<20+15*2+2&&col>=670+1100-jet_pos+13*2&&col<670+1100-jet_pos+13*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+16*2&&row<20+16*2+2&&col>=670+1100-jet_pos+13*2&&col<670+1100-jet_pos+13*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+17*2&&row<20+17*2+2&&col>=670+1100-jet_pos+13*2&&col<670+1100-jet_pos+13*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+18*2&&row<20+18*2+2&&col>=670+1100-jet_pos+13*2&&col<670+1100-jet_pos+13*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+19*2&&row<20+19*2+2&&col>=670+1100-jet_pos+13*2&&col<670+1100-jet_pos+13*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+20*2&&row<20+20*2+2&&col>=670+1100-jet_pos+13*2&&col<670+1100-jet_pos+13*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+21*2&&row<20+21*2+2&&col>=670+1100-jet_pos+13*2&&col<670+1100-jet_pos+13*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+22*2&&row<20+22*2+2&&col>=670+1100-jet_pos+13*2&&col<670+1100-jet_pos+13*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+23*2&&row<20+23*2+2&&col>=670+1100-jet_pos+13*2&&col<670+1100-jet_pos+13*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+24*2&&row<20+24*2+2&&col>=670+1100-jet_pos+13*2&&col<670+1100-jet_pos+13*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+25*2&&row<20+25*2+2&&col>=670+1100-jet_pos+13*2&&col<670+1100-jet_pos+13*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+6*2&&row<20+6*2+2&&col>=670+1100-jet_pos+14*2&&col<670+1100-jet_pos+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+7*2&&row<20+7*2+2&&col>=670+1100-jet_pos+14*2&&col<670+1100-jet_pos+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+8*2&&row<20+8*2+2&&col>=670+1100-jet_pos+14*2&&col<670+1100-jet_pos+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+9*2&&row<20+9*2+2&&col>=670+1100-jet_pos+14*2&&col<670+1100-jet_pos+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+10*2&&row<20+10*2+2&&col>=670+1100-jet_pos+14*2&&col<670+1100-jet_pos+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+11*2&&row<20+11*2+2&&col>=670+1100-jet_pos+14*2&&col<670+1100-jet_pos+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+12*2&&row<20+12*2+2&&col>=670+1100-jet_pos+14*2&&col<670+1100-jet_pos+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+13*2&&row<20+13*2+2&&col>=670+1100-jet_pos+14*2&&col<670+1100-jet_pos+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+14*2&&row<20+14*2+2&&col>=670+1100-jet_pos+14*2&&col<670+1100-jet_pos+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+15*2&&row<20+15*2+2&&col>=670+1100-jet_pos+14*2&&col<670+1100-jet_pos+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+16*2&&row<20+16*2+2&&col>=670+1100-jet_pos+14*2&&col<670+1100-jet_pos+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+17*2&&row<20+17*2+2&&col>=670+1100-jet_pos+14*2&&col<670+1100-jet_pos+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+18*2&&row<20+18*2+2&&col>=670+1100-jet_pos+14*2&&col<670+1100-jet_pos+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+19*2&&row<20+19*2+2&&col>=670+1100-jet_pos+14*2&&col<670+1100-jet_pos+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+20*2&&row<20+20*2+2&&col>=670+1100-jet_pos+14*2&&col<670+1100-jet_pos+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+21*2&&row<20+21*2+2&&col>=670+1100-jet_pos+14*2&&col<670+1100-jet_pos+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+22*2&&row<20+22*2+2&&col>=670+1100-jet_pos+14*2&&col<670+1100-jet_pos+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+23*2&&row<20+23*2+2&&col>=670+1100-jet_pos+14*2&&col<670+1100-jet_pos+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+24*2&&row<20+24*2+2&&col>=670+1100-jet_pos+14*2&&col<670+1100-jet_pos+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+25*2&&row<20+25*2+2&&col>=670+1100-jet_pos+14*2&&col<670+1100-jet_pos+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+26*2&&row<20+26*2+2&&col>=670+1100-jet_pos+14*2&&col<670+1100-jet_pos+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+5*2&&row<20+5*2+2&&col>=670+1100-jet_pos+15*2&&col<670+1100-jet_pos+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+6*2&&row<20+6*2+2&&col>=670+1100-jet_pos+15*2&&col<670+1100-jet_pos+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+7*2&&row<20+7*2+2&&col>=670+1100-jet_pos+15*2&&col<670+1100-jet_pos+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+8*2&&row<20+8*2+2&&col>=670+1100-jet_pos+15*2&&col<670+1100-jet_pos+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+9*2&&row<20+9*2+2&&col>=670+1100-jet_pos+15*2&&col<670+1100-jet_pos+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+10*2&&row<20+10*2+2&&col>=670+1100-jet_pos+15*2&&col<670+1100-jet_pos+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+11*2&&row<20+11*2+2&&col>=670+1100-jet_pos+15*2&&col<670+1100-jet_pos+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+12*2&&row<20+12*2+2&&col>=670+1100-jet_pos+15*2&&col<670+1100-jet_pos+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+14*2&&row<20+14*2+2&&col>=670+1100-jet_pos+15*2&&col<670+1100-jet_pos+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+15*2&&row<20+15*2+2&&col>=670+1100-jet_pos+15*2&&col<670+1100-jet_pos+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+16*2&&row<20+16*2+2&&col>=670+1100-jet_pos+15*2&&col<670+1100-jet_pos+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+17*2&&row<20+17*2+2&&col>=670+1100-jet_pos+15*2&&col<670+1100-jet_pos+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+18*2&&row<20+18*2+2&&col>=670+1100-jet_pos+15*2&&col<670+1100-jet_pos+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+20*2&&row<20+20*2+2&&col>=670+1100-jet_pos+15*2&&col<670+1100-jet_pos+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+21*2&&row<20+21*2+2&&col>=670+1100-jet_pos+15*2&&col<670+1100-jet_pos+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+22*2&&row<20+22*2+2&&col>=670+1100-jet_pos+15*2&&col<670+1100-jet_pos+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+23*2&&row<20+23*2+2&&col>=670+1100-jet_pos+15*2&&col<670+1100-jet_pos+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+24*2&&row<20+24*2+2&&col>=670+1100-jet_pos+15*2&&col<670+1100-jet_pos+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+25*2&&row<20+25*2+2&&col>=670+1100-jet_pos+15*2&&col<670+1100-jet_pos+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+26*2&&row<20+26*2+2&&col>=670+1100-jet_pos+15*2&&col<670+1100-jet_pos+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+27*2&&row<20+27*2+2&&col>=670+1100-jet_pos+15*2&&col<670+1100-jet_pos+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+4*2&&row<20+4*2+2&&col>=670+1100-jet_pos+16*2&&col<670+1100-jet_pos+16*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+5*2&&row<20+5*2+2&&col>=670+1100-jet_pos+16*2&&col<670+1100-jet_pos+16*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+6*2&&row<20+6*2+2&&col>=670+1100-jet_pos+16*2&&col<670+1100-jet_pos+16*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+7*2&&row<20+7*2+2&&col>=670+1100-jet_pos+16*2&&col<670+1100-jet_pos+16*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+8*2&&row<20+8*2+2&&col>=670+1100-jet_pos+16*2&&col<670+1100-jet_pos+16*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+9*2&&row<20+9*2+2&&col>=670+1100-jet_pos+16*2&&col<670+1100-jet_pos+16*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+10*2&&row<20+10*2+2&&col>=670+1100-jet_pos+16*2&&col<670+1100-jet_pos+16*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+14*2&&row<20+14*2+2&&col>=670+1100-jet_pos+16*2&&col<670+1100-jet_pos+16*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+15*2&&row<20+15*2+2&&col>=670+1100-jet_pos+16*2&&col<670+1100-jet_pos+16*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+16*2&&row<20+16*2+2&&col>=670+1100-jet_pos+16*2&&col<670+1100-jet_pos+16*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+17*2&&row<20+17*2+2&&col>=670+1100-jet_pos+16*2&&col<670+1100-jet_pos+16*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+18*2&&row<20+18*2+2&&col>=670+1100-jet_pos+16*2&&col<670+1100-jet_pos+16*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+22*2&&row<20+22*2+2&&col>=670+1100-jet_pos+16*2&&col<670+1100-jet_pos+16*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+23*2&&row<20+23*2+2&&col>=670+1100-jet_pos+16*2&&col<670+1100-jet_pos+16*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+24*2&&row<20+24*2+2&&col>=670+1100-jet_pos+16*2&&col<670+1100-jet_pos+16*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+25*2&&row<20+25*2+2&&col>=670+1100-jet_pos+16*2&&col<670+1100-jet_pos+16*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+26*2&&row<20+26*2+2&&col>=670+1100-jet_pos+16*2&&col<670+1100-jet_pos+16*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+27*2&&row<20+27*2+2&&col>=670+1100-jet_pos+16*2&&col<670+1100-jet_pos+16*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+28*2&&row<20+28*2+2&&col>=670+1100-jet_pos+16*2&&col<670+1100-jet_pos+16*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+4*2&&row<20+4*2+2&&col>=670+1100-jet_pos+17*2&&col<670+1100-jet_pos+17*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+5*2&&row<20+5*2+2&&col>=670+1100-jet_pos+17*2&&col<670+1100-jet_pos+17*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+6*2&&row<20+6*2+2&&col>=670+1100-jet_pos+17*2&&col<670+1100-jet_pos+17*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+7*2&&row<20+7*2+2&&col>=670+1100-jet_pos+17*2&&col<670+1100-jet_pos+17*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+8*2&&row<20+8*2+2&&col>=670+1100-jet_pos+17*2&&col<670+1100-jet_pos+17*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+14*2&&row<20+14*2+2&&col>=670+1100-jet_pos+17*2&&col<670+1100-jet_pos+17*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+15*2&&row<20+15*2+2&&col>=670+1100-jet_pos+17*2&&col<670+1100-jet_pos+17*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+16*2&&row<20+16*2+2&&col>=670+1100-jet_pos+17*2&&col<670+1100-jet_pos+17*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+17*2&&row<20+17*2+2&&col>=670+1100-jet_pos+17*2&&col<670+1100-jet_pos+17*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+18*2&&row<20+18*2+2&&col>=670+1100-jet_pos+17*2&&col<670+1100-jet_pos+17*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+24*2&&row<20+24*2+2&&col>=670+1100-jet_pos+17*2&&col<670+1100-jet_pos+17*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+25*2&&row<20+25*2+2&&col>=670+1100-jet_pos+17*2&&col<670+1100-jet_pos+17*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+26*2&&row<20+26*2+2&&col>=670+1100-jet_pos+17*2&&col<670+1100-jet_pos+17*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+27*2&&row<20+27*2+2&&col>=670+1100-jet_pos+17*2&&col<670+1100-jet_pos+17*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+28*2&&row<20+28*2+2&&col>=670+1100-jet_pos+17*2&&col<670+1100-jet_pos+17*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+4*2&&row<20+4*2+2&&col>=670+1100-jet_pos+18*2&&col<670+1100-jet_pos+18*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+5*2&&row<20+5*2+2&&col>=670+1100-jet_pos+18*2&&col<670+1100-jet_pos+18*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+6*2&&row<20+6*2+2&&col>=670+1100-jet_pos+18*2&&col<670+1100-jet_pos+18*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+14*2&&row<20+14*2+2&&col>=670+1100-jet_pos+18*2&&col<670+1100-jet_pos+18*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+15*2&&row<20+15*2+2&&col>=670+1100-jet_pos+18*2&&col<670+1100-jet_pos+18*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+16*2&&row<20+16*2+2&&col>=670+1100-jet_pos+18*2&&col<670+1100-jet_pos+18*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+17*2&&row<20+17*2+2&&col>=670+1100-jet_pos+18*2&&col<670+1100-jet_pos+18*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+18*2&&row<20+18*2+2&&col>=670+1100-jet_pos+18*2&&col<670+1100-jet_pos+18*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+26*2&&row<20+26*2+2&&col>=670+1100-jet_pos+18*2&&col<670+1100-jet_pos+18*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+27*2&&row<20+27*2+2&&col>=670+1100-jet_pos+18*2&&col<670+1100-jet_pos+18*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+28*2&&row<20+28*2+2&&col>=670+1100-jet_pos+18*2&&col<670+1100-jet_pos+18*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+14*2&&row<20+14*2+2&&col>=670+1100-jet_pos+19*2&&col<670+1100-jet_pos+19*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+15*2&&row<20+15*2+2&&col>=670+1100-jet_pos+19*2&&col<670+1100-jet_pos+19*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+16*2&&row<20+16*2+2&&col>=670+1100-jet_pos+19*2&&col<670+1100-jet_pos+19*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+17*2&&row<20+17*2+2&&col>=670+1100-jet_pos+19*2&&col<670+1100-jet_pos+19*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+18*2&&row<20+18*2+2&&col>=670+1100-jet_pos+19*2&&col<670+1100-jet_pos+19*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+14*2&&row<20+14*2+2&&col>=670+1100-jet_pos+20*2&&col<670+1100-jet_pos+20*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+15*2&&row<20+15*2+2&&col>=670+1100-jet_pos+20*2&&col<670+1100-jet_pos+20*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+16*2&&row<20+16*2+2&&col>=670+1100-jet_pos+20*2&&col<670+1100-jet_pos+20*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+17*2&&row<20+17*2+2&&col>=670+1100-jet_pos+20*2&&col<670+1100-jet_pos+20*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+18*2&&row<20+18*2+2&&col>=670+1100-jet_pos+20*2&&col<670+1100-jet_pos+20*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+13*2&&row<20+13*2+2&&col>=670+1100-jet_pos+21*2&&col<670+1100-jet_pos+21*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+14*2&&row<20+14*2+2&&col>=670+1100-jet_pos+21*2&&col<670+1100-jet_pos+21*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+15*2&&row<20+15*2+2&&col>=670+1100-jet_pos+21*2&&col<670+1100-jet_pos+21*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+16*2&&row<20+16*2+2&&col>=670+1100-jet_pos+21*2&&col<670+1100-jet_pos+21*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+17*2&&row<20+17*2+2&&col>=670+1100-jet_pos+21*2&&col<670+1100-jet_pos+21*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+18*2&&row<20+18*2+2&&col>=670+1100-jet_pos+21*2&&col<670+1100-jet_pos+21*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+19*2&&row<20+19*2+2&&col>=670+1100-jet_pos+21*2&&col<670+1100-jet_pos+21*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+12*2&&row<20+12*2+2&&col>=670+1100-jet_pos+22*2&&col<670+1100-jet_pos+22*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+13*2&&row<20+13*2+2&&col>=670+1100-jet_pos+22*2&&col<670+1100-jet_pos+22*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+14*2&&row<20+14*2+2&&col>=670+1100-jet_pos+22*2&&col<670+1100-jet_pos+22*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+15*2&&row<20+15*2+2&&col>=670+1100-jet_pos+22*2&&col<670+1100-jet_pos+22*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+16*2&&row<20+16*2+2&&col>=670+1100-jet_pos+22*2&&col<670+1100-jet_pos+22*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+17*2&&row<20+17*2+2&&col>=670+1100-jet_pos+22*2&&col<670+1100-jet_pos+22*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+18*2&&row<20+18*2+2&&col>=670+1100-jet_pos+22*2&&col<670+1100-jet_pos+22*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+19*2&&row<20+19*2+2&&col>=670+1100-jet_pos+22*2&&col<670+1100-jet_pos+22*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+20*2&&row<20+20*2+2&&col>=670+1100-jet_pos+22*2&&col<670+1100-jet_pos+22*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+11*2&&row<20+11*2+2&&col>=670+1100-jet_pos+23*2&&col<670+1100-jet_pos+23*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+12*2&&row<20+12*2+2&&col>=670+1100-jet_pos+23*2&&col<670+1100-jet_pos+23*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+13*2&&row<20+13*2+2&&col>=670+1100-jet_pos+23*2&&col<670+1100-jet_pos+23*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+14*2&&row<20+14*2+2&&col>=670+1100-jet_pos+23*2&&col<670+1100-jet_pos+23*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+15*2&&row<20+15*2+2&&col>=670+1100-jet_pos+23*2&&col<670+1100-jet_pos+23*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+16*2&&row<20+16*2+2&&col>=670+1100-jet_pos+23*2&&col<670+1100-jet_pos+23*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+17*2&&row<20+17*2+2&&col>=670+1100-jet_pos+23*2&&col<670+1100-jet_pos+23*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+18*2&&row<20+18*2+2&&col>=670+1100-jet_pos+23*2&&col<670+1100-jet_pos+23*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+19*2&&row<20+19*2+2&&col>=670+1100-jet_pos+23*2&&col<670+1100-jet_pos+23*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+20*2&&row<20+20*2+2&&col>=670+1100-jet_pos+23*2&&col<670+1100-jet_pos+23*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+21*2&&row<20+21*2+2&&col>=670+1100-jet_pos+23*2&&col<670+1100-jet_pos+23*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+9*2&&row<20+9*2+2&&col>=670+1100-jet_pos+24*2&&col<670+1100-jet_pos+24*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+10*2&&row<20+10*2+2&&col>=670+1100-jet_pos+24*2&&col<670+1100-jet_pos+24*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+11*2&&row<20+11*2+2&&col>=670+1100-jet_pos+24*2&&col<670+1100-jet_pos+24*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+12*2&&row<20+12*2+2&&col>=670+1100-jet_pos+24*2&&col<670+1100-jet_pos+24*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+13*2&&row<20+13*2+2&&col>=670+1100-jet_pos+24*2&&col<670+1100-jet_pos+24*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+14*2&&row<20+14*2+2&&col>=670+1100-jet_pos+24*2&&col<670+1100-jet_pos+24*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+15*2&&row<20+15*2+2&&col>=670+1100-jet_pos+24*2&&col<670+1100-jet_pos+24*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+16*2&&row<20+16*2+2&&col>=670+1100-jet_pos+24*2&&col<670+1100-jet_pos+24*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+17*2&&row<20+17*2+2&&col>=670+1100-jet_pos+24*2&&col<670+1100-jet_pos+24*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+18*2&&row<20+18*2+2&&col>=670+1100-jet_pos+24*2&&col<670+1100-jet_pos+24*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+19*2&&row<20+19*2+2&&col>=670+1100-jet_pos+24*2&&col<670+1100-jet_pos+24*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+20*2&&row<20+20*2+2&&col>=670+1100-jet_pos+24*2&&col<670+1100-jet_pos+24*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+21*2&&row<20+21*2+2&&col>=670+1100-jet_pos+24*2&&col<670+1100-jet_pos+24*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+22*2&&row<20+22*2+2&&col>=670+1100-jet_pos+24*2&&col<670+1100-jet_pos+24*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+23*2&&row<20+23*2+2&&col>=670+1100-jet_pos+24*2&&col<670+1100-jet_pos+24*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+9*2&&row<20+9*2+2&&col>=670+1100-jet_pos+25*2&&col<670+1100-jet_pos+25*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+10*2&&row<20+10*2+2&&col>=670+1100-jet_pos+25*2&&col<670+1100-jet_pos+25*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+11*2&&row<20+11*2+2&&col>=670+1100-jet_pos+25*2&&col<670+1100-jet_pos+25*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+12*2&&row<20+12*2+2&&col>=670+1100-jet_pos+25*2&&col<670+1100-jet_pos+25*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+14*2&&row<20+14*2+2&&col>=670+1100-jet_pos+25*2&&col<670+1100-jet_pos+25*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+15*2&&row<20+15*2+2&&col>=670+1100-jet_pos+25*2&&col<670+1100-jet_pos+25*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+16*2&&row<20+16*2+2&&col>=670+1100-jet_pos+25*2&&col<670+1100-jet_pos+25*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+17*2&&row<20+17*2+2&&col>=670+1100-jet_pos+25*2&&col<670+1100-jet_pos+25*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+18*2&&row<20+18*2+2&&col>=670+1100-jet_pos+25*2&&col<670+1100-jet_pos+25*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+20*2&&row<20+20*2+2&&col>=670+1100-jet_pos+25*2&&col<670+1100-jet_pos+25*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+21*2&&row<20+21*2+2&&col>=670+1100-jet_pos+25*2&&col<670+1100-jet_pos+25*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+22*2&&row<20+22*2+2&&col>=670+1100-jet_pos+25*2&&col<670+1100-jet_pos+25*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+23*2&&row<20+23*2+2&&col>=670+1100-jet_pos+25*2&&col<670+1100-jet_pos+25*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+9*2&&row<20+9*2+2&&col>=670+1100-jet_pos+26*2&&col<670+1100-jet_pos+26*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+10*2&&row<20+10*2+2&&col>=670+1100-jet_pos+26*2&&col<670+1100-jet_pos+26*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+15*2&&row<20+15*2+2&&col>=670+1100-jet_pos+26*2&&col<670+1100-jet_pos+26*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+16*2&&row<20+16*2+2&&col>=670+1100-jet_pos+26*2&&col<670+1100-jet_pos+26*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+17*2&&row<20+17*2+2&&col>=670+1100-jet_pos+26*2&&col<670+1100-jet_pos+26*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+22*2&&row<20+22*2+2&&col>=670+1100-jet_pos+26*2&&col<670+1100-jet_pos+26*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+23*2&&row<20+23*2+2&&col>=670+1100-jet_pos+26*2&&col<670+1100-jet_pos+26*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+15*2&&row<20+15*2+2&&col>=670+1100-jet_pos+27*2&&col<670+1100-jet_pos+27*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+16*2&&row<20+16*2+2&&col>=670+1100-jet_pos+27*2&&col<670+1100-jet_pos+27*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+17*2&&row<20+17*2+2&&col>=670+1100-jet_pos+27*2&&col<670+1100-jet_pos+27*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1100&&jet_pos<=1700&&row>=20+16*2&&row<20+16*2+2&&col>=670+1100-jet_pos+28*2&&col<670+1100-jet_pos+28*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+11*2&&row<20+jet_pos-1700+11*2+2&&col>=70+4*2&&col<70+4*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+12*2&&row<20+jet_pos-1700+12*2+2&&col>=70+4*2&&col<70+4*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+13*2&&row<20+jet_pos-1700+13*2+2&&col>=70+4*2&&col<70+4*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+11*2&&row<20+jet_pos-1700+11*2+2&&col>=70+5*2&&col<70+5*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+12*2&&row<20+jet_pos-1700+12*2+2&&col>=70+5*2&&col<70+5*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+13*2&&row<20+jet_pos-1700+13*2+2&&col>=70+5*2&&col<70+5*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+14*2&&row<20+jet_pos-1700+14*2+2&&col>=70+5*2&&col<70+5*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+11*2&&row<20+jet_pos-1700+11*2+2&&col>=70+6*2&&col<70+6*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+12*2&&row<20+jet_pos-1700+12*2+2&&col>=70+6*2&&col<70+6*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+13*2&&row<20+jet_pos-1700+13*2+2&&col>=70+6*2&&col<70+6*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+14*2&&row<20+jet_pos-1700+14*2+2&&col>=70+6*2&&col<70+6*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+15*2&&row<20+jet_pos-1700+15*2+2&&col>=70+6*2&&col<70+6*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+12*2&&row<20+jet_pos-1700+12*2+2&&col>=70+7*2&&col<70+7*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+13*2&&row<20+jet_pos-1700+13*2+2&&col>=70+7*2&&col<70+7*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+14*2&&row<20+jet_pos-1700+14*2+2&&col>=70+7*2&&col<70+7*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+15*2&&row<20+jet_pos-1700+15*2+2&&col>=70+7*2&&col<70+7*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+16*2&&row<20+jet_pos-1700+16*2+2&&col>=70+7*2&&col<70+7*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+12*2&&row<20+jet_pos-1700+12*2+2&&col>=70+8*2&&col<70+8*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+13*2&&row<20+jet_pos-1700+13*2+2&&col>=70+8*2&&col<70+8*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+14*2&&row<20+jet_pos-1700+14*2+2&&col>=70+8*2&&col<70+8*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+15*2&&row<20+jet_pos-1700+15*2+2&&col>=70+8*2&&col<70+8*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+16*2&&row<20+jet_pos-1700+16*2+2&&col>=70+8*2&&col<70+8*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+3*2&&row<20+jet_pos-1700+3*2+2&&col>=70+9*2&&col<70+9*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+4*2&&row<20+jet_pos-1700+4*2+2&&col>=70+9*2&&col<70+9*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+5*2&&row<20+jet_pos-1700+5*2+2&&col>=70+9*2&&col<70+9*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+13*2&&row<20+jet_pos-1700+13*2+2&&col>=70+9*2&&col<70+9*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+14*2&&row<20+jet_pos-1700+14*2+2&&col>=70+9*2&&col<70+9*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+15*2&&row<20+jet_pos-1700+15*2+2&&col>=70+9*2&&col<70+9*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+16*2&&row<20+jet_pos-1700+16*2+2&&col>=70+9*2&&col<70+9*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+17*2&&row<20+jet_pos-1700+17*2+2&&col>=70+9*2&&col<70+9*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+3*2&&row<20+jet_pos-1700+3*2+2&&col>=70+10*2&&col<70+10*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+4*2&&row<20+jet_pos-1700+4*2+2&&col>=70+10*2&&col<70+10*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+5*2&&row<20+jet_pos-1700+5*2+2&&col>=70+10*2&&col<70+10*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+13*2&&row<20+jet_pos-1700+13*2+2&&col>=70+10*2&&col<70+10*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+14*2&&row<20+jet_pos-1700+14*2+2&&col>=70+10*2&&col<70+10*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+15*2&&row<20+jet_pos-1700+15*2+2&&col>=70+10*2&&col<70+10*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+16*2&&row<20+jet_pos-1700+16*2+2&&col>=70+10*2&&col<70+10*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+17*2&&row<20+jet_pos-1700+17*2+2&&col>=70+10*2&&col<70+10*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+4*2&&row<20+jet_pos-1700+4*2+2&&col>=70+11*2&&col<70+11*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+5*2&&row<20+jet_pos-1700+5*2+2&&col>=70+11*2&&col<70+11*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+6*2&&row<20+jet_pos-1700+6*2+2&&col>=70+11*2&&col<70+11*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+14*2&&row<20+jet_pos-1700+14*2+2&&col>=70+11*2&&col<70+11*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+15*2&&row<20+jet_pos-1700+15*2+2&&col>=70+11*2&&col<70+11*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+16*2&&row<20+jet_pos-1700+16*2+2&&col>=70+11*2&&col<70+11*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+17*2&&row<20+jet_pos-1700+17*2+2&&col>=70+11*2&&col<70+11*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+18*2&&row<20+jet_pos-1700+18*2+2&&col>=70+11*2&&col<70+11*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+4*2&&row<20+jet_pos-1700+4*2+2&&col>=70+12*2&&col<70+12*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+5*2&&row<20+jet_pos-1700+5*2+2&&col>=70+12*2&&col<70+12*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+6*2&&row<20+jet_pos-1700+6*2+2&&col>=70+12*2&&col<70+12*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+7*2&&row<20+jet_pos-1700+7*2+2&&col>=70+12*2&&col<70+12*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+14*2&&row<20+jet_pos-1700+14*2+2&&col>=70+12*2&&col<70+12*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+15*2&&row<20+jet_pos-1700+15*2+2&&col>=70+12*2&&col<70+12*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+16*2&&row<20+jet_pos-1700+16*2+2&&col>=70+12*2&&col<70+12*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+17*2&&row<20+jet_pos-1700+17*2+2&&col>=70+12*2&&col<70+12*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+18*2&&row<20+jet_pos-1700+18*2+2&&col>=70+12*2&&col<70+12*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+5*2&&row<20+jet_pos-1700+5*2+2&&col>=70+13*2&&col<70+13*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+6*2&&row<20+jet_pos-1700+6*2+2&&col>=70+13*2&&col<70+13*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+7*2&&row<20+jet_pos-1700+7*2+2&&col>=70+13*2&&col<70+13*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+8*2&&row<20+jet_pos-1700+8*2+2&&col>=70+13*2&&col<70+13*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+15*2&&row<20+jet_pos-1700+15*2+2&&col>=70+13*2&&col<70+13*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+16*2&&row<20+jet_pos-1700+16*2+2&&col>=70+13*2&&col<70+13*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+17*2&&row<20+jet_pos-1700+17*2+2&&col>=70+13*2&&col<70+13*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+18*2&&row<20+jet_pos-1700+18*2+2&&col>=70+13*2&&col<70+13*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+19*2&&row<20+jet_pos-1700+19*2+2&&col>=70+13*2&&col<70+13*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+4*2&&row<20+jet_pos-1700+4*2+2&&col>=70+14*2&&col<70+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+5*2&&row<20+jet_pos-1700+5*2+2&&col>=70+14*2&&col<70+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+6*2&&row<20+jet_pos-1700+6*2+2&&col>=70+14*2&&col<70+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+7*2&&row<20+jet_pos-1700+7*2+2&&col>=70+14*2&&col<70+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+8*2&&row<20+jet_pos-1700+8*2+2&&col>=70+14*2&&col<70+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+9*2&&row<20+jet_pos-1700+9*2+2&&col>=70+14*2&&col<70+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+10*2&&row<20+jet_pos-1700+10*2+2&&col>=70+14*2&&col<70+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+11*2&&row<20+jet_pos-1700+11*2+2&&col>=70+14*2&&col<70+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+12*2&&row<20+jet_pos-1700+12*2+2&&col>=70+14*2&&col<70+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+13*2&&row<20+jet_pos-1700+13*2+2&&col>=70+14*2&&col<70+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+14*2&&row<20+jet_pos-1700+14*2+2&&col>=70+14*2&&col<70+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+15*2&&row<20+jet_pos-1700+15*2+2&&col>=70+14*2&&col<70+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+16*2&&row<20+jet_pos-1700+16*2+2&&col>=70+14*2&&col<70+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+17*2&&row<20+jet_pos-1700+17*2+2&&col>=70+14*2&&col<70+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+18*2&&row<20+jet_pos-1700+18*2+2&&col>=70+14*2&&col<70+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+19*2&&row<20+jet_pos-1700+19*2+2&&col>=70+14*2&&col<70+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+20*2&&row<20+jet_pos-1700+20*2+2&&col>=70+14*2&&col<70+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+21*2&&row<20+jet_pos-1700+21*2+2&&col>=70+14*2&&col<70+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+22*2&&row<20+jet_pos-1700+22*2+2&&col>=70+14*2&&col<70+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+23*2&&row<20+jet_pos-1700+23*2+2&&col>=70+14*2&&col<70+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+24*2&&row<20+jet_pos-1700+24*2+2&&col>=70+14*2&&col<70+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+25*2&&row<20+jet_pos-1700+25*2+2&&col>=70+14*2&&col<70+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+26*2&&row<20+jet_pos-1700+26*2+2&&col>=70+14*2&&col<70+14*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+2*2&&row<20+jet_pos-1700+2*2+2&&col>=70+15*2&&col<70+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+3*2&&row<20+jet_pos-1700+3*2+2&&col>=70+15*2&&col<70+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+4*2&&row<20+jet_pos-1700+4*2+2&&col>=70+15*2&&col<70+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+5*2&&row<20+jet_pos-1700+5*2+2&&col>=70+15*2&&col<70+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+6*2&&row<20+jet_pos-1700+6*2+2&&col>=70+15*2&&col<70+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+7*2&&row<20+jet_pos-1700+7*2+2&&col>=70+15*2&&col<70+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+8*2&&row<20+jet_pos-1700+8*2+2&&col>=70+15*2&&col<70+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+9*2&&row<20+jet_pos-1700+9*2+2&&col>=70+15*2&&col<70+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+10*2&&row<20+jet_pos-1700+10*2+2&&col>=70+15*2&&col<70+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+11*2&&row<20+jet_pos-1700+11*2+2&&col>=70+15*2&&col<70+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+12*2&&row<20+jet_pos-1700+12*2+2&&col>=70+15*2&&col<70+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+13*2&&row<20+jet_pos-1700+13*2+2&&col>=70+15*2&&col<70+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+14*2&&row<20+jet_pos-1700+14*2+2&&col>=70+15*2&&col<70+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+15*2&&row<20+jet_pos-1700+15*2+2&&col>=70+15*2&&col<70+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+16*2&&row<20+jet_pos-1700+16*2+2&&col>=70+15*2&&col<70+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+17*2&&row<20+jet_pos-1700+17*2+2&&col>=70+15*2&&col<70+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+18*2&&row<20+jet_pos-1700+18*2+2&&col>=70+15*2&&col<70+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+19*2&&row<20+jet_pos-1700+19*2+2&&col>=70+15*2&&col<70+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+20*2&&row<20+jet_pos-1700+20*2+2&&col>=70+15*2&&col<70+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+21*2&&row<20+jet_pos-1700+21*2+2&&col>=70+15*2&&col<70+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+22*2&&row<20+jet_pos-1700+22*2+2&&col>=70+15*2&&col<70+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+23*2&&row<20+jet_pos-1700+23*2+2&&col>=70+15*2&&col<70+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+24*2&&row<20+jet_pos-1700+24*2+2&&col>=70+15*2&&col<70+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+25*2&&row<20+jet_pos-1700+25*2+2&&col>=70+15*2&&col<70+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+26*2&&row<20+jet_pos-1700+26*2+2&&col>=70+15*2&&col<70+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+27*2&&row<20+jet_pos-1700+27*2+2&&col>=70+15*2&&col<70+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+28*2&&row<20+jet_pos-1700+28*2+2&&col>=70+15*2&&col<70+15*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+1*2&&row<20+jet_pos-1700+1*2+2&&col>=70+16*2&&col<70+16*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+2*2&&row<20+jet_pos-1700+2*2+2&&col>=70+16*2&&col<70+16*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+3*2&&row<20+jet_pos-1700+3*2+2&&col>=70+16*2&&col<70+16*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+4*2&&row<20+jet_pos-1700+4*2+2&&col>=70+16*2&&col<70+16*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+5*2&&row<20+jet_pos-1700+5*2+2&&col>=70+16*2&&col<70+16*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+6*2&&row<20+jet_pos-1700+6*2+2&&col>=70+16*2&&col<70+16*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+7*2&&row<20+jet_pos-1700+7*2+2&&col>=70+16*2&&col<70+16*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+8*2&&row<20+jet_pos-1700+8*2+2&&col>=70+16*2&&col<70+16*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+9*2&&row<20+jet_pos-1700+9*2+2&&col>=70+16*2&&col<70+16*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+10*2&&row<20+jet_pos-1700+10*2+2&&col>=70+16*2&&col<70+16*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+11*2&&row<20+jet_pos-1700+11*2+2&&col>=70+16*2&&col<70+16*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+12*2&&row<20+jet_pos-1700+12*2+2&&col>=70+16*2&&col<70+16*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+13*2&&row<20+jet_pos-1700+13*2+2&&col>=70+16*2&&col<70+16*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+14*2&&row<20+jet_pos-1700+14*2+2&&col>=70+16*2&&col<70+16*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+15*2&&row<20+jet_pos-1700+15*2+2&&col>=70+16*2&&col<70+16*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+16*2&&row<20+jet_pos-1700+16*2+2&&col>=70+16*2&&col<70+16*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+17*2&&row<20+jet_pos-1700+17*2+2&&col>=70+16*2&&col<70+16*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+18*2&&row<20+jet_pos-1700+18*2+2&&col>=70+16*2&&col<70+16*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+19*2&&row<20+jet_pos-1700+19*2+2&&col>=70+16*2&&col<70+16*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+20*2&&row<20+jet_pos-1700+20*2+2&&col>=70+16*2&&col<70+16*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+21*2&&row<20+jet_pos-1700+21*2+2&&col>=70+16*2&&col<70+16*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+22*2&&row<20+jet_pos-1700+22*2+2&&col>=70+16*2&&col<70+16*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+23*2&&row<20+jet_pos-1700+23*2+2&&col>=70+16*2&&col<70+16*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+24*2&&row<20+jet_pos-1700+24*2+2&&col>=70+16*2&&col<70+16*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+25*2&&row<20+jet_pos-1700+25*2+2&&col>=70+16*2&&col<70+16*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+26*2&&row<20+jet_pos-1700+26*2+2&&col>=70+16*2&&col<70+16*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+27*2&&row<20+jet_pos-1700+27*2+2&&col>=70+16*2&&col<70+16*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+28*2&&row<20+jet_pos-1700+28*2+2&&col>=70+16*2&&col<70+16*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+2*2&&row<20+jet_pos-1700+2*2+2&&col>=70+17*2&&col<70+17*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+3*2&&row<20+jet_pos-1700+3*2+2&&col>=70+17*2&&col<70+17*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+4*2&&row<20+jet_pos-1700+4*2+2&&col>=70+17*2&&col<70+17*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+5*2&&row<20+jet_pos-1700+5*2+2&&col>=70+17*2&&col<70+17*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+6*2&&row<20+jet_pos-1700+6*2+2&&col>=70+17*2&&col<70+17*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+7*2&&row<20+jet_pos-1700+7*2+2&&col>=70+17*2&&col<70+17*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+8*2&&row<20+jet_pos-1700+8*2+2&&col>=70+17*2&&col<70+17*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+9*2&&row<20+jet_pos-1700+9*2+2&&col>=70+17*2&&col<70+17*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+10*2&&row<20+jet_pos-1700+10*2+2&&col>=70+17*2&&col<70+17*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+11*2&&row<20+jet_pos-1700+11*2+2&&col>=70+17*2&&col<70+17*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+12*2&&row<20+jet_pos-1700+12*2+2&&col>=70+17*2&&col<70+17*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+13*2&&row<20+jet_pos-1700+13*2+2&&col>=70+17*2&&col<70+17*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+14*2&&row<20+jet_pos-1700+14*2+2&&col>=70+17*2&&col<70+17*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+15*2&&row<20+jet_pos-1700+15*2+2&&col>=70+17*2&&col<70+17*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+16*2&&row<20+jet_pos-1700+16*2+2&&col>=70+17*2&&col<70+17*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+17*2&&row<20+jet_pos-1700+17*2+2&&col>=70+17*2&&col<70+17*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+18*2&&row<20+jet_pos-1700+18*2+2&&col>=70+17*2&&col<70+17*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+19*2&&row<20+jet_pos-1700+19*2+2&&col>=70+17*2&&col<70+17*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+20*2&&row<20+jet_pos-1700+20*2+2&&col>=70+17*2&&col<70+17*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+21*2&&row<20+jet_pos-1700+21*2+2&&col>=70+17*2&&col<70+17*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+22*2&&row<20+jet_pos-1700+22*2+2&&col>=70+17*2&&col<70+17*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+23*2&&row<20+jet_pos-1700+23*2+2&&col>=70+17*2&&col<70+17*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+24*2&&row<20+jet_pos-1700+24*2+2&&col>=70+17*2&&col<70+17*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+25*2&&row<20+jet_pos-1700+25*2+2&&col>=70+17*2&&col<70+17*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+26*2&&row<20+jet_pos-1700+26*2+2&&col>=70+17*2&&col<70+17*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+27*2&&row<20+jet_pos-1700+27*2+2&&col>=70+17*2&&col<70+17*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+28*2&&row<20+jet_pos-1700+28*2+2&&col>=70+17*2&&col<70+17*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+4*2&&row<20+jet_pos-1700+4*2+2&&col>=70+18*2&&col<70+18*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+5*2&&row<20+jet_pos-1700+5*2+2&&col>=70+18*2&&col<70+18*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+6*2&&row<20+jet_pos-1700+6*2+2&&col>=70+18*2&&col<70+18*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+7*2&&row<20+jet_pos-1700+7*2+2&&col>=70+18*2&&col<70+18*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+8*2&&row<20+jet_pos-1700+8*2+2&&col>=70+18*2&&col<70+18*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+9*2&&row<20+jet_pos-1700+9*2+2&&col>=70+18*2&&col<70+18*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+10*2&&row<20+jet_pos-1700+10*2+2&&col>=70+18*2&&col<70+18*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+11*2&&row<20+jet_pos-1700+11*2+2&&col>=70+18*2&&col<70+18*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+12*2&&row<20+jet_pos-1700+12*2+2&&col>=70+18*2&&col<70+18*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+13*2&&row<20+jet_pos-1700+13*2+2&&col>=70+18*2&&col<70+18*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+14*2&&row<20+jet_pos-1700+14*2+2&&col>=70+18*2&&col<70+18*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+15*2&&row<20+jet_pos-1700+15*2+2&&col>=70+18*2&&col<70+18*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+16*2&&row<20+jet_pos-1700+16*2+2&&col>=70+18*2&&col<70+18*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+17*2&&row<20+jet_pos-1700+17*2+2&&col>=70+18*2&&col<70+18*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+18*2&&row<20+jet_pos-1700+18*2+2&&col>=70+18*2&&col<70+18*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+19*2&&row<20+jet_pos-1700+19*2+2&&col>=70+18*2&&col<70+18*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+20*2&&row<20+jet_pos-1700+20*2+2&&col>=70+18*2&&col<70+18*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+21*2&&row<20+jet_pos-1700+21*2+2&&col>=70+18*2&&col<70+18*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+22*2&&row<20+jet_pos-1700+22*2+2&&col>=70+18*2&&col<70+18*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+23*2&&row<20+jet_pos-1700+23*2+2&&col>=70+18*2&&col<70+18*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+24*2&&row<20+jet_pos-1700+24*2+2&&col>=70+18*2&&col<70+18*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+25*2&&row<20+jet_pos-1700+25*2+2&&col>=70+18*2&&col<70+18*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+26*2&&row<20+jet_pos-1700+26*2+2&&col>=70+18*2&&col<70+18*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+5*2&&row<20+jet_pos-1700+5*2+2&&col>=70+19*2&&col<70+19*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+6*2&&row<20+jet_pos-1700+6*2+2&&col>=70+19*2&&col<70+19*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+7*2&&row<20+jet_pos-1700+7*2+2&&col>=70+19*2&&col<70+19*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+8*2&&row<20+jet_pos-1700+8*2+2&&col>=70+19*2&&col<70+19*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+15*2&&row<20+jet_pos-1700+15*2+2&&col>=70+19*2&&col<70+19*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+16*2&&row<20+jet_pos-1700+16*2+2&&col>=70+19*2&&col<70+19*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+17*2&&row<20+jet_pos-1700+17*2+2&&col>=70+19*2&&col<70+19*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+18*2&&row<20+jet_pos-1700+18*2+2&&col>=70+19*2&&col<70+19*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+19*2&&row<20+jet_pos-1700+19*2+2&&col>=70+19*2&&col<70+19*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+4*2&&row<20+jet_pos-1700+4*2+2&&col>=70+20*2&&col<70+20*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+5*2&&row<20+jet_pos-1700+5*2+2&&col>=70+20*2&&col<70+20*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+6*2&&row<20+jet_pos-1700+6*2+2&&col>=70+20*2&&col<70+20*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+7*2&&row<20+jet_pos-1700+7*2+2&&col>=70+20*2&&col<70+20*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+14*2&&row<20+jet_pos-1700+14*2+2&&col>=70+20*2&&col<70+20*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+15*2&&row<20+jet_pos-1700+15*2+2&&col>=70+20*2&&col<70+20*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+16*2&&row<20+jet_pos-1700+16*2+2&&col>=70+20*2&&col<70+20*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+17*2&&row<20+jet_pos-1700+17*2+2&&col>=70+20*2&&col<70+20*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+18*2&&row<20+jet_pos-1700+18*2+2&&col>=70+20*2&&col<70+20*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+4*2&&row<20+jet_pos-1700+4*2+2&&col>=70+21*2&&col<70+21*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+5*2&&row<20+jet_pos-1700+5*2+2&&col>=70+21*2&&col<70+21*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+6*2&&row<20+jet_pos-1700+6*2+2&&col>=70+21*2&&col<70+21*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+14*2&&row<20+jet_pos-1700+14*2+2&&col>=70+21*2&&col<70+21*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+15*2&&row<20+jet_pos-1700+15*2+2&&col>=70+21*2&&col<70+21*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+16*2&&row<20+jet_pos-1700+16*2+2&&col>=70+21*2&&col<70+21*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+17*2&&row<20+jet_pos-1700+17*2+2&&col>=70+21*2&&col<70+21*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+18*2&&row<20+jet_pos-1700+18*2+2&&col>=70+21*2&&col<70+21*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+3*2&&row<20+jet_pos-1700+3*2+2&&col>=70+22*2&&col<70+22*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+4*2&&row<20+jet_pos-1700+4*2+2&&col>=70+22*2&&col<70+22*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+5*2&&row<20+jet_pos-1700+5*2+2&&col>=70+22*2&&col<70+22*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+13*2&&row<20+jet_pos-1700+13*2+2&&col>=70+22*2&&col<70+22*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+14*2&&row<20+jet_pos-1700+14*2+2&&col>=70+22*2&&col<70+22*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+15*2&&row<20+jet_pos-1700+15*2+2&&col>=70+22*2&&col<70+22*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+16*2&&row<20+jet_pos-1700+16*2+2&&col>=70+22*2&&col<70+22*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+17*2&&row<20+jet_pos-1700+17*2+2&&col>=70+22*2&&col<70+22*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+3*2&&row<20+jet_pos-1700+3*2+2&&col>=70+23*2&&col<70+23*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+4*2&&row<20+jet_pos-1700+4*2+2&&col>=70+23*2&&col<70+23*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+5*2&&row<20+jet_pos-1700+5*2+2&&col>=70+23*2&&col<70+23*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+13*2&&row<20+jet_pos-1700+13*2+2&&col>=70+23*2&&col<70+23*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+14*2&&row<20+jet_pos-1700+14*2+2&&col>=70+23*2&&col<70+23*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+15*2&&row<20+jet_pos-1700+15*2+2&&col>=70+23*2&&col<70+23*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+16*2&&row<20+jet_pos-1700+16*2+2&&col>=70+23*2&&col<70+23*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+17*2&&row<20+jet_pos-1700+17*2+2&&col>=70+23*2&&col<70+23*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+12*2&&row<20+jet_pos-1700+12*2+2&&col>=70+24*2&&col<70+24*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+13*2&&row<20+jet_pos-1700+13*2+2&&col>=70+24*2&&col<70+24*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+14*2&&row<20+jet_pos-1700+14*2+2&&col>=70+24*2&&col<70+24*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+15*2&&row<20+jet_pos-1700+15*2+2&&col>=70+24*2&&col<70+24*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+16*2&&row<20+jet_pos-1700+16*2+2&&col>=70+24*2&&col<70+24*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+12*2&&row<20+jet_pos-1700+12*2+2&&col>=70+25*2&&col<70+25*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+13*2&&row<20+jet_pos-1700+13*2+2&&col>=70+25*2&&col<70+25*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+14*2&&row<20+jet_pos-1700+14*2+2&&col>=70+25*2&&col<70+25*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+15*2&&row<20+jet_pos-1700+15*2+2&&col>=70+25*2&&col<70+25*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+16*2&&row<20+jet_pos-1700+16*2+2&&col>=70+25*2&&col<70+25*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+11*2&&row<20+jet_pos-1700+11*2+2&&col>=70+26*2&&col<70+26*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+12*2&&row<20+jet_pos-1700+12*2+2&&col>=70+26*2&&col<70+26*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+13*2&&row<20+jet_pos-1700+13*2+2&&col>=70+26*2&&col<70+26*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+14*2&&row<20+jet_pos-1700+14*2+2&&col>=70+26*2&&col<70+26*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+15*2&&row<20+jet_pos-1700+15*2+2&&col>=70+26*2&&col<70+26*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+11*2&&row<20+jet_pos-1700+11*2+2&&col>=70+27*2&&col<70+27*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+12*2&&row<20+jet_pos-1700+12*2+2&&col>=70+27*2&&col<70+27*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+13*2&&row<20+jet_pos-1700+13*2+2&&col>=70+27*2&&col<70+27*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+14*2&&row<20+jet_pos-1700+14*2+2&&col>=70+27*2&&col<70+27*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+11*2&&row<20+jet_pos-1700+11*2+2&&col>=70+28*2&&col<70+28*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+12*2&&row<20+jet_pos-1700+12*2+2&&col>=70+28*2&&col<70+28*2+2) {red, green, blue} <= 3'b000;
			else if(jet_pos>1700&&jet_pos<=2200&&row>=20+jet_pos-1700+13*2&&row<20+jet_pos-1700+13*2+2&&col>=70+28*2&&col<70+28*2+2) {red, green, blue} <= 3'b000;
			else if(col >= 130 && col <= 130+40 && row >= 530 && row <= 530+40) {red, green, blue} <= 3'b100;
			else if(col >= 180 && col <= 180+40 && row >= 530 && row <= 530+40) {red, green, blue} <= 3'b010;
			else if(col >= 230 && col <= 230+40 && row >= 530 && row <= 530+40) {red, green, blue} <= 3'b001;
			else if(col >= 280 && col <= 280+40 && row >= 530 && row <= 530+40) {red, green, blue} <= 3'b110;
			else if(col >= 330 && col <= 330+40 && row >= 530 && row <= 530+40) {red, green, blue} <= 3'b101;
			else if(col >= 380 && col <= 380+40 && row >= 530 && row <= 530+40) {red, green, blue} <= 3'b011;
			else if(col >= 430 && col <= 430+40 && row >= 530 && row <= 530+40) begin
				if(col-430 > row-530) {red, green, blue} <= 3'b100;
				else {red, green, blue} <= 3'b010;
			end
			else if(col >= 480 && col <= 480+40 && row >= 530 && row <= 530+40) begin
				if(col-480 > row-530) {red, green, blue} <= 3'b010;
				else {red, green, blue} <= 3'b001;
			end
			else if(col >= 530 && col <= 530+40 && row >= 530 && row <= 530+40) begin
				if(col-530 > row-530) {red, green, blue} <= 3'b001;
				else {red, green, blue} <= 3'b100;
			end
			else if(col >= 580 && col <= 580+40 && row >= 530 && row <= 530+40) begin
				if(col-580 > row-530) {red, green, blue} <= 3'b110;
				else {red, green, blue} <= 3'b101;
			end
			else if(col >= 630 && col <= 630+40 && row >= 530 && row <= 530+40) begin
				if(col-630 > row-530) {red, green, blue} <= 3'b101;
				else {red, green, blue} <= 3'b011;
			end
			else if(row>=10+2*8&&row<10+2*8+8&&col>=315+3*8&&col<315+3*8+8) begin
				{red, green, blue} <= 3'b110;
			end
			else if(row>=10+3*8&&row<10+3*8+8&&col>=315+3*8&&col<315+3*8+8) begin
				{red, green, blue} <= 3'b110;
			end
			else if(row>=10+4*8&&row<10+4*8+8&&col>=315+3*8&&col<315+3*8+8) begin
				{red, green, blue} <= 3'b110;
			end
			else if(row>=10+5*8&&row<10+5*8+8&&col>=315+3*8&&col<315+3*8+8) begin
				{red, green, blue} <= 3'b110;
			end
			else if(row>=10+6*8&&row<10+6*8+8&&col>=315+3*8&&col<315+3*8+8) begin
				{red, green, blue} <= 3'b110;
			end
			else if(row>=10+7*8&&row<10+7*8+8&&col>=315+3*8&&col<315+3*8+8) begin
				{red, green, blue} <= 3'b110;
			end
			else if(row>=10+1*8&&row<10+1*8+8&&col>=315+4*8&&col<315+4*8+8) begin
				{red, green, blue} <= 3'b110;
			end
			else if(row>=10+8*8&&row<10+8*8+8&&col>=315+4*8&&col<315+4*8+8) begin
				{red, green, blue} <= 3'b110;
			end
			else if(row>=10+1*8&&row<10+1*8+8&&col>=315+5*8&&col<315+5*8+8) begin
				{red, green, blue} <= 3'b110;
			end
			else if(row>=10+8*8&&row<10+8*8+8&&col>=315+5*8&&col<315+5*8+8) begin
				{red, green, blue} <= 3'b110;
			end
			else if(row>=10+1*8&&row<10+1*8+8&&col>=315+6*8&&col<315+6*8+8) begin
				{red, green, blue} <= 3'b110;
			end
			else if(row>=10+8*8&&row<10+8*8+8&&col>=315+6*8&&col<315+6*8+8) begin
				{red, green, blue} <= 3'b110;
			end
			else if(row>=10+2*8&&row<10+2*8+8&&col>=315+7*8&&col<315+7*8+8) begin
				{red, green, blue} <= 3'b110;
			end
			else if(row>=10+3*8&&row<10+3*8+8&&col>=315+7*8&&col<315+7*8+8) begin
				{red, green, blue} <= 3'b110;
			end
			else if(row>=10+4*8&&row<10+4*8+8&&col>=315+7*8&&col<315+7*8+8) begin
				{red, green, blue} <= 3'b110;
			end
			else if(row>=10+5*8&&row<10+5*8+8&&col>=315+7*8&&col<315+7*8+8) begin
				{red, green, blue} <= 3'b110;
			end
			else if(row>=10+6*8&&row<10+6*8+8&&col>=315+7*8&&col<315+7*8+8) begin
				{red, green, blue} <= 3'b110;
			end
			else if(row>=10+7*8&&row<10+7*8+8&&col>=315+7*8&&col<315+7*8+8) begin
				{red, green, blue} <= 3'b110;
			end
			else if(row>=10+3*8&&row<10+3*8+8&&col>=225+2*8&&col<225+2*8+8) begin
				{red, green, blue} <= 3'b001;
			end
			else if(row>=10+7*8&&row<10+7*8+8&&col>=225+2*8&&col<225+2*8+8) begin
				{red, green, blue} <= 3'b001;
			end
			else if(row>=10+1*8&&row<10+1*8+8&&col>=225+3*8&&col<225+3*8+8) begin
				{red, green, blue} <= 3'b001;
			end
			else if(row>=10+2*8&&row<10+2*8+8&&col>=225+3*8&&col<225+3*8+8) begin
				{red, green, blue} <= 3'b001;
			end
			else if(row>=10+6*8&&row<10+6*8+8&&col>=225+3*8&&col<225+3*8+8) begin
				{red, green, blue} <= 3'b001;
			end
			else if(row>=10+7*8&&row<10+7*8+8&&col>=225+3*8&&col<225+3*8+8) begin
				{red, green, blue} <= 3'b001;
			end
			else if(row>=10+1*8&&row<10+1*8+8&&col>=225+4*8&&col<225+4*8+8) begin
				{red, green, blue} <= 3'b001;
			end
			else if(row>=10+5*8&&row<10+5*8+8&&col>=225+4*8&&col<225+4*8+8) begin
				{red, green, blue} <= 3'b001;
			end
			else if(row>=10+7*8&&row<10+7*8+8&&col>=225+4*8&&col<225+4*8+8) begin
				{red, green, blue} <= 3'b001;
			end
			else if(row>=10+1*8&&row<10+1*8+8&&col>=225+5*8&&col<225+5*8+8) begin
				{red, green, blue} <= 3'b001;
			end
			else if(row>=10+2*8&&row<10+2*8+8&&col>=225+5*8&&col<225+5*8+8) begin
				{red, green, blue} <= 3'b001;
			end
			else if(row>=10+5*8&&row<10+5*8+8&&col>=225+5*8&&col<225+5*8+8) begin
				{red, green, blue} <= 3'b001;
			end
			else if(row>=10+7*8&&row<10+7*8+8&&col>=225+5*8&&col<225+5*8+8) begin
				{red, green, blue} <= 3'b001;
			end
			else if(row>=10+3*8&&row<10+3*8+8&&col>=225+6*8&&col<225+6*8+8) begin
				{red, green, blue} <= 3'b001;
			end
			else if(row>=10+4*8&&row<10+4*8+8&&col>=225+6*8&&col<225+6*8+8) begin
				{red, green, blue} <= 3'b001;
			end
			else if(row>=10+7*8&&row<10+7*8+8&&col>=225+6*8&&col<225+6*8+8) begin
				{red, green, blue} <= 3'b001;
			end
			else if(row>=10+7*8&&row<10+7*8+8&&col>=225+7*8&&col<225+7*8+8) begin
				{red, green, blue} <= 3'b001;
			end
			else if(row>=10+7*8&&row<10+7*8+8&&col>=225+8*8&&col<225+8*8+8) begin
				{red, green, blue} <= 3'b001;
			end
			else if(row>=10+5*8&&row<10+5*8+8&&col>=405+0*8&&col<405+0*8+8) begin
				{red, green, blue} <= 3'b101;
			end
			else if(row>=10+4*8&&row<10+4*8+8&&col>=405+1*8&&col<405+1*8+8) begin
				{red, green, blue} <= 3'b101;
			end
			else if(row>=10+5*8&&row<10+5*8+8&&col>=405+1*8&&col<405+1*8+8) begin
				{red, green, blue} <= 3'b101;
			end
			else if(row>=10+3*8&&row<10+3*8+8&&col>=405+2*8&&col<405+2*8+8) begin
				{red, green, blue} <= 3'b101;
			end
			else if(row>=10+4*8&&row<10+4*8+8&&col>=405+2*8&&col<405+2*8+8) begin
				{red, green, blue} <= 3'b101;
			end
			else if(row>=10+5*8&&row<10+5*8+8&&col>=405+2*8&&col<405+2*8+8) begin
				{red, green, blue} <= 3'b101;
			end
			else if(row>=10+1*8&&row<10+1*8+8&&col>=405+3*8&&col<405+3*8+8) begin
				{red, green, blue} <= 3'b101;
			end
			else if(row>=10+2*8&&row<10+2*8+8&&col>=405+3*8&&col<405+3*8+8) begin
				{red, green, blue} <= 3'b101;
			end
			else if(row>=10+3*8&&row<10+3*8+8&&col>=405+3*8&&col<405+3*8+8) begin
				{red, green, blue} <= 3'b101;
			end
			else if(row>=10+5*8&&row<10+5*8+8&&col>=405+3*8&&col<405+3*8+8) begin
				{red, green, blue} <= 3'b101;
			end
			else if(row>=10+5*8&&row<10+5*8+8&&col>=405+4*8&&col<405+4*8+8) begin
				{red, green, blue} <= 3'b101;
			end
			else if(row>=10+5*8&&row<10+5*8+8&&col>=405+5*8&&col<405+5*8+8) begin
				{red, green, blue} <= 3'b101;
			end
			else if(row>=10+2*8&&row<10+2*8+8&&col>=405+6*8&&col<405+6*8+8) begin
				{red, green, blue} <= 3'b101;
			end
			else if(row>=10+3*8&&row<10+3*8+8&&col>=405+6*8&&col<405+6*8+8) begin
				{red, green, blue} <= 3'b101;
			end
			else if(row>=10+4*8&&row<10+4*8+8&&col>=405+6*8&&col<405+6*8+8) begin
				{red, green, blue} <= 3'b101;
			end
			else if(row>=10+5*8&&row<10+5*8+8&&col>=405+6*8&&col<405+6*8+8) begin
				{red, green, blue} <= 3'b101;
			end
			else if(row>=10+6*8&&row<10+6*8+8&&col>=405+6*8&&col<405+6*8+8) begin
				{red, green, blue} <= 3'b101;
			end
			else if(row>=10+7*8&&row<10+7*8+8&&col>=405+6*8&&col<405+6*8+8) begin
				{red, green, blue} <= 3'b101;
			end
			else if(row>=10+8*8&&row<10+8*8+8&&col>=405+6*8&&col<405+6*8+8) begin
				{red, green, blue} <= 3'b101;
			end
			else if(row>=10+5*8&&row<10+5*8+8&&col>=405+7*8&&col<405+7*8+8) begin
				{red, green, blue} <= 3'b101;
			end
			else if(row>=10+5*8&&row<10+5*8+8&&col>=405+8*8&&col<405+8*8+8) begin
				{red, green, blue} <= 3'b101;
			end
			else if(row>=10+2*8&&row<10+2*8+8&&col>=495+2*8&&col<495+2*8+8) begin
				{red, green, blue} <= 3'b011;
			end
			else if(row>=10+3*8&&row<10+3*8+8&&col>=495+2*8&&col<495+2*8+8) begin
				{red, green, blue} <= 3'b011;
			end
			else if(row>=10+5*8&&row<10+5*8+8&&col>=495+2*8&&col<495+2*8+8) begin
				{red, green, blue} <= 3'b011;
			end
			else if(row>=10+6*8&&row<10+6*8+8&&col>=495+2*8&&col<495+2*8+8) begin
				{red, green, blue} <= 3'b011;
			end
			else if(row>=10+7*8&&row<10+7*8+8&&col>=495+2*8&&col<495+2*8+8) begin
				{red, green, blue} <= 3'b011;
			end
			else if(row>=10+1*8&&row<10+1*8+8&&col>=495+3*8&&col<495+3*8+8) begin
				{red, green, blue} <= 3'b011;
			end
			else if(row>=10+4*8&&row<10+4*8+8&&col>=495+3*8&&col<495+3*8+8) begin
				{red, green, blue} <= 3'b011;
			end
			else if(row>=10+8*8&&row<10+8*8+8&&col>=495+3*8&&col<495+3*8+8) begin
				{red, green, blue} <= 3'b011;
			end
			else if(row>=10+1*8&&row<10+1*8+8&&col>=495+4*8&&col<495+4*8+8) begin
				{red, green, blue} <= 3'b011;
			end
			else if(row>=10+4*8&&row<10+4*8+8&&col>=495+4*8&&col<495+4*8+8) begin
				{red, green, blue} <= 3'b011;
			end
			else if(row>=10+8*8&&row<10+8*8+8&&col>=495+4*8&&col<495+4*8+8) begin
				{red, green, blue} <= 3'b011;
			end
			else if(row>=10+1*8&&row<10+1*8+8&&col>=495+5*8&&col<495+5*8+8) begin
				{red, green, blue} <= 3'b011;
			end
			else if(row>=10+4*8&&row<10+4*8+8&&col>=495+5*8&&col<495+5*8+8) begin
				{red, green, blue} <= 3'b011;
			end
			else if(row>=10+8*8&&row<10+8*8+8&&col>=495+5*8&&col<495+5*8+8) begin
				{red, green, blue} <= 3'b011;
			end
			else if(row>=10+2*8&&row<10+2*8+8&&col>=495+6*8&&col<495+6*8+8) begin
				{red, green, blue} <= 3'b011;
			end
			else if(row>=10+3*8&&row<10+3*8+8&&col>=495+6*8&&col<495+6*8+8) begin
				{red, green, blue} <= 3'b011;
			end
			else if(row>=10+5*8&&row<10+5*8+8&&col>=495+6*8&&col<495+6*8+8) begin
				{red, green, blue} <= 3'b011;
			end
			else if(row>=10+6*8&&row<10+6*8+8&&col>=495+6*8&&col<495+6*8+8) begin
				{red, green, blue} <= 3'b011;
			end
			else if(row>=10+7*8&&row<10+7*8+8&&col>=495+6*8&&col<495+6*8+8) begin
				{red, green, blue} <= 3'b011;
			end
			else if(endflag == 2'd1) {red, green, blue} <= 3'b100;
			else if(endflag == 2'd2) {red, green, blue} <= 3'b010;
			else {red, green, blue} <= 3'b111;
		end
	end
	
	always @(posedge CLK or negedge RST) begin
		if(!RST) begin
			
		end
		else begin
			if((to_left[4'd0]>0||to_right[4'd0]>0||to_up[4'd0]>0||to_down[4'd0]>0)
			&& col >= CELL_SIZE*2+BORDER_WIDTH-moveflag_2*to_left[4'd0]*movecounter+moveflag_2*to_right[4'd0]*movecounter
			&& col <= CELL_SIZE*3-BORDER_WIDTH-moveflag_2*to_left[4'd0]*movecounter+moveflag_2*to_right[4'd0]*movecounter
			&& row >= CELL_SIZE*1+BORDER_WIDTH-moveflag_2*to_up[4'd0]*movecounter+moveflag_2*to_down[4'd0]*movecounter
			&& row <= CELL_SIZE*2-BORDER_WIDTH-moveflag_2*to_up[4'd0]*movecounter+moveflag_2*to_down[4'd0]*movecounter) cell_index <= 4'd0;
			else if((to_left[4'd1]>0||to_right[4'd1]>0||to_up[4'd1]>0||to_down[4'd1]>0)
			&& col >= CELL_SIZE*2+BORDER_WIDTH-moveflag_2*to_left[4'd1]*movecounter+moveflag_2*to_right[4'd1]*movecounter
			&& col <= CELL_SIZE*3-BORDER_WIDTH-moveflag_2*to_left[4'd1]*movecounter+moveflag_2*to_right[4'd1]*movecounter
			&& row >= CELL_SIZE*2+BORDER_WIDTH-moveflag_2*to_up[4'd1]*movecounter+moveflag_2*to_down[4'd1]*movecounter
			&& row <= CELL_SIZE*3-BORDER_WIDTH-moveflag_2*to_up[4'd1]*movecounter+moveflag_2*to_down[4'd1]*movecounter) cell_index <= 4'd1;
			else if((to_left[4'd2]>0||to_right[4'd2]>0||to_up[4'd2]>0||to_down[4'd2]>0)
			&& col >= CELL_SIZE*2+BORDER_WIDTH-moveflag_2*to_left[4'd2]*movecounter+moveflag_2*to_right[4'd2]*movecounter
			&& col <= CELL_SIZE*3-BORDER_WIDTH-moveflag_2*to_left[4'd2]*movecounter+moveflag_2*to_right[4'd2]*movecounter
			&& row >= CELL_SIZE*3+BORDER_WIDTH-moveflag_2*to_up[4'd2]*movecounter+moveflag_2*to_down[4'd2]*movecounter
			&& row <= CELL_SIZE*4-BORDER_WIDTH-moveflag_2*to_up[4'd2]*movecounter+moveflag_2*to_down[4'd2]*movecounter) cell_index <= 4'd2;
			else if((to_left[4'd3]>0||to_right[4'd3]>0||to_up[4'd3]>0||to_down[4'd3]>0)
			&& col >= CELL_SIZE*2+BORDER_WIDTH-moveflag_2*to_left[4'd3]*movecounter+moveflag_2*to_right[4'd3]*movecounter
			&& col <= CELL_SIZE*3-BORDER_WIDTH-moveflag_2*to_left[4'd3]*movecounter+moveflag_2*to_right[4'd3]*movecounter
			&& row >= CELL_SIZE*4+BORDER_WIDTH-moveflag_2*to_up[4'd3]*movecounter+moveflag_2*to_down[4'd3]*movecounter
			&& row <= CELL_SIZE*5-BORDER_WIDTH-moveflag_2*to_up[4'd3]*movecounter+moveflag_2*to_down[4'd3]*movecounter) cell_index <= 4'd3;
			else if((to_left[4'd4]>0||to_right[4'd4]>0||to_up[4'd4]>0||to_down[4'd4]>0)
			&& col >= CELL_SIZE*3+BORDER_WIDTH-moveflag_2*to_left[4'd4]*movecounter+moveflag_2*to_right[4'd4]*movecounter
			&& col <= CELL_SIZE*4-BORDER_WIDTH-moveflag_2*to_left[4'd4]*movecounter+moveflag_2*to_right[4'd4]*movecounter
			&& row >= CELL_SIZE*1+BORDER_WIDTH-moveflag_2*to_up[4'd4]*movecounter+moveflag_2*to_down[4'd4]*movecounter
			&& row <= CELL_SIZE*2-BORDER_WIDTH-moveflag_2*to_up[4'd4]*movecounter+moveflag_2*to_down[4'd4]*movecounter) cell_index <= 4'd4;
			else if((to_left[4'd5]>0||to_right[4'd5]>0||to_up[4'd5]>0||to_down[4'd5]>0)
			&& col >= CELL_SIZE*3+BORDER_WIDTH-moveflag_2*to_left[4'd5]*movecounter+moveflag_2*to_right[4'd5]*movecounter
			&& col <= CELL_SIZE*4-BORDER_WIDTH-moveflag_2*to_left[4'd5]*movecounter+moveflag_2*to_right[4'd5]*movecounter
			&& row >= CELL_SIZE*2+BORDER_WIDTH-moveflag_2*to_up[4'd5]*movecounter+moveflag_2*to_down[4'd5]*movecounter
			&& row <= CELL_SIZE*3-BORDER_WIDTH-moveflag_2*to_up[4'd5]*movecounter+moveflag_2*to_down[4'd5]*movecounter) cell_index <= 4'd5;
			else if((to_left[4'd6]>0||to_right[4'd6]>0||to_up[4'd6]>0||to_down[4'd6]>0)
			&& col >= CELL_SIZE*3+BORDER_WIDTH-moveflag_2*to_left[4'd6]*movecounter+moveflag_2*to_right[4'd6]*movecounter
			&& col <= CELL_SIZE*4-BORDER_WIDTH-moveflag_2*to_left[4'd6]*movecounter+moveflag_2*to_right[4'd6]*movecounter
			&& row >= CELL_SIZE*3+BORDER_WIDTH-moveflag_2*to_up[4'd6]*movecounter+moveflag_2*to_down[4'd6]*movecounter
			&& row <= CELL_SIZE*4-BORDER_WIDTH-moveflag_2*to_up[4'd6]*movecounter+moveflag_2*to_down[4'd6]*movecounter) cell_index <= 4'd6;
			else if((to_left[4'd7]>0||to_right[4'd7]>0||to_up[4'd7]>0||to_down[4'd7]>0)
			&& col >= CELL_SIZE*3+BORDER_WIDTH-moveflag_2*to_left[4'd7]*movecounter+moveflag_2*to_right[4'd7]*movecounter
			&& col <= CELL_SIZE*4-BORDER_WIDTH-moveflag_2*to_left[4'd7]*movecounter+moveflag_2*to_right[4'd7]*movecounter
			&& row >= CELL_SIZE*4+BORDER_WIDTH-moveflag_2*to_up[4'd7]*movecounter+moveflag_2*to_down[4'd7]*movecounter
			&& row <= CELL_SIZE*5-BORDER_WIDTH-moveflag_2*to_up[4'd7]*movecounter+moveflag_2*to_down[4'd7]*movecounter) cell_index <= 4'd7;
			else if((to_left[4'd8]>0||to_right[4'd8]>0||to_up[4'd8]>0||to_down[4'd8]>0)
			&& col >= CELL_SIZE*4+BORDER_WIDTH-moveflag_2*to_left[4'd8]*movecounter+moveflag_2*to_right[4'd8]*movecounter
			&& col <= CELL_SIZE*5-BORDER_WIDTH-moveflag_2*to_left[4'd8]*movecounter+moveflag_2*to_right[4'd8]*movecounter
			&& row >= CELL_SIZE*1+BORDER_WIDTH-moveflag_2*to_up[4'd8]*movecounter+moveflag_2*to_down[4'd8]*movecounter
			&& row <= CELL_SIZE*2-BORDER_WIDTH-moveflag_2*to_up[4'd8]*movecounter+moveflag_2*to_down[4'd8]*movecounter) cell_index <= 4'd8;
			else if((to_left[4'd9]>0||to_right[4'd9]>0||to_up[4'd9]>0||to_down[4'd9]>0)
			&& col >= CELL_SIZE*4+BORDER_WIDTH-moveflag_2*to_left[4'd9]*movecounter+moveflag_2*to_right[4'd9]*movecounter
			&& col <= CELL_SIZE*5-BORDER_WIDTH-moveflag_2*to_left[4'd9]*movecounter+moveflag_2*to_right[4'd9]*movecounter
			&& row >= CELL_SIZE*2+BORDER_WIDTH-moveflag_2*to_up[4'd9]*movecounter+moveflag_2*to_down[4'd9]*movecounter
			&& row <= CELL_SIZE*3-BORDER_WIDTH-moveflag_2*to_up[4'd9]*movecounter+moveflag_2*to_down[4'd9]*movecounter) cell_index <= 4'd9;
			else if((to_left[4'd10]>0||to_right[4'd10]>0||to_up[4'd10]>0||to_down[4'd10]>0)
			&& col >= CELL_SIZE*4+BORDER_WIDTH-moveflag_2*to_left[4'd10]*movecounter+moveflag_2*to_right[4'd10]*movecounter
			&& col <= CELL_SIZE*5-BORDER_WIDTH-moveflag_2*to_left[4'd10]*movecounter+moveflag_2*to_right[4'd10]*movecounter
			&& row >= CELL_SIZE*3+BORDER_WIDTH-moveflag_2*to_up[4'd10]*movecounter+moveflag_2*to_down[4'd10]*movecounter
			&& row <= CELL_SIZE*4-BORDER_WIDTH-moveflag_2*to_up[4'd10]*movecounter+moveflag_2*to_down[4'd10]*movecounter) cell_index <= 4'd10;
			else if((to_left[4'd11]>0||to_right[4'd11]>0||to_up[4'd11]>0||to_down[4'd11]>0)
			&& col >= CELL_SIZE*4+BORDER_WIDTH-moveflag_2*to_left[4'd11]*movecounter+moveflag_2*to_right[4'd11]*movecounter
			&& col <= CELL_SIZE*5-BORDER_WIDTH-moveflag_2*to_left[4'd11]*movecounter+moveflag_2*to_right[4'd11]*movecounter
			&& row >= CELL_SIZE*4+BORDER_WIDTH-moveflag_2*to_up[4'd11]*movecounter+moveflag_2*to_down[4'd11]*movecounter
			&& row <= CELL_SIZE*5-BORDER_WIDTH-moveflag_2*to_up[4'd11]*movecounter+moveflag_2*to_down[4'd11]*movecounter) cell_index <= 4'd11;
			else if((to_left[4'd12]>0||to_right[4'd12]>0||to_up[4'd12]>0||to_down[4'd12]>0)
			&& col >= CELL_SIZE*5+BORDER_WIDTH-moveflag_2*to_left[4'd12]*movecounter+moveflag_2*to_right[4'd12]*movecounter
			&& col <= CELL_SIZE*6-BORDER_WIDTH-moveflag_2*to_left[4'd12]*movecounter+moveflag_2*to_right[4'd12]*movecounter
			&& row >= CELL_SIZE*1+BORDER_WIDTH-moveflag_2*to_up[4'd12]*movecounter+moveflag_2*to_down[4'd12]*movecounter
			&& row <= CELL_SIZE*2-BORDER_WIDTH-moveflag_2*to_up[4'd12]*movecounter+moveflag_2*to_down[4'd12]*movecounter) cell_index <= 4'd12;
			else if((to_left[4'd13]>0||to_right[4'd13]>0||to_up[4'd13]>0||to_down[4'd13]>0)
			&& col >= CELL_SIZE*5+BORDER_WIDTH-moveflag_2*to_left[4'd13]*movecounter+moveflag_2*to_right[4'd13]*movecounter
			&& col <= CELL_SIZE*6-BORDER_WIDTH-moveflag_2*to_left[4'd13]*movecounter+moveflag_2*to_right[4'd13]*movecounter
			&& row >= CELL_SIZE*2+BORDER_WIDTH-moveflag_2*to_up[4'd13]*movecounter+moveflag_2*to_down[4'd13]*movecounter
			&& row <= CELL_SIZE*3-BORDER_WIDTH-moveflag_2*to_up[4'd13]*movecounter+moveflag_2*to_down[4'd13]*movecounter) cell_index <= 4'd13;
			else if((to_left[4'd14]>0||to_right[4'd14]>0||to_up[4'd14]>0||to_down[4'd14]>0)
			&& col >= CELL_SIZE*5+BORDER_WIDTH-moveflag_2*to_left[4'd14]*movecounter+moveflag_2*to_right[4'd14]*movecounter
			&& col <= CELL_SIZE*6-BORDER_WIDTH-moveflag_2*to_left[4'd14]*movecounter+moveflag_2*to_right[4'd14]*movecounter
			&& row >= CELL_SIZE*3+BORDER_WIDTH-moveflag_2*to_up[4'd14]*movecounter+moveflag_2*to_down[4'd14]*movecounter
			&& row <= CELL_SIZE*4-BORDER_WIDTH-moveflag_2*to_up[4'd14]*movecounter+moveflag_2*to_down[4'd14]*movecounter) cell_index <= 4'd14;
			else if((to_left[4'd15]>0||to_right[4'd15]>0||to_up[4'd15]>0||to_down[4'd15]>0)
			&& col >= CELL_SIZE*5+BORDER_WIDTH-moveflag_2*to_left[4'd15]*movecounter+moveflag_2*to_right[4'd15]*movecounter
			&& col <= CELL_SIZE*6-BORDER_WIDTH-moveflag_2*to_left[4'd15]*movecounter+moveflag_2*to_right[4'd15]*movecounter
			&& row >= CELL_SIZE*4+BORDER_WIDTH-moveflag_2*to_up[4'd15]*movecounter+moveflag_2*to_down[4'd15]*movecounter
			&& row <= CELL_SIZE*5-BORDER_WIDTH-moveflag_2*to_up[4'd15]*movecounter+moveflag_2*to_down[4'd15]*movecounter) cell_index <= 4'd15;
			else if(col >= CELL_SIZE*2+BORDER_WIDTH-moveflag_2*to_left[4'd0]*movecounter+moveflag_2*to_right[4'd0]*movecounter
			&& col <= CELL_SIZE*3-BORDER_WIDTH-moveflag_2*to_left[4'd0]*movecounter+moveflag_2*to_right[4'd0]*movecounter
			&& row >= CELL_SIZE*1+BORDER_WIDTH-moveflag_2*to_up[4'd0]*movecounter+moveflag_2*to_down[4'd0]*movecounter
			&& row <= CELL_SIZE*2-BORDER_WIDTH-moveflag_2*to_up[4'd0]*movecounter+moveflag_2*to_down[4'd0]*movecounter) cell_index <= 4'd0;
			else if(col >= CELL_SIZE*2+BORDER_WIDTH-moveflag_2*to_left[4'd1]*movecounter+moveflag_2*to_right[4'd1]*movecounter
			&& col <= CELL_SIZE*3-BORDER_WIDTH-moveflag_2*to_left[4'd1]*movecounter+moveflag_2*to_right[4'd1]*movecounter
			&& row >= CELL_SIZE*2+BORDER_WIDTH-moveflag_2*to_up[4'd1]*movecounter+moveflag_2*to_down[4'd1]*movecounter
			&& row <= CELL_SIZE*3-BORDER_WIDTH-moveflag_2*to_up[4'd1]*movecounter+moveflag_2*to_down[4'd1]*movecounter) cell_index <= 4'd1;
			else if(col >= CELL_SIZE*2+BORDER_WIDTH-moveflag_2*to_left[4'd2]*movecounter+moveflag_2*to_right[4'd2]*movecounter
			&& col <= CELL_SIZE*3-BORDER_WIDTH-moveflag_2*to_left[4'd2]*movecounter+moveflag_2*to_right[4'd2]*movecounter
			&& row >= CELL_SIZE*3+BORDER_WIDTH-moveflag_2*to_up[4'd2]*movecounter+moveflag_2*to_down[4'd2]*movecounter
			&& row <= CELL_SIZE*4-BORDER_WIDTH-moveflag_2*to_up[4'd2]*movecounter+moveflag_2*to_down[4'd2]*movecounter) cell_index <= 4'd2;
			else if(col >= CELL_SIZE*2+BORDER_WIDTH-moveflag_2*to_left[4'd3]*movecounter+moveflag_2*to_right[4'd3]*movecounter
			&& col <= CELL_SIZE*3-BORDER_WIDTH-moveflag_2*to_left[4'd3]*movecounter+moveflag_2*to_right[4'd3]*movecounter
			&& row >= CELL_SIZE*4+BORDER_WIDTH-moveflag_2*to_up[4'd3]*movecounter+moveflag_2*to_down[4'd3]*movecounter
			&& row <= CELL_SIZE*5-BORDER_WIDTH-moveflag_2*to_up[4'd3]*movecounter+moveflag_2*to_down[4'd3]*movecounter) cell_index <= 4'd3;
			else if(col >= CELL_SIZE*3+BORDER_WIDTH-moveflag_2*to_left[4'd4]*movecounter+moveflag_2*to_right[4'd4]*movecounter
			&& col <= CELL_SIZE*4-BORDER_WIDTH-moveflag_2*to_left[4'd4]*movecounter+moveflag_2*to_right[4'd4]*movecounter
			&& row >= CELL_SIZE*1+BORDER_WIDTH-moveflag_2*to_up[4'd4]*movecounter+moveflag_2*to_down[4'd4]*movecounter
			&& row <= CELL_SIZE*2-BORDER_WIDTH-moveflag_2*to_up[4'd4]*movecounter+moveflag_2*to_down[4'd4]*movecounter) cell_index <= 4'd4;
			else if(col >= CELL_SIZE*3+BORDER_WIDTH-moveflag_2*to_left[4'd5]*movecounter+moveflag_2*to_right[4'd5]*movecounter
			&& col <= CELL_SIZE*4-BORDER_WIDTH-moveflag_2*to_left[4'd5]*movecounter+moveflag_2*to_right[4'd5]*movecounter
			&& row >= CELL_SIZE*2+BORDER_WIDTH-moveflag_2*to_up[4'd5]*movecounter+moveflag_2*to_down[4'd5]*movecounter
			&& row <= CELL_SIZE*3-BORDER_WIDTH-moveflag_2*to_up[4'd5]*movecounter+moveflag_2*to_down[4'd5]*movecounter) cell_index <= 4'd5;
			else if(col >= CELL_SIZE*3+BORDER_WIDTH-moveflag_2*to_left[4'd6]*movecounter+moveflag_2*to_right[4'd6]*movecounter
			&& col <= CELL_SIZE*4-BORDER_WIDTH-moveflag_2*to_left[4'd6]*movecounter+moveflag_2*to_right[4'd6]*movecounter
			&& row >= CELL_SIZE*3+BORDER_WIDTH-moveflag_2*to_up[4'd6]*movecounter+moveflag_2*to_down[4'd6]*movecounter
			&& row <= CELL_SIZE*4-BORDER_WIDTH-moveflag_2*to_up[4'd6]*movecounter+moveflag_2*to_down[4'd6]*movecounter) cell_index <= 4'd6;
			else if(col >= CELL_SIZE*3+BORDER_WIDTH-moveflag_2*to_left[4'd7]*movecounter+moveflag_2*to_right[4'd7]*movecounter
			&& col <= CELL_SIZE*4-BORDER_WIDTH-moveflag_2*to_left[4'd7]*movecounter+moveflag_2*to_right[4'd7]*movecounter
			&& row >= CELL_SIZE*4+BORDER_WIDTH-moveflag_2*to_up[4'd7]*movecounter+moveflag_2*to_down[4'd7]*movecounter
			&& row <= CELL_SIZE*5-BORDER_WIDTH-moveflag_2*to_up[4'd7]*movecounter+moveflag_2*to_down[4'd7]*movecounter) cell_index <= 4'd7;
			else if(col >= CELL_SIZE*4+BORDER_WIDTH-moveflag_2*to_left[4'd8]*movecounter+moveflag_2*to_right[4'd8]*movecounter
			&& col <= CELL_SIZE*5-BORDER_WIDTH-moveflag_2*to_left[4'd8]*movecounter+moveflag_2*to_right[4'd8]*movecounter
			&& row >= CELL_SIZE*1+BORDER_WIDTH-moveflag_2*to_up[4'd8]*movecounter+moveflag_2*to_down[4'd8]*movecounter
			&& row <= CELL_SIZE*2-BORDER_WIDTH-moveflag_2*to_up[4'd8]*movecounter+moveflag_2*to_down[4'd8]*movecounter) cell_index <= 4'd8;
			else if(col >= CELL_SIZE*4+BORDER_WIDTH-moveflag_2*to_left[4'd9]*movecounter+moveflag_2*to_right[4'd9]*movecounter
			&& col <= CELL_SIZE*5-BORDER_WIDTH-moveflag_2*to_left[4'd9]*movecounter+moveflag_2*to_right[4'd9]*movecounter
			&& row >= CELL_SIZE*2+BORDER_WIDTH-moveflag_2*to_up[4'd9]*movecounter+moveflag_2*to_down[4'd9]*movecounter
			&& row <= CELL_SIZE*3-BORDER_WIDTH-moveflag_2*to_up[4'd9]*movecounter+moveflag_2*to_down[4'd9]*movecounter) cell_index <= 4'd9;
			else if(col >= CELL_SIZE*4+BORDER_WIDTH-moveflag_2*to_left[4'd10]*movecounter+moveflag_2*to_right[4'd10]*movecounter
			&& col <= CELL_SIZE*5-BORDER_WIDTH-moveflag_2*to_left[4'd10]*movecounter+moveflag_2*to_right[4'd10]*movecounter
			&& row >= CELL_SIZE*3+BORDER_WIDTH-moveflag_2*to_up[4'd10]*movecounter+moveflag_2*to_down[4'd10]*movecounter
			&& row <= CELL_SIZE*4-BORDER_WIDTH-moveflag_2*to_up[4'd10]*movecounter+moveflag_2*to_down[4'd10]*movecounter) cell_index <= 4'd10;
			else if(col >= CELL_SIZE*4+BORDER_WIDTH-moveflag_2*to_left[4'd11]*movecounter+moveflag_2*to_right[4'd11]*movecounter
			&& col <= CELL_SIZE*5-BORDER_WIDTH-moveflag_2*to_left[4'd11]*movecounter+moveflag_2*to_right[4'd11]*movecounter
			&& row >= CELL_SIZE*4+BORDER_WIDTH-moveflag_2*to_up[4'd11]*movecounter+moveflag_2*to_down[4'd11]*movecounter
			&& row <= CELL_SIZE*5-BORDER_WIDTH-moveflag_2*to_up[4'd11]*movecounter+moveflag_2*to_down[4'd11]*movecounter) cell_index <= 4'd11;
			else if(col >= CELL_SIZE*5+BORDER_WIDTH-moveflag_2*to_left[4'd12]*movecounter+moveflag_2*to_right[4'd12]*movecounter
			&& col <= CELL_SIZE*6-BORDER_WIDTH-moveflag_2*to_left[4'd12]*movecounter+moveflag_2*to_right[4'd12]*movecounter
			&& row >= CELL_SIZE*1+BORDER_WIDTH-moveflag_2*to_up[4'd12]*movecounter+moveflag_2*to_down[4'd12]*movecounter
			&& row <= CELL_SIZE*2-BORDER_WIDTH-moveflag_2*to_up[4'd12]*movecounter+moveflag_2*to_down[4'd12]*movecounter) cell_index <= 4'd12;
			else if(col >= CELL_SIZE*5+BORDER_WIDTH-moveflag_2*to_left[4'd13]*movecounter+moveflag_2*to_right[4'd13]*movecounter
			&& col <= CELL_SIZE*6-BORDER_WIDTH-moveflag_2*to_left[4'd13]*movecounter+moveflag_2*to_right[4'd13]*movecounter
			&& row >= CELL_SIZE*2+BORDER_WIDTH-moveflag_2*to_up[4'd13]*movecounter+moveflag_2*to_down[4'd13]*movecounter
			&& row <= CELL_SIZE*3-BORDER_WIDTH-moveflag_2*to_up[4'd13]*movecounter+moveflag_2*to_down[4'd13]*movecounter) cell_index <= 4'd13;
			else if(col >= CELL_SIZE*5+BORDER_WIDTH-moveflag_2*to_left[4'd14]*movecounter+moveflag_2*to_right[4'd14]*movecounter
			&& col <= CELL_SIZE*6-BORDER_WIDTH-moveflag_2*to_left[4'd14]*movecounter+moveflag_2*to_right[4'd14]*movecounter
			&& row >= CELL_SIZE*3+BORDER_WIDTH-moveflag_2*to_up[4'd14]*movecounter+moveflag_2*to_down[4'd14]*movecounter
			&& row <= CELL_SIZE*4-BORDER_WIDTH-moveflag_2*to_up[4'd14]*movecounter+moveflag_2*to_down[4'd14]*movecounter) cell_index <= 4'd14;
			else if(col >= CELL_SIZE*5+BORDER_WIDTH-moveflag_2*to_left[4'd15]*movecounter+moveflag_2*to_right[4'd15]*movecounter
			&& col <= CELL_SIZE*6-BORDER_WIDTH-moveflag_2*to_left[4'd15]*movecounter+moveflag_2*to_right[4'd15]*movecounter
			&& row >= CELL_SIZE*4+BORDER_WIDTH-moveflag_2*to_up[4'd15]*movecounter+moveflag_2*to_down[4'd15]*movecounter
			&& row <= CELL_SIZE*5-BORDER_WIDTH-moveflag_2*to_up[4'd15]*movecounter+moveflag_2*to_down[4'd15]*movecounter) cell_index <= 4'd15;
			else cell_index <= 5'd16;
			
			/*
			if(col >= CELL_SIZE*2+BORDER_WIDTH && col <= CELL_SIZE*3-BORDER_WIDTH) begin
				if(row >= CELL_SIZE+BORDER_WIDTH && row <= CELL_SIZE*2-BORDER_WIDTH) cell_index <= 4'd0;
				else if(row >= CELL_SIZE*2+BORDER_WIDTH && row <= CELL_SIZE*3-BORDER_WIDTH) cell_index <= 4'd1;
				else if(row >= CELL_SIZE*3+BORDER_WIDTH && row <= CELL_SIZE*4-BORDER_WIDTH) cell_index <= 4'd2;
				else if(row >= CELL_SIZE*4+BORDER_WIDTH && row <= CELL_SIZE*5-BORDER_WIDTH) cell_index <= 4'd3;
			end
			else if(col >= CELL_SIZE*3+BORDER_WIDTH && col <= CELL_SIZE*4-BORDER_WIDTH) begin
				if(row >= CELL_SIZE+BORDER_WIDTH && row <= CELL_SIZE*2-BORDER_WIDTH) cell_index <= 4'd4;
				else if(row >= CELL_SIZE*2+BORDER_WIDTH && row <= CELL_SIZE*3-BORDER_WIDTH) cell_index <= 4'd5;
				else if(row >= CELL_SIZE*3+BORDER_WIDTH && row <= CELL_SIZE*4-BORDER_WIDTH) cell_index <= 4'd6;
				else if(row >= CELL_SIZE*4+BORDER_WIDTH && row <= CELL_SIZE*5-BORDER_WIDTH) cell_index <= 4'd7;
			end
			else if(col >= CELL_SIZE*4+BORDER_WIDTH && col <= CELL_SIZE*5-BORDER_WIDTH) begin
				if(row >= CELL_SIZE+BORDER_WIDTH && row <= CELL_SIZE*2-BORDER_WIDTH) cell_index <= 4'd8;
				else if(row >= CELL_SIZE*2+BORDER_WIDTH && row <= CELL_SIZE*3-BORDER_WIDTH) cell_index <= 4'd9;
				else if(row >= CELL_SIZE*3+BORDER_WIDTH && row <= CELL_SIZE*4-BORDER_WIDTH) cell_index <= 4'd10;
				else if(row >= CELL_SIZE*4+BORDER_WIDTH && row <= CELL_SIZE*5-BORDER_WIDTH) cell_index <= 4'd11;
			end
			else if(col >= CELL_SIZE*5+BORDER_WIDTH && col <= CELL_SIZE*6-BORDER_WIDTH) begin
				if(row >= CELL_SIZE+BORDER_WIDTH && row <= CELL_SIZE*2-BORDER_WIDTH) cell_index <= 4'd12;
				else if(row >= CELL_SIZE*2+BORDER_WIDTH && row <= CELL_SIZE*3-BORDER_WIDTH) cell_index <= 4'd13;
				else if(row >= CELL_SIZE*3+BORDER_WIDTH && row <= CELL_SIZE*4-BORDER_WIDTH) cell_index <= 4'd14;
				else if(row >= CELL_SIZE*4+BORDER_WIDTH && row <= CELL_SIZE*5-BORDER_WIDTH) cell_index <= 4'd15;
			end
			*/
		end
	end
	
	always @(posedge CLK or negedge RST) begin
		if(!RST) begin
			{board[0], board[4], board[8], board[12]} <= {8'd0, 8'd2, 8'd0, 8'd0};
			{board[1], board[5], board[9], board[13]} <= {8'd0, 8'd0, 8'd0, 8'd0};
			{board[2], board[6], board[10], board[14]} <= {8'd0, 8'd0, 8'd0, 8'd0};
			{board[3], board[7], board[11], board[15]} <= {8'd0, 8'd1, 8'd0, 8'd0};
			{origin[0], origin[4], origin[8], origin[12]} <= {8'd0, 8'd2, 8'd0, 8'd0};
			{origin[1], origin[5], origin[9], origin[13]} <= {8'd0, 8'd0, 8'd0, 8'd0};
			{origin[2], origin[6], origin[10], origin[14]} <= {8'd0, 8'd0, 8'd0, 8'd0};
			{origin[3], origin[7], origin[11], origin[15]} <= {8'd0, 8'd1, 8'd0, 8'd0};
			activeflag <= 1'b0;
			appearflag <= 1'b0;
			moveflag <= 1'b0;
			moveflag_2 <= 1'b0;
			endflag <= 2'd0;
			clockcounter <= 64'd0;
			clockflag <= 1'b0;
			missileclockflag <= 1'b0;
			
			movecounter <= 32'd0;
			moveclocker <= 32'd0;
		 jet_pos <= 64'd0;
				
			missile_row <= 32'd100;
			missile_col <= 32'd200;
			missile_flag <= 3'd0;
			
			to_left[0] <= 32'd0;
			to_left[1] <= 32'd0;
			to_left[2] <= 32'd0;
			to_left[3] <= 32'd0;
			to_left[4] <= 32'd0;
			to_left[5] <= 32'd0;
			to_left[6] <= 32'd0;
			to_left[7] <= 32'd0;
			to_left[8] <= 32'd0;
			to_left[9] <= 32'd0;
			to_left[10] <= 32'd0;
			to_left[11] <= 32'd0;
			to_left[12] <= 32'd0;
			to_left[13] <= 32'd0;
			to_left[14] <= 32'd0;
			to_left[15] <= 32'd0;
			
			to_right[0] <= 32'd0;
			to_right[1] <= 32'd0;
			to_right[2] <= 32'd0;
			to_right[3] <= 32'd0;
			to_right[4] <= 32'd0;
			to_right[5] <= 32'd0;
			to_right[6] <= 32'd0;
			to_right[7] <= 32'd0;
			to_right[8] <= 32'd0;
			to_right[9] <= 32'd0;
			to_right[10] <= 32'd0;
			to_right[11] <= 32'd0;
			to_right[12] <= 32'd0;
			to_right[13] <= 32'd0;
			to_right[14] <= 32'd0;
			to_right[15] <= 32'd0;
			
			to_up[0] <= 32'd0;
			to_up[1] <= 32'd0;
			to_up[2] <= 32'd0;
			to_up[3] <= 32'd0;
			to_up[4] <= 32'd0;
			to_up[5] <= 32'd0;
			to_up[6] <= 32'd0;
			to_up[7] <= 32'd0;
			to_up[8] <= 32'd0;
			to_up[9] <= 32'd0;
			to_up[10] <= 32'd0;
			to_up[11] <= 32'd0;
			to_up[12] <= 32'd0;
			to_up[13] <= 32'd0;
			to_up[14] <= 32'd0;
			to_up[15] <= 32'd0;
			
			to_down[0] <= 32'd0;
			to_down[1] <= 32'd0;
			to_down[2] <= 32'd0;
			to_down[3] <= 32'd0;
			to_down[4] <= 32'd0;
			to_down[5] <= 32'd0;
			to_down[6] <= 32'd0;
			to_down[7] <= 32'd0;
			to_down[8] <= 32'd0;
			to_down[9] <= 32'd0;
			to_down[10] <= 32'd0;
			to_down[11] <= 32'd0;
			to_down[12] <= 32'd0;
			to_down[13] <= 32'd0;
			to_down[14] <= 32'd0;
			to_down[15] <= 32'd0;
		end
		else if(endflag == 2'd0) begin
			if(!moveflag && !moveflag_2) begin
				{origin[0], origin[1], origin[2], origin[3]} <= {board[0], board[1], board[2], board[3]};
				{origin[4], origin[5], origin[6], origin[7]} <= {board[4], board[5], board[6], board[7]};
				{origin[8], origin[9], origin[10], origin[11]} <= {board[8], board[9], board[10], board[11]};
				{origin[12], origin[13], origin[14], origin[15]} <= {board[12], board[13], board[14], board[15]};
			end
			
			if(moveflag_2) begin
				moveclocker <= moveclocker + 32'd1;
				movecounter <= moveclocker[26:17];
				if(movecounter >= 32'd100) begin
					moveclocker <= 32'd0;
					movecounter <= 32'd0;
					moveflag_2 <= 1'b0;
					appearflag <= 1'b1;
				end
			end
			
			if(!moveflag && !moveflag_2) begin
				to_left[0] <= 32'd0;
				to_left[1] <= 32'd0;
				to_left[2] <= 32'd0;
				to_left[3] <= 32'd0;
				to_left[4] <= 32'd0;
				to_left[5] <= 32'd0;
				to_left[6] <= 32'd0;
				to_left[7] <= 32'd0;
				to_left[8] <= 32'd0;
				to_left[9] <= 32'd0;
				to_left[10] <= 32'd0;
				to_left[11] <= 32'd0;
				to_left[12] <= 32'd0;
				to_left[13] <= 32'd0;
				to_left[14] <= 32'd0;
				to_left[15] <= 32'd0;
				
				to_right[0] <= 32'd0;
				to_right[1] <= 32'd0;
				to_right[2] <= 32'd0;
				to_right[3] <= 32'd0;
				to_right[4] <= 32'd0;
				to_right[5] <= 32'd0;
				to_right[6] <= 32'd0;
				to_right[7] <= 32'd0;
				to_right[8] <= 32'd0;
				to_right[9] <= 32'd0;
				to_right[10] <= 32'd0;
				to_right[11] <= 32'd0;
				to_right[12] <= 32'd0;
				to_right[13] <= 32'd0;
				to_right[14] <= 32'd0;
				to_right[15] <= 32'd0;
				
				to_up[0] <= 32'd0;
				to_up[1] <= 32'd0;
				to_up[2] <= 32'd0;
				to_up[3] <= 32'd0;
				to_up[4] <= 32'd0;
				to_up[5] <= 32'd0;
				to_up[6] <= 32'd0;
				to_up[7] <= 32'd0;
				to_up[8] <= 32'd0;
				to_up[9] <= 32'd0;
				to_up[10] <= 32'd0;
				to_up[11] <= 32'd0;
				to_up[12] <= 32'd0;
				to_up[13] <= 32'd0;
				to_up[14] <= 32'd0;
				to_up[15] <= 32'd0;
				
				to_down[0] <= 32'd0;
				to_down[1] <= 32'd0;
				to_down[2] <= 32'd0;
				to_down[3] <= 32'd0;
				to_down[4] <= 32'd0;
				to_down[5] <= 32'd0;
				to_down[6] <= 32'd0;
				to_down[7] <= 32'd0;
				to_down[8] <= 32'd0;
				to_down[9] <= 32'd0;
				to_down[10] <= 32'd0;
				to_down[11] <= 32'd0;
				to_down[12] <= 32'd0;
				to_down[13] <= 32'd0;
				to_down[14] <= 32'd0;
				to_down[15] <= 32'd0;
			end
			
			clockcounter <= clockcounter + 64'd1;
			
			if(jet_pos >= 2200) jet_pos <= 64'd0;
			else if(clockcounter[17] == clockflag) begin
				if(!speed) jet_pos <= jet_pos + 3;
				else jet_pos <= jet_pos	+ 1;
				clockflag <= clockflag + 1'b1;
			end
			if(clockcounter[15] == missileclockflag) begin
				if(missile_flag == 1) missile_col <= missile_col+1;
				else if(missile_flag == 2) missile_row <= missile_row-1;
				else if(missile_flag == 3) missile_col <= missile_col-1;
				else if(missile_flag == 4) missile_row <= missile_row+1;
				missileclockflag <= missileclockflag + 1'b1;
			end
			
			if(!missile && missile_flag==0) begin
				if(jet_pos <= 600) begin
					missile_row <= 520+30-3;
					missile_col <= 70+jet_pos;
					missile_flag <= 3'd1;
				end
				else if(jet_pos <= 1100) begin
					missile_row <= 520+600-jet_pos;
					missile_col <= 670+30-3;
					missile_flag <= 3'd2;
				end
				else if(jet_pos <= 1700) begin
					missile_row <= 20+30-1;
					missile_col <= 670+1100-jet_pos;
					missile_flag <= 3'd3;
				end
				else if(jet_pos <= 2200) begin
					missile_row <= 20+jet_pos-1700;
					missile_col <= 70+30;
					missile_flag <= 3'd4;
				end
			end
			
			if(missile_row <= 1 || missile_row >= 598 || missile_col <= 1 || missile_col >= 798) begin
				missile_flag <= 3'd0;
				missile_row <= 100;
				missile_col <= 200;
			end
			
			if(board[0]>0&&board[1]>0&&board[2]>0&&board[3]>0&&board[4]>0&&board[5]>0&&board[6]>0&&board[7]>0
			 &&board[8]>0&&board[9]>0&&board[10]>0&&board[11]>0&&board[12]>0&&board[13]>0&&board[14]>0&&board[15]>0
			 &&board[0]!=board[1]&&board[1]!=board[2]&&board[2]!=board[3]
			 &&board[4]!=board[5]&&board[5]!=board[6]&&board[6]!=board[7]
			 &&board[8]!=board[9]&&board[9]!=board[10]&&board[10]!=board[11]
			 &&board[12]!=board[13]&&board[13]!=board[14]&&board[14]!=board[15]
			 &&board[0]!=board[4]&&board[4]!=board[8]&&board[8]!=board[12]
			 &&board[1]!=board[5]&&board[5]!=board[9]&&board[9]!=board[13]
			 &&board[2]!=board[6]&&board[6]!=board[10]&&board[10]!=board[14]
			 &&board[3]!=board[7]&&board[7]!=board[11]&&board[11]!=board[15]) endflag <= 2'd1;
				
			if(board[0]==8'd11||board[1]==8'd11||board[2]==8'd11||board[3]==8'd11
			 ||board[4]==8'd11||board[5]==8'd11||board[6]==8'd11||board[7]==8'd11
			 ||board[8]==8'd11||board[9]==8'd11||board[10]==8'd11||board[11]==8'd11
			 ||board[13]==8'd11||board[13]==8'd11||board[14]==8'd11||board[15]==8'd11) endflag <= 2'd2;
			
			if(up && down && left && right) begin
				activeflag <= 1'b0;
			end
			else if(!moveflag_2 && !moveflag && !appearflag) begin
				activeflag <= 1'b1;
				if(!left && !activeflag) begin
					if(board[0] == 8'd0 && board[4] == 8'd0 && board[8] == 8'd0 && board[12] == 8'd0) begin
						{board[0], board[4], board[8], board[12]} <= {8'd0, 8'd0, 8'd0, 8'd0};
						{to_left[0], to_left[4], to_left[8], to_left[12]} <= {32'd0, 32'd0, 32'd0, 32'd0};
					end
					else if(board[0] == 8'd0 && board[4] == 8'd0 && board[8] == 8'd0 && board[12] != 8'd0) begin
						{board[0], board[4], board[8], board[12]} <= {board[12], 8'd0, 8'd0, 8'd0};
						{to_left[0], to_left[4], to_left[8], to_left[12]} <= {32'd0, 32'd0, 32'd0, 32'd3};
					end
					else if(board[0] == 8'd0 && board[4] == 8'd0 && board[8] != 8'd0 && board[12] == 8'd0) begin
						{board[0], board[4], board[8], board[12]} <= {board[8], 8'd0, 8'd0, 8'd0};
						{to_left[0], to_left[4], to_left[8], to_left[12]} <= {32'd0, 32'd0, 32'd2, 32'd0};
					end
					else if(board[0] == 8'd0 && board[4] != 8'd0 && board[8] == 8'd0 && board[12] == 8'd0) begin
						{board[0], board[4], board[8], board[12]} <= {board[4], 8'd0, 8'd0, 8'd0};
						{to_left[0], to_left[4], to_left[8], to_left[12]} <= {32'd0, 32'd1, 32'd0, 32'd0};
					end
					else if(board[0] != 8'd0 && board[4] == 8'd0 && board[8] == 8'd0 && board[12] == 8'd0) begin
						{board[0], board[4], board[8], board[12]} <= {board[0], 8'd0, 8'd0, 8'd0};
						{to_left[0], to_left[4], to_left[8], to_left[12]} <= {32'd0, 32'd0, 32'd0, 32'd0};
					end
					else if(board[0] == 8'd0 && board[4] == 8'd0 && board[8] != 8'd0 && board[12] != 8'd0) begin
						if(board[8] != board[12]) begin
							{board[0], board[4], board[8], board[12]} <= {board[8], board[12], 8'd0, 8'd0};
							{to_left[0], to_left[4], to_left[8], to_left[12]} <= {32'd0, 32'd0, 32'd2, 32'd2};
						end
						else begin
							{board[0], board[4], board[8], board[12]} <= {board[8]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_left[0], to_left[4], to_left[8], to_left[12]} <= {32'd0, 32'd0, 32'd2, 32'd3};
						end
					end
					else if(board[0] == 8'd0 && board[4] != 8'd0 && board[8] == 8'd0 && board[12] != 8'd0) begin
						if(board[4] != board[12]) begin
							{board[0], board[4], board[8], board[12]} <= {board[4], board[12], 8'd0, 8'd0};
							{to_left[0], to_left[4], to_left[8], to_left[12]} <= {32'd0, 32'd1, 32'd0, 32'd2};
						end
						else begin
							{board[0], board[4], board[8], board[12]} <= {board[4]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_left[0], to_left[4], to_left[8], to_left[12]} <= {32'd0, 32'd1, 32'd0, 32'd3};
						end
					end
					else if(board[0] != 8'd0 && board[4] == 8'd0 && board[8] == 8'd0 && board[12] != 8'd0) begin
						if(board[0] != board[12]) begin
							{board[0], board[4], board[8], board[12]} <= {board[0], board[12], 8'd0, 8'd0};
							{to_left[0], to_left[4], to_left[8], to_left[12]} <= {32'd0, 32'd0, 32'd0, 32'd2};
						end
						else begin
							{board[0], board[4], board[8], board[12]} <= {board[0]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_left[0], to_left[4], to_left[8], to_left[12]} <= {32'd0, 32'd0, 32'd0, 32'd3};
						end
					end
					else if(board[0] == 8'd0 && board[4] != 8'd0 && board[8] != 8'd0 && board[12] == 8'd0) begin
						if(board[4] != board[8]) begin
							{board[0], board[4], board[8], board[12]} <= {board[4], board[8], 8'd0, 8'd0};
							{to_left[0], to_left[4], to_left[8], to_left[12]} <= {32'd0, 32'd1, 32'd1, 32'd0};
						end
						else begin
							{board[0], board[4], board[8], board[12]} <= {board[4]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_left[0], to_left[4], to_left[8], to_left[12]} <= {32'd0, 32'd1, 32'd2, 32'd0};
						end
					end
					else if(board[0] != 8'd0 && board[4] == 8'd0 && board[8] != 8'd0 && board[12] == 8'd0) begin
						if(board[0] != board[8]) begin
							{board[0], board[4], board[8], board[12]} <= {board[0], board[8], 8'd0, 8'd0};
							{to_left[0], to_left[4], to_left[8], to_left[12]} <= {32'd0, 32'd0, 32'd1, 32'd0};
						end
						else begin
							{board[0], board[4], board[8], board[12]} <= {board[0]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_left[0], to_left[4], to_left[8], to_left[12]} <= {32'd0, 32'd0, 32'd2, 32'd0};
						end
					end
					else if(board[0] != 8'd0 && board[4] != 8'd0 && board[8] == 8'd0 && board[12] == 8'd0) begin
						if(board[0] != board[4]) begin
							{board[0], board[4], board[8], board[12]} <= {board[0], board[4], 8'd0, 8'd0};
							{to_left[0], to_left[4], to_left[8], to_left[12]} <= {32'd0, 32'd0, 32'd0, 32'd0};
						end
						else begin
							{board[0], board[4], board[8], board[12]} <= {board[0]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_left[0], to_left[4], to_left[8], to_left[12]} <= {32'd0, 32'd1, 32'd0, 32'd0};
						end
					end
					else if(board[0] != 8'd0 && board[4] != 8'd0 && board[8] != 8'd0 && board[12] == 8'd0) begin
						if(board[0] == board[4]) begin
							{board[0], board[4], board[8], board[12]} <= {board[0]+8'd1, board[8], 8'd0, 8'd0};
							{to_left[0], to_left[4], to_left[8], to_left[12]} <= {32'd0, 32'd1, 32'd1, 32'd0};
						end
						else if(board[4] == board[8]) begin
							{board[0], board[4], board[8], board[12]} <= {board[0], board[4]+8'd1, 8'd0, 8'd0};
							{to_left[0], to_left[4], to_left[8], to_left[12]} <= {32'd0, 32'd0, 32'd1, 32'd0};
						end
						else begin
							{board[0], board[4], board[8], board[12]} <= {board[0], board[4], board[8], 8'd0};
							{to_left[0], to_left[4], to_left[8], to_left[12]} <= {32'd0, 32'd0, 32'd0, 32'd0};
						end
					end
					else if(board[0] != 8'd0 && board[4] != 8'd0 && board[8] == 8'd0 && board[12] != 8'd0) begin
						if(board[0] == board[4]) begin
							{board[0], board[4], board[8], board[12]} <= {board[0]+8'd1, board[12], 8'd0, 8'd0};
							{to_left[0], to_left[4], to_left[8], to_left[12]} <= {32'd0, 32'd1, 32'd0, 32'd2};
						end
						else if(board[4] == board[12]) begin
							{board[0], board[4], board[8], board[12]} <= {board[0], board[4]+8'd1, 8'd0, 8'd0};
							{to_left[0], to_left[4], to_left[8], to_left[12]} <= {32'd0, 32'd0, 32'd0, 32'd2};
						end
						else begin
							{board[0], board[4], board[8], board[12]} <= {board[0], board[4], board[12], 8'd0};
							{to_left[0], to_left[4], to_left[8], to_left[12]} <= {32'd0, 32'd0, 32'd0, 32'd1};
						end
					end
					else if(board[0] != 8'd0 && board[4] == 8'd0 && board[8] != 8'd0 && board[12] != 8'd0) begin
						if(board[0] == board[8]) begin
							{board[0], board[4], board[8], board[12]} <= {board[0]+8'd1, board[12], 8'd0, 8'd0};
							{to_left[0], to_left[4], to_left[8], to_left[12]} <= {32'd0, 32'd0, 32'd2, 32'd2};
						end
						else if(board[8] == board[12]) begin
							{board[0], board[4], board[8], board[12]} <= {board[0], board[8]+8'd1, 8'd0, 8'd0};
							{to_left[0], to_left[4], to_left[8], to_left[12]} <= {32'd0, 32'd0, 32'd1, 32'd2};
						end
						else begin
							{board[0], board[4], board[8], board[12]} <= {board[0], board[8], board[12], 8'd0};
							{to_left[0], to_left[4], to_left[8], to_left[12]} <= {32'd0, 32'd0, 32'd1, 32'd1};
						end
					end
					else if(board[0] == 8'd0 && board[4] != 8'd0 && board[8] != 8'd0 && board[12] != 8'd0) begin
						if(board[4] == board[8]) begin
							{board[0], board[4], board[8], board[12]} <= {board[4]+8'd1, board[12], 8'd0, 8'd0};
							{to_left[0], to_left[4], to_left[8], to_left[12]} <= {32'd0, 32'd1, 32'd2, 32'd2};
						end
						else if(board[8] == board[12]) begin
							{board[0], board[4], board[8], board[12]} <= {board[4], board[8]+8'd1, 8'd0, 8'd0};
							{to_left[0], to_left[4], to_left[8], to_left[12]} <= {32'd0, 32'd1, 32'd1, 32'd2};
						end
						else begin
							{board[0], board[4], board[8], board[12]} <= {board[4], board[8], board[12], 8'd0};
							{to_left[0], to_left[4], to_left[8], to_left[12]} <= {32'd0, 32'd1, 32'd1, 32'd1};
						end
					end
					else begin
						if(board[0] == board[4]) begin
							if(board[8] == board[12]) begin
								{board[0], board[4], board[8], board[12]} <= {board[0]+8'd1, board[8]+8'd1, 8'd0, 8'd0};
								{to_left[0], to_left[4], to_left[8], to_left[12]} <= {32'd0, 32'd1, 32'd1, 32'd2};
							end
							else begin
								{board[0], board[4], board[8], board[12]} <= {board[0]+8'd1, board[8], board[12], 8'd0};
								{to_left[0], to_left[4], to_left[8], to_left[12]} <= {32'd0, 32'd1, 32'd1, 32'd1};
							end
						end
						else begin
							if(board[4] == board[8]) begin
								{board[0], board[4], board[8], board[12]} <= {board[0], board[4]+8'd1, board[12], 8'd0};
								{to_left[0], to_left[4], to_left[8], to_left[12]} <= {32'd0, 32'd0, 32'd1, 32'd1};
							end
							else if(board[8] == board[12]) begin
								{board[0], board[4], board[8], board[12]} <= {board[0], board[4], board[8]+8'd1, 8'd0};
								{to_left[0], to_left[4], to_left[8], to_left[12]} <= {32'd0, 32'd0, 32'd0, 32'd1};
							end
							else begin
								{board[0], board[4], board[8], board[12]} <= {board[0], board[4], board[8], board[12]};
								{to_left[0], to_left[4], to_left[8], to_left[12]} <= {32'd0, 32'd0, 32'd0, 32'd0};
							end
						end
					end
					
					if(board[1] == 8'd0 && board[5] == 8'd0 && board[9] == 8'd0 && board[13] == 8'd0) begin
						{board[1], board[5], board[9], board[13]} <= {8'd0, 8'd0, 8'd0, 8'd0};
						{to_left[1], to_left[5], to_left[9], to_left[13]} <= {32'd0, 32'd0, 32'd0, 32'd0};
					end
					else if(board[1] == 8'd0 && board[5] == 8'd0 && board[9] == 8'd0 && board[13] != 8'd0) begin
						{board[1], board[5], board[9], board[13]} <= {board[13], 8'd0, 8'd0, 8'd0};
						{to_left[1], to_left[5], to_left[9], to_left[13]} <= {32'd0, 32'd0, 32'd0, 32'd3};
					end
					else if(board[1] == 8'd0 && board[5] == 8'd0 && board[9] != 8'd0 && board[13] == 8'd0) begin
						{board[1], board[5], board[9], board[13]} <= {board[9], 8'd0, 8'd0, 8'd0};
						{to_left[1], to_left[5], to_left[9], to_left[13]} <= {32'd0, 32'd0, 32'd2, 32'd0};
					end
					else if(board[1] == 8'd0 && board[5] != 8'd0 && board[9] == 8'd0 && board[13] == 8'd0) begin
						{board[1], board[5], board[9], board[13]} <= {board[5], 8'd0, 8'd0, 8'd0};
						{to_left[1], to_left[5], to_left[9], to_left[13]} <= {32'd0, 32'd1, 32'd0, 32'd0};
					end
					else if(board[1] != 8'd0 && board[5] == 8'd0 && board[9] == 8'd0 && board[13] == 8'd0) begin
						{board[1], board[5], board[9], board[13]} <= {board[1], 8'd0, 8'd0, 8'd0};
						{to_left[1], to_left[5], to_left[9], to_left[13]} <= {32'd0, 32'd0, 32'd0, 32'd0};
					end
					else if(board[1] == 8'd0 && board[5] == 8'd0 && board[9] != 8'd0 && board[13] != 8'd0) begin
						if(board[9] != board[13]) begin
							{board[1], board[5], board[9], board[13]} <= {board[9], board[13], 8'd0, 8'd0};
							{to_left[1], to_left[5], to_left[9], to_left[13]} <= {32'd0, 32'd0, 32'd2, 32'd2};
						end
						else begin
							{board[1], board[5], board[9], board[13]} <= {board[9]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_left[1], to_left[5], to_left[9], to_left[13]} <= {32'd0, 32'd0, 32'd2, 32'd3};
						end
					end
					else if(board[1] == 8'd0 && board[5] != 8'd0 && board[9] == 8'd0 && board[13] != 8'd0) begin
						if(board[5] != board[13]) begin
							{board[1], board[5], board[9], board[13]} <= {board[5], board[13], 8'd0, 8'd0};
							{to_left[1], to_left[5], to_left[9], to_left[13]} <= {32'd0, 32'd1, 32'd0, 32'd2};
						end
						else begin
							{board[1], board[5], board[9], board[13]} <= {board[5]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_left[1], to_left[5], to_left[9], to_left[13]} <= {32'd0, 32'd1, 32'd0, 32'd3};
						end
					end
					else if(board[1] != 8'd0 && board[5] == 8'd0 && board[9] == 8'd0 && board[13] != 8'd0) begin
						if(board[1] != board[13]) begin
							{board[1], board[5], board[9], board[13]} <= {board[1], board[13], 8'd0, 8'd0};
							{to_left[1], to_left[5], to_left[9], to_left[13]} <= {32'd0, 32'd0, 32'd0, 32'd2};
						end
						else begin
							{board[1], board[5], board[9], board[13]} <= {board[1]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_left[1], to_left[5], to_left[9], to_left[13]} <= {32'd0, 32'd0, 32'd0, 32'd3};
						end
					end
					else if(board[1] == 8'd0 && board[5] != 8'd0 && board[9] != 8'd0 && board[13] == 8'd0) begin
						if(board[5] != board[9]) begin
							{board[1], board[5], board[9], board[13]} <= {board[5], board[9], 8'd0, 8'd0};
							{to_left[1], to_left[5], to_left[9], to_left[13]} <= {32'd0, 32'd1, 32'd1, 32'd0};
						end
						else begin
							{board[1], board[5], board[9], board[13]} <= {board[5]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_left[1], to_left[5], to_left[9], to_left[13]} <= {32'd0, 32'd1, 32'd2, 32'd0};
						end
					end
					else if(board[1] != 8'd0 && board[5] == 8'd0 && board[9] != 8'd0 && board[13] == 8'd0) begin
						if(board[1] != board[9]) begin
							{board[1], board[5], board[9], board[13]} <= {board[1], board[9], 8'd0, 8'd0};
							{to_left[1], to_left[5], to_left[9], to_left[13]} <= {32'd0, 32'd0, 32'd1, 32'd0};
						end
						else begin
							{board[1], board[5], board[9], board[13]} <= {board[1]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_left[1], to_left[5], to_left[9], to_left[13]} <= {32'd0, 32'd0, 32'd2, 32'd0};
						end
					end
					else if(board[1] != 8'd0 && board[5] != 8'd0 && board[9] == 8'd0 && board[13] == 8'd0) begin
						if(board[1] != board[5]) begin
							{board[1], board[5], board[9], board[13]} <= {board[1], board[5], 8'd0, 8'd0};
							{to_left[1], to_left[5], to_left[9], to_left[13]} <= {32'd0, 32'd0, 32'd0, 32'd0};
						end
						else begin
							{board[1], board[5], board[9], board[13]} <= {board[1]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_left[1], to_left[5], to_left[9], to_left[13]} <= {32'd0, 32'd1, 32'd0, 32'd0};
						end
					end
					else if(board[1] != 8'd0 && board[5] != 8'd0 && board[9] != 8'd0 && board[13] == 8'd0) begin
						if(board[1] == board[5]) begin
							{board[1], board[5], board[9], board[13]} <= {board[1]+8'd1, board[9], 8'd0, 8'd0};
							{to_left[1], to_left[5], to_left[9], to_left[13]} <= {32'd0, 32'd1, 32'd1, 32'd0};
						end
						else if(board[5] == board[9]) begin
							{board[1], board[5], board[9], board[13]} <= {board[1], board[5]+8'd1, 8'd0, 8'd0};
							{to_left[1], to_left[5], to_left[9], to_left[13]} <= {32'd0, 32'd0, 32'd1, 32'd0};
						end
						else begin
							{board[1], board[5], board[9], board[13]} <= {board[1], board[5], board[9], 8'd0};
							{to_left[1], to_left[5], to_left[9], to_left[13]} <= {32'd0, 32'd0, 32'd0, 32'd0};
						end
					end
					else if(board[1] != 8'd0 && board[5] != 8'd0 && board[9] == 8'd0 && board[13] != 8'd0) begin
						if(board[1] == board[5]) begin
							{board[1], board[5], board[9], board[13]} <= {board[1]+8'd1, board[13], 8'd0, 8'd0};
							{to_left[1], to_left[5], to_left[9], to_left[13]} <= {32'd0, 32'd1, 32'd0, 32'd2};
						end
						else if(board[5] == board[13]) begin
							{board[1], board[5], board[9], board[13]} <= {board[1], board[5]+8'd1, 8'd0, 8'd0};
							{to_left[1], to_left[5], to_left[9], to_left[13]} <= {32'd0, 32'd0, 32'd0, 32'd2};
						end
						else begin
							{board[1], board[5], board[9], board[13]} <= {board[1], board[5], board[13], 8'd0};
							{to_left[1], to_left[5], to_left[9], to_left[13]} <= {32'd0, 32'd0, 32'd0, 32'd1};
						end
					end
					else if(board[1] != 8'd0 && board[5] == 8'd0 && board[9] != 8'd0 && board[13] != 8'd0) begin
						if(board[1] == board[9]) begin
							{board[1], board[5], board[9], board[13]} <= {board[1]+8'd1, board[13], 8'd0, 8'd0};
							{to_left[1], to_left[5], to_left[9], to_left[13]} <= {32'd0, 32'd0, 32'd2, 32'd2};
						end
						else if(board[9] == board[13]) begin
							{board[1], board[5], board[9], board[13]} <= {board[1], board[9]+8'd1, 8'd0, 8'd0};
							{to_left[1], to_left[5], to_left[9], to_left[13]} <= {32'd0, 32'd0, 32'd1, 32'd2};
						end
						else begin
							{board[1], board[5], board[9], board[13]} <= {board[1], board[9], board[13], 8'd0};
							{to_left[1], to_left[5], to_left[9], to_left[13]} <= {32'd0, 32'd0, 32'd1, 32'd1};
						end
					end
					else if(board[1] == 8'd0 && board[5] != 8'd0 && board[9] != 8'd0 && board[13] != 8'd0) begin
						if(board[5] == board[9]) begin
							{board[1], board[5], board[9], board[13]} <= {board[5]+8'd1, board[13], 8'd0, 8'd0};
							{to_left[1], to_left[5], to_left[9], to_left[13]} <= {32'd0, 32'd1, 32'd2, 32'd2};
						end
						else if(board[9] == board[13]) begin
							{board[1], board[5], board[9], board[13]} <= {board[5], board[9]+8'd1, 8'd0, 8'd0};
							{to_left[1], to_left[5], to_left[9], to_left[13]} <= {32'd0, 32'd1, 32'd1, 32'd2};
						end
						else begin
							{board[1], board[5], board[9], board[13]} <= {board[5], board[9], board[13], 8'd0};
							{to_left[1], to_left[5], to_left[9], to_left[13]} <= {32'd0, 32'd1, 32'd1, 32'd1};
						end
					end
					else begin
						if(board[1] == board[5]) begin
							if(board[9] == board[13]) begin
								{board[1], board[5], board[9], board[13]} <= {board[1]+8'd1, board[9]+8'd1, 8'd0, 8'd0};
								{to_left[1], to_left[5], to_left[9], to_left[13]} <= {32'd0, 32'd1, 32'd1, 32'd2};
							end
							else begin
								{board[1], board[5], board[9], board[13]} <= {board[1]+8'd1, board[9], board[13], 8'd0};
								{to_left[1], to_left[5], to_left[9], to_left[13]} <= {32'd0, 32'd1, 32'd1, 32'd1};
							end
						end
						else begin
							if(board[5] == board[9]) begin
								{board[1], board[5], board[9], board[13]} <= {board[1], board[5]+8'd1, board[13], 8'd0};
								{to_left[1], to_left[5], to_left[9], to_left[13]} <= {32'd0, 32'd0, 32'd1, 32'd1};
							end
							else if(board[9] == board[13]) begin
								{board[1], board[5], board[9], board[13]} <= {board[1], board[5], board[9]+8'd1, 8'd0};
								{to_left[1], to_left[5], to_left[9], to_left[13]} <= {32'd0, 32'd0, 32'd0, 32'd1};
							end
							else begin
								{board[1], board[5], board[9], board[13]} <= {board[1], board[5], board[9], board[13]};
								{to_left[1], to_left[5], to_left[9], to_left[13]} <= {32'd0, 32'd0, 32'd0, 32'd0};
							end
						end
					end
					
					if(board[2] == 8'd0 && board[6] == 8'd0 && board[10] == 8'd0 && board[14] == 8'd0) begin
						{board[2], board[6], board[10], board[14]} <= {8'd0, 8'd0, 8'd0, 8'd0};
						{to_left[2], to_left[6], to_left[10], to_left[14]} <= {32'd0, 32'd0, 32'd0, 32'd0};
					end
					else if(board[2] == 8'd0 && board[6] == 8'd0 && board[10] == 8'd0 && board[14] != 8'd0) begin
						{board[2], board[6], board[10], board[14]} <= {board[14], 8'd0, 8'd0, 8'd0};
						{to_left[2], to_left[6], to_left[10], to_left[14]} <= {32'd0, 32'd0, 32'd0, 32'd3};
					end
					else if(board[2] == 8'd0 && board[6] == 8'd0 && board[10] != 8'd0 && board[14] == 8'd0) begin
						{board[2], board[6], board[10], board[14]} <= {board[10], 8'd0, 8'd0, 8'd0};
						{to_left[2], to_left[6], to_left[10], to_left[14]} <= {32'd0, 32'd0, 32'd2, 32'd0};
					end
					else if(board[2] == 8'd0 && board[6] != 8'd0 && board[10] == 8'd0 && board[14] == 8'd0) begin
						{board[2], board[6], board[10], board[14]} <= {board[6], 8'd0, 8'd0, 8'd0};
						{to_left[2], to_left[6], to_left[10], to_left[14]} <= {32'd0, 32'd1, 32'd0, 32'd0};
					end
					else if(board[2] != 8'd0 && board[6] == 8'd0 && board[10] == 8'd0 && board[14] == 8'd0) begin
						{board[2], board[6], board[10], board[14]} <= {board[2], 8'd0, 8'd0, 8'd0};
						{to_left[2], to_left[6], to_left[10], to_left[14]} <= {32'd0, 32'd0, 32'd0, 32'd0};
					end
					else if(board[2] == 8'd0 && board[6] == 8'd0 && board[10] != 8'd0 && board[14] != 8'd0) begin
						if(board[10] != board[14]) begin
							{board[2], board[6], board[10], board[14]} <= {board[10], board[14], 8'd0, 8'd0};
							{to_left[2], to_left[6], to_left[10], to_left[14]} <= {32'd0, 32'd0, 32'd2, 32'd2};
						end
						else begin
							{board[2], board[6], board[10], board[14]} <= {board[10]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_left[2], to_left[6], to_left[10], to_left[14]} <= {32'd0, 32'd0, 32'd2, 32'd3};
						end
					end
					else if(board[2] == 8'd0 && board[6] != 8'd0 && board[10] == 8'd0 && board[14] != 8'd0) begin
						if(board[6] != board[14]) begin
							{board[2], board[6], board[10], board[14]} <= {board[6], board[14], 8'd0, 8'd0};
							{to_left[2], to_left[6], to_left[10], to_left[14]} <= {32'd0, 32'd1, 32'd0, 32'd2};
						end
						else begin
							{board[2], board[6], board[10], board[14]} <= {board[6]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_left[2], to_left[6], to_left[10], to_left[14]} <= {32'd0, 32'd1, 32'd0, 32'd3};
						end
					end
					else if(board[2] != 8'd0 && board[6] == 8'd0 && board[10] == 8'd0 && board[14] != 8'd0) begin
						if(board[2] != board[14]) begin
							{board[2], board[6], board[10], board[14]} <= {board[2], board[14], 8'd0, 8'd0};
							{to_left[2], to_left[6], to_left[10], to_left[14]} <= {32'd0, 32'd0, 32'd0, 32'd2};
						end
						else begin
							{board[2], board[6], board[10], board[14]} <= {board[2]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_left[2], to_left[6], to_left[10], to_left[14]} <= {32'd0, 32'd0, 32'd0, 32'd3};
						end
					end
					else if(board[2] == 8'd0 && board[6] != 8'd0 && board[10] != 8'd0 && board[14] == 8'd0) begin
						if(board[6] != board[10]) begin
							{board[2], board[6], board[10], board[14]} <= {board[6], board[10], 8'd0, 8'd0};
							{to_left[2], to_left[6], to_left[10], to_left[14]} <= {32'd0, 32'd1, 32'd1, 32'd0};
						end
						else begin
							{board[2], board[6], board[10], board[14]} <= {board[6]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_left[2], to_left[6], to_left[10], to_left[14]} <= {32'd0, 32'd1, 32'd2, 32'd0};
						end
					end
					else if(board[2] != 8'd0 && board[6] == 8'd0 && board[10] != 8'd0 && board[14] == 8'd0) begin
						if(board[2] != board[10]) begin
							{board[2], board[6], board[10], board[14]} <= {board[2], board[10], 8'd0, 8'd0};
							{to_left[2], to_left[6], to_left[10], to_left[14]} <= {32'd0, 32'd0, 32'd1, 32'd0};
						end
						else begin
							{board[2], board[6], board[10], board[14]} <= {board[2]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_left[2], to_left[6], to_left[10], to_left[14]} <= {32'd0, 32'd0, 32'd2, 32'd0};
						end
					end
					else if(board[2] != 8'd0 && board[6] != 8'd0 && board[10] == 8'd0 && board[14] == 8'd0) begin
						if(board[2] != board[6]) begin
							{board[2], board[6], board[10], board[14]} <= {board[2], board[6], 8'd0, 8'd0};
							{to_left[2], to_left[6], to_left[10], to_left[14]} <= {32'd0, 32'd0, 32'd0, 32'd0};
						end
						else begin
							{board[2], board[6], board[10], board[14]} <= {board[2]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_left[2], to_left[6], to_left[10], to_left[14]} <= {32'd0, 32'd1, 32'd0, 32'd0};
						end
					end
					else if(board[2] != 8'd0 && board[6] != 8'd0 && board[10] != 8'd0 && board[14] == 8'd0) begin
						if(board[2] == board[6]) begin
							{board[2], board[6], board[10], board[14]} <= {board[2]+8'd1, board[10], 8'd0, 8'd0};
							{to_left[2], to_left[6], to_left[10], to_left[14]} <= {32'd0, 32'd1, 32'd1, 32'd0};
						end
						else if(board[6] == board[10]) begin
							{board[2], board[6], board[10], board[14]} <= {board[2], board[6]+8'd1, 8'd0, 8'd0};
							{to_left[2], to_left[6], to_left[10], to_left[14]} <= {32'd0, 32'd0, 32'd1, 32'd0};
						end
						else begin
							{board[2], board[6], board[10], board[14]} <= {board[2], board[6], board[10], 8'd0};
							{to_left[2], to_left[6], to_left[10], to_left[14]} <= {32'd0, 32'd0, 32'd0, 32'd0};
						end
					end
					else if(board[2] != 8'd0 && board[6] != 8'd0 && board[10] == 8'd0 && board[14] != 8'd0) begin
						if(board[2] == board[6]) begin
							{board[2], board[6], board[10], board[14]} <= {board[2]+8'd1, board[14], 8'd0, 8'd0};
							{to_left[2], to_left[6], to_left[10], to_left[14]} <= {32'd0, 32'd1, 32'd0, 32'd2};
						end
						else if(board[6] == board[14]) begin
							{board[2], board[6], board[10], board[14]} <= {board[2], board[6]+8'd1, 8'd0, 8'd0};
							{to_left[2], to_left[6], to_left[10], to_left[14]} <= {32'd0, 32'd0, 32'd0, 32'd2};
						end
						else begin
							{board[2], board[6], board[10], board[14]} <= {board[2], board[6], board[14], 8'd0};
							{to_left[2], to_left[6], to_left[10], to_left[14]} <= {32'd0, 32'd0, 32'd0, 32'd1};
						end
					end
					else if(board[2] != 8'd0 && board[6] == 8'd0 && board[10] != 8'd0 && board[14] != 8'd0) begin
						if(board[2] == board[10]) begin
							{board[2], board[6], board[10], board[14]} <= {board[2]+8'd1, board[14], 8'd0, 8'd0};
							{to_left[2], to_left[6], to_left[10], to_left[14]} <= {32'd0, 32'd0, 32'd2, 32'd2};
						end
						else if(board[10] == board[14]) begin
							{board[2], board[6], board[10], board[14]} <= {board[2], board[10]+8'd1, 8'd0, 8'd0};
							{to_left[2], to_left[6], to_left[10], to_left[14]} <= {32'd0, 32'd0, 32'd1, 32'd2};
						end
						else begin
							{board[2], board[6], board[10], board[14]} <= {board[2], board[10], board[14], 8'd0};
							{to_left[2], to_left[6], to_left[10], to_left[14]} <= {32'd0, 32'd0, 32'd1, 32'd1};
						end
					end
					else if(board[2] == 8'd0 && board[6] != 8'd0 && board[10] != 8'd0 && board[14] != 8'd0) begin
						if(board[6] == board[10]) begin
							{board[2], board[6], board[10], board[14]} <= {board[6]+8'd1, board[14], 8'd0, 8'd0};
							{to_left[2], to_left[6], to_left[10], to_left[14]} <= {32'd0, 32'd1, 32'd2, 32'd2};
						end
						else if(board[10] == board[14]) begin
							{board[2], board[6], board[10], board[14]} <= {board[6], board[10]+8'd1, 8'd0, 8'd0};
							{to_left[2], to_left[6], to_left[10], to_left[14]} <= {32'd0, 32'd1, 32'd1, 32'd2};
						end
						else begin
							{board[2], board[6], board[10], board[14]} <= {board[6], board[10], board[14], 8'd0};
							{to_left[2], to_left[6], to_left[10], to_left[14]} <= {32'd0, 32'd1, 32'd1, 32'd1};
						end
					end
					else begin
						if(board[2] == board[6]) begin
							if(board[10] == board[14]) begin
								{board[2], board[6], board[10], board[14]} <= {board[2]+8'd1, board[10]+8'd1, 8'd0, 8'd0};
								{to_left[2], to_left[6], to_left[10], to_left[14]} <= {32'd0, 32'd1, 32'd1, 32'd2};
							end
							else begin
								{board[2], board[6], board[10], board[14]} <= {board[2]+8'd1, board[10], board[14], 8'd0};
								{to_left[2], to_left[6], to_left[10], to_left[14]} <= {32'd0, 32'd1, 32'd1, 32'd1};
							end
						end
						else begin
							if(board[6] == board[10]) begin
								{board[2], board[6], board[10], board[14]} <= {board[2], board[6]+8'd1, board[14], 8'd0};
								{to_left[2], to_left[6], to_left[10], to_left[14]} <= {32'd0, 32'd0, 32'd1, 32'd1};
							end
							else if(board[10] == board[14]) begin
								{board[2], board[6], board[10], board[14]} <= {board[2], board[6], board[10]+8'd1, 8'd0};
								{to_left[2], to_left[6], to_left[10], to_left[14]} <= {32'd0, 32'd0, 32'd0, 32'd1};
							end
							else begin
								{board[2], board[6], board[10], board[14]} <= {board[2], board[6], board[10], board[14]};
								{to_left[2], to_left[6], to_left[10], to_left[14]} <= {32'd0, 32'd0, 32'd0, 32'd0};
							end
						end
					end
					
					if(board[3] == 8'd0 && board[7] == 8'd0 && board[11] == 8'd0 && board[15] == 8'd0) begin
						{board[3], board[7], board[11], board[15]} <= {8'd0, 8'd0, 8'd0, 8'd0};
						{to_left[3], to_left[7], to_left[11], to_left[15]} <= {32'd0, 32'd0, 32'd0, 32'd0};
					end
					else if(board[3] == 8'd0 && board[7] == 8'd0 && board[11] == 8'd0 && board[15] != 8'd0) begin
						{board[3], board[7], board[11], board[15]} <= {board[15], 8'd0, 8'd0, 8'd0};
						{to_left[3], to_left[7], to_left[11], to_left[15]} <= {32'd0, 32'd0, 32'd0, 32'd3};
					end
					else if(board[3] == 8'd0 && board[7] == 8'd0 && board[11] != 8'd0 && board[15] == 8'd0) begin
						{board[3], board[7], board[11], board[15]} <= {board[11], 8'd0, 8'd0, 8'd0};
						{to_left[3], to_left[7], to_left[11], to_left[15]} <= {32'd0, 32'd0, 32'd2, 32'd0};
					end
					else if(board[3] == 8'd0 && board[7] != 8'd0 && board[11] == 8'd0 && board[15] == 8'd0) begin
						{board[3], board[7], board[11], board[15]} <= {board[7], 8'd0, 8'd0, 8'd0};
						{to_left[3], to_left[7], to_left[11], to_left[15]} <= {32'd0, 32'd1, 32'd0, 32'd0};
					end
					else if(board[3] != 8'd0 && board[7] == 8'd0 && board[11] == 8'd0 && board[15] == 8'd0) begin
						{board[3], board[7], board[11], board[15]} <= {board[3], 8'd0, 8'd0, 8'd0};
						{to_left[3], to_left[7], to_left[11], to_left[15]} <= {32'd0, 32'd0, 32'd0, 32'd0};
					end
					else if(board[3] == 8'd0 && board[7] == 8'd0 && board[11] != 8'd0 && board[15] != 8'd0) begin
						if(board[11] != board[15]) begin
							{board[3], board[7], board[11], board[15]} <= {board[11], board[15], 8'd0, 8'd0};
							{to_left[3], to_left[7], to_left[11], to_left[15]} <= {32'd0, 32'd0, 32'd2, 32'd2};
						end
						else begin
							{board[3], board[7], board[11], board[15]} <= {board[11]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_left[3], to_left[7], to_left[11], to_left[15]} <= {32'd0, 32'd0, 32'd2, 32'd3};
						end
					end
					else if(board[3] == 8'd0 && board[7] != 8'd0 && board[11] == 8'd0 && board[15] != 8'd0) begin
						if(board[7] != board[15]) begin
							{board[3], board[7], board[11], board[15]} <= {board[7], board[15], 8'd0, 8'd0};
							{to_left[3], to_left[7], to_left[11], to_left[15]} <= {32'd0, 32'd1, 32'd0, 32'd2};
						end
						else begin
							{board[3], board[7], board[11], board[15]} <= {board[7]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_left[3], to_left[7], to_left[11], to_left[15]} <= {32'd0, 32'd1, 32'd0, 32'd3};
						end
					end
					else if(board[3] != 8'd0 && board[7] == 8'd0 && board[11] == 8'd0 && board[15] != 8'd0) begin
						if(board[3] != board[15]) begin
							{board[3], board[7], board[11], board[15]} <= {board[3], board[15], 8'd0, 8'd0};
							{to_left[3], to_left[7], to_left[11], to_left[15]} <= {32'd0, 32'd0, 32'd0, 32'd2};
						end
						else begin
							{board[3], board[7], board[11], board[15]} <= {board[3]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_left[3], to_left[7], to_left[11], to_left[15]} <= {32'd0, 32'd0, 32'd0, 32'd3};
						end
					end
					else if(board[3] == 8'd0 && board[7] != 8'd0 && board[11] != 8'd0 && board[15] == 8'd0) begin
						if(board[7] != board[11]) begin
							{board[3], board[7], board[11], board[15]} <= {board[7], board[11], 8'd0, 8'd0};
							{to_left[3], to_left[7], to_left[11], to_left[15]} <= {32'd0, 32'd1, 32'd1, 32'd0};
						end
						else begin
							{board[3], board[7], board[11], board[15]} <= {board[7]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_left[3], to_left[7], to_left[11], to_left[15]} <= {32'd0, 32'd1, 32'd2, 32'd0};
						end
					end
					else if(board[3] != 8'd0 && board[7] == 8'd0 && board[11] != 8'd0 && board[15] == 8'd0) begin
						if(board[3] != board[11]) begin
							{board[3], board[7], board[11], board[15]} <= {board[3], board[11], 8'd0, 8'd0};
							{to_left[3], to_left[7], to_left[11], to_left[15]} <= {32'd0, 32'd0, 32'd1, 32'd0};
						end
						else begin
							{board[3], board[7], board[11], board[15]} <= {board[3]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_left[3], to_left[7], to_left[11], to_left[15]} <= {32'd0, 32'd0, 32'd2, 32'd0};
						end
					end
					else if(board[3] != 8'd0 && board[7] != 8'd0 && board[11] == 8'd0 && board[15] == 8'd0) begin
						if(board[3] != board[7]) begin
							{board[3], board[7], board[11], board[15]} <= {board[3], board[7], 8'd0, 8'd0};
							{to_left[3], to_left[7], to_left[11], to_left[15]} <= {32'd0, 32'd0, 32'd0, 32'd0};
						end
						else begin
							{board[3], board[7], board[11], board[15]} <= {board[3]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_left[3], to_left[7], to_left[11], to_left[15]} <= {32'd0, 32'd1, 32'd0, 32'd0};
						end
					end
					else if(board[3] != 8'd0 && board[7] != 8'd0 && board[11] != 8'd0 && board[15] == 8'd0) begin
						if(board[3] == board[7]) begin
							{board[3], board[7], board[11], board[15]} <= {board[3]+8'd1, board[11], 8'd0, 8'd0};
							{to_left[3], to_left[7], to_left[11], to_left[15]} <= {32'd0, 32'd1, 32'd1, 32'd0};
						end
						else if(board[7] == board[11]) begin
							{board[3], board[7], board[11], board[15]} <= {board[3], board[7]+8'd1, 8'd0, 8'd0};
							{to_left[3], to_left[7], to_left[11], to_left[15]} <= {32'd0, 32'd0, 32'd1, 32'd0};
						end
						else begin
							{board[3], board[7], board[11], board[15]} <= {board[3], board[7], board[11], 8'd0};
							{to_left[3], to_left[7], to_left[11], to_left[15]} <= {32'd0, 32'd0, 32'd0, 32'd0};
						end
					end
					else if(board[3] != 8'd0 && board[7] != 8'd0 && board[11] == 8'd0 && board[15] != 8'd0) begin
						if(board[3] == board[7]) begin
							{board[3], board[7], board[11], board[15]} <= {board[3]+8'd1, board[15], 8'd0, 8'd0};
							{to_left[3], to_left[7], to_left[11], to_left[15]} <= {32'd0, 32'd1, 32'd0, 32'd2};
						end
						else if(board[7] == board[15]) begin
							{board[3], board[7], board[11], board[15]} <= {board[3], board[7]+8'd1, 8'd0, 8'd0};
							{to_left[3], to_left[7], to_left[11], to_left[15]} <= {32'd0, 32'd0, 32'd0, 32'd2};
						end
						else begin
							{board[3], board[7], board[11], board[15]} <= {board[3], board[7], board[15], 8'd0};
							{to_left[3], to_left[7], to_left[11], to_left[15]} <= {32'd0, 32'd0, 32'd0, 32'd1};
						end
					end
					else if(board[3] != 8'd0 && board[7] == 8'd0 && board[11] != 8'd0 && board[15] != 8'd0) begin
						if(board[3] == board[11]) begin
							{board[3], board[7], board[11], board[15]} <= {board[3]+8'd1, board[15], 8'd0, 8'd0};
							{to_left[3], to_left[7], to_left[11], to_left[15]} <= {32'd0, 32'd0, 32'd2, 32'd2};
						end
						else if(board[11] == board[15]) begin
							{board[3], board[7], board[11], board[15]} <= {board[3], board[11]+8'd1, 8'd0, 8'd0};
							{to_left[3], to_left[7], to_left[11], to_left[15]} <= {32'd0, 32'd0, 32'd1, 32'd2};
						end
						else begin
							{board[3], board[7], board[11], board[15]} <= {board[3], board[11], board[15], 8'd0};
							{to_left[3], to_left[7], to_left[11], to_left[15]} <= {32'd0, 32'd0, 32'd1, 32'd1};
						end
					end
					else if(board[3] == 8'd0 && board[7] != 8'd0 && board[11] != 8'd0 && board[15] != 8'd0) begin
						if(board[7] == board[11]) begin
							{board[3], board[7], board[11], board[15]} <= {board[7]+8'd1, board[15], 8'd0, 8'd0};
							{to_left[3], to_left[7], to_left[11], to_left[15]} <= {32'd0, 32'd1, 32'd2, 32'd2};
						end
						else if(board[11] == board[15]) begin
							{board[3], board[7], board[11], board[15]} <= {board[7], board[11]+8'd1, 8'd0, 8'd0};
							{to_left[3], to_left[7], to_left[11], to_left[15]} <= {32'd0, 32'd1, 32'd1, 32'd2};
						end
						else begin
							{board[3], board[7], board[11], board[15]} <= {board[7], board[11], board[15], 8'd0};
							{to_left[3], to_left[7], to_left[11], to_left[15]} <= {32'd0, 32'd1, 32'd1, 32'd1};
						end
					end
					else begin
						if(board[3] == board[7]) begin
							if(board[11] == board[15]) begin
								{board[3], board[7], board[11], board[15]} <= {board[3]+8'd1, board[11]+8'd1, 8'd0, 8'd0};
								{to_left[3], to_left[7], to_left[11], to_left[15]} <= {32'd0, 32'd1, 32'd1, 32'd2};
							end
							else begin
								{board[3], board[7], board[11], board[15]} <= {board[3]+8'd1, board[11], board[15], 8'd0};
								{to_left[3], to_left[7], to_left[11], to_left[15]} <= {32'd0, 32'd1, 32'd1, 32'd1};
							end
						end
						else begin
							if(board[7] == board[11]) begin
								{board[3], board[7], board[11], board[15]} <= {board[3], board[7]+8'd1, board[15], 8'd0};
								{to_left[3], to_left[7], to_left[11], to_left[15]} <= {32'd0, 32'd0, 32'd1, 32'd1};
							end
							else if(board[11] == board[15]) begin
								{board[3], board[7], board[11], board[15]} <= {board[3], board[7], board[11]+8'd1, 8'd0};
								{to_left[3], to_left[7], to_left[11], to_left[15]} <= {32'd0, 32'd0, 32'd0, 32'd1};
							end
							else begin
								{board[3], board[7], board[11], board[15]} <= {board[3], board[7], board[11], board[15]};
								{to_left[3], to_left[7], to_left[11], to_left[15]} <= {32'd0, 32'd0, 32'd0, 32'd0};
							end
						end
					end
				end
				else if(!up && !activeflag) begin
					if(board[0] == 8'd0 && board[1] == 8'd0 && board[2] == 8'd0 && board[3] == 8'd0) begin
						{board[0], board[1], board[2], board[3]} <= {8'd0, 8'd0, 8'd0, 8'd0};
						{to_up[0], to_up[1], to_up[2], to_up[3]} <= {32'd0, 32'd0, 32'd0, 32'd0};
					end
					else if(board[0] == 8'd0 && board[1] == 8'd0 && board[2] == 8'd0 && board[3] != 8'd0) begin
						{board[0], board[1], board[2], board[3]} <= {board[3], 8'd0, 8'd0, 8'd0};
						{to_up[0], to_up[1], to_up[2], to_up[3]} <= {32'd0, 32'd0, 32'd0, 32'd3};
					end
					else if(board[0] == 8'd0 && board[1] == 8'd0 && board[2] != 8'd0 && board[3] == 8'd0) begin
						{board[0], board[1], board[2], board[3]} <= {board[2], 8'd0, 8'd0, 8'd0};
						{to_up[0], to_up[1], to_up[2], to_up[3]} <= {32'd0, 32'd0, 32'd2, 32'd0};
					end
					else if(board[0] == 8'd0 && board[1] != 8'd0 && board[2] == 8'd0 && board[3] == 8'd0) begin
						{board[0], board[1], board[2], board[3]} <= {board[1], 8'd0, 8'd0, 8'd0};
						{to_up[0], to_up[1], to_up[2], to_up[3]} <= {32'd0, 32'd1, 32'd0, 32'd0};
					end
					else if(board[0] != 8'd0 && board[1] == 8'd0 && board[2] == 8'd0 && board[3] == 8'd0) begin
						{board[0], board[1], board[2], board[3]} <= {board[0], 8'd0, 8'd0, 8'd0};
						{to_up[0], to_up[1], to_up[2], to_up[3]} <= {32'd0, 32'd0, 32'd0, 32'd0};
					end
					else if(board[0] == 8'd0 && board[1] == 8'd0 && board[2] != 8'd0 && board[3] != 8'd0) begin
						if(board[2] != board[3]) begin
							{board[0], board[1], board[2], board[3]} <= {board[2], board[3], 8'd0, 8'd0};
							{to_up[0], to_up[1], to_up[2], to_up[3]} <= {32'd0, 32'd0, 32'd2, 32'd2};
						end
						else begin
							{board[0], board[1], board[2], board[3]} <= {board[2]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_up[0], to_up[1], to_up[2], to_up[3]} <= {32'd0, 32'd0, 32'd2, 32'd3};
						end
					end
					else if(board[0] == 8'd0 && board[1] != 8'd0 && board[2] == 8'd0 && board[3] != 8'd0) begin
						if(board[1] != board[3]) begin
							{board[0], board[1], board[2], board[3]} <= {board[1], board[3], 8'd0, 8'd0};
							{to_up[0], to_up[1], to_up[2], to_up[3]} <= {32'd0, 32'd1, 32'd0, 32'd2};
						end
						else begin
							{board[0], board[1], board[2], board[3]} <= {board[1]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_up[0], to_up[1], to_up[2], to_up[3]} <= {32'd0, 32'd1, 32'd0, 32'd3};
						end
					end
					else if(board[0] != 8'd0 && board[1] == 8'd0 && board[2] == 8'd0 && board[3] != 8'd0) begin
						if(board[0] != board[3]) begin
							{board[0], board[1], board[2], board[3]} <= {board[0], board[3], 8'd0, 8'd0};
							{to_up[0], to_up[1], to_up[2], to_up[3]} <= {32'd0, 32'd0, 32'd0, 32'd2};
						end
						else begin
							{board[0], board[1], board[2], board[3]} <= {board[0]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_up[0], to_up[1], to_up[2], to_up[3]} <= {32'd0, 32'd0, 32'd0, 32'd3};
						end
					end
					else if(board[0] == 8'd0 && board[1] != 8'd0 && board[2] != 8'd0 && board[3] == 8'd0) begin
						if(board[1] != board[2]) begin
							{board[0], board[1], board[2], board[3]} <= {board[1], board[2], 8'd0, 8'd0};
							{to_up[0], to_up[1], to_up[2], to_up[3]} <= {32'd0, 32'd1, 32'd1, 32'd0};
						end
						else begin
							{board[0], board[1], board[2], board[3]} <= {board[1]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_up[0], to_up[1], to_up[2], to_up[3]} <= {32'd0, 32'd1, 32'd2, 32'd0};
						end
					end
					else if(board[0] != 8'd0 && board[1] == 8'd0 && board[2] != 8'd0 && board[3] == 8'd0) begin
						if(board[0] != board[2]) begin
							{board[0], board[1], board[2], board[3]} <= {board[0], board[2], 8'd0, 8'd0};
							{to_up[0], to_up[1], to_up[2], to_up[3]} <= {32'd0, 32'd0, 32'd1, 32'd0};
						end
						else begin
							{board[0], board[1], board[2], board[3]} <= {board[0]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_up[0], to_up[1], to_up[2], to_up[3]} <= {32'd0, 32'd0, 32'd2, 32'd0};
						end
					end
					else if(board[0] != 8'd0 && board[1] != 8'd0 && board[2] == 8'd0 && board[3] == 8'd0) begin
						if(board[0] != board[1]) begin
							{board[0], board[1], board[2], board[3]} <= {board[0], board[1], 8'd0, 8'd0};
							{to_up[0], to_up[1], to_up[2], to_up[3]} <= {32'd0, 32'd0, 32'd0, 32'd0};
						end
						else begin
							{board[0], board[1], board[2], board[3]} <= {board[0]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_up[0], to_up[1], to_up[2], to_up[3]} <= {32'd0, 32'd1, 32'd0, 32'd0};
						end
					end
					else if(board[0] != 8'd0 && board[1] != 8'd0 && board[2] != 8'd0 && board[3] == 8'd0) begin
						if(board[0] == board[1]) begin
							{board[0], board[1], board[2], board[3]} <= {board[0]+8'd1, board[2], 8'd0, 8'd0};
							{to_up[0], to_up[1], to_up[2], to_up[3]} <= {32'd0, 32'd1, 32'd1, 32'd0};
						end
						else if(board[1] == board[2]) begin
							{board[0], board[1], board[2], board[3]} <= {board[0], board[1]+8'd1, 8'd0, 8'd0};
							{to_up[0], to_up[1], to_up[2], to_up[3]} <= {32'd0, 32'd0, 32'd1, 32'd0};
						end
						else begin
							{board[0], board[1], board[2], board[3]} <= {board[0], board[1], board[2], 8'd0};
							{to_up[0], to_up[1], to_up[2], to_up[3]} <= {32'd0, 32'd0, 32'd0, 32'd0};
						end
					end
					else if(board[0] != 8'd0 && board[1] != 8'd0 && board[2] == 8'd0 && board[3] != 8'd0) begin
						if(board[0] == board[1]) begin
							{board[0], board[1], board[2], board[3]} <= {board[0]+8'd1, board[3], 8'd0, 8'd0};
							{to_up[0], to_up[1], to_up[2], to_up[3]} <= {32'd0, 32'd1, 32'd0, 32'd2};
						end
						else if(board[1] == board[3]) begin
							{board[0], board[1], board[2], board[3]} <= {board[0], board[1]+8'd1, 8'd0, 8'd0};
							{to_up[0], to_up[1], to_up[2], to_up[3]} <= {32'd0, 32'd0, 32'd0, 32'd2};
						end
						else begin
							{board[0], board[1], board[2], board[3]} <= {board[0], board[1], board[3], 8'd0};
							{to_up[0], to_up[1], to_up[2], to_up[3]} <= {32'd0, 32'd0, 32'd0, 32'd1};
						end
					end
					else if(board[0] != 8'd0 && board[1] == 8'd0 && board[2] != 8'd0 && board[3] != 8'd0) begin
						if(board[0] == board[2]) begin
							{board[0], board[1], board[2], board[3]} <= {board[0]+8'd1, board[3], 8'd0, 8'd0};
							{to_up[0], to_up[1], to_up[2], to_up[3]} <= {32'd0, 32'd0, 32'd2, 32'd2};
						end
						else if(board[2] == board[3]) begin
							{board[0], board[1], board[2], board[3]} <= {board[0], board[2]+8'd1, 8'd0, 8'd0};
							{to_up[0], to_up[1], to_up[2], to_up[3]} <= {32'd0, 32'd0, 32'd1, 32'd2};
						end
						else begin
							{board[0], board[1], board[2], board[3]} <= {board[0], board[2], board[3], 8'd0};
							{to_up[0], to_up[1], to_up[2], to_up[3]} <= {32'd0, 32'd0, 32'd1, 32'd1};
						end
					end
					else if(board[0] == 8'd0 && board[1] != 8'd0 && board[2] != 8'd0 && board[3] != 8'd0) begin
						if(board[1] == board[2]) begin
							{board[0], board[1], board[2], board[3]} <= {board[1]+8'd1, board[3], 8'd0, 8'd0};
							{to_up[0], to_up[1], to_up[2], to_up[3]} <= {32'd0, 32'd1, 32'd2, 32'd2};
						end
						else if(board[2] == board[3]) begin
							{board[0], board[1], board[2], board[3]} <= {board[1], board[2]+8'd1, 8'd0, 8'd0};
							{to_up[0], to_up[1], to_up[2], to_up[3]} <= {32'd0, 32'd1, 32'd1, 32'd2};
						end
						else begin
							{board[0], board[1], board[2], board[3]} <= {board[1], board[2], board[3], 8'd0};
							{to_up[0], to_up[1], to_up[2], to_up[3]} <= {32'd0, 32'd1, 32'd1, 32'd1};
						end
					end
					else begin
						if(board[0] == board[1]) begin
							if(board[2] == board[3]) begin
								{board[0], board[1], board[2], board[3]} <= {board[0]+8'd1, board[2]+8'd1, 8'd0, 8'd0};
								{to_up[0], to_up[1], to_up[2], to_up[3]} <= {32'd0, 32'd1, 32'd1, 32'd2};
							end
							else begin
								{board[0], board[1], board[2], board[3]} <= {board[0]+8'd1, board[2], board[3], 8'd0};
								{to_up[0], to_up[1], to_up[2], to_up[3]} <= {32'd0, 32'd1, 32'd1, 32'd1};
							end
						end
						else begin
							if(board[1] == board[2]) begin
								{board[0], board[1], board[2], board[3]} <= {board[0], board[1]+8'd1, board[3], 8'd0};
								{to_up[0], to_up[1], to_up[2], to_up[3]} <= {32'd0, 32'd0, 32'd1, 32'd1};
							end
							else if(board[2] == board[3]) begin
								{board[0], board[1], board[2], board[3]} <= {board[0], board[1], board[2]+8'd1, 8'd0};
								{to_up[0], to_up[1], to_up[2], to_up[3]} <= {32'd0, 32'd0, 32'd0, 32'd1};
							end
							else begin
								{board[0], board[1], board[2], board[3]} <= {board[0], board[1], board[2], board[3]};
								{to_up[0], to_up[1], to_up[2], to_up[3]} <= {32'd0, 32'd0, 32'd0, 32'd0};
							end
						end
					end
					
					if(board[4] == 8'd0 && board[5] == 8'd0 && board[6] == 8'd0 && board[7] == 8'd0) begin
						{board[4], board[5], board[6], board[7]} <= {8'd0, 8'd0, 8'd0, 8'd0};
						{to_up[4], to_up[5], to_up[6], to_up[7]} <= {32'd0, 32'd0, 32'd0, 32'd0};
					end
					else if(board[4] == 8'd0 && board[5] == 8'd0 && board[6] == 8'd0 && board[7] != 8'd0) begin
						{board[4], board[5], board[6], board[7]} <= {board[7], 8'd0, 8'd0, 8'd0};
						{to_up[4], to_up[5], to_up[6], to_up[7]} <= {32'd0, 32'd0, 32'd0, 32'd3};
					end
					else if(board[4] == 8'd0 && board[5] == 8'd0 && board[6] != 8'd0 && board[7] == 8'd0) begin
						{board[4], board[5], board[6], board[7]} <= {board[6], 8'd0, 8'd0, 8'd0};
						{to_up[4], to_up[5], to_up[6], to_up[7]} <= {32'd0, 32'd0, 32'd2, 32'd0};
					end
					else if(board[4] == 8'd0 && board[5] != 8'd0 && board[6] == 8'd0 && board[7] == 8'd0) begin
						{board[4], board[5], board[6], board[7]} <= {board[5], 8'd0, 8'd0, 8'd0};
						{to_up[4], to_up[5], to_up[6], to_up[7]} <= {32'd0, 32'd1, 32'd0, 32'd0};
					end
					else if(board[4] != 8'd0 && board[5] == 8'd0 && board[6] == 8'd0 && board[7] == 8'd0) begin
						{board[4], board[5], board[6], board[7]} <= {board[4], 8'd0, 8'd0, 8'd0};
						{to_up[4], to_up[5], to_up[6], to_up[7]} <= {32'd0, 32'd0, 32'd0, 32'd0};
					end
					else if(board[4] == 8'd0 && board[5] == 8'd0 && board[6] != 8'd0 && board[7] != 8'd0) begin
						if(board[6] != board[7]) begin
							{board[4], board[5], board[6], board[7]} <= {board[6], board[7], 8'd0, 8'd0};
							{to_up[4], to_up[5], to_up[6], to_up[7]} <= {32'd0, 32'd0, 32'd2, 32'd2};
						end
						else begin
							{board[4], board[5], board[6], board[7]} <= {board[6]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_up[4], to_up[5], to_up[6], to_up[7]} <= {32'd0, 32'd0, 32'd2, 32'd3};
						end
					end
					else if(board[4] == 8'd0 && board[5] != 8'd0 && board[6] == 8'd0 && board[7] != 8'd0) begin
						if(board[5] != board[7]) begin
							{board[4], board[5], board[6], board[7]} <= {board[5], board[7], 8'd0, 8'd0};
							{to_up[4], to_up[5], to_up[6], to_up[7]} <= {32'd0, 32'd1, 32'd0, 32'd2};
						end
						else begin
							{board[4], board[5], board[6], board[7]} <= {board[5]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_up[4], to_up[5], to_up[6], to_up[7]} <= {32'd0, 32'd1, 32'd0, 32'd3};
						end
					end
					else if(board[4] != 8'd0 && board[5] == 8'd0 && board[6] == 8'd0 && board[7] != 8'd0) begin
						if(board[4] != board[7]) begin
							{board[4], board[5], board[6], board[7]} <= {board[4], board[7], 8'd0, 8'd0};
							{to_up[4], to_up[5], to_up[6], to_up[7]} <= {32'd0, 32'd0, 32'd0, 32'd2};
						end
						else begin
							{board[4], board[5], board[6], board[7]} <= {board[4]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_up[4], to_up[5], to_up[6], to_up[7]} <= {32'd0, 32'd0, 32'd0, 32'd3};
						end
					end
					else if(board[4] == 8'd0 && board[5] != 8'd0 && board[6] != 8'd0 && board[7] == 8'd0) begin
						if(board[5] != board[6]) begin
							{board[4], board[5], board[6], board[7]} <= {board[5], board[6], 8'd0, 8'd0};
							{to_up[4], to_up[5], to_up[6], to_up[7]} <= {32'd0, 32'd1, 32'd1, 32'd0};
						end
						else begin
							{board[4], board[5], board[6], board[7]} <= {board[5]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_up[4], to_up[5], to_up[6], to_up[7]} <= {32'd0, 32'd1, 32'd2, 32'd0};
						end
					end
					else if(board[4] != 8'd0 && board[5] == 8'd0 && board[6] != 8'd0 && board[7] == 8'd0) begin
						if(board[4] != board[6]) begin
							{board[4], board[5], board[6], board[7]} <= {board[4], board[6], 8'd0, 8'd0};
							{to_up[4], to_up[5], to_up[6], to_up[7]} <= {32'd0, 32'd0, 32'd1, 32'd0};
						end
						else begin
							{board[4], board[5], board[6], board[7]} <= {board[4]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_up[4], to_up[5], to_up[6], to_up[7]} <= {32'd0, 32'd0, 32'd2, 32'd0};
						end
					end
					else if(board[4] != 8'd0 && board[5] != 8'd0 && board[6] == 8'd0 && board[7] == 8'd0) begin
						if(board[4] != board[5]) begin
							{board[4], board[5], board[6], board[7]} <= {board[4], board[5], 8'd0, 8'd0};
							{to_up[4], to_up[5], to_up[6], to_up[7]} <= {32'd0, 32'd0, 32'd0, 32'd0};
						end
						else begin
							{board[4], board[5], board[6], board[7]} <= {board[4]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_up[4], to_up[5], to_up[6], to_up[7]} <= {32'd0, 32'd1, 32'd0, 32'd0};
						end
					end
					else if(board[4] != 8'd0 && board[5] != 8'd0 && board[6] != 8'd0 && board[7] == 8'd0) begin
						if(board[4] == board[5]) begin
							{board[4], board[5], board[6], board[7]} <= {board[4]+8'd1, board[6], 8'd0, 8'd0};
							{to_up[4], to_up[5], to_up[6], to_up[7]} <= {32'd0, 32'd1, 32'd1, 32'd0};
						end
						else if(board[5] == board[6]) begin
							{board[4], board[5], board[6], board[7]} <= {board[4], board[5]+8'd1, 8'd0, 8'd0};
							{to_up[4], to_up[5], to_up[6], to_up[7]} <= {32'd0, 32'd0, 32'd1, 32'd0};
						end
						else begin
							{board[4], board[5], board[6], board[7]} <= {board[4], board[5], board[6], 8'd0};
							{to_up[4], to_up[5], to_up[6], to_up[7]} <= {32'd0, 32'd0, 32'd0, 32'd0};
						end
					end
					else if(board[4] != 8'd0 && board[5] != 8'd0 && board[6] == 8'd0 && board[7] != 8'd0) begin
						if(board[4] == board[5]) begin
							{board[4], board[5], board[6], board[7]} <= {board[4]+8'd1, board[7], 8'd0, 8'd0};
							{to_up[4], to_up[5], to_up[6], to_up[7]} <= {32'd0, 32'd1, 32'd0, 32'd2};
						end
						else if(board[5] == board[7]) begin
							{board[4], board[5], board[6], board[7]} <= {board[4], board[5]+8'd1, 8'd0, 8'd0};
							{to_up[4], to_up[5], to_up[6], to_up[7]} <= {32'd0, 32'd0, 32'd0, 32'd2};
						end
						else begin
							{board[4], board[5], board[6], board[7]} <= {board[4], board[5], board[7], 8'd0};
							{to_up[4], to_up[5], to_up[6], to_up[7]} <= {32'd0, 32'd0, 32'd0, 32'd1};
						end
					end
					else if(board[4] != 8'd0 && board[5] == 8'd0 && board[6] != 8'd0 && board[7] != 8'd0) begin
						if(board[4] == board[6]) begin
							{board[4], board[5], board[6], board[7]} <= {board[4]+8'd1, board[7], 8'd0, 8'd0};
							{to_up[4], to_up[5], to_up[6], to_up[7]} <= {32'd0, 32'd0, 32'd2, 32'd2};
						end
						else if(board[6] == board[7]) begin
							{board[4], board[5], board[6], board[7]} <= {board[4], board[6]+8'd1, 8'd0, 8'd0};
							{to_up[4], to_up[5], to_up[6], to_up[7]} <= {32'd0, 32'd0, 32'd1, 32'd2};
						end
						else begin
							{board[4], board[5], board[6], board[7]} <= {board[4], board[6], board[7], 8'd0};
							{to_up[4], to_up[5], to_up[6], to_up[7]} <= {32'd0, 32'd0, 32'd1, 32'd1};
						end
					end
					else if(board[4] == 8'd0 && board[5] != 8'd0 && board[6] != 8'd0 && board[7] != 8'd0) begin
						if(board[5] == board[6]) begin
							{board[4], board[5], board[6], board[7]} <= {board[5]+8'd1, board[7], 8'd0, 8'd0};
							{to_up[4], to_up[5], to_up[6], to_up[7]} <= {32'd0, 32'd1, 32'd2, 32'd2};
						end
						else if(board[6] == board[7]) begin
							{board[4], board[5], board[6], board[7]} <= {board[5], board[6]+8'd1, 8'd0, 8'd0};
							{to_up[4], to_up[5], to_up[6], to_up[7]} <= {32'd0, 32'd1, 32'd1, 32'd2};
						end
						else begin
							{board[4], board[5], board[6], board[7]} <= {board[5], board[6], board[7], 8'd0};
							{to_up[4], to_up[5], to_up[6], to_up[7]} <= {32'd0, 32'd1, 32'd1, 32'd1};
						end
					end
					else begin
						if(board[4] == board[5]) begin
							if(board[6] == board[7]) begin
								{board[4], board[5], board[6], board[7]} <= {board[4]+8'd1, board[6]+8'd1, 8'd0, 8'd0};
								{to_up[4], to_up[5], to_up[6], to_up[7]} <= {32'd0, 32'd1, 32'd1, 32'd2};
							end
							else begin
								{board[4], board[5], board[6], board[7]} <= {board[4]+8'd1, board[6], board[7], 8'd0};
								{to_up[4], to_up[5], to_up[6], to_up[7]} <= {32'd0, 32'd1, 32'd1, 32'd1};
							end
						end
						else begin
							if(board[5] == board[6]) begin
								{board[4], board[5], board[6], board[7]} <= {board[4], board[5]+8'd1, board[7], 8'd0};
								{to_up[4], to_up[5], to_up[6], to_up[7]} <= {32'd0, 32'd0, 32'd1, 32'd1};
							end
							else if(board[6] == board[7]) begin
								{board[4], board[5], board[6], board[7]} <= {board[4], board[5], board[6]+8'd1, 8'd0};
								{to_up[4], to_up[5], to_up[6], to_up[7]} <= {32'd0, 32'd0, 32'd0, 32'd1};
							end
							else begin
								{board[4], board[5], board[6], board[7]} <= {board[4], board[5], board[6], board[7]};
								{to_up[4], to_up[5], to_up[6], to_up[7]} <= {32'd0, 32'd0, 32'd0, 32'd0};
							end
						end
					end
					
					if(board[8] == 8'd0 && board[9] == 8'd0 && board[10] == 8'd0 && board[11] == 8'd0) begin
						{board[8], board[9], board[10], board[11]} <= {8'd0, 8'd0, 8'd0, 8'd0};
						{to_up[8], to_up[9], to_up[10], to_up[11]} <= {32'd0, 32'd0, 32'd0, 32'd0};
					end
					else if(board[8] == 8'd0 && board[9] == 8'd0 && board[10] == 8'd0 && board[11] != 8'd0) begin
						{board[8], board[9], board[10], board[11]} <= {board[11], 8'd0, 8'd0, 8'd0};
						{to_up[8], to_up[9], to_up[10], to_up[11]} <= {32'd0, 32'd0, 32'd0, 32'd3};
					end
					else if(board[8] == 8'd0 && board[9] == 8'd0 && board[10] != 8'd0 && board[11] == 8'd0) begin
						{board[8], board[9], board[10], board[11]} <= {board[10], 8'd0, 8'd0, 8'd0};
						{to_up[8], to_up[9], to_up[10], to_up[11]} <= {32'd0, 32'd0, 32'd2, 32'd0};
					end
					else if(board[8] == 8'd0 && board[9] != 8'd0 && board[10] == 8'd0 && board[11] == 8'd0) begin
						{board[8], board[9], board[10], board[11]} <= {board[9], 8'd0, 8'd0, 8'd0};
						{to_up[8], to_up[9], to_up[10], to_up[11]} <= {32'd0, 32'd1, 32'd0, 32'd0};
					end
					else if(board[8] != 8'd0 && board[9] == 8'd0 && board[10] == 8'd0 && board[11] == 8'd0) begin
						{board[8], board[9], board[10], board[11]} <= {board[8], 8'd0, 8'd0, 8'd0};
						{to_up[8], to_up[9], to_up[10], to_up[11]} <= {32'd0, 32'd0, 32'd0, 32'd0};
					end
					else if(board[8] == 8'd0 && board[9] == 8'd0 && board[10] != 8'd0 && board[11] != 8'd0) begin
						if(board[10] != board[11]) begin
							{board[8], board[9], board[10], board[11]} <= {board[10], board[11], 8'd0, 8'd0};
							{to_up[8], to_up[9], to_up[10], to_up[11]} <= {32'd0, 32'd0, 32'd2, 32'd2};
						end
						else begin
							{board[8], board[9], board[10], board[11]} <= {board[10]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_up[8], to_up[9], to_up[10], to_up[11]} <= {32'd0, 32'd0, 32'd2, 32'd3};
						end
					end
					else if(board[8] == 8'd0 && board[9] != 8'd0 && board[10] == 8'd0 && board[11] != 8'd0) begin
						if(board[9] != board[11]) begin
							{board[8], board[9], board[10], board[11]} <= {board[9], board[11], 8'd0, 8'd0};
							{to_up[8], to_up[9], to_up[10], to_up[11]} <= {32'd0, 32'd1, 32'd0, 32'd2};
						end
						else begin
							{board[8], board[9], board[10], board[11]} <= {board[9]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_up[8], to_up[9], to_up[10], to_up[11]} <= {32'd0, 32'd1, 32'd0, 32'd3};
						end
					end
					else if(board[8] != 8'd0 && board[9] == 8'd0 && board[10] == 8'd0 && board[11] != 8'd0) begin
						if(board[8] != board[11]) begin
							{board[8], board[9], board[10], board[11]} <= {board[8], board[11], 8'd0, 8'd0};
							{to_up[8], to_up[9], to_up[10], to_up[11]} <= {32'd0, 32'd0, 32'd0, 32'd2};
						end
						else begin
							{board[8], board[9], board[10], board[11]} <= {board[8]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_up[8], to_up[9], to_up[10], to_up[11]} <= {32'd0, 32'd0, 32'd0, 32'd3};
						end
					end
					else if(board[8] == 8'd0 && board[9] != 8'd0 && board[10] != 8'd0 && board[11] == 8'd0) begin
						if(board[9] != board[10]) begin
							{board[8], board[9], board[10], board[11]} <= {board[9], board[10], 8'd0, 8'd0};
							{to_up[8], to_up[9], to_up[10], to_up[11]} <= {32'd0, 32'd1, 32'd1, 32'd0};
						end
						else begin
							{board[8], board[9], board[10], board[11]} <= {board[9]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_up[8], to_up[9], to_up[10], to_up[11]} <= {32'd0, 32'd1, 32'd2, 32'd0};
						end
					end
					else if(board[8] != 8'd0 && board[9] == 8'd0 && board[10] != 8'd0 && board[11] == 8'd0) begin
						if(board[8] != board[10]) begin
							{board[8], board[9], board[10], board[11]} <= {board[8], board[10], 8'd0, 8'd0};
							{to_up[8], to_up[9], to_up[10], to_up[11]} <= {32'd0, 32'd0, 32'd1, 32'd0};
						end
						else begin
							{board[8], board[9], board[10], board[11]} <= {board[8]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_up[8], to_up[9], to_up[10], to_up[11]} <= {32'd0, 32'd0, 32'd2, 32'd0};
						end
					end
					else if(board[8] != 8'd0 && board[9] != 8'd0 && board[10] == 8'd0 && board[11] == 8'd0) begin
						if(board[8] != board[9]) begin
							{board[8], board[9], board[10], board[11]} <= {board[8], board[9], 8'd0, 8'd0};
							{to_up[8], to_up[9], to_up[10], to_up[11]} <= {32'd0, 32'd0, 32'd0, 32'd0};
						end
						else begin
							{board[8], board[9], board[10], board[11]} <= {board[8]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_up[8], to_up[9], to_up[10], to_up[11]} <= {32'd0, 32'd1, 32'd0, 32'd0};
						end
					end
					else if(board[8] != 8'd0 && board[9] != 8'd0 && board[10] != 8'd0 && board[11] == 8'd0) begin
						if(board[8] == board[9]) begin
							{board[8], board[9], board[10], board[11]} <= {board[8]+8'd1, board[10], 8'd0, 8'd0};
							{to_up[8], to_up[9], to_up[10], to_up[11]} <= {32'd0, 32'd1, 32'd1, 32'd0};
						end
						else if(board[9] == board[10]) begin
							{board[8], board[9], board[10], board[11]} <= {board[8], board[9]+8'd1, 8'd0, 8'd0};
							{to_up[8], to_up[9], to_up[10], to_up[11]} <= {32'd0, 32'd0, 32'd1, 32'd0};
						end
						else begin
							{board[8], board[9], board[10], board[11]} <= {board[8], board[9], board[10], 8'd0};
							{to_up[8], to_up[9], to_up[10], to_up[11]} <= {32'd0, 32'd0, 32'd0, 32'd0};
						end
					end
					else if(board[8] != 8'd0 && board[9] != 8'd0 && board[10] == 8'd0 && board[11] != 8'd0) begin
						if(board[8] == board[9]) begin
							{board[8], board[9], board[10], board[11]} <= {board[8]+8'd1, board[11], 8'd0, 8'd0};
							{to_up[8], to_up[9], to_up[10], to_up[11]} <= {32'd0, 32'd1, 32'd0, 32'd2};
						end
						else if(board[9] == board[11]) begin
							{board[8], board[9], board[10], board[11]} <= {board[8], board[9]+8'd1, 8'd0, 8'd0};
							{to_up[8], to_up[9], to_up[10], to_up[11]} <= {32'd0, 32'd0, 32'd0, 32'd2};
						end
						else begin
							{board[8], board[9], board[10], board[11]} <= {board[8], board[9], board[11], 8'd0};
							{to_up[8], to_up[9], to_up[10], to_up[11]} <= {32'd0, 32'd0, 32'd0, 32'd1};
						end
					end
					else if(board[8] != 8'd0 && board[9] == 8'd0 && board[10] != 8'd0 && board[11] != 8'd0) begin
						if(board[8] == board[10]) begin
							{board[8], board[9], board[10], board[11]} <= {board[8]+8'd1, board[11], 8'd0, 8'd0};
							{to_up[8], to_up[9], to_up[10], to_up[11]} <= {32'd0, 32'd0, 32'd2, 32'd2};
						end
						else if(board[10] == board[11]) begin
							{board[8], board[9], board[10], board[11]} <= {board[8], board[10]+8'd1, 8'd0, 8'd0};
							{to_up[8], to_up[9], to_up[10], to_up[11]} <= {32'd0, 32'd0, 32'd1, 32'd2};
						end
						else begin
							{board[8], board[9], board[10], board[11]} <= {board[8], board[10], board[11], 8'd0};
							{to_up[8], to_up[9], to_up[10], to_up[11]} <= {32'd0, 32'd0, 32'd1, 32'd1};
						end
					end
					else if(board[8] == 8'd0 && board[9] != 8'd0 && board[10] != 8'd0 && board[11] != 8'd0) begin
						if(board[9] == board[10]) begin
							{board[8], board[9], board[10], board[11]} <= {board[9]+8'd1, board[11], 8'd0, 8'd0};
							{to_up[8], to_up[9], to_up[10], to_up[11]} <= {32'd0, 32'd1, 32'd2, 32'd2};
						end
						else if(board[10] == board[11]) begin
							{board[8], board[9], board[10], board[11]} <= {board[9], board[10]+8'd1, 8'd0, 8'd0};
							{to_up[8], to_up[9], to_up[10], to_up[11]} <= {32'd0, 32'd1, 32'd1, 32'd2};
						end
						else begin
							{board[8], board[9], board[10], board[11]} <= {board[9], board[10], board[11], 8'd0};
							{to_up[8], to_up[9], to_up[10], to_up[11]} <= {32'd0, 32'd1, 32'd1, 32'd1};
						end
					end
					else begin
						if(board[8] == board[9]) begin
							if(board[10] == board[11]) begin
								{board[8], board[9], board[10], board[11]} <= {board[8]+8'd1, board[10]+8'd1, 8'd0, 8'd0};
								{to_up[8], to_up[9], to_up[10], to_up[11]} <= {32'd0, 32'd1, 32'd1, 32'd2};
							end
							else begin
								{board[8], board[9], board[10], board[11]} <= {board[8]+8'd1, board[10], board[11], 8'd0};
								{to_up[8], to_up[9], to_up[10], to_up[11]} <= {32'd0, 32'd1, 32'd1, 32'd1};
							end
						end
						else begin
							if(board[9] == board[10]) begin
								{board[8], board[9], board[10], board[11]} <= {board[8], board[9]+8'd1, board[11], 8'd0};
								{to_up[8], to_up[9], to_up[10], to_up[11]} <= {32'd0, 32'd0, 32'd1, 32'd1};
							end
							else if(board[10] == board[11]) begin
								{board[8], board[9], board[10], board[11]} <= {board[8], board[9], board[10]+8'd1, 8'd0};
								{to_up[8], to_up[9], to_up[10], to_up[11]} <= {32'd0, 32'd0, 32'd0, 32'd1};
							end
							else begin
								{board[8], board[9], board[10], board[11]} <= {board[8], board[9], board[10], board[11]};
								{to_up[8], to_up[9], to_up[10], to_up[11]} <= {32'd0, 32'd0, 32'd0, 32'd0};
							end
						end
					end
					
					if(board[12] == 8'd0 && board[13] == 8'd0 && board[14] == 8'd0 && board[15] == 8'd0) begin
						{board[12], board[13], board[14], board[15]} <= {8'd0, 8'd0, 8'd0, 8'd0};
						{to_up[12], to_up[13], to_up[14], to_up[15]} <= {32'd0, 32'd0, 32'd0, 32'd0};
					end
					else if(board[12] == 8'd0 && board[13] == 8'd0 && board[14] == 8'd0 && board[15] != 8'd0) begin
						{board[12], board[13], board[14], board[15]} <= {board[15], 8'd0, 8'd0, 8'd0};
						{to_up[12], to_up[13], to_up[14], to_up[15]} <= {32'd0, 32'd0, 32'd0, 32'd3};
					end
					else if(board[12] == 8'd0 && board[13] == 8'd0 && board[14] != 8'd0 && board[15] == 8'd0) begin
						{board[12], board[13], board[14], board[15]} <= {board[14], 8'd0, 8'd0, 8'd0};
						{to_up[12], to_up[13], to_up[14], to_up[15]} <= {32'd0, 32'd0, 32'd2, 32'd0};
					end
					else if(board[12] == 8'd0 && board[13] != 8'd0 && board[14] == 8'd0 && board[15] == 8'd0) begin
						{board[12], board[13], board[14], board[15]} <= {board[13], 8'd0, 8'd0, 8'd0};
						{to_up[12], to_up[13], to_up[14], to_up[15]} <= {32'd0, 32'd1, 32'd0, 32'd0};
					end
					else if(board[12] != 8'd0 && board[13] == 8'd0 && board[14] == 8'd0 && board[15] == 8'd0) begin
						{board[12], board[13], board[14], board[15]} <= {board[12], 8'd0, 8'd0, 8'd0};
						{to_up[12], to_up[13], to_up[14], to_up[15]} <= {32'd0, 32'd0, 32'd0, 32'd0};
					end
					else if(board[12] == 8'd0 && board[13] == 8'd0 && board[14] != 8'd0 && board[15] != 8'd0) begin
						if(board[14] != board[15]) begin
							{board[12], board[13], board[14], board[15]} <= {board[14], board[15], 8'd0, 8'd0};
							{to_up[12], to_up[13], to_up[14], to_up[15]} <= {32'd0, 32'd0, 32'd2, 32'd2};
						end
						else begin
							{board[12], board[13], board[14], board[15]} <= {board[14]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_up[12], to_up[13], to_up[14], to_up[15]} <= {32'd0, 32'd0, 32'd2, 32'd3};
						end
					end
					else if(board[12] == 8'd0 && board[13] != 8'd0 && board[14] == 8'd0 && board[15] != 8'd0) begin
						if(board[13] != board[15]) begin
							{board[12], board[13], board[14], board[15]} <= {board[13], board[15], 8'd0, 8'd0};
							{to_up[12], to_up[13], to_up[14], to_up[15]} <= {32'd0, 32'd1, 32'd0, 32'd2};
						end
						else begin
							{board[12], board[13], board[14], board[15]} <= {board[13]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_up[12], to_up[13], to_up[14], to_up[15]} <= {32'd0, 32'd1, 32'd0, 32'd3};
						end
					end
					else if(board[12] != 8'd0 && board[13] == 8'd0 && board[14] == 8'd0 && board[15] != 8'd0) begin
						if(board[12] != board[15]) begin
							{board[12], board[13], board[14], board[15]} <= {board[12], board[15], 8'd0, 8'd0};
							{to_up[12], to_up[13], to_up[14], to_up[15]} <= {32'd0, 32'd0, 32'd0, 32'd2};
						end
						else begin
							{board[12], board[13], board[14], board[15]} <= {board[12]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_up[12], to_up[13], to_up[14], to_up[15]} <= {32'd0, 32'd0, 32'd0, 32'd3};
						end
					end
					else if(board[12] == 8'd0 && board[13] != 8'd0 && board[14] != 8'd0 && board[15] == 8'd0) begin
						if(board[13] != board[14]) begin
							{board[12], board[13], board[14], board[15]} <= {board[13], board[14], 8'd0, 8'd0};
							{to_up[12], to_up[13], to_up[14], to_up[15]} <= {32'd0, 32'd1, 32'd1, 32'd0};
						end
						else begin
							{board[12], board[13], board[14], board[15]} <= {board[13]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_up[12], to_up[13], to_up[14], to_up[15]} <= {32'd0, 32'd1, 32'd2, 32'd0};
						end
					end
					else if(board[12] != 8'd0 && board[13] == 8'd0 && board[14] != 8'd0 && board[15] == 8'd0) begin
						if(board[12] != board[14]) begin
							{board[12], board[13], board[14], board[15]} <= {board[12], board[14], 8'd0, 8'd0};
							{to_up[12], to_up[13], to_up[14], to_up[15]} <= {32'd0, 32'd0, 32'd1, 32'd0};
						end
						else begin
							{board[12], board[13], board[14], board[15]} <= {board[12]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_up[12], to_up[13], to_up[14], to_up[15]} <= {32'd0, 32'd0, 32'd2, 32'd0};
						end
					end
					else if(board[12] != 8'd0 && board[13] != 8'd0 && board[14] == 8'd0 && board[15] == 8'd0) begin
						if(board[12] != board[13]) begin
							{board[12], board[13], board[14], board[15]} <= {board[12], board[13], 8'd0, 8'd0};
							{to_up[12], to_up[13], to_up[14], to_up[15]} <= {32'd0, 32'd0, 32'd0, 32'd0};
						end
						else begin
							{board[12], board[13], board[14], board[15]} <= {board[12]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_up[12], to_up[13], to_up[14], to_up[15]} <= {32'd0, 32'd1, 32'd0, 32'd0};
						end
					end
					else if(board[12] != 8'd0 && board[13] != 8'd0 && board[14] != 8'd0 && board[15] == 8'd0) begin
						if(board[12] == board[13]) begin
							{board[12], board[13], board[14], board[15]} <= {board[12]+8'd1, board[14], 8'd0, 8'd0};
							{to_up[12], to_up[13], to_up[14], to_up[15]} <= {32'd0, 32'd1, 32'd1, 32'd0};
						end
						else if(board[13] == board[14]) begin
							{board[12], board[13], board[14], board[15]} <= {board[12], board[13]+8'd1, 8'd0, 8'd0};
							{to_up[12], to_up[13], to_up[14], to_up[15]} <= {32'd0, 32'd0, 32'd1, 32'd0};
						end
						else begin
							{board[12], board[13], board[14], board[15]} <= {board[12], board[13], board[14], 8'd0};
							{to_up[12], to_up[13], to_up[14], to_up[15]} <= {32'd0, 32'd0, 32'd0, 32'd0};
						end
					end
					else if(board[12] != 8'd0 && board[13] != 8'd0 && board[14] == 8'd0 && board[15] != 8'd0) begin
						if(board[12] == board[13]) begin
							{board[12], board[13], board[14], board[15]} <= {board[12]+8'd1, board[15], 8'd0, 8'd0};
							{to_up[12], to_up[13], to_up[14], to_up[15]} <= {32'd0, 32'd1, 32'd0, 32'd2};
						end
						else if(board[13] == board[15]) begin
							{board[12], board[13], board[14], board[15]} <= {board[12], board[13]+8'd1, 8'd0, 8'd0};
							{to_up[12], to_up[13], to_up[14], to_up[15]} <= {32'd0, 32'd0, 32'd0, 32'd2};
						end
						else begin
							{board[12], board[13], board[14], board[15]} <= {board[12], board[13], board[15], 8'd0};
							{to_up[12], to_up[13], to_up[14], to_up[15]} <= {32'd0, 32'd0, 32'd0, 32'd1};
						end
					end
					else if(board[12] != 8'd0 && board[13] == 8'd0 && board[14] != 8'd0 && board[15] != 8'd0) begin
						if(board[12] == board[14]) begin
							{board[12], board[13], board[14], board[15]} <= {board[12]+8'd1, board[15], 8'd0, 8'd0};
							{to_up[12], to_up[13], to_up[14], to_up[15]} <= {32'd0, 32'd0, 32'd2, 32'd2};
						end
						else if(board[14] == board[15]) begin
							{board[12], board[13], board[14], board[15]} <= {board[12], board[14]+8'd1, 8'd0, 8'd0};
							{to_up[12], to_up[13], to_up[14], to_up[15]} <= {32'd0, 32'd0, 32'd1, 32'd2};
						end
						else begin
							{board[12], board[13], board[14], board[15]} <= {board[12], board[14], board[15], 8'd0};
							{to_up[12], to_up[13], to_up[14], to_up[15]} <= {32'd0, 32'd0, 32'd1, 32'd1};
						end
					end
					else if(board[12] == 8'd0 && board[13] != 8'd0 && board[14] != 8'd0 && board[15] != 8'd0) begin
						if(board[13] == board[14]) begin
							{board[12], board[13], board[14], board[15]} <= {board[13]+8'd1, board[15], 8'd0, 8'd0};
							{to_up[12], to_up[13], to_up[14], to_up[15]} <= {32'd0, 32'd1, 32'd2, 32'd2};
						end
						else if(board[14] == board[15]) begin
							{board[12], board[13], board[14], board[15]} <= {board[13], board[14]+8'd1, 8'd0, 8'd0};
							{to_up[12], to_up[13], to_up[14], to_up[15]} <= {32'd0, 32'd1, 32'd1, 32'd2};
						end
						else begin
							{board[12], board[13], board[14], board[15]} <= {board[13], board[14], board[15], 8'd0};
							{to_up[12], to_up[13], to_up[14], to_up[15]} <= {32'd0, 32'd1, 32'd1, 32'd1};
						end
					end
					else begin
						if(board[12] == board[13]) begin
							if(board[14] == board[15]) begin
								{board[12], board[13], board[14], board[15]} <= {board[12]+8'd1, board[14]+8'd1, 8'd0, 8'd0};
								{to_up[12], to_up[13], to_up[14], to_up[15]} <= {32'd0, 32'd1, 32'd1, 32'd2};
							end
							else begin
								{board[12], board[13], board[14], board[15]} <= {board[12]+8'd1, board[14], board[15], 8'd0};
								{to_up[12], to_up[13], to_up[14], to_up[15]} <= {32'd0, 32'd1, 32'd1, 32'd1};
							end
						end
						else begin
							if(board[13] == board[14]) begin
								{board[12], board[13], board[14], board[15]} <= {board[12], board[13]+8'd1, board[15], 8'd0};
								{to_up[12], to_up[13], to_up[14], to_up[15]} <= {32'd0, 32'd0, 32'd1, 32'd1};
							end
							else if(board[14] == board[15]) begin
								{board[12], board[13], board[14], board[15]} <= {board[12], board[13], board[14]+8'd1, 8'd0};
								{to_up[12], to_up[13], to_up[14], to_up[15]} <= {32'd0, 32'd0, 32'd0, 32'd1};
							end
							else begin
								{board[12], board[13], board[14], board[15]} <= {board[12], board[13], board[14], board[15]};
								{to_up[12], to_up[13], to_up[14], to_up[15]} <= {32'd0, 32'd0, 32'd0, 32'd0};
							end
						end
					end
				end
				else if(!down && !activeflag) begin
					if(board[3] == 8'd0 && board[2] == 8'd0 && board[1] == 8'd0 && board[0] == 8'd0) begin
						{board[3], board[2], board[1], board[0]} <= {8'd0, 8'd0, 8'd0, 8'd0};
						{to_down[3], to_down[2], to_down[1], to_down[0]} <= {32'd0, 32'd0, 32'd0, 32'd0};
					end
					else if(board[3] == 8'd0 && board[2] == 8'd0 && board[1] == 8'd0 && board[0] != 8'd0) begin
						{board[3], board[2], board[1], board[0]} <= {board[0], 8'd0, 8'd0, 8'd0};
						{to_down[3], to_down[2], to_down[1], to_down[0]} <= {32'd0, 32'd0, 32'd0, 32'd3};
					end
					else if(board[3] == 8'd0 && board[2] == 8'd0 && board[1] != 8'd0 && board[0] == 8'd0) begin
						{board[3], board[2], board[1], board[0]} <= {board[1], 8'd0, 8'd0, 8'd0};
						{to_down[3], to_down[2], to_down[1], to_down[0]} <= {32'd0, 32'd0, 32'd2, 32'd0};
					end
					else if(board[3] == 8'd0 && board[2] != 8'd0 && board[1] == 8'd0 && board[0] == 8'd0) begin
						{board[3], board[2], board[1], board[0]} <= {board[2], 8'd0, 8'd0, 8'd0};
						{to_down[3], to_down[2], to_down[1], to_down[0]} <= {32'd0, 32'd1, 32'd0, 32'd0};
					end
					else if(board[3] != 8'd0 && board[2] == 8'd0 && board[1] == 8'd0 && board[0] == 8'd0) begin
						{board[3], board[2], board[1], board[0]} <= {board[3], 8'd0, 8'd0, 8'd0};
						{to_down[3], to_down[2], to_down[1], to_down[0]} <= {32'd0, 32'd0, 32'd0, 32'd0};
					end
					else if(board[3] == 8'd0 && board[2] == 8'd0 && board[1] != 8'd0 && board[0] != 8'd0) begin
						if(board[1] != board[0]) begin
							{board[3], board[2], board[1], board[0]} <= {board[1], board[0], 8'd0, 8'd0};
							{to_down[3], to_down[2], to_down[1], to_down[0]} <= {32'd0, 32'd0, 32'd2, 32'd2};
						end
						else begin
							{board[3], board[2], board[1], board[0]} <= {board[1]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_down[3], to_down[2], to_down[1], to_down[0]} <= {32'd0, 32'd0, 32'd2, 32'd3};
						end
					end
					else if(board[3] == 8'd0 && board[2] != 8'd0 && board[1] == 8'd0 && board[0] != 8'd0) begin
						if(board[2] != board[0]) begin
							{board[3], board[2], board[1], board[0]} <= {board[2], board[0], 8'd0, 8'd0};
							{to_down[3], to_down[2], to_down[1], to_down[0]} <= {32'd0, 32'd1, 32'd0, 32'd2};
						end
						else begin
							{board[3], board[2], board[1], board[0]} <= {board[2]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_down[3], to_down[2], to_down[1], to_down[0]} <= {32'd0, 32'd1, 32'd0, 32'd3};
						end
					end
					else if(board[3] != 8'd0 && board[2] == 8'd0 && board[1] == 8'd0 && board[0] != 8'd0) begin
						if(board[3] != board[0]) begin
							{board[3], board[2], board[1], board[0]} <= {board[3], board[0], 8'd0, 8'd0};
							{to_down[3], to_down[2], to_down[1], to_down[0]} <= {32'd0, 32'd0, 32'd0, 32'd2};
						end
						else begin
							{board[3], board[2], board[1], board[0]} <= {board[3]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_down[3], to_down[2], to_down[1], to_down[0]} <= {32'd0, 32'd0, 32'd0, 32'd3};
						end
					end
					else if(board[3] == 8'd0 && board[2] != 8'd0 && board[1] != 8'd0 && board[0] == 8'd0) begin
						if(board[2] != board[1]) begin
							{board[3], board[2], board[1], board[0]} <= {board[2], board[1], 8'd0, 8'd0};
							{to_down[3], to_down[2], to_down[1], to_down[0]} <= {32'd0, 32'd1, 32'd1, 32'd0};
						end
						else begin
							{board[3], board[2], board[1], board[0]} <= {board[2]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_down[3], to_down[2], to_down[1], to_down[0]} <= {32'd0, 32'd1, 32'd2, 32'd0};
						end
					end
					else if(board[3] != 8'd0 && board[2] == 8'd0 && board[1] != 8'd0 && board[0] == 8'd0) begin
						if(board[3] != board[1]) begin
							{board[3], board[2], board[1], board[0]} <= {board[3], board[1], 8'd0, 8'd0};
							{to_down[3], to_down[2], to_down[1], to_down[0]} <= {32'd0, 32'd0, 32'd1, 32'd0};
						end
						else begin
							{board[3], board[2], board[1], board[0]} <= {board[3]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_down[3], to_down[2], to_down[1], to_down[0]} <= {32'd0, 32'd0, 32'd2, 32'd0};
						end
					end
					else if(board[3] != 8'd0 && board[2] != 8'd0 && board[1] == 8'd0 && board[0] == 8'd0) begin
						if(board[3] != board[2]) begin
							{board[3], board[2], board[1], board[0]} <= {board[3], board[2], 8'd0, 8'd0};
							{to_down[3], to_down[2], to_down[1], to_down[0]} <= {32'd0, 32'd0, 32'd0, 32'd0};
						end
						else begin
							{board[3], board[2], board[1], board[0]} <= {board[3]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_down[3], to_down[2], to_down[1], to_down[0]} <= {32'd0, 32'd1, 32'd0, 32'd0};
						end
					end
					else if(board[3] != 8'd0 && board[2] != 8'd0 && board[1] != 8'd0 && board[0] == 8'd0) begin
						if(board[3] == board[2]) begin
							{board[3], board[2], board[1], board[0]} <= {board[3]+8'd1, board[1], 8'd0, 8'd0};
							{to_down[3], to_down[2], to_down[1], to_down[0]} <= {32'd0, 32'd1, 32'd1, 32'd0};
						end
						else if(board[2] == board[1]) begin
							{board[3], board[2], board[1], board[0]} <= {board[3], board[2]+8'd1, 8'd0, 8'd0};
							{to_down[3], to_down[2], to_down[1], to_down[0]} <= {32'd0, 32'd0, 32'd1, 32'd0};
						end
						else begin
							{board[3], board[2], board[1], board[0]} <= {board[3], board[2], board[1], 8'd0};
							{to_down[3], to_down[2], to_down[1], to_down[0]} <= {32'd0, 32'd0, 32'd0, 32'd0};
						end
					end
					else if(board[3] != 8'd0 && board[2] != 8'd0 && board[1] == 8'd0 && board[0] != 8'd0) begin
						if(board[3] == board[2]) begin
							{board[3], board[2], board[1], board[0]} <= {board[3]+8'd1, board[0], 8'd0, 8'd0};
							{to_down[3], to_down[2], to_down[1], to_down[0]} <= {32'd0, 32'd1, 32'd0, 32'd2};
						end
						else if(board[2] == board[0]) begin
							{board[3], board[2], board[1], board[0]} <= {board[3], board[2]+8'd1, 8'd0, 8'd0};
							{to_down[3], to_down[2], to_down[1], to_down[0]} <= {32'd0, 32'd0, 32'd0, 32'd2};
						end
						else begin
							{board[3], board[2], board[1], board[0]} <= {board[3], board[2], board[0], 8'd0};
							{to_down[3], to_down[2], to_down[1], to_down[0]} <= {32'd0, 32'd0, 32'd0, 32'd1};
						end
					end
					else if(board[3] != 8'd0 && board[2] == 8'd0 && board[1] != 8'd0 && board[0] != 8'd0) begin
						if(board[3] == board[1]) begin
							{board[3], board[2], board[1], board[0]} <= {board[3]+8'd1, board[0], 8'd0, 8'd0};
							{to_down[3], to_down[2], to_down[1], to_down[0]} <= {32'd0, 32'd0, 32'd2, 32'd2};
						end
						else if(board[1] == board[0]) begin
							{board[3], board[2], board[1], board[0]} <= {board[3], board[1]+8'd1, 8'd0, 8'd0};
							{to_down[3], to_down[2], to_down[1], to_down[0]} <= {32'd0, 32'd0, 32'd1, 32'd2};
						end
						else begin
							{board[3], board[2], board[1], board[0]} <= {board[3], board[1], board[0], 8'd0};
							{to_down[3], to_down[2], to_down[1], to_down[0]} <= {32'd0, 32'd0, 32'd1, 32'd1};
						end
					end
					else if(board[3] == 8'd0 && board[2] != 8'd0 && board[1] != 8'd0 && board[0] != 8'd0) begin
						if(board[2] == board[1]) begin
							{board[3], board[2], board[1], board[0]} <= {board[2]+8'd1, board[0], 8'd0, 8'd0};
							{to_down[3], to_down[2], to_down[1], to_down[0]} <= {32'd0, 32'd1, 32'd2, 32'd2};
						end
						else if(board[1] == board[0]) begin
							{board[3], board[2], board[1], board[0]} <= {board[2], board[1]+8'd1, 8'd0, 8'd0};
							{to_down[3], to_down[2], to_down[1], to_down[0]} <= {32'd0, 32'd1, 32'd1, 32'd2};
						end
						else begin
							{board[3], board[2], board[1], board[0]} <= {board[2], board[1], board[0], 8'd0};
							{to_down[3], to_down[2], to_down[1], to_down[0]} <= {32'd0, 32'd1, 32'd1, 32'd1};
						end
					end
					else begin
						if(board[3] == board[2]) begin
							if(board[1] == board[0]) begin
								{board[3], board[2], board[1], board[0]} <= {board[3]+8'd1, board[1]+8'd1, 8'd0, 8'd0};
								{to_down[3], to_down[2], to_down[1], to_down[0]} <= {32'd0, 32'd1, 32'd1, 32'd2};
							end
							else begin
								{board[3], board[2], board[1], board[0]} <= {board[3]+8'd1, board[1], board[0], 8'd0};
								{to_down[3], to_down[2], to_down[1], to_down[0]} <= {32'd0, 32'd1, 32'd1, 32'd1};
							end
						end
						else begin
							if(board[2] == board[1]) begin
								{board[3], board[2], board[1], board[0]} <= {board[3], board[2]+8'd1, board[0], 8'd0};
								{to_down[3], to_down[2], to_down[1], to_down[0]} <= {32'd0, 32'd0, 32'd1, 32'd1};
							end
							else if(board[1] == board[0]) begin
								{board[3], board[2], board[1], board[0]} <= {board[3], board[2], board[1]+8'd1, 8'd0};
								{to_down[3], to_down[2], to_down[1], to_down[0]} <= {32'd0, 32'd0, 32'd0, 32'd1};
							end
							else begin
								{board[3], board[2], board[1], board[0]} <= {board[3], board[2], board[1], board[0]};
								{to_down[3], to_down[2], to_down[1], to_down[0]} <= {32'd0, 32'd0, 32'd0, 32'd0};
							end
						end
					end
					
					if(board[7] == 8'd0 && board[6] == 8'd0 && board[5] == 8'd0 && board[4] == 8'd0) begin
						{board[7], board[6], board[5], board[4]} <= {8'd0, 8'd0, 8'd0, 8'd0};
						{to_down[7], to_down[6], to_down[5], to_down[4]} <= {32'd0, 32'd0, 32'd0, 32'd0};
					end
					else if(board[7] == 8'd0 && board[6] == 8'd0 && board[5] == 8'd0 && board[4] != 8'd0) begin
						{board[7], board[6], board[5], board[4]} <= {board[4], 8'd0, 8'd0, 8'd0};
						{to_down[7], to_down[6], to_down[5], to_down[4]} <= {32'd0, 32'd0, 32'd0, 32'd3};
					end
					else if(board[7] == 8'd0 && board[6] == 8'd0 && board[5] != 8'd0 && board[4] == 8'd0) begin
						{board[7], board[6], board[5], board[4]} <= {board[5], 8'd0, 8'd0, 8'd0};
						{to_down[7], to_down[6], to_down[5], to_down[4]} <= {32'd0, 32'd0, 32'd2, 32'd0};
					end
					else if(board[7] == 8'd0 && board[6] != 8'd0 && board[5] == 8'd0 && board[4] == 8'd0) begin
						{board[7], board[6], board[5], board[4]} <= {board[6], 8'd0, 8'd0, 8'd0};
						{to_down[7], to_down[6], to_down[5], to_down[4]} <= {32'd0, 32'd1, 32'd0, 32'd0};
					end
					else if(board[7] != 8'd0 && board[6] == 8'd0 && board[5] == 8'd0 && board[4] == 8'd0) begin
						{board[7], board[6], board[5], board[4]} <= {board[7], 8'd0, 8'd0, 8'd0};
						{to_down[7], to_down[6], to_down[5], to_down[4]} <= {32'd0, 32'd0, 32'd0, 32'd0};
					end
					else if(board[7] == 8'd0 && board[6] == 8'd0 && board[5] != 8'd0 && board[4] != 8'd0) begin
						if(board[5] != board[4]) begin
							{board[7], board[6], board[5], board[4]} <= {board[5], board[4], 8'd0, 8'd0};
							{to_down[7], to_down[6], to_down[5], to_down[4]} <= {32'd0, 32'd0, 32'd2, 32'd2};
						end
						else begin
							{board[7], board[6], board[5], board[4]} <= {board[5]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_down[7], to_down[6], to_down[5], to_down[4]} <= {32'd0, 32'd0, 32'd2, 32'd3};
						end
					end
					else if(board[7] == 8'd0 && board[6] != 8'd0 && board[5] == 8'd0 && board[4] != 8'd0) begin
						if(board[6] != board[4]) begin
							{board[7], board[6], board[5], board[4]} <= {board[6], board[4], 8'd0, 8'd0};
							{to_down[7], to_down[6], to_down[5], to_down[4]} <= {32'd0, 32'd1, 32'd0, 32'd2};
						end
						else begin
							{board[7], board[6], board[5], board[4]} <= {board[6]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_down[7], to_down[6], to_down[5], to_down[4]} <= {32'd0, 32'd1, 32'd0, 32'd3};
						end
					end
					else if(board[7] != 8'd0 && board[6] == 8'd0 && board[5] == 8'd0 && board[4] != 8'd0) begin
						if(board[7] != board[4]) begin
							{board[7], board[6], board[5], board[4]} <= {board[7], board[4], 8'd0, 8'd0};
							{to_down[7], to_down[6], to_down[5], to_down[4]} <= {32'd0, 32'd0, 32'd0, 32'd2};
						end
						else begin
							{board[7], board[6], board[5], board[4]} <= {board[7]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_down[7], to_down[6], to_down[5], to_down[4]} <= {32'd0, 32'd0, 32'd0, 32'd3};
						end
					end
					else if(board[7] == 8'd0 && board[6] != 8'd0 && board[5] != 8'd0 && board[4] == 8'd0) begin
						if(board[6] != board[5]) begin
							{board[7], board[6], board[5], board[4]} <= {board[6], board[5], 8'd0, 8'd0};
							{to_down[7], to_down[6], to_down[5], to_down[4]} <= {32'd0, 32'd1, 32'd1, 32'd0};
						end
						else begin
							{board[7], board[6], board[5], board[4]} <= {board[6]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_down[7], to_down[6], to_down[5], to_down[4]} <= {32'd0, 32'd1, 32'd2, 32'd0};
						end
					end
					else if(board[7] != 8'd0 && board[6] == 8'd0 && board[5] != 8'd0 && board[4] == 8'd0) begin
						if(board[7] != board[5]) begin
							{board[7], board[6], board[5], board[4]} <= {board[7], board[5], 8'd0, 8'd0};
							{to_down[7], to_down[6], to_down[5], to_down[4]} <= {32'd0, 32'd0, 32'd1, 32'd0};
						end
						else begin
							{board[7], board[6], board[5], board[4]} <= {board[7]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_down[7], to_down[6], to_down[5], to_down[4]} <= {32'd0, 32'd0, 32'd2, 32'd0};
						end
					end
					else if(board[7] != 8'd0 && board[6] != 8'd0 && board[5] == 8'd0 && board[4] == 8'd0) begin
						if(board[7] != board[6]) begin
							{board[7], board[6], board[5], board[4]} <= {board[7], board[6], 8'd0, 8'd0};
							{to_down[7], to_down[6], to_down[5], to_down[4]} <= {32'd0, 32'd0, 32'd0, 32'd0};
						end
						else begin
							{board[7], board[6], board[5], board[4]} <= {board[7]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_down[7], to_down[6], to_down[5], to_down[4]} <= {32'd0, 32'd1, 32'd0, 32'd0};
						end
					end
					else if(board[7] != 8'd0 && board[6] != 8'd0 && board[5] != 8'd0 && board[4] == 8'd0) begin
						if(board[7] == board[6]) begin
							{board[7], board[6], board[5], board[4]} <= {board[7]+8'd1, board[5], 8'd0, 8'd0};
							{to_down[7], to_down[6], to_down[5], to_down[4]} <= {32'd0, 32'd1, 32'd1, 32'd0};
						end
						else if(board[6] == board[5]) begin
							{board[7], board[6], board[5], board[4]} <= {board[7], board[6]+8'd1, 8'd0, 8'd0};
							{to_down[7], to_down[6], to_down[5], to_down[4]} <= {32'd0, 32'd0, 32'd1, 32'd0};
						end
						else begin
							{board[7], board[6], board[5], board[4]} <= {board[7], board[6], board[5], 8'd0};
							{to_down[7], to_down[6], to_down[5], to_down[4]} <= {32'd0, 32'd0, 32'd0, 32'd0};
						end
					end
					else if(board[7] != 8'd0 && board[6] != 8'd0 && board[5] == 8'd0 && board[4] != 8'd0) begin
						if(board[7] == board[6]) begin
							{board[7], board[6], board[5], board[4]} <= {board[7]+8'd1, board[4], 8'd0, 8'd0};
							{to_down[7], to_down[6], to_down[5], to_down[4]} <= {32'd0, 32'd1, 32'd0, 32'd2};
						end
						else if(board[6] == board[4]) begin
							{board[7], board[6], board[5], board[4]} <= {board[7], board[6]+8'd1, 8'd0, 8'd0};
							{to_down[7], to_down[6], to_down[5], to_down[4]} <= {32'd0, 32'd0, 32'd0, 32'd2};
						end
						else begin
							{board[7], board[6], board[5], board[4]} <= {board[7], board[6], board[4], 8'd0};
							{to_down[7], to_down[6], to_down[5], to_down[4]} <= {32'd0, 32'd0, 32'd0, 32'd1};
						end
					end
					else if(board[7] != 8'd0 && board[6] == 8'd0 && board[5] != 8'd0 && board[4] != 8'd0) begin
						if(board[7] == board[5]) begin
							{board[7], board[6], board[5], board[4]} <= {board[7]+8'd1, board[4], 8'd0, 8'd0};
							{to_down[7], to_down[6], to_down[5], to_down[4]} <= {32'd0, 32'd0, 32'd2, 32'd2};
						end
						else if(board[5] == board[4]) begin
							{board[7], board[6], board[5], board[4]} <= {board[7], board[5]+8'd1, 8'd0, 8'd0};
							{to_down[7], to_down[6], to_down[5], to_down[4]} <= {32'd0, 32'd0, 32'd1, 32'd2};
						end
						else begin
							{board[7], board[6], board[5], board[4]} <= {board[7], board[5], board[4], 8'd0};
							{to_down[7], to_down[6], to_down[5], to_down[4]} <= {32'd0, 32'd0, 32'd1, 32'd1};
						end
					end
					else if(board[7] == 8'd0 && board[6] != 8'd0 && board[5] != 8'd0 && board[4] != 8'd0) begin
						if(board[6] == board[5]) begin
							{board[7], board[6], board[5], board[4]} <= {board[6]+8'd1, board[4], 8'd0, 8'd0};
							{to_down[7], to_down[6], to_down[5], to_down[4]} <= {32'd0, 32'd1, 32'd2, 32'd2};
						end
						else if(board[5] == board[4]) begin
							{board[7], board[6], board[5], board[4]} <= {board[6], board[5]+8'd1, 8'd0, 8'd0};
							{to_down[7], to_down[6], to_down[5], to_down[4]} <= {32'd0, 32'd1, 32'd1, 32'd2};
						end
						else begin
							{board[7], board[6], board[5], board[4]} <= {board[6], board[5], board[4], 8'd0};
							{to_down[7], to_down[6], to_down[5], to_down[4]} <= {32'd0, 32'd1, 32'd1, 32'd1};
						end
					end
					else begin
						if(board[7] == board[6]) begin
							if(board[5] == board[4]) begin
								{board[7], board[6], board[5], board[4]} <= {board[7]+8'd1, board[5]+8'd1, 8'd0, 8'd0};
								{to_down[7], to_down[6], to_down[5], to_down[4]} <= {32'd0, 32'd1, 32'd1, 32'd2};
							end
							else begin
								{board[7], board[6], board[5], board[4]} <= {board[7]+8'd1, board[5], board[4], 8'd0};
								{to_down[7], to_down[6], to_down[5], to_down[4]} <= {32'd0, 32'd1, 32'd1, 32'd1};
							end
						end
						else begin
							if(board[6] == board[5]) begin
								{board[7], board[6], board[5], board[4]} <= {board[7], board[6]+8'd1, board[4], 8'd0};
								{to_down[7], to_down[6], to_down[5], to_down[4]} <= {32'd0, 32'd0, 32'd1, 32'd1};
							end
							else if(board[5] == board[4]) begin
								{board[7], board[6], board[5], board[4]} <= {board[7], board[6], board[5]+8'd1, 8'd0};
								{to_down[7], to_down[6], to_down[5], to_down[4]} <= {32'd0, 32'd0, 32'd0, 32'd1};
							end
							else begin
								{board[7], board[6], board[5], board[4]} <= {board[7], board[6], board[5], board[4]};
								{to_down[7], to_down[6], to_down[5], to_down[4]} <= {32'd0, 32'd0, 32'd0, 32'd0};
							end
						end
					end
					
					if(board[11] == 8'd0 && board[10] == 8'd0 && board[9] == 8'd0 && board[8] == 8'd0) begin
						{board[11], board[10], board[9], board[8]} <= {8'd0, 8'd0, 8'd0, 8'd0};
						{to_down[11], to_down[10], to_down[9], to_down[8]} <= {32'd0, 32'd0, 32'd0, 32'd0};
					end
					else if(board[11] == 8'd0 && board[10] == 8'd0 && board[9] == 8'd0 && board[8] != 8'd0) begin
						{board[11], board[10], board[9], board[8]} <= {board[8], 8'd0, 8'd0, 8'd0};
						{to_down[11], to_down[10], to_down[9], to_down[8]} <= {32'd0, 32'd0, 32'd0, 32'd3};
					end
					else if(board[11] == 8'd0 && board[10] == 8'd0 && board[9] != 8'd0 && board[8] == 8'd0) begin
						{board[11], board[10], board[9], board[8]} <= {board[9], 8'd0, 8'd0, 8'd0};
						{to_down[11], to_down[10], to_down[9], to_down[8]} <= {32'd0, 32'd0, 32'd2, 32'd0};
					end
					else if(board[11] == 8'd0 && board[10] != 8'd0 && board[9] == 8'd0 && board[8] == 8'd0) begin
						{board[11], board[10], board[9], board[8]} <= {board[10], 8'd0, 8'd0, 8'd0};
						{to_down[11], to_down[10], to_down[9], to_down[8]} <= {32'd0, 32'd1, 32'd0, 32'd0};
					end
					else if(board[11] != 8'd0 && board[10] == 8'd0 && board[9] == 8'd0 && board[8] == 8'd0) begin
						{board[11], board[10], board[9], board[8]} <= {board[11], 8'd0, 8'd0, 8'd0};
						{to_down[11], to_down[10], to_down[9], to_down[8]} <= {32'd0, 32'd0, 32'd0, 32'd0};
					end
					else if(board[11] == 8'd0 && board[10] == 8'd0 && board[9] != 8'd0 && board[8] != 8'd0) begin
						if(board[9] != board[8]) begin
							{board[11], board[10], board[9], board[8]} <= {board[9], board[8], 8'd0, 8'd0};
							{to_down[11], to_down[10], to_down[9], to_down[8]} <= {32'd0, 32'd0, 32'd2, 32'd2};
						end
						else begin
							{board[11], board[10], board[9], board[8]} <= {board[9]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_down[11], to_down[10], to_down[9], to_down[8]} <= {32'd0, 32'd0, 32'd2, 32'd3};
						end
					end
					else if(board[11] == 8'd0 && board[10] != 8'd0 && board[9] == 8'd0 && board[8] != 8'd0) begin
						if(board[10] != board[8]) begin
							{board[11], board[10], board[9], board[8]} <= {board[10], board[8], 8'd0, 8'd0};
							{to_down[11], to_down[10], to_down[9], to_down[8]} <= {32'd0, 32'd1, 32'd0, 32'd2};
						end
						else begin
							{board[11], board[10], board[9], board[8]} <= {board[10]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_down[11], to_down[10], to_down[9], to_down[8]} <= {32'd0, 32'd1, 32'd0, 32'd3};
						end
					end
					else if(board[11] != 8'd0 && board[10] == 8'd0 && board[9] == 8'd0 && board[8] != 8'd0) begin
						if(board[11] != board[8]) begin
							{board[11], board[10], board[9], board[8]} <= {board[11], board[8], 8'd0, 8'd0};
							{to_down[11], to_down[10], to_down[9], to_down[8]} <= {32'd0, 32'd0, 32'd0, 32'd2};
						end
						else begin
							{board[11], board[10], board[9], board[8]} <= {board[11]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_down[11], to_down[10], to_down[9], to_down[8]} <= {32'd0, 32'd0, 32'd0, 32'd3};
						end
					end
					else if(board[11] == 8'd0 && board[10] != 8'd0 && board[9] != 8'd0 && board[8] == 8'd0) begin
						if(board[10] != board[9]) begin
							{board[11], board[10], board[9], board[8]} <= {board[10], board[9], 8'd0, 8'd0};
							{to_down[11], to_down[10], to_down[9], to_down[8]} <= {32'd0, 32'd1, 32'd1, 32'd0};
						end
						else begin
							{board[11], board[10], board[9], board[8]} <= {board[10]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_down[11], to_down[10], to_down[9], to_down[8]} <= {32'd0, 32'd1, 32'd2, 32'd0};
						end
					end
					else if(board[11] != 8'd0 && board[10] == 8'd0 && board[9] != 8'd0 && board[8] == 8'd0) begin
						if(board[11] != board[9]) begin
							{board[11], board[10], board[9], board[8]} <= {board[11], board[9], 8'd0, 8'd0};
							{to_down[11], to_down[10], to_down[9], to_down[8]} <= {32'd0, 32'd0, 32'd1, 32'd0};
						end
						else begin
							{board[11], board[10], board[9], board[8]} <= {board[11]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_down[11], to_down[10], to_down[9], to_down[8]} <= {32'd0, 32'd0, 32'd2, 32'd0};
						end
					end
					else if(board[11] != 8'd0 && board[10] != 8'd0 && board[9] == 8'd0 && board[8] == 8'd0) begin
						if(board[11] != board[10]) begin
							{board[11], board[10], board[9], board[8]} <= {board[11], board[10], 8'd0, 8'd0};
							{to_down[11], to_down[10], to_down[9], to_down[8]} <= {32'd0, 32'd0, 32'd0, 32'd0};
						end
						else begin
							{board[11], board[10], board[9], board[8]} <= {board[11]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_down[11], to_down[10], to_down[9], to_down[8]} <= {32'd0, 32'd1, 32'd0, 32'd0};
						end
					end
					else if(board[11] != 8'd0 && board[10] != 8'd0 && board[9] != 8'd0 && board[8] == 8'd0) begin
						if(board[11] == board[10]) begin
							{board[11], board[10], board[9], board[8]} <= {board[11]+8'd1, board[9], 8'd0, 8'd0};
							{to_down[11], to_down[10], to_down[9], to_down[8]} <= {32'd0, 32'd1, 32'd1, 32'd0};
						end
						else if(board[10] == board[9]) begin
							{board[11], board[10], board[9], board[8]} <= {board[11], board[10]+8'd1, 8'd0, 8'd0};
							{to_down[11], to_down[10], to_down[9], to_down[8]} <= {32'd0, 32'd0, 32'd1, 32'd0};
						end
						else begin
							{board[11], board[10], board[9], board[8]} <= {board[11], board[10], board[9], 8'd0};
							{to_down[11], to_down[10], to_down[9], to_down[8]} <= {32'd0, 32'd0, 32'd0, 32'd0};
						end
					end
					else if(board[11] != 8'd0 && board[10] != 8'd0 && board[9] == 8'd0 && board[8] != 8'd0) begin
						if(board[11] == board[10]) begin
							{board[11], board[10], board[9], board[8]} <= {board[11]+8'd1, board[8], 8'd0, 8'd0};
							{to_down[11], to_down[10], to_down[9], to_down[8]} <= {32'd0, 32'd1, 32'd0, 32'd2};
						end
						else if(board[10] == board[8]) begin
							{board[11], board[10], board[9], board[8]} <= {board[11], board[10]+8'd1, 8'd0, 8'd0};
							{to_down[11], to_down[10], to_down[9], to_down[8]} <= {32'd0, 32'd0, 32'd0, 32'd2};
						end
						else begin
							{board[11], board[10], board[9], board[8]} <= {board[11], board[10], board[8], 8'd0};
							{to_down[11], to_down[10], to_down[9], to_down[8]} <= {32'd0, 32'd0, 32'd0, 32'd1};
						end
					end
					else if(board[11] != 8'd0 && board[10] == 8'd0 && board[9] != 8'd0 && board[8] != 8'd0) begin
						if(board[11] == board[9]) begin
							{board[11], board[10], board[9], board[8]} <= {board[11]+8'd1, board[8], 8'd0, 8'd0};
							{to_down[11], to_down[10], to_down[9], to_down[8]} <= {32'd0, 32'd0, 32'd2, 32'd2};
						end
						else if(board[9] == board[8]) begin
							{board[11], board[10], board[9], board[8]} <= {board[11], board[9]+8'd1, 8'd0, 8'd0};
							{to_down[11], to_down[10], to_down[9], to_down[8]} <= {32'd0, 32'd0, 32'd1, 32'd2};
						end
						else begin
							{board[11], board[10], board[9], board[8]} <= {board[11], board[9], board[8], 8'd0};
							{to_down[11], to_down[10], to_down[9], to_down[8]} <= {32'd0, 32'd0, 32'd1, 32'd1};
						end
					end
					else if(board[11] == 8'd0 && board[10] != 8'd0 && board[9] != 8'd0 && board[8] != 8'd0) begin
						if(board[10] == board[9]) begin
							{board[11], board[10], board[9], board[8]} <= {board[10]+8'd1, board[8], 8'd0, 8'd0};
							{to_down[11], to_down[10], to_down[9], to_down[8]} <= {32'd0, 32'd1, 32'd2, 32'd2};
						end
						else if(board[9] == board[8]) begin
							{board[11], board[10], board[9], board[8]} <= {board[10], board[9]+8'd1, 8'd0, 8'd0};
							{to_down[11], to_down[10], to_down[9], to_down[8]} <= {32'd0, 32'd1, 32'd1, 32'd2};
						end
						else begin
							{board[11], board[10], board[9], board[8]} <= {board[10], board[9], board[8], 8'd0};
							{to_down[11], to_down[10], to_down[9], to_down[8]} <= {32'd0, 32'd1, 32'd1, 32'd1};
						end
					end
					else begin
						if(board[11] == board[10]) begin
							if(board[9] == board[8]) begin
								{board[11], board[10], board[9], board[8]} <= {board[11]+8'd1, board[9]+8'd1, 8'd0, 8'd0};
								{to_down[11], to_down[10], to_down[9], to_down[8]} <= {32'd0, 32'd1, 32'd1, 32'd2};
							end
							else begin
								{board[11], board[10], board[9], board[8]} <= {board[11]+8'd1, board[9], board[8], 8'd0};
								{to_down[11], to_down[10], to_down[9], to_down[8]} <= {32'd0, 32'd1, 32'd1, 32'd1};
							end
						end
						else begin
							if(board[10] == board[9]) begin
								{board[11], board[10], board[9], board[8]} <= {board[11], board[10]+8'd1, board[8], 8'd0};
								{to_down[11], to_down[10], to_down[9], to_down[8]} <= {32'd0, 32'd0, 32'd1, 32'd1};
							end
							else if(board[9] == board[8]) begin
								{board[11], board[10], board[9], board[8]} <= {board[11], board[10], board[9]+8'd1, 8'd0};
								{to_down[11], to_down[10], to_down[9], to_down[8]} <= {32'd0, 32'd0, 32'd0, 32'd1};
							end
							else begin
								{board[11], board[10], board[9], board[8]} <= {board[11], board[10], board[9], board[8]};
								{to_down[11], to_down[10], to_down[9], to_down[8]} <= {32'd0, 32'd0, 32'd0, 32'd0};
							end
						end
					end
					
					if(board[15] == 8'd0 && board[14] == 8'd0 && board[13] == 8'd0 && board[12] == 8'd0) begin
						{board[15], board[14], board[13], board[12]} <= {8'd0, 8'd0, 8'd0, 8'd0};
						{to_down[15], to_down[14], to_down[13], to_down[12]} <= {32'd0, 32'd0, 32'd0, 32'd0};
					end
					else if(board[15] == 8'd0 && board[14] == 8'd0 && board[13] == 8'd0 && board[12] != 8'd0) begin
						{board[15], board[14], board[13], board[12]} <= {board[12], 8'd0, 8'd0, 8'd0};
						{to_down[15], to_down[14], to_down[13], to_down[12]} <= {32'd0, 32'd0, 32'd0, 32'd3};
					end
					else if(board[15] == 8'd0 && board[14] == 8'd0 && board[13] != 8'd0 && board[12] == 8'd0) begin
						{board[15], board[14], board[13], board[12]} <= {board[13], 8'd0, 8'd0, 8'd0};
						{to_down[15], to_down[14], to_down[13], to_down[12]} <= {32'd0, 32'd0, 32'd2, 32'd0};
					end
					else if(board[15] == 8'd0 && board[14] != 8'd0 && board[13] == 8'd0 && board[12] == 8'd0) begin
						{board[15], board[14], board[13], board[12]} <= {board[14], 8'd0, 8'd0, 8'd0};
						{to_down[15], to_down[14], to_down[13], to_down[12]} <= {32'd0, 32'd1, 32'd0, 32'd0};
					end
					else if(board[15] != 8'd0 && board[14] == 8'd0 && board[13] == 8'd0 && board[12] == 8'd0) begin
						{board[15], board[14], board[13], board[12]} <= {board[15], 8'd0, 8'd0, 8'd0};
						{to_down[15], to_down[14], to_down[13], to_down[12]} <= {32'd0, 32'd0, 32'd0, 32'd0};
					end
					else if(board[15] == 8'd0 && board[14] == 8'd0 && board[13] != 8'd0 && board[12] != 8'd0) begin
						if(board[13] != board[12]) begin
							{board[15], board[14], board[13], board[12]} <= {board[13], board[12], 8'd0, 8'd0};
							{to_down[15], to_down[14], to_down[13], to_down[12]} <= {32'd0, 32'd0, 32'd2, 32'd2};
						end
						else begin
							{board[15], board[14], board[13], board[12]} <= {board[13]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_down[15], to_down[14], to_down[13], to_down[12]} <= {32'd0, 32'd0, 32'd2, 32'd3};
						end
					end
					else if(board[15] == 8'd0 && board[14] != 8'd0 && board[13] == 8'd0 && board[12] != 8'd0) begin
						if(board[14] != board[12]) begin
							{board[15], board[14], board[13], board[12]} <= {board[14], board[12], 8'd0, 8'd0};
							{to_down[15], to_down[14], to_down[13], to_down[12]} <= {32'd0, 32'd1, 32'd0, 32'd2};
						end
						else begin
							{board[15], board[14], board[13], board[12]} <= {board[14]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_down[15], to_down[14], to_down[13], to_down[12]} <= {32'd0, 32'd1, 32'd0, 32'd3};
						end
					end
					else if(board[15] != 8'd0 && board[14] == 8'd0 && board[13] == 8'd0 && board[12] != 8'd0) begin
						if(board[15] != board[12]) begin
							{board[15], board[14], board[13], board[12]} <= {board[15], board[12], 8'd0, 8'd0};
							{to_down[15], to_down[14], to_down[13], to_down[12]} <= {32'd0, 32'd0, 32'd0, 32'd2};
						end
						else begin
							{board[15], board[14], board[13], board[12]} <= {board[15]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_down[15], to_down[14], to_down[13], to_down[12]} <= {32'd0, 32'd0, 32'd0, 32'd3};
						end
					end
					else if(board[15] == 8'd0 && board[14] != 8'd0 && board[13] != 8'd0 && board[12] == 8'd0) begin
						if(board[14] != board[13]) begin
							{board[15], board[14], board[13], board[12]} <= {board[14], board[13], 8'd0, 8'd0};
							{to_down[15], to_down[14], to_down[13], to_down[12]} <= {32'd0, 32'd1, 32'd1, 32'd0};
						end
						else begin
							{board[15], board[14], board[13], board[12]} <= {board[14]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_down[15], to_down[14], to_down[13], to_down[12]} <= {32'd0, 32'd1, 32'd2, 32'd0};
						end
					end
					else if(board[15] != 8'd0 && board[14] == 8'd0 && board[13] != 8'd0 && board[12] == 8'd0) begin
						if(board[15] != board[13]) begin
							{board[15], board[14], board[13], board[12]} <= {board[15], board[13], 8'd0, 8'd0};
							{to_down[15], to_down[14], to_down[13], to_down[12]} <= {32'd0, 32'd0, 32'd1, 32'd0};
						end
						else begin
							{board[15], board[14], board[13], board[12]} <= {board[15]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_down[15], to_down[14], to_down[13], to_down[12]} <= {32'd0, 32'd0, 32'd2, 32'd0};
						end
					end
					else if(board[15] != 8'd0 && board[14] != 8'd0 && board[13] == 8'd0 && board[12] == 8'd0) begin
						if(board[15] != board[14]) begin
							{board[15], board[14], board[13], board[12]} <= {board[15], board[14], 8'd0, 8'd0};
							{to_down[15], to_down[14], to_down[13], to_down[12]} <= {32'd0, 32'd0, 32'd0, 32'd0};
						end
						else begin
							{board[15], board[14], board[13], board[12]} <= {board[15]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_down[15], to_down[14], to_down[13], to_down[12]} <= {32'd0, 32'd1, 32'd0, 32'd0};
						end
					end
					else if(board[15] != 8'd0 && board[14] != 8'd0 && board[13] != 8'd0 && board[12] == 8'd0) begin
						if(board[15] == board[14]) begin
							{board[15], board[14], board[13], board[12]} <= {board[15]+8'd1, board[13], 8'd0, 8'd0};
							{to_down[15], to_down[14], to_down[13], to_down[12]} <= {32'd0, 32'd1, 32'd1, 32'd0};
						end
						else if(board[14] == board[13]) begin
							{board[15], board[14], board[13], board[12]} <= {board[15], board[14]+8'd1, 8'd0, 8'd0};
							{to_down[15], to_down[14], to_down[13], to_down[12]} <= {32'd0, 32'd0, 32'd1, 32'd0};
						end
						else begin
							{board[15], board[14], board[13], board[12]} <= {board[15], board[14], board[13], 8'd0};
							{to_down[15], to_down[14], to_down[13], to_down[12]} <= {32'd0, 32'd0, 32'd0, 32'd0};
						end
					end
					else if(board[15] != 8'd0 && board[14] != 8'd0 && board[13] == 8'd0 && board[12] != 8'd0) begin
						if(board[15] == board[14]) begin
							{board[15], board[14], board[13], board[12]} <= {board[15]+8'd1, board[12], 8'd0, 8'd0};
							{to_down[15], to_down[14], to_down[13], to_down[12]} <= {32'd0, 32'd1, 32'd0, 32'd2};
						end
						else if(board[14] == board[12]) begin
							{board[15], board[14], board[13], board[12]} <= {board[15], board[14]+8'd1, 8'd0, 8'd0};
							{to_down[15], to_down[14], to_down[13], to_down[12]} <= {32'd0, 32'd0, 32'd0, 32'd2};
						end
						else begin
							{board[15], board[14], board[13], board[12]} <= {board[15], board[14], board[12], 8'd0};
							{to_down[15], to_down[14], to_down[13], to_down[12]} <= {32'd0, 32'd0, 32'd0, 32'd1};
						end
					end
					else if(board[15] != 8'd0 && board[14] == 8'd0 && board[13] != 8'd0 && board[12] != 8'd0) begin
						if(board[15] == board[13]) begin
							{board[15], board[14], board[13], board[12]} <= {board[15]+8'd1, board[12], 8'd0, 8'd0};
							{to_down[15], to_down[14], to_down[13], to_down[12]} <= {32'd0, 32'd0, 32'd2, 32'd2};
						end
						else if(board[13] == board[12]) begin
							{board[15], board[14], board[13], board[12]} <= {board[15], board[13]+8'd1, 8'd0, 8'd0};
							{to_down[15], to_down[14], to_down[13], to_down[12]} <= {32'd0, 32'd0, 32'd1, 32'd2};
						end
						else begin
							{board[15], board[14], board[13], board[12]} <= {board[15], board[13], board[12], 8'd0};
							{to_down[15], to_down[14], to_down[13], to_down[12]} <= {32'd0, 32'd0, 32'd1, 32'd1};
						end
					end
					else if(board[15] == 8'd0 && board[14] != 8'd0 && board[13] != 8'd0 && board[12] != 8'd0) begin
						if(board[14] == board[13]) begin
							{board[15], board[14], board[13], board[12]} <= {board[14]+8'd1, board[12], 8'd0, 8'd0};
							{to_down[15], to_down[14], to_down[13], to_down[12]} <= {32'd0, 32'd1, 32'd2, 32'd2};
						end
						else if(board[13] == board[12]) begin
							{board[15], board[14], board[13], board[12]} <= {board[14], board[13]+8'd1, 8'd0, 8'd0};
							{to_down[15], to_down[14], to_down[13], to_down[12]} <= {32'd0, 32'd1, 32'd1, 32'd2};
						end
						else begin
							{board[15], board[14], board[13], board[12]} <= {board[14], board[13], board[12], 8'd0};
							{to_down[15], to_down[14], to_down[13], to_down[12]} <= {32'd0, 32'd1, 32'd1, 32'd1};
						end
					end
					else begin
						if(board[15] == board[14]) begin
							if(board[13] == board[12]) begin
								{board[15], board[14], board[13], board[12]} <= {board[15]+8'd1, board[13]+8'd1, 8'd0, 8'd0};
								{to_down[15], to_down[14], to_down[13], to_down[12]} <= {32'd0, 32'd1, 32'd1, 32'd2};
							end
							else begin
								{board[15], board[14], board[13], board[12]} <= {board[15]+8'd1, board[13], board[12], 8'd0};
								{to_down[15], to_down[14], to_down[13], to_down[12]} <= {32'd0, 32'd1, 32'd1, 32'd1};
							end
						end
						else begin
							if(board[14] == board[13]) begin
								{board[15], board[14], board[13], board[12]} <= {board[15], board[14]+8'd1, board[12], 8'd0};
								{to_down[15], to_down[14], to_down[13], to_down[12]} <= {32'd0, 32'd0, 32'd1, 32'd1};
							end
							else if(board[13] == board[12]) begin
								{board[15], board[14], board[13], board[12]} <= {board[15], board[14], board[13]+8'd1, 8'd0};
								{to_down[15], to_down[14], to_down[13], to_down[12]} <= {32'd0, 32'd0, 32'd0, 32'd1};
							end
							else begin
								{board[15], board[14], board[13], board[12]} <= {board[15], board[14], board[13], board[12]};
								{to_down[15], to_down[14], to_down[13], to_down[12]} <= {32'd0, 32'd0, 32'd0, 32'd0};
							end
						end
					end
				end
				else if(!right && !activeflag) begin
					if(board[12] == 8'd0 && board[8] == 8'd0 && board[4] == 8'd0 && board[0] == 8'd0) begin
						{board[12], board[8], board[4], board[0]} <= {8'd0, 8'd0, 8'd0, 8'd0};
						{to_right[12], to_right[8], to_right[4], to_right[0]} <= {32'd0, 32'd0, 32'd0, 32'd0};
					end
					else if(board[12] == 8'd0 && board[8] == 8'd0 && board[4] == 8'd0 && board[0] != 8'd0) begin
						{board[12], board[8], board[4], board[0]} <= {board[0], 8'd0, 8'd0, 8'd0};
						{to_right[12], to_right[8], to_right[4], to_right[0]} <= {32'd0, 32'd0, 32'd0, 32'd3};
					end
					else if(board[12] == 8'd0 && board[8] == 8'd0 && board[4] != 8'd0 && board[0] == 8'd0) begin
						{board[12], board[8], board[4], board[0]} <= {board[4], 8'd0, 8'd0, 8'd0};
						{to_right[12], to_right[8], to_right[4], to_right[0]} <= {32'd0, 32'd0, 32'd2, 32'd0};
					end
					else if(board[12] == 8'd0 && board[8] != 8'd0 && board[4] == 8'd0 && board[0] == 8'd0) begin
						{board[12], board[8], board[4], board[0]} <= {board[8], 8'd0, 8'd0, 8'd0};
						{to_right[12], to_right[8], to_right[4], to_right[0]} <= {32'd0, 32'd1, 32'd0, 32'd0};
					end
					else if(board[12] != 8'd0 && board[8] == 8'd0 && board[4] == 8'd0 && board[0] == 8'd0) begin
						{board[12], board[8], board[4], board[0]} <= {board[12], 8'd0, 8'd0, 8'd0};
						{to_right[12], to_right[8], to_right[4], to_right[0]} <= {32'd0, 32'd0, 32'd0, 32'd0};
					end
					else if(board[12] == 8'd0 && board[8] == 8'd0 && board[4] != 8'd0 && board[0] != 8'd0) begin
						if(board[4] != board[0]) begin
							{board[12], board[8], board[4], board[0]} <= {board[4], board[0], 8'd0, 8'd0};
							{to_right[12], to_right[8], to_right[4], to_right[0]} <= {32'd0, 32'd0, 32'd2, 32'd2};
						end
						else begin
							{board[12], board[8], board[4], board[0]} <= {board[4]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_right[12], to_right[8], to_right[4], to_right[0]} <= {32'd0, 32'd0, 32'd2, 32'd3};
						end
					end
					else if(board[12] == 8'd0 && board[8] != 8'd0 && board[4] == 8'd0 && board[0] != 8'd0) begin
						if(board[8] != board[0]) begin
							{board[12], board[8], board[4], board[0]} <= {board[8], board[0], 8'd0, 8'd0};
							{to_right[12], to_right[8], to_right[4], to_right[0]} <= {32'd0, 32'd1, 32'd0, 32'd2};
						end
						else begin
							{board[12], board[8], board[4], board[0]} <= {board[8]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_right[12], to_right[8], to_right[4], to_right[0]} <= {32'd0, 32'd1, 32'd0, 32'd3};
						end
					end
					else if(board[12] != 8'd0 && board[8] == 8'd0 && board[4] == 8'd0 && board[0] != 8'd0) begin
						if(board[12] != board[0]) begin
							{board[12], board[8], board[4], board[0]} <= {board[12], board[0], 8'd0, 8'd0};
							{to_right[12], to_right[8], to_right[4], to_right[0]} <= {32'd0, 32'd0, 32'd0, 32'd2};
						end
						else begin
							{board[12], board[8], board[4], board[0]} <= {board[12]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_right[12], to_right[8], to_right[4], to_right[0]} <= {32'd0, 32'd0, 32'd0, 32'd3};
						end
					end
					else if(board[12] == 8'd0 && board[8] != 8'd0 && board[4] != 8'd0 && board[0] == 8'd0) begin
						if(board[8] != board[4]) begin
							{board[12], board[8], board[4], board[0]} <= {board[8], board[4], 8'd0, 8'd0};
							{to_right[12], to_right[8], to_right[4], to_right[0]} <= {32'd0, 32'd1, 32'd1, 32'd0};
						end
						else begin
							{board[12], board[8], board[4], board[0]} <= {board[8]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_right[12], to_right[8], to_right[4], to_right[0]} <= {32'd0, 32'd1, 32'd2, 32'd0};
						end
					end
					else if(board[12] != 8'd0 && board[8] == 8'd0 && board[4] != 8'd0 && board[0] == 8'd0) begin
						if(board[12] != board[4]) begin
							{board[12], board[8], board[4], board[0]} <= {board[12], board[4], 8'd0, 8'd0};
							{to_right[12], to_right[8], to_right[4], to_right[0]} <= {32'd0, 32'd0, 32'd1, 32'd0};
						end
						else begin
							{board[12], board[8], board[4], board[0]} <= {board[12]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_right[12], to_right[8], to_right[4], to_right[0]} <= {32'd0, 32'd0, 32'd2, 32'd0};
						end
					end
					else if(board[12] != 8'd0 && board[8] != 8'd0 && board[4] == 8'd0 && board[0] == 8'd0) begin
						if(board[12] != board[8]) begin
							{board[12], board[8], board[4], board[0]} <= {board[12], board[8], 8'd0, 8'd0};
							{to_right[12], to_right[8], to_right[4], to_right[0]} <= {32'd0, 32'd0, 32'd0, 32'd0};
						end
						else begin
							{board[12], board[8], board[4], board[0]} <= {board[12]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_right[12], to_right[8], to_right[4], to_right[0]} <= {32'd0, 32'd1, 32'd0, 32'd0};
						end
					end
					else if(board[12] != 8'd0 && board[8] != 8'd0 && board[4] != 8'd0 && board[0] == 8'd0) begin
						if(board[12] == board[8]) begin
							{board[12], board[8], board[4], board[0]} <= {board[12]+8'd1, board[4], 8'd0, 8'd0};
							{to_right[12], to_right[8], to_right[4], to_right[0]} <= {32'd0, 32'd1, 32'd1, 32'd0};
						end
						else if(board[8] == board[4]) begin
							{board[12], board[8], board[4], board[0]} <= {board[12], board[8]+8'd1, 8'd0, 8'd0};
							{to_right[12], to_right[8], to_right[4], to_right[0]} <= {32'd0, 32'd0, 32'd1, 32'd0};
						end
						else begin
							{board[12], board[8], board[4], board[0]} <= {board[12], board[8], board[4], 8'd0};
							{to_right[12], to_right[8], to_right[4], to_right[0]} <= {32'd0, 32'd0, 32'd0, 32'd0};
						end
					end
					else if(board[12] != 8'd0 && board[8] != 8'd0 && board[4] == 8'd0 && board[0] != 8'd0) begin
						if(board[12] == board[8]) begin
							{board[12], board[8], board[4], board[0]} <= {board[12]+8'd1, board[0], 8'd0, 8'd0};
							{to_right[12], to_right[8], to_right[4], to_right[0]} <= {32'd0, 32'd1, 32'd0, 32'd2};
						end
						else if(board[8] == board[0]) begin
							{board[12], board[8], board[4], board[0]} <= {board[12], board[8]+8'd1, 8'd0, 8'd0};
							{to_right[12], to_right[8], to_right[4], to_right[0]} <= {32'd0, 32'd0, 32'd0, 32'd2};
						end
						else begin
							{board[12], board[8], board[4], board[0]} <= {board[12], board[8], board[0], 8'd0};
							{to_right[12], to_right[8], to_right[4], to_right[0]} <= {32'd0, 32'd0, 32'd0, 32'd1};
						end
					end
					else if(board[12] != 8'd0 && board[8] == 8'd0 && board[4] != 8'd0 && board[0] != 8'd0) begin
						if(board[12] == board[4]) begin
							{board[12], board[8], board[4], board[0]} <= {board[12]+8'd1, board[0], 8'd0, 8'd0};
							{to_right[12], to_right[8], to_right[4], to_right[0]} <= {32'd0, 32'd0, 32'd2, 32'd2};
						end
						else if(board[4] == board[0]) begin
							{board[12], board[8], board[4], board[0]} <= {board[12], board[4]+8'd1, 8'd0, 8'd0};
							{to_right[12], to_right[8], to_right[4], to_right[0]} <= {32'd0, 32'd0, 32'd1, 32'd2};
						end
						else begin
							{board[12], board[8], board[4], board[0]} <= {board[12], board[4], board[0], 8'd0};
							{to_right[12], to_right[8], to_right[4], to_right[0]} <= {32'd0, 32'd0, 32'd1, 32'd1};
						end
					end
					else if(board[12] == 8'd0 && board[8] != 8'd0 && board[4] != 8'd0 && board[0] != 8'd0) begin
						if(board[8] == board[4]) begin
							{board[12], board[8], board[4], board[0]} <= {board[8]+8'd1, board[0], 8'd0, 8'd0};
							{to_right[12], to_right[8], to_right[4], to_right[0]} <= {32'd0, 32'd1, 32'd2, 32'd2};
						end
						else if(board[4] == board[0]) begin
							{board[12], board[8], board[4], board[0]} <= {board[8], board[4]+8'd1, 8'd0, 8'd0};
							{to_right[12], to_right[8], to_right[4], to_right[0]} <= {32'd0, 32'd1, 32'd1, 32'd2};
						end
						else begin
							{board[12], board[8], board[4], board[0]} <= {board[8], board[4], board[0], 8'd0};
							{to_right[12], to_right[8], to_right[4], to_right[0]} <= {32'd0, 32'd1, 32'd1, 32'd1};
						end
					end
					else begin
						if(board[12] == board[8]) begin
							if(board[4] == board[0]) begin
								{board[12], board[8], board[4], board[0]} <= {board[12]+8'd1, board[4]+8'd1, 8'd0, 8'd0};
								{to_right[12], to_right[8], to_right[4], to_right[0]} <= {32'd0, 32'd1, 32'd1, 32'd2};
							end
							else begin
								{board[12], board[8], board[4], board[0]} <= {board[12]+8'd1, board[4], board[0], 8'd0};
								{to_right[12], to_right[8], to_right[4], to_right[0]} <= {32'd0, 32'd1, 32'd1, 32'd1};
							end
						end
						else begin
							if(board[8] == board[4]) begin
								{board[12], board[8], board[4], board[0]} <= {board[12], board[8]+8'd1, board[0], 8'd0};
								{to_right[12], to_right[8], to_right[4], to_right[0]} <= {32'd0, 32'd0, 32'd1, 32'd1};
							end
							else if(board[4] == board[0]) begin
								{board[12], board[8], board[4], board[0]} <= {board[12], board[8], board[4]+8'd1, 8'd0};
								{to_right[12], to_right[8], to_right[4], to_right[0]} <= {32'd0, 32'd0, 32'd0, 32'd1};
							end
							else begin
								{board[12], board[8], board[4], board[0]} <= {board[12], board[8], board[4], board[0]};
								{to_right[12], to_right[8], to_right[4], to_right[0]} <= {32'd0, 32'd0, 32'd0, 32'd0};
							end
						end
					end
					
					if(board[13] == 8'd0 && board[9] == 8'd0 && board[5] == 8'd0 && board[1] == 8'd0) begin
						{board[13], board[9], board[5], board[1]} <= {8'd0, 8'd0, 8'd0, 8'd0};
						{to_right[13], to_right[9], to_right[5], to_right[1]} <= {32'd0, 32'd0, 32'd0, 32'd0};
					end
					else if(board[13] == 8'd0 && board[9] == 8'd0 && board[5] == 8'd0 && board[1] != 8'd0) begin
						{board[13], board[9], board[5], board[1]} <= {board[1], 8'd0, 8'd0, 8'd0};
						{to_right[13], to_right[9], to_right[5], to_right[1]} <= {32'd0, 32'd0, 32'd0, 32'd3};
					end
					else if(board[13] == 8'd0 && board[9] == 8'd0 && board[5] != 8'd0 && board[1] == 8'd0) begin
						{board[13], board[9], board[5], board[1]} <= {board[5], 8'd0, 8'd0, 8'd0};
						{to_right[13], to_right[9], to_right[5], to_right[1]} <= {32'd0, 32'd0, 32'd2, 32'd0};
					end
					else if(board[13] == 8'd0 && board[9] != 8'd0 && board[5] == 8'd0 && board[1] == 8'd0) begin
						{board[13], board[9], board[5], board[1]} <= {board[9], 8'd0, 8'd0, 8'd0};
						{to_right[13], to_right[9], to_right[5], to_right[1]} <= {32'd0, 32'd1, 32'd0, 32'd0};
					end
					else if(board[13] != 8'd0 && board[9] == 8'd0 && board[5] == 8'd0 && board[1] == 8'd0) begin
						{board[13], board[9], board[5], board[1]} <= {board[13], 8'd0, 8'd0, 8'd0};
						{to_right[13], to_right[9], to_right[5], to_right[1]} <= {32'd0, 32'd0, 32'd0, 32'd0};
					end
					else if(board[13] == 8'd0 && board[9] == 8'd0 && board[5] != 8'd0 && board[1] != 8'd0) begin
						if(board[5] != board[1]) begin
							{board[13], board[9], board[5], board[1]} <= {board[5], board[1], 8'd0, 8'd0};
							{to_right[13], to_right[9], to_right[5], to_right[1]} <= {32'd0, 32'd0, 32'd2, 32'd2};
						end
						else begin
							{board[13], board[9], board[5], board[1]} <= {board[5]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_right[13], to_right[9], to_right[5], to_right[1]} <= {32'd0, 32'd0, 32'd2, 32'd3};
						end
					end
					else if(board[13] == 8'd0 && board[9] != 8'd0 && board[5] == 8'd0 && board[1] != 8'd0) begin
						if(board[9] != board[1]) begin
							{board[13], board[9], board[5], board[1]} <= {board[9], board[1], 8'd0, 8'd0};
							{to_right[13], to_right[9], to_right[5], to_right[1]} <= {32'd0, 32'd1, 32'd0, 32'd2};
						end
						else begin
							{board[13], board[9], board[5], board[1]} <= {board[9]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_right[13], to_right[9], to_right[5], to_right[1]} <= {32'd0, 32'd1, 32'd0, 32'd3};
						end
					end
					else if(board[13] != 8'd0 && board[9] == 8'd0 && board[5] == 8'd0 && board[1] != 8'd0) begin
						if(board[13] != board[1]) begin
							{board[13], board[9], board[5], board[1]} <= {board[13], board[1], 8'd0, 8'd0};
							{to_right[13], to_right[9], to_right[5], to_right[1]} <= {32'd0, 32'd0, 32'd0, 32'd2};
						end
						else begin
							{board[13], board[9], board[5], board[1]} <= {board[13]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_right[13], to_right[9], to_right[5], to_right[1]} <= {32'd0, 32'd0, 32'd0, 32'd3};
						end
					end
					else if(board[13] == 8'd0 && board[9] != 8'd0 && board[5] != 8'd0 && board[1] == 8'd0) begin
						if(board[9] != board[5]) begin
							{board[13], board[9], board[5], board[1]} <= {board[9], board[5], 8'd0, 8'd0};
							{to_right[13], to_right[9], to_right[5], to_right[1]} <= {32'd0, 32'd1, 32'd1, 32'd0};
						end
						else begin
							{board[13], board[9], board[5], board[1]} <= {board[9]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_right[13], to_right[9], to_right[5], to_right[1]} <= {32'd0, 32'd1, 32'd2, 32'd0};
						end
					end
					else if(board[13] != 8'd0 && board[9] == 8'd0 && board[5] != 8'd0 && board[1] == 8'd0) begin
						if(board[13] != board[5]) begin
							{board[13], board[9], board[5], board[1]} <= {board[13], board[5], 8'd0, 8'd0};
							{to_right[13], to_right[9], to_right[5], to_right[1]} <= {32'd0, 32'd0, 32'd1, 32'd0};
						end
						else begin
							{board[13], board[9], board[5], board[1]} <= {board[13]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_right[13], to_right[9], to_right[5], to_right[1]} <= {32'd0, 32'd0, 32'd2, 32'd0};
						end
					end
					else if(board[13] != 8'd0 && board[9] != 8'd0 && board[5] == 8'd0 && board[1] == 8'd0) begin
						if(board[13] != board[9]) begin
							{board[13], board[9], board[5], board[1]} <= {board[13], board[9], 8'd0, 8'd0};
							{to_right[13], to_right[9], to_right[5], to_right[1]} <= {32'd0, 32'd0, 32'd0, 32'd0};
						end
						else begin
							{board[13], board[9], board[5], board[1]} <= {board[13]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_right[13], to_right[9], to_right[5], to_right[1]} <= {32'd0, 32'd1, 32'd0, 32'd0};
						end
					end
					else if(board[13] != 8'd0 && board[9] != 8'd0 && board[5] != 8'd0 && board[1] == 8'd0) begin
						if(board[13] == board[9]) begin
							{board[13], board[9], board[5], board[1]} <= {board[13]+8'd1, board[5], 8'd0, 8'd0};
							{to_right[13], to_right[9], to_right[5], to_right[1]} <= {32'd0, 32'd1, 32'd1, 32'd0};
						end
						else if(board[9] == board[5]) begin
							{board[13], board[9], board[5], board[1]} <= {board[13], board[9]+8'd1, 8'd0, 8'd0};
							{to_right[13], to_right[9], to_right[5], to_right[1]} <= {32'd0, 32'd0, 32'd1, 32'd0};
						end
						else begin
							{board[13], board[9], board[5], board[1]} <= {board[13], board[9], board[5], 8'd0};
							{to_right[13], to_right[9], to_right[5], to_right[1]} <= {32'd0, 32'd0, 32'd0, 32'd0};
						end
					end
					else if(board[13] != 8'd0 && board[9] != 8'd0 && board[5] == 8'd0 && board[1] != 8'd0) begin
						if(board[13] == board[9]) begin
							{board[13], board[9], board[5], board[1]} <= {board[13]+8'd1, board[1], 8'd0, 8'd0};
							{to_right[13], to_right[9], to_right[5], to_right[1]} <= {32'd0, 32'd1, 32'd0, 32'd2};
						end
						else if(board[9] == board[1]) begin
							{board[13], board[9], board[5], board[1]} <= {board[13], board[9]+8'd1, 8'd0, 8'd0};
							{to_right[13], to_right[9], to_right[5], to_right[1]} <= {32'd0, 32'd0, 32'd0, 32'd2};
						end
						else begin
							{board[13], board[9], board[5], board[1]} <= {board[13], board[9], board[1], 8'd0};
							{to_right[13], to_right[9], to_right[5], to_right[1]} <= {32'd0, 32'd0, 32'd0, 32'd1};
						end
					end
					else if(board[13] != 8'd0 && board[9] == 8'd0 && board[5] != 8'd0 && board[1] != 8'd0) begin
						if(board[13] == board[5]) begin
							{board[13], board[9], board[5], board[1]} <= {board[13]+8'd1, board[1], 8'd0, 8'd0};
							{to_right[13], to_right[9], to_right[5], to_right[1]} <= {32'd0, 32'd0, 32'd2, 32'd2};
						end
						else if(board[5] == board[1]) begin
							{board[13], board[9], board[5], board[1]} <= {board[13], board[5]+8'd1, 8'd0, 8'd0};
							{to_right[13], to_right[9], to_right[5], to_right[1]} <= {32'd0, 32'd0, 32'd1, 32'd2};
						end
						else begin
							{board[13], board[9], board[5], board[1]} <= {board[13], board[5], board[1], 8'd0};
							{to_right[13], to_right[9], to_right[5], to_right[1]} <= {32'd0, 32'd0, 32'd1, 32'd1};
						end
					end
					else if(board[13] == 8'd0 && board[9] != 8'd0 && board[5] != 8'd0 && board[1] != 8'd0) begin
						if(board[9] == board[5]) begin
							{board[13], board[9], board[5], board[1]} <= {board[9]+8'd1, board[1], 8'd0, 8'd0};
							{to_right[13], to_right[9], to_right[5], to_right[1]} <= {32'd0, 32'd1, 32'd2, 32'd2};
						end
						else if(board[5] == board[1]) begin
							{board[13], board[9], board[5], board[1]} <= {board[9], board[5]+8'd1, 8'd0, 8'd0};
							{to_right[13], to_right[9], to_right[5], to_right[1]} <= {32'd0, 32'd1, 32'd1, 32'd2};
						end
						else begin
							{board[13], board[9], board[5], board[1]} <= {board[9], board[5], board[1], 8'd0};
							{to_right[13], to_right[9], to_right[5], to_right[1]} <= {32'd0, 32'd1, 32'd1, 32'd1};
						end
					end
					else begin
						if(board[13] == board[9]) begin
							if(board[5] == board[1]) begin
								{board[13], board[9], board[5], board[1]} <= {board[13]+8'd1, board[5]+8'd1, 8'd0, 8'd0};
								{to_right[13], to_right[9], to_right[5], to_right[1]} <= {32'd0, 32'd1, 32'd1, 32'd2};
							end
							else begin
								{board[13], board[9], board[5], board[1]} <= {board[13]+8'd1, board[5], board[1], 8'd0};
								{to_right[13], to_right[9], to_right[5], to_right[1]} <= {32'd0, 32'd1, 32'd1, 32'd1};
							end
						end
						else begin
							if(board[9] == board[5]) begin
								{board[13], board[9], board[5], board[1]} <= {board[13], board[9]+8'd1, board[1], 8'd0};
								{to_right[13], to_right[9], to_right[5], to_right[1]} <= {32'd0, 32'd0, 32'd1, 32'd1};
							end
							else if(board[5] == board[1]) begin
								{board[13], board[9], board[5], board[1]} <= {board[13], board[9], board[5]+8'd1, 8'd0};
								{to_right[13], to_right[9], to_right[5], to_right[1]} <= {32'd0, 32'd0, 32'd0, 32'd1};
							end
							else begin
								{board[13], board[9], board[5], board[1]} <= {board[13], board[9], board[5], board[1]};
								{to_right[13], to_right[9], to_right[5], to_right[1]} <= {32'd0, 32'd0, 32'd0, 32'd0};
							end
						end
					end
					
					if(board[14] == 8'd0 && board[10] == 8'd0 && board[6] == 8'd0 && board[2] == 8'd0) begin
						{board[14], board[10], board[6], board[2]} <= {8'd0, 8'd0, 8'd0, 8'd0};
						{to_right[14], to_right[10], to_right[6], to_right[2]} <= {32'd0, 32'd0, 32'd0, 32'd0};
					end
					else if(board[14] == 8'd0 && board[10] == 8'd0 && board[6] == 8'd0 && board[2] != 8'd0) begin
						{board[14], board[10], board[6], board[2]} <= {board[2], 8'd0, 8'd0, 8'd0};
						{to_right[14], to_right[10], to_right[6], to_right[2]} <= {32'd0, 32'd0, 32'd0, 32'd3};
					end
					else if(board[14] == 8'd0 && board[10] == 8'd0 && board[6] != 8'd0 && board[2] == 8'd0) begin
						{board[14], board[10], board[6], board[2]} <= {board[6], 8'd0, 8'd0, 8'd0};
						{to_right[14], to_right[10], to_right[6], to_right[2]} <= {32'd0, 32'd0, 32'd2, 32'd0};
					end
					else if(board[14] == 8'd0 && board[10] != 8'd0 && board[6] == 8'd0 && board[2] == 8'd0) begin
						{board[14], board[10], board[6], board[2]} <= {board[10], 8'd0, 8'd0, 8'd0};
						{to_right[14], to_right[10], to_right[6], to_right[2]} <= {32'd0, 32'd1, 32'd0, 32'd0};
					end
					else if(board[14] != 8'd0 && board[10] == 8'd0 && board[6] == 8'd0 && board[2] == 8'd0) begin
						{board[14], board[10], board[6], board[2]} <= {board[14], 8'd0, 8'd0, 8'd0};
						{to_right[14], to_right[10], to_right[6], to_right[2]} <= {32'd0, 32'd0, 32'd0, 32'd0};
					end
					else if(board[14] == 8'd0 && board[10] == 8'd0 && board[6] != 8'd0 && board[2] != 8'd0) begin
						if(board[6] != board[2]) begin
							{board[14], board[10], board[6], board[2]} <= {board[6], board[2], 8'd0, 8'd0};
							{to_right[14], to_right[10], to_right[6], to_right[2]} <= {32'd0, 32'd0, 32'd2, 32'd2};
						end
						else begin
							{board[14], board[10], board[6], board[2]} <= {board[6]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_right[14], to_right[10], to_right[6], to_right[2]} <= {32'd0, 32'd0, 32'd2, 32'd3};
						end
					end
					else if(board[14] == 8'd0 && board[10] != 8'd0 && board[6] == 8'd0 && board[2] != 8'd0) begin
						if(board[10] != board[2]) begin
							{board[14], board[10], board[6], board[2]} <= {board[10], board[2], 8'd0, 8'd0};
							{to_right[14], to_right[10], to_right[6], to_right[2]} <= {32'd0, 32'd1, 32'd0, 32'd2};
						end
						else begin
							{board[14], board[10], board[6], board[2]} <= {board[10]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_right[14], to_right[10], to_right[6], to_right[2]} <= {32'd0, 32'd1, 32'd0, 32'd3};
						end
					end
					else if(board[14] != 8'd0 && board[10] == 8'd0 && board[6] == 8'd0 && board[2] != 8'd0) begin
						if(board[14] != board[2]) begin
							{board[14], board[10], board[6], board[2]} <= {board[14], board[2], 8'd0, 8'd0};
							{to_right[14], to_right[10], to_right[6], to_right[2]} <= {32'd0, 32'd0, 32'd0, 32'd2};
						end
						else begin
							{board[14], board[10], board[6], board[2]} <= {board[14]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_right[14], to_right[10], to_right[6], to_right[2]} <= {32'd0, 32'd0, 32'd0, 32'd3};
						end
					end
					else if(board[14] == 8'd0 && board[10] != 8'd0 && board[6] != 8'd0 && board[2] == 8'd0) begin
						if(board[10] != board[6]) begin
							{board[14], board[10], board[6], board[2]} <= {board[10], board[6], 8'd0, 8'd0};
							{to_right[14], to_right[10], to_right[6], to_right[2]} <= {32'd0, 32'd1, 32'd1, 32'd0};
						end
						else begin
							{board[14], board[10], board[6], board[2]} <= {board[10]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_right[14], to_right[10], to_right[6], to_right[2]} <= {32'd0, 32'd1, 32'd2, 32'd0};
						end
					end
					else if(board[14] != 8'd0 && board[10] == 8'd0 && board[6] != 8'd0 && board[2] == 8'd0) begin
						if(board[14] != board[6]) begin
							{board[14], board[10], board[6], board[2]} <= {board[14], board[6], 8'd0, 8'd0};
							{to_right[14], to_right[10], to_right[6], to_right[2]} <= {32'd0, 32'd0, 32'd1, 32'd0};
						end
						else begin
							{board[14], board[10], board[6], board[2]} <= {board[14]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_right[14], to_right[10], to_right[6], to_right[2]} <= {32'd0, 32'd0, 32'd2, 32'd0};
						end
					end
					else if(board[14] != 8'd0 && board[10] != 8'd0 && board[6] == 8'd0 && board[2] == 8'd0) begin
						if(board[14] != board[10]) begin
							{board[14], board[10], board[6], board[2]} <= {board[14], board[10], 8'd0, 8'd0};
							{to_right[14], to_right[10], to_right[6], to_right[2]} <= {32'd0, 32'd0, 32'd0, 32'd0};
						end
						else begin
							{board[14], board[10], board[6], board[2]} <= {board[14]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_right[14], to_right[10], to_right[6], to_right[2]} <= {32'd0, 32'd1, 32'd0, 32'd0};
						end
					end
					else if(board[14] != 8'd0 && board[10] != 8'd0 && board[6] != 8'd0 && board[2] == 8'd0) begin
						if(board[14] == board[10]) begin
							{board[14], board[10], board[6], board[2]} <= {board[14]+8'd1, board[6], 8'd0, 8'd0};
							{to_right[14], to_right[10], to_right[6], to_right[2]} <= {32'd0, 32'd1, 32'd1, 32'd0};
						end
						else if(board[10] == board[6]) begin
							{board[14], board[10], board[6], board[2]} <= {board[14], board[10]+8'd1, 8'd0, 8'd0};
							{to_right[14], to_right[10], to_right[6], to_right[2]} <= {32'd0, 32'd0, 32'd1, 32'd0};
						end
						else begin
							{board[14], board[10], board[6], board[2]} <= {board[14], board[10], board[6], 8'd0};
							{to_right[14], to_right[10], to_right[6], to_right[2]} <= {32'd0, 32'd0, 32'd0, 32'd0};
						end
					end
					else if(board[14] != 8'd0 && board[10] != 8'd0 && board[6] == 8'd0 && board[2] != 8'd0) begin
						if(board[14] == board[10]) begin
							{board[14], board[10], board[6], board[2]} <= {board[14]+8'd1, board[2], 8'd0, 8'd0};
							{to_right[14], to_right[10], to_right[6], to_right[2]} <= {32'd0, 32'd1, 32'd0, 32'd2};
						end
						else if(board[10] == board[2]) begin
							{board[14], board[10], board[6], board[2]} <= {board[14], board[10]+8'd1, 8'd0, 8'd0};
							{to_right[14], to_right[10], to_right[6], to_right[2]} <= {32'd0, 32'd0, 32'd0, 32'd2};
						end
						else begin
							{board[14], board[10], board[6], board[2]} <= {board[14], board[10], board[2], 8'd0};
							{to_right[14], to_right[10], to_right[6], to_right[2]} <= {32'd0, 32'd0, 32'd0, 32'd1};
						end
					end
					else if(board[14] != 8'd0 && board[10] == 8'd0 && board[6] != 8'd0 && board[2] != 8'd0) begin
						if(board[14] == board[6]) begin
							{board[14], board[10], board[6], board[2]} <= {board[14]+8'd1, board[2], 8'd0, 8'd0};
							{to_right[14], to_right[10], to_right[6], to_right[2]} <= {32'd0, 32'd0, 32'd2, 32'd2};
						end
						else if(board[6] == board[2]) begin
							{board[14], board[10], board[6], board[2]} <= {board[14], board[6]+8'd1, 8'd0, 8'd0};
							{to_right[14], to_right[10], to_right[6], to_right[2]} <= {32'd0, 32'd0, 32'd1, 32'd2};
						end
						else begin
							{board[14], board[10], board[6], board[2]} <= {board[14], board[6], board[2], 8'd0};
							{to_right[14], to_right[10], to_right[6], to_right[2]} <= {32'd0, 32'd0, 32'd1, 32'd1};
						end
					end
					else if(board[14] == 8'd0 && board[10] != 8'd0 && board[6] != 8'd0 && board[2] != 8'd0) begin
						if(board[10] == board[6]) begin
							{board[14], board[10], board[6], board[2]} <= {board[10]+8'd1, board[2], 8'd0, 8'd0};
							{to_right[14], to_right[10], to_right[6], to_right[2]} <= {32'd0, 32'd1, 32'd2, 32'd2};
						end
						else if(board[6] == board[2]) begin
							{board[14], board[10], board[6], board[2]} <= {board[10], board[6]+8'd1, 8'd0, 8'd0};
							{to_right[14], to_right[10], to_right[6], to_right[2]} <= {32'd0, 32'd1, 32'd1, 32'd2};
						end
						else begin
							{board[14], board[10], board[6], board[2]} <= {board[10], board[6], board[2], 8'd0};
							{to_right[14], to_right[10], to_right[6], to_right[2]} <= {32'd0, 32'd1, 32'd1, 32'd1};
						end
					end
					else begin
						if(board[14] == board[10]) begin
							if(board[6] == board[2]) begin
								{board[14], board[10], board[6], board[2]} <= {board[14]+8'd1, board[6]+8'd1, 8'd0, 8'd0};
								{to_right[14], to_right[10], to_right[6], to_right[2]} <= {32'd0, 32'd1, 32'd1, 32'd2};
							end
							else begin
								{board[14], board[10], board[6], board[2]} <= {board[14]+8'd1, board[6], board[2], 8'd0};
								{to_right[14], to_right[10], to_right[6], to_right[2]} <= {32'd0, 32'd1, 32'd1, 32'd1};
							end
						end
						else begin
							if(board[10] == board[6]) begin
								{board[14], board[10], board[6], board[2]} <= {board[14], board[10]+8'd1, board[2], 8'd0};
								{to_right[14], to_right[10], to_right[6], to_right[2]} <= {32'd0, 32'd0, 32'd1, 32'd1};
							end
							else if(board[6] == board[2]) begin
								{board[14], board[10], board[6], board[2]} <= {board[14], board[10], board[6]+8'd1, 8'd0};
								{to_right[14], to_right[10], to_right[6], to_right[2]} <= {32'd0, 32'd0, 32'd0, 32'd1};
							end
							else begin
								{board[14], board[10], board[6], board[2]} <= {board[14], board[10], board[6], board[2]};
								{to_right[14], to_right[10], to_right[6], to_right[2]} <= {32'd0, 32'd0, 32'd0, 32'd0};
							end
						end
					end
					
					if(board[15] == 8'd0 && board[11] == 8'd0 && board[7] == 8'd0 && board[3] == 8'd0) begin
						{board[15], board[11], board[7], board[3]} <= {8'd0, 8'd0, 8'd0, 8'd0};
						{to_right[15], to_right[11], to_right[7], to_right[3]} <= {32'd0, 32'd0, 32'd0, 32'd0};
					end
					else if(board[15] == 8'd0 && board[11] == 8'd0 && board[7] == 8'd0 && board[3] != 8'd0) begin
						{board[15], board[11], board[7], board[3]} <= {board[3], 8'd0, 8'd0, 8'd0};
						{to_right[15], to_right[11], to_right[7], to_right[3]} <= {32'd0, 32'd0, 32'd0, 32'd3};
					end
					else if(board[15] == 8'd0 && board[11] == 8'd0 && board[7] != 8'd0 && board[3] == 8'd0) begin
						{board[15], board[11], board[7], board[3]} <= {board[7], 8'd0, 8'd0, 8'd0};
						{to_right[15], to_right[11], to_right[7], to_right[3]} <= {32'd0, 32'd0, 32'd2, 32'd0};
					end
					else if(board[15] == 8'd0 && board[11] != 8'd0 && board[7] == 8'd0 && board[3] == 8'd0) begin
						{board[15], board[11], board[7], board[3]} <= {board[11], 8'd0, 8'd0, 8'd0};
						{to_right[15], to_right[11], to_right[7], to_right[3]} <= {32'd0, 32'd1, 32'd0, 32'd0};
					end
					else if(board[15] != 8'd0 && board[11] == 8'd0 && board[7] == 8'd0 && board[3] == 8'd0) begin
						{board[15], board[11], board[7], board[3]} <= {board[15], 8'd0, 8'd0, 8'd0};
						{to_right[15], to_right[11], to_right[7], to_right[3]} <= {32'd0, 32'd0, 32'd0, 32'd0};
					end
					else if(board[15] == 8'd0 && board[11] == 8'd0 && board[7] != 8'd0 && board[3] != 8'd0) begin
						if(board[7] != board[3]) begin
							{board[15], board[11], board[7], board[3]} <= {board[7], board[3], 8'd0, 8'd0};
							{to_right[15], to_right[11], to_right[7], to_right[3]} <= {32'd0, 32'd0, 32'd2, 32'd2};
						end
						else begin
							{board[15], board[11], board[7], board[3]} <= {board[7]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_right[15], to_right[11], to_right[7], to_right[3]} <= {32'd0, 32'd0, 32'd2, 32'd3};
						end
					end
					else if(board[15] == 8'd0 && board[11] != 8'd0 && board[7] == 8'd0 && board[3] != 8'd0) begin
						if(board[11] != board[3]) begin
							{board[15], board[11], board[7], board[3]} <= {board[11], board[3], 8'd0, 8'd0};
							{to_right[15], to_right[11], to_right[7], to_right[3]} <= {32'd0, 32'd1, 32'd0, 32'd2};
						end
						else begin
							{board[15], board[11], board[7], board[3]} <= {board[11]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_right[15], to_right[11], to_right[7], to_right[3]} <= {32'd0, 32'd1, 32'd0, 32'd3};
						end
					end
					else if(board[15] != 8'd0 && board[11] == 8'd0 && board[7] == 8'd0 && board[3] != 8'd0) begin
						if(board[15] != board[3]) begin
							{board[15], board[11], board[7], board[3]} <= {board[15], board[3], 8'd0, 8'd0};
							{to_right[15], to_right[11], to_right[7], to_right[3]} <= {32'd0, 32'd0, 32'd0, 32'd2};
						end
						else begin
							{board[15], board[11], board[7], board[3]} <= {board[15]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_right[15], to_right[11], to_right[7], to_right[3]} <= {32'd0, 32'd0, 32'd0, 32'd3};
						end
					end
					else if(board[15] == 8'd0 && board[11] != 8'd0 && board[7] != 8'd0 && board[3] == 8'd0) begin
						if(board[11] != board[7]) begin
							{board[15], board[11], board[7], board[3]} <= {board[11], board[7], 8'd0, 8'd0};
							{to_right[15], to_right[11], to_right[7], to_right[3]} <= {32'd0, 32'd1, 32'd1, 32'd0};
						end
						else begin
							{board[15], board[11], board[7], board[3]} <= {board[11]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_right[15], to_right[11], to_right[7], to_right[3]} <= {32'd0, 32'd1, 32'd2, 32'd0};
						end
					end
					else if(board[15] != 8'd0 && board[11] == 8'd0 && board[7] != 8'd0 && board[3] == 8'd0) begin
						if(board[15] != board[7]) begin
							{board[15], board[11], board[7], board[3]} <= {board[15], board[7], 8'd0, 8'd0};
							{to_right[15], to_right[11], to_right[7], to_right[3]} <= {32'd0, 32'd0, 32'd1, 32'd0};
						end
						else begin
							{board[15], board[11], board[7], board[3]} <= {board[15]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_right[15], to_right[11], to_right[7], to_right[3]} <= {32'd0, 32'd0, 32'd2, 32'd0};
						end
					end
					else if(board[15] != 8'd0 && board[11] != 8'd0 && board[7] == 8'd0 && board[3] == 8'd0) begin
						if(board[15] != board[11]) begin
							{board[15], board[11], board[7], board[3]} <= {board[15], board[11], 8'd0, 8'd0};
							{to_right[15], to_right[11], to_right[7], to_right[3]} <= {32'd0, 32'd0, 32'd0, 32'd0};
						end
						else begin
							{board[15], board[11], board[7], board[3]} <= {board[15]+8'd1, 8'd0, 8'd0, 8'd0};
							{to_right[15], to_right[11], to_right[7], to_right[3]} <= {32'd0, 32'd1, 32'd0, 32'd0};
						end
					end
					else if(board[15] != 8'd0 && board[11] != 8'd0 && board[7] != 8'd0 && board[3] == 8'd0) begin
						if(board[15] == board[11]) begin
							{board[15], board[11], board[7], board[3]} <= {board[15]+8'd1, board[7], 8'd0, 8'd0};
							{to_right[15], to_right[11], to_right[7], to_right[3]} <= {32'd0, 32'd1, 32'd1, 32'd0};
						end
						else if(board[11] == board[7]) begin
							{board[15], board[11], board[7], board[3]} <= {board[15], board[11]+8'd1, 8'd0, 8'd0};
							{to_right[15], to_right[11], to_right[7], to_right[3]} <= {32'd0, 32'd0, 32'd1, 32'd0};
						end
						else begin
							{board[15], board[11], board[7], board[3]} <= {board[15], board[11], board[7], 8'd0};
							{to_right[15], to_right[11], to_right[7], to_right[3]} <= {32'd0, 32'd0, 32'd0, 32'd0};
						end
					end
					else if(board[15] != 8'd0 && board[11] != 8'd0 && board[7] == 8'd0 && board[3] != 8'd0) begin
						if(board[15] == board[11]) begin
							{board[15], board[11], board[7], board[3]} <= {board[15]+8'd1, board[3], 8'd0, 8'd0};
							{to_right[15], to_right[11], to_right[7], to_right[3]} <= {32'd0, 32'd1, 32'd0, 32'd2};
						end
						else if(board[11] == board[3]) begin
							{board[15], board[11], board[7], board[3]} <= {board[15], board[11]+8'd1, 8'd0, 8'd0};
							{to_right[15], to_right[11], to_right[7], to_right[3]} <= {32'd0, 32'd0, 32'd0, 32'd2};
						end
						else begin
							{board[15], board[11], board[7], board[3]} <= {board[15], board[11], board[3], 8'd0};
							{to_right[15], to_right[11], to_right[7], to_right[3]} <= {32'd0, 32'd0, 32'd0, 32'd1};
						end
					end
					else if(board[15] != 8'd0 && board[11] == 8'd0 && board[7] != 8'd0 && board[3] != 8'd0) begin
						if(board[15] == board[7]) begin
							{board[15], board[11], board[7], board[3]} <= {board[15]+8'd1, board[3], 8'd0, 8'd0};
							{to_right[15], to_right[11], to_right[7], to_right[3]} <= {32'd0, 32'd0, 32'd2, 32'd2};
						end
						else if(board[7] == board[3]) begin
							{board[15], board[11], board[7], board[3]} <= {board[15], board[7]+8'd1, 8'd0, 8'd0};
							{to_right[15], to_right[11], to_right[7], to_right[3]} <= {32'd0, 32'd0, 32'd1, 32'd2};
						end
						else begin
							{board[15], board[11], board[7], board[3]} <= {board[15], board[7], board[3], 8'd0};
							{to_right[15], to_right[11], to_right[7], to_right[3]} <= {32'd0, 32'd0, 32'd1, 32'd1};
						end
					end
					else if(board[15] == 8'd0 && board[11] != 8'd0 && board[7] != 8'd0 && board[3] != 8'd0) begin
						if(board[11] == board[7]) begin
							{board[15], board[11], board[7], board[3]} <= {board[11]+8'd1, board[3], 8'd0, 8'd0};
							{to_right[15], to_right[11], to_right[7], to_right[3]} <= {32'd0, 32'd1, 32'd2, 32'd2};
						end
						else if(board[7] == board[3]) begin
							{board[15], board[11], board[7], board[3]} <= {board[11], board[7]+8'd1, 8'd0, 8'd0};
							{to_right[15], to_right[11], to_right[7], to_right[3]} <= {32'd0, 32'd1, 32'd1, 32'd2};
						end
						else begin
							{board[15], board[11], board[7], board[3]} <= {board[11], board[7], board[3], 8'd0};
							{to_right[15], to_right[11], to_right[7], to_right[3]} <= {32'd0, 32'd1, 32'd1, 32'd1};
						end
					end
					else begin
						if(board[15] == board[11]) begin
							if(board[7] == board[3]) begin
								{board[15], board[11], board[7], board[3]} <= {board[15]+8'd1, board[7]+8'd1, 8'd0, 8'd0};
								{to_right[15], to_right[11], to_right[7], to_right[3]} <= {32'd0, 32'd1, 32'd1, 32'd2};
							end
							else begin
								{board[15], board[11], board[7], board[3]} <= {board[15]+8'd1, board[7], board[3], 8'd0};
								{to_right[15], to_right[11], to_right[7], to_right[3]} <= {32'd0, 32'd1, 32'd1, 32'd1};
							end
						end
						else begin
							if(board[11] == board[7]) begin
								{board[15], board[11], board[7], board[3]} <= {board[15], board[11]+8'd1, board[3], 8'd0};
								{to_right[15], to_right[11], to_right[7], to_right[3]} <= {32'd0, 32'd0, 32'd1, 32'd1};
							end
							else if(board[7] == board[3]) begin
								{board[15], board[11], board[7], board[3]} <= {board[15], board[11], board[7]+8'd1, 8'd0};
								{to_right[15], to_right[11], to_right[7], to_right[3]} <= {32'd0, 32'd0, 32'd0, 32'd1};
							end
							else begin
								{board[15], board[11], board[7], board[3]} <= {board[15], board[11], board[7], board[3]};
								{to_right[15], to_right[11], to_right[7], to_right[3]} <= {32'd0, 32'd0, 32'd0, 32'd0};
							end
						end
					end
				end
				if((!up || !down || !left || !right) && !activeflag) begin
					moveflag <= 1'b1;
				end
			end
			if(moveflag) begin
				if({board[0],board[1],board[2],board[3]} != {origin[0],origin[1],origin[2],origin[3]}) moveflag_2 <= 1'b1;
				else if({board[4],board[5],board[6],board[7]} != {origin[4],origin[5],origin[6],origin[7]}) moveflag_2 <= 1'b1;
				else if({board[8],board[9],board[10],board[11]} != {origin[8],origin[9],origin[10],origin[11]}) moveflag_2 <= 1'b1;
				else if({board[12],board[13],board[14],board[15]} != {origin[12],origin[13],origin[14],origin[15]}) moveflag_2 <= 1'b1;
				moveflag <= 1'b0;
			end
			if(appearflag) begin
				if(board[clockcounter[12:9]] == 8'd0) begin
					appearflag <= 1'b0;
					board[clockcounter[12:9]] <= (clockcounter[13:11] > 0)?8'd1:8'd2;
				end
			end
		end
	end
endmodule
