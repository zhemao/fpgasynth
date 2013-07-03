module fpmult_tb ();

reg [31:0] dataa [3:0];
reg [31:0] datab [3:0];
wire [31:0] result;

reg clk = 1;
reg reset;
wire done;

reg [2:0] ind;

fpmult mult (
	.clk (clk),
	.reset (reset),
	.dataa (dataa[ind]),
	.datab (datab[ind]),
	.result (result),
	.done (done)
);

reg [31:0] expected [3:0];

always #10000 clk = !clk;

initial begin
	dataa[0] = 32'h40000000; // 2.0
	dataa[1] = 32'hbfa00000; // -1.25
	dataa[2] = 32'h00000000; // 0
	dataa[3] = 32'hc0400000; // -3.0
	datab[0] = 32'h40400000; // 3.0
	datab[1] = 32'h3fc00000; // 1.5
	datab[2] = 32'h40000000; // 2
	datab[3] = 32'hc0300000; // -2.75
	expected[0] = 32'h40c00000; // 6.0
	expected[1] = 32'hbff00000; // -1.875
	expected[2] = 32'h00000000; // 0
	expected[3] = 32'h41040000; // 8.25
	for (ind = 0; ind < 4; ind++) begin
		reset = 1;
		#20000 reset = 0;
		#120000 assert(done == 1);
		assert(result == expected[ind]);
	end
end

endmodule
