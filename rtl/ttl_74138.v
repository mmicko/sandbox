/*
    TTL 74138

    3 to 8-line decoder/demultiplexer, inverting outputs
                _____   _____
        A0   1 |*    \_/     | 16  Vcc
        A1   2 |             | 15  /Y0
        A2   3 |             | 14  /Y1
       /E1   4 |             | 13  /Y2
       /E2   5 |             | 12  /Y3
        E3   6 |             | 11  /Y4
       /Y7   7 |             | 10  /Y5
       GND   8 |_____________| 9   /Y6
*/

module ttl_74138(
    input  [2:0] A,
    input  E1_n,
    input  E2_n,
    input  E3,
    output [7:0] Y
);
    wire enable;

    nand(enable, ~E1_n, ~E2_n, E3);    
    nand(Y[0],~A[2],~A[1],~A[0], ~enable);
    nand(Y[1],~A[2],~A[1], A[0], ~enable);
    nand(Y[2],~A[2], A[1],~A[0], ~enable);
    nand(Y[3],~A[2], A[1], A[0], ~enable);
    nand(Y[4], A[2],~A[1],~A[0], ~enable);
    nand(Y[5], A[2],~A[1], A[0], ~enable);
    nand(Y[6], A[2], A[1],~A[0], ~enable);
    nand(Y[7], A[2], A[1], A[0], ~enable);    
endmodule