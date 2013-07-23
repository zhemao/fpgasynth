module mult32 (
    clk,
    reset,
    dataa,
    datab,
    result,
    done
);

input clk;
input reset;
input [31:0] dataa;
input [31:0] datab;
output reg [63:0] result;
output done;

reg [15:0] alow;
reg [15:0] blow;
reg [15:0] ahigh;
reg [15:0] bhigh;

reg [15:0] multa;
reg [15:0] multb;
wire [31:0] multr;

mult16 mult (
	.dataa (multa),
	.datab (multb),
	.result (multr)
);

reg [63:0] suma;
reg [63:0] sumb;
wire [63:0] sumr = suma + sumb;

reg [2:0] step;

assign done = (step == 6) ? 1'b1 : 1'b0;

always @(posedge clk) begin
    if (reset == 1) begin
        step = 0;
    end else if (step != 6) begin
        step = step + 1'b1;
    end
	
    case (step)
	0: begin
		alow <= dataa[15:0];
		ahigh <= dataa[31:16];
		blow <= datab[15:0];
		bhigh <= datab[31:16];

        multa <= dataa[15:0];
        multb <= datab[31:16];
	end
    1: begin
        suma <= {16'h0, multr, 16'h0}; 
        multa <= ahigh;
        multb <= blow;
    end
    2: begin
        sumb <= {16'h0, multr, 16'h0}; 
        multa <= alow;
        multb <= blow;
    end
    3: begin
        suma <= sumr;
        sumb[31:0] <= multr;
        multa <= ahigh;
        multb <= bhigh;
    end
    4: begin
        sumb[63:32] <= multr;
    end
    5: begin
        result <= sumr;
    end
	endcase
end

endmodule
