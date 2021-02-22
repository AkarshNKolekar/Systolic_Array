//Instance of systolic array
`timescale 1ns/100ps

module systolic_array#(
    parameter NUM_ROW = 8,
    parameter NUM_COL = 8,
    parameter IN_WORD_SIZE = 8,
    parameter OUT_WORD_SIZE = 24
)(
    clk,
    rst,

    top_inputs,
    left_inputs,

    compute_done,
    cycles_count,
    pe_register_vals
);

input clk;
input rst;

input [NUM_COL *  IN_WORD_SIZE -1 : 0] top_inputs;
input [NUM_ROW *  IN_WORD_SIZE -1 : 0] left_inputs;

output reg compute_done;
output reg  [OUT_WORD_SIZE-1:0] cycles_count;
output [0: OUT_WORD_SIZE * NUM_ROW * NUM_COL -1] pe_register_vals;

//wire [15:0] tie_high;
//assign tie_high =16'hFF_FF;

//ORIGINAL
/*
genvar i;
generate
    for(i=0; i <NUM_ROW * NUM_COL; i=i+1)
    begin
        assign pe_register_vals[i*OUT_WORD_SIZE +: OUT_WORD_SIZE] = tie_high[OUT_WORD_SIZE-1:0];
        //assign pe_register_vals[0:15] = tie_high[15:0];
    end
endgenerate
  */      
//assign pe_register_vals[0:15] = tie_high[15:0];

reg [IN_WORD_SIZE -1:0] x_new [0:63];
reg [IN_WORD_SIZE -1:0] w_new [0:63];
wire [IN_WORD_SIZE -1:0] x_old [0:63];
wire [IN_WORD_SIZE -1:0] w_old [0:63];

//intermediate registers for delays
reg [IN_WORD_SIZE-1:0]row2_temp;
reg [IN_WORD_SIZE-1:0]col2_temp;
reg [IN_WORD_SIZE-1:0]row3_temp1;
reg [IN_WORD_SIZE-1:0]row3_temp2;
reg [IN_WORD_SIZE-1:0]col3_temp1;
reg [IN_WORD_SIZE-1:0]col3_temp2;
reg [IN_WORD_SIZE-1:0]row4_temp1;
reg [IN_WORD_SIZE-1:0]row4_temp2;
reg [IN_WORD_SIZE-1:0]row4_temp3;
reg [IN_WORD_SIZE-1:0]col4_temp1;
reg [IN_WORD_SIZE-1:0]col4_temp2;
reg [IN_WORD_SIZE-1:0]col4_temp3;
reg [IN_WORD_SIZE-1:0]row5_temp1;
reg [IN_WORD_SIZE-1:0]row5_temp2;
reg [IN_WORD_SIZE-1:0]row5_temp3;
reg [IN_WORD_SIZE-1:0]row5_temp4;
reg [IN_WORD_SIZE-1:0]col5_temp1;
reg [IN_WORD_SIZE-1:0]col5_temp2;
reg [IN_WORD_SIZE-1:0]col5_temp3;
reg [IN_WORD_SIZE-1:0]col5_temp4;
reg [IN_WORD_SIZE-1:0]row6_temp1;
reg [IN_WORD_SIZE-1:0]row6_temp2;
reg [IN_WORD_SIZE-1:0]row6_temp3;
reg [IN_WORD_SIZE-1:0]row6_temp4;
reg [IN_WORD_SIZE-1:0]row6_temp5;
reg [IN_WORD_SIZE-1:0]col6_temp1;
reg [IN_WORD_SIZE-1:0]col6_temp2;
reg [IN_WORD_SIZE-1:0]col6_temp3;
reg [IN_WORD_SIZE-1:0]col6_temp4;
reg [IN_WORD_SIZE-1:0]col6_temp5;
reg [IN_WORD_SIZE-1:0]row7_temp1;
reg [IN_WORD_SIZE-1:0]row7_temp2;
reg [IN_WORD_SIZE-1:0]row7_temp3;
reg [IN_WORD_SIZE-1:0]row7_temp4;
reg [IN_WORD_SIZE-1:0]row7_temp5;
reg [IN_WORD_SIZE-1:0]row7_temp6;
reg [IN_WORD_SIZE-1:0]col7_temp1;
reg [IN_WORD_SIZE-1:0]col7_temp2;
reg [IN_WORD_SIZE-1:0]col7_temp3;
reg [IN_WORD_SIZE-1:0]col7_temp4;
reg [IN_WORD_SIZE-1:0]col7_temp5;
reg [IN_WORD_SIZE-1:0]col7_temp6;
reg [IN_WORD_SIZE-1:0]row8_temp1;
reg [IN_WORD_SIZE-1:0]row8_temp2;
reg [IN_WORD_SIZE-1:0]row8_temp3;
reg [IN_WORD_SIZE-1:0]row8_temp4;
reg [IN_WORD_SIZE-1:0]row8_temp5;
reg [IN_WORD_SIZE-1:0]row8_temp6;
reg [IN_WORD_SIZE-1:0]row8_temp7;
reg [IN_WORD_SIZE-1:0]col8_temp1;
reg [IN_WORD_SIZE-1:0]col8_temp2;
reg [IN_WORD_SIZE-1:0]col8_temp3;
reg [IN_WORD_SIZE-1:0]col8_temp4;
reg [IN_WORD_SIZE-1:0]col8_temp5;
reg [IN_WORD_SIZE-1:0]col8_temp6;
reg [IN_WORD_SIZE-1:0]col8_temp7;

//count cycles
always @ (posedge clk) begin
    if (rst) begin
        cycles_count <= 0;
        end
    else begin
        cycles_count <= cycles_count + 1;
    end
end

//First row/col delay
always @(posedge clk) begin
    if (rst) begin
        x_new[0] <= 0;
        w_new[0] <= 0;
    end
    else begin
        x_new[0] <= left_inputs [7:0];
        w_new[0] <= top_inputs [7:0];
    end
end

//Second row/col delay
always @(posedge clk) begin
    if (rst) begin
        row2_temp <= 0;
        col2_temp <= 0;
        x_new[8] <= 0;
        w_new[1] <= 0;
    end
    else begin
        row2_temp <= left_inputs [15:8];
        x_new [8] <= row2_temp;
        col2_temp <= top_inputs[15:8];
        w_new[1] <= col2_temp;
    end
end

//Third row/col delay
always @(posedge clk) begin
    if (rst) begin
        row3_temp1 <= 0;
        row3_temp2 <= 0;
        x_new [16] <= 0;
        col3_temp1 <= 0;
        col3_temp2 <= 0;
        w_new [2] <= 0;
    end
    else begin
        row3_temp1 <= left_inputs[23:16];
        row3_temp2 <= row3_temp1;
        x_new [16] <= row3_temp2;
        col3_temp1 <= top_inputs[23:16];
        col3_temp2 <= col3_temp1;
        w_new [2] <= col3_temp2;
    end
end

//Fourth row/col delay
always @(posedge clk) begin
    if (rst) begin
        row4_temp1 <= 0;
        row4_temp2 <= 0;
        row4_temp3 <= 0;
        x_new [24] <= 0;
        col4_temp1 <= 0;
        col4_temp2 <= 0;
        col4_temp3 <= 0;
        w_new [3] <= 0;
    end
    else begin
        row4_temp1 <= left_inputs[31:24];
        row4_temp2 <= row4_temp1;
        row4_temp3 <= row4_temp2;
        x_new [24] <= row4_temp3;
        col4_temp1 <= top_inputs[31:24];
        col4_temp2 <= col4_temp1;
        col4_temp3 <= col4_temp2;
        w_new [3] <= col4_temp3;
    end
end

//Fifth row/col delay
always @(posedge clk) begin
    if (rst) begin
        row5_temp1 <= 0;
        row5_temp2 <= 0;
        row5_temp3 <= 0;
        row5_temp4 <= 0;
        x_new [32] <= 0;
        col5_temp1 <= 0;
        col5_temp2 <= 0;
        col5_temp3 <= 0;
        col5_temp4 <= 0;
        w_new [4] <= 0;
    end
    else begin
        row5_temp1 <= left_inputs[39:32];
        row5_temp2 <= row5_temp1;
        row5_temp3 <= row5_temp2;
        row5_temp4 <= row5_temp3;
        x_new [32] <= row5_temp4;
        col5_temp1 <= top_inputs[39:32];
        col5_temp2 <= col5_temp1;
        col5_temp3 <= col5_temp2;
        col5_temp4 <= col5_temp3;
        w_new [4] <= col5_temp4;
    end
end

//Sixth rol/col delay
always @(posedge clk) begin
    if (rst) begin
        row6_temp1 <= 0;
        row6_temp2 <= 0;
        row6_temp3 <= 0;
        row6_temp4 <= 0;
        row6_temp5 <= 0;
        x_new [40] <= 0;
        col6_temp1 <= 0;
        col6_temp2 <= 0;
        col6_temp3 <= 0;
        col6_temp4 <= 0;
        col6_temp5 <= 0;
        w_new [5] <= 0;
    end
    else begin
        row6_temp1 <= left_inputs[47:40];
        row6_temp2 <= row6_temp1;
        row6_temp3 <= row6_temp2;
        row6_temp4 <= row6_temp3;
        row6_temp5 <= row6_temp4;
        x_new [40] <= row6_temp5;
        col6_temp1 <= top_inputs[47:40];
        col6_temp2 <= col6_temp1;
        col6_temp3 <= col6_temp2;
        col6_temp4 <= col6_temp3;
        col6_temp5 <= col6_temp4;
        w_new [5] <= col6_temp5;
    end
end

//Seventh rol/col delay
always @(posedge clk) begin
    if (rst) begin
        row7_temp1 <= 0;
        row7_temp2 <= 0;
        row7_temp3 <= 0;
        row7_temp4 <= 0;
        row7_temp5 <= 0;
        row7_temp6 <= 0;
        x_new [48] <= 0;
        col7_temp1 <= 0;
        col7_temp2 <= 0;
        col7_temp3 <= 0;
        col7_temp4 <= 0;
        col7_temp5 <= 0;
        col7_temp6 <= 0;
        w_new [6] <= 0;
    end
    else begin
        row7_temp1 <= left_inputs[55:48];
        row7_temp2 <= row7_temp1;
        row7_temp3 <= row7_temp2;
        row7_temp4 <= row7_temp3;
        row7_temp5 <= row7_temp4;
        row7_temp6 <= row7_temp5;
        x_new [48] <= row7_temp6;
        col7_temp1 <= top_inputs[55:48];
        col7_temp2 <= col7_temp1;
        col7_temp3 <= col7_temp2;
        col7_temp4 <= col7_temp3;
        col7_temp5 <= col7_temp4;
        col7_temp6 <= col7_temp5;
        w_new [6] <= col7_temp6;
    end
end

//Eigth rol/col delay
always @(posedge clk) begin
    if (rst) begin
        row8_temp1 <= 0;
        row8_temp2 <= 0;
        row8_temp3 <= 0;
        row8_temp4 <= 0;
        row8_temp5 <= 0;
        row8_temp6 <= 0;
        row8_temp7 <= 0;
        x_new [56] <= 0;
        col8_temp1 <= 0;
        col8_temp2 <= 0;
        col8_temp3 <= 0;
        col8_temp4 <= 0;
        col8_temp5 <= 0;
        col8_temp6 <= 0;
        col8_temp7 <= 0;
        w_new [7] <= 0;
    end
    else begin
        row8_temp1 <= left_inputs[63:56];
        row8_temp2 <= row8_temp1;
        row8_temp3 <= row8_temp2;
        row8_temp4 <= row8_temp3;
        row8_temp5 <= row8_temp4;
        row8_temp6 <= row8_temp5;
        row8_temp7 <= row8_temp6;
        x_new [56] <= row8_temp7;
        col8_temp1 <= top_inputs[63:56];
        col8_temp2 <= col8_temp1;
        col8_temp3 <= col8_temp2;
        col8_temp4 <= col8_temp3;
        col8_temp5 <= col8_temp4;
        col8_temp6 <= col8_temp5;
        col8_temp7 <= col8_temp6;
        w_new [7] <= col8_temp7;
    end
end

//PE instantiation
//First Row
mac_unit m0 (clk,rst,x_new[0],w_new[0],x_old[0],w_old[0],pe_register_vals[0:23]);
mac_unit m1 (clk,rst,x_old[0],w_new[1],x_old[1],w_old[1],pe_register_vals[24:47]);
mac_unit m2 (clk,rst,x_old[1],w_new[2],x_old[2],w_old[2],pe_register_vals[48:71]);
mac_unit m3 (clk,rst,x_old[2],w_new[3],x_old[3],w_old[3],pe_register_vals[72:95]);
mac_unit m4 (clk,rst,x_old[3],w_new[4],x_old[4],w_old[4],pe_register_vals[96:119]);
mac_unit m5 (clk,rst,x_old[4],w_new[5],x_old[5],w_old[5],pe_register_vals[120:143]);
mac_unit m6 (clk,rst,x_old[5],w_new[6],x_old[6],w_old[6],pe_register_vals[144:167]);
mac_unit m7 (clk,rst,x_old[6],w_new[7],x_old[7],w_old[7],pe_register_vals[168:191]);
//Second Row
mac_unit m8 (clk,rst,x_new[8],w_old[0],x_old[8],w_old[8],pe_register_vals[192:215]);
mac_unit m9 (clk,rst,x_old[8],w_old[1],x_old[9],w_old[9],pe_register_vals[216:239]);
mac_unit m10(clk,rst,x_old[9],w_old[2],x_old[10],w_old[10],pe_register_vals[240:263]);
mac_unit m11(clk,rst,x_old[10],w_old[3],x_old[11],w_old[11],pe_register_vals[264:287]);
mac_unit m12(clk,rst,x_old[11],w_old[4],x_old[12],w_old[12],pe_register_vals[288:311]);
mac_unit m13(clk,rst,x_old[12],w_old[5],x_old[13],w_old[13],pe_register_vals[312:335]);
mac_unit m14(clk,rst,x_old[13],w_old[6],x_old[14],w_old[14],pe_register_vals[336:359]);
mac_unit m15(clk,rst,x_old[14],w_old[7],x_old[15],w_old[15],pe_register_vals[360:383]);
//Third Row
mac_unit m16(clk,rst,x_new[16],w_old[8],x_old[16],w_old[16],pe_register_vals[384:407]);
mac_unit m17(clk,rst,x_old[16],w_old[9],x_old[17],w_old[17],pe_register_vals[408:431]);
mac_unit m18(clk,rst,x_old[17],w_old[10],x_old[18],w_old[18],pe_register_vals[432:455]);
mac_unit m19(clk,rst,x_old[18],w_old[11],x_old[19],w_old[19],pe_register_vals[456:479]);
mac_unit m20(clk,rst,x_old[19],w_old[12],x_old[20],w_old[20],pe_register_vals[480:503]);
mac_unit m21(clk,rst,x_old[20],w_old[13],x_old[21],w_old[21],pe_register_vals[504:527]);
mac_unit m22(clk,rst,x_old[21],w_old[14],x_old[22],w_old[22],pe_register_vals[528:551]);
mac_unit m23(clk,rst,x_old[22],w_old[15],x_old[23],w_old[23],pe_register_vals[552:575]);
//Fourth Row
mac_unit m24(clk,rst,x_new[24],w_old[16],x_old[24],w_old[24],pe_register_vals[576:599]);
mac_unit m25(clk,rst,x_old[24],w_old[17],x_old[25],w_old[25],pe_register_vals[600:623]);
mac_unit m26(clk,rst,x_old[25],w_old[18],x_old[26],w_old[26],pe_register_vals[624:647]);
mac_unit m27(clk,rst,x_old[26],w_old[19],x_old[27],w_old[27],pe_register_vals[648:671]);
mac_unit m28(clk,rst,x_old[27],w_old[20],x_old[28],w_old[28],pe_register_vals[672:695]);
mac_unit m29(clk,rst,x_old[28],w_old[21],x_old[29],w_old[29],pe_register_vals[696:719]);
mac_unit m30(clk,rst,x_old[29],w_old[22],x_old[30],w_old[30],pe_register_vals[720:743]);
mac_unit m31(clk,rst,x_old[30],w_old[23],x_old[31],w_old[31],pe_register_vals[744:767]);
//Fifth Row
mac_unit m32(clk,rst,x_new[32],w_old[24],x_old[32],w_old[32],pe_register_vals[768:791]);
mac_unit m33(clk,rst,x_old[32],w_old[25],x_old[33],w_old[33],pe_register_vals[792:815]);
mac_unit m34(clk,rst,x_old[33],w_old[26],x_old[34],w_old[34],pe_register_vals[816:839]);
mac_unit m35(clk,rst,x_old[34],w_old[27],x_old[35],w_old[35],pe_register_vals[840:863]);
mac_unit m36(clk,rst,x_old[35],w_old[28],x_old[36],w_old[36],pe_register_vals[864:887]);
mac_unit m37(clk,rst,x_old[36],w_old[29],x_old[37],w_old[37],pe_register_vals[888:911]);
mac_unit m38(clk,rst,x_old[37],w_old[30],x_old[38],w_old[38],pe_register_vals[912:935]);
mac_unit m39(clk,rst,x_old[38],w_old[31],x_old[39],w_old[39],pe_register_vals[936:959]);
//Sixth Row
mac_unit m40(clk,rst,x_new[40],w_old[32],x_old[40],w_old[40],pe_register_vals[960:983]);
mac_unit m41(clk,rst,x_old[40],w_old[33],x_old[41],w_old[41],pe_register_vals[984:1007]);
mac_unit m42(clk,rst,x_old[41],w_old[34],x_old[42],w_old[42],pe_register_vals[1008:1031]);
mac_unit m43(clk,rst,x_old[42],w_old[35],x_old[43],w_old[43],pe_register_vals[1032:1055]);
mac_unit m44(clk,rst,x_old[43],w_old[36],x_old[44],w_old[44],pe_register_vals[1056:1079]);
mac_unit m45(clk,rst,x_old[44],w_old[37],x_old[45],w_old[45],pe_register_vals[1080:1103]);
mac_unit m46(clk,rst,x_old[45],w_old[38],x_old[46],w_old[46],pe_register_vals[1104:1127]);
mac_unit m47(clk,rst,x_old[46],w_old[39],x_old[47],w_old[47],pe_register_vals[1128:1151]);
//Seventh Row
mac_unit m48(clk,rst,x_new[48],w_old[40],x_old[48],w_old[48],pe_register_vals[1152:1175]);
mac_unit m49(clk,rst,x_old[48],w_old[41],x_old[49],w_old[49],pe_register_vals[1176:1199]);
mac_unit m50(clk,rst,x_old[49],w_old[42],x_old[50],w_old[50],pe_register_vals[1200:1223]);
mac_unit m51(clk,rst,x_old[50],w_old[43],x_old[51],w_old[51],pe_register_vals[1224:1247]);
mac_unit m52(clk,rst,x_old[51],w_old[44],x_old[52],w_old[52],pe_register_vals[1248:1271]);
mac_unit m53(clk,rst,x_old[52],w_old[45],x_old[53],w_old[53],pe_register_vals[1272:1295]);
mac_unit m54(clk,rst,x_old[53],w_old[46],x_old[54],w_old[54],pe_register_vals[1296:1319]);
mac_unit m55(clk,rst,x_old[54],w_old[47],x_old[55],w_old[55],pe_register_vals[1320:1343]);
//Eighth Row
mac_unit m56(clk,rst,x_new[56],w_old[48],x_old[56],w_old[56],pe_register_vals[1344:1367]);
mac_unit m57(clk,rst,x_old[56],w_old[49],x_old[57],w_old[57],pe_register_vals[1368:1391]);
mac_unit m58(clk,rst,x_old[57],w_old[50],x_old[58],w_old[58],pe_register_vals[1392:1415]);
mac_unit m59(clk,rst,x_old[58],w_old[51],x_old[59],w_old[59],pe_register_vals[1416:1439]);
mac_unit m60(clk,rst,x_old[59],w_old[52],x_old[60],w_old[60],pe_register_vals[1440:1463]);
mac_unit m61(clk,rst,x_old[60],w_old[53],x_old[61],w_old[61],pe_register_vals[1464:1487]);
mac_unit m62(clk,rst,x_old[61],w_old[54],x_old[62],w_old[62],pe_register_vals[1488:1511]);
mac_unit m63(clk,rst,x_old[62],w_old[55],x_old[63],w_old[63],pe_register_vals[1512:1535]);

always @(posedge clk)
begin
    if(rst)
        begin
            compute_done <= 1'b0;
        end
    else
        begin
            if (cycles_count == 22)
            begin
                compute_done <= 1'b1;
            end
        end
end
endmodule
