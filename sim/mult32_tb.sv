module mult32_tb ();

reg clk = 0;
reg reset;
reg [31:0] dataa = 32'd1507328;
reg [31:0] datab = 32'd4325;
wire [63:0] result;

parameter expected = 64'd6519193600;

always #10000 clk = !clk;

mult32 mult (
	.clk (clk),
	.reset (reset),
	.dataa (dataa),
	.datab (datab),
	.result (result)
);

initial begin
	reset = 1;
	#20000 reset = 0;
	#80000 assert (result == expected);
end

endmodule
