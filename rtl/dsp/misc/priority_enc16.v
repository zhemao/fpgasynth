module priority_enc16 (
    encoded,
    decoded
);

input [15:0] encoded;
output reg [3:0] decoded;

reg [4:0] i;

always @(*) begin
    decoded = 4'd15;
    for (i = 4'd0; i < 16; i = i + 1'b1) begin
        if (encoded[i] == 1) begin
            decoded = 4'd15 - i[3:0];
        end
    end
end

endmodule
