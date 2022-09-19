`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/09/19 19:25:36
// Design Name: 
// Module Name: comparator_4bit
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


module comparator_4bit(a, b, x, y, z);

input [3:0] a, b;

output x, y, z;

wire x, y, z;

// x : A>B case
assign x = (a > b) ? 1'b1: 1'b0;

// y : A=B case
assign y = (a == b) ? 1'b1: 1'b0;

// z : A<B case
assign z = (a < b) ? 1'b1: 1'b0;

endmodule
