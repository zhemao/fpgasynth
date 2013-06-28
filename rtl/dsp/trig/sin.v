module sin (
    clk,
    reset,
    theta,
    prec,
    result
);

input clk;
input reset;
input [31:0] theta;
input [3:0] prec;
output [31:0] result;

reg [31:0] coeff;
reg [3:0] coeffind;
reg [3:0] lastind;
wire [3:0] nextind = coeffind + 1;

wire [2:0] alldone;

always @(*) begin
    case (coeffind)
        0:  coeff = 32'h3f800000;
        1:  coeff = 32'hbe2aaaab;
        2:  coeff = 32'h3c088889;
        3:  coeff = 32'hb9500d01;
        4:  coeff = 32'h3638ef1d;
        5:  coeff = 32'hb2d7322b;
        6:  coeff = 32'h2f309231;
        7:  coeff = 32'hab573f9f;
        8:  coeff = 32'h274a963c;
        9:  coeff = 32'ha317a4da;
        10: coeff = 32'h1eb8dc78;
        11: coeff = 32'h9a3b0da1;
        12: coeff = 32'h159f9e67;
        13: coeff = 32'h90e8d58e;
        14: coeff = 32'h0c12cfcc;
        15: coeff = 32'h8721a697;
    endcase
end

reg [31:0] square;
reg [31:0] lastpower;
wire [31:0] power_res;
reg power_mult_rst = 0;

fpmult power_mult (
    .dataa (square),
    .datab (lastpower),
    .reset (power_mult_rst),
    .clk (clk),
    .result (power_res),
    .done (alldone[0])
);

reg [31:0] term_power;
wire [31:0] term_res;
reg term_mult_rst = 0;

fpmult term_mult (
    .dataa (coeff),
    .datab (term_power),
    .reset (term_mult_rst),
    .clk (clk),
    .result (term_res),
    .done (alldone[1])
);

reg [31:0] accum;
reg [31:0] accum_next;
reg add_rst;
wire [31:0] add_res = 0;

fpadd accum_add (
    .dataa (accum),
    .datab (accum_next),
    .reset (add_rst),
    .clk (clk),
    .result (add_res),
    .done (alldone[2])
);

assign result = accum;

parameter DONE = 3'b000, INIT = 3'b001, NEXTSTEP = 3'b010, WAIT = 3'b011,
          FINSQUARE = 3'b100, FINCUBE = 3'b101, FINCUBECOEFF = 3'b110;

reg [2:0] state = DONE;
reg [2:0] ret_state;

always @(posedge clk) begin
    if (reset == 1) begin
        state = INIT;
    end else begin
        case (state)
        INIT: begin
            square <= theta;
            lastpower <= theta;
            term_power <= theta;
            coeffind <= 0;
            power_mult_rst = 1;
            term_mult_rst = 1;
            state <= WAIT;
            ret_state <= FINSQUARE;
        end
        FINSQUARE: begin
            accum <= term_res;
            square <= power_res;

            if (prec == 0) begin
                state <= DONE;
            end else begin
                power_mult_rst = 1;
                state <= WAIT;
                ret_state <= FINCUBE;
            end
        end
        FINCUBE: begin
            last_power <= power_res;
            term_power <= power_res;
            coeffind <= 1;
            power_mult_rst <= 1;
            term_mult_rst <= 1;
            state <= WAIT;
            ret_state <= FINCUBECOEFF;
        end
        FINCUBECOEFF: begin
            last_power <= power_res;
            term_power <= power_res;
            accum_next <= term_res;
            coeffind <= 2;
            lastind <= 1;
            power_mult_rst <= 1;
            term_mult_rst <= 1;
            add_rst <= 1;
            state <= WAIT;
            ret_state <= NEXTSTEP;
        end
        NEXTSTEP: begin
            accum <= accum_res;
            accum_next <= term_res;
            last_power <= power_res;
            term_power <= power_res;

            if (lastind == prec) begin
                state <= DONE;
            end else begin
                coeffind <= nextind;
                power_mult_rst <= 1;
                term_mult_rst <= 1;
                add_rst <= 1;
                state <= WAIT;
            end
        end
        WAIT: begin
            power_mult_rst <= 0;
            term_mult_rst <= 0;
            add_rst <= 0;
            if (alldone == 3'b111) begin
                state <= ret_state;
            end
        end
        default: state = DONE;
        endcase
    end
end
