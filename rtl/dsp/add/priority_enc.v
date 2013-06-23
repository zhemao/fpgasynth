module priority_enc (
    encoded,
    decoded,
    triggered
);

input [23:0] encoded;
output reg [4:0] decoded;
output reg triggered;

reg signed [5:0] i;

always @(*) begin
    if (encoded == 0) begin
        decoded = 23;
        triggered = 0;
    end else begin
        triggered = 1;
        for (i = 23; i >= 0; i = i - 1) begin
            if (encoded[i] == 1)
                decoded = 23 - i;
        end
    end
end

endmodule
