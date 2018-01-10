`timescale 1ns/1ns
/*
	Testbench for TTL
*/
module ttl_tb();

	wire [7:0] r1;
	wire [7:0] w;
	reg g1;
	reg g2;

	reg [2:0] aa;
	reg e1;
	reg e2;
	reg e3;

	ttl_74244 buffer(._1G_n(g1),._1A(r1[3:0]),._1Y(w[3:0]),._2G_n(g2),._2A(r1[7:4]),._2Y(w[7:4]));
	
	ttl_74138 dec(.A(aa),.E1_n(e1),.E2_n(e2),.E3(e3),.Y(r1));
    
	wire [7:0] r;
	reg g;
	reg c;
	reg a;
	reg b;

	ttl_74155 dem(._1C(c),._1G_n(g),._2G_n(g),.A(a),.B(b),._2C_n(~c),._1Y(r[3:0]),._2Y(r[7:4]));
	initial
	begin
		$dumpfile("ttl_tb.vcd");
		$dumpvars(0, ttl_tb);

		e1 = 1;
		e2 = 1;
		e3 = 1;
		g1 = 1;
		g2 = 1;
		aa = 3'b000;
		#10
		e1 = 0;
		#20
		e2 = 0;
		#50
		g1 = 0;
		g2 = 0;
		#100		

	
		g = 0;
		
		
		c = 0;
		b = 0;
		a = 0;
		#20
		c = 0;
		b = 0;
		a = 1;
		#20
		c = 0;
		b = 1;
		a = 0;
		#20
		c = 0;
		b = 1;
		a = 1;
		#20
		c = 1;
		b = 0;
		a = 0;
		#20
		c = 1;
		b = 0;
		a = 1;
		#20
		c = 1;
		b = 1;
		a = 0;
		#20
		c = 1;
		b = 1;
		a = 1;
		#20
		g = 1;

		#100		
		$finish;
	end
endmodule
