module fpcomp_tb ();

reg [31:0] dataa;
reg [31:0] datab;

wire geq;
wire leq;

fpcomp comp (
	.dataa (dataa),
	.datab (datab),
	.geq (geq),
	.leq (leq)
);

wire [1:0] result = {geq, leq};

initial begin
	dataa = 32'h80000000; // -0
	datab = 32'h00000000; // 0
	#20000 assert (result == 2'b11);
	dataa = 32'h3fc00000; // 1.5
	datab = 32'h3fc00000; // 1.5
	#20000 assert (result == 2'b11);
	dataa = 32'h3fcccccd; // 1.6
	datab = 32'h3fc00000; // 1.5
	#20000 assert (result == 2'b10);
	dataa = 32'h3fc00000; // 1.5
	datab = 32'h3fcccccd; // 1.6
	#20000 assert (result == 2'b01);
	dataa = 32'h40200000; // 2.5
	datab = 32'h3fc00000; // 1.5
	#20000 assert (result == 2'b10);
	dataa = 32'h3fc00000; // 1.5
	datab = 32'h40200000; // 2.5
	#20000 assert (result == 2'b01);
	dataa = 32'h3fc00000; // 1.5
	datab = 32'hbfc00000; // -1.5
	#20000 assert (result == 2'b10);
	dataa = 32'hbfc00000; // -1.5
	datab = 32'h3fc00000; // 1.5
	#20000 assert (result == 2'b01);
	dataa = 32'hbfc00000; // -1.5
	datab = 32'hbfcccccd; // -1.6
	#20000 assert (result == 2'b10);
	dataa = 32'hbfcccccd; // -1.6
	datab = 32'hbfc00000; // -1.5
	#20000 assert (result == 2'b01);
	dataa = 32'h40033613; // 2.050175428390503
	datab = 32'h40490fdb; // 3.141592653589793
	#20000 assert (result == 2'b01);
end

endmodule
