`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/09/16 20:20:27
// Design Name: 
// Module Name: FA_tb
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


module FA_tb();
// input
reg x, y, z;
// output
wire s, c;
//Instantiate the U1
FA u1(x, y, z, s, c);
// Specify input stimulus
initial begin
    {x, y, z} = 2'b000;
    #10 {x, y, z} = 2'b001;
    #10 {x, y, z} = 2'b010;
    #10 {x, y, z} = 2'b011;
    #10 x = 1; y = 0; z = 0;
    #10 x = 1; y = 0; z = 1;
    #10 x = 1; y = 1; z = 0;
    #10 x = 1; y = 1; z = 1;
end
endmodule
