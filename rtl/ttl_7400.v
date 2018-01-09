/*
    TTL 7400

    Quad 2-input NAND Gate
                _____   _____
        1A   1 |*    \_/     | 14  Vcc
        1B   2 |             | 13  4B
        1Y   3 |             | 12  4A
        2A   4 |             | 11  4Y
        2B   5 |             | 10  3B
        2Y   6 |             | 9   3A
       GND   7 |_____________| 8   3Y

    TTL 7401

    Quad 2-Input NAND Gate; Open Collector Outputs
                _____   _____
        1Y   1 |*    \_/     | 14  Vcc
        1A   2 |             | 13  4Y
        1B   3 |             | 12  4B
        2Y   4 |             | 11  4A
        2A   5 |             | 10  3Y
        2B   6 |             | 9   3B
       GND   7 |_____________| 8   3A

*/

module ttl_7400(
    input _1A, input _1B, output _1Y,
    input _2A, input _2B, output _2Y,
    input _3A, input _3B, output _3Y,
    input _4A, input _4B, output _4Y
);
    nand(_1Y,_1A,_1B);
    nand(_2Y,_2A,_2B);
    nand(_3Y,_3A,_3B);
    nand(_4Y,_4A,_4B);
endmodule

/*
module ttl_7401(
    input _1A, input _1B, output _1Y,
    input _2A, input _2B, output _2Y,
    input _3A, input _3B, output _3Y,
    input _4A, input _4B, output _4Y
);
    nand(_1Y,_1A,_1B);
    nand(_2Y,_2A,_2B);
    nand(_3Y,_3A,_3B);
    nand(_4Y,_4A,_4B);
endmodule
*/