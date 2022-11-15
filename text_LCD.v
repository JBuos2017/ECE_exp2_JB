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


module text_LCD(rst, clk, dac_d, LCD_E, LCD_RS, LCD_RW, LCD_DATA);

input rst, clk;
input [7:0] dac_d; 

output LCD_E, LCD_RS, LCD_RW;
output reg [7:0] LCD_DATA;

wire LCD_E;
reg DAC_num;
reg LCD_text;
reg LCD_RS, LCD_RW;

reg [2:0] state; 
parameter DELAY = 3'b000,
          FUNCTION_SET = 3'b001,
          ENTRY_MODE = 3'b010,
          DISP_ONOFF = 3'b011,
          LINE1 = 3'b100,
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
                    state = DELAY_T;
                    cnt = 0;
                end
                else cnt = cnt + 1;
            end
            DELAY_T : begin
                if(cnt >= 5) begin
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
                    case(DAC_num)
                        0 : LCD_text = 10'b1_0_0011_0000;
                        1 : LCD_text = 10'b1_0_0011_0001;
                    endcase
                    case(cnt)
                    00 : begin
                        DAC_num = dac_d[7]; 
                        {LCD_RS, LCD_RW, LCD_DATA} = DAC_num;
                    end
                    01 : begin
                        DAC_num = dac_d[6]; 
                        {LCD_RS, LCD_RW, LCD_DATA} = DAC_num;
                    end
                    02 : begin
                        DAC_num = dac_d[5]; 
                        {LCD_RS, LCD_RW, LCD_DATA} = DAC_num;
                    end
                    03 : begin
                        DAC_num = dac_d[4]; 
                        {LCD_RS, LCD_RW, LCD_DATA} = DAC_num;
                    end
                    04 : begin
                        DAC_num = dac_d[3]; 
                        {LCD_RS, LCD_RW, LCD_DATA} = DAC_num;
                    end
                    05 : begin
                        DAC_num = dac_d[2]; 
                        {LCD_RS, LCD_RW, LCD_DATA} = DAC_num;
                    end
                    06 : begin
                        DAC_num = dac_d[1]; 
                        {LCD_RS, LCD_RW, LCD_DATA} = DAC_num;
                    end
                    07 : begin
                        DAC_num = dac_d[0]; 
                        {LCD_RS, LCD_RW, LCD_DATA} = DAC_num;
                    end
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
