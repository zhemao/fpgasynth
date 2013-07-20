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

reg [31:0] osc_steps [0:4];

wire [31:0] osc_output [0:4];
wire [0:4] osc_done;

genvar ind;
generate
for (ind = 0; ind < 4; ind = ind + 1) 
    begin: osc_generate
    wave_gen osc (
        .clk (clk),
        .reset (reset),
        .aud_req (aud_req),
        .aud_step (osc_steps[ind]),
        .aud_primscale (osc_scale[ind]),
        .aud_secscale (aud_amp),
        .aud_data (osc_output[ind]),
        .aud_done (osc_done[ind])
    );
end
endgenerate

endmodule
