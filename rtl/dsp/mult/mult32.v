module mult32 (
    clk,
    reset,
    dataa,
    datab,
    result
);

input clk;
input reset;
input [31:0] dataa;
input [31:0] datab;
output reg [63:0] result;

reg [15:0] alow;
reg [15:0] blow;
reg [15:0] ahigh;
reg [15:0] bhigh;

reg [15:0] ax;
reg [15:0] bx;
wire [31:0] rx;

reg [15:0] ay;
reg [15:0] by;
wire [31:0] ry;

mult16 multx (
	.dataa (ax),
	.datab (bx),
	.result (rx)
);

mult16 multy (
	.dataa (ay),
	.datab (by),
	.result (ry)
);

reg [63:0] lh;
reg [63:0] hl;
reg [63:0] hhll;
reg [63:0] lhhl;

reg [1:0] step;

always @(posedge clk) begin
    if (reset == 1) begin
        step = 0;
    end else if (step != 3) begin
        step = step + 1;
    end
end

always @(*) begin
    case (step)
    0: begin
        ax <= alow;
        bx <= bhigh;
        ay <= ahigh;
        by <= blow;
    end
    1: begin
        ax <= ahigh;
        bx <= bhigh;
        ay <= alow;
        by <= blow;
    end
    default: begin
        ax <= 0;
        bx <= 0;
        ay <= 0;
        by <= 0;
    end
    endcase
end

always @(posedge clk) begin
	case (step)
	0: begin
		alow <= dataa[15:0];
		ahigh <= dataa[31:16];
		blow <= datab[15:0];
		bhigh <= datab[31:16];
	end
    1: begin
        lh <= {16'h0, rx, 16'h0}; 
        hl <= {16'h0, ry, 16'h0}; 
    end
    2: begin
        hhll <= {rx, ry};
        lhhl <= lh + hl;
    end
    3: begin
        result <= hhll + lhhl;
    end
	endcase
end

endmodule
