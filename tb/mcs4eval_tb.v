`timescale 1ns/1ns
/*
	Testbench for MCS-4 Evaluation board
*/
module mcs4eval_tb();
	reg clk = 1'b0;
	wire phi1;
	wire phi2;
	wire sync;
	wire cm_rom;

	wire [3:0] data_bus;

	always
		#(96) clk <= !clk;

	i4001 #(.ROM_FILENAME("build/roms/mcs4eval.mem")) rom(.clk_i(clk),.PHI1_i(phi1),.PHI2_i(phi2),.SYNC_i(sync),.D_io(data_bus),.CM_i(cm_rom));
	
	i4002 ram_0(.clk_i(clk),.PHI1_i(phi1),.PHI2_i(phi2),.SYNC_i(sync),.D_io(data_bus),.CM_i(cm_rom),.P0_i(1'b0));
	i4002 ram_1(.clk_i(clk),.PHI1_i(phi1),.PHI2_i(phi2),.SYNC_i(sync),.D_io(data_bus),.CM_i(cm_rom),.P0_i(1'b1));
	
	i4004 cpu(.clk_i(clk),.PHI1_i(phi1),.PHI2_i(phi2),.SYNC_o(sync),.D_io(data_bus),.CM_ROM_o(cm_rom),.TEST_i(1'b1));

	mcs4_clk_gen generator(.clk_i(clk),.PHI1_o(phi1),.PHI2_o(phi2));

	initial
	begin
		$dumpfile("mcs4eval_tb.vcd");
		$dumpvars(0, mcs4eval_tb);
		#800000
		$finish;
	end
endmodule
