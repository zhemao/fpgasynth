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

reg [7:0] expa;
reg [7:0] expb;
reg [8:0] expr;

wire [63:0] mantp;
reg  [22:0] mantr;

assign result = {sign, expr[7:0], mantr};

mult32 intmult (
    .clk (clk),
    .reset (mult_reset),
    .dataa (manta),
    .datab (mantb),
    .result (mantp)
);

parameter last_step = 6;

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
                expa <= dataa[30:23];
                expb <= datab[30:23];
                manta <= {9'b1, dataa[22:0]};
                mantb <= {9'b1, datab[22:0]};
                mult_reset <= 1;
                step = step + 1;
            end
            1: begin 
                expr <= expa + expb;
                mult_reset <= 0;
                step = step + 1;
            end
            2: if (expr[8:7] == 2'b00) begin // underflow (expr <= 127)
                expr <= 0;
                mantr <= 0;
                done <= 1;
                step = last_step;
            end else begin
                expr <= expr - 127;
                step = step + 1;
            end
            3: if (expr[8] == 1'b1) begin // overflow (expr >= 256)
                expr <= {9 {1'b1}};
                mantr <= 0;
                done <= 1;
                step = last_step;
            end else begin
                step = step + 1;
            end
            5: if (mantp[47] == 1'b1) begin
                mantr <= mantp[46:24];
                expr <= expr + 1;
                done <= 1;
                step = step + 1;
            end else begin
                mantr <= mantp[45:23];
                done <= 1;
                step = step + 1;
            end
            last_step: done = 1;
            default: step = step + 1;
        endcase
    end
end

endmodule
