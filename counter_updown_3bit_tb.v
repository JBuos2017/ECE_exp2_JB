`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/10/03 17:25:15
// Design Name: 
// Module Name: counter_updown_3bit_tb
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


module counter_updown_3bit_tb();
reg clk, rst, x;
wire [2:0] state;

counter_updowm_3bit u1(clk, rst, x, state);
initial begin
    clk =0; rst = 1; x=0; 
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
