`timescale 1ns/1ns
/*
	Testbench for Intellec-4
*/
module intellec4_tb();
	reg clk = 1'b0;
	wire phi1;
	wire phi2;

	always
		#(96) clk <= !clk;

	mcs40_clk_gen generator(.clk_i(clk),.PHI1_o(phi1),.PHI2_o(phi2));

	initial
	begin
		$dumpfile("intellec4_tb.vcd");
		$dumpvars(0, intellec4_tb);
		#2500
		$finish;
	end
endmodule
