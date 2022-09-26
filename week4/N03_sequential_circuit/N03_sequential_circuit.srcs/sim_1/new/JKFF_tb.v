`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/09/26 17:36:35
// Design Name: 
// Module Name: JKFF_tb
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


module JKFF_tb();

reg clk, J, K;
wire Q;

JKFF u1(clk, J, K, Q);

initial begin
    clk <= 0;
    #30 {J,K} <= 2'b00;
    #30 {J,K} <= 2'b01;
    #30 {J,K} <= 2'b10;
    #30 {J,K} <= 2'b11;
    #30 {J,K} <= 2'b00;
    #30 {J,K} <= 2'b01;
    #30 {J,K} <= 2'b10;
    #30 {J,K} <= 2'b11;
end

always begin
    #5 clk <= ~clk;
end

endmodule
