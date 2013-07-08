module floattoint (
    floatin,
    intout
);

input [31:0] floatin;
output signed [15:0] intout;

wire sign = floatin[31];
wire [7:0] exp = floatin[30:23];
wire [23:0] mant = {1'b1, floatin[22:0]};

reg [23:0] mant_res;
wire signed [15:0] resultu = {1'b0, mant_res[23:9]};
assign intout = (sign == 1) ? -resultu : resultu;

wire signed [8:0] shiftby = 9'd141 - exp;

always @(*) begin
    if (exp == 8'h7f) begin // (exp == 127)
        mant_res = {15'b1, 9'b0}; // truncate to 1
    end else if (exp[7] == 1'b0) begin // (exp <= 127)
        mant_res = 23'h0; //truncate to 0
    // (exp <= 142)
    end else if (shiftby == 0) begin
        mant_res = mant;
    end else if (shiftby[8] == 0) begin
        mant_res = mant >> shiftby;
    end else begin
        mant_res = {24 {1'b1}};
    end
end

endmodule
