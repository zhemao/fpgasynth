module fpmult (
    clk,
    reset,
    dataa,
    datab,
    result
);

input clk;
input reset;
input [31:0] dataa;
input [31:0] datab;

output [31:0] result;

reg [2:0] step;

reg sign;
reg mult_reset;

reg [23:0] manta;
reg [23:0] mantb;

reg [7:0] expa;
reg [7:0] expb;
reg [7:0] expr;

wire [47:0] mantp;
reg  [22:0] mantr;

assign result = {sign, expr, mantr};

mult32 intmult (
    .clk (clk),
    .reset (mult_reset),
    .dataa (manta),
    .datab (mantb),
    .result (mantp),
);

always @(posedge clk) begin
    if (reset == 1) begin
        step = 0;
    end else if (step != 6) begin
        step = step + 1;
    end
end

always @(posedge clk) begin
    case (step)
        0: begin
            sign <= dataa[31] ^ datab[31];
            expa <= dataa[30:23];
            expb <= datab[30:23];
            manta <= {1'b1, dataa[22:0]};
            mantb <= {1'b1, datab[22:0]};
            mult_reset <= 1;
        end
        1: begin 
            expr <= expa + expb;
            mult_reset <= 0;
        end
        2: expr = expr - 127;
        5: if (mantp[47] == 1'b1) begin
            mantr <= mantp[46:24];
            expr <= expr + 1;
        end else begin
            mantr <= mantp[45:23];
        end
        default : begin
            mantr <= mantr;
            expr <= expr;
        end
    endcase
end

endmodule
