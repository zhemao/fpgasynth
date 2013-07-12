module fpmult (
    clk,
    reset,
    dataa,
    datab,
    result,
    done
);

input clk;
input reset;
input [31:0] dataa;
input [31:0] datab;

output [31:0] result;
output reg done;

reg [2:0] step;

reg sign;
reg mult_reset;

reg [31:0] manta;
reg [31:0] mantb;

reg [8:0] expa;
reg [8:0] expb;
reg [8:0] expr;
wire [8:0] exps;

wire [63:0] mantp;
reg  [22:0] mantr;

assign exps = expa + expb;
assign result = {sign, expr[7:0], mantr};

mult32 intmult (
    .clk (clk),
    .reset (mult_reset),
    .dataa (manta),
    .datab (mantb),
    .result (mantp)
);

parameter last_step = 3'd6;

always @(posedge clk) begin
    if (reset == 1) begin
        step = 0;
        done = 0;
    end else begin
        case (step)
            // if either of the two factors is 0, product is 0
            0: if (dataa[30:0] == 0 || datab[30:0] == 0) begin
                mantr <= 0;
                expr <= 0;
                sign <= dataa[31] ^ datab[31];
                done <= 1;
                step = last_step;
            end else begin
                sign <= dataa[31] ^ datab[31];
                expa <= {1'b0, dataa[30:23]};
                expb <= {1'b0, datab[30:23]};
                manta <= {9'b1, dataa[22:0]};
                mantb <= {9'b1, datab[22:0]};
                mult_reset <= 1;
                step = step + 1'b1;
            end
            1: begin
                mult_reset <= 0;
                if (exps[8:7] == 2'b00) begin // underflow (expr <= 127)
                    expr <= 0;
                    mantr <= 0;
                    done <= 1;
                    step = last_step;
                end else begin
                    expa <= exps;
                    expb <= -9'd127;
                    step = step + 1'b1;
                end
            end
            2: if (exps[8] == 1'b1) begin // overflow (expr >= 256)
                expr <= {9 {1'b1}};
                mantr <= 0;
                done <= 1;
                step = last_step;
            end else begin
                expr <= exps;
                expa <= exps;
                expb <= 1;
                step = step + 1'b1;
            end
            5: if (mantp[47] == 1'b1) begin
                mantr <= mantp[46:24];
                expr <= exps;
                done <= 1;
                step = step + 1'b1;
            end else begin
                mantr <= mantp[45:23];
                done <= 1;
                step = step + 1'b1;
            end
            last_step: done = 1;
            default: step = step + 1'b1;
        endcase
    end
end

endmodule
