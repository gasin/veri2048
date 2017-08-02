`define CELL_SIZE 100
`define BORDER_WIDTH 15

module display(row, col, red, green, blue, color, up, down, left, right, vnotactive, CLK, RST);
	input [31:0] row, col;
	input CLK, RST, color, up, down, left, right, vnotactive;
	output red, green, blue;
	reg red, green, blue;
	//reg [31:0] originX, originY;
	
	always @(posedge CLK or negedge RST) begin
		if(!RST) begin
			red <= 1'b1;
			green <= 1'b1;
			blue <= 1'b1;
		end
		else begin
			if(row >= CELL_SIZE-BORDER_WIDTH && row <= CELL_SIZE+BORDER_WIDTH) begin
				red <= 1'b0;
				green <= 1'b0;
				blue <= 1'b0;
			end
			else if(row >= CELL_SIZE*2-BORDER_WIDTH && row <= CELL_SIZE*2+BORDER_WIDTH) begin
				red <= 1'b0;
				green <= 1'b0;
				blue <= 1'b0;
			end
			else if(row >= CELL_SIZE*3-BORDER_WIDTH && row <= CELL_SIZE*2+BORDER_SIZE) begin
				red <= 1'b0;
				green <= 1'b0;
				blue <= 1'b0;
			end
			else if(row >= CELL_SIZE*4-BORDER_WIDTH && row <= CELL_SIZE*4+BORDER_SIZE) begin
				red <= 1'b0;
				green <= 1'b0;
				blue <= 1'b0;
			end
			else if(row >= CELL_SIZE*5-BORDER_WIDTH && row <= CELL_SIZE*5+BORDER_SIZE) begin
				red <= 1'b0;
				green <= 1'b0;
				blue <= 1'b0;
			end
			else if(col >= CELL_SIZE-BORDER_WIDTH && col <= CELL_SIZE+BORDER_WIDTH) begin
				red <= 1'b0;
				green <= 1'b0;
				blue <= 1'b0;
			end
			else if(col >= CELL_SIZE*2-BORDER_WIDTH && col <= CELL_SIZE*2+BORDER_WIDTH) begin
				red <= 1'b0;
				green <= 1'b0;
				blue <= 1'b0;
			end
			else if(col >= CELL_SIZE*3-BORDER_WIDTH && col <= CELL_SIZE*2+BORDER_SIZE) begin
				red <= 1'b0;
				green <= 1'b0;
				blue <= 1'b0;
			end
			else if(col >= CELL_SIZE*4-BORDER_WIDTH && col <= CELL_SIZE*4+BORDER_SIZE) begin
				red <= 1'b0;
				green <= 1'b0;
				blue <= 1'b0;
			end
			else if(col >= CELL_SIZE*5-BORDER_WIDTH && col <= CELL_SIZE*5+BORDER_SIZE) begin
				red <= 1'b0;
				green <= 1'b0;
				blue <= 1'b0;
			end
			else begin
				red <= 1'b1;
				green <= 1'b1;
				blue <= 1'b1;
			end
		end
	end
	
	/*
	always @(posedge CLK or negedge RST) begin
		if(!RST) begin
		end
		else begin
		end
	end
	*/
endmodule
