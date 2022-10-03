`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/10/03 16:26:53
// Design Name: 
// Module Name: counter_up_2bit_tb
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


module counter_up_2bit_tb();
reg clk, rst, x;
wire [1:0] state;


counter_up_2bit u1(clk, rst, x, state);
initial begin
    clk =0; rst = 1; x=0; //4.1.1 00->01
    #10 rst = 0;
    #10 rst = 1;
    #20 x = 1;  
    #20 x = 0;
    #20 x = 1;  
    #20 x = 0;
    #20 x = 1;  
    #20 x = 0;
    #20 x = 1;  
    #20 x = 0;
    #20 x = 1;  
    #20 x = 0;
    #20 x = 1;  
    #20 x = 0;  
    #20 x = 1;  
    #20 x = 0;
    
end

always begin
    #5 clk = ~clk;
end

endmodule
