module sin_tb ();

reg [31:0] theta [0:2];
reg [3:0] prec [0:2];
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
	prec[0] = 4'hA;
	prec[1] = 4'h9;
	prec[2] = 4'h7;
	expected[0] = 32'h00000000;
	expected[1] = 32'h3f576aa4;
	expected[2] = 32'h3f6e9a1d;

	for (ind = 0; ind < 3; ind++) begin
		reset = 1;
		#20000 reset = 0;
		while (done == 0) begin
			#20000;
		end
		assert (result[31:3] == expected[ind][31:3]);
	end
end


endmodule
