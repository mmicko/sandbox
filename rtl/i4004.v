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
    reg [3:0] OPR_r;
    reg [3:0] OPA_r;

    reg [3:0] data_r;
    reg bus_state_r;

    reg [3:0] ACC_r;
	reg CARRY_r; 
    reg [7:0] RP_r[0:7];
	reg [11:0] STACK_r[0:2];
	
	reg [1:0] SP_r;
	
	reg [11:0] TEMP_r;
	reg extended_r;

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
		STACK_r[0] = 12'b000000000000;
		STACK_r[1] = 12'b000000000000;
		STACK_r[2] = 12'b000000000000;
		SP_r = 2'b00;
        bus_state_r = 0;     
        ACC_r = 4'b0000;   
		CARRY_r = 1'b0;
        RP_r[0] = 4'b0000;
        RP_r[1] = 4'b0000;
        RP_r[2] = 4'b0000;
        RP_r[3] = 4'b0000;
        RP_r[4] = 4'b0000;
        RP_r[5] = 4'b0000;
        RP_r[6] = 4'b0000;
        RP_r[7] = 4'b0000;
		extended_r = 0;
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
        else if (state_r==STATE_M1) 
            TEMP_r[7:4] = D_io[3:0];
        else if (state_r==STATE_M2)   
		begin
			TEMP_r[3:0] = D_io[3:0];
			if (extended_r == 0)
			begin		
				if ((TEMP_r[7:4]==4'b0001) || 
					(TEMP_r[7:4]==4'b0100) || 
					(TEMP_r[7:4]==4'b0101) || 
					(TEMP_r[7:4]==4'b0111) || 
					((TEMP_r[7:4]==4'b0010) && (TEMP_r[0]==1'b0)))
				begin
					extended_r = 1;
				end
				else
				begin
					extended_r = 0;
					OPR_r = TEMP_r[7:4];
					OPA_r = TEMP_r[3:0];
				end
			end
		end
        else if (state_r==STATE_X1) 
        begin
			case(OPR_r)
				4'b0000 : ;// NOP 
				4'b0001 : begin // JCN *
						  end
				4'b0010 : begin // FIM */ SRC 
						  end
				4'b0011 : begin // FIN / JIN
						  end
				4'b0100 : begin // JUN *
						  end
				4'b0101 : begin // JMS *
						  end
				4'b0110 : begin // INC 
						  end
				4'b0111 : begin // ISZ *
						  end
				4'b1000 : begin // ADD 
						  end
				4'b1001 : begin // SUB 
						  end
				4'b1010 : begin // LD
						  end
				4'b1011 : begin // XCH
						  end
				4'b1100 : begin // BBL 
						  end
				4'b1101 : begin // LDM 
						  end
				4'b1110 : begin // I/O and RAM 
						  case(OPA_r)
							4'b0000 : begin // WRM
									  end
							4'b0001	: begin // WMP
									  end
							4'b0010 : begin // WRR
									  end
							4'b0011 : begin // ???
									  end
							4'b0100 : begin // WR0
									  end
							4'b0101 : begin // WR1
									  end
							4'b0110 : begin // WR2
									  end
							4'b0111 : begin // WR3
									  end
							4'b1000 : begin // SBM
									  end
							4'b1001 : begin // RDM
									  end
							4'b1010 : begin // RDR
									  end
							4'b1011 : begin // ADM
									  end
							4'b1100 : begin // RD0
									  end
							4'b1101 : begin // RD1
									  end
							4'b1110 : begin // RD2
									  end
							4'b1111 : begin // RD3
									  end
						  endcase
						  end
				4'b1111 : begin // ACC group
						  case(OPA_r)
							4'b0000 : begin // CLB
									  ACC_r <= 4'b0000;
									  CARRY_r <= 1'b0;
									  end
							4'b0001	: begin // CLC
									  CARRY_r <= 1'b0;
									  end
							4'b0010 : begin // IAC
									  { CARRY_r, ACC_r } <= ACC_r + 4'b0001;
									  end
							4'b0011 : begin // CMC
									  CARRY_r <= ~CARRY_r;
									  end
							4'b0100 : begin // CMA
									  ACC_r <= ~ACC_r;
									  end
							4'b0101 : begin // RAL
									  end
							4'b0110 : begin // RAR
									  end
							4'b0111 : begin // TCC
									  end
							4'b1000 : begin // DAC
									  { CARRY_r, ACC_r } <= ACC_r - 4'b0001;
									  end
							4'b1001 : begin // TCS						
									  end
							4'b1010 : begin // STC
									  end
							4'b1011 : begin // DAA
									  end
							4'b1100 : begin // KBP
									  end
							4'b1101 : begin // DCL
									  end
							4'b1110 : begin // ???
									  end
							4'b1111 : begin // ???
									  end
						  endcase
						  end
			endcase
		end
endmodule
