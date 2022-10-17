`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/10/17 17:34:23
// Design Name: 
// Module Name: counter8
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


module counter8(clk, rst, cnt);

input clk, rst;
output reg [7:0] cnt;

always @(posedge clk or negedge rst) begin
    if(!rst) begin
        cnt <= 8'b0000_0000;
    end
    else cnt <= cnt + 1;
end
endmodule
