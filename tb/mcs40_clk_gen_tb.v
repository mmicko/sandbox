`timescale 1ns/1ns
/*
	Testbench for MCS-40 clock generator
*/
module mcs40_clk_gen_tb();
	reg clk = 1'b0;
	wire phi1;
	wire phi2;

	always
		#(96) clk <= !clk;

	mcs40_clk_gen_tb generator(.clk_i(clk),.PHI1_o(phi1),.PHI2_o(phi2));

	initial
	begin
		$dumpfile("mcs40_clk_gen_tb.vcd");
		$dumpvars(0, mcs40_clk_gen_tb);
		#2500
		$finish;
	end
endmodule
