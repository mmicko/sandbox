/*
    TTL 7402

    Quad 2-input NOR Gate
                _____   _____
        1Y   1 |*    \_/     | 14  Vcc
        1A   2 |             | 13  4Y
        1B   3 |             | 12  4B
        2Y   4 |             | 11  4A
        2A   5 |             | 10  3Y
        2B   6 |             | 9   3B
       GND   7 |_____________| 8   3A


    TTL 7403

    Quad 2-Input NOR Gate; Open Collector Outputs
                _____   _____
        1A   1 |*    \_/     | 14  Vcc
        1B   2 |             | 13  4B
        1Y   3 |             | 12  4A
        2A   4 |             | 11  4Y
        2B   5 |             | 10  3B
        2Y   6 |             | 9   3A
       GND   7 |_____________| 8   3Y
*/

module ttl_7402(
    input  A1, input  B1, output Y1,
    input  A2, input  B2, output Y2,
    input  A3, input  B3, output Y3,
    input  A4, input  B4, output Y4
);
    nor(Y1,A1,B1);
    nor(Y2,A2,B2);
    nor(Y3,A3,B3);
    nor(Y4,A4,B4);
endmodule


module ttl_7403(
    input  A1, input  B1, output Y1,
    input  A2, input  B2, output Y2,
    input  A3, input  B3, output Y3,
    input  A4, input  B4, output Y4
);
    nor(Y1,A1,B1);
    nor(Y2,A2,B2);
    nor(Y3,A3,B3);
    nor(Y4,A4,B4);
endmodule
