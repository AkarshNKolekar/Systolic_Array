`timescale 1ns/100ps
module mac_unit_tb();

parameter IP_SIZE=8;
parameter OP_SIZE=16;

reg clk;

reg [IP_SIZE-1:0] x_new;
reg [IP_SIZE-1:0] w_new;
reg rst;

wire [IP_SIZE-1:0] x_old;
wire [IP_SIZE-1:0] w_old;
wire [OP_SIZE-1:0] pe_val;

initial begin
    clk = 0;
    x_new = 0;
    w_new = 0;
    rst = 0;
    #0.5 rst = 1;
    #1 rst = 0;
end

always #1 clk = ~clk;

always @(posedge clk) begin
    x_new = x_new + 1;
    w_new = w_new + 1;
end


mac_unit dut (.clk(clk), .rst(rst), .x_new(x_new), .w_new(w_new), .x_old(x_old), .w_old(w_old), .pe_val(pe_val));

initial begin
    $monitor("clk=%d, rst=%d, x_new=%d, w_new=%d, x_old=%d, w_old=%d, pe_val=%d",clk, rst, x_new, w_new, x_old, w_old, pe_val);
end

always #10 $finish;

endmodule
