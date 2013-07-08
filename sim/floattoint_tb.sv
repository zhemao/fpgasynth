module floattoint_tb ();

reg [31:0] floatin;
wire [15:0] intout;

floattoint converter (
	.floatin (floatin),
	.intout (intout)
);

initial begin
	floatin = 32'h0;
	#20000 assert (intout == 16'h0);
	floatin = 32'h80000000;
	#20000 assert (intout == 16'h0);
	floatin = 32'h3f000000;
	#20000 assert (intout == 16'h0);
	floatin = 32'h3fc00000;
	#20000 assert (intout == 16'h1);
	floatin = 32'hbf8ccccd;
	#20000 assert (intout == 16'hffff);
	floatin = 32'h489e616b;
	#20000 assert (intout == 16'h7fff);
	floatin = 32'h43b5abee;
	#20000 assert (intout == 16'h016b);
	floatin = 32'hc4aa6afb;
	#20000 assert (intout == 16'hfaad);
end

endmodule
