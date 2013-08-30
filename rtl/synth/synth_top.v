module synth_top (
    clk,
    reset,

    osc_ctrl_data,
    osc_ctrl_write,
    osc_ctrl_addr,
    
    aud_amp,
    aud_req,
    aud_data
);

input clk;
input reset;

input [31:0] osc_ctrl_data;
input osc_ctrl_write;
input [2:0] osc_ctrl_addr;

input [31:0] aud_amp;
input aud_req;
output reg [31:0] aud_data;

wire [15:0] osc_output [0:3];
wire [0:3] osc_done;

reg osc_next = 1'b0;

reg [31:0] osc_scale [0:3];
reg [31:0] osc_step [0:3];

always @(posedge clk) begin
    if (osc_ctrl_write == 1'b1) begin
        if (osc_ctrl_addr[2] == 1'b0)
            osc_scale[osc_ctrl_addr[1:0]] <= osc_ctrl_data;
        else
            osc_step[osc_ctrl_addr[1:0]] <= osc_ctrl_data;
    end
end

genvar ind;
generate
    for (ind = 0; ind < 4; ind = ind + 1)
    begin: osc_generate
        wave_gen osc (
            .clk (clk),
            .reset (reset),
            .req_next (osc_next),
            .aud_step (osc_step[ind]),
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

reg last_aud_req;
reg next_sample;

always @(posedge clk) begin
    last_aud_req <= aud_req;
    next_sample <= aud_req && !last_aud_req;

	if (reset == 1'b1) begin
		step <= 2'b0;
	end else case (step)
		0: if (next_sample == 1'b1) begin
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
