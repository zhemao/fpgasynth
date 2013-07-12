module inttofloat_tb ();

reg [15:0] intin;
reg [31:0] floatout;

reg clk = 1'b1;
reg reset = 1'b0;
wire done;

inttofloat converter (
	.clk (clk),
	.reset (reset),
	.floatout (floatout),
	.intin (intin),
	.done (done)
);

reg [15:0] test_inputs[0:4];
reg [31:0] expected[0:4];

always #10000 clk = !clk;

integer i;

initial begin
	test_inputs[0] = 16'h7fff;
	test_inputs[1] = 16'h8000;
	test_inputs[2] = 16'h0000;
	test_inputs[3] = 16'h000f;
	test_inputs[4] = 16'hffe5;
	expected[0] = 32'h46fffe00;
	expected[1] = 32'hc7000000;
	expected[2] = 32'h00000000;
	expected[3] = 32'h41700000;
	expected[4] = 32'hc1d80000;

	for (i = 0; i < 5; i++) begin
		reset = 1;
		intin = test_inputs[i];
		#20000 reset = 0;
		#40000 assert (done == 1);
		assert (floatout == expected[i]);
	end
end

endmodule
