module priority_enc24 (
    encoded,
    decoded
);

input [23:0] encoded;
output reg [4:0] decoded;

reg [4:0] i;

always @(*) begin
    decoded = 23;
    for (i = 0; i < 24; i = i + 1'b1) begin
        if (encoded[i] == 1) begin
            decoded = 5'd23 - i;
        end
    end
end

endmodule
