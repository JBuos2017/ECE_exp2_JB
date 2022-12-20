`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/28 20:44:23
// Design Name: 
// Module Name: LCD
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/16 00:55:07
// Design Name: 
// Module Name: text_LCD
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module LCD(rst, clk, hour, min, sec, d_or_n, t_state, LCD_E, LCD_RS, LCD_RW, LCD_DATA);

input rst, clk, d_or_n;
input [2:0] t_state;
input [7:0] hour, min, sec; 

output LCD_E, LCD_RS, LCD_RW;
output reg [7:0] LCD_DATA;

wire LCD_E;
reg LCD_text;
reg LCD_RS, LCD_RW;

reg [2:0] state; 
parameter DELAY = 3'b000,
          FUNCTION_SET = 3'b001,
          ENTRY_MODE = 3'b010,
          DISP_ONOFF = 3'b011,
          LINE1 = 3'b100,
          LINE2 = 3'b101,
          DELAY_T = 3'b110,
          CLEAR_DISP = 3'b111;

integer cnt;

always @(posedge clk or negedge rst)
begin
    if(!rst) begin
        state = DELAY;
        cnt = 0;
    end
    else
    begin
        case(state)
            DELAY : begin
                if(cnt >= 70) begin
                    state = FUNCTION_SET;
                    cnt = 0;
                end
                else cnt = cnt + 1;
            end
            FUNCTION_SET : begin
                if(cnt >= 30) begin
                    state = DISP_ONOFF;
                    cnt = 0;
                end
                else cnt = cnt + 1;
            end
            DISP_ONOFF : begin
                if(cnt >= 30) begin
                    state = ENTRY_MODE;
                    cnt = 0;
                end
                else cnt = cnt + 1;
            end
            ENTRY_MODE : begin
                if(cnt >= 30) begin
                    state = LINE1;
                    cnt = 0;
                end
                else cnt = cnt + 1;
            end
            LINE1 : begin
                if(cnt >= 20) begin
                    state = LINE2;
                    cnt = 0;
                end
                else cnt = cnt + 1;
            end
            LINE2 : begin
                if(cnt >= 20) begin
                    state = DELAY_T;
                    cnt = 0;
                end
                else cnt = cnt + 1;
            end
            DELAY_T : begin
                if(cnt >= 200) begin
                    state = CLEAR_DISP;
                    cnt = 0;
                end
                else cnt = cnt + 1;
            end
            CLEAR_DISP : begin

                if(cnt >= 5) begin
                    state = LINE1;
                    cnt = 0;
                end
                else cnt = cnt + 1;
            end
            default : state = DELAY;
        endcase
    end
end

always @(posedge clk or negedge rst)
begin
    if(!rst) 
        {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_1_00000000;
    else begin
        case(state)
            FUNCTION_SET :
                {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_0011_1000;
            DISP_ONOFF :
                {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_0000_1100;
            ENTRY_MODE :
                {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_0000_0110;
            LINE1 :
                begin
                    case(cnt)
                    00 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_1000_0000; //address
                    01 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0101_0100; //T
                    02 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0110_1001; //i
                    03 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0110_1101; //m
                    04 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0110_0101; //e
                    05 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; //
                    06 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_1010; //:
                    07 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000;
                    08 : case(hour[7:4]) //hour ten
                            0 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0000; 
                            1 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0001; 
                            2 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0010;
                            3 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0011;
                            4 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0100;
                            5 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0101;
                            6 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0110;
                            7 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0111;
                            8 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_1000;
                            9 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_1001;
                        endcase
                    09 : case(hour[3:0]) //hour one
                            0 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0000;
                            1 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0001;
                            2 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0010;
                            3 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0011;
                            4 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0100;
                            5 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0101;
                            6 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0110;
                            7 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0111;
                            8 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_1000;
                            9 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_1001;
                        endcase
                    10 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_1010; //:
                    11 : case(min[7:4]) //min ten
                            0 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0000;
                            1 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0001;
                            2 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0010;
                            3 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0011;
                            4 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0100;
                            5 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0101;
                            6 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0110;
                            7 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0111;
                            8 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_1000;
                            9 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_1001;
                        endcase
                    12 : case(min[3:0]) //min one
                            0 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0000;
                            1 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0001;
                            2 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0010;
                            3 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0011;
                            4 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0100;
                            5 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0101;
                            6 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0110;
                            7 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0111;
                            8 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_1000;
                            9 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_1001;
                         endcase
                     13 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_1010; //:
                     14 : case(sec[7:4]) //sec ten
                            0 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0000;
                            1 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0001;
                            2 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0010;
                            3 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0011;
                            4 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0100;
                            5 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0101;
                            6 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0110;
                            7 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0111;
                            8 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_1000;
                            9 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_1001;
                            10 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0001_0110;
                        endcase
                    15 : case(sec[3:0]) //sec one
                            0 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0000;
                            1 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0001;
                            2 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0010;
                            3 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0011;
                            4 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0100;
                            5 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0101;
                            6 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0110;
                            7 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0111;
                            8 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_1000;
                            9 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_1001;
                        endcase
                    
                    default : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; //
                endcase
           end
           LINE2 :
                begin
                    case(cnt)
                    00 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_1100_0000; //adress
                    01 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0101_0011; //S
                    02 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0111_0100; //t
                    03 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0110_0001; //a
                    04 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0111_0100; //t
                    05 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0110_0101; //e
                    06 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; //
                    07 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_1010; //:
                    08 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; //  
                    09 : case(t_state)
                            0 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0100_0001; //A
                            1 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0100_0010; //B
                            2 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0100_0011; //C
                            3 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0100_0100; //D
                            4 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0100_0101; //E
                            5 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0100_0110; //F
                            6 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0100_0111; //G
                            7 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0100_1000; //H
                            8 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0100_0001; //A
                        endcase
                    10 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_1000; //(
                    11 : {LCD_RS, LCD_RW, LCD_DATA} = d_or_n? 10'b1_0_0100_1110 : 10'b1_0_0100_0100;//N/D
                    12 : {LCD_RS, LCD_RW, LCD_DATA} = d_or_n? 10'b1_0_0110_1001 : 10'b1_0_0110_0001;//i/a
                    13 : {LCD_RS, LCD_RW, LCD_DATA} = d_or_n? 10'b1_0_0110_0111 : 10'b1_0_0111_1001;//g/y
                    14 : {LCD_RS, LCD_RW, LCD_DATA} = d_or_n? 10'b1_0_0110_1000 : 10'b1_0_0010_1001;//h/)
                    15 : {LCD_RS, LCD_RW, LCD_DATA} = d_or_n? 10'b1_0_0111_0100 : 10'b1_0_0010_0000;//t/
                    16 : {LCD_RS, LCD_RW, LCD_DATA} = d_or_n? 10'b1_0_0010_1001 : 10'b1_0_0010_0000;//)/
                    default : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; //
                endcase
           end
            DELAY_T : 
                {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_0000_0010;
            CLEAR_DISP :
                {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_0000_0001;
            default :
                {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_1_0010_0000;
         endcase
     end
end

assign LCD_E = clk;

endmodule

