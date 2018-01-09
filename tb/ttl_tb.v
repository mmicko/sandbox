`timescale 1ns/1ns
/*
	Testbench for TTL
*/
module ttl_tb();

	reg [7:0] r;
	wire [7:0] w;
	reg g1;
	reg g2;

	ttl_74244 b(._1G_n(g1),._1A(r[3:0]),._1Y(w[3:0]),._2G_n(g2),._2A(r[7:4]),._2Y(w[7:4]));

	initial
	begin
		$dumpfile("ttl_tb.vcd");
		$dumpvars(0, ttl_tb);
		g1 = 1;
		g2 = 1;
		r = 8'ha5;
		#10
		g1 = 0;
		#20
		g2 = 0;
		#10
		g1 = 1;
		#10
		g2 = 1;
		#100		
		$finish;
	end
endmodule
