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

output [31:0] result;
output reg done;

wire signa = dataa[31];
wire signb = datab[31];
wire [7:0] expa = dataa[30:23];
wire [7:0] expb = datab[30:23];
wire [25:0] manta = {3'b001, dataa[22:0]};
wire [25:0] mantb = {3'b001, datab[22:0]};

reg [7:0] expx;
reg [7:0] expy;
reg [25:0] mantx;
reg [25:0] manty;

wire [8:0] expdiff = expx - expy;
wire [25:0] mantsum = mantx + manty;
wire [7:0] expdiffu = (expdiff[8] == 1) ? -expdiff[7:0] : expdiff[7:0];
wire [24:0] mantsumu = (mantsum[25] == 1) ? -mantsum[24:0] : mantsum[24:0];

wire [31:0] mantx_ext = {{6 {mantx[25]}}, mantx};
wire [31:0] manty_ext = {{6 {manty[25]}}, manty};

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

reg [31:0] encin;
wire [4:0] encout;
wire enctrig;

priority_enc encoder (
    .encoded (encin),
    .decoded (encout),
    .triggered (enctrig)
);

reg signr;
reg [7:0] expr;
reg [22:0] mantr;

assign result = {signr, expr, mantr};

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
                    shift_dir <= 1;
                    shift_type <= 1;
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
                    shift_dir <= 1;
                    shift_type <= 1;
                    step <= 1;
                end else begin
                    expr <= expy;
                    mantx <= 0;
                    step <= 2;
                end
            end
            1: begin
                if (expdiff[8] == 0) begin
                    manty <= shiftout[25:0];
                end else begin
                    mantx <= shiftout[25:0];
                end
                // computing expr + 1
                expx <= expr;
                expy <= -8'd1;
                step <= 2;
            end
            2: if (mantsum == 0) begin
                mantr <= 0;
                expr <= 0;
                signr <= 0;
                done <= 1;
                step <= 6;
            end else if (mantsumu[24] == 1) begin
                signr <= mantsum[25];
                mantr <= mantsumu[23:1];
                expr <= expdiff[7:0];
                done <= 1;
                step <= 6;
            end else begin
                signr <= mantsum[25];
                encin <= {6'd0, mantsumu};
                step <= 3;
            end
            3: if (encout == 0) begin
                done <= 1;
                step <= 6;
            end else begin
                shiftby <= 23 - encout;
                shiftin <= mantsumu;
                shift_dir <= 0;
                shift_type <= 0;
                step <= 4;
            end
            4: begin
                // expr + shiftby
                expx <= expr;
                expy <= -shiftby;
                step <= 5;
            end
            5: begin
                mantr <= shiftout[22:0];
                expr <= expdiff[7:0];
                done <= 1;
                step <= 6;
            end
            default: begin
                done = 1;
            end
        endcase
    end
end

endmodule
