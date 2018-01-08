/*
    74LS04	
    Hex Inverter
    
    74LS05	
    Hex Inverter; Open Collector Outputs
    
    74LS06	
    Hex Inverter; Open Collector High Voltage Outputs
    
    74LS07	
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
    input  A1, output Y1,
    input  A2, output Y2,
    input  A3, output Y3,
    input  A4, output Y4,
    input  A5, output Y5,
    input  A6, output Y6
);
    not(Y1,A1);
    not(Y2,A2);
    not(Y3,A3);
    not(Y4,A4);
    not(Y5,A5);
    not(Y6,A6);    
endmodule