module fpadd_tb ();

reg [31:0] dataa[3:0];
reg [31:0] datab[3:0];
wire [31:0] result;

reg clk = 1;
reg reset;
wire done;

reg [2:0] ind;

reg [31:0] expected[3:0];

fpadd add (
	.clk (clk),
	.reset (reset),
	.dataa (dataa[ind]),
	.datab (datab[ind]),
	.result (result),
	.done (done)
);

always #10000 clk = !clk;

initial begin
	dataa[0] = 32'h3fc00000; // 1.5
	dataa[1] = 32'h3fc00000; // 1.5
	dataa[2] = 32'h3d800000; // .0625
	dataa[3] = 32'h3d800000; // .0625
	datab[0] = 32'h3fa00000; // 1.25
	datab[1] = 32'hbfa00000; // -1.25
	datab[2] = 32'h3f800000; // 1
	datab[3] = 32'h3d800000; // .0625
	expected[0] = 32'h40700000;
	expected[1] = 32'h3e800000;
	expected[2] = 32'h3f880000;
	expected[3] = 32'h3e000000;

	for (ind = 0; ind < 4; ind++) begin
		reset = 1;
		#20000 reset = 0;
		#120000 assert(done == 1);
		assert(result == expected[ind]);
	end
end

endmodule
