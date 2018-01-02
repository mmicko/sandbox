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
    output reg SYNC_o,
    output [2:0] CM_RAM_o,
    output CM_ROM_o,
    input TEST_i,
    input RESET_i
);

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

    reg [11:0] PC_r;

    reg [3:0] data_r;
    reg bus_state_r;

    //----------------------------------------------------------------
    // Initial state set
    //----------------------------------------------------------------
    initial
    begin
        SYNC_o = 0;
        prev_phi1_r = 0;
        prev_phi2_r = 0;
        state_r = STATE_X3;
        PC_r = 12'b000000000000;        
        bus_state_r = 0;        
    end

    //----------------------------------------------------------------
    // Main state machine
    //----------------------------------------------------------------
    always @(posedge clk_i)
    begin
        if ((PHI1_i == 1'b1) && (prev_phi1_r == 1'b0)) //  phi1 edge
        begin
        end
        if ((PHI2_i == 1'b1) && (prev_phi2_r == 1'b0)) //  phi2 edge
        begin
            state_r <= state_r + 3'b001; // next state
        end

        if ((state_r == STATE_X2) && (prev_state_r != STATE_X2)) //  when executing X2
        begin
            PC_r <= PC_r + 1;
        end

        prev_state_r <= state_r;
        prev_phi1_r <= PHI1_i;
        prev_phi2_r <= PHI2_i;
    end

    //----------------------------------------------------------------
    // Setting SYNC output pin
    //----------------------------------------------------------------
    always @*
        if (state_r==STATE_X3) 
            SYNC_o = 0;
        else
            SYNC_o = 1;

    //----------------------------------------------------------------
    // Setting data/address bus
    //----------------------------------------------------------------

    assign D_io[3:0] = bus_state_r ? 4'bzzzz : data_r[3:0];

    //----------------------------------------------------------------
    // Bus state setting
    //----------------------------------------------------------------
    always @*
        if ((state_r==STATE_A1) || (state_r==STATE_A2) || (state_r==STATE_A3))
            bus_state_r = 1'b0;
        else 
            bus_state_r = 1'b1;

    //----------------------------------------------------------------
    // Address on databus
    //----------------------------------------------------------------    
    always @*
        if (state_r==STATE_A1)
            data_r[3:0] = PC_r[3:0];
        else if (state_r==STATE_A2) 
            data_r[3:0] = PC_r[7:4];
        else if (state_r==STATE_A3) 
            data_r[3:0] = PC_r[11:8];
endmodule
