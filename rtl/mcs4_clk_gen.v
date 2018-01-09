/*
    Two phase clock generator for MCS-4
*/
module mcs4_clk_gen(
    input clk_i, // main design clock, not a pin
    output reg PHI1_o,
    output reg PHI2_o
);
    reg[2:0] r_clk_count = 3'b000;
    
    initial
    begin
        PHI1_o = 1;
        PHI2_o = 1;
    end

    always @(posedge clk_i)
    begin
        if ((r_clk_count == 3'b000) || (r_clk_count == 3'b001))
            PHI1_o <= 0;
        else
            PHI1_o <= 1;
        if ((r_clk_count == 3'b100) || (r_clk_count == 3'b101))
            PHI2_o <= 0;
        else
            PHI2_o <= 1;
        if (r_clk_count == 3'b110)
            r_clk_count <= 3'b000;
        else
            r_clk_count <= r_clk_count + 1;
    end
endmodule
