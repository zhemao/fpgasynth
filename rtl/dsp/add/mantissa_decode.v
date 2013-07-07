module mantissa_decode (
    sign,
    mantissa,
    denormal,
    result
);

input sign;
input [22:0] mantissa;
input denormal;
output [25:0] result;

wire [2:0] prefix = (denormal == 1'b1) ? 3'b000 : 3'b001;
wire [25:0] resultu = {prefix, mantissa};

assign result = (sign == 1) ? -resultu : resultu;

endmodule
