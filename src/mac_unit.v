`timescale 1ns/100ps

module mac_unit #(parameter IP_SIZE=8,parameter OP_SIZE=24) (clk, rst, x_new, w_new, x_old, w_old, pe_val);

input clk;
input rst;
input [IP_SIZE-1:0] x_new;
input [IP_SIZE-1:0] w_new;

output [IP_SIZE-1:0] x_old;
output [IP_SIZE-1:0] w_old;
output [OP_SIZE-1:0] pe_val;

reg [IP_SIZE-1:0] x_new_reg;
reg [IP_SIZE-1:0] w_new_reg;
reg [OP_SIZE-1:0] partial_sum_reg;

always @ (posedge clk) begin
    if (rst) begin
        x_new_reg <= 0;
        w_new_reg <= 0;
    end
    else begin
        x_new_reg <= x_new;
        w_new_reg <= w_new;
    end
end

assign x_old = x_new_reg;
assign w_old = w_new_reg;

always @ (posedge clk) begin
    if (rst) begin
        partial_sum_reg <= 0;
    end
    else begin
        partial_sum_reg <= pe_val;
    end
end

assign pe_val = partial_sum_reg + (x_new*w_new);

endmodule
