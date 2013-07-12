module audio_codec (
    clk,
    reset_n,
    sample_end,
    audio_output,
    audio_input,
    mono_stereo,

    AUD_ADCLRCK,
    AUD_ADCDAT,
    AUD_DACLRCK,
    AUD_DACDAT,
    AUD_BCLK
);

input clk;
input reset_n;
output sample_end;
input [15:0] audio_output;
output reg [15:0] audio_input;
// 1 is stereo, 0 is mono
input mono_stereo;

output AUD_ADCLRCK;
input AUD_ADCDAT;
output AUD_DACLRCK;
output AUD_DACDAT;
inout AUD_BCLK;

wire lrck;
wire bclk;

reg [7:0] lrck_divider;
reg [2:0] bclk_divider;

assign lrck = !lrck_divider[7];

reg [15:0] shift_out;
reg [15:0] shift_temp;
reg [15:0] shift_in_left;
reg [15:0] shift_in_right;
wire [15:0] shift_in_avg = shift_in_left[15:1] + shift_in_right[15:1];

assign AUD_ADCLRCK = lrck;
assign AUD_DACLRCK = lrck;
assign AUD_BCLK = bclk_divider[2];
assign AUD_DACDAT = shift_out[15];

always @(posedge clk) begin
    if (reset_n == 0) begin
        lrck_divider <= 8'hff;
        bclk_divider <= 3'b111;
    end else begin
        lrck_divider <= lrck_divider + 1'b1;
        bclk_divider <= bclk_divider + 1'b1;
    end
end

assign sample_end = (lrck_divider == 8'h7e && mono_stereo == 1'b1 || 
                        lrck_divider == 8'hfe) ? 1'b1 : 1'b0;

wire clr_lrck = (lrck_divider == 8'h7f) ? 1'b1 : 1'b0;
wire set_lrck = (lrck_divider == 8'hff) ? 1'b1 : 1'b0;
wire set_bclk = (bclk_divider == 3'b011) ? 1'b1 : 1'b0;
wire clr_bclk = (bclk_divider == 3'b111) ? 1'b1 : 1'b0;

always @(*) begin
    if (mono_stereo == 1) begin
        if (lrck == 1) begin
            audio_input <= shift_in_left;
        end else begin
            audio_input <= shift_in_right;
        end
    end else begin
        audio_input <= shift_in_avg;
    end
end

always @(posedge clk) begin
    if (reset_n == 0) begin
        shift_out <= 16'h0;
        shift_in_left <= 16'h0;
        shift_in_right <= 16'h0;
    end else if (set_lrck == 1) begin
        shift_out <= audio_output;
        shift_temp <= audio_output;
        shift_in_left <= 16'h0;
        shift_in_right <= 16'h0;
    end else if (clr_lrck == 1) begin
        if (mono_stereo == 1) begin
            // if stereo, pull from audio_output again
            shift_out <= audio_output;
        end else begin
            // if mono, restore from shift_temp
            shift_out <= shift_temp;
        end
    end else if (set_bclk == 1) begin
        if (lrck == 1) begin
            shift_in_left <= {shift_in_left[14:0], AUD_ADCDAT};
        end else begin
            shift_in_right <= {shift_in_right[14:0], AUD_ADCDAT};
        end
    end else if (clr_bclk == 1) begin
        shift_out <= {shift_out[14:0], 1'b0};
    end
end

endmodule
