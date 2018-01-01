/*
    Intel i4002 RAM
                _____   _____
        D0   1 |*    \_/     | 16  O0
        D1   2 |             | 15  O1
        D2   3 |             | 14  O2
        D3   4 |             | 13  O3
       Vss   5 |             | 12  Vdd
      PHI1   6 |             | 11  CM
      PHI2   7 |             | 10  P0
      SYNC   8 |_____________|  9  RESET

    D0-D3       - DATA BUS I/O
    Vss         - GND
    PHI1        - CLOCK PHASE 1
    PHI2        - CLOCK PHASE 2
    SYNC        - SYNC INPUT
    O0 - O3     - OUTPUT LINES
    Vdd         - -15V
    CM          - MEMORY CONTROL INPUT
    P0          - HARD WIRED CHIP SELECT INPUT
    RESET       - RESET
*/

module i4002(
    input clk_i, // main design clock, not a pin
    inout [3:0] D_io,
    input PHI1_i,
    input PHI2_i,
    input SYNC_i,
    output [3:0] O_o,
    input CM_i,
    input P0_i,
    input RESET_i
);
endmodule
