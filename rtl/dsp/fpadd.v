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
wire [24:0] manta = {2'b01, dataa[22:0]};
wire [24:0] mantb = {2'b01, datab[22:0]};

wire [7:0] expx;
wire [7:0] expy;
wire [24:0] mantx;
wire [24:0] manty;

wire [8:0] expdiff = expx - expy;
wire [24:0] mantsum = mantx + manty;
wire [7:0] expdiffu = (expdiff[8] == 1) ? (-expdiff)[7:0] : expdiff[7:0];
wire [23:0] mantsumu = (mantsum[24] == 1) ? (-mantsum)[23:0] : mantsum[23:0];

wire [31:0] mantx_ext = {{7 {mantx[24]}}, mantx};
wire [31:0] manty_ext = {{7 {manty[24]}}, manty};

reg [31:0] shiftin;
reg [4:0] shiftby;
reg shift_dir;
reg shift_type;
wire [31:0] shiftout;

barrel_shift shifter (
    .direction (shift_dir),
    .type (shift_type),
    .shiftin (shiftin),
    .shiftby (shiftby),
    .shiftout (shiftout)
);

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
            0: if (expdiff == 0) begin
                expr <= expx;
                step <= 2;
            // expdiff > 0 
            end else if (expdiff[8] == 0) begin
                // expdiffu < 32
                if (expdiffu[7:5] == 0) begin
                    expr <= expx;
                    shiftin <= manty_ext;
                    shiftby <= expdiffu[4:0];
                    direction <= 1;
                    type <= 1;
                    step <= 1;
                end else begin
                    expr <= expx;
                    manty <= 0;
                    step <= 2;
                end
            end else begin
                // expdiffu < 32
                if (expdiffu[7:5] == 0) begin
                    expr <= expy;
                    shiftin <= mantx_ext;
                    shiftby <= expdiffu[4:0];
                    direction <= 1;
                    step <= 1;
                end else begin
                    expr <= expy;
                    mantx <= 0;
                    step <= 2;
                end
            end
            1: begin
                if (expdiff[8] == 0) begin
                    manty = shiftout;
                end else begin
                    mantx = shiftout;
                end
                step = 2;
            end
            2: begin
                
            end
            default: begin
                step = step;
            end
        endcase;
    end
end

endmodule
