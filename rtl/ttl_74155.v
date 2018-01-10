/*
    TTL 74155

    Dual 2-line to 4-line decoder/demultiplexer, inverting outputs
                _____   _____
        1C   1 |*    \_/     | 16  Vcc
       /1G   2 |             | 15  /2C
         B   3 |             | 14  /2G
       1Y3   4 |             | 13  A
       1Y2   5 |             | 12  2Y3
       1Y1   6 |             | 11  2Y2
       1Y0   7 |             | 10  2Y1
       GND   8 |_____________| 9   2Y0
*/

module ttl_74155(
    input  _1C,
    input  _1G_n,
    input  B,
    output [3:0] _1Y,
    input  _2C_n,
    input  _2G_n,
    input  A,
    output [3:0] _2Y
);

    wire enable1;
    wire enable2;

    nand(enable1, ~_1G_n, ~_1C);
    nand(_1Y[0],~A,~B, ~enable1);
    nand(_1Y[1], A,~B, ~enable1);
    nand(_1Y[2],~A, B, ~enable1);
    nand(_1Y[3], A, B, ~enable1);

    nand(enable2, ~_2G_n, ~_2C_n);
    nand(_2Y[0],~A,~B, ~enable2);
    nand(_2Y[1], A,~B, ~enable2);
    nand(_2Y[2],~A, B, ~enable2);
    nand(_2Y[3], A, B, ~enable2);

endmodule