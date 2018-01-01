/*
	Intel i4004 CPU
			   _____   _____
	   D0   1 |*    \_/     | 16  CM-RAM0
	   D1   2 |             | 15  CM-RAM1
	   D2   3 |             | 14  CM-RAM2
	   D3   4 |             | 13  CM-RAM3
	  Vss   5 |             | 12  Vdd
	 PHI1   6 |             | 11  CM-ROM
	 PHI2   7 |             | 10  TEST
	 SYNC   8 |_____________|  9  RESET

	D0-D3       - DATA BUS I/O
	Vss         - GND
	PHI1        - CLOCK PHASE 1
	PHI2        - CLOCK PHASE 2
	SYNC        - SYNC OUTPUT
	CM-RAM0-3   - MEMORY CONTROL OUTPUTS
	Vdd         - -15V
	CM-ROM      - MEMORY CONTROL OUTPUT
	TEST        - TEST
	RESET      - RESET
*/

module i4004(
	input clk_i, // main design clock, not a pin
	inout [3:0] D_io,
	input PHI1_i,
	input PHI2_i,
	output SYNC_o,
	output [3:0] CM_RAM_o,
	output CM_ROM_o,
	input TEST_i,
	input RESET_i
);
endmodule
