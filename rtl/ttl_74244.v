/*
    TTL 74244	

    Octal buffer, non-inverting three-state outputs
                _____   _____
       /1G   1 |*    \_/     | 20  Vcc
       1A1   2 |             | 19  /2G
       2Y4   3 |             | 18  1Y1
       1A2   4 |             | 17  2A4
       2Y3   5 |             | 16  1Y2
       1A3   6 |             | 15  2A3
       2Y2   7 |             | 14  1Y3
       1A4   8 |             | 13  2A2
       2Y1   9 |             | 12  1Y4
       GND  10 |_____________| 11  2A1
*/

module ttl_74244(
    input  _1G_n,
    input  [4:1] _1A, output [4:1] _1Y,
    input  _2G_n,
    input  [4:1] _2A, output [4:1] _2Y
);
    bufif0(_1Y[1],_1A[1],_1G_n);
    bufif0(_1Y[2],_1A[2],_1G_n);
    bufif0(_1Y[3],_1A[3],_1G_n);
    bufif0(_1Y[4],_1A[4],_1G_n);
    bufif0(_2Y[1],_2A[1],_2G_n);
    bufif0(_2Y[2],_2A[2],_2G_n);
    bufif0(_2Y[3],_2A[3],_2G_n);
    bufif0(_2Y[4],_2A[4],_2G_n);    
endmodule