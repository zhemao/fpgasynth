module barrel_shift (
    direction,
    type,
    shiftin,
    shiftby,
    shiftout
);

// 1 means right shift, 0 means left shift
input direction;
// 1 means arithmetic, 0 means logical
input type;
input [31:0] shiftin;
input [4:0] shiftby;
output reg [31:0] shiftout;

always @(*) begin
    if (direction == 1) begin
        if (type == 1) begin
            shiftout = shiftin >> shiftby;
        end else begin
            shiftout = shiftin >>> shiftby;
        end
    end else begin
        shiftout = shiftin << shiftby;
    end
end

endmodule
