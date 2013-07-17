module wave_gen (
    clk,
    reset,
    aud_req,
    aud_step,
    aud_amp,
    aud_data,
    aud_done
);

input clk;
input reset;
input aud_req;
input [31:0] aud_step;
input [31:0] aud_amp;

output reg [15:0] aud_data;
output aud_done;

parameter NEGPI = 32'hc0490fdb, HALFPI = 32'h3fc90fdb;

reg [31:0] theta;

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

wire overshoot;
wire _unused;

fpcomp magcomp (
    .dataa (sum_result),
    .datab (HALFPI),
    .geq (overshoot),
    .leq (_unused)
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

reg [2:0] sum_state;
reg [2:0] sin_state;
reg [2:0] scale_state;

parameter WAIT_BEGIN = 3'b000, TRIGGER_BEGIN = 3'b001, 
          WAIT_MIDDLE = 3'b010, TRIGGER_MIDDLE = 3'b011,
          WAIT_END = 3'b100;

wire sum_finished = (sum_state == WAIT_BEGIN) ? 1'b1 : 1'b0;
wire sin_finished = (sin_state == WAIT_BEGIN) ? 1'b1 : 1'b0;
wire scale_finished = (scale_state == WAIT_BEGIN) ? 1'b1 : 1'b0;

assign aud_done = sum_finished & sin_finished & scale_finished;

// handle sum
always @(posedge clk) begin
    if (reset == 1'b1) begin
        sum_state <= WAIT_BEGIN;
        sin_state <= WAIT_BEGIN;
        scale_state <= WAIT_BEGIN;
        theta <= 32'h0;
        base_samp <= 32'h0;
        scaled_samp <= 32'h0;
        next_samp <= 16'h0;
        aud_data <= 16'h0;
    end else begin
        case (sum_state)
        WAIT_BEGIN :  if (aud_req == 1'b1) begin
            sum_reset <= 1'b1;
            sum_in_sel <= 1'b1;
            sum_state <= TRIGGER_BEGIN;
        end
        TRIGGER_BEGIN : begin
            sum_reset <= 1'b0;
            sum_state <= WAIT_MIDDLE;
        end
        WAIT_MIDDLE : if (sum_done == 1'b1) begin
            theta <= sum_result;
            if (overshoot == 1'b1) begin
                sum_in_sel <= 1'b0;
                sum_reset <= 1'b1;
                sum_state <= TRIGGER_MIDDLE;
            end else begin
                sum_state <= WAIT_BEGIN;
            end
        end
        TRIGGER_MIDDLE : begin
            sum_reset <= 1'b0;
            sum_state <= WAIT_END;
        end
        WAIT_END : if (sum_done == 1'b1) begin
            theta <= sum_result;
            sum_state <= WAIT_BEGIN;
        end
        endcase
        
        case (sin_state)
        WAIT_BEGIN : if (aud_req == 1'b1) begin
            sin_reset <= 1'b1;
            sin_state <= TRIGGER_BEGIN;
        end
        TRIGGER_BEGIN : begin
            sin_reset <= 1'b0;
            sin_state <= WAIT_END;
        end
        WAIT_END : if (sin_done == 1'b1) begin
            base_samp <= sin_result;
            sin_state <= WAIT_BEGIN;
        end
        endcase
        
        case (scale_state)
        WAIT_BEGIN : if (aud_req == 1'b1) begin
            mult_reset <= 1'b1;
            scale_state <= TRIGGER_BEGIN;
            aud_data <= next_samp;
        end
        TRIGGER_BEGIN : begin
            mult_reset <= 1'b0;
            scale_state <= WAIT_MIDDLE;
        end
        WAIT_MIDDLE : if (mult_done == 1'b1) begin
            scaled_samp <= mult_result;
            conv_reset <= 1'b1;
            scale_state <= TRIGGER_MIDDLE;
        end
        TRIGGER_MIDDLE : begin
            conv_reset <= 1'b0;
            scale_state <= WAIT_END;
        end
        WAIT_END : if (conv_done == 1'b1) begin
            next_samp <= conv_result;
            scale_state <= WAIT_BEGIN;
        end
        endcase
    end
end

endmodule
