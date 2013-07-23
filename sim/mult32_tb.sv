module mult32_tb ();

reg clk = 0;
reg reset;
reg [31:0] dataa = 32'd1507328;
reg [31:0] datab = 32'd4325;
wire [63:0] result;
wire done;

parameter expected = 64'd6519193600;

always #10000 clk = !clk;

mult32 mult (
	.clk (clk),
	.reset (reset),
	.dataa (dataa),
	.datab (datab),
	.result (result),
    .done (done)
);

initial begin
	reset = 1;
	#20000 reset = 0; // 20 ns
	#120000 assert (done == 1'b1);
    assert (result == expected); // 140000 ns
end

endmodule
