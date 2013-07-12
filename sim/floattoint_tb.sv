module floattoint_tb ();

reg [31:0] floatin;
wire [15:0] intout;

reg clk = 1'b1;
reg reset = 1'b0;
wire done;

floattoint converter (
	.clk (clk),
	.reset (reset),
	.floatin (floatin),
	.intout (intout),
	.done (done)
);

reg [31:0] test_inputs[0:7];
reg [15:0] expected[0:7];

always #10000 clk = !clk;

integer i;

initial begin
	test_inputs[0] = 32'h00000000;
	test_inputs[1] = 32'h80000000;
	test_inputs[2] = 32'h3f000000;
	test_inputs[3] = 32'h3fc00000;
	test_inputs[4] = 32'hbf8ccccd;
	test_inputs[5] = 32'h489e616b;
	test_inputs[6] = 32'h43b5abee;
	test_inputs[7] = 32'hc4aa6afb;

	expected[0] = 16'h0000;
	expected[1] = 16'h0000;
	expected[2] = 16'h0000;
	expected[3] = 16'h0001;
	expected[4] = 16'hffff;
	expected[5] = 16'h7fff;
	expected[6] = 16'h016b;
	expected[7] = 16'hfaad;

	for (i = 0; i < 8; i++) begin
		reset = 1;
		floatin = test_inputs[i];
		#20000 reset = 0;
		#40000 assert (done == 1);
		assert (intout == expected[i]);
	end
end

endmodule
