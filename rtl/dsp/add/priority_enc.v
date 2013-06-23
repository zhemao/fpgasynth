module priority_enc (
    encoded,
    decoded,
    triggered
);

input [31:0] encoded;
output reg [4:0] decoded;
output reg triggered;

reg signed [5:0] i;

always @(*) begin
    if (encoded == 0) begin
        decoded = 0;
        triggered = 0;
    end else begin
        triggered = 1;
        for (i = 31; i >= 0; i = i - 1) begin
            if (encoded[i[4:0]] == 1)
                decoded = i[4:0];
        end
    end
end

endmodule
