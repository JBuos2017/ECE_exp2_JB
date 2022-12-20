`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/28 20:48:17
// Design Name: 
// Module Name: clock
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


module clock(rst, clk, time_spd, add_hour_t, hour, min, sec, d_or_n);

input rst, clk;
input add_hour_t;
input [1:0] time_spd;
output reg [7:0] hour, min, sec;
output reg d_or_n;

reg i2so, so2st, st2mo, mo2mt, mt2ho, ho2ht, ht2d;
wire i2so_t, so2st_t, st2mo_t, mo2mt_t, mt2ho_t, ho2ht_t, ht2d_t;

reg [12:0] i;

oneshot_universal #(.WIDTH(7)) u2(clk, rst, {i2so, so2st, st2mo, mo2mt, mt2ho, ho2ht, ht2d}, {i2so_t, so2st_t, st2mo_t, mo2mt_t, mt2ho_t, ho2ht_t, ht2d_t});

always @(negedge rst or posedge clk) begin // time speed
    if(~rst) begin;
        i = 0;
        i2so=0;
    end
    else begin
        case(time_spd) 
            2'b00 : 
                if(i>=1000) begin
                    i2so = 1;
                    i=0;
                end
                else begin
                    i=i+1;
                    i2so=0;
                end
            2'b01 : if(i>=100) begin
                    i2so = 1;
                    i=0;
                end
                else begin
                    i=i+1;
                    i2so=0;
                end
            2'b10 : if(i>=10) begin
                    i2so = 1;
                    i=0;
                end
                else begin
                    i=i+1;
                    i2so=0;
                end
            2'b11 : if(i>=5) begin
                    i2so = 1;
                    i=0;
                end
                else begin
                    i=i+1;
                    i2so=0;
                end
        endcase
    end
end

always @(negedge rst or posedge clk) begin //sec[7:4]
    if(~rst) begin
        sec[3:0] = 0;
        so2st=0;
    end
    else begin
        if(i2so_t) begin
            if(sec[3:0]==9) begin
                sec[3:0]<=0;
                so2st<=1;
            end
            else begin
                sec[3:0] <= sec[3:0] + 1;
                so2st<=0;
            end
        end
    end
end

always @(negedge rst or posedge clk) begin //sec[7:4]
    if(~rst) begin
        sec[7:4] = 0;
        st2mo=0;
    end
    else begin
        if(so2st_t) begin
            if(sec[7:4]==5) begin
                sec[7:4]<=0;
                st2mo<=1;
            end
            else begin
                sec[7:4] <= sec[7:4] + 1;
                st2mo<=0;
            end
        end
    end
end

always @(negedge rst or posedge clk) begin //min[3:0]
    if(~rst) begin
        min[3:0] = 0;
        mo2mt=0;
    end
    else begin
        if(st2mo_t) begin
            if(min[3:0]==9) begin
                min[3:0]<=0;
                mo2mt<=1;
            end
            else begin
                min[3:0] <= min[3:0] + 1;
                mo2mt<=0;
            end
        end
    end
end

always @(negedge rst or posedge clk) begin //min[7:4]
    if(~rst) begin
        min[7:4] = 0;
        mt2ho=0;
    end
    else begin
        if(mo2mt_t) begin
            if(min[7:4]==5) begin
                min[7:4]<=0;
                mt2ho<=1;
            end
            else begin
                min[7:4] <= min[7:4] + 1;
                mt2ho<=0;
            end
        end
    end
end

always @(negedge rst or posedge clk) begin //hour[3:0]
    if(~rst) begin
        hour[3:0] = 0;
        ho2ht=0;
        ht2d=0;
    end
    else begin
        if(mt2ho_t | add_hour_t) begin
            if(hour[3:0]==9) begin
                hour[3:0]<=0;
                ho2ht <= 1;
            end
            else begin
                if(hour[3:0]==3 & hour[7:4]==2) begin
                    hour[3:0]<=0;
                    ht2d <= 1;
                end
                else begin
                    hour[3:0] <= hour[3:0] + 1;
                    ht2d <= 0;
                    ho2ht <= 0;
                end
            end
        end
    end
end

always @(negedge rst or posedge clk) begin
    if(~rst) begin
        hour[7:4] = 0;
    end
    else begin
        if(ht2d_t) hour[7:4]<=0;
        else begin
            if(ho2ht_t) hour[7:4] <= hour[7:4] + 1;
        end
    end
end

always @(negedge rst or posedge clk) begin
    if(~rst) begin
        d_or_n = 1; //0:day, 1:night
    end
    else begin
        if(hour[7:4]*10 + hour[3:0] >= 8 & hour[7:4]*10 + hour[3:0] < 23) begin
            d_or_n <= 0;
        end
        else d_or_n <= 1;
    end
end

endmodule
