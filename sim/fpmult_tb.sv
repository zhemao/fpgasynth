module fpmult_tb ();

wire [31:0] dataa = 32'h3fc00000;
wire [31:0] datab = 32'hbfc00000;
wire [31:0] result;

reg clk = 1;
reg reset;
wire done;

fpmult mult (
	.clk (clk),
	.reset (reset),
	.dataa (dataa),
	.datab (datab),
	.result (result),
	.done (done)
);

parameter expected = 32'hc0100000;

always #10000 clk = !clk;

initial begin
	reset = 1;
	#20000 reset = 0;
	#120000 assert(done == 1);
	assert(result == expected);
end

endmodule
