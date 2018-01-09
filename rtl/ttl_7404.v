/*
    TTL 7404	
    Hex Inverter
    
    TTL 7405	
    Hex Inverter; Open Collector Outputs
    
    TTL 7406	
    Hex Inverter; Open Collector High Voltage Outputs
    
    TTL 7407	
    Hex Buffer; Open Collector High Voltage Outputs
                _____   _____
        1A   1 |*    \_/     | 14  Vcc
        1Y   2 |             | 13  6A
        2A   3 |             | 12  6Y
        2Y   4 |             | 11  5A
        3A   5 |             | 10  5Y
        3Y   6 |             | 9   4A
       GND   7 |_____________| 8   4Y
*/

module ttl_7404(
    input _1A, output _1Y,
    input _2A, output _2Y,
    input _3A, output _3Y,
    input _4A, output _4Y,
    input _5A, output _5Y,
    input _6A, output _6Y
);
    not(_1Y,_1A);
    not(_2Y,_2A);
    not(_3Y,_3A);
    not(_4Y,_4A);
    not(_5Y,_5A);
    not(_6Y,_6A);    
endmodule