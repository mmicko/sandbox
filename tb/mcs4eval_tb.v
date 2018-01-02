`timescale 1ns/1ns
/*
	Testbench for MCS-4 Evaluation board
*/
module mcs4eval_tb();
	reg clk = 1'b0;
	wire phi1;
	wire phi2;

	always
		#(96) clk <= !clk;

	i4001 #(.ROM_FILENAME("build/roms/mcs4eval.mem")) rom(.clk_i(clk),.PHI1_i(phi1),.PHI2_i(phi2));

	mcs4_clk_gen generator(.clk_i(clk),.PHI1_o(phi1),.PHI2_o(phi2));

	initial
	begin
		$dumpfile("mcs4eval_tb.vcd");
		$dumpvars(0, mcs4eval_tb);
		#2500
		$finish;
	end
endmodule
