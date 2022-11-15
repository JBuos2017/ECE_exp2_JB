`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/16 00:48:08
// Design Name: 
// Module Name: DAC_display
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


module DAC_display(clk, rst, btn, add_sel, dac_csn, dac_ldacn, dac_wrn, dac_a_b, dac_d, led_out,LCD_E, LCD_RS, LCD_RW, LCD_DATA);

input clk, rst;
input [5:0] btn;
input add_sel;
output reg dac_csn, dac_ldacn, dac_wrn, dac_a_b;
output reg [7:0]dac_d;
output reg [7:0] led_out;
output LCD_E, LCD_RS, LCD_RW;
output reg [7:0] LCD_DATA;

reg [7:0] dac_d_temp;
reg [7:0] cnt;
wire [5:0] btn_t;

reg [1:0] state;

parameter DELAY = 2'b00;
parameter SET_WRN = 2'b01;
parameter UP_DATA = 2'b10;

oneshot_universal #(.WIDTH(6)) u1(clk, rst, {btn[5:0]}, {btn_t[5:0]});
text_LCD t1(rst, clk, dac_d, LCD_E, LCD_RS, LCD_RW, LCD_DATA);

always @(posedge clk or negedge rst)
begin
    if(!rst) begin
        state <= DELAY;
        cnt <= 0;
    end
    else begin
        case(state)
            DELAY : begin
                if(cnt >= 200) begin
                    state <= SET_WRN;
                    cnt <= 0;
                end
                else cnt <= cnt + 1;
            end
            SET_WRN : begin
                if(cnt >= 50) begin
                    state <= UP_DATA;
                    cnt <= 0;
                end
                else cnt <= cnt + 1;
            end
            UP_DATA : begin
                if(cnt >= 30) begin
                    state <= DELAY;
                    cnt <= 0;
                end
                else cnt <= cnt + 1;
            end
        endcase
    end
end

always @(posedge clk or negedge rst)
begin
    if(!rst) begin
        dac_wrn <= 1;
    end
    else begin
        case(state)
            DELAY :
                dac_wrn <= 1;
            SET_WRN :
                dac_wrn <= 0;
            UP_DATA : 
                dac_d <= dac_d_temp;
        endcase
    end
end     

always @(posedge clk or negedge rst)
begin
    if(!rst) begin
        dac_d_temp <= 8'b0000_0000;
        led_out <= 8'b0101_0101;
    end
    else begin
        if(btn_t == 6'b100000) dac_d_temp <= dac_d_temp - 8'b0000_0001;
        else if(btn_t == 6'b010000) dac_d_temp <= dac_d_temp + 8'b0000_0001;
        else if(btn_t == 6'b001000) dac_d_temp <= dac_d_temp - 8'b0000_0010;
        else if(btn_t == 6'b000100) dac_d_temp <= dac_d_temp + 8'b0000_0010;
        else if(btn_t == 6'b000010) dac_d_temp <= dac_d_temp - 8'b0000_1000;
        else if(btn_t == 6'b000001) dac_d_temp <= dac_d_temp + 8'b0000_1000;
        led_out <= dac_d_temp;
    end
end     

always @(posedge clk) begin
    dac_csn <= 0;
    dac_ldacn <= 0;
    dac_a_b <= add_sel; //0 select A, 1 select B
end

endmodule
