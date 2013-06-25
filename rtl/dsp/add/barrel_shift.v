module barrel_shift (
    direction,
    shiftin,
    shiftby,
    shiftout
);

// 1 means right shift, 0 means left shift
input direction;
input signed [25:0] shiftin;
input [4:0] shiftby;
output reg signed [25:0] shiftout;

always @(*) begin
    if (direction == 1) begin
        shiftout = shiftin >>> shiftby;
    end else begin
        shiftout = shiftin << shiftby;
    end
end

endmodule
