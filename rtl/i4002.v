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

    Total memory stored is 320 bit

    4 registers of 80 bits
    16 * 4bit as RAM and 4 * 4bit as STATUS registers
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

    reg [3:0] RAM_r[0:15];
    reg [3:0] STATUS_r[0:3];
    localparam STATE_A1 = 3'b000;
    localparam STATE_A2 = 3'b001;
    localparam STATE_A3 = 3'b010;
    localparam STATE_M1 = 3'b011;
    localparam STATE_M2 = 3'b100;
    localparam STATE_X1 = 3'b101;
    localparam STATE_X2 = 3'b110;
    localparam STATE_X3 = 3'b111;

    reg prev_phi1_r;
    reg prev_phi2_r;
    reg [2:0] state_r;
    reg [2:0] prev_state_r;

    reg bus_state_r;
    reg prev_sync_r;
    reg [3:0] data_r;
    
    //----------------------------------------------------------------
    // Initial state set
    //----------------------------------------------------------------
    initial
    begin
        bus_state_r = 1'b1;
    end

    //----------------------------------------------------------------
    // Main state machine
    //----------------------------------------------------------------
    always @(posedge clk_i)
    begin
        if (SYNC_i==1'b1)
        begin
            if ((PHI1_i == 1'b1) && (prev_phi1_r == 1'b0)) //  phi1 edge
            begin
            end
            if ((PHI2_i == 1'b1) && (prev_phi2_r == 1'b0)) //  phi2 edge
            begin
                state_r <= state_r + 3'b001; // next state
            end
        end
        prev_sync_r <= SYNC_i;
        prev_state_r <= state_r;
        prev_phi1_r <= PHI1_i;
        prev_phi2_r <= PHI2_i;
    end


    always @*
        if ((prev_sync_r==1'b0) && (SYNC_i==1'b1))
            state_r <= 3'b000;

    //----------------------------------------------------------------
    // Setting data/address bus
    //----------------------------------------------------------------

    assign D_io[3:0] = bus_state_r ? 4'bzzzz : data_r[3:0];

    //----------------------------------------------------------------
    // Bus state setting
    //----------------------------------------------------------------
    //always @*
        //if ((state_r==STATE_M1) || (state_r==STATE_M2))
            //bus_state_r = 1'b0;
        //else 
            //bus_state_r = 1'b1;

    //----------------------------------------------------------------
    // Address on databus
    //----------------------------------------------------------------    
    //always @*
        //if (state_r==STATE_X2)
            //addr_r[3:0] = D_io[3:0];
        //else if (state_r==STATE_X3) 
            //addr_r[7:4] = D_io[3:0];
        
        
endmodule