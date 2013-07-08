module fpcomp (
    dataa,
    datab,
    leq,
    geq
);

input [31:0] dataa;
input [31:0] datab;

output leq; // less than or equal to
output geq; // greater than or equal to

wire signa = dataa[31];
wire signb = datab[31];

wire [7:0] expa = dataa[30:23];
wire [7:0] expb = datab[30:23];

wire [22:0] manta = dataa[22:0];
wire [22:0] mantb = datab[22:0];

wire signed [8:0] expdiff = expa - expb;
wire signed [23:0] mantdiff = manta - mantb;

reg [1:0] result;

assign geq = result[1];
assign leq = result [0];

always @(*) begin
    // zero and negative zero are supposed to be equal
    if (dataa[30:0] == 0 && datab[30:0] == 0) begin
        result <= 2'b11;
    end else if (signa != signb) begin
        // a is positive, b is negative
        if (signa == 0) begin
            result <= 2'b10;
        // a is negative, b is positive
        end else begin
            result <= 2'b01;
        end
    end else if (expdiff == 0) begin
        // a == b
        if (mantdiff == 0) begin
            result <= 2'b11;
        // a > b
        end else if (mantdiff[8] == 0) begin
            // invert if signs are negative
            result <= 2'b10 ^ {2 {signa}};
        end else begin
            result <= 2'b01 ^ {2 {signa}};
        end
    // a > b
    end else if (expdiff[8] == 0) begin
        result <= 2'b10 ^ {2 {signa}};
    end else begin
        result <= 2'b01 ^ {2 {signa}};
    end
end

endmodule
