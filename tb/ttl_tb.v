`timescale 1ns/1ns
/*
	Testbench for TTL
*/
module ttl_tb();

	wire [7:0] r;
	wire [7:0] w;
	reg g1;
	reg g2;

	reg [2:0] a;
	reg e1;
	reg e2;
	reg e3;

	ttl_74244 b(._1G_n(g1),._1A(r[3:0]),._1Y(w[3:0]),._2G_n(g2),._2A(r[7:4]),._2Y(w[7:4]));
	
	ttl_74138 dec(.A(a),.E1_n(e1),.E2_n(e2),.E3(e3),.Y(r));

	initial
	begin
		$dumpfile("ttl_tb.vcd");
		$dumpvars(0, ttl_tb);
		e1 = 1;
		e2 = 1;
		e3 = 1;
		g1 = 1;
		g2 = 1;
		a = 3'b000;
		#10
		e1 = 0;
		#20
		e2 = 0;
		#50
		g1 = 0;
		g2 = 0;
		#100		
		$finish;
	end
endmodule
