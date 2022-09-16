`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/09/16 14:08:32
// Design Name: 
// Module Name: HA_case
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


module HA_case(a, b, s, c);

input a, b;

output reg s, c;

always @ (a, b) begin
    case({a, b})
        2'b00 : {s, c} = 2'b00;
        2'b01 : {s, c} = 2'b10;
        2'b10 : {s, c} = 2'b10;
        2'b11 : {s, c} = 2'b01;
    endcase
end

endmodule
