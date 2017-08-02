`define SSTART  2'b0
`define SCHAT   2'b1
`define SPUSH  2'b10

/*
 * main module for VGA
 */
module mainvga(red,green,blue,vsync,hsync,vnotactive,rin,gin,bin,col,row,CLK,RST);
	input CLK;
	input RST;
	
	// VGA
	input  rin;
	input  gin;
	input  bin;
	output red;
	output green;
	output blue;
	output vsync;
	output hsync;
	output vnotactive;
	output [9:0] col;
	output [9:0] row;

	// definitions
	reg red;
	reg green;
	reg blue;
	reg vsync;
	reg hsync;
	
	wire hsync0;
	wire vsync0;				 	
	wire [10:0] col0;
	wire [9:0]  row0;
	wire hstart0;
	wire vstart0;
	wire active0;
	wire vnotactive0;

	assign vnotactive = vnotactive0;
	assign col = col0[9:0];
	assign row = row0;
	
	sync sync0(hsync0,vsync0,col0,row0,active0,vnotactive0,hstart0,vstart0,CLK,RST); 

	/*
 	* output HSync/VSync and RGB data
 	*/
	always @(posedge CLK or negedge RST) begin
		if(!RST) begin
			red   <= 0;
			green <= 0;
			blue  <= 0;
		end 
		else begin
			hsync <= hsync0;
    		vsync <= vsync0;
			if(active0) begin
				red <= rin;
				green <= gin;
				blue <= bin;
			end else begin
				red <= 0;
				green <= 0;
				blue <= 0;
			end
		end
	end
endmodule
