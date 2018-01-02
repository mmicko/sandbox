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
    inout [3:0] D_io,
    input PHI1_i,
    input PHI2_i,
    input SYNC_i,
    inout [3:0] IO_io,
    input CM_i,
    input CL_i,
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

    reg [7:0] store_r[0:255];
    reg [3:0] data_r;
    reg bus_state_r;
    reg [7:0] addr_r;
    reg [3:0] id_r;
    reg prev_sync_r;
    

    //----------------------------------------------------------------
    // Initial state set
    //----------------------------------------------------------------
    initial
    begin
	    $readmemh(ROM_FILENAME, store_r);
        bus_state_r = 1'b1;
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
    always @*
        if ((state_r==STATE_M1) || (state_r==STATE_M2))
            bus_state_r = 1'b0;
        else 
            bus_state_r = 1'b1;

    //----------------------------------------------------------------
    // Address on databus
    //----------------------------------------------------------------    
    always @*
        if (state_r==STATE_A1)
            addr_r[3:0] = D_io[3:0];
        else if (state_r==STATE_A2) 
            addr_r[7:4] = D_io[3:0];
        else if (state_r==STATE_A3) 
            id_r[3:0] = D_io[3:0];
        else if (state_r==STATE_M1) 
            data_r[3:0] = store_r[addr_r][7:4];
        else if (state_r==STATE_M2) 
            data_r[3:0] = store_r[addr_r][3:0];
endmodule
