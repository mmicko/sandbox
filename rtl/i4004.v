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
    output reg [3:0] CM_RAM_o,
    output reg CM_ROM_o,
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

    reg [11:0] PC_r[0:3];
    reg [3:0] OPR_r;
    reg [3:0] OPA_r;

    reg [3:0] data_r;
    reg bus_state_r;

    reg [3:0] ACC_r;
	reg CARRY_r; 
    reg [7:0] RP_r[0:7];
	
	reg [1:0] PC_current_r;
	
	reg [11:0] TEMP_r;
	reg extended_r;
	reg [7:0] RC_r;
	reg [2:0] CM_r;

    //----------------------------------------------------------------
    // Initial state set
    //----------------------------------------------------------------
    initial
    begin
        SYNC_o = 0;
        prev_phi1_r = 0;
        prev_phi2_r = 0;
        state_r = STATE_X3;
        PC_r[0] = 12'b000000000000;
		PC_r[1] = 12'b000000000000;
		PC_r[2] = 12'b000000000000;
		PC_r[3] = 12'b000000000000;
		PC_current_r = 2'b00;
        bus_state_r = 0;     
        ACC_r = 4'b0000;   
		CARRY_r = 1'b0;
        RP_r[0] = 8'b00000000;
        RP_r[1] = 8'b00000000;
        RP_r[2] = 8'b00000000;
        RP_r[3] = 8'b00000000;
        RP_r[4] = 8'b00000000;
        RP_r[5] = 8'b00000000;
        RP_r[6] = 8'b00000000;
        RP_r[7] = 8'b00000000;
		RC_r = 8'b00000000;
		CM_r = 3'b000;
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
    // Setting CM_ROM output pin
    //----------------------------------------------------------------
    always @*
        if ((state_r==STATE_A3) || 
		   ((state_r==STATE_M2) && (OPR_r == 4'b1110 )) || // I/O and RAM
   		   ((state_r==STATE_X2) && (OPR_r == 4'b0010 ) && (TEMP_r[8]==1'b1))) // SRC
		begin 
            CM_ROM_o = 0;
			CM_RAM_o[0] = (CM_r==3'b000) ? 1 : 0;
			CM_RAM_o[1] = CM_r[0];
			CM_RAM_o[2] = CM_r[1];
			CM_RAM_o[3] = CM_r[2];
		end
        else
		begin
            CM_ROM_o = 1;
			CM_RAM_o = 4'b1111;
		end

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
    always @(posedge clk_i)
	begin
		if (state_r==prev_state_r)
		begin
		end 
        else if (state_r==STATE_A1)
            data_r[3:0] <= PC_r[PC_current_r][3:0];
        else if (state_r==STATE_A2) 
            data_r[3:0] <= PC_r[PC_current_r][7:4];
        else if (state_r==STATE_A3) 
            data_r[3:0] <= PC_r[PC_current_r][11:8];
        else if (state_r==STATE_M1) 
            TEMP_r[7:4] <= D_io[3:0];
        else if (state_r==STATE_M2)   
		begin
			//$display("PC : %03h",PC_r[PC_current_r][11:0]);
			TEMP_r[3:0] <= D_io[3:0];
			if (extended_r == 0)
			begin		
				if ((TEMP_r[7:4]==4'b0001) || 
					(TEMP_r[7:4]==4'b0100) || 
					(TEMP_r[7:4]==4'b0101) || 
					(TEMP_r[7:4]==4'b0111) || 
					((TEMP_r[7:4]==4'b0010) && (D_io[0]==1'b0)))
				begin
					extended_r <= 1;
					TEMP_r[11:8] <= D_io[3:0];
					OPR_r <= TEMP_r[7:4];
				end
				else
				begin
					extended_r <= 0;
					TEMP_r[11:8] <= D_io[3:0];
					OPR_r <= TEMP_r[7:4];
					OPA_r <= D_io[3:0];
				end
			end
			else
			begin
			  extended_r <= 0;
			end
		end
        else if (state_r == STATE_X1)
        begin
			data_r[3:0] <= TEMP_r[3:0];
			$display("%03h ACC_r=%02h CARRY_r %d",PC_r[PC_current_r][11:0],ACC_r,CARRY_r);
			$display("R01=%02h R23=%02h R45=%02h R67=%02h R89=%02h Rab=%02h Rcd=%02h Ref=%02h",RP_r[0],RP_r[1],RP_r[2],RP_r[3],RP_r[4],RP_r[5],RP_r[6],RP_r[7]);
			PC_r[PC_current_r] <= PC_r[PC_current_r] + 1;
			if (extended_r==0)
			case(OPR_r)
				4'b0000 : $display("NOP");// NOP 
				4'b0001 : begin // JCN *
						  $display("JCN %1h %02h",TEMP_r[11:8],TEMP_r[7:0]);
						  if (TEMP_r[11]==1'b0)
						  begin
						  	if (((ACC_r==0) & TEMP_r[10]) || ((CARRY_r==1) & TEMP_r[9]) || (~TEST_i & TEMP_r[8]))
							begin
							  PC_r[PC_current_r][7:0] <= TEMP_r[7:0];
							end
						  end
						  else
						  begin
						  	if (((ACC_r!=0) & TEMP_r[10]) || ((CARRY_r!=1) & TEMP_r[9]) || (TEST_i & TEMP_r[8]))
							begin
							  PC_r[PC_current_r][7:0] <= TEMP_r[7:0];
							end							
						  end						   
						end
				4'b0010 : begin // FIM */ SRC 
						  if (TEMP_r[8]==1'b0)
						  begin
						  	$display("FIM %d %2h",TEMP_r[11:9],TEMP_r[7:0]);
							RP_r[TEMP_r[11:9]] <= TEMP_r[7:0];
						  end
						  else
						  begin
							$display("SCR %d",TEMP_r[11:9]);
							RC_r <= RP_r[TEMP_r[11:9]]; 
						  end						
						  end
				4'b0011 : begin // FIN / JIN
						  if (TEMP_r[8]==1'b0)
						  begin
						  	$display("FIN %d",TEMP_r[11:9]);
							$display("read from %02h",RP_r[0]);
							//RP_r[TEMP_r[11:9]] <= TEMP_r[7:0];
						  end
						  else
						  begin
							$display("JIN %d",TEMP_r[11:9]);
							PC_r[PC_current_r] <= { PC_r[PC_current_r][11:8], RP_r[TEMP_r[11:9]] };
						  end						
						  end
				4'b0100 : begin // JUN *
						  $display("JUN %3h",TEMP_r[11:0]);
						  PC_r[PC_current_r] <= TEMP_r[11:0];
						  end
				4'b0101 : begin // JMS *
						  $display("JMS %3h",TEMP_r[11:0]);
						  PC_current_r = PC_current_r - 1;
						  PC_r[PC_current_r] <= TEMP_r[11:0];
						  end
				4'b0110 : begin // INC 
						  $display("INC %d",OPA_r[3:0]);
						  if (OPA_r[0]==1)
						  	RP_r[OPA_r[3:1]][3:0] <= RP_r[OPA_r[3:1]][3:0] + 1;
						  else
						  	RP_r[OPA_r[3:1]][7:4] <= RP_r[OPA_r[3:1]][7:4] + 1;
						  end
				4'b0111 : begin // ISZ *
						  $display("ISZ %d %02h",TEMP_r[11:8],TEMP_r[7:0]);
						  end
				4'b1000 : begin // ADD 
						  $display("ADD %d",OPA_r[3:0]);
						  if (OPA_r[0]==1)
						  	{ CARRY_r , ACC_r } <= ACC_r + RP_r[OPA_r[3:1]][3:0];
						  else
						  	{ CARRY_r , ACC_r } <= ACC_r + RP_r[OPA_r[3:1]][7:4];
						  end
				4'b1001 : begin // SUB 
						  $display("SUB %d",OPA_r[3:0]);
						  if (OPA_r[0]==1)
						  	{ CARRY_r , ACC_r } <= ACC_r - RP_r[OPA_r[3:1]][3:0];
						  else
						  	{ CARRY_r , ACC_r } <= ACC_r - RP_r[OPA_r[3:1]][7:4];
						  end
				4'b1010 : begin // LD
						  $display("LD %d",OPA_r[3:0]);
						  if (OPA_r[0]==1)
						  	ACC_r <= RP_r[OPA_r[3:1]][3:0];
						  else
						  	ACC_r <= RP_r[OPA_r[3:1]][7:4];						  
						  end
				4'b1011 : begin // XCH
						  $display("XCH %d",OPA_r[3:0]);
						  if (OPA_r[0]==1)
						  begin
						  	ACC_r  <= RP_r[OPA_r[3:1]][3:0];
							RP_r[OPA_r[3:1]][3:0] <= ACC_r;
						  end
						  else
						  begin
						  	ACC_r  <= RP_r[OPA_r[3:1]][7:4];
							RP_r[OPA_r[3:1]][7:4] <= ACC_r;
						  end
						  end
				4'b1100 : begin // BBL 
						  $display("BBL 0x%1h",OPA_r[3:0]);
						  ACC_r <= OPA_r[3:0];
						  PC_current_r <= PC_current_r + 1;
						  end
				4'b1101 : begin // LDM 
						  $display("LDM 0x%1h",OPA_r[3:0]);
						  ACC_r <= OPA_r[3:0];
						  end
				4'b1110 : begin // I/O and RAM 
						  case(OPA_r)
							4'b0000 : begin // WRM
									  $display("WRM");
									  end
							4'b0001	: begin // WMP
									  $display("WPM");
									  end
							4'b0010 : begin // WRR
									  $display("WRR");
									  end
							4'b0011 : begin // ???
									  $display("???");
									  end
							4'b0100 : begin // WR0
									  $display("WR0");
									  end
							4'b0101 : begin // WR1
									  $display("WR1");
									  end
							4'b0110 : begin // WR2
									  $display("WR2");
									  end
							4'b0111 : begin // WR3
									  $display("WR3");
									  end
							4'b1000 : begin // SBM
									  $display("SBM");
									  end
							4'b1001 : begin // RDM
									  $display("RDM");
									  end
							4'b1010 : begin // RDR
									  $display("RDR");
									  end
							4'b1011 : begin // ADM
								      $display("ADM");
									  end
							4'b1100 : begin // RD0
									  $display("RD0");
									  end
							4'b1101 : begin // RD1
									  $display("RD1");
									  end
							4'b1110 : begin // RD2
									  $display("RD2");
									  end
							4'b1111 : begin // RD3
									  $display("RD3");
									  end
						  endcase
						  end
				4'b1111 : begin // ACC group
						  case(OPA_r)
							4'b0000 : begin // CLB
									  $display("CLB");
									  ACC_r <= 4'b0000;
									  CARRY_r <= 1'b0;									  
									  end
							4'b0001	: begin // CLC
							   		  $display("CLC");
									  CARRY_r <= 1'b0;
									  end
							4'b0010 : begin // IAC
									  $display("IAC");
									  { CARRY_r, ACC_r } <= ACC_r + 4'b0001;
									  end
							4'b0011 : begin // CMC
							 		  $display("CMC");
									  CARRY_r <= ~CARRY_r;
									  end
							4'b0100 : begin // CMA
									  $display("CMA");
									  ACC_r <= ~ACC_r;
									  end
							4'b0101 : begin // RAL
									  $display("RAL");
									   { CARRY_r, ACC_r[3:0] } <=  { ACC_r[3:0], CARRY_r };
									  end
							4'b0110 : begin // RAR
									  $display("RAR");
									  { CARRY_r, ACC_r } <=  { ACC_r[0], CARRY_r,  ACC_r[3:1]};
									  end
							4'b0111 : begin // TCC
									  $display("TCC");
									  ACC_r <= { 3'b000, CARRY_r };	
									  CARRY_r <= 1'b0;								  	
									  end
							4'b1000 : begin // DAC
									  $display("DAC");
									  { CARRY_r, ACC_r } <= ACC_r - 4'b0001;
									  end
							4'b1001 : begin // TCS
									  $display("TCS");					
									  if (CARRY_r==1'b0)
									  	ACC_r <= 9;
									  else 
										ACC_r <= 10;
									  CARRY_r <= 1'b0;
									  end
							4'b1010 : begin // STC
									  $display("STC");
									  CARRY_r <= 1'b1;
									  end
							4'b1011 : begin // DAA
									  $display("DAA");
									  if (ACC_r > 9 || CARRY_r==1)
									  	ACC_r <= ACC_r + 6;
									  end
							4'b1100 : begin // KBP
									  $display("KBP");
									  case(ACC_r)
									    4'b0000 : ACC_r <= 4'b0000;
										4'b0001 : ACC_r <= 4'b0001;
										4'b0010 : ACC_r <= 4'b0010;
										4'b0100 : ACC_r <= 4'b0011;
										4'b1000 : ACC_r <= 4'b0100;
									  	default : ACC_r <= 4'b1111;
									  endcase
									  end
							4'b1101 : begin // DCL
									  $display("DCL");
									  CM_r <= ACC_r[2:0];
									  end
							4'b1110 : begin // ???
									  $display("???");
									  end
							4'b1111 : begin // ???
									  $display("???");
									  end
						  endcase
						  end
			endcase
		end
        else if (state_r == STATE_X2)
        begin
		end
        else if (state_r == STATE_X2)
        begin
		end		
	end
endmodule
