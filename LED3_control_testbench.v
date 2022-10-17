`timescale 1us / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/10/18 00:26:58
// Design Name: 
// Module Name: LED3_control_testbench
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


module LED3_control_testbench();


reg clk, rst;
reg [7:0] btn;

wire [3:0] led_signal_R;
wire [3:0] led_signal_G;
wire [3:0] led_signal_B;

LED3_control c1(clk, rst, btn, led_signal_R, led_signal_G, led_signal_B);

initial begin 
    clk <= 0; rst <= 1; btn <= 8'b00000001;
    #1e+6; rst <= 0;
    #1e+6; rst <= 1;
    #1e+6; btn <= 8'b00000001;
    #1e+6; btn <= 8'b00000010;
    #1e+6; btn <= 8'b00000100;
end

always begin
    #0.5 clk <= ~clk;
end
endmodule

