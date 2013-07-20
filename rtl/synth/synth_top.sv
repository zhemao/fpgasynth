module synth_top (
    clk,
    reset,

    osc_scale,
    aud_amp,
    aud_step,
    
    aud_req,
    aud_data
);

input clk;
input reset;

input [31:0] osc_scale [0:3];

input [31:0] aud_amp;
input [31:0] aud_step;
input aud_req;
output reg [31:0] aud_data;

wire [31:0] osc_output [0:4];
wire [0:4] osc_done;

reg osc_next = 1'b0;

genvar ind;
generate
for (ind = 0; ind < 4; ind = ind + 1)
    begin: osc_generate

    wire [7:0] exp = aud_step[30:23] + ind;
    wire [31:0] osc_step = {aud_step[31], exp, aud_step[22:0]};

    wave_gen osc (
        .clk (clk),
        .reset (reset),
        .req_next (osc_next),
        .aud_step (osc_step),
        .aud_primscale (osc_scale[ind]),
        .aud_secscale (aud_amp),
        .aud_data (osc_output[ind]),
        .aud_done (osc_done[ind])
    );
end
endgenerate

reg [2:0] step;

reg [15:0] arga;
reg [15:0] argb;
wire [15:0] sum_res = arga + argb;
reg [15:0] sum_temp;

always @(posedge clk) begin
	if (reset == 1'b1) begin
		step <= 2'b0;
	end else case (step)
		0: if (aud_req == 1'b1) begin
			aud_data <= sum_temp;
			osc_next <= 1'b1;
			step <= 3'd1;
		end
		1: begin
			osc_next <= 1'b0;
			if (osc_done == 4'b1111) begin
				arga <= osc_output[0];
				argb <= osc_output[1];
				step <= 3'd2;
			end
		end
		2: begin
			sum_temp <= sum_res;
			arga <= osc_output[2];
			argb <= osc_output[3];
			step <= 3'd3;
		end
		3: begin
			arga <= sum_temp;
			argb <= sum_res;
			step <= 3'd4;
		end
		4: begin
			sum_temp <= sum_res;
			step <= 3'd0;
		end
	endcase
end

endmodule
