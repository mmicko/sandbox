/*
    Intel i4003 SR
                _____   _____
        CP   1 |*    \_/     | 16  E
   DATA_IN   2 |             | 15  SERIAL_OUT
        Q0   3 |             | 14  Vdd
        Q1   4 |             | 13  Q9
       Vss   5 |             | 12  Q8
        Q2   6 |             | 11  Q7
        Q3   7 |             | 10  Q6
        Q4   8 |_____________|  9  Q5

    CP          - CLOCK PULSE INPUT
    Q0-Q9       - PARALLEL OUTPUTS
    E           - ENABLE INPUT
*/

module i4003(
    input CP_i,
    input DATA_IN_i,
    output [9:0] Q_o,
    input E_i,
    output SERIAL_OUT_o
);

endmodule
