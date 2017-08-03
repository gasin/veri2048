
module display(row, col, red, green, blue, color, up, down, left, right, vnotactive, CLK, RST);
	input [31:0] row, col;
	input CLK, RST, color, up, down, left, right, vnotactive;
	output red, green, blue;
	reg red, green, blue;
	reg activeflag;
	reg appearflag;
	reg moveflag;
    reg moveflag_2;
	reg endflag;
	reg [31:0] clockcounter;
	reg [7:0] board [0:15];
	reg [3:0] cell_index;
	reg [31:0] cell_position_row [0:15];
	reg [31:0] cell_position_col [0:15];
    reg [31:0] to_left [0:15];
    reg [31:0] to_right [0:15];
    reg [31:0] to_up [0:15];
    reg [31:0] to_down [0:15];
    reg [31:0] movecounter;
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
            
            movecounter <= 32'd0;
            
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
				else if(board[cell_index] == 8'd0) {red, green, blue} <= 3'b111;
				else if(board[cell_index] == 8'd1) begin
					if(row >= cell_position_row[cell_index] + 10 +3*6 && row < cell_position_row[cell_index]+10+(3+1)*6 && col >= cell_position_col[cell_index]+10+2*6 && col < cell_position_col[cell_index]+10+(2+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +7*6 && row < cell_position_row[cell_index]+10+(7+1)*6 && col >= cell_position_col[cell_index]+10+2*6 && col < cell_position_col[cell_index]+10+(2+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +1*6 && row < cell_position_row[cell_index]+10+(1+1)*6 && col >= cell_position_col[cell_index]+10+3*6 && col < cell_position_col[cell_index]+10+(3+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +2*6 && row < cell_position_row[cell_index]+10+(2+1)*6 && col >= cell_position_col[cell_index]+10+3*6 && col < cell_position_col[cell_index]+10+(3+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +6*6 && row < cell_position_row[cell_index]+10+(6+1)*6 && col >= cell_position_col[cell_index]+10+3*6 && col < cell_position_col[cell_index]+10+(3+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +7*6 && row < cell_position_row[cell_index]+10+(7+1)*6 && col >= cell_position_col[cell_index]+10+3*6 && col < cell_position_col[cell_index]+10+(3+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +1*6 && row < cell_position_row[cell_index]+10+(1+1)*6 && col >= cell_position_col[cell_index]+10+4*6 && col < cell_position_col[cell_index]+10+(4+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +5*6 && row < cell_position_row[cell_index]+10+(5+1)*6 && col >= cell_position_col[cell_index]+10+4*6 && col < cell_position_col[cell_index]+10+(4+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +7*6 && row < cell_position_row[cell_index]+10+(7+1)*6 && col >= cell_position_col[cell_index]+10+4*6 && col < cell_position_col[cell_index]+10+(4+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +1*6 && row < cell_position_row[cell_index]+10+(1+1)*6 && col >= cell_position_col[cell_index]+10+5*6 && col < cell_position_col[cell_index]+10+(5+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +2*6 && row < cell_position_row[cell_index]+10+(2+1)*6 && col >= cell_position_col[cell_index]+10+5*6 && col < cell_position_col[cell_index]+10+(5+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +5*6 && row < cell_position_row[cell_index]+10+(5+1)*6 && col >= cell_position_col[cell_index]+10+5*6 && col < cell_position_col[cell_index]+10+(5+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +7*6 && row < cell_position_row[cell_index]+10+(7+1)*6 && col >= cell_position_col[cell_index]+10+5*6 && col < cell_position_col[cell_index]+10+(5+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +3*6 && row < cell_position_row[cell_index]+10+(3+1)*6 && col >= cell_position_col[cell_index]+10+6*6 && col < cell_position_col[cell_index]+10+(6+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +4*6 && row < cell_position_row[cell_index]+10+(4+1)*6 && col >= cell_position_col[cell_index]+10+6*6 && col < cell_position_col[cell_index]+10+(6+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +7*6 && row < cell_position_row[cell_index]+10+(7+1)*6 && col >= cell_position_col[cell_index]+10+6*6 && col < cell_position_col[cell_index]+10+(6+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +7*6 && row < cell_position_row[cell_index]+10+(7+1)*6 && col >= cell_position_col[cell_index]+10+7*6 && col < cell_position_col[cell_index]+10+(7+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +7*6 && row < cell_position_row[cell_index]+10+(7+1)*6 && col >= cell_position_col[cell_index]+10+8*6 && col < cell_position_col[cell_index]+10+(8+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else {red, green, blue} <= 3'b100;
				end
				else if(board[cell_index] == 8'd2) begin
					if(row >= cell_position_row[cell_index] + 10 +5*6 && row < cell_position_row[cell_index]+10+(5+1)*6 && col >= cell_position_col[cell_index]+10+0*6 && col < cell_position_col[cell_index]+10+(0+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +4*6 && row < cell_position_row[cell_index]+10+(4+1)*6 && col >= cell_position_col[cell_index]+10+1*6 && col < cell_position_col[cell_index]+10+(1+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +5*6 && row < cell_position_row[cell_index]+10+(5+1)*6 && col >= cell_position_col[cell_index]+10+1*6 && col < cell_position_col[cell_index]+10+(1+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +3*6 && row < cell_position_row[cell_index]+10+(3+1)*6 && col >= cell_position_col[cell_index]+10+2*6 && col < cell_position_col[cell_index]+10+(2+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +4*6 && row < cell_position_row[cell_index]+10+(4+1)*6 && col >= cell_position_col[cell_index]+10+2*6 && col < cell_position_col[cell_index]+10+(2+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +5*6 && row < cell_position_row[cell_index]+10+(5+1)*6 && col >= cell_position_col[cell_index]+10+2*6 && col < cell_position_col[cell_index]+10+(2+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +1*6 && row < cell_position_row[cell_index]+10+(1+1)*6 && col >= cell_position_col[cell_index]+10+3*6 && col < cell_position_col[cell_index]+10+(3+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +2*6 && row < cell_position_row[cell_index]+10+(2+1)*6 && col >= cell_position_col[cell_index]+10+3*6 && col < cell_position_col[cell_index]+10+(3+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +3*6 && row < cell_position_row[cell_index]+10+(3+1)*6 && col >= cell_position_col[cell_index]+10+3*6 && col < cell_position_col[cell_index]+10+(3+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +5*6 && row < cell_position_row[cell_index]+10+(5+1)*6 && col >= cell_position_col[cell_index]+10+3*6 && col < cell_position_col[cell_index]+10+(3+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +5*6 && row < cell_position_row[cell_index]+10+(5+1)*6 && col >= cell_position_col[cell_index]+10+4*6 && col < cell_position_col[cell_index]+10+(4+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +5*6 && row < cell_position_row[cell_index]+10+(5+1)*6 && col >= cell_position_col[cell_index]+10+5*6 && col < cell_position_col[cell_index]+10+(5+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +2*6 && row < cell_position_row[cell_index]+10+(2+1)*6 && col >= cell_position_col[cell_index]+10+6*6 && col < cell_position_col[cell_index]+10+(6+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +3*6 && row < cell_position_row[cell_index]+10+(3+1)*6 && col >= cell_position_col[cell_index]+10+6*6 && col < cell_position_col[cell_index]+10+(6+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +4*6 && row < cell_position_row[cell_index]+10+(4+1)*6 && col >= cell_position_col[cell_index]+10+6*6 && col < cell_position_col[cell_index]+10+(6+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +5*6 && row < cell_position_row[cell_index]+10+(5+1)*6 && col >= cell_position_col[cell_index]+10+6*6 && col < cell_position_col[cell_index]+10+(6+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +6*6 && row < cell_position_row[cell_index]+10+(6+1)*6 && col >= cell_position_col[cell_index]+10+6*6 && col < cell_position_col[cell_index]+10+(6+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +7*6 && row < cell_position_row[cell_index]+10+(7+1)*6 && col >= cell_position_col[cell_index]+10+6*6 && col < cell_position_col[cell_index]+10+(6+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +8*6 && row < cell_position_row[cell_index]+10+(8+1)*6 && col >= cell_position_col[cell_index]+10+6*6 && col < cell_position_col[cell_index]+10+(6+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +5*6 && row < cell_position_row[cell_index]+10+(5+1)*6 && col >= cell_position_col[cell_index]+10+7*6 && col < cell_position_col[cell_index]+10+(7+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +5*6 && row < cell_position_row[cell_index]+10+(5+1)*6 && col >= cell_position_col[cell_index]+10+8*6 && col < cell_position_col[cell_index]+10+(8+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else {red, green, blue} <= 3'b010;
				end
				else if(board[cell_index] == 8'd3) begin
					if(row >= cell_position_row[cell_index] + 10 +2*6 && row < cell_position_row[cell_index]+10+(2+1)*6 && col >= cell_position_col[cell_index]+10+2*6 && col < cell_position_col[cell_index]+10+(2+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +3*6 && row < cell_position_row[cell_index]+10+(3+1)*6 && col >= cell_position_col[cell_index]+10+2*6 && col < cell_position_col[cell_index]+10+(2+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +5*6 && row < cell_position_row[cell_index]+10+(5+1)*6 && col >= cell_position_col[cell_index]+10+2*6 && col < cell_position_col[cell_index]+10+(2+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +6*6 && row < cell_position_row[cell_index]+10+(6+1)*6 && col >= cell_position_col[cell_index]+10+2*6 && col < cell_position_col[cell_index]+10+(2+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +7*6 && row < cell_position_row[cell_index]+10+(7+1)*6 && col >= cell_position_col[cell_index]+10+2*6 && col < cell_position_col[cell_index]+10+(2+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +1*6 && row < cell_position_row[cell_index]+10+(1+1)*6 && col >= cell_position_col[cell_index]+10+3*6 && col < cell_position_col[cell_index]+10+(3+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +4*6 && row < cell_position_row[cell_index]+10+(4+1)*6 && col >= cell_position_col[cell_index]+10+3*6 && col < cell_position_col[cell_index]+10+(3+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +8*6 && row < cell_position_row[cell_index]+10+(8+1)*6 && col >= cell_position_col[cell_index]+10+3*6 && col < cell_position_col[cell_index]+10+(3+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +1*6 && row < cell_position_row[cell_index]+10+(1+1)*6 && col >= cell_position_col[cell_index]+10+4*6 && col < cell_position_col[cell_index]+10+(4+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +4*6 && row < cell_position_row[cell_index]+10+(4+1)*6 && col >= cell_position_col[cell_index]+10+4*6 && col < cell_position_col[cell_index]+10+(4+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +8*6 && row < cell_position_row[cell_index]+10+(8+1)*6 && col >= cell_position_col[cell_index]+10+4*6 && col < cell_position_col[cell_index]+10+(4+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +1*6 && row < cell_position_row[cell_index]+10+(1+1)*6 && col >= cell_position_col[cell_index]+10+5*6 && col < cell_position_col[cell_index]+10+(5+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +4*6 && row < cell_position_row[cell_index]+10+(4+1)*6 && col >= cell_position_col[cell_index]+10+5*6 && col < cell_position_col[cell_index]+10+(5+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +8*6 && row < cell_position_row[cell_index]+10+(8+1)*6 && col >= cell_position_col[cell_index]+10+5*6 && col < cell_position_col[cell_index]+10+(5+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +2*6 && row < cell_position_row[cell_index]+10+(2+1)*6 && col >= cell_position_col[cell_index]+10+6*6 && col < cell_position_col[cell_index]+10+(6+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +3*6 && row < cell_position_row[cell_index]+10+(3+1)*6 && col >= cell_position_col[cell_index]+10+6*6 && col < cell_position_col[cell_index]+10+(6+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +5*6 && row < cell_position_row[cell_index]+10+(5+1)*6 && col >= cell_position_col[cell_index]+10+6*6 && col < cell_position_col[cell_index]+10+(6+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +6*6 && row < cell_position_row[cell_index]+10+(6+1)*6 && col >= cell_position_col[cell_index]+10+6*6 && col < cell_position_col[cell_index]+10+(6+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +7*6 && row < cell_position_row[cell_index]+10+(7+1)*6 && col >= cell_position_col[cell_index]+10+6*6 && col < cell_position_col[cell_index]+10+(6+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else {red, green, blue} <= 3'b001;
				end
				else if(board[cell_index] == 8'd4) begin
					if(row >= cell_position_row[cell_index] + 10 +2*6 && row < cell_position_row[cell_index]+10+(2+1)*6 && col >= cell_position_col[cell_index]+10+2*6 && col < cell_position_col[cell_index]+10+(2+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +3*6 && row < cell_position_row[cell_index]+10+(3+1)*6 && col >= cell_position_col[cell_index]+10+2*6 && col < cell_position_col[cell_index]+10+(2+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +4*6 && row < cell_position_row[cell_index]+10+(4+1)*6 && col >= cell_position_col[cell_index]+10+2*6 && col < cell_position_col[cell_index]+10+(2+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +5*6 && row < cell_position_row[cell_index]+10+(5+1)*6 && col >= cell_position_col[cell_index]+10+2*6 && col < cell_position_col[cell_index]+10+(2+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +6*6 && row < cell_position_row[cell_index]+10+(6+1)*6 && col >= cell_position_col[cell_index]+10+2*6 && col < cell_position_col[cell_index]+10+(2+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +7*6 && row < cell_position_row[cell_index]+10+(7+1)*6 && col >= cell_position_col[cell_index]+10+2*6 && col < cell_position_col[cell_index]+10+(2+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +8*6 && row < cell_position_row[cell_index]+10+(8+1)*6 && col >= cell_position_col[cell_index]+10+2*6 && col < cell_position_col[cell_index]+10+(2+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +4*6 && row < cell_position_row[cell_index]+10+(4+1)*6 && col >= cell_position_col[cell_index]+10+4*6 && col < cell_position_col[cell_index]+10+(4+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +5*6 && row < cell_position_row[cell_index]+10+(5+1)*6 && col >= cell_position_col[cell_index]+10+4*6 && col < cell_position_col[cell_index]+10+(4+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +6*6 && row < cell_position_row[cell_index]+10+(6+1)*6 && col >= cell_position_col[cell_index]+10+4*6 && col < cell_position_col[cell_index]+10+(4+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +7*6 && row < cell_position_row[cell_index]+10+(7+1)*6 && col >= cell_position_col[cell_index]+10+4*6 && col < cell_position_col[cell_index]+10+(4+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +2*6 && row < cell_position_row[cell_index]+10+(2+1)*6 && col >= cell_position_col[cell_index]+10+5*6 && col < cell_position_col[cell_index]+10+(5+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +3*6 && row < cell_position_row[cell_index]+10+(3+1)*6 && col >= cell_position_col[cell_index]+10+5*6 && col < cell_position_col[cell_index]+10+(5+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +4*6 && row < cell_position_row[cell_index]+10+(4+1)*6 && col >= cell_position_col[cell_index]+10+5*6 && col < cell_position_col[cell_index]+10+(5+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +7*6 && row < cell_position_row[cell_index]+10+(7+1)*6 && col >= cell_position_col[cell_index]+10+5*6 && col < cell_position_col[cell_index]+10+(5+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +8*6 && row < cell_position_row[cell_index]+10+(8+1)*6 && col >= cell_position_col[cell_index]+10+5*6 && col < cell_position_col[cell_index]+10+(5+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +1*6 && row < cell_position_row[cell_index]+10+(1+1)*6 && col >= cell_position_col[cell_index]+10+6*6 && col < cell_position_col[cell_index]+10+(6+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +2*6 && row < cell_position_row[cell_index]+10+(2+1)*6 && col >= cell_position_col[cell_index]+10+6*6 && col < cell_position_col[cell_index]+10+(6+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +4*6 && row < cell_position_row[cell_index]+10+(4+1)*6 && col >= cell_position_col[cell_index]+10+6*6 && col < cell_position_col[cell_index]+10+(6+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +8*6 && row < cell_position_row[cell_index]+10+(8+1)*6 && col >= cell_position_col[cell_index]+10+6*6 && col < cell_position_col[cell_index]+10+(6+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +1*6 && row < cell_position_row[cell_index]+10+(1+1)*6 && col >= cell_position_col[cell_index]+10+7*6 && col < cell_position_col[cell_index]+10+(7+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +4*6 && row < cell_position_row[cell_index]+10+(4+1)*6 && col >= cell_position_col[cell_index]+10+7*6 && col < cell_position_col[cell_index]+10+(7+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +8*6 && row < cell_position_row[cell_index]+10+(8+1)*6 && col >= cell_position_col[cell_index]+10+7*6 && col < cell_position_col[cell_index]+10+(7+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +4*6 && row < cell_position_row[cell_index]+10+(4+1)*6 && col >= cell_position_col[cell_index]+10+8*6 && col < cell_position_col[cell_index]+10+(8+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +8*6 && row < cell_position_row[cell_index]+10+(8+1)*6 && col >= cell_position_col[cell_index]+10+8*6 && col < cell_position_col[cell_index]+10+(8+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +5*6 && row < cell_position_row[cell_index]+10+(5+1)*6 && col >= cell_position_col[cell_index]+10+9*6 && col < cell_position_col[cell_index]+10+(9+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +6*6 && row < cell_position_row[cell_index]+10+(6+1)*6 && col >= cell_position_col[cell_index]+10+9*6 && col < cell_position_col[cell_index]+10+(9+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +7*6 && row < cell_position_row[cell_index]+10+(7+1)*6 && col >= cell_position_col[cell_index]+10+9*6 && col < cell_position_col[cell_index]+10+(9+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else {red, green, blue} <= 3'b110;
				end
				else if(board[cell_index] == 8'd5) begin
					if(row >= cell_position_row[cell_index] + 10 +2*6 && row < cell_position_row[cell_index]+10+(2+1)*6 && col >= cell_position_col[cell_index]+10+0*6 && col < cell_position_col[cell_index]+10+(0+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +3*6 && row < cell_position_row[cell_index]+10+(3+1)*6 && col >= cell_position_col[cell_index]+10+0*6 && col < cell_position_col[cell_index]+10+(0+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +7*6 && row < cell_position_row[cell_index]+10+(7+1)*6 && col >= cell_position_col[cell_index]+10+0*6 && col < cell_position_col[cell_index]+10+(0+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +8*6 && row < cell_position_row[cell_index]+10+(8+1)*6 && col >= cell_position_col[cell_index]+10+0*6 && col < cell_position_col[cell_index]+10+(0+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +1*6 && row < cell_position_row[cell_index]+10+(1+1)*6 && col >= cell_position_col[cell_index]+10+1*6 && col < cell_position_col[cell_index]+10+(1+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +2*6 && row < cell_position_row[cell_index]+10+(2+1)*6 && col >= cell_position_col[cell_index]+10+1*6 && col < cell_position_col[cell_index]+10+(1+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +8*6 && row < cell_position_row[cell_index]+10+(8+1)*6 && col >= cell_position_col[cell_index]+10+1*6 && col < cell_position_col[cell_index]+10+(1+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +1*6 && row < cell_position_row[cell_index]+10+(1+1)*6 && col >= cell_position_col[cell_index]+10+2*6 && col < cell_position_col[cell_index]+10+(2+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +2*6 && row < cell_position_row[cell_index]+10+(2+1)*6 && col >= cell_position_col[cell_index]+10+2*6 && col < cell_position_col[cell_index]+10+(2+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +5*6 && row < cell_position_row[cell_index]+10+(5+1)*6 && col >= cell_position_col[cell_index]+10+2*6 && col < cell_position_col[cell_index]+10+(2+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +8*6 && row < cell_position_row[cell_index]+10+(8+1)*6 && col >= cell_position_col[cell_index]+10+2*6 && col < cell_position_col[cell_index]+10+(2+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +2*6 && row < cell_position_row[cell_index]+10+(2+1)*6 && col >= cell_position_col[cell_index]+10+3*6 && col < cell_position_col[cell_index]+10+(3+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +4*6 && row < cell_position_row[cell_index]+10+(4+1)*6 && col >= cell_position_col[cell_index]+10+3*6 && col < cell_position_col[cell_index]+10+(3+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +5*6 && row < cell_position_row[cell_index]+10+(5+1)*6 && col >= cell_position_col[cell_index]+10+3*6 && col < cell_position_col[cell_index]+10+(3+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +6*6 && row < cell_position_row[cell_index]+10+(6+1)*6 && col >= cell_position_col[cell_index]+10+3*6 && col < cell_position_col[cell_index]+10+(3+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +8*6 && row < cell_position_row[cell_index]+10+(8+1)*6 && col >= cell_position_col[cell_index]+10+3*6 && col < cell_position_col[cell_index]+10+(3+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +2*6 && row < cell_position_row[cell_index]+10+(2+1)*6 && col >= cell_position_col[cell_index]+10+4*6 && col < cell_position_col[cell_index]+10+(4+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +3*6 && row < cell_position_row[cell_index]+10+(3+1)*6 && col >= cell_position_col[cell_index]+10+4*6 && col < cell_position_col[cell_index]+10+(4+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +4*6 && row < cell_position_row[cell_index]+10+(4+1)*6 && col >= cell_position_col[cell_index]+10+4*6 && col < cell_position_col[cell_index]+10+(4+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +6*6 && row < cell_position_row[cell_index]+10+(6+1)*6 && col >= cell_position_col[cell_index]+10+4*6 && col < cell_position_col[cell_index]+10+(4+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +7*6 && row < cell_position_row[cell_index]+10+(7+1)*6 && col >= cell_position_col[cell_index]+10+4*6 && col < cell_position_col[cell_index]+10+(4+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +8*6 && row < cell_position_row[cell_index]+10+(8+1)*6 && col >= cell_position_col[cell_index]+10+4*6 && col < cell_position_col[cell_index]+10+(4+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +2*6 && row < cell_position_row[cell_index]+10+(2+1)*6 && col >= cell_position_col[cell_index]+10+6*6 && col < cell_position_col[cell_index]+10+(6+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +3*6 && row < cell_position_row[cell_index]+10+(3+1)*6 && col >= cell_position_col[cell_index]+10+6*6 && col < cell_position_col[cell_index]+10+(6+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +6*6 && row < cell_position_row[cell_index]+10+(6+1)*6 && col >= cell_position_col[cell_index]+10+6*6 && col < cell_position_col[cell_index]+10+(6+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +7*6 && row < cell_position_row[cell_index]+10+(7+1)*6 && col >= cell_position_col[cell_index]+10+6*6 && col < cell_position_col[cell_index]+10+(6+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +8*6 && row < cell_position_row[cell_index]+10+(8+1)*6 && col >= cell_position_col[cell_index]+10+6*6 && col < cell_position_col[cell_index]+10+(6+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +2*6 && row < cell_position_row[cell_index]+10+(2+1)*6 && col >= cell_position_col[cell_index]+10+7*6 && col < cell_position_col[cell_index]+10+(7+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +5*6 && row < cell_position_row[cell_index]+10+(5+1)*6 && col >= cell_position_col[cell_index]+10+7*6 && col < cell_position_col[cell_index]+10+(7+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +6*6 && row < cell_position_row[cell_index]+10+(6+1)*6 && col >= cell_position_col[cell_index]+10+7*6 && col < cell_position_col[cell_index]+10+(7+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +8*6 && row < cell_position_row[cell_index]+10+(8+1)*6 && col >= cell_position_col[cell_index]+10+7*6 && col < cell_position_col[cell_index]+10+(7+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +2*6 && row < cell_position_row[cell_index]+10+(2+1)*6 && col >= cell_position_col[cell_index]+10+8*6 && col < cell_position_col[cell_index]+10+(8+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +3*6 && row < cell_position_row[cell_index]+10+(3+1)*6 && col >= cell_position_col[cell_index]+10+8*6 && col < cell_position_col[cell_index]+10+(8+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +4*6 && row < cell_position_row[cell_index]+10+(4+1)*6 && col >= cell_position_col[cell_index]+10+8*6 && col < cell_position_col[cell_index]+10+(8+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +5*6 && row < cell_position_row[cell_index]+10+(5+1)*6 && col >= cell_position_col[cell_index]+10+8*6 && col < cell_position_col[cell_index]+10+(8+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +8*6 && row < cell_position_row[cell_index]+10+(8+1)*6 && col >= cell_position_col[cell_index]+10+8*6 && col < cell_position_col[cell_index]+10+(8+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +8*6 && row < cell_position_row[cell_index]+10+(8+1)*6 && col >= cell_position_col[cell_index]+10+9*6 && col < cell_position_col[cell_index]+10+(9+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else {red, green, blue} <= 3'b101;
				end
				else if(board[cell_index] == 8'd6) begin
					if(row >= cell_position_row[cell_index] + 10 +4*6 && row < cell_position_row[cell_index]+10+(4+1)*6 && col >= cell_position_col[cell_index]+10+0*6 && col < cell_position_col[cell_index]+10+(0+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +5*6 && row < cell_position_row[cell_index]+10+(5+1)*6 && col >= cell_position_col[cell_index]+10+0*6 && col < cell_position_col[cell_index]+10+(0+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +6*6 && row < cell_position_row[cell_index]+10+(6+1)*6 && col >= cell_position_col[cell_index]+10+0*6 && col < cell_position_col[cell_index]+10+(0+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +7*6 && row < cell_position_row[cell_index]+10+(7+1)*6 && col >= cell_position_col[cell_index]+10+0*6 && col < cell_position_col[cell_index]+10+(0+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +3*6 && row < cell_position_row[cell_index]+10+(3+1)*6 && col >= cell_position_col[cell_index]+10+1*6 && col < cell_position_col[cell_index]+10+(1+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +4*6 && row < cell_position_row[cell_index]+10+(4+1)*6 && col >= cell_position_col[cell_index]+10+1*6 && col < cell_position_col[cell_index]+10+(1+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +7*6 && row < cell_position_row[cell_index]+10+(7+1)*6 && col >= cell_position_col[cell_index]+10+1*6 && col < cell_position_col[cell_index]+10+(1+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +8*6 && row < cell_position_row[cell_index]+10+(8+1)*6 && col >= cell_position_col[cell_index]+10+1*6 && col < cell_position_col[cell_index]+10+(1+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +2*6 && row < cell_position_row[cell_index]+10+(2+1)*6 && col >= cell_position_col[cell_index]+10+2*6 && col < cell_position_col[cell_index]+10+(2+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +3*6 && row < cell_position_row[cell_index]+10+(3+1)*6 && col >= cell_position_col[cell_index]+10+2*6 && col < cell_position_col[cell_index]+10+(2+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +4*6 && row < cell_position_row[cell_index]+10+(4+1)*6 && col >= cell_position_col[cell_index]+10+2*6 && col < cell_position_col[cell_index]+10+(2+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +8*6 && row < cell_position_row[cell_index]+10+(8+1)*6 && col >= cell_position_col[cell_index]+10+2*6 && col < cell_position_col[cell_index]+10+(2+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +1*6 && row < cell_position_row[cell_index]+10+(1+1)*6 && col >= cell_position_col[cell_index]+10+3*6 && col < cell_position_col[cell_index]+10+(3+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +2*6 && row < cell_position_row[cell_index]+10+(2+1)*6 && col >= cell_position_col[cell_index]+10+3*6 && col < cell_position_col[cell_index]+10+(3+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +4*6 && row < cell_position_row[cell_index]+10+(4+1)*6 && col >= cell_position_col[cell_index]+10+3*6 && col < cell_position_col[cell_index]+10+(3+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +7*6 && row < cell_position_row[cell_index]+10+(7+1)*6 && col >= cell_position_col[cell_index]+10+3*6 && col < cell_position_col[cell_index]+10+(3+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +8*6 && row < cell_position_row[cell_index]+10+(8+1)*6 && col >= cell_position_col[cell_index]+10+3*6 && col < cell_position_col[cell_index]+10+(3+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +5*6 && row < cell_position_row[cell_index]+10+(5+1)*6 && col >= cell_position_col[cell_index]+10+4*6 && col < cell_position_col[cell_index]+10+(4+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +6*6 && row < cell_position_row[cell_index]+10+(6+1)*6 && col >= cell_position_col[cell_index]+10+4*6 && col < cell_position_col[cell_index]+10+(4+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +7*6 && row < cell_position_row[cell_index]+10+(7+1)*6 && col >= cell_position_col[cell_index]+10+4*6 && col < cell_position_col[cell_index]+10+(4+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +2*6 && row < cell_position_row[cell_index]+10+(2+1)*6 && col >= cell_position_col[cell_index]+10+5*6 && col < cell_position_col[cell_index]+10+(5+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +3*6 && row < cell_position_row[cell_index]+10+(3+1)*6 && col >= cell_position_col[cell_index]+10+5*6 && col < cell_position_col[cell_index]+10+(5+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +4*6 && row < cell_position_row[cell_index]+10+(4+1)*6 && col >= cell_position_col[cell_index]+10+5*6 && col < cell_position_col[cell_index]+10+(5+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +1*6 && row < cell_position_row[cell_index]+10+(1+1)*6 && col >= cell_position_col[cell_index]+10+6*6 && col < cell_position_col[cell_index]+10+(6+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +2*6 && row < cell_position_row[cell_index]+10+(2+1)*6 && col >= cell_position_col[cell_index]+10+6*6 && col < cell_position_col[cell_index]+10+(6+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +4*6 && row < cell_position_row[cell_index]+10+(4+1)*6 && col >= cell_position_col[cell_index]+10+6*6 && col < cell_position_col[cell_index]+10+(6+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +4*6 && row < cell_position_row[cell_index]+10+(4+1)*6 && col >= cell_position_col[cell_index]+10+7*6 && col < cell_position_col[cell_index]+10+(7+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +1*6 && row < cell_position_row[cell_index]+10+(1+1)*6 && col >= cell_position_col[cell_index]+10+8*6 && col < cell_position_col[cell_index]+10+(8+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +2*6 && row < cell_position_row[cell_index]+10+(2+1)*6 && col >= cell_position_col[cell_index]+10+8*6 && col < cell_position_col[cell_index]+10+(8+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +3*6 && row < cell_position_row[cell_index]+10+(3+1)*6 && col >= cell_position_col[cell_index]+10+8*6 && col < cell_position_col[cell_index]+10+(8+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +4*6 && row < cell_position_row[cell_index]+10+(4+1)*6 && col >= cell_position_col[cell_index]+10+8*6 && col < cell_position_col[cell_index]+10+(8+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +5*6 && row < cell_position_row[cell_index]+10+(5+1)*6 && col >= cell_position_col[cell_index]+10+8*6 && col < cell_position_col[cell_index]+10+(8+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +6*6 && row < cell_position_row[cell_index]+10+(6+1)*6 && col >= cell_position_col[cell_index]+10+8*6 && col < cell_position_col[cell_index]+10+(8+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +7*6 && row < cell_position_row[cell_index]+10+(7+1)*6 && col >= cell_position_col[cell_index]+10+8*6 && col < cell_position_col[cell_index]+10+(8+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +8*6 && row < cell_position_row[cell_index]+10+(8+1)*6 && col >= cell_position_col[cell_index]+10+8*6 && col < cell_position_col[cell_index]+10+(8+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 10 +4*6 && row < cell_position_row[cell_index]+10+(4+1)*6 && col >= cell_position_col[cell_index]+10+9*6 && col < cell_position_col[cell_index]+10+(9+1)*6) begin
						{red, green, blue} <= 3'b000;
					end
					else {red, green, blue} <= 3'b011;
				end
				else if(board[cell_index] == 8'd7) begin
					if(row >= cell_position_row[cell_index] + 25 +1*3 && row < cell_position_row[cell_index]+25+(1+1)*3 && col >= cell_position_col[cell_index]+8+0+2*3 && col < cell_position_col[cell_index]+8+0+(2+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +2*3 && row < cell_position_row[cell_index]+25+(2+1)*3 && col >= cell_position_col[cell_index]+8+0+2*3 && col < cell_position_col[cell_index]+8+0+(2+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +3*3 && row < cell_position_row[cell_index]+25+(3+1)*3 && col >= cell_position_col[cell_index]+8+0+2*3 && col < cell_position_col[cell_index]+8+0+(2+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +4*3 && row < cell_position_row[cell_index]+25+(4+1)*3 && col >= cell_position_col[cell_index]+8+0+2*3 && col < cell_position_col[cell_index]+8+0+(2+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +5*3 && row < cell_position_row[cell_index]+25+(5+1)*3 && col >= cell_position_col[cell_index]+8+0+2*3 && col < cell_position_col[cell_index]+8+0+(2+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +6*3 && row < cell_position_row[cell_index]+25+(6+1)*3 && col >= cell_position_col[cell_index]+8+0+2*3 && col < cell_position_col[cell_index]+8+0+(2+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +7*3 && row < cell_position_row[cell_index]+25+(7+1)*3 && col >= cell_position_col[cell_index]+8+0+2*3 && col < cell_position_col[cell_index]+8+0+(2+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +8*3 && row < cell_position_row[cell_index]+25+(8+1)*3 && col >= cell_position_col[cell_index]+8+0+2*3 && col < cell_position_col[cell_index]+8+0+(2+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +2*3 && row < cell_position_row[cell_index]+25+(2+1)*3 && col >= cell_position_col[cell_index]+8+0+5*3 && col < cell_position_col[cell_index]+8+0+(5+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +3*3 && row < cell_position_row[cell_index]+25+(3+1)*3 && col >= cell_position_col[cell_index]+8+0+5*3 && col < cell_position_col[cell_index]+8+0+(5+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +7*3 && row < cell_position_row[cell_index]+25+(7+1)*3 && col >= cell_position_col[cell_index]+8+0+5*3 && col < cell_position_col[cell_index]+8+0+(5+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +8*3 && row < cell_position_row[cell_index]+25+(8+1)*3 && col >= cell_position_col[cell_index]+8+0+5*3 && col < cell_position_col[cell_index]+8+0+(5+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +2*3 && row < cell_position_row[cell_index]+25+(2+1)*3 && col >= cell_position_col[cell_index]+8+0+6*3 && col < cell_position_col[cell_index]+8+0+(6+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +6*3 && row < cell_position_row[cell_index]+25+(6+1)*3 && col >= cell_position_col[cell_index]+8+0+6*3 && col < cell_position_col[cell_index]+8+0+(6+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +7*3 && row < cell_position_row[cell_index]+25+(7+1)*3 && col >= cell_position_col[cell_index]+8+0+6*3 && col < cell_position_col[cell_index]+8+0+(6+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +8*3 && row < cell_position_row[cell_index]+25+(8+1)*3 && col >= cell_position_col[cell_index]+8+0+6*3 && col < cell_position_col[cell_index]+8+0+(6+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +2*3 && row < cell_position_row[cell_index]+25+(2+1)*3 && col >= cell_position_col[cell_index]+8+0+7*3 && col < cell_position_col[cell_index]+8+0+(7+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +3*3 && row < cell_position_row[cell_index]+25+(3+1)*3 && col >= cell_position_col[cell_index]+8+0+7*3 && col < cell_position_col[cell_index]+8+0+(7+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +5*3 && row < cell_position_row[cell_index]+25+(5+1)*3 && col >= cell_position_col[cell_index]+8+0+7*3 && col < cell_position_col[cell_index]+8+0+(7+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +6*3 && row < cell_position_row[cell_index]+25+(6+1)*3 && col >= cell_position_col[cell_index]+8+0+7*3 && col < cell_position_col[cell_index]+8+0+(7+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +8*3 && row < cell_position_row[cell_index]+25+(8+1)*3 && col >= cell_position_col[cell_index]+8+0+7*3 && col < cell_position_col[cell_index]+8+0+(7+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +3*3 && row < cell_position_row[cell_index]+25+(3+1)*3 && col >= cell_position_col[cell_index]+8+0+8*3 && col < cell_position_col[cell_index]+8+0+(8+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +4*3 && row < cell_position_row[cell_index]+25+(4+1)*3 && col >= cell_position_col[cell_index]+8+0+8*3 && col < cell_position_col[cell_index]+8+0+(8+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +5*3 && row < cell_position_row[cell_index]+25+(5+1)*3 && col >= cell_position_col[cell_index]+8+0+8*3 && col < cell_position_col[cell_index]+8+0+(8+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +8*3 && row < cell_position_row[cell_index]+25+(8+1)*3 && col >= cell_position_col[cell_index]+8+0+8*3 && col < cell_position_col[cell_index]+8+0+(8+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +8*3 && row < cell_position_row[cell_index]+25+(8+1)*3 && col >= cell_position_col[cell_index]+8+0+9*3 && col < cell_position_col[cell_index]+8+0+(9+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +2*3 && row < cell_position_row[cell_index]+25+(2+1)*3 && col >= cell_position_col[cell_index]+8+32+2*3 && col < cell_position_col[cell_index]+8+32+(2+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +3*3 && row < cell_position_row[cell_index]+25+(3+1)*3 && col >= cell_position_col[cell_index]+8+32+2*3 && col < cell_position_col[cell_index]+8+32+(2+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +5*3 && row < cell_position_row[cell_index]+25+(5+1)*3 && col >= cell_position_col[cell_index]+8+32+2*3 && col < cell_position_col[cell_index]+8+32+(2+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +6*3 && row < cell_position_row[cell_index]+25+(6+1)*3 && col >= cell_position_col[cell_index]+8+32+2*3 && col < cell_position_col[cell_index]+8+32+(2+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +7*3 && row < cell_position_row[cell_index]+25+(7+1)*3 && col >= cell_position_col[cell_index]+8+32+2*3 && col < cell_position_col[cell_index]+8+32+(2+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +1*3 && row < cell_position_row[cell_index]+25+(1+1)*3 && col >= cell_position_col[cell_index]+8+32+3*3 && col < cell_position_col[cell_index]+8+32+(3+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +4*3 && row < cell_position_row[cell_index]+25+(4+1)*3 && col >= cell_position_col[cell_index]+8+32+3*3 && col < cell_position_col[cell_index]+8+32+(3+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +8*3 && row < cell_position_row[cell_index]+25+(8+1)*3 && col >= cell_position_col[cell_index]+8+32+3*3 && col < cell_position_col[cell_index]+8+32+(3+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +1*3 && row < cell_position_row[cell_index]+25+(1+1)*3 && col >= cell_position_col[cell_index]+8+32+4*3 && col < cell_position_col[cell_index]+8+32+(4+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +4*3 && row < cell_position_row[cell_index]+25+(4+1)*3 && col >= cell_position_col[cell_index]+8+32+4*3 && col < cell_position_col[cell_index]+8+32+(4+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +8*3 && row < cell_position_row[cell_index]+25+(8+1)*3 && col >= cell_position_col[cell_index]+8+32+4*3 && col < cell_position_col[cell_index]+8+32+(4+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +1*3 && row < cell_position_row[cell_index]+25+(1+1)*3 && col >= cell_position_col[cell_index]+8+32+5*3 && col < cell_position_col[cell_index]+8+32+(5+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +4*3 && row < cell_position_row[cell_index]+25+(4+1)*3 && col >= cell_position_col[cell_index]+8+32+5*3 && col < cell_position_col[cell_index]+8+32+(5+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +8*3 && row < cell_position_row[cell_index]+25+(8+1)*3 && col >= cell_position_col[cell_index]+8+32+5*3 && col < cell_position_col[cell_index]+8+32+(5+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +2*3 && row < cell_position_row[cell_index]+25+(2+1)*3 && col >= cell_position_col[cell_index]+8+32+6*3 && col < cell_position_col[cell_index]+8+32+(6+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +3*3 && row < cell_position_row[cell_index]+25+(3+1)*3 && col >= cell_position_col[cell_index]+8+32+6*3 && col < cell_position_col[cell_index]+8+32+(6+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +5*3 && row < cell_position_row[cell_index]+25+(5+1)*3 && col >= cell_position_col[cell_index]+8+32+6*3 && col < cell_position_col[cell_index]+8+32+(6+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +6*3 && row < cell_position_row[cell_index]+25+(6+1)*3 && col >= cell_position_col[cell_index]+8+32+6*3 && col < cell_position_col[cell_index]+8+32+(6+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +7*3 && row < cell_position_row[cell_index]+25+(7+1)*3 && col >= cell_position_col[cell_index]+8+32+6*3 && col < cell_position_col[cell_index]+8+32+(6+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(col-cell_position_col[cell_index] > row-cell_position_row[cell_index]) {red, green, blue} <= 3'b100;
					else {red, green, blue} <= 3'b010;
				end
				else if(board[cell_index] == 8'd8) begin
					if(row >= cell_position_row[cell_index] + 25 +2*3 && row < cell_position_row[cell_index]+25+(2+1)*3 && col >= cell_position_col[cell_index]+8+0+0*3 && col < cell_position_col[cell_index]+8+0+(0+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +3*3 && row < cell_position_row[cell_index]+25+(3+1)*3 && col >= cell_position_col[cell_index]+8+0+0*3 && col < cell_position_col[cell_index]+8+0+(0+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +4*3 && row < cell_position_row[cell_index]+25+(4+1)*3 && col >= cell_position_col[cell_index]+8+0+0*3 && col < cell_position_col[cell_index]+8+0+(0+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +8*3 && row < cell_position_row[cell_index]+25+(8+1)*3 && col >= cell_position_col[cell_index]+8+0+0*3 && col < cell_position_col[cell_index]+8+0+(0+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +9*3 && row < cell_position_row[cell_index]+25+(9+1)*3 && col >= cell_position_col[cell_index]+8+0+0*3 && col < cell_position_col[cell_index]+8+0+(0+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +1*3 && row < cell_position_row[cell_index]+25+(1+1)*3 && col >= cell_position_col[cell_index]+8+0+1*3 && col < cell_position_col[cell_index]+8+0+(1+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +2*3 && row < cell_position_row[cell_index]+25+(2+1)*3 && col >= cell_position_col[cell_index]+8+0+1*3 && col < cell_position_col[cell_index]+8+0+(1+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +7*3 && row < cell_position_row[cell_index]+25+(7+1)*3 && col >= cell_position_col[cell_index]+8+0+1*3 && col < cell_position_col[cell_index]+8+0+(1+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +8*3 && row < cell_position_row[cell_index]+25+(8+1)*3 && col >= cell_position_col[cell_index]+8+0+1*3 && col < cell_position_col[cell_index]+8+0+(1+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +9*3 && row < cell_position_row[cell_index]+25+(9+1)*3 && col >= cell_position_col[cell_index]+8+0+1*3 && col < cell_position_col[cell_index]+8+0+(1+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +1*3 && row < cell_position_row[cell_index]+25+(1+1)*3 && col >= cell_position_col[cell_index]+8+0+2*3 && col < cell_position_col[cell_index]+8+0+(2+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +6*3 && row < cell_position_row[cell_index]+25+(6+1)*3 && col >= cell_position_col[cell_index]+8+0+2*3 && col < cell_position_col[cell_index]+8+0+(2+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +7*3 && row < cell_position_row[cell_index]+25+(7+1)*3 && col >= cell_position_col[cell_index]+8+0+2*3 && col < cell_position_col[cell_index]+8+0+(2+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +9*3 && row < cell_position_row[cell_index]+25+(9+1)*3 && col >= cell_position_col[cell_index]+8+0+2*3 && col < cell_position_col[cell_index]+8+0+(2+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +1*3 && row < cell_position_row[cell_index]+25+(1+1)*3 && col >= cell_position_col[cell_index]+8+0+3*3 && col < cell_position_col[cell_index]+8+0+(3+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +2*3 && row < cell_position_row[cell_index]+25+(2+1)*3 && col >= cell_position_col[cell_index]+8+0+3*3 && col < cell_position_col[cell_index]+8+0+(3+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +3*3 && row < cell_position_row[cell_index]+25+(3+1)*3 && col >= cell_position_col[cell_index]+8+0+3*3 && col < cell_position_col[cell_index]+8+0+(3+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +4*3 && row < cell_position_row[cell_index]+25+(4+1)*3 && col >= cell_position_col[cell_index]+8+0+3*3 && col < cell_position_col[cell_index]+8+0+(3+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +5*3 && row < cell_position_row[cell_index]+25+(5+1)*3 && col >= cell_position_col[cell_index]+8+0+3*3 && col < cell_position_col[cell_index]+8+0+(3+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +6*3 && row < cell_position_row[cell_index]+25+(6+1)*3 && col >= cell_position_col[cell_index]+8+0+3*3 && col < cell_position_col[cell_index]+8+0+(3+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +9*3 && row < cell_position_row[cell_index]+25+(9+1)*3 && col >= cell_position_col[cell_index]+8+0+3*3 && col < cell_position_col[cell_index]+8+0+(3+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +1*3 && row < cell_position_row[cell_index]+25+(1+1)*3 && col >= cell_position_col[cell_index]+8+0+5*3 && col < cell_position_col[cell_index]+8+0+(5+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +2*3 && row < cell_position_row[cell_index]+25+(2+1)*3 && col >= cell_position_col[cell_index]+8+0+5*3 && col < cell_position_col[cell_index]+8+0+(5+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +3*3 && row < cell_position_row[cell_index]+25+(3+1)*3 && col >= cell_position_col[cell_index]+8+0+5*3 && col < cell_position_col[cell_index]+8+0+(5+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +4*3 && row < cell_position_row[cell_index]+25+(4+1)*3 && col >= cell_position_col[cell_index]+8+0+5*3 && col < cell_position_col[cell_index]+8+0+(5+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +8*3 && row < cell_position_row[cell_index]+25+(8+1)*3 && col >= cell_position_col[cell_index]+8+0+5*3 && col < cell_position_col[cell_index]+8+0+(5+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +9*3 && row < cell_position_row[cell_index]+25+(9+1)*3 && col >= cell_position_col[cell_index]+8+0+5*3 && col < cell_position_col[cell_index]+8+0+(5+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +1*3 && row < cell_position_row[cell_index]+25+(1+1)*3 && col >= cell_position_col[cell_index]+8+0+6*3 && col < cell_position_col[cell_index]+8+0+(6+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +4*3 && row < cell_position_row[cell_index]+25+(4+1)*3 && col >= cell_position_col[cell_index]+8+0+6*3 && col < cell_position_col[cell_index]+8+0+(6+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +9*3 && row < cell_position_row[cell_index]+25+(9+1)*3 && col >= cell_position_col[cell_index]+8+0+6*3 && col < cell_position_col[cell_index]+8+0+(6+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +1*3 && row < cell_position_row[cell_index]+25+(1+1)*3 && col >= cell_position_col[cell_index]+8+0+7*3 && col < cell_position_col[cell_index]+8+0+(7+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +4*3 && row < cell_position_row[cell_index]+25+(4+1)*3 && col >= cell_position_col[cell_index]+8+0+7*3 && col < cell_position_col[cell_index]+8+0+(7+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +9*3 && row < cell_position_row[cell_index]+25+(9+1)*3 && col >= cell_position_col[cell_index]+8+0+7*3 && col < cell_position_col[cell_index]+8+0+(7+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +1*3 && row < cell_position_row[cell_index]+25+(1+1)*3 && col >= cell_position_col[cell_index]+8+0+8*3 && col < cell_position_col[cell_index]+8+0+(8+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +4*3 && row < cell_position_row[cell_index]+25+(4+1)*3 && col >= cell_position_col[cell_index]+8+0+8*3 && col < cell_position_col[cell_index]+8+0+(8+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +9*3 && row < cell_position_row[cell_index]+25+(9+1)*3 && col >= cell_position_col[cell_index]+8+0+8*3 && col < cell_position_col[cell_index]+8+0+(8+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +1*3 && row < cell_position_row[cell_index]+25+(1+1)*3 && col >= cell_position_col[cell_index]+8+0+9*3 && col < cell_position_col[cell_index]+8+0+(9+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +4*3 && row < cell_position_row[cell_index]+25+(4+1)*3 && col >= cell_position_col[cell_index]+8+0+9*3 && col < cell_position_col[cell_index]+8+0+(9+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +5*3 && row < cell_position_row[cell_index]+25+(5+1)*3 && col >= cell_position_col[cell_index]+8+0+9*3 && col < cell_position_col[cell_index]+8+0+(9+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +6*3 && row < cell_position_row[cell_index]+25+(6+1)*3 && col >= cell_position_col[cell_index]+8+0+9*3 && col < cell_position_col[cell_index]+8+0+(9+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +7*3 && row < cell_position_row[cell_index]+25+(7+1)*3 && col >= cell_position_col[cell_index]+8+0+9*3 && col < cell_position_col[cell_index]+8+0+(9+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +8*3 && row < cell_position_row[cell_index]+25+(8+1)*3 && col >= cell_position_col[cell_index]+8+0+9*3 && col < cell_position_col[cell_index]+8+0+(9+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +9*3 && row < cell_position_row[cell_index]+25+(9+1)*3 && col >= cell_position_col[cell_index]+8+0+9*3 && col < cell_position_col[cell_index]+8+0+(9+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +4*3 && row < cell_position_row[cell_index]+25+(4+1)*3 && col >= cell_position_col[cell_index]+8+32+2*3 && col < cell_position_col[cell_index]+8+32+(2+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +5*3 && row < cell_position_row[cell_index]+25+(5+1)*3 && col >= cell_position_col[cell_index]+8+32+2*3 && col < cell_position_col[cell_index]+8+32+(2+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +6*3 && row < cell_position_row[cell_index]+25+(6+1)*3 && col >= cell_position_col[cell_index]+8+32+2*3 && col < cell_position_col[cell_index]+8+32+(2+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +7*3 && row < cell_position_row[cell_index]+25+(7+1)*3 && col >= cell_position_col[cell_index]+8+32+2*3 && col < cell_position_col[cell_index]+8+32+(2+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +2*3 && row < cell_position_row[cell_index]+25+(2+1)*3 && col >= cell_position_col[cell_index]+8+32+3*3 && col < cell_position_col[cell_index]+8+32+(3+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +3*3 && row < cell_position_row[cell_index]+25+(3+1)*3 && col >= cell_position_col[cell_index]+8+32+3*3 && col < cell_position_col[cell_index]+8+32+(3+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +4*3 && row < cell_position_row[cell_index]+25+(4+1)*3 && col >= cell_position_col[cell_index]+8+32+3*3 && col < cell_position_col[cell_index]+8+32+(3+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +7*3 && row < cell_position_row[cell_index]+25+(7+1)*3 && col >= cell_position_col[cell_index]+8+32+3*3 && col < cell_position_col[cell_index]+8+32+(3+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +8*3 && row < cell_position_row[cell_index]+25+(8+1)*3 && col >= cell_position_col[cell_index]+8+32+3*3 && col < cell_position_col[cell_index]+8+32+(3+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +1*3 && row < cell_position_row[cell_index]+25+(1+1)*3 && col >= cell_position_col[cell_index]+8+32+4*3 && col < cell_position_col[cell_index]+8+32+(4+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +2*3 && row < cell_position_row[cell_index]+25+(2+1)*3 && col >= cell_position_col[cell_index]+8+32+4*3 && col < cell_position_col[cell_index]+8+32+(4+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +4*3 && row < cell_position_row[cell_index]+25+(4+1)*3 && col >= cell_position_col[cell_index]+8+32+4*3 && col < cell_position_col[cell_index]+8+32+(4+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +8*3 && row < cell_position_row[cell_index]+25+(8+1)*3 && col >= cell_position_col[cell_index]+8+32+4*3 && col < cell_position_col[cell_index]+8+32+(4+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +1*3 && row < cell_position_row[cell_index]+25+(1+1)*3 && col >= cell_position_col[cell_index]+8+32+5*3 && col < cell_position_col[cell_index]+8+32+(5+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +4*3 && row < cell_position_row[cell_index]+25+(4+1)*3 && col >= cell_position_col[cell_index]+8+32+5*3 && col < cell_position_col[cell_index]+8+32+(5+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +8*3 && row < cell_position_row[cell_index]+25+(8+1)*3 && col >= cell_position_col[cell_index]+8+32+5*3 && col < cell_position_col[cell_index]+8+32+(5+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +4*3 && row < cell_position_row[cell_index]+25+(4+1)*3 && col >= cell_position_col[cell_index]+8+32+6*3 && col < cell_position_col[cell_index]+8+32+(6+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +5*3 && row < cell_position_row[cell_index]+25+(5+1)*3 && col >= cell_position_col[cell_index]+8+32+6*3 && col < cell_position_col[cell_index]+8+32+(6+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +8*3 && row < cell_position_row[cell_index]+25+(8+1)*3 && col >= cell_position_col[cell_index]+8+32+6*3 && col < cell_position_col[cell_index]+8+32+(6+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +5*3 && row < cell_position_row[cell_index]+25+(5+1)*3 && col >= cell_position_col[cell_index]+8+32+7*3 && col < cell_position_col[cell_index]+8+32+(7+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +6*3 && row < cell_position_row[cell_index]+25+(6+1)*3 && col >= cell_position_col[cell_index]+8+32+7*3 && col < cell_position_col[cell_index]+8+32+(7+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +7*3 && row < cell_position_row[cell_index]+25+(7+1)*3 && col >= cell_position_col[cell_index]+8+32+7*3 && col < cell_position_col[cell_index]+8+32+(7+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +8*3 && row < cell_position_row[cell_index]+25+(8+1)*3 && col >= cell_position_col[cell_index]+8+32+7*3 && col < cell_position_col[cell_index]+8+32+(7+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(col-cell_position_col[cell_index] > row-cell_position_row[cell_index]) {red, green, blue} <= 3'b010;
					else {red, green, blue} <= 3'b001;
				end
				else if(board[cell_index] == 8'd9) begin
					if(row >= cell_position_row[cell_index] + 25 +1*3 && row < cell_position_row[cell_index]+25+(1+1)*3 && col >= cell_position_col[cell_index]+8+0+1*3 && col < cell_position_col[cell_index]+8+0+(1+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +2*3 && row < cell_position_row[cell_index]+25+(2+1)*3 && col >= cell_position_col[cell_index]+8+0+1*3 && col < cell_position_col[cell_index]+8+0+(1+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +3*3 && row < cell_position_row[cell_index]+25+(3+1)*3 && col >= cell_position_col[cell_index]+8+0+1*3 && col < cell_position_col[cell_index]+8+0+(1+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +4*3 && row < cell_position_row[cell_index]+25+(4+1)*3 && col >= cell_position_col[cell_index]+8+0+1*3 && col < cell_position_col[cell_index]+8+0+(1+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +7*3 && row < cell_position_row[cell_index]+25+(7+1)*3 && col >= cell_position_col[cell_index]+8+0+1*3 && col < cell_position_col[cell_index]+8+0+(1+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +8*3 && row < cell_position_row[cell_index]+25+(8+1)*3 && col >= cell_position_col[cell_index]+8+0+1*3 && col < cell_position_col[cell_index]+8+0+(1+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +1*3 && row < cell_position_row[cell_index]+25+(1+1)*3 && col >= cell_position_col[cell_index]+8+0+2*3 && col < cell_position_col[cell_index]+8+0+(2+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +4*3 && row < cell_position_row[cell_index]+25+(4+1)*3 && col >= cell_position_col[cell_index]+8+0+2*3 && col < cell_position_col[cell_index]+8+0+(2+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +8*3 && row < cell_position_row[cell_index]+25+(8+1)*3 && col >= cell_position_col[cell_index]+8+0+2*3 && col < cell_position_col[cell_index]+8+0+(2+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +1*3 && row < cell_position_row[cell_index]+25+(1+1)*3 && col >= cell_position_col[cell_index]+8+0+3*3 && col < cell_position_col[cell_index]+8+0+(3+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +4*3 && row < cell_position_row[cell_index]+25+(4+1)*3 && col >= cell_position_col[cell_index]+8+0+3*3 && col < cell_position_col[cell_index]+8+0+(3+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +8*3 && row < cell_position_row[cell_index]+25+(8+1)*3 && col >= cell_position_col[cell_index]+8+0+3*3 && col < cell_position_col[cell_index]+8+0+(3+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +1*3 && row < cell_position_row[cell_index]+25+(1+1)*3 && col >= cell_position_col[cell_index]+8+0+4*3 && col < cell_position_col[cell_index]+8+0+(4+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +4*3 && row < cell_position_row[cell_index]+25+(4+1)*3 && col >= cell_position_col[cell_index]+8+0+4*3 && col < cell_position_col[cell_index]+8+0+(4+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +5*3 && row < cell_position_row[cell_index]+25+(5+1)*3 && col >= cell_position_col[cell_index]+8+0+4*3 && col < cell_position_col[cell_index]+8+0+(4+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +6*3 && row < cell_position_row[cell_index]+25+(6+1)*3 && col >= cell_position_col[cell_index]+8+0+4*3 && col < cell_position_col[cell_index]+8+0+(4+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +7*3 && row < cell_position_row[cell_index]+25+(7+1)*3 && col >= cell_position_col[cell_index]+8+0+4*3 && col < cell_position_col[cell_index]+8+0+(4+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +8*3 && row < cell_position_row[cell_index]+25+(8+1)*3 && col >= cell_position_col[cell_index]+8+0+4*3 && col < cell_position_col[cell_index]+8+0+(4+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +1*3 && row < cell_position_row[cell_index]+25+(1+1)*3 && col >= cell_position_col[cell_index]+8+0+8*3 && col < cell_position_col[cell_index]+8+0+(8+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +2*3 && row < cell_position_row[cell_index]+25+(2+1)*3 && col >= cell_position_col[cell_index]+8+0+8*3 && col < cell_position_col[cell_index]+8+0+(8+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +3*3 && row < cell_position_row[cell_index]+25+(3+1)*3 && col >= cell_position_col[cell_index]+8+0+8*3 && col < cell_position_col[cell_index]+8+0+(8+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +4*3 && row < cell_position_row[cell_index]+25+(4+1)*3 && col >= cell_position_col[cell_index]+8+0+8*3 && col < cell_position_col[cell_index]+8+0+(8+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +5*3 && row < cell_position_row[cell_index]+25+(5+1)*3 && col >= cell_position_col[cell_index]+8+0+8*3 && col < cell_position_col[cell_index]+8+0+(8+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +6*3 && row < cell_position_row[cell_index]+25+(6+1)*3 && col >= cell_position_col[cell_index]+8+0+8*3 && col < cell_position_col[cell_index]+8+0+(8+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +7*3 && row < cell_position_row[cell_index]+25+(7+1)*3 && col >= cell_position_col[cell_index]+8+0+8*3 && col < cell_position_col[cell_index]+8+0+(8+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +8*3 && row < cell_position_row[cell_index]+25+(8+1)*3 && col >= cell_position_col[cell_index]+8+0+8*3 && col < cell_position_col[cell_index]+8+0+(8+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +3*3 && row < cell_position_row[cell_index]+25+(3+1)*3 && col >= cell_position_col[cell_index]+8+32+2*3 && col < cell_position_col[cell_index]+8+32+(2+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +7*3 && row < cell_position_row[cell_index]+25+(7+1)*3 && col >= cell_position_col[cell_index]+8+32+2*3 && col < cell_position_col[cell_index]+8+32+(2+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +1*3 && row < cell_position_row[cell_index]+25+(1+1)*3 && col >= cell_position_col[cell_index]+8+32+3*3 && col < cell_position_col[cell_index]+8+32+(3+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +2*3 && row < cell_position_row[cell_index]+25+(2+1)*3 && col >= cell_position_col[cell_index]+8+32+3*3 && col < cell_position_col[cell_index]+8+32+(3+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +6*3 && row < cell_position_row[cell_index]+25+(6+1)*3 && col >= cell_position_col[cell_index]+8+32+3*3 && col < cell_position_col[cell_index]+8+32+(3+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +7*3 && row < cell_position_row[cell_index]+25+(7+1)*3 && col >= cell_position_col[cell_index]+8+32+3*3 && col < cell_position_col[cell_index]+8+32+(3+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +1*3 && row < cell_position_row[cell_index]+25+(1+1)*3 && col >= cell_position_col[cell_index]+8+32+4*3 && col < cell_position_col[cell_index]+8+32+(4+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +5*3 && row < cell_position_row[cell_index]+25+(5+1)*3 && col >= cell_position_col[cell_index]+8+32+4*3 && col < cell_position_col[cell_index]+8+32+(4+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +7*3 && row < cell_position_row[cell_index]+25+(7+1)*3 && col >= cell_position_col[cell_index]+8+32+4*3 && col < cell_position_col[cell_index]+8+32+(4+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +1*3 && row < cell_position_row[cell_index]+25+(1+1)*3 && col >= cell_position_col[cell_index]+8+32+5*3 && col < cell_position_col[cell_index]+8+32+(5+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +2*3 && row < cell_position_row[cell_index]+25+(2+1)*3 && col >= cell_position_col[cell_index]+8+32+5*3 && col < cell_position_col[cell_index]+8+32+(5+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +5*3 && row < cell_position_row[cell_index]+25+(5+1)*3 && col >= cell_position_col[cell_index]+8+32+5*3 && col < cell_position_col[cell_index]+8+32+(5+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +7*3 && row < cell_position_row[cell_index]+25+(7+1)*3 && col >= cell_position_col[cell_index]+8+32+5*3 && col < cell_position_col[cell_index]+8+32+(5+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +3*3 && row < cell_position_row[cell_index]+25+(3+1)*3 && col >= cell_position_col[cell_index]+8+32+6*3 && col < cell_position_col[cell_index]+8+32+(6+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +4*3 && row < cell_position_row[cell_index]+25+(4+1)*3 && col >= cell_position_col[cell_index]+8+32+6*3 && col < cell_position_col[cell_index]+8+32+(6+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +7*3 && row < cell_position_row[cell_index]+25+(7+1)*3 && col >= cell_position_col[cell_index]+8+32+6*3 && col < cell_position_col[cell_index]+8+32+(6+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +7*3 && row < cell_position_row[cell_index]+25+(7+1)*3 && col >= cell_position_col[cell_index]+8+32+7*3 && col < cell_position_col[cell_index]+8+32+(7+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +7*3 && row < cell_position_row[cell_index]+25+(7+1)*3 && col >= cell_position_col[cell_index]+8+32+8*3 && col < cell_position_col[cell_index]+8+32+(8+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(col-cell_position_col[cell_index] > row-cell_position_row[cell_index]) {red, green, blue} <= 3'b001;
					else {red, green, blue} <= 3'b100;
				end
				else if(board[cell_index] == 8'd10) begin
					if(row >= cell_position_row[cell_index] + 25 +1*3 && row < cell_position_row[cell_index]+25+(1+1)*3 && col >= cell_position_col[cell_index]+8+0+1*3 && col < cell_position_col[cell_index]+8+0+(1+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +2*3 && row < cell_position_row[cell_index]+25+(2+1)*3 && col >= cell_position_col[cell_index]+8+0+1*3 && col < cell_position_col[cell_index]+8+0+(1+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +3*3 && row < cell_position_row[cell_index]+25+(3+1)*3 && col >= cell_position_col[cell_index]+8+0+1*3 && col < cell_position_col[cell_index]+8+0+(1+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +4*3 && row < cell_position_row[cell_index]+25+(4+1)*3 && col >= cell_position_col[cell_index]+8+0+1*3 && col < cell_position_col[cell_index]+8+0+(1+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +5*3 && row < cell_position_row[cell_index]+25+(5+1)*3 && col >= cell_position_col[cell_index]+8+0+1*3 && col < cell_position_col[cell_index]+8+0+(1+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +6*3 && row < cell_position_row[cell_index]+25+(6+1)*3 && col >= cell_position_col[cell_index]+8+0+1*3 && col < cell_position_col[cell_index]+8+0+(1+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +7*3 && row < cell_position_row[cell_index]+25+(7+1)*3 && col >= cell_position_col[cell_index]+8+0+1*3 && col < cell_position_col[cell_index]+8+0+(1+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +8*3 && row < cell_position_row[cell_index]+25+(8+1)*3 && col >= cell_position_col[cell_index]+8+0+1*3 && col < cell_position_col[cell_index]+8+0+(1+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +1*3 && row < cell_position_row[cell_index]+25+(1+1)*3 && col >= cell_position_col[cell_index]+8+0+5*3 && col < cell_position_col[cell_index]+8+0+(5+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +2*3 && row < cell_position_row[cell_index]+25+(2+1)*3 && col >= cell_position_col[cell_index]+8+0+5*3 && col < cell_position_col[cell_index]+8+0+(5+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +3*3 && row < cell_position_row[cell_index]+25+(3+1)*3 && col >= cell_position_col[cell_index]+8+0+5*3 && col < cell_position_col[cell_index]+8+0+(5+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +4*3 && row < cell_position_row[cell_index]+25+(4+1)*3 && col >= cell_position_col[cell_index]+8+0+5*3 && col < cell_position_col[cell_index]+8+0+(5+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +5*3 && row < cell_position_row[cell_index]+25+(5+1)*3 && col >= cell_position_col[cell_index]+8+0+5*3 && col < cell_position_col[cell_index]+8+0+(5+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +6*3 && row < cell_position_row[cell_index]+25+(6+1)*3 && col >= cell_position_col[cell_index]+8+0+5*3 && col < cell_position_col[cell_index]+8+0+(5+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +7*3 && row < cell_position_row[cell_index]+25+(7+1)*3 && col >= cell_position_col[cell_index]+8+0+5*3 && col < cell_position_col[cell_index]+8+0+(5+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +8*3 && row < cell_position_row[cell_index]+25+(8+1)*3 && col >= cell_position_col[cell_index]+8+0+5*3 && col < cell_position_col[cell_index]+8+0+(5+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +1*3 && row < cell_position_row[cell_index]+25+(1+1)*3 && col >= cell_position_col[cell_index]+8+0+6*3 && col < cell_position_col[cell_index]+8+0+(6+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +8*3 && row < cell_position_row[cell_index]+25+(8+1)*3 && col >= cell_position_col[cell_index]+8+0+6*3 && col < cell_position_col[cell_index]+8+0+(6+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +1*3 && row < cell_position_row[cell_index]+25+(1+1)*3 && col >= cell_position_col[cell_index]+8+0+7*3 && col < cell_position_col[cell_index]+8+0+(7+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +8*3 && row < cell_position_row[cell_index]+25+(8+1)*3 && col >= cell_position_col[cell_index]+8+0+7*3 && col < cell_position_col[cell_index]+8+0+(7+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +1*3 && row < cell_position_row[cell_index]+25+(1+1)*3 && col >= cell_position_col[cell_index]+8+0+8*3 && col < cell_position_col[cell_index]+8+0+(8+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +8*3 && row < cell_position_row[cell_index]+25+(8+1)*3 && col >= cell_position_col[cell_index]+8+0+8*3 && col < cell_position_col[cell_index]+8+0+(8+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +1*3 && row < cell_position_row[cell_index]+25+(1+1)*3 && col >= cell_position_col[cell_index]+8+0+9*3 && col < cell_position_col[cell_index]+8+0+(9+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +2*3 && row < cell_position_row[cell_index]+25+(2+1)*3 && col >= cell_position_col[cell_index]+8+0+9*3 && col < cell_position_col[cell_index]+8+0+(9+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +3*3 && row < cell_position_row[cell_index]+25+(3+1)*3 && col >= cell_position_col[cell_index]+8+0+9*3 && col < cell_position_col[cell_index]+8+0+(9+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +4*3 && row < cell_position_row[cell_index]+25+(4+1)*3 && col >= cell_position_col[cell_index]+8+0+9*3 && col < cell_position_col[cell_index]+8+0+(9+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +5*3 && row < cell_position_row[cell_index]+25+(5+1)*3 && col >= cell_position_col[cell_index]+8+0+9*3 && col < cell_position_col[cell_index]+8+0+(9+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +6*3 && row < cell_position_row[cell_index]+25+(6+1)*3 && col >= cell_position_col[cell_index]+8+0+9*3 && col < cell_position_col[cell_index]+8+0+(9+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +7*3 && row < cell_position_row[cell_index]+25+(7+1)*3 && col >= cell_position_col[cell_index]+8+0+9*3 && col < cell_position_col[cell_index]+8+0+(9+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +8*3 && row < cell_position_row[cell_index]+25+(8+1)*3 && col >= cell_position_col[cell_index]+8+0+9*3 && col < cell_position_col[cell_index]+8+0+(9+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +1*3 && row < cell_position_row[cell_index]+25+(1+1)*3 && col >= cell_position_col[cell_index]+8+32+0*3 && col < cell_position_col[cell_index]+8+32+(0+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +2*3 && row < cell_position_row[cell_index]+25+(2+1)*3 && col >= cell_position_col[cell_index]+8+32+0*3 && col < cell_position_col[cell_index]+8+32+(0+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +6*3 && row < cell_position_row[cell_index]+25+(6+1)*3 && col >= cell_position_col[cell_index]+8+32+0*3 && col < cell_position_col[cell_index]+8+32+(0+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +7*3 && row < cell_position_row[cell_index]+25+(7+1)*3 && col >= cell_position_col[cell_index]+8+32+0*3 && col < cell_position_col[cell_index]+8+32+(0+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +8*3 && row < cell_position_row[cell_index]+25+(8+1)*3 && col >= cell_position_col[cell_index]+8+32+0*3 && col < cell_position_col[cell_index]+8+32+(0+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +1*3 && row < cell_position_row[cell_index]+25+(1+1)*3 && col >= cell_position_col[cell_index]+8+32+1*3 && col < cell_position_col[cell_index]+8+32+(1+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +5*3 && row < cell_position_row[cell_index]+25+(5+1)*3 && col >= cell_position_col[cell_index]+8+32+1*3 && col < cell_position_col[cell_index]+8+32+(1+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +6*3 && row < cell_position_row[cell_index]+25+(6+1)*3 && col >= cell_position_col[cell_index]+8+32+1*3 && col < cell_position_col[cell_index]+8+32+(1+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +8*3 && row < cell_position_row[cell_index]+25+(8+1)*3 && col >= cell_position_col[cell_index]+8+32+1*3 && col < cell_position_col[cell_index]+8+32+(1+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +1*3 && row < cell_position_row[cell_index]+25+(1+1)*3 && col >= cell_position_col[cell_index]+8+32+2*3 && col < cell_position_col[cell_index]+8+32+(2+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +4*3 && row < cell_position_row[cell_index]+25+(4+1)*3 && col >= cell_position_col[cell_index]+8+32+2*3 && col < cell_position_col[cell_index]+8+32+(2+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +5*3 && row < cell_position_row[cell_index]+25+(5+1)*3 && col >= cell_position_col[cell_index]+8+32+2*3 && col < cell_position_col[cell_index]+8+32+(2+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +8*3 && row < cell_position_row[cell_index]+25+(8+1)*3 && col >= cell_position_col[cell_index]+8+32+2*3 && col < cell_position_col[cell_index]+8+32+(2+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +1*3 && row < cell_position_row[cell_index]+25+(1+1)*3 && col >= cell_position_col[cell_index]+8+32+3*3 && col < cell_position_col[cell_index]+8+32+(3+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +2*3 && row < cell_position_row[cell_index]+25+(2+1)*3 && col >= cell_position_col[cell_index]+8+32+3*3 && col < cell_position_col[cell_index]+8+32+(3+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +3*3 && row < cell_position_row[cell_index]+25+(3+1)*3 && col >= cell_position_col[cell_index]+8+32+3*3 && col < cell_position_col[cell_index]+8+32+(3+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +4*3 && row < cell_position_row[cell_index]+25+(4+1)*3 && col >= cell_position_col[cell_index]+8+32+3*3 && col < cell_position_col[cell_index]+8+32+(3+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +8*3 && row < cell_position_row[cell_index]+25+(8+1)*3 && col >= cell_position_col[cell_index]+8+32+3*3 && col < cell_position_col[cell_index]+8+32+(3+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +3*3 && row < cell_position_row[cell_index]+25+(3+1)*3 && col >= cell_position_col[cell_index]+8+32+5*3 && col < cell_position_col[cell_index]+8+32+(5+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +4*3 && row < cell_position_row[cell_index]+25+(4+1)*3 && col >= cell_position_col[cell_index]+8+32+5*3 && col < cell_position_col[cell_index]+8+32+(5+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +1*3 && row < cell_position_row[cell_index]+25+(1+1)*3 && col >= cell_position_col[cell_index]+8+32+6*3 && col < cell_position_col[cell_index]+8+32+(6+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +2*3 && row < cell_position_row[cell_index]+25+(2+1)*3 && col >= cell_position_col[cell_index]+8+32+6*3 && col < cell_position_col[cell_index]+8+32+(6+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +4*3 && row < cell_position_row[cell_index]+25+(4+1)*3 && col >= cell_position_col[cell_index]+8+32+6*3 && col < cell_position_col[cell_index]+8+32+(6+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +4*3 && row < cell_position_row[cell_index]+25+(4+1)*3 && col >= cell_position_col[cell_index]+8+32+7*3 && col < cell_position_col[cell_index]+8+32+(7+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +1*3 && row < cell_position_row[cell_index]+25+(1+1)*3 && col >= cell_position_col[cell_index]+8+32+8*3 && col < cell_position_col[cell_index]+8+32+(8+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +2*3 && row < cell_position_row[cell_index]+25+(2+1)*3 && col >= cell_position_col[cell_index]+8+32+8*3 && col < cell_position_col[cell_index]+8+32+(8+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +3*3 && row < cell_position_row[cell_index]+25+(3+1)*3 && col >= cell_position_col[cell_index]+8+32+8*3 && col < cell_position_col[cell_index]+8+32+(8+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +4*3 && row < cell_position_row[cell_index]+25+(4+1)*3 && col >= cell_position_col[cell_index]+8+32+8*3 && col < cell_position_col[cell_index]+8+32+(8+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +5*3 && row < cell_position_row[cell_index]+25+(5+1)*3 && col >= cell_position_col[cell_index]+8+32+8*3 && col < cell_position_col[cell_index]+8+32+(8+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +6*3 && row < cell_position_row[cell_index]+25+(6+1)*3 && col >= cell_position_col[cell_index]+8+32+8*3 && col < cell_position_col[cell_index]+8+32+(8+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +7*3 && row < cell_position_row[cell_index]+25+(7+1)*3 && col >= cell_position_col[cell_index]+8+32+8*3 && col < cell_position_col[cell_index]+8+32+(8+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +8*3 && row < cell_position_row[cell_index]+25+(8+1)*3 && col >= cell_position_col[cell_index]+8+32+8*3 && col < cell_position_col[cell_index]+8+32+(8+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +4*3 && row < cell_position_row[cell_index]+25+(4+1)*3 && col >= cell_position_col[cell_index]+8+32+9*3 && col < cell_position_col[cell_index]+8+32+(9+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(col-cell_position_col[cell_index] > row-cell_position_row[cell_index]) {red, green, blue} <= 3'b110;
					else {red, green, blue} <= 3'b101;
				end
				else if(board[cell_index] == 8'd11) begin
					if(row >= cell_position_row[cell_index] + 25 +1*3 && row < cell_position_row[cell_index]+25+(1+1)*3 && col >= cell_position_col[cell_index]+8+0+0*3 && col < cell_position_col[cell_index]+8+0+(0+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +2*3 && row < cell_position_row[cell_index]+25+(2+1)*3 && col >= cell_position_col[cell_index]+8+0+0*3 && col < cell_position_col[cell_index]+8+0+(0+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +6*3 && row < cell_position_row[cell_index]+25+(6+1)*3 && col >= cell_position_col[cell_index]+8+0+0*3 && col < cell_position_col[cell_index]+8+0+(0+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +7*3 && row < cell_position_row[cell_index]+25+(7+1)*3 && col >= cell_position_col[cell_index]+8+0+0*3 && col < cell_position_col[cell_index]+8+0+(0+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +8*3 && row < cell_position_row[cell_index]+25+(8+1)*3 && col >= cell_position_col[cell_index]+8+0+0*3 && col < cell_position_col[cell_index]+8+0+(0+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +1*3 && row < cell_position_row[cell_index]+25+(1+1)*3 && col >= cell_position_col[cell_index]+8+0+1*3 && col < cell_position_col[cell_index]+8+0+(1+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +5*3 && row < cell_position_row[cell_index]+25+(5+1)*3 && col >= cell_position_col[cell_index]+8+0+1*3 && col < cell_position_col[cell_index]+8+0+(1+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +6*3 && row < cell_position_row[cell_index]+25+(6+1)*3 && col >= cell_position_col[cell_index]+8+0+1*3 && col < cell_position_col[cell_index]+8+0+(1+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +8*3 && row < cell_position_row[cell_index]+25+(8+1)*3 && col >= cell_position_col[cell_index]+8+0+1*3 && col < cell_position_col[cell_index]+8+0+(1+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +1*3 && row < cell_position_row[cell_index]+25+(1+1)*3 && col >= cell_position_col[cell_index]+8+0+2*3 && col < cell_position_col[cell_index]+8+0+(2+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +4*3 && row < cell_position_row[cell_index]+25+(4+1)*3 && col >= cell_position_col[cell_index]+8+0+2*3 && col < cell_position_col[cell_index]+8+0+(2+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +5*3 && row < cell_position_row[cell_index]+25+(5+1)*3 && col >= cell_position_col[cell_index]+8+0+2*3 && col < cell_position_col[cell_index]+8+0+(2+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +8*3 && row < cell_position_row[cell_index]+25+(8+1)*3 && col >= cell_position_col[cell_index]+8+0+2*3 && col < cell_position_col[cell_index]+8+0+(2+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +1*3 && row < cell_position_row[cell_index]+25+(1+1)*3 && col >= cell_position_col[cell_index]+8+0+3*3 && col < cell_position_col[cell_index]+8+0+(3+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +2*3 && row < cell_position_row[cell_index]+25+(2+1)*3 && col >= cell_position_col[cell_index]+8+0+3*3 && col < cell_position_col[cell_index]+8+0+(3+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +3*3 && row < cell_position_row[cell_index]+25+(3+1)*3 && col >= cell_position_col[cell_index]+8+0+3*3 && col < cell_position_col[cell_index]+8+0+(3+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +4*3 && row < cell_position_row[cell_index]+25+(4+1)*3 && col >= cell_position_col[cell_index]+8+0+3*3 && col < cell_position_col[cell_index]+8+0+(3+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +8*3 && row < cell_position_row[cell_index]+25+(8+1)*3 && col >= cell_position_col[cell_index]+8+0+3*3 && col < cell_position_col[cell_index]+8+0+(3+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +1*3 && row < cell_position_row[cell_index]+25+(1+1)*3 && col >= cell_position_col[cell_index]+8+0+6*3 && col < cell_position_col[cell_index]+8+0+(6+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +2*3 && row < cell_position_row[cell_index]+25+(2+1)*3 && col >= cell_position_col[cell_index]+8+0+6*3 && col < cell_position_col[cell_index]+8+0+(6+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +3*3 && row < cell_position_row[cell_index]+25+(3+1)*3 && col >= cell_position_col[cell_index]+8+0+6*3 && col < cell_position_col[cell_index]+8+0+(6+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +4*3 && row < cell_position_row[cell_index]+25+(4+1)*3 && col >= cell_position_col[cell_index]+8+0+6*3 && col < cell_position_col[cell_index]+8+0+(6+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +5*3 && row < cell_position_row[cell_index]+25+(5+1)*3 && col >= cell_position_col[cell_index]+8+0+6*3 && col < cell_position_col[cell_index]+8+0+(6+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +6*3 && row < cell_position_row[cell_index]+25+(6+1)*3 && col >= cell_position_col[cell_index]+8+0+6*3 && col < cell_position_col[cell_index]+8+0+(6+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +7*3 && row < cell_position_row[cell_index]+25+(7+1)*3 && col >= cell_position_col[cell_index]+8+0+6*3 && col < cell_position_col[cell_index]+8+0+(6+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +8*3 && row < cell_position_row[cell_index]+25+(8+1)*3 && col >= cell_position_col[cell_index]+8+0+6*3 && col < cell_position_col[cell_index]+8+0+(6+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +1*3 && row < cell_position_row[cell_index]+25+(1+1)*3 && col >= cell_position_col[cell_index]+8+0+7*3 && col < cell_position_col[cell_index]+8+0+(7+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +8*3 && row < cell_position_row[cell_index]+25+(8+1)*3 && col >= cell_position_col[cell_index]+8+0+7*3 && col < cell_position_col[cell_index]+8+0+(7+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +1*3 && row < cell_position_row[cell_index]+25+(1+1)*3 && col >= cell_position_col[cell_index]+8+0+8*3 && col < cell_position_col[cell_index]+8+0+(8+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +8*3 && row < cell_position_row[cell_index]+25+(8+1)*3 && col >= cell_position_col[cell_index]+8+0+8*3 && col < cell_position_col[cell_index]+8+0+(8+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +1*3 && row < cell_position_row[cell_index]+25+(1+1)*3 && col >= cell_position_col[cell_index]+8+0+9*3 && col < cell_position_col[cell_index]+8+0+(9+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +2*3 && row < cell_position_row[cell_index]+25+(2+1)*3 && col >= cell_position_col[cell_index]+8+0+9*3 && col < cell_position_col[cell_index]+8+0+(9+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +3*3 && row < cell_position_row[cell_index]+25+(3+1)*3 && col >= cell_position_col[cell_index]+8+0+9*3 && col < cell_position_col[cell_index]+8+0+(9+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +4*3 && row < cell_position_row[cell_index]+25+(4+1)*3 && col >= cell_position_col[cell_index]+8+0+9*3 && col < cell_position_col[cell_index]+8+0+(9+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +5*3 && row < cell_position_row[cell_index]+25+(5+1)*3 && col >= cell_position_col[cell_index]+8+0+9*3 && col < cell_position_col[cell_index]+8+0+(9+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +6*3 && row < cell_position_row[cell_index]+25+(6+1)*3 && col >= cell_position_col[cell_index]+8+0+9*3 && col < cell_position_col[cell_index]+8+0+(9+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +7*3 && row < cell_position_row[cell_index]+25+(7+1)*3 && col >= cell_position_col[cell_index]+8+0+9*3 && col < cell_position_col[cell_index]+8+0+(9+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +8*3 && row < cell_position_row[cell_index]+25+(8+1)*3 && col >= cell_position_col[cell_index]+8+0+9*3 && col < cell_position_col[cell_index]+8+0+(9+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +3*3 && row < cell_position_row[cell_index]+25+(3+1)*3 && col >= cell_position_col[cell_index]+8+32+0*3 && col < cell_position_col[cell_index]+8+32+(0+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +4*3 && row < cell_position_row[cell_index]+25+(4+1)*3 && col >= cell_position_col[cell_index]+8+32+0*3 && col < cell_position_col[cell_index]+8+32+(0+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +1*3 && row < cell_position_row[cell_index]+25+(1+1)*3 && col >= cell_position_col[cell_index]+8+32+1*3 && col < cell_position_col[cell_index]+8+32+(1+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +2*3 && row < cell_position_row[cell_index]+25+(2+1)*3 && col >= cell_position_col[cell_index]+8+32+1*3 && col < cell_position_col[cell_index]+8+32+(1+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +4*3 && row < cell_position_row[cell_index]+25+(4+1)*3 && col >= cell_position_col[cell_index]+8+32+1*3 && col < cell_position_col[cell_index]+8+32+(1+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +4*3 && row < cell_position_row[cell_index]+25+(4+1)*3 && col >= cell_position_col[cell_index]+8+32+2*3 && col < cell_position_col[cell_index]+8+32+(2+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +1*3 && row < cell_position_row[cell_index]+25+(1+1)*3 && col >= cell_position_col[cell_index]+8+32+3*3 && col < cell_position_col[cell_index]+8+32+(3+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +2*3 && row < cell_position_row[cell_index]+25+(2+1)*3 && col >= cell_position_col[cell_index]+8+32+3*3 && col < cell_position_col[cell_index]+8+32+(3+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +3*3 && row < cell_position_row[cell_index]+25+(3+1)*3 && col >= cell_position_col[cell_index]+8+32+3*3 && col < cell_position_col[cell_index]+8+32+(3+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +4*3 && row < cell_position_row[cell_index]+25+(4+1)*3 && col >= cell_position_col[cell_index]+8+32+3*3 && col < cell_position_col[cell_index]+8+32+(3+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +5*3 && row < cell_position_row[cell_index]+25+(5+1)*3 && col >= cell_position_col[cell_index]+8+32+3*3 && col < cell_position_col[cell_index]+8+32+(3+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +6*3 && row < cell_position_row[cell_index]+25+(6+1)*3 && col >= cell_position_col[cell_index]+8+32+3*3 && col < cell_position_col[cell_index]+8+32+(3+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +7*3 && row < cell_position_row[cell_index]+25+(7+1)*3 && col >= cell_position_col[cell_index]+8+32+3*3 && col < cell_position_col[cell_index]+8+32+(3+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +8*3 && row < cell_position_row[cell_index]+25+(8+1)*3 && col >= cell_position_col[cell_index]+8+32+3*3 && col < cell_position_col[cell_index]+8+32+(3+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +4*3 && row < cell_position_row[cell_index]+25+(4+1)*3 && col >= cell_position_col[cell_index]+8+32+4*3 && col < cell_position_col[cell_index]+8+32+(4+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +2*3 && row < cell_position_row[cell_index]+25+(2+1)*3 && col >= cell_position_col[cell_index]+8+32+6*3 && col < cell_position_col[cell_index]+8+32+(6+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +3*3 && row < cell_position_row[cell_index]+25+(3+1)*3 && col >= cell_position_col[cell_index]+8+32+6*3 && col < cell_position_col[cell_index]+8+32+(6+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +5*3 && row < cell_position_row[cell_index]+25+(5+1)*3 && col >= cell_position_col[cell_index]+8+32+6*3 && col < cell_position_col[cell_index]+8+32+(6+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +6*3 && row < cell_position_row[cell_index]+25+(6+1)*3 && col >= cell_position_col[cell_index]+8+32+6*3 && col < cell_position_col[cell_index]+8+32+(6+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +7*3 && row < cell_position_row[cell_index]+25+(7+1)*3 && col >= cell_position_col[cell_index]+8+32+6*3 && col < cell_position_col[cell_index]+8+32+(6+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +1*3 && row < cell_position_row[cell_index]+25+(1+1)*3 && col >= cell_position_col[cell_index]+8+32+7*3 && col < cell_position_col[cell_index]+8+32+(7+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +4*3 && row < cell_position_row[cell_index]+25+(4+1)*3 && col >= cell_position_col[cell_index]+8+32+7*3 && col < cell_position_col[cell_index]+8+32+(7+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +8*3 && row < cell_position_row[cell_index]+25+(8+1)*3 && col >= cell_position_col[cell_index]+8+32+7*3 && col < cell_position_col[cell_index]+8+32+(7+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +1*3 && row < cell_position_row[cell_index]+25+(1+1)*3 && col >= cell_position_col[cell_index]+8+32+8*3 && col < cell_position_col[cell_index]+8+32+(8+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +4*3 && row < cell_position_row[cell_index]+25+(4+1)*3 && col >= cell_position_col[cell_index]+8+32+8*3 && col < cell_position_col[cell_index]+8+32+(8+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +8*3 && row < cell_position_row[cell_index]+25+(8+1)*3 && col >= cell_position_col[cell_index]+8+32+8*3 && col < cell_position_col[cell_index]+8+32+(8+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +2*3 && row < cell_position_row[cell_index]+25+(2+1)*3 && col >= cell_position_col[cell_index]+8+32+9*3 && col < cell_position_col[cell_index]+8+32+(9+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +3*3 && row < cell_position_row[cell_index]+25+(3+1)*3 && col >= cell_position_col[cell_index]+8+32+9*3 && col < cell_position_col[cell_index]+8+32+(9+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +5*3 && row < cell_position_row[cell_index]+25+(5+1)*3 && col >= cell_position_col[cell_index]+8+32+9*3 && col < cell_position_col[cell_index]+8+32+(9+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +6*3 && row < cell_position_row[cell_index]+25+(6+1)*3 && col >= cell_position_col[cell_index]+8+32+9*3 && col < cell_position_col[cell_index]+8+32+(9+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(row >= cell_position_row[cell_index] + 25 +7*3 && row < cell_position_row[cell_index]+25+(7+1)*3 && col >= cell_position_col[cell_index]+8+32+9*3 && col < cell_position_col[cell_index]+8+32+(9+1)*3) begin
						{red, green, blue} <= 3'b000;
					end
					else if(col-cell_position_col[cell_index] > row-cell_position_row[cell_index]) {red, green, blue} <= 3'b101;
					else {red, green, blue} <= 3'b011;
				end
				else {red, green, blue} <= 3'b111;
			end
			else if(col >= 100 && col <= 100+40 && row >= 530 && row <= 530+40) {red, green, blue} <= 3'b100;
			else if(col >= 150 && col <= 150+40 && row >= 530 && row <= 530+40) {red, green, blue} <= 3'b010;
			else if(col >= 200 && col <= 200+40 && row >= 530 && row <= 530+40) {red, green, blue} <= 3'b001;
			else if(col >= 250 && col <= 250+40 && row >= 530 && row <= 530+40) {red, green, blue} <= 3'b110;
			else if(col >= 300 && col <= 300+40 && row >= 530 && row <= 530+40) {red, green, blue} <= 3'b101;
			else if(col >= 350 && col <= 350+40 && row >= 530 && row <= 530+40) {red, green, blue} <= 3'b011;
			else if(col >= 400 && col <= 400+40 && row >= 530 && row <= 530+40) begin
				if(col-400 > row-530) {red, green, blue} <= 3'b100;
				else {red, green, blue} <= 3'b010;
			end
			else if(col >= 450 && col <= 450+40 && row >= 530 && row <= 530+40) begin
				if(col-450 > row-530) {red, green, blue} <= 3'b010;
				else {red, green, blue} <= 3'b001;
			end
			else if(col >= 500 && col <= 500+40 && row >= 530 && row <= 530+40) begin
				if(col-500 > row-530) {red, green, blue} <= 3'b001;
				else {red, green, blue} <= 3'b100;
			end
			else if(col >= 550 && col <= 550+40 && row >= 530 && row <= 530+40) begin
				if(col-550 > row-530) {red, green, blue} <= 3'b110;
				else {red, green, blue} <= 3'b101;
			end
			else if(col >= 600 && col <= 600+40 && row >= 530 && row <= 530+40) begin
				if(col-600 > row-530) {red, green, blue} <= 3'b101;
				else {red, green, blue} <= 3'b011;
			end
			else if(endflag) {red, green, blue} <= 3'b100;
			else {red, green, blue} <= 3'b111;
		end
	end
	
	always @(posedge CLK or negedge RST) begin
		if(!RST) begin
		end
		else begin
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
			endflag <= 1'b0;
			clockcounter <= 32'd0;
		end
		else if(!endflag) begin
            if(!moveflag_2) begin
                {origin[0], origin[1], origin[2], origin[3]} <= {board[0], board[1], board[2], board[3]};
                {origin[4], origin[5], origin[6], origin[7]} <= {board[4], board[5], board[6], board[7]};
                {origin[8], origin[9], origin[10], origin[11]} <= {board[8], board[9], board[10], board[11]};
                {origin[12], origin[13], origin[14], origin[15]} <= {board[12], board[13], board[14], board[15]};
            end
			
			clockcounter <= clockcounter + 32'd1;
			
			if(board[0]>0&&board[1]>0&&board[2]>0&&board[3]>0&&board[4]>0&&board[5]>0&&board[6]>0&&board[7]>0) begin
			if(board[8]>0&&board[9]>0&&board[10]>0&&board[11]>0&&board[12]>0&&board[13]>0&&board[14]>0&&board[15]>0) begin
			if(board[0]!=board[1]&&board[1]!=board[2]&&board[2]!=board[3]) begin
			if(board[4]!=board[5]&&board[5]!=board[6]&&board[6]!=board[7]) begin
			if(board[8]!=board[9]&&board[9]!=board[10]&&board[10]!=board[11]) begin
			if(board[12]!=board[13]&&board[13]!=board[14]&&board[14]!=board[15]) begin
			if(board[0]!=board[4]&&board[4]!=board[8]&&board[8]!=board[12]) begin
			if(board[1]!=board[5]&&board[5]!=board[9]&&board[9]!=board[13]) begin
			if(board[2]!=board[6]&&board[6]!=board[10]&&board[10]!=board[14]) begin
			if(board[3]!=board[7]&&board[7]!=board[11]&&board[11]!=board[15]) begin
				endflag <= 1'b1;
			end end end end end end end end end end
			if(board[0]==8'd11||board[1]==8'd11||board[2]==8'd11||board[3]==8'd11) begin
			if(board[4]==8'd11||board[5]==8'd11||board[9]==8'd11||board[7]==8'd11) begin
			if(board[8]==8'd11||board[9]==8'd11||board[10]==8'd11||board[11]==8'd11) begin
			if(board[13]==8'd11||board[13]==8'd11||board[14]==8'd11||board[15]==8'd11) begin
				endflag <= 1'b1;
			end end end end 
			
			if(!moveflag_2 && !moveflag && !appearflag && up && down && left && right) begin
				activeflag <= 1'b0;
			end
			else begin
				activeflag <= 1'b1;
				if(!left && !activeflag) begin
					if(board[0] == 8'd0 && board[4] == 8'd0 && board[8] == 8'd0 && board[12] == 8'd0) begin
						{board[0], board[4], board[8], board[12]} <= {8'd0, 8'd0, 8'd0, 8'd0};
					end
					else if(board[0] == 8'd0 && board[4] == 8'd0 && board[8] == 8'd0 && board[12] != 8'd0) begin
						{board[0], board[4], board[8], board[12]} <= {board[12], 8'd0, 8'd0, 8'd0};
					end
					else if(board[0] == 8'd0 && board[4] == 8'd0 && board[8] != 8'd0 && board[12] == 8'd0) begin
						{board[0], board[4], board[8], board[12]} <= {board[8], 8'd0, 8'd0, 8'd0};
					end
					else if(board[0] == 8'd0 && board[4] != 8'd0 && board[8] == 8'd0 && board[12] == 8'd0) begin
						{board[0], board[4], board[8], board[12]} <= {board[4], 8'd0, 8'd0, 8'd0};
					end
					else if(board[0] != 8'd0 && board[4] == 8'd0 && board[8] == 8'd0 && board[12] == 8'd0) begin
						{board[0], board[4], board[8], board[12]} <= {board[0], 8'd0, 8'd0, 8'd0};
					end
					else if(board[0] == 8'd0 && board[4] == 8'd0 && board[8] != 8'd0 && board[12] != 8'd0) begin
						if(board[8] != board[12]) {board[0], board[4], board[8], board[12]} <= {board[8], board[12], 8'd0, 8'd0};
						else {board[0], board[4], board[8], board[12]} <= {board[8]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[0] == 8'd0 && board[4] != 8'd0 && board[8] == 8'd0 && board[12] != 8'd0) begin
						if(board[4] != board[12]) {board[0], board[4], board[8], board[12]} <= {board[4], board[12], 8'd0, 8'd0};
						else {board[0], board[4], board[8], board[12]} <= {board[4]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[0] != 8'd0 && board[4] == 8'd0 && board[8] == 8'd0 && board[12] != 8'd0) begin
						if(board[0] != board[12]) {board[0], board[4], board[8], board[12]} <= {board[0], board[12], 8'd0, 8'd0};
						else {board[0], board[4], board[8], board[12]} <= {board[0]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[0] == 8'd0 && board[4] != 8'd0 && board[8] != 8'd0 && board[12] == 8'd0) begin
						if(board[4] != board[8]) {board[0], board[4], board[8], board[12]} <= {board[4], board[8], 8'd0, 8'd0};
						else {board[0], board[4], board[8], board[12]} <= {board[4]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[0] != 8'd0 && board[4] == 8'd0 && board[8] != 8'd0 && board[12] == 8'd0) begin
						if(board[0] != board[8]) {board[0], board[4], board[8], board[12]} <= {board[0], board[8], 8'd0, 8'd0};
						else {board[0], board[4], board[8], board[12]} <= {board[0]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[0] != 8'd0 && board[4] != 8'd0 && board[8] == 8'd0 && board[12] == 8'd0) begin
						if(board[0] != board[4]) {board[0], board[4], board[8], board[12]} <= {board[0], board[4], 8'd0, 8'd0};
						else {board[0], board[4], board[8], board[12]} <= {board[0]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[0] != 8'd0 && board[4] != 8'd0 && board[8] != 8'd0 && board[12] == 8'd0) begin
						if(board[0] == board[4]) {board[0], board[4], board[8], board[12]} <= {board[0]+8'd1, board[8], 8'd0, 8'd0};
						else if(board[4] == board[8]) {board[0], board[4], board[8], board[12]} <= {board[0], board[4]+8'd1, 8'd0, 8'd0};
						else {board[0], board[4], board[8], board[12]} <= {board[0], board[4], board[8], 8'd0};
					end
					else if(board[0] != 8'd0 && board[4] != 8'd0 && board[8] == 8'd0 && board[12] != 8'd0) begin
						if(board[0] == board[4]) {board[0], board[4], board[8], board[12]} <= {board[0]+8'd1, board[12], 8'd0, 8'd0};
						else if(board[4] == board[12]) {board[0], board[4], board[8], board[12]} <= {board[0], board[4]+8'd1, 8'd0, 8'd0};
						else {board[0], board[4], board[8], board[12]} <= {board[0], board[4], board[12], 8'd0};
					end
					else if(board[0] != 8'd0 && board[4] == 8'd0 && board[8] != 8'd0 && board[12] != 8'd0) begin
						if(board[0] == board[8]) {board[0], board[4], board[8], board[12]} <= {board[0]+8'd1, board[12], 8'd0, 8'd0};
						else if(board[8] == board[12]) {board[0], board[4], board[8], board[12]} <= {board[0], board[8]+8'd1, 8'd0, 8'd0};
						else {board[0], board[4], board[8], board[12]} <= {board[0], board[8], board[12], 8'd0};
					end
					else if(board[0] == 8'd0 && board[4] != 8'd0 && board[8] != 8'd0 && board[12] != 8'd0) begin
						if(board[4] == board[8]) {board[0], board[4], board[8], board[12]} <= {board[4]+8'd1, board[12], 8'd0, 8'd0};
						else if(board[8] == board[12]) {board[0], board[4], board[8], board[12]} <= {board[4], board[8]+8'd1, 8'd0, 8'd0};
						else {board[0], board[4], board[8], board[12]} <= {board[4], board[8], board[12], 8'd0};
					end
					else begin
						if(board[0] == board[4]) begin
							if(board[8] == board[12]) {board[0], board[4], board[8], board[12]} <= {board[0]+8'd1, board[8]+8'd1, 8'd0, 8'd0};
							else {board[0], board[4], board[8], board[12]} <= {board[0]+8'd1, board[8], board[12], 8'd0};
						end
						else begin
							if(board[4] == board[8]) {board[0], board[4], board[8], board[12]} <= {board[0], board[4]+8'd1, board[12], 8'd0};
							else if(board[8] == board[12]) {board[0], board[4], board[8], board[12]} <= {board[0], board[4], board[8]+8'd1, 8'd0};
							else {board[0], board[4], board[8], board[12]} <= {board[0], board[4], board[8], board[12]};
						end
					end
					
					if(board[1] == 8'd0 && board[5] == 8'd0 && board[9] == 8'd0 && board[13] == 8'd0) begin
						{board[1], board[5], board[9], board[13]} <= {8'd0, 8'd0, 8'd0, 8'd0};
					end
					else if(board[1] == 8'd0 && board[5] == 8'd0 && board[9] == 8'd0 && board[13] != 8'd0) begin
						{board[1], board[5], board[9], board[13]} <= {board[13], 8'd0, 8'd0, 8'd0};
					end
					else if(board[1] == 8'd0 && board[5] == 8'd0 && board[9] != 8'd0 && board[13] == 8'd0) begin
						{board[1], board[5], board[9], board[13]} <= {board[9], 8'd0, 8'd0, 8'd0};
					end
					else if(board[1] == 8'd0 && board[5] != 8'd0 && board[9] == 8'd0 && board[13] == 8'd0) begin
						{board[1], board[5], board[9], board[13]} <= {board[5], 8'd0, 8'd0, 8'd0};
					end
					else if(board[1] != 8'd0 && board[5] == 8'd0 && board[9] == 8'd0 && board[13] == 8'd0) begin
						{board[1], board[5], board[9], board[13]} <= {board[1], 8'd0, 8'd0, 8'd0};
					end
					else if(board[1] == 8'd0 && board[5] == 8'd0 && board[9] != 8'd0 && board[13] != 8'd0) begin
						if(board[9] != board[13]) {board[1], board[5], board[9], board[13]} <= {board[9], board[13], 8'd0, 8'd0};
						else {board[1], board[5], board[9], board[13]} <= {board[9]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[1] == 8'd0 && board[5] != 8'd0 && board[9] == 8'd0 && board[13] != 8'd0) begin
						if(board[5] != board[13]) {board[1], board[5], board[9], board[13]} <= {board[5], board[13], 8'd0, 8'd0};
						else {board[1], board[5], board[9], board[13]} <= {board[5]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[1] != 8'd0 && board[5] == 8'd0 && board[9] == 8'd0 && board[13] != 8'd0) begin
						if(board[1] != board[13]) {board[1], board[5], board[9], board[13]} <= {board[1], board[13], 8'd0, 8'd0};
						else {board[1], board[5], board[9], board[13]} <= {board[1]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[1] == 8'd0 && board[5] != 8'd0 && board[9] != 8'd0 && board[13] == 8'd0) begin
						if(board[5] != board[9]) {board[1], board[5], board[9], board[13]} <= {board[5], board[9], 8'd0, 8'd0};
						else {board[1], board[5], board[9], board[13]} <= {board[5]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[1] != 8'd0 && board[5] == 8'd0 && board[9] != 8'd0 && board[13] == 8'd0) begin
						if(board[1] != board[9]) {board[1], board[5], board[9], board[13]} <= {board[1], board[9], 8'd0, 8'd0};
						else {board[1], board[5], board[9], board[13]} <= {board[1]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[1] != 8'd0 && board[5] != 8'd0 && board[9] == 8'd0 && board[13] == 8'd0) begin
						if(board[1] != board[5]) {board[1], board[5], board[9], board[13]} <= {board[1], board[5], 8'd0, 8'd0};
						else {board[1], board[5], board[9], board[13]} <= {board[1]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[1] != 8'd0 && board[5] != 8'd0 && board[9] != 8'd0 && board[13] == 8'd0) begin
						if(board[1] == board[5]) {board[1], board[5], board[9], board[13]} <= {board[1]+8'd1, board[9], 8'd0, 8'd0};
						else if(board[5] == board[9]) {board[1], board[5], board[9], board[13]} <= {board[1], board[5]+8'd1, 8'd0, 8'd0};
						else {board[1], board[5], board[9], board[13]} <= {board[1], board[5], board[9], 8'd0};
					end
					else if(board[1] != 8'd0 && board[5] != 8'd0 && board[9] == 8'd0 && board[13] != 8'd0) begin
						if(board[1] == board[5]) {board[1], board[5], board[9], board[13]} <= {board[1]+8'd1, board[13], 8'd0, 8'd0};
						else if(board[5] == board[13]) {board[1], board[5], board[9], board[13]} <= {board[1], board[5]+8'd1, 8'd0, 8'd0};
						else {board[1], board[5], board[9], board[13]} <= {board[1], board[5], board[13], 8'd0};
					end
					else if(board[1] != 8'd0 && board[5] == 8'd0 && board[9] != 8'd0 && board[13] != 8'd0) begin
						if(board[1] == board[9]) {board[1], board[5], board[9], board[13]} <= {board[1]+8'd1, board[13], 8'd0, 8'd0};
						else if(board[9] == board[13]) {board[1], board[5], board[9], board[13]} <= {board[1], board[9]+8'd1, 8'd0, 8'd0};
						else {board[1], board[5], board[9], board[13]} <= {board[1], board[9], board[13], 8'd0};
					end
					else if(board[1] == 8'd0 && board[5] != 8'd0 && board[9] != 8'd0 && board[13] != 8'd0) begin
						if(board[5] == board[9]) {board[1], board[5], board[9], board[13]} <= {board[5]+8'd1, board[13], 8'd0, 8'd0};
						else if(board[9] == board[13]) {board[1], board[5], board[9], board[13]} <= {board[5], board[9]+8'd1, 8'd0, 8'd0};
						else {board[1], board[5], board[9], board[13]} <= {board[5], board[9], board[13], 8'd0};
					end
					else begin
						if(board[1] == board[5]) begin
							if(board[9] == board[13]) {board[1], board[5], board[9], board[13]} <= {board[1]+8'd1, board[9]+8'd1, 8'd0, 8'd0};
							else {board[1], board[5], board[9], board[13]} <= {board[1]+8'd1, board[9], board[13], 8'd0};
						end
						else begin
							if(board[5] == board[9]) {board[1], board[5], board[9], board[13]} <= {board[1], board[5]+8'd1, board[13], 8'd0};
							else if(board[9] == board[13]) {board[1], board[5], board[9], board[13]} <= {board[1], board[5], board[9]+8'd1, 8'd0};
							else {board[1], board[5], board[9], board[13]} <= {board[1], board[5], board[9], board[13]};
						end
					end
					
					if(board[2] == 8'd0 && board[6] == 8'd0 && board[10] == 8'd0 && board[14] == 8'd0) begin
						{board[2], board[6], board[10], board[14]} <= {8'd0, 8'd0, 8'd0, 8'd0};
					end
					else if(board[2] == 8'd0 && board[6] == 8'd0 && board[10] == 8'd0 && board[14] != 8'd0) begin
						{board[2], board[6], board[10], board[14]} <= {board[14], 8'd0, 8'd0, 8'd0};
					end
					else if(board[2] == 8'd0 && board[6] == 8'd0 && board[10] != 8'd0 && board[14] == 8'd0) begin
						{board[2], board[6], board[10], board[14]} <= {board[10], 8'd0, 8'd0, 8'd0};
					end
					else if(board[2] == 8'd0 && board[6] != 8'd0 && board[10] == 8'd0 && board[14] == 8'd0) begin
						{board[2], board[6], board[10], board[14]} <= {board[6], 8'd0, 8'd0, 8'd0};
					end
					else if(board[2] != 8'd0 && board[6] == 8'd0 && board[10] == 8'd0 && board[14] == 8'd0) begin
						{board[2], board[6], board[10], board[14]} <= {board[2], 8'd0, 8'd0, 8'd0};
					end
					else if(board[2] == 8'd0 && board[6] == 8'd0 && board[10] != 8'd0 && board[14] != 8'd0) begin
						if(board[10] != board[14]) {board[2], board[6], board[10], board[14]} <= {board[10], board[14], 8'd0, 8'd0};
						else {board[2], board[6], board[10], board[14]} <= {board[10]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[2] == 8'd0 && board[6] != 8'd0 && board[10] == 8'd0 && board[14] != 8'd0) begin
						if(board[6] != board[14]) {board[2], board[6], board[10], board[14]} <= {board[6], board[14], 8'd0, 8'd0};
						else {board[2], board[6], board[10], board[14]} <= {board[6]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[2] != 8'd0 && board[6] == 8'd0 && board[10] == 8'd0 && board[14] != 8'd0) begin
						if(board[2] != board[14]) {board[2], board[6], board[10], board[14]} <= {board[2], board[14], 8'd0, 8'd0};
						else {board[2], board[6], board[10], board[14]} <= {board[2]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[2] == 8'd0 && board[6] != 8'd0 && board[10] != 8'd0 && board[14] == 8'd0) begin
						if(board[6] != board[10]) {board[2], board[6], board[10], board[14]} <= {board[6], board[10], 8'd0, 8'd0};
						else {board[2], board[6], board[10], board[14]} <= {board[6]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[2] != 8'd0 && board[6] == 8'd0 && board[10] != 8'd0 && board[14] == 8'd0) begin
						if(board[2] != board[10]) {board[2], board[6], board[10], board[14]} <= {board[2], board[10], 8'd0, 8'd0};
						else {board[2], board[6], board[10], board[14]} <= {board[2]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[2] != 8'd0 && board[6] != 8'd0 && board[10] == 8'd0 && board[14] == 8'd0) begin
						if(board[2] != board[6]) {board[2], board[6], board[10], board[14]} <= {board[2], board[6], 8'd0, 8'd0};
						else {board[2], board[6], board[10], board[14]} <= {board[2]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[2] != 8'd0 && board[6] != 8'd0 && board[10] != 8'd0 && board[14] == 8'd0) begin
						if(board[2] == board[6]) {board[2], board[6], board[10], board[14]} <= {board[2]+8'd1, board[10], 8'd0, 8'd0};
						else if(board[6] == board[10]) {board[2], board[6], board[10], board[14]} <= {board[2], board[6]+8'd1, 8'd0, 8'd0};
						else {board[2], board[6], board[10], board[14]} <= {board[2], board[6], board[10], 8'd0};
					end
					else if(board[2] != 8'd0 && board[6] != 8'd0 && board[10] == 8'd0 && board[14] != 8'd0) begin
						if(board[2] == board[6]) {board[2], board[6], board[10], board[14]} <= {board[2]+8'd1, board[14], 8'd0, 8'd0};
						else if(board[6] == board[14]) {board[2], board[6], board[10], board[14]} <= {board[2], board[6]+8'd1, 8'd0, 8'd0};
						else {board[2], board[6], board[10], board[14]} <= {board[2], board[6], board[14], 8'd0};
					end
					else if(board[2] != 8'd0 && board[6] == 8'd0 && board[10] != 8'd0 && board[14] != 8'd0) begin
						if(board[2] == board[10]) {board[2], board[6], board[10], board[14]} <= {board[2]+8'd1, board[14], 8'd0, 8'd0};
						else if(board[10] == board[14]) {board[2], board[6], board[10], board[14]} <= {board[2], board[10]+8'd1, 8'd0, 8'd0};
						else {board[2], board[6], board[10], board[14]} <= {board[2], board[10], board[14], 8'd0};
					end
					else if(board[2] == 8'd0 && board[6] != 8'd0 && board[10] != 8'd0 && board[14] != 8'd0) begin
						if(board[6] == board[10]) {board[2], board[6], board[10], board[14]} <= {board[6]+8'd1, board[14], 8'd0, 8'd0};
						else if(board[10] == board[14]) {board[2], board[6], board[10], board[14]} <= {board[6], board[10]+8'd1, 8'd0, 8'd0};
						else {board[2], board[6], board[10], board[14]} <= {board[6], board[10], board[14], 8'd0};
					end
					else begin
						if(board[2] == board[6]) begin
							if(board[10] == board[14]) {board[2], board[6], board[10], board[14]} <= {board[2]+8'd1, board[10]+8'd1, 8'd0, 8'd0};
							else {board[2], board[6], board[10], board[14]} <= {board[2]+8'd1, board[10], board[14], 8'd0};
						end
						else begin
							if(board[6] == board[10]) {board[2], board[6], board[10], board[14]} <= {board[2], board[6]+8'd1, board[14], 8'd0};
							else if(board[10] == board[14]) {board[2], board[6], board[10], board[14]} <= {board[2], board[6], board[10]+8'd1, 8'd0};
							else {board[2], board[6], board[10], board[14]} <= {board[2], board[6], board[10], board[14]};
						end
					end
					
					if(board[3] == 8'd0 && board[7] == 8'd0 && board[11] == 8'd0 && board[15] == 8'd0) begin
						{board[3], board[7], board[11], board[15]} <= {8'd0, 8'd0, 8'd0, 8'd0};
					end
					else if(board[3] == 8'd0 && board[7] == 8'd0 && board[11] == 8'd0 && board[15] != 8'd0) begin
						{board[3], board[7], board[11], board[15]} <= {board[15], 8'd0, 8'd0, 8'd0};
					end
					else if(board[3] == 8'd0 && board[7] == 8'd0 && board[11] != 8'd0 && board[15] == 8'd0) begin
						{board[3], board[7], board[11], board[15]} <= {board[11], 8'd0, 8'd0, 8'd0};
					end
					else if(board[3] == 8'd0 && board[7] != 8'd0 && board[11] == 8'd0 && board[15] == 8'd0) begin
						{board[3], board[7], board[11], board[15]} <= {board[7], 8'd0, 8'd0, 8'd0};
					end
					else if(board[3] != 8'd0 && board[7] == 8'd0 && board[11] == 8'd0 && board[15] == 8'd0) begin
						{board[3], board[7], board[11], board[15]} <= {board[3], 8'd0, 8'd0, 8'd0};
					end
					else if(board[3] == 8'd0 && board[7] == 8'd0 && board[11] != 8'd0 && board[15] != 8'd0) begin
						if(board[11] != board[15]) {board[3], board[7], board[11], board[15]} <= {board[11], board[15], 8'd0, 8'd0};
						else {board[3], board[7], board[11], board[15]} <= {board[11]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[3] == 8'd0 && board[7] != 8'd0 && board[11] == 8'd0 && board[15] != 8'd0) begin
						if(board[7] != board[15]) {board[3], board[7], board[11], board[15]} <= {board[7], board[15], 8'd0, 8'd0};
						else {board[3], board[7], board[11], board[15]} <= {board[7]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[3] != 8'd0 && board[7] == 8'd0 && board[11] == 8'd0 && board[15] != 8'd0) begin
						if(board[3] != board[15]) {board[3], board[7], board[11], board[15]} <= {board[3], board[15], 8'd0, 8'd0};
						else {board[3], board[7], board[11], board[15]} <= {board[3]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[3] == 8'd0 && board[7] != 8'd0 && board[11] != 8'd0 && board[15] == 8'd0) begin
						if(board[7] != board[11]) {board[3], board[7], board[11], board[15]} <= {board[7], board[11], 8'd0, 8'd0};
						else {board[3], board[7], board[11], board[15]} <= {board[7]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[3] != 8'd0 && board[7] == 8'd0 && board[11] != 8'd0 && board[15] == 8'd0) begin
						if(board[3] != board[11]) {board[3], board[7], board[11], board[15]} <= {board[3], board[11], 8'd0, 8'd0};
						else {board[3], board[7], board[11], board[15]} <= {board[3]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[3] != 8'd0 && board[7] != 8'd0 && board[11] == 8'd0 && board[15] == 8'd0) begin
						if(board[3] != board[7]) {board[3], board[7], board[11], board[15]} <= {board[3], board[7], 8'd0, 8'd0};
						else {board[3], board[7], board[11], board[15]} <= {board[3]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[3] != 8'd0 && board[7] != 8'd0 && board[11] != 8'd0 && board[15] == 8'd0) begin
						if(board[3] == board[7]) {board[3], board[7], board[11], board[15]} <= {board[3]+8'd1, board[11], 8'd0, 8'd0};
						else if(board[7] == board[11]) {board[3], board[7], board[11], board[15]} <= {board[3], board[7]+8'd1, 8'd0, 8'd0};
						else {board[3], board[7], board[11], board[15]} <= {board[3], board[7], board[11], 8'd0};
					end
					else if(board[3] != 8'd0 && board[7] != 8'd0 && board[11] == 8'd0 && board[15] != 8'd0) begin
						if(board[3] == board[7]) {board[3], board[7], board[11], board[15]} <= {board[3]+8'd1, board[15], 8'd0, 8'd0};
						else if(board[7] == board[15]) {board[3], board[7], board[11], board[15]} <= {board[3], board[7]+8'd1, 8'd0, 8'd0};
						else {board[3], board[7], board[11], board[15]} <= {board[3], board[7], board[15], 8'd0};
					end
					else if(board[3] != 8'd0 && board[7] == 8'd0 && board[11] != 8'd0 && board[15] != 8'd0) begin
						if(board[3] == board[11]) {board[3], board[7], board[11], board[15]} <= {board[3]+8'd1, board[15], 8'd0, 8'd0};
						else if(board[11] == board[15]) {board[3], board[7], board[11], board[15]} <= {board[3], board[11]+8'd1, 8'd0, 8'd0};
						else {board[3], board[7], board[11], board[15]} <= {board[3], board[11], board[15], 8'd0};
					end
					else if(board[3] == 8'd0 && board[7] != 8'd0 && board[11] != 8'd0 && board[15] != 8'd0) begin
						if(board[7] == board[11]) {board[3], board[7], board[11], board[15]} <= {board[7]+8'd1, board[15], 8'd0, 8'd0};
						else if(board[11] == board[15]) {board[3], board[7], board[11], board[15]} <= {board[7], board[11]+8'd1, 8'd0, 8'd0};
						else {board[3], board[7], board[11], board[15]} <= {board[7], board[11], board[15], 8'd0};
					end
					else begin
						if(board[3] == board[7]) begin
							if(board[11] == board[15]) {board[3], board[7], board[11], board[15]} <= {board[3]+8'd1, board[11]+8'd1, 8'd0, 8'd0};
							else {board[3], board[7], board[11], board[15]} <= {board[3]+8'd1, board[11], board[15], 8'd0};
						end
						else begin
							if(board[7] == board[11]) {board[3], board[7], board[11], board[15]} <= {board[3], board[7]+8'd1, board[15], 8'd0};
							else if(board[11] == board[15]) {board[3], board[7], board[11], board[15]} <= {board[3], board[7], board[11]+8'd1, 8'd0};
							else {board[3], board[7], board[11], board[15]} <= {board[3], board[7], board[11], board[15]};
						end
					end
				end
				else if(!up && !activeflag) begin
					if(board[0] == 8'd0 && board[1] == 8'd0 && board[2] == 8'd0 && board[3] == 8'd0) begin
						{board[0], board[1], board[2], board[3]} <= {8'd0, 8'd0, 8'd0, 8'd0};
					end
					else if(board[0] == 8'd0 && board[1] == 8'd0 && board[2] == 8'd0 && board[3] != 8'd0) begin
						{board[0], board[1], board[2], board[3]} <= {board[3], 8'd0, 8'd0, 8'd0};
					end
					else if(board[0] == 8'd0 && board[1] == 8'd0 && board[2] != 8'd0 && board[3] == 8'd0) begin
						{board[0], board[1], board[2], board[3]} <= {board[2], 8'd0, 8'd0, 8'd0};
					end
					else if(board[0] == 8'd0 && board[1] != 8'd0 && board[2] == 8'd0 && board[3] == 8'd0) begin
						{board[0], board[1], board[2], board[3]} <= {board[1], 8'd0, 8'd0, 8'd0};
					end
					else if(board[0] != 8'd0 && board[1] == 8'd0 && board[2] == 8'd0 && board[3] == 8'd0) begin
						{board[0], board[1], board[2], board[3]} <= {board[0], 8'd0, 8'd0, 8'd0};
					end
					else if(board[0] == 8'd0 && board[1] == 8'd0 && board[2] != 8'd0 && board[3] != 8'd0) begin
						if(board[2] != board[3]) {board[0], board[1], board[2], board[3]} <= {board[2], board[3], 8'd0, 8'd0};
						else {board[0], board[1], board[2], board[3]} <= {board[2]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[0] == 8'd0 && board[1] != 8'd0 && board[2] == 8'd0 && board[3] != 8'd0) begin
						if(board[1] != board[3]) {board[0], board[1], board[2], board[3]} <= {board[1], board[3], 8'd0, 8'd0};
						else {board[0], board[1], board[2], board[3]} <= {board[1]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[0] != 8'd0 && board[1] == 8'd0 && board[2] == 8'd0 && board[3] != 8'd0) begin
						if(board[0] != board[3]) {board[0], board[1], board[2], board[3]} <= {board[0], board[3], 8'd0, 8'd0};
						else {board[0], board[1], board[2], board[3]} <= {board[0]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[0] == 8'd0 && board[1] != 8'd0 && board[2] != 8'd0 && board[3] == 8'd0) begin
						if(board[1] != board[2]) {board[0], board[1], board[2], board[3]} <= {board[1], board[2], 8'd0, 8'd0};
						else {board[0], board[1], board[2], board[3]} <= {board[1]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[0] != 8'd0 && board[1] == 8'd0 && board[2] != 8'd0 && board[3] == 8'd0) begin
						if(board[0] != board[2]) {board[0], board[1], board[2], board[3]} <= {board[0], board[2], 8'd0, 8'd0};
						else {board[0], board[1], board[2], board[3]} <= {board[0]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[0] != 8'd0 && board[1] != 8'd0 && board[2] == 8'd0 && board[3] == 8'd0) begin
						if(board[0] != board[1]) {board[0], board[1], board[2], board[3]} <= {board[0], board[1], 8'd0, 8'd0};
						else {board[0], board[1], board[2], board[3]} <= {board[0]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[0] != 8'd0 && board[1] != 8'd0 && board[2] != 8'd0 && board[3] == 8'd0) begin
						if(board[0] == board[1]) {board[0], board[1], board[2], board[3]} <= {board[0]+8'd1, board[2], 8'd0, 8'd0};
						else if(board[1] == board[2]) {board[0], board[1], board[2], board[3]} <= {board[0], board[1]+8'd1, 8'd0, 8'd0};
						else {board[0], board[1], board[2], board[3]} <= {board[0], board[1], board[2], 8'd0};
					end
					else if(board[0] != 8'd0 && board[1] != 8'd0 && board[2] == 8'd0 && board[3] != 8'd0) begin
						if(board[0] == board[1]) {board[0], board[1], board[2], board[3]} <= {board[0]+8'd1, board[3], 8'd0, 8'd0};
						else if(board[1] == board[3]) {board[0], board[1], board[2], board[3]} <= {board[0], board[1]+8'd1, 8'd0, 8'd0};
						else {board[0], board[1], board[2], board[3]} <= {board[0], board[1], board[3], 8'd0};
					end
					else if(board[0] != 8'd0 && board[1] == 8'd0 && board[2] != 8'd0 && board[3] != 8'd0) begin
						if(board[0] == board[2]) {board[0], board[1], board[2], board[3]} <= {board[0]+8'd1, board[3], 8'd0, 8'd0};
						else if(board[2] == board[3]) {board[0], board[1], board[2], board[3]} <= {board[0], board[2]+8'd1, 8'd0, 8'd0};
						else {board[0], board[1], board[2], board[3]} <= {board[0], board[2], board[3], 8'd0};
					end
					else if(board[0] == 8'd0 && board[1] != 8'd0 && board[2] != 8'd0 && board[3] != 8'd0) begin
						if(board[1] == board[2]) {board[0], board[1], board[2], board[3]} <= {board[1]+8'd1, board[3], 8'd0, 8'd0};
						else if(board[2] == board[3]) {board[0], board[1], board[2], board[3]} <= {board[1], board[2]+8'd1, 8'd0, 8'd0};
						else {board[0], board[1], board[2], board[3]} <= {board[1], board[2], board[3], 8'd0};
					end
					else begin
						if(board[0] == board[1]) begin
							if(board[2] == board[3]) {board[0], board[1], board[2], board[3]} <= {board[0]+8'd1, board[2]+8'd1, 8'd0, 8'd0};
							else {board[0], board[1], board[2], board[3]} <= {board[0]+8'd1, board[2], board[3], 8'd0};
						end
						else begin
							if(board[1] == board[2]) {board[0], board[1], board[2], board[3]} <= {board[0], board[1]+8'd1, board[3], 8'd0};
							else if(board[2] == board[3]) {board[0], board[1], board[2], board[3]} <= {board[0], board[1], board[2]+8'd1, 8'd0};
							else {board[0], board[1], board[2], board[3]} <= {board[0], board[1], board[2], board[3]};
						end
					end
					
					if(board[4] == 8'd0 && board[5] == 8'd0 && board[6] == 8'd0 && board[7] == 8'd0) begin
						{board[4], board[5], board[6], board[7]} <= {8'd0, 8'd0, 8'd0, 8'd0};
					end
					else if(board[4] == 8'd0 && board[5] == 8'd0 && board[6] == 8'd0 && board[7] != 8'd0) begin
						{board[4], board[5], board[6], board[7]} <= {board[7], 8'd0, 8'd0, 8'd0};
					end
					else if(board[4] == 8'd0 && board[5] == 8'd0 && board[6] != 8'd0 && board[7] == 8'd0) begin
						{board[4], board[5], board[6], board[7]} <= {board[6], 8'd0, 8'd0, 8'd0};
					end
					else if(board[4] == 8'd0 && board[5] != 8'd0 && board[6] == 8'd0 && board[7] == 8'd0) begin
						{board[4], board[5], board[6], board[7]} <= {board[5], 8'd0, 8'd0, 8'd0};
					end
					else if(board[4] != 8'd0 && board[5] == 8'd0 && board[6] == 8'd0 && board[7] == 8'd0) begin
						{board[4], board[5], board[6], board[7]} <= {board[4], 8'd0, 8'd0, 8'd0};
					end
					else if(board[4] == 8'd0 && board[5] == 8'd0 && board[6] != 8'd0 && board[7] != 8'd0) begin
						if(board[6] != board[7]) {board[4], board[5], board[6], board[7]} <= {board[6], board[7], 8'd0, 8'd0};
						else {board[4], board[5], board[6], board[7]} <= {board[6]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[4] == 8'd0 && board[5] != 8'd0 && board[6] == 8'd0 && board[7] != 8'd0) begin
						if(board[5] != board[7]) {board[4], board[5], board[6], board[7]} <= {board[5], board[7], 8'd0, 8'd0};
						else {board[4], board[5], board[6], board[7]} <= {board[5]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[4] != 8'd0 && board[5] == 8'd0 && board[6] == 8'd0 && board[7] != 8'd0) begin
						if(board[4] != board[7]) {board[4], board[5], board[6], board[7]} <= {board[4], board[7], 8'd0, 8'd0};
						else {board[4], board[5], board[6], board[7]} <= {board[4]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[4] == 8'd0 && board[5] != 8'd0 && board[6] != 8'd0 && board[7] == 8'd0) begin
						if(board[5] != board[6]) {board[4], board[5], board[6], board[7]} <= {board[5], board[6], 8'd0, 8'd0};
						else {board[4], board[5], board[6], board[7]} <= {board[5]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[4] != 8'd0 && board[5] == 8'd0 && board[6] != 8'd0 && board[7] == 8'd0) begin
						if(board[4] != board[6]) {board[4], board[5], board[6], board[7]} <= {board[4], board[6], 8'd0, 8'd0};
						else {board[4], board[5], board[6], board[7]} <= {board[4]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[4] != 8'd0 && board[5] != 8'd0 && board[6] == 8'd0 && board[7] == 8'd0) begin
						if(board[4] != board[5]) {board[4], board[5], board[6], board[7]} <= {board[4], board[5], 8'd0, 8'd0};
						else {board[4], board[5], board[6], board[7]} <= {board[4]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[4] != 8'd0 && board[5] != 8'd0 && board[6] != 8'd0 && board[7] == 8'd0) begin
						if(board[4] == board[5]) {board[4], board[5], board[6], board[7]} <= {board[4]+8'd1, board[6], 8'd0, 8'd0};
						else if(board[5] == board[6]) {board[4], board[5], board[6], board[7]} <= {board[4], board[5]+8'd1, 8'd0, 8'd0};
						else {board[4], board[5], board[6], board[7]} <= {board[4], board[5], board[6], 8'd0};
					end
					else if(board[4] != 8'd0 && board[5] != 8'd0 && board[6] == 8'd0 && board[7] != 8'd0) begin
						if(board[4] == board[5]) {board[4], board[5], board[6], board[7]} <= {board[4]+8'd1, board[7], 8'd0, 8'd0};
						else if(board[5] == board[7]) {board[4], board[5], board[6], board[7]} <= {board[4], board[5]+8'd1, 8'd0, 8'd0};
						else {board[4], board[5], board[6], board[7]} <= {board[4], board[5], board[7], 8'd0};
					end
					else if(board[4] != 8'd0 && board[5] == 8'd0 && board[6] != 8'd0 && board[7] != 8'd0) begin
						if(board[4] == board[6]) {board[4], board[5], board[6], board[7]} <= {board[4]+8'd1, board[7], 8'd0, 8'd0};
						else if(board[6] == board[7]) {board[4], board[5], board[6], board[7]} <= {board[4], board[6]+8'd1, 8'd0, 8'd0};
						else {board[4], board[5], board[6], board[7]} <= {board[4], board[6], board[7], 8'd0};
					end
					else if(board[4] == 8'd0 && board[5] != 8'd0 && board[6] != 8'd0 && board[7] != 8'd0) begin
						if(board[5] == board[6]) {board[4], board[5], board[6], board[7]} <= {board[5]+8'd1, board[7], 8'd0, 8'd0};
						else if(board[6] == board[7]) {board[4], board[5], board[6], board[7]} <= {board[5], board[6]+8'd1, 8'd0, 8'd0};
						else {board[4], board[5], board[6], board[7]} <= {board[5], board[6], board[7], 8'd0};
					end
					else begin
						if(board[4] == board[5]) begin
							if(board[6] == board[7]) {board[4], board[5], board[6], board[7]} <= {board[4]+8'd1, board[6]+8'd1, 8'd0, 8'd0};
							else {board[4], board[5], board[6], board[7]} <= {board[4]+8'd1, board[6], board[7], 8'd0};
						end
						else begin
							if(board[5] == board[6]) {board[4], board[5], board[6], board[7]} <= {board[4], board[5]+8'd1, board[7], 8'd0};
							else if(board[6] == board[7]) {board[4], board[5], board[6], board[7]} <= {board[4], board[5], board[6]+8'd1, 8'd0};
							else {board[4], board[5], board[6], board[7]} <= {board[4], board[5], board[6], board[7]};
						end
					end
					
					if(board[8] == 8'd0 && board[9] == 8'd0 && board[10] == 8'd0 && board[11] == 8'd0) begin
						{board[8], board[9], board[10], board[11]} <= {8'd0, 8'd0, 8'd0, 8'd0};
					end
					else if(board[8] == 8'd0 && board[9] == 8'd0 && board[10] == 8'd0 && board[11] != 8'd0) begin
						{board[8], board[9], board[10], board[11]} <= {board[11], 8'd0, 8'd0, 8'd0};
					end
					else if(board[8] == 8'd0 && board[9] == 8'd0 && board[10] != 8'd0 && board[11] == 8'd0) begin
						{board[8], board[9], board[10], board[11]} <= {board[10], 8'd0, 8'd0, 8'd0};
					end
					else if(board[8] == 8'd0 && board[9] != 8'd0 && board[10] == 8'd0 && board[11] == 8'd0) begin
						{board[8], board[9], board[10], board[11]} <= {board[9], 8'd0, 8'd0, 8'd0};
					end
					else if(board[8] != 8'd0 && board[9] == 8'd0 && board[10] == 8'd0 && board[11] == 8'd0) begin
						{board[8], board[9], board[10], board[11]} <= {board[8], 8'd0, 8'd0, 8'd0};
					end
					else if(board[8] == 8'd0 && board[9] == 8'd0 && board[10] != 8'd0 && board[11] != 8'd0) begin
						if(board[10] != board[11]) {board[8], board[9], board[10], board[11]} <= {board[10], board[11], 8'd0, 8'd0};
						else {board[8], board[9], board[10], board[11]} <= {board[10]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[8] == 8'd0 && board[9] != 8'd0 && board[10] == 8'd0 && board[11] != 8'd0) begin
						if(board[9] != board[11]) {board[8], board[9], board[10], board[11]} <= {board[9], board[11], 8'd0, 8'd0};
						else {board[8], board[9], board[10], board[11]} <= {board[9]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[8] != 8'd0 && board[9] == 8'd0 && board[10] == 8'd0 && board[11] != 8'd0) begin
						if(board[8] != board[11]) {board[8], board[9], board[10], board[11]} <= {board[8], board[11], 8'd0, 8'd0};
						else {board[8], board[9], board[10], board[11]} <= {board[8]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[8] == 8'd0 && board[9] != 8'd0 && board[10] != 8'd0 && board[11] == 8'd0) begin
						if(board[9] != board[10]) {board[8], board[9], board[10], board[11]} <= {board[9], board[10], 8'd0, 8'd0};
						else {board[8], board[9], board[10], board[11]} <= {board[9]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[8] != 8'd0 && board[9] == 8'd0 && board[10] != 8'd0 && board[11] == 8'd0) begin
						if(board[8] != board[10]) {board[8], board[9], board[10], board[11]} <= {board[8], board[10], 8'd0, 8'd0};
						else {board[8], board[9], board[10], board[11]} <= {board[8]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[8] != 8'd0 && board[9] != 8'd0 && board[10] == 8'd0 && board[11] == 8'd0) begin
						if(board[8] != board[9]) {board[8], board[9], board[10], board[11]} <= {board[8], board[9], 8'd0, 8'd0};
						else {board[8], board[9], board[10], board[11]} <= {board[8]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[8] != 8'd0 && board[9] != 8'd0 && board[10] != 8'd0 && board[11] == 8'd0) begin
						if(board[8] == board[9]) {board[8], board[9], board[10], board[11]} <= {board[8]+8'd1, board[10], 8'd0, 8'd0};
						else if(board[9] == board[10]) {board[8], board[9], board[10], board[11]} <= {board[8], board[9]+8'd1, 8'd0, 8'd0};
						else {board[8], board[9], board[10], board[11]} <= {board[8], board[9], board[10], 8'd0};
					end
					else if(board[8] != 8'd0 && board[9] != 8'd0 && board[10] == 8'd0 && board[11] != 8'd0) begin
						if(board[8] == board[9]) {board[8], board[9], board[10], board[11]} <= {board[8]+8'd1, board[11], 8'd0, 8'd0};
						else if(board[9] == board[11]) {board[8], board[9], board[10], board[11]} <= {board[8], board[9]+8'd1, 8'd0, 8'd0};
						else {board[8], board[9], board[10], board[11]} <= {board[8], board[9], board[11], 8'd0};
					end
					else if(board[8] != 8'd0 && board[9] == 8'd0 && board[10] != 8'd0 && board[11] != 8'd0) begin
						if(board[8] == board[10]) {board[8], board[9], board[10], board[11]} <= {board[8]+8'd1, board[11], 8'd0, 8'd0};
						else if(board[10] == board[11]) {board[8], board[9], board[10], board[11]} <= {board[8], board[10]+8'd1, 8'd0, 8'd0};
						else {board[8], board[9], board[10], board[11]} <= {board[8], board[10], board[11], 8'd0};
					end
					else if(board[8] == 8'd0 && board[9] != 8'd0 && board[10] != 8'd0 && board[11] != 8'd0) begin
						if(board[9] == board[10]) {board[8], board[9], board[10], board[11]} <= {board[9]+8'd1, board[11], 8'd0, 8'd0};
						else if(board[10] == board[11]) {board[8], board[9], board[10], board[11]} <= {board[9], board[10]+8'd1, 8'd0, 8'd0};
						else {board[8], board[9], board[10], board[11]} <= {board[9], board[10], board[11], 8'd0};
					end
					else begin
						if(board[8] == board[9]) begin
							if(board[10] == board[11]) {board[8], board[9], board[10], board[11]} <= {board[8]+8'd1, board[10]+8'd1, 8'd0, 8'd0};
							else {board[8], board[9], board[10], board[11]} <= {board[8]+8'd1, board[10], board[11], 8'd0};
						end
						else begin
							if(board[9] == board[10]) {board[8], board[9], board[10], board[11]} <= {board[8], board[9]+8'd1, board[11], 8'd0};
							else if(board[10] == board[11]) {board[8], board[9], board[10], board[11]} <= {board[8], board[9], board[10]+8'd1, 8'd0};
							else {board[8], board[9], board[10], board[11]} <= {board[8], board[9], board[10], board[11]};
						end
					end
					
					if(board[12] == 8'd0 && board[13] == 8'd0 && board[14] == 8'd0 && board[15] == 8'd0) begin
						{board[12], board[13], board[14], board[15]} <= {8'd0, 8'd0, 8'd0, 8'd0};
					end
					else if(board[12] == 8'd0 && board[13] == 8'd0 && board[14] == 8'd0 && board[15] != 8'd0) begin
						{board[12], board[13], board[14], board[15]} <= {board[15], 8'd0, 8'd0, 8'd0};
					end
					else if(board[12] == 8'd0 && board[13] == 8'd0 && board[14] != 8'd0 && board[15] == 8'd0) begin
						{board[12], board[13], board[14], board[15]} <= {board[14], 8'd0, 8'd0, 8'd0};
					end
					else if(board[12] == 8'd0 && board[13] != 8'd0 && board[14] == 8'd0 && board[15] == 8'd0) begin
						{board[12], board[13], board[14], board[15]} <= {board[13], 8'd0, 8'd0, 8'd0};
					end
					else if(board[12] != 8'd0 && board[13] == 8'd0 && board[14] == 8'd0 && board[15] == 8'd0) begin
						{board[12], board[13], board[14], board[15]} <= {board[12], 8'd0, 8'd0, 8'd0};
					end
					else if(board[12] == 8'd0 && board[13] == 8'd0 && board[14] != 8'd0 && board[15] != 8'd0) begin
						if(board[14] != board[15]) {board[12], board[13], board[14], board[15]} <= {board[14], board[15], 8'd0, 8'd0};
						else {board[12], board[13], board[14], board[15]} <= {board[14]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[12] == 8'd0 && board[13] != 8'd0 && board[14] == 8'd0 && board[15] != 8'd0) begin
						if(board[13] != board[15]) {board[12], board[13], board[14], board[15]} <= {board[13], board[15], 8'd0, 8'd0};
						else {board[12], board[13], board[14], board[15]} <= {board[13]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[12] != 8'd0 && board[13] == 8'd0 && board[14] == 8'd0 && board[15] != 8'd0) begin
						if(board[12] != board[15]) {board[12], board[13], board[14], board[15]} <= {board[12], board[15], 8'd0, 8'd0};
						else {board[12], board[13], board[14], board[15]} <= {board[12]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[12] == 8'd0 && board[13] != 8'd0 && board[14] != 8'd0 && board[15] == 8'd0) begin
						if(board[13] != board[14]) {board[12], board[13], board[14], board[15]} <= {board[13], board[14], 8'd0, 8'd0};
						else {board[12], board[13], board[14], board[15]} <= {board[13]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[12] != 8'd0 && board[13] == 8'd0 && board[14] != 8'd0 && board[15] == 8'd0) begin
						if(board[12] != board[14]) {board[12], board[13], board[14], board[15]} <= {board[12], board[14], 8'd0, 8'd0};
						else {board[12], board[13], board[14], board[15]} <= {board[12]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[12] != 8'd0 && board[13] != 8'd0 && board[14] == 8'd0 && board[15] == 8'd0) begin
						if(board[12] != board[13]) {board[12], board[13], board[14], board[15]} <= {board[12], board[13], 8'd0, 8'd0};
						else {board[12], board[13], board[14], board[15]} <= {board[12]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[12] != 8'd0 && board[13] != 8'd0 && board[14] != 8'd0 && board[15] == 8'd0) begin
						if(board[12] == board[13]) {board[12], board[13], board[14], board[15]} <= {board[12]+8'd1, board[14], 8'd0, 8'd0};
						else if(board[13] == board[14]) {board[12], board[13], board[14], board[15]} <= {board[12], board[13]+8'd1, 8'd0, 8'd0};
						else {board[12], board[13], board[14], board[15]} <= {board[12], board[13], board[14], 8'd0};
					end
					else if(board[12] != 8'd0 && board[13] != 8'd0 && board[14] == 8'd0 && board[15] != 8'd0) begin
						if(board[12] == board[13]) {board[12], board[13], board[14], board[15]} <= {board[12]+8'd1, board[15], 8'd0, 8'd0};
						else if(board[13] == board[15]) {board[12], board[13], board[14], board[15]} <= {board[12], board[13]+8'd1, 8'd0, 8'd0};
						else {board[12], board[13], board[14], board[15]} <= {board[12], board[13], board[15], 8'd0};
					end
					else if(board[12] != 8'd0 && board[13] == 8'd0 && board[14] != 8'd0 && board[15] != 8'd0) begin
						if(board[12] == board[14]) {board[12], board[13], board[14], board[15]} <= {board[12]+8'd1, board[15], 8'd0, 8'd0};
						else if(board[14] == board[15]) {board[12], board[13], board[14], board[15]} <= {board[12], board[14]+8'd1, 8'd0, 8'd0};
						else {board[12], board[13], board[14], board[15]} <= {board[12], board[14], board[15], 8'd0};
					end
					else if(board[12] == 8'd0 && board[13] != 8'd0 && board[14] != 8'd0 && board[15] != 8'd0) begin
						if(board[13] == board[14]) {board[12], board[13], board[14], board[15]} <= {board[13]+8'd1, board[15], 8'd0, 8'd0};
						else if(board[14] == board[15]) {board[12], board[13], board[14], board[15]} <= {board[13], board[14]+8'd1, 8'd0, 8'd0};
						else {board[12], board[13], board[14], board[15]} <= {board[13], board[14], board[15], 8'd0};
					end
					else begin
						if(board[12] == board[13]) begin
							if(board[14] == board[15]) {board[12], board[13], board[14], board[15]} <= {board[12]+8'd1, board[14]+8'd1, 8'd0, 8'd0};
							else {board[12], board[13], board[14], board[15]} <= {board[12]+8'd1, board[14], board[15], 8'd0};
						end
						else begin
							if(board[13] == board[14]) {board[12], board[13], board[14], board[15]} <= {board[12], board[13]+8'd1, board[15], 8'd0};
							else if(board[14] == board[15]) {board[12], board[13], board[14], board[15]} <= {board[12], board[13], board[14]+8'd1, 8'd0};
							else {board[12], board[13], board[14], board[15]} <= {board[12], board[13], board[14], board[15]};
						end
					end
				end
				else if(!down && !activeflag) begin
					if(board[3] == 8'd0 && board[2] == 8'd0 && board[1] == 8'd0 && board[0] == 8'd0) begin
						{board[3], board[2], board[1], board[0]} <= {8'd0, 8'd0, 8'd0, 8'd0};
					end
					else if(board[3] == 8'd0 && board[2] == 8'd0 && board[1] == 8'd0 && board[0] != 8'd0) begin
						{board[3], board[2], board[1], board[0]} <= {board[0], 8'd0, 8'd0, 8'd0};
					end
					else if(board[3] == 8'd0 && board[2] == 8'd0 && board[1] != 8'd0 && board[0] == 8'd0) begin
						{board[3], board[2], board[1], board[0]} <= {board[1], 8'd0, 8'd0, 8'd0};
					end
					else if(board[3] == 8'd0 && board[2] != 8'd0 && board[1] == 8'd0 && board[0] == 8'd0) begin
						{board[3], board[2], board[1], board[0]} <= {board[2], 8'd0, 8'd0, 8'd0};
					end
					else if(board[3] != 8'd0 && board[2] == 8'd0 && board[1] == 8'd0 && board[0] == 8'd0) begin
						{board[3], board[2], board[1], board[0]} <= {board[3], 8'd0, 8'd0, 8'd0};
					end
					else if(board[3] == 8'd0 && board[2] == 8'd0 && board[1] != 8'd0 && board[0] != 8'd0) begin
						if(board[1] != board[0]) {board[3], board[2], board[1], board[0]} <= {board[1], board[0], 8'd0, 8'd0};
						else {board[3], board[2], board[1], board[0]} <= {board[1]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[3] == 8'd0 && board[2] != 8'd0 && board[1] == 8'd0 && board[0] != 8'd0) begin
						if(board[2] != board[0]) {board[3], board[2], board[1], board[0]} <= {board[2], board[0], 8'd0, 8'd0};
						else {board[3], board[2], board[1], board[0]} <= {board[2]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[3] != 8'd0 && board[2] == 8'd0 && board[1] == 8'd0 && board[0] != 8'd0) begin
						if(board[3] != board[0]) {board[3], board[2], board[1], board[0]} <= {board[3], board[0], 8'd0, 8'd0};
						else {board[3], board[2], board[1], board[0]} <= {board[3]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[3] == 8'd0 && board[2] != 8'd0 && board[1] != 8'd0 && board[0] == 8'd0) begin
						if(board[2] != board[1]) {board[3], board[2], board[1], board[0]} <= {board[2], board[1], 8'd0, 8'd0};
						else {board[3], board[2], board[1], board[0]} <= {board[2]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[3] != 8'd0 && board[2] == 8'd0 && board[1] != 8'd0 && board[0] == 8'd0) begin
						if(board[3] != board[1]) {board[3], board[2], board[1], board[0]} <= {board[3], board[1], 8'd0, 8'd0};
						else {board[3], board[2], board[1], board[0]} <= {board[3]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[3] != 8'd0 && board[2] != 8'd0 && board[1] == 8'd0 && board[0] == 8'd0) begin
						if(board[3] != board[2]) {board[3], board[2], board[1], board[0]} <= {board[3], board[2], 8'd0, 8'd0};
						else {board[3], board[2], board[1], board[0]} <= {board[3]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[3] != 8'd0 && board[2] != 8'd0 && board[1] != 8'd0 && board[0] == 8'd0) begin
						if(board[3] == board[2]) {board[3], board[2], board[1], board[0]} <= {board[3]+8'd1, board[1], 8'd0, 8'd0};
						else if(board[2] == board[1]) {board[3], board[2], board[1], board[0]} <= {board[3], board[2]+8'd1, 8'd0, 8'd0};
						else {board[3], board[2], board[1], board[0]} <= {board[3], board[2], board[1], 8'd0};
					end
					else if(board[3] != 8'd0 && board[2] != 8'd0 && board[1] == 8'd0 && board[0] != 8'd0) begin
						if(board[3] == board[2]) {board[3], board[2], board[1], board[0]} <= {board[3]+8'd1, board[0], 8'd0, 8'd0};
						else if(board[2] == board[0]) {board[3], board[2], board[1], board[0]} <= {board[3], board[2]+8'd1, 8'd0, 8'd0};
						else {board[3], board[2], board[1], board[0]} <= {board[3], board[2], board[0], 8'd0};
					end
					else if(board[3] != 8'd0 && board[2] == 8'd0 && board[1] != 8'd0 && board[0] != 8'd0) begin
						if(board[3] == board[1]) {board[3], board[2], board[1], board[0]} <= {board[3]+8'd1, board[0], 8'd0, 8'd0};
						else if(board[1] == board[0]) {board[3], board[2], board[1], board[0]} <= {board[3], board[1]+8'd1, 8'd0, 8'd0};
						else {board[3], board[2], board[1], board[0]} <= {board[3], board[1], board[0], 8'd0};
					end
					else if(board[3] == 8'd0 && board[2] != 8'd0 && board[1] != 8'd0 && board[0] != 8'd0) begin
						if(board[2] == board[1]) {board[3], board[2], board[1], board[0]} <= {board[2]+8'd1, board[0], 8'd0, 8'd0};
						else if(board[1] == board[0]) {board[3], board[2], board[1], board[0]} <= {board[2], board[1]+8'd1, 8'd0, 8'd0};
						else {board[3], board[2], board[1], board[0]} <= {board[2], board[1], board[0], 8'd0};
					end
					else begin
						if(board[3] == board[2]) begin
							if(board[1] == board[0]) {board[3], board[2], board[1], board[0]} <= {board[3]+8'd1, board[1]+8'd1, 8'd0, 8'd0};
							else {board[3], board[2], board[1], board[0]} <= {board[3]+8'd1, board[1], board[0], 8'd0};
						end
						else begin
							if(board[2] == board[1]) {board[3], board[2], board[1], board[0]} <= {board[3], board[2]+8'd1, board[0], 8'd0};
							else if(board[1] == board[0]) {board[3], board[2], board[1], board[0]} <= {board[3], board[2], board[1]+8'd1, 8'd0};
							else {board[3], board[2], board[1], board[0]} <= {board[3], board[2], board[1], board[0]};
						end
					end
					
					if(board[7] == 8'd0 && board[6] == 8'd0 && board[5] == 8'd0 && board[4] == 8'd0) begin
						{board[7], board[6], board[5], board[4]} <= {8'd0, 8'd0, 8'd0, 8'd0};
					end
					else if(board[7] == 8'd0 && board[6] == 8'd0 && board[5] == 8'd0 && board[4] != 8'd0) begin
						{board[7], board[6], board[5], board[4]} <= {board[4], 8'd0, 8'd0, 8'd0};
					end
					else if(board[7] == 8'd0 && board[6] == 8'd0 && board[5] != 8'd0 && board[4] == 8'd0) begin
						{board[7], board[6], board[5], board[4]} <= {board[5], 8'd0, 8'd0, 8'd0};
					end
					else if(board[7] == 8'd0 && board[6] != 8'd0 && board[5] == 8'd0 && board[4] == 8'd0) begin
						{board[7], board[6], board[5], board[4]} <= {board[6], 8'd0, 8'd0, 8'd0};
					end
					else if(board[7] != 8'd0 && board[6] == 8'd0 && board[5] == 8'd0 && board[4] == 8'd0) begin
						{board[7], board[6], board[5], board[4]} <= {board[7], 8'd0, 8'd0, 8'd0};
					end
					else if(board[7] == 8'd0 && board[6] == 8'd0 && board[5] != 8'd0 && board[4] != 8'd0) begin
						if(board[5] != board[4]) {board[7], board[6], board[5], board[4]} <= {board[5], board[4], 8'd0, 8'd0};
						else {board[7], board[6], board[5], board[4]} <= {board[5]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[7] == 8'd0 && board[6] != 8'd0 && board[5] == 8'd0 && board[4] != 8'd0) begin
						if(board[6] != board[4]) {board[7], board[6], board[5], board[4]} <= {board[6], board[4], 8'd0, 8'd0};
						else {board[7], board[6], board[5], board[4]} <= {board[6]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[7] != 8'd0 && board[6] == 8'd0 && board[5] == 8'd0 && board[4] != 8'd0) begin
						if(board[7] != board[4]) {board[7], board[6], board[5], board[4]} <= {board[7], board[4], 8'd0, 8'd0};
						else {board[7], board[6], board[5], board[4]} <= {board[7]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[7] == 8'd0 && board[6] != 8'd0 && board[5] != 8'd0 && board[4] == 8'd0) begin
						if(board[6] != board[5]) {board[7], board[6], board[5], board[4]} <= {board[6], board[5], 8'd0, 8'd0};
						else {board[7], board[6], board[5], board[4]} <= {board[6]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[7] != 8'd0 && board[6] == 8'd0 && board[5] != 8'd0 && board[4] == 8'd0) begin
						if(board[7] != board[5]) {board[7], board[6], board[5], board[4]} <= {board[7], board[5], 8'd0, 8'd0};
						else {board[7], board[6], board[5], board[4]} <= {board[7]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[7] != 8'd0 && board[6] != 8'd0 && board[5] == 8'd0 && board[4] == 8'd0) begin
						if(board[7] != board[6]) {board[7], board[6], board[5], board[4]} <= {board[7], board[6], 8'd0, 8'd0};
						else {board[7], board[6], board[5], board[4]} <= {board[7]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[7] != 8'd0 && board[6] != 8'd0 && board[5] != 8'd0 && board[4] == 8'd0) begin
						if(board[7] == board[6]) {board[7], board[6], board[5], board[4]} <= {board[7]+8'd1, board[5], 8'd0, 8'd0};
						else if(board[6] == board[5]) {board[7], board[6], board[5], board[4]} <= {board[7], board[6]+8'd1, 8'd0, 8'd0};
						else {board[7], board[6], board[5], board[4]} <= {board[7], board[6], board[5], 8'd0};
					end
					else if(board[7] != 8'd0 && board[6] != 8'd0 && board[5] == 8'd0 && board[4] != 8'd0) begin
						if(board[7] == board[6]) {board[7], board[6], board[5], board[4]} <= {board[7]+8'd1, board[4], 8'd0, 8'd0};
						else if(board[6] == board[4]) {board[7], board[6], board[5], board[4]} <= {board[7], board[6]+8'd1, 8'd0, 8'd0};
						else {board[7], board[6], board[5], board[4]} <= {board[7], board[6], board[4], 8'd0};
					end
					else if(board[7] != 8'd0 && board[6] == 8'd0 && board[5] != 8'd0 && board[4] != 8'd0) begin
						if(board[7] == board[5]) {board[7], board[6], board[5], board[4]} <= {board[7]+8'd1, board[4], 8'd0, 8'd0};
						else if(board[5] == board[4]) {board[7], board[6], board[5], board[4]} <= {board[7], board[5]+8'd1, 8'd0, 8'd0};
						else {board[7], board[6], board[5], board[4]} <= {board[7], board[5], board[4], 8'd0};
					end
					else if(board[7] == 8'd0 && board[6] != 8'd0 && board[5] != 8'd0 && board[4] != 8'd0) begin
						if(board[6] == board[5]) {board[7], board[6], board[5], board[4]} <= {board[6]+8'd1, board[4], 8'd0, 8'd0};
						else if(board[5] == board[4]) {board[7], board[6], board[5], board[4]} <= {board[6], board[5]+8'd1, 8'd0, 8'd0};
						else {board[7], board[6], board[5], board[4]} <= {board[6], board[5], board[4], 8'd0};
					end
					else begin
						if(board[7] == board[6]) begin
							if(board[5] == board[4]) {board[7], board[6], board[5], board[4]} <= {board[7]+8'd1, board[5]+8'd1, 8'd0, 8'd0};
							else {board[7], board[6], board[5], board[4]} <= {board[7]+8'd1, board[5], board[4], 8'd0};
						end
						else begin
							if(board[6] == board[5]) {board[7], board[6], board[5], board[4]} <= {board[7], board[6]+8'd1, board[4], 8'd0};
							else if(board[5] == board[4]) {board[7], board[6], board[5], board[4]} <= {board[7], board[6], board[5]+8'd1, 8'd0};
							else {board[7], board[6], board[5], board[4]} <= {board[7], board[6], board[5], board[4]};
						end
					end
					
					if(board[11] == 8'd0 && board[10] == 8'd0 && board[9] == 8'd0 && board[8] == 8'd0) begin
						{board[11], board[10], board[9], board[8]} <= {8'd0, 8'd0, 8'd0, 8'd0};
					end
					else if(board[11] == 8'd0 && board[10] == 8'd0 && board[9] == 8'd0 && board[8] != 8'd0) begin
						{board[11], board[10], board[9], board[8]} <= {board[8], 8'd0, 8'd0, 8'd0};
					end
					else if(board[11] == 8'd0 && board[10] == 8'd0 && board[9] != 8'd0 && board[8] == 8'd0) begin
						{board[11], board[10], board[9], board[8]} <= {board[9], 8'd0, 8'd0, 8'd0};
					end
					else if(board[11] == 8'd0 && board[10] != 8'd0 && board[9] == 8'd0 && board[8] == 8'd0) begin
						{board[11], board[10], board[9], board[8]} <= {board[10], 8'd0, 8'd0, 8'd0};
					end
					else if(board[11] != 8'd0 && board[10] == 8'd0 && board[9] == 8'd0 && board[8] == 8'd0) begin
						{board[11], board[10], board[9], board[8]} <= {board[11], 8'd0, 8'd0, 8'd0};
					end
					else if(board[11] == 8'd0 && board[10] == 8'd0 && board[9] != 8'd0 && board[8] != 8'd0) begin
						if(board[9] != board[8]) {board[11], board[10], board[9], board[8]} <= {board[9], board[8], 8'd0, 8'd0};
						else {board[11], board[10], board[9], board[8]} <= {board[9]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[11] == 8'd0 && board[10] != 8'd0 && board[9] == 8'd0 && board[8] != 8'd0) begin
						if(board[10] != board[8]) {board[11], board[10], board[9], board[8]} <= {board[10], board[8], 8'd0, 8'd0};
						else {board[11], board[10], board[9], board[8]} <= {board[10]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[11] != 8'd0 && board[10] == 8'd0 && board[9] == 8'd0 && board[8] != 8'd0) begin
						if(board[11] != board[8]) {board[11], board[10], board[9], board[8]} <= {board[11], board[8], 8'd0, 8'd0};
						else {board[11], board[10], board[9], board[8]} <= {board[11]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[11] == 8'd0 && board[10] != 8'd0 && board[9] != 8'd0 && board[8] == 8'd0) begin
						if(board[10] != board[9]) {board[11], board[10], board[9], board[8]} <= {board[10], board[9], 8'd0, 8'd0};
						else {board[11], board[10], board[9], board[8]} <= {board[10]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[11] != 8'd0 && board[10] == 8'd0 && board[9] != 8'd0 && board[8] == 8'd0) begin
						if(board[11] != board[9]) {board[11], board[10], board[9], board[8]} <= {board[11], board[9], 8'd0, 8'd0};
						else {board[11], board[10], board[9], board[8]} <= {board[11]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[11] != 8'd0 && board[10] != 8'd0 && board[9] == 8'd0 && board[8] == 8'd0) begin
						if(board[11] != board[10]) {board[11], board[10], board[9], board[8]} <= {board[11], board[10], 8'd0, 8'd0};
						else {board[11], board[10], board[9], board[8]} <= {board[11]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[11] != 8'd0 && board[10] != 8'd0 && board[9] != 8'd0 && board[8] == 8'd0) begin
						if(board[11] == board[10]) {board[11], board[10], board[9], board[8]} <= {board[11]+8'd1, board[9], 8'd0, 8'd0};
						else if(board[10] == board[9]) {board[11], board[10], board[9], board[8]} <= {board[11], board[10]+8'd1, 8'd0, 8'd0};
						else {board[11], board[10], board[9], board[8]} <= {board[11], board[10], board[9], 8'd0};
					end
					else if(board[11] != 8'd0 && board[10] != 8'd0 && board[9] == 8'd0 && board[8] != 8'd0) begin
						if(board[11] == board[10]) {board[11], board[10], board[9], board[8]} <= {board[11]+8'd1, board[8], 8'd0, 8'd0};
						else if(board[10] == board[8]) {board[11], board[10], board[9], board[8]} <= {board[11], board[10]+8'd1, 8'd0, 8'd0};
						else {board[11], board[10], board[9], board[8]} <= {board[11], board[10], board[8], 8'd0};
					end
					else if(board[11] != 8'd0 && board[10] == 8'd0 && board[9] != 8'd0 && board[8] != 8'd0) begin
						if(board[11] == board[9]) {board[11], board[10], board[9], board[8]} <= {board[11]+8'd1, board[8], 8'd0, 8'd0};
						else if(board[9] == board[8]) {board[11], board[10], board[9], board[8]} <= {board[11], board[9]+8'd1, 8'd0, 8'd0};
						else {board[11], board[10], board[9], board[8]} <= {board[11], board[9], board[8], 8'd0};
					end
					else if(board[11] == 8'd0 && board[10] != 8'd0 && board[9] != 8'd0 && board[8] != 8'd0) begin
						if(board[10] == board[9]) {board[11], board[10], board[9], board[8]} <= {board[10]+8'd1, board[8], 8'd0, 8'd0};
						else if(board[9] == board[8]) {board[11], board[10], board[9], board[8]} <= {board[10], board[9]+8'd1, 8'd0, 8'd0};
						else {board[11], board[10], board[9], board[8]} <= {board[10], board[9], board[8], 8'd0};
					end
					else begin
						if(board[11] == board[10]) begin
							if(board[9] == board[8]) {board[11], board[10], board[9], board[8]} <= {board[11]+8'd1, board[9]+8'd1, 8'd0, 8'd0};
							else {board[11], board[10], board[9], board[8]} <= {board[11]+8'd1, board[9], board[8], 8'd0};
						end
						else begin
							if(board[10] == board[9]) {board[11], board[10], board[9], board[8]} <= {board[11], board[10]+8'd1, board[8], 8'd0};
							else if(board[9] == board[8]) {board[11], board[10], board[9], board[8]} <= {board[11], board[10], board[9]+8'd1, 8'd0};
							else {board[11], board[10], board[9], board[8]} <= {board[11], board[10], board[9], board[8]};
						end
					end
					
					if(board[15] == 8'd0 && board[14] == 8'd0 && board[13] == 8'd0 && board[12] == 8'd0) begin
						{board[15], board[14], board[13], board[12]} <= {8'd0, 8'd0, 8'd0, 8'd0};
					end
					else if(board[15] == 8'd0 && board[14] == 8'd0 && board[13] == 8'd0 && board[12] != 8'd0) begin
						{board[15], board[14], board[13], board[12]} <= {board[12], 8'd0, 8'd0, 8'd0};
					end
					else if(board[15] == 8'd0 && board[14] == 8'd0 && board[13] != 8'd0 && board[12] == 8'd0) begin
						{board[15], board[14], board[13], board[12]} <= {board[13], 8'd0, 8'd0, 8'd0};
					end
					else if(board[15] == 8'd0 && board[14] != 8'd0 && board[13] == 8'd0 && board[12] == 8'd0) begin
						{board[15], board[14], board[13], board[12]} <= {board[14], 8'd0, 8'd0, 8'd0};
					end
					else if(board[15] != 8'd0 && board[14] == 8'd0 && board[13] == 8'd0 && board[12] == 8'd0) begin
						{board[15], board[14], board[13], board[12]} <= {board[15], 8'd0, 8'd0, 8'd0};
					end
					else if(board[15] == 8'd0 && board[14] == 8'd0 && board[13] != 8'd0 && board[12] != 8'd0) begin
						if(board[13] != board[12]) {board[15], board[14], board[13], board[12]} <= {board[13], board[12], 8'd0, 8'd0};
						else {board[15], board[14], board[13], board[12]} <= {board[13]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[15] == 8'd0 && board[14] != 8'd0 && board[13] == 8'd0 && board[12] != 8'd0) begin
						if(board[14] != board[12]) {board[15], board[14], board[13], board[12]} <= {board[14], board[12], 8'd0, 8'd0};
						else {board[15], board[14], board[13], board[12]} <= {board[14]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[15] != 8'd0 && board[14] == 8'd0 && board[13] == 8'd0 && board[12] != 8'd0) begin
						if(board[15] != board[12]) {board[15], board[14], board[13], board[12]} <= {board[15], board[12], 8'd0, 8'd0};
						else {board[15], board[14], board[13], board[12]} <= {board[15]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[15] == 8'd0 && board[14] != 8'd0 && board[13] != 8'd0 && board[12] == 8'd0) begin
						if(board[14] != board[13]) {board[15], board[14], board[13], board[12]} <= {board[14], board[13], 8'd0, 8'd0};
						else {board[15], board[14], board[13], board[12]} <= {board[14]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[15] != 8'd0 && board[14] == 8'd0 && board[13] != 8'd0 && board[12] == 8'd0) begin
						if(board[15] != board[13]) {board[15], board[14], board[13], board[12]} <= {board[15], board[13], 8'd0, 8'd0};
						else {board[15], board[14], board[13], board[12]} <= {board[15]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[15] != 8'd0 && board[14] != 8'd0 && board[13] == 8'd0 && board[12] == 8'd0) begin
						if(board[15] != board[14]) {board[15], board[14], board[13], board[12]} <= {board[15], board[14], 8'd0, 8'd0};
						else {board[15], board[14], board[13], board[12]} <= {board[15]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[15] != 8'd0 && board[14] != 8'd0 && board[13] != 8'd0 && board[12] == 8'd0) begin
						if(board[15] == board[14]) {board[15], board[14], board[13], board[12]} <= {board[15]+8'd1, board[13], 8'd0, 8'd0};
						else if(board[14] == board[13]) {board[15], board[14], board[13], board[12]} <= {board[15], board[14]+8'd1, 8'd0, 8'd0};
						else {board[15], board[14], board[13], board[12]} <= {board[15], board[14], board[13], 8'd0};
					end
					else if(board[15] != 8'd0 && board[14] != 8'd0 && board[13] == 8'd0 && board[12] != 8'd0) begin
						if(board[15] == board[14]) {board[15], board[14], board[13], board[12]} <= {board[15]+8'd1, board[12], 8'd0, 8'd0};
						else if(board[14] == board[12]) {board[15], board[14], board[13], board[12]} <= {board[15], board[14]+8'd1, 8'd0, 8'd0};
						else {board[15], board[14], board[13], board[12]} <= {board[15], board[14], board[12], 8'd0};
					end
					else if(board[15] != 8'd0 && board[14] == 8'd0 && board[13] != 8'd0 && board[12] != 8'd0) begin
						if(board[15] == board[13]) {board[15], board[14], board[13], board[12]} <= {board[15]+8'd1, board[12], 8'd0, 8'd0};
						else if(board[13] == board[12]) {board[15], board[14], board[13], board[12]} <= {board[15], board[13]+8'd1, 8'd0, 8'd0};
						else {board[15], board[14], board[13], board[12]} <= {board[15], board[13], board[12], 8'd0};
					end
					else if(board[15] == 8'd0 && board[14] != 8'd0 && board[13] != 8'd0 && board[12] != 8'd0) begin
						if(board[14] == board[13]) {board[15], board[14], board[13], board[12]} <= {board[14]+8'd1, board[12], 8'd0, 8'd0};
						else if(board[13] == board[12]) {board[15], board[14], board[13], board[12]} <= {board[14], board[13]+8'd1, 8'd0, 8'd0};
						else {board[15], board[14], board[13], board[12]} <= {board[14], board[13], board[12], 8'd0};
					end
					else begin
						if(board[15] == board[14]) begin
							if(board[13] == board[12]) {board[15], board[14], board[13], board[12]} <= {board[15]+8'd1, board[13]+8'd1, 8'd0, 8'd0};
							else {board[15], board[14], board[13], board[12]} <= {board[15]+8'd1, board[13], board[12], 8'd0};
						end
						else begin
							if(board[14] == board[13]) {board[15], board[14], board[13], board[12]} <= {board[15], board[14]+8'd1, board[12], 8'd0};
							else if(board[13] == board[12]) {board[15], board[14], board[13], board[12]} <= {board[15], board[14], board[13]+8'd1, 8'd0};
							else {board[15], board[14], board[13], board[12]} <= {board[15], board[14], board[13], board[12]};
						end
					end
				end
				else if(!right && !activeflag) begin
					if(board[12] == 8'd0 && board[8] == 8'd0 && board[4] == 8'd0 && board[0] == 8'd0) begin
						{board[12], board[8], board[4], board[0]} <= {8'd0, 8'd0, 8'd0, 8'd0};
					end
					else if(board[12] == 8'd0 && board[8] == 8'd0 && board[4] == 8'd0 && board[0] != 8'd0) begin
						{board[12], board[8], board[4], board[0]} <= {board[0], 8'd0, 8'd0, 8'd0};
					end
					else if(board[12] == 8'd0 && board[8] == 8'd0 && board[4] != 8'd0 && board[0] == 8'd0) begin
						{board[12], board[8], board[4], board[0]} <= {board[4], 8'd0, 8'd0, 8'd0};
					end
					else if(board[12] == 8'd0 && board[8] != 8'd0 && board[4] == 8'd0 && board[0] == 8'd0) begin
						{board[12], board[8], board[4], board[0]} <= {board[8], 8'd0, 8'd0, 8'd0};
					end
					else if(board[12] != 8'd0 && board[8] == 8'd0 && board[4] == 8'd0 && board[0] == 8'd0) begin
						{board[12], board[8], board[4], board[0]} <= {board[12], 8'd0, 8'd0, 8'd0};
					end
					else if(board[12] == 8'd0 && board[8] == 8'd0 && board[4] != 8'd0 && board[0] != 8'd0) begin
						if(board[4] != board[0]) {board[12], board[8], board[4], board[0]} <= {board[4], board[0], 8'd0, 8'd0};
						else {board[12], board[8], board[4], board[0]} <= {board[4]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[12] == 8'd0 && board[8] != 8'd0 && board[4] == 8'd0 && board[0] != 8'd0) begin
						if(board[8] != board[0]) {board[12], board[8], board[4], board[0]} <= {board[8], board[0], 8'd0, 8'd0};
						else {board[12], board[8], board[4], board[0]} <= {board[8]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[12] != 8'd0 && board[8] == 8'd0 && board[4] == 8'd0 && board[0] != 8'd0) begin
						if(board[12] != board[0]) {board[12], board[8], board[4], board[0]} <= {board[12], board[0], 8'd0, 8'd0};
						else {board[12], board[8], board[4], board[0]} <= {board[12]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[12] == 8'd0 && board[8] != 8'd0 && board[4] != 8'd0 && board[0] == 8'd0) begin
						if(board[8] != board[4]) {board[12], board[8], board[4], board[0]} <= {board[8], board[4], 8'd0, 8'd0};
						else {board[12], board[8], board[4], board[0]} <= {board[8]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[12] != 8'd0 && board[8] == 8'd0 && board[4] != 8'd0 && board[0] == 8'd0) begin
						if(board[12] != board[4]) {board[12], board[8], board[4], board[0]} <= {board[12], board[4], 8'd0, 8'd0};
						else {board[12], board[8], board[4], board[0]} <= {board[12]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[12] != 8'd0 && board[8] != 8'd0 && board[4] == 8'd0 && board[0] == 8'd0) begin
						if(board[12] != board[8]) {board[12], board[8], board[4], board[0]} <= {board[12], board[8], 8'd0, 8'd0};
						else {board[12], board[8], board[4], board[0]} <= {board[12]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[12] != 8'd0 && board[8] != 8'd0 && board[4] != 8'd0 && board[0] == 8'd0) begin
						if(board[12] == board[8]) {board[12], board[8], board[4], board[0]} <= {board[12]+8'd1, board[4], 8'd0, 8'd0};
						else if(board[8] == board[4]) {board[12], board[8], board[4], board[0]} <= {board[12], board[8]+8'd1, 8'd0, 8'd0};
						else {board[12], board[8], board[4], board[0]} <= {board[12], board[8], board[4], 8'd0};
					end
					else if(board[12] != 8'd0 && board[8] != 8'd0 && board[4] == 8'd0 && board[0] != 8'd0) begin
						if(board[12] == board[8]) {board[12], board[8], board[4], board[0]} <= {board[12]+8'd1, board[0], 8'd0, 8'd0};
						else if(board[8] == board[0]) {board[12], board[8], board[4], board[0]} <= {board[12], board[8]+8'd1, 8'd0, 8'd0};
						else {board[12], board[8], board[4], board[0]} <= {board[12], board[8], board[0], 8'd0};
					end
					else if(board[12] != 8'd0 && board[8] == 8'd0 && board[4] != 8'd0 && board[0] != 8'd0) begin
						if(board[12] == board[4]) {board[12], board[8], board[4], board[0]} <= {board[12]+8'd1, board[0], 8'd0, 8'd0};
						else if(board[4] == board[0]) {board[12], board[8], board[4], board[0]} <= {board[12], board[4]+8'd1, 8'd0, 8'd0};
						else {board[12], board[8], board[4], board[0]} <= {board[12], board[4], board[0], 8'd0};
					end
					else if(board[12] == 8'd0 && board[8] != 8'd0 && board[4] != 8'd0 && board[0] != 8'd0) begin
						if(board[8] == board[4]) {board[12], board[8], board[4], board[0]} <= {board[8]+8'd1, board[0], 8'd0, 8'd0};
						else if(board[4] == board[0]) {board[12], board[8], board[4], board[0]} <= {board[8], board[4]+8'd1, 8'd0, 8'd0};
						else {board[12], board[8], board[4], board[0]} <= {board[8], board[4], board[0], 8'd0};
					end
					else begin
						if(board[12] == board[8]) begin
							if(board[4] == board[0]) {board[12], board[8], board[4], board[0]} <= {board[12]+8'd1, board[4]+8'd1, 8'd0, 8'd0};
							else {board[12], board[8], board[4], board[0]} <= {board[12]+8'd1, board[4], board[0], 8'd0};
						end
						else begin
							if(board[8] == board[4]) {board[12], board[8], board[4], board[0]} <= {board[12], board[8]+8'd1, board[0], 8'd0};
							else if(board[4] == board[0]) {board[12], board[8], board[4], board[0]} <= {board[12], board[8], board[4]+8'd1, 8'd0};
							else {board[12], board[8], board[4], board[0]} <= {board[12], board[8], board[4], board[0]};
						end
					end
					
					if(board[13] == 8'd0 && board[9] == 8'd0 && board[5] == 8'd0 && board[1] == 8'd0) begin
						{board[13], board[9], board[5], board[1]} <= {8'd0, 8'd0, 8'd0, 8'd0};
					end
					else if(board[13] == 8'd0 && board[9] == 8'd0 && board[5] == 8'd0 && board[1] != 8'd0) begin
						{board[13], board[9], board[5], board[1]} <= {board[1], 8'd0, 8'd0, 8'd0};
					end
					else if(board[13] == 8'd0 && board[9] == 8'd0 && board[5] != 8'd0 && board[1] == 8'd0) begin
						{board[13], board[9], board[5], board[1]} <= {board[5], 8'd0, 8'd0, 8'd0};
					end
					else if(board[13] == 8'd0 && board[9] != 8'd0 && board[5] == 8'd0 && board[1] == 8'd0) begin
						{board[13], board[9], board[5], board[1]} <= {board[9], 8'd0, 8'd0, 8'd0};
					end
					else if(board[13] != 8'd0 && board[9] == 8'd0 && board[5] == 8'd0 && board[1] == 8'd0) begin
						{board[13], board[9], board[5], board[1]} <= {board[13], 8'd0, 8'd0, 8'd0};
					end
					else if(board[13] == 8'd0 && board[9] == 8'd0 && board[5] != 8'd0 && board[1] != 8'd0) begin
						if(board[5] != board[1]) {board[13], board[9], board[5], board[1]} <= {board[5], board[1], 8'd0, 8'd0};
						else {board[13], board[9], board[5], board[1]} <= {board[5]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[13] == 8'd0 && board[9] != 8'd0 && board[5] == 8'd0 && board[1] != 8'd0) begin
						if(board[9] != board[1]) {board[13], board[9], board[5], board[1]} <= {board[9], board[1], 8'd0, 8'd0};
						else {board[13], board[9], board[5], board[1]} <= {board[9]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[13] != 8'd0 && board[9] == 8'd0 && board[5] == 8'd0 && board[1] != 8'd0) begin
						if(board[13] != board[1]) {board[13], board[9], board[5], board[1]} <= {board[13], board[1], 8'd0, 8'd0};
						else {board[13], board[9], board[5], board[1]} <= {board[13]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[13] == 8'd0 && board[9] != 8'd0 && board[5] != 8'd0 && board[1] == 8'd0) begin
						if(board[9] != board[5]) {board[13], board[9], board[5], board[1]} <= {board[9], board[5], 8'd0, 8'd0};
						else {board[13], board[9], board[5], board[1]} <= {board[9]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[13] != 8'd0 && board[9] == 8'd0 && board[5] != 8'd0 && board[1] == 8'd0) begin
						if(board[13] != board[5]) {board[13], board[9], board[5], board[1]} <= {board[13], board[5], 8'd0, 8'd0};
						else {board[13], board[9], board[5], board[1]} <= {board[13]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[13] != 8'd0 && board[9] != 8'd0 && board[5] == 8'd0 && board[1] == 8'd0) begin
						if(board[13] != board[9]) {board[13], board[9], board[5], board[1]} <= {board[13], board[9], 8'd0, 8'd0};
						else {board[13], board[9], board[5], board[1]} <= {board[13]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[13] != 8'd0 && board[9] != 8'd0 && board[5] != 8'd0 && board[1] == 8'd0) begin
						if(board[13] == board[9]) {board[13], board[9], board[5], board[1]} <= {board[13]+8'd1, board[5], 8'd0, 8'd0};
						else if(board[9] == board[5]) {board[13], board[9], board[5], board[1]} <= {board[13], board[9]+8'd1, 8'd0, 8'd0};
						else {board[13], board[9], board[5], board[1]} <= {board[13], board[9], board[5], 8'd0};
					end
					else if(board[13] != 8'd0 && board[9] != 8'd0 && board[5] == 8'd0 && board[1] != 8'd0) begin
						if(board[13] == board[9]) {board[13], board[9], board[5], board[1]} <= {board[13]+8'd1, board[1], 8'd0, 8'd0};
						else if(board[9] == board[1]) {board[13], board[9], board[5], board[1]} <= {board[13], board[9]+8'd1, 8'd0, 8'd0};
						else {board[13], board[9], board[5], board[1]} <= {board[13], board[9], board[1], 8'd0};
					end
					else if(board[13] != 8'd0 && board[9] == 8'd0 && board[5] != 8'd0 && board[1] != 8'd0) begin
						if(board[13] == board[5]) {board[13], board[9], board[5], board[1]} <= {board[13]+8'd1, board[1], 8'd0, 8'd0};
						else if(board[5] == board[1]) {board[13], board[9], board[5], board[1]} <= {board[13], board[5]+8'd1, 8'd0, 8'd0};
						else {board[13], board[9], board[5], board[1]} <= {board[13], board[5], board[1], 8'd0};
					end
					else if(board[13] == 8'd0 && board[9] != 8'd0 && board[5] != 8'd0 && board[1] != 8'd0) begin
						if(board[9] == board[5]) {board[13], board[9], board[5], board[1]} <= {board[9]+8'd1, board[1], 8'd0, 8'd0};
						else if(board[5] == board[1]) {board[13], board[9], board[5], board[1]} <= {board[9], board[5]+8'd1, 8'd0, 8'd0};
						else {board[13], board[9], board[5], board[1]} <= {board[9], board[5], board[1], 8'd0};
					end
					else begin
						if(board[13] == board[9]) begin
							if(board[5] == board[1]) {board[13], board[9], board[5], board[1]} <= {board[13]+8'd1, board[5]+8'd1, 8'd0, 8'd0};
							else {board[13], board[9], board[5], board[1]} <= {board[13]+8'd1, board[5], board[1], 8'd0};
						end
						else begin
							if(board[9] == board[5]) {board[13], board[9], board[5], board[1]} <= {board[13], board[9]+8'd1, board[1], 8'd0};
							else if(board[5] == board[1]) {board[13], board[9], board[5], board[1]} <= {board[13], board[9], board[5]+8'd1, 8'd0};
							else {board[13], board[9], board[5], board[1]} <= {board[13], board[9], board[5], board[1]};
						end
					end
					
					if(board[14] == 8'd0 && board[10] == 8'd0 && board[6] == 8'd0 && board[2] == 8'd0) begin
						{board[14], board[10], board[6], board[2]} <= {8'd0, 8'd0, 8'd0, 8'd0};
					end
					else if(board[14] == 8'd0 && board[10] == 8'd0 && board[6] == 8'd0 && board[2] != 8'd0) begin
						{board[14], board[10], board[6], board[2]} <= {board[2], 8'd0, 8'd0, 8'd0};
					end
					else if(board[14] == 8'd0 && board[10] == 8'd0 && board[6] != 8'd0 && board[2] == 8'd0) begin
						{board[14], board[10], board[6], board[2]} <= {board[6], 8'd0, 8'd0, 8'd0};
					end
					else if(board[14] == 8'd0 && board[10] != 8'd0 && board[6] == 8'd0 && board[2] == 8'd0) begin
						{board[14], board[10], board[6], board[2]} <= {board[10], 8'd0, 8'd0, 8'd0};
					end
					else if(board[14] != 8'd0 && board[10] == 8'd0 && board[6] == 8'd0 && board[2] == 8'd0) begin
						{board[14], board[10], board[6], board[2]} <= {board[14], 8'd0, 8'd0, 8'd0};
					end
					else if(board[14] == 8'd0 && board[10] == 8'd0 && board[6] != 8'd0 && board[2] != 8'd0) begin
						if(board[6] != board[2]) {board[14], board[10], board[6], board[2]} <= {board[6], board[2], 8'd0, 8'd0};
						else {board[14], board[10], board[6], board[2]} <= {board[6]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[14] == 8'd0 && board[10] != 8'd0 && board[6] == 8'd0 && board[2] != 8'd0) begin
						if(board[10] != board[2]) {board[14], board[10], board[6], board[2]} <= {board[10], board[2], 8'd0, 8'd0};
						else {board[14], board[10], board[6], board[2]} <= {board[10]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[14] != 8'd0 && board[10] == 8'd0 && board[6] == 8'd0 && board[2] != 8'd0) begin
						if(board[14] != board[2]) {board[14], board[10], board[6], board[2]} <= {board[14], board[2], 8'd0, 8'd0};
						else {board[14], board[10], board[6], board[2]} <= {board[14]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[14] == 8'd0 && board[10] != 8'd0 && board[6] != 8'd0 && board[2] == 8'd0) begin
						if(board[10] != board[6]) {board[14], board[10], board[6], board[2]} <= {board[10], board[6], 8'd0, 8'd0};
						else {board[14], board[10], board[6], board[2]} <= {board[10]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[14] != 8'd0 && board[10] == 8'd0 && board[6] != 8'd0 && board[2] == 8'd0) begin
						if(board[14] != board[6]) {board[14], board[10], board[6], board[2]} <= {board[14], board[6], 8'd0, 8'd0};
						else {board[14], board[10], board[6], board[2]} <= {board[14]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[14] != 8'd0 && board[10] != 8'd0 && board[6] == 8'd0 && board[2] == 8'd0) begin
						if(board[14] != board[10]) {board[14], board[10], board[6], board[2]} <= {board[14], board[10], 8'd0, 8'd0};
						else {board[14], board[10], board[6], board[2]} <= {board[14]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[14] != 8'd0 && board[10] != 8'd0 && board[6] != 8'd0 && board[2] == 8'd0) begin
						if(board[14] == board[10]) {board[14], board[10], board[6], board[2]} <= {board[14]+8'd1, board[6], 8'd0, 8'd0};
						else if(board[10] == board[6]) {board[14], board[10], board[6], board[2]} <= {board[14], board[10]+8'd1, 8'd0, 8'd0};
						else {board[14], board[10], board[6], board[2]} <= {board[14], board[10], board[6], 8'd0};
					end
					else if(board[14] != 8'd0 && board[10] != 8'd0 && board[6] == 8'd0 && board[2] != 8'd0) begin
						if(board[14] == board[10]) {board[14], board[10], board[6], board[2]} <= {board[14]+8'd1, board[2], 8'd0, 8'd0};
						else if(board[10] == board[2]) {board[14], board[10], board[6], board[2]} <= {board[14], board[10]+8'd1, 8'd0, 8'd0};
						else {board[14], board[10], board[6], board[2]} <= {board[14], board[10], board[2], 8'd0};
					end
					else if(board[14] != 8'd0 && board[10] == 8'd0 && board[6] != 8'd0 && board[2] != 8'd0) begin
						if(board[14] == board[6]) {board[14], board[10], board[6], board[2]} <= {board[14]+8'd1, board[2], 8'd0, 8'd0};
						else if(board[6] == board[2]) {board[14], board[10], board[6], board[2]} <= {board[14], board[6]+8'd1, 8'd0, 8'd0};
						else {board[14], board[10], board[6], board[2]} <= {board[14], board[6], board[2], 8'd0};
					end
					else if(board[14] == 8'd0 && board[10] != 8'd0 && board[6] != 8'd0 && board[2] != 8'd0) begin
						if(board[10] == board[6]) {board[14], board[10], board[6], board[2]} <= {board[10]+8'd1, board[2], 8'd0, 8'd0};
						else if(board[6] == board[2]) {board[14], board[10], board[6], board[2]} <= {board[10], board[6]+8'd1, 8'd0, 8'd0};
						else {board[14], board[10], board[6], board[2]} <= {board[10], board[6], board[2], 8'd0};
					end
					else begin
						if(board[14] == board[10]) begin
							if(board[6] == board[2]) {board[14], board[10], board[6], board[2]} <= {board[14]+8'd1, board[6]+8'd1, 8'd0, 8'd0};
							else {board[14], board[10], board[6], board[2]} <= {board[14]+8'd1, board[6], board[2], 8'd0};
						end
						else begin
							if(board[10] == board[6]) {board[14], board[10], board[6], board[2]} <= {board[14], board[10]+8'd1, board[2], 8'd0};
							else if(board[6] == board[2]) {board[14], board[10], board[6], board[2]} <= {board[14], board[10], board[6]+8'd1, 8'd0};
							else {board[14], board[10], board[6], board[2]} <= {board[14], board[10], board[6], board[2]};
						end
					end
					
					if(board[15] == 8'd0 && board[11] == 8'd0 && board[7] == 8'd0 && board[3] == 8'd0) begin
						{board[15], board[11], board[7], board[3]} <= {8'd0, 8'd0, 8'd0, 8'd0};
					end
					else if(board[15] == 8'd0 && board[11] == 8'd0 && board[7] == 8'd0 && board[3] != 8'd0) begin
						{board[15], board[11], board[7], board[3]} <= {board[3], 8'd0, 8'd0, 8'd0};
					end
					else if(board[15] == 8'd0 && board[11] == 8'd0 && board[7] != 8'd0 && board[3] == 8'd0) begin
						{board[15], board[11], board[7], board[3]} <= {board[7], 8'd0, 8'd0, 8'd0};
					end
					else if(board[15] == 8'd0 && board[11] != 8'd0 && board[7] == 8'd0 && board[3] == 8'd0) begin
						{board[15], board[11], board[7], board[3]} <= {board[11], 8'd0, 8'd0, 8'd0};
					end
					else if(board[15] != 8'd0 && board[11] == 8'd0 && board[7] == 8'd0 && board[3] == 8'd0) begin
						{board[15], board[11], board[7], board[3]} <= {board[15], 8'd0, 8'd0, 8'd0};
					end
					else if(board[15] == 8'd0 && board[11] == 8'd0 && board[7] != 8'd0 && board[3] != 8'd0) begin
						if(board[7] != board[3]) {board[15], board[11], board[7], board[3]} <= {board[7], board[3], 8'd0, 8'd0};
						else {board[15], board[11], board[7], board[3]} <= {board[7]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[15] == 8'd0 && board[11] != 8'd0 && board[7] == 8'd0 && board[3] != 8'd0) begin
						if(board[11] != board[3]) {board[15], board[11], board[7], board[3]} <= {board[11], board[3], 8'd0, 8'd0};
						else {board[15], board[11], board[7], board[3]} <= {board[11]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[15] != 8'd0 && board[11] == 8'd0 && board[7] == 8'd0 && board[3] != 8'd0) begin
						if(board[15] != board[3]) {board[15], board[11], board[7], board[3]} <= {board[15], board[3], 8'd0, 8'd0};
						else {board[15], board[11], board[7], board[3]} <= {board[15]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[15] == 8'd0 && board[11] != 8'd0 && board[7] != 8'd0 && board[3] == 8'd0) begin
						if(board[11] != board[7]) {board[15], board[11], board[7], board[3]} <= {board[11], board[7], 8'd0, 8'd0};
						else {board[15], board[11], board[7], board[3]} <= {board[11]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[15] != 8'd0 && board[11] == 8'd0 && board[7] != 8'd0 && board[3] == 8'd0) begin
						if(board[15] != board[7]) {board[15], board[11], board[7], board[3]} <= {board[15], board[7], 8'd0, 8'd0};
						else {board[15], board[11], board[7], board[3]} <= {board[15]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[15] != 8'd0 && board[11] != 8'd0 && board[7] == 8'd0 && board[3] == 8'd0) begin
						if(board[15] != board[11]) {board[15], board[11], board[7], board[3]} <= {board[15], board[11], 8'd0, 8'd0};
						else {board[15], board[11], board[7], board[3]} <= {board[15]+8'd1, 8'd0, 8'd0, 8'd0};
					end
					else if(board[15] != 8'd0 && board[11] != 8'd0 && board[7] != 8'd0 && board[3] == 8'd0) begin
						if(board[15] == board[11]) {board[15], board[11], board[7], board[3]} <= {board[15]+8'd1, board[7], 8'd0, 8'd0};
						else if(board[11] == board[7]) {board[15], board[11], board[7], board[3]} <= {board[15], board[11]+8'd1, 8'd0, 8'd0};
						else {board[15], board[11], board[7], board[3]} <= {board[15], board[11], board[7], 8'd0};
					end
					else if(board[15] != 8'd0 && board[11] != 8'd0 && board[7] == 8'd0 && board[3] != 8'd0) begin
						if(board[15] == board[11]) {board[15], board[11], board[7], board[3]} <= {board[15]+8'd1, board[3], 8'd0, 8'd0};
						else if(board[11] == board[3]) {board[15], board[11], board[7], board[3]} <= {board[15], board[11]+8'd1, 8'd0, 8'd0};
						else {board[15], board[11], board[7], board[3]} <= {board[15], board[11], board[3], 8'd0};
					end
					else if(board[15] != 8'd0 && board[11] == 8'd0 && board[7] != 8'd0 && board[3] != 8'd0) begin
						if(board[15] == board[7]) {board[15], board[11], board[7], board[3]} <= {board[15]+8'd1, board[3], 8'd0, 8'd0};
						else if(board[7] == board[3]) {board[15], board[11], board[7], board[3]} <= {board[15], board[7]+8'd1, 8'd0, 8'd0};
						else {board[15], board[11], board[7], board[3]} <= {board[15], board[7], board[3], 8'd0};
					end
					else if(board[15] == 8'd0 && board[11] != 8'd0 && board[7] != 8'd0 && board[3] != 8'd0) begin
						if(board[11] == board[7]) {board[15], board[11], board[7], board[3]} <= {board[11]+8'd1, board[3], 8'd0, 8'd0};
						else if(board[7] == board[3]) {board[15], board[11], board[7], board[3]} <= {board[11], board[7]+8'd1, 8'd0, 8'd0};
						else {board[15], board[11], board[7], board[3]} <= {board[11], board[7], board[3], 8'd0};
					end
					else begin
						if(board[15] == board[11]) begin
							if(board[7] == board[3]) {board[15], board[11], board[7], board[3]} <= {board[15]+8'd1, board[7]+8'd1, 8'd0, 8'd0};
							else {board[15], board[11], board[7], board[3]} <= {board[15]+8'd1, board[7], board[3], 8'd0};
						end
						else begin
							if(board[11] == board[7]) {board[15], board[11], board[7], board[3]} <= {board[15], board[11]+8'd1, board[3], 8'd0};
							else if(board[7] == board[3]) {board[15], board[11], board[7], board[3]} <= {board[15], board[11], board[7]+8'd1, 8'd0};
							else {board[15], board[11], board[7], board[3]} <= {board[15], board[11], board[7], board[3]};
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
