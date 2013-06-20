module fpadd (
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

output reg [31:0] result;
output reg done;

wire signa = dataa[31];
wire signb = datab[31];
wire [7:0] expa = dataa[30:23];
wire [7:0] expb = datab[30:23];
wire [23:0] manta = {1'b1, dataa[22:0]};
wire [23:0] mantb = {1'b1, datab[22:0]};

wire [7:0] expx;
wire [7:0] expy;
wire [23:0] mantx;
wire [23:0] manty;

wire [8:0] expdiff = expx - expy;
wire [24:0] mantsum = mantx + manty;
wire [7:0] expdiffu = (expdiff[8] == 1) ? (-expdiff)[7:0] : expdiff[7:0];

reg signr;
reg [7:0] expr;
reg [22:0] mantr;

assign result = {sign, expr, mantr};

reg [2:0] step;

always @(posedge clk) begin
    if (reset == 1) begin
        expx = expa;
        expy = expb;
        mantx = (signa == 1) ? -manta : manta;
        manty = (signb == 1) ? -mantb : mantb;
        step <= 0;
        done <= 0;
    end else begin
        case (step)
            0: begin
                if (expdiff == 0) begin
                    expr <= expx;
                end else if (expdiff > 0) begin
                    expr <= expx;
                    manty <= manty >> 
                end else begin
                end
                step = step + 1;
            end
        endcase;
    end
end
