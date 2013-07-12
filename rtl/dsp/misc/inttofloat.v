module inttofloat (
    clk,
    reset,
    intin,
    floatout,
    done
);

input clk;
input reset;
input [15:0] intin;
output [31:0] floatout;
output done;

reg sign;
reg [7:0] exp;
reg [15:0] intinu;

wire [3:0] shiftby;

priority_enc16 encoder (
    .encoded (intinu),
    .decoded (shiftby)
);

reg finished;

assign floatout = {sign, exp, intinu[14:0], 8'b0};
assign done = finished;

always @(posedge clk) begin
    if (reset == 1) begin
        if (intin == 0) begin
            sign <= 1'b0;
            intinu <= 15'd0;
            exp <= 8'd0;
            finished <= 1'b1;
        end else begin
            sign <= intin[15];
            intinu <= (intin[15] == 1) ? -intin : intin;
            finished <= 1'b0;
        end
    end else if (finished == 0) begin
        intinu <= intinu << shiftby;
        exp <= 8'd142 - shiftby;
        finished <= 1'b1;
    end
end

endmodule
