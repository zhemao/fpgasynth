module priority_enc15 (
    encoded,
    decoded
);

input [14:0] encoded;
output reg [3:0] decoded;

reg [3:0] i;

always @(*) begin
    decoded = 4'd14;
    for (i = 4'd0; i < 15; i = i + 1'b1) begin
        if (encoded[i] == 1) begin
            decoded = 4'd14 - i;
        end
    end
end

endmodule
