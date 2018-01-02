/*
    Intel i4001 ROM
                _____   _____
        D0   1 |*    \_/     | 16  I/O0
        D1   2 |             | 15  I/O1
        D2   3 |             | 14  I/O2
        D3   4 |             | 13  I/O3
       Vss   5 |             | 12  Vdd
      PHI1   6 |             | 11  CM
      PHI2   7 |             | 10  CL
      SYNC   8 |_____________|  9  RESET

    D0-D3       - DATA BUS
    Vss         - GND
    PHI1        - CLOCK PHASE 1
    PHI2        - CLOCK PHASE 2
    SYNC        - SYNC INPUT
    I/O0 - I/O3 - INPUT OUTPUT LINES
    Vdd         - -15V
    CM          - MEMORY CONTROL INPUT
    CL          - CLEAR INPUT FOR I/O LINES
    RESET       - RESET

*/
module i4001
#(
    parameter ROM_FILENAME="",
    parameter CHIP_NUMBER=4'b0000,
    parameter IO_MASK=4'b0000
)
(
    input clk_i, // main design clock, not a pin
    output reg [3:0] D_o,
    input PHI1_i,
    input PHI2_i,
    input SYNC_i,
    inout [3:0] IO_io,
    input CM_i,
    input CL_i,
    input RESET_i
);
  reg [7:0] store[0:255];

  initial
  begin
	$readmemh(ROM_FILENAME, store);
  end

endmodule
