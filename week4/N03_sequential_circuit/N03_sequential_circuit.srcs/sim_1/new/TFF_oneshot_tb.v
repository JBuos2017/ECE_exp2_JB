`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/09/26 18:50:37
// Design Name: 
// Module Name: TFF_oneshot_tb
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


module TFF_oneshot_tb();

reg clk, T, rst;
wire Q;

TFF_oneshot u1(clk, rst, T, Q);

initial begin
    clk <= 0;
    rst <= 1;
    #10 rst <= 0;
    #10 rst <= 1;
    #60 T <= 0;
    #60 T <= 1;
    #60 T <= 0;
    #60 T <= 1;
    #60 T <= 0;
    #60 T <= 1;
    #60 T <= 0;
end

always begin
    #5 clk <= ~clk;
end


endmodule
