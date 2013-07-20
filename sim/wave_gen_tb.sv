module wave_gen_tb ();

reg clk = 1'b1;
reg reset;
reg aud_req;

parameter aud_step = 32'h3d18aead, 
          aud_primscale = 32'h437f0000, 
          aud_secscale = 32'h3f800000;

wire [15:0] aud_data;
wire aud_done;

wave_gen generator (
	.clk (clk),
	.reset (reset),
	.aud_req (aud_req),
	.aud_step (aud_step),
	.aud_primscale (aud_primscale),
	.aud_secscale (aud_secscale),
	.aud_data (aud_data),
	.aud_done (aud_done)
);

always #10000 clk = !clk;

parameter MAX_STEPS = 169;

integer step;

initial begin
	aud_req <= 1'b0;
	reset <= 1'b1;
	#20000 reset <= 1'b0;
	for (step = 0; step < MAX_STEPS; step++) begin
		aud_req <= 1'b1;
		#20000 aud_req <= 1'b0;
		#22675737 assert (aud_done == 1'b1);
	end
end

endmodule
