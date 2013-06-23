module mantissa_decode (
    sign,
    mantissa,
    result
);

input sign;
input [22:0] mantissa;
output [25:0] result;

wire [25:0] resultu = {3'b001, mantissa};

assign result = (sign == 1) ? -resultu : resultu;

endmodule
