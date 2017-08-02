module top(keyin, red, green, blue, hsync, vsync, CLK, RST);
	input CLK, RST;
	input [4:0] keyin;
	output red, green, blue, hsync, vsync;
	wire r, g, b, vnotactive;
	wire [9:0] row, col;
	
	mainvga vga(.red(red),.green(green),.blue(blue),.hsync(hsync),.vsync(vsync),.rin(r),.gin(g),.bin(b),.row(row),.col(col),.vnotactive(vnotactive),.CLK(CLK),.RST(RST));
	display display(.red(r),.green(g),.blue(b),.row(row),.col(col),.vnotactive(vnotactive),.color(keyin[0]),.up(keyin[1]),.down(keyin[2]),.left(keyin[3]),.right(keyin[4]),.CLK(CLK),.RST(RST));
	chattering_remover cr(.key_in(keyin),.clk(CLK),.rst(RST));
endmodule
