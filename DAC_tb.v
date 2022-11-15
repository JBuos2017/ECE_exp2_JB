`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/16 00:22:12
// Design Name: 
// Module Name: DAC_tb
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


module DAC_tb();



reg clk, rst;
reg [5:0] btn;
reg  add_sel;
wire dac_csn, dac_ldacn, dac_wrn, dac_a_b;
wire [7:0]dac_d;
wire [7:0] led_out;

DAC d1(clk, rst, btn, add_sel, dac_csn, dac_ldacn, dac_wrn, dac_a_b, dac_d, led_out);

initial begin
    clk <= 0;
    rst <= 1;
    btn <= 6'b000000;
    add_sel <= 0;
    #2; rst <=0;
    #2; rst <=1;
    #300; btn <= 6'b100000;
    #300; btn <= 6'b010000;
    #300; btn <= 6'b001000;
    #300; btn <= 6'b000100;
    #300; btn <= 6'b000010;
    #300; btn <= 6'b000001;
end

always begin
    #0.5 clk <= ~clk;
end
    
endmodule