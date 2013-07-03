module sin_tb ();

reg [31:0] theta [0:2];
reg [31:0] prec [0:2];
reg [31:0] expected [0:2];
reg clk = 1'b1;
reg reset;
wire [31:0] result;
wire done;
reg [1:0] ind;

sin sinunit (
	.clk (clk),
	.reset (reset),
	.theta (theta[ind]),
	.prec (prec[ind]),
	.result (result),
	.done (done)
);

always #10000 clk = !clk;

initial begin
	theta[0] = 32'h00000000;
	theta[1] = 32'h3f800000;
	theta[2] = 32'h3f99999a;
	prec[0] = 32'h41200000;
	prec[1] = 32'h41100000;
	prec[2] = 32'h40e00000;
	expected[0] = 32'h00000000;
	expected[1] = 32'h3f576aa5;
	expected[2] = 32'h3f6e9a1c;

	for (ind = 0; ind < 3; ind++) begin
		reset = 1;
		#20000 reset = 0;
		while (done == 0) begin
			#20000;
		end
		assert (result == expected[ind]);
	end
end


endmodule
