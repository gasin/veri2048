
module divider(clk, rst, clkout);
	input clk, rst;
	output clkout;
	
	reg [7:0] counter;
	
	always @(posedge clk or negedge rst) begin
		if(!rst) counter <= 8'b0;
		else counter <= counter + 8'b1;
	end
	
	assign clkout = counter[7];
endmodule

module chattering_remover(clk, rst, keyin, keyout);
	input clk, rst;
	input [4:0] keyin;
	output reg [4:0] keyout;
	
	always @(posedge clk_divided) keyout <= keyin;
	
	divider div(clk, rst, clk_divided);
endmodule

