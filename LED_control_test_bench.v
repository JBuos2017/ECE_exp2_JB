`timescale 1us / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/10/17 17:59:48
// Design Name: 
// Module Name: LED_control_test_bench
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


module LED_control_test_bench();

reg clk, rst;
reg [7:0] bin;


wire [7:0] seg_data;
wire [7:0] seg_sel;
wire led_signal;

LED_control c1(clk, rst, bin, seg_data, seg_sel, led_signal);

initial begin 
    clk <= 0; rst <= 1; bin <= 8'b00000000;
    #1e+6; rst <= 0;
    #1e+6; rst <= 1;
    #1e+6; bin <= 8'b00000000;
    #1e+6; bin <= 8'b00111111;
    #1e+6; bin <= 8'b01111111;
    #1e+6; bin <= 8'b10111111;
    #1e+6; bin <= 8'b11111111;
end

always begin
    #0.5 clk <= ~clk;
end
endmodule
