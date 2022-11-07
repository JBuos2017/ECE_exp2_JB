`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/07 14:23:33
// Design Name: 
// Module Name: LCD_cursor_tb
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


module LCD_cursor_tb();

reg rst, clk;
reg [9:0] number_btn;
reg [1:0] control_btn;

wire LCD_E, LCD_RS, LCD_RW;
wire [7:0] LCD_DATA;
wire [7:0] LED_out;

LCD_cursor t1(rst, clk, LCD_E, LCD_RS, LCD_RW, LCD_DATA, LED_out, number_btn, control_btn);

initial begin
    clk <= 0;
    rst <= 1;
    number_btn <= 10'b0000_0000_00;
    control_btn <= 2'b00;
    #2; rst <=0;
    #2; rst <=1;
    #350; number_btn <= 10'b0100_0000_00;
    #100; number_btn <= 10'b0000_0100_00;
    #100; number_btn <= 10'b0000_0000_00; control_btn <= 2'b01;
    #100; control_btn <= 2'b10; 
end

always begin
    #0.5 clk <= ~clk;
end
    
endmodule
