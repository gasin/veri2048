module top(keyin, red, green, blue, hsync, vsync, CLK, RST);
	input CLK, RST;
	input [5:0] keyin;
	output red, green, blue, hsync, vsync;
	wire r, g, b, vnotactive;
	wire [9:0] row, col;
	wire [5:0] keyout;
	
	mainvga vga(.red(red),.green(green),.blue(blue),.hsync(hsync),.vsync(vsync),.rin(r),.gin(g),.bin(b),.row(row),.col(col),.vnotactive(vnotactive),.CLK(CLK),.RST(RST));
	display display(.red(r),.green(g),.blue(b),.row(row),.col(col),.vnotactive(vnotactive),.speed(keyout[0]),.up(keyout[1]),.down(keyout[2]),.left(keyout[3]),.right(keyout[4]),.missile(keyout[5]),.CLK(CLK),.RST(RST));
	chattering_remover cr(.keyin(keyin),.clk(CLK),.rst(RST),.keyout(keyout));
endmodule
