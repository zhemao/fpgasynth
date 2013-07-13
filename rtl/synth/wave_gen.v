module wave_gen (
    clk,
    reset,
    aud_req,
    aud_step,
    aud_amp,
    aud_data
);

input clk;
input reset;
input aud_req;
input [31:0] aud_step;
input [31:0] aud_amp;

output reg [15:0] aud_data;

parameter NEGPI = 32'hc0490fdb, HALFPI = 32'h3fc90fdb;

reg [31:0] theta;

wire overshoot;

fpcomp magcomp (
    .dataa (theta),
    .datab (HALFPI),
    .geq (overshoot)
);

reg sum_in_sel;
reg sum_reset;

wire [31:0] sum_datab = (sum_in_sel == 1'b1) ? aud_step : NEGPI;
wire [31:0] sum_result;
wire sum_done;

fpadd summer (
    .clk (clk),
    .reset (sum_reset),
    .dataa (theta),
    .datab (sum_datab),
    .result (sum_result),
    .done (sum_done)
);

reg sin_reset;

parameter SIN_PREC = 4'h9;

wire [31:0] sin_result;
wire sin_done;

sin sinunit (
    .clk (clk),
    .reset (sin_reset),
    .theta (theta),
    .prec (SIN_PREC),
    .result (sin_result),
    .done (sin_done)
);

reg [31:0] base_samp;


reg mult_reset;
wire [31:0] mult_result;
wire mult_done;

fpmult scaler (
    .clk (clk),
    .reset (mult_reset),
    .dataa (base_samp),
    .datab (aud_amp),
    .result (mult_result),
    .done (mult_done)
);

reg [31:0] scaled_samp;
wire [15:0] conv_result;
reg conv_reset;
wire conv_done;

floattoint conv (
    .clk (clk),
    .reset (conv_reset),
    .floatin (scaled_samp),
    .intout (conv_result),
    .done (conv_done)
);

reg [15:0] next_samp;

wire [3:0] all_done = {sum_done, sin_done, mult_done, conv_done};
reg [3:0] last_done;
reg [3:0] done_trigger;

reg [1:0] sum_state;
reg [1:0] sin_state;
reg [1:0] scale_state;

parameter WAIT = 2'b00, TRIGGER = 2'b01, CHECK_OVERSHOOT = 2'b10;

// handle sum
always @(posedge clk) begin
    last_done <= all_done;
    done_trigger <= !last_done & all_done;
    
    if (reset == 1'b1) begin
        sum_state <= WAIT;
        sin_state <= WAIT;
        scale_state <= WAIT;
        theta <= 32'h0;
        base_samp <= 32'h0;
        scaled_samp <= 32'h0;
        next_samp <= 16'h0;
        aud_data <= 16'h0;
    end else begin
        case (sum_state)
        WAIT :  if (aud_req == 1'b1) begin
            sum_reset <= 1'b1;
            sum_in_sel <= 1'b1;
            sum_state <= TRIGGER;
        end else if (done_trigger[3] == 1'b1) begin
            sum_state <= CHECK_OVERSHOOT;
            theta <= sum_result;
        end
        TRIGGER : begin
            sum_reset <= 1'b0;
            sum_state <= WAIT;
        end
        CHECK_OVERSHOOT : if (overshoot == 1'b1) begin
            sum_in_sel <= 1'b1;
            sum_reset <= 1'b1;
            sum_state <= TRIGGER;
        end
        endcase
        case (sin_state)
        WAIT : if (aud_req == 1'b1) begin
            sin_reset <= 1'b1;
            sin_state <= TRIGGER;
        end else if (done_trigger[2]) begin
            base_samp <= sin_result;
        end
        TRIGGER : begin
            sin_reset <= 1'b0;
            sin_state <= WAIT;
        end
        endcase
        case (scale_state)
        WAIT : if (aud_req == 1'b1) begin
            mult_reset <= 1'b1;
            scale_state <= TRIGGER;
            aud_data <= next_samp;
        // mult is finished
        end else if (done_trigger[1] == 1'b1) begin
            scaled_samp <= mult_result;
            conv_reset <= 1'b1;
            scale_state <= TRIGGER;
        end else if (done_trigger[0] == 1'b1) begin
            next_samp <= conv_result;
        end
        TRIGGER : begin
            mult_reset <= 1'b0;
            conv_reset <= 1'b0;
            scale_state <= WAIT;
        end
        endcase
    end
end

endmodule
