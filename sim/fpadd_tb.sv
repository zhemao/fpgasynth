module fpadd_tb ();

wire [31:0] dataa = 32'h3fa00000; // 1.25
wire [31:0] datab = 32'h40200000; // 2.5
wire [31:0] result;

reg clk = 1;
reg reset;
wire done;

parameter expected = 32'h40700000; // 3.75

fpadd add (
	.clk (clk),
	.reset (reset),
	.dataa (dataa),
	.datab (datab),
	.result (result),
	.done (done)
);

always #10000 clk = !clk;

initial begin
	reset = 1;
	#20000 reset = 0;
	#120000 assert(done == 1);
	assert(result == expected);
end

endmodule
