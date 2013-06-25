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
wire [22:0] manta = dataa[22:0];
wire [22:0] mantb = datab[22:0];

wire [25:0] manta_dec;
wire [25:0] mantb_dec;

mantissa_decode mantdeca (
    .sign (signa),
    .mantissa (manta),
    .result (manta_dec)
);

mantissa_decode mantdecb (
    .sign (signb),
    .mantissa (mantb),
    .result (mantb_dec)
);

reg [7:0] expx;
reg [7:0] expy;
reg signed [25:0] mantx;
reg signed [25:0] manty;

reg expaddsub;

reg signed [8:0] expsum;
wire signed [25:0] mantsum = mantx + manty;
wire [7:0] expsumu = (expsum[8] == 1) ? -expsum[7:0] : expsum[7:0];
wire [24:0] mantsumu = (mantsum[25] == 1) ? -mantsum[24:0] : mantsum[24:0];

always @(*) begin
    if (expaddsub == 1) begin
        expsum = expx + expy;
    end else begin
        expsum = expx - expy;
    end
end

reg [25:0] shiftin;
reg [4:0] shiftby;
reg shift_dir;
wire [25:0] shiftout;

barrel_shift shifter (
    .direction (shift_dir),
    .shiftin (shiftin),
    .shiftby (shiftby),
    .shiftout (shiftout)
);

reg [23:0] encin;
wire [4:0] encout;

priority_enc encoder (
    .encoded (encin),
    .decoded (encout)
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
        expaddsub = 0;
        mantx = manta_dec;
        manty = mantb_dec;
        step <= 0;
        done <= 0;
    end else begin
        case (step)
            0: begin
                if (expsum == 0) begin
                    expr <= expx;
                    expy <= 8'd1;
                    step <= 2;
                // expsum > 0 
                end else if (expsum[8] == 0) begin
                    // expsumu < 32
                    if (expsumu[7:5] == 0) begin
                        expr <= expx;
                        expy <= 8'd1;
                        shiftin <= manty;
                        shiftby <= expsumu[4:0];
                        shift_dir <= 1;
                        step <= 1;
                    end else begin
                        expr <= expx;
                        expy <= 8'd1;
                        manty <= 0;
                        step <= 2;
                    end
                end else begin
                    // expsumu < 32
                    if (expsumu[7:5] == 0) begin
                        expr <= expy;
                        expx <= 8'd1;
                        shiftin <= mantx;
                        shiftby <= expsumu[4:0];
                        shift_dir <= 1;
                        step <= 1;
                    end else begin
                        expr <= expy;
                        expx <= 8'd1;
                        mantx <= 0;
                        step <= 2;
                    end
                end
                // computing expr + 1
                expaddsub = 1;
            end
            1: begin
                if (expsum[8] == 0) begin
                    manty <= shiftout;
                end else begin
                    mantx <= shiftout;
                end
                step <= 2;
            end
            2: if (mantsum == 0) begin
                mantr <= 0;
                expr <= 0;
                signr <= 0;
                done <= 1;
                step <= 6;
            // overflow
            end else if (mantsumu[24] == 1) begin
                signr <= mantsum[25];
                mantr <= mantsumu[23:1];
                expr <= expsumu;
                done <= 1;
                step <= 6;
            // just right
            end else if (mantsumu[23] == 1) begin
                signr <= mantsum[25];
                mantr <= mantsumu[22:0];
                done <= 1;
                step <= 6;
            end else begin
                signr <= mantsum[25];
                encin <= mantsumu[23:0];
                step <= 3;
            end
            3: begin
                shiftby <= encout;
                shiftin <= {1'b0, mantsumu};
                shift_dir <= 0;
                // expr - encout
                expx <= expr;
                expy <= {3'b0, encout};
                expaddsub <= 0;
                step <= 4;
            end
            4: begin
                mantr <= shiftout[22:0];
                expr <= expsumu;
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
