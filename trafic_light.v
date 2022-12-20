`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/28 20:41:49
// Design Name: 
// Module Name: trafic_light
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


module trafic_light(rst, clk, time_spd, add_hour, emgc_btn, LCD_E, LCD_RS, LCD_RW, LCD_DATA, N_C, W_C, S_C, E_C, Walk);

input rst, clk;
input add_hour, emgc_btn;
input [1:0] time_spd;

output LCD_E, LCD_RS, LCD_RW;
output wire [7:0] LCD_DATA;
//output reg [3:0] N_C_out, W_C_out, S_C_out, E_C_out; // L,G,Y,R
//output reg [7:0] walk_out; // NR,NG,WR,WG,SR,SG,ER,EG


output reg [3:0] N_C, W_C, S_C, E_C; // L,G,Y,R
output reg [7:0] Walk; // NR,NG,WR,WG,SR,SG,ER,EG



wire d_or_n;
wire add_hour_t, emgc_btn_t; 
wire [7:0] hour, min, sec;
reg [3:0] t_state; 
reg [2:0] prev_t_state;
reg emgc;
reg d_or_n_stay;
//reg [1:0] direction;
integer emgc_cnt;

wire LCD_E;

parameter A = 4'b0000,
          B = 4'b0001,
          C = 4'b0010,
          D = 4'b0011,
          E = 4'b0100,
          F = 4'b0101,
          G = 4'b0110,
          H = 4'b0111,
          E_A = 4'b1000,
          
          L_A = 24'b0100_0001_0100_0001_10_01_10_01,
          L_A_F = 24'b0100_0001_0100_0001_10_00_10_00,
          L_A_Y = 24'b0010_0010_0010_0010_10_01_10_01,
          L_A_Y_F = 24'b0010_0010_0010_0010_10_00_10_00,
          // L,G,Y,R,  NR,NG,WR,WG,SR,SG,ER,EG
          L_B = 24'b1100_0001_0001_0001_10_10_10_01,
          L_B_F = 24'b1100_0001_0001_0001_10_10_10_00,
          L_B_Y = 24'b0010_0010_0010_0010_10_10_10_01,
          L_B_Y_F = 24'b0010_0010_0010_0010_10_10_10_00,
          // L,G,Y,R,  NR,NG,WR,WG,SR,SG,ER,EG
          L_C = 24'b0001_0001_1100_0001_10_01_10_10,
          L_C_F = 24'b0001_0001_1100_0001_10_00_10_10,
          L_C_Y = 24'b0010_0010_0010_0010_10_01_10_10,
          L_C_Y_F = 24'b0010_0010_0010_0010_10_00_10_10,
          // L,G,Y,R,  NR,NG,WR,WG,SR,SG,ER,EG
          L_D = 24'b1000_0001_1000_0001_10_10_10_10,
          L_D_Y = 24'b0010_0010_0010_0010_10_10_10_10,
          // L,G,Y,R,  NR,NG,WR,WG,SR,SG,ER,EG
          L_E = 24'b0001_0100_0001_0100_01_10_01_10,
          L_E_F = 24'b0001_0100_0001_0100_00_10_00_10,
          L_E_Y = 24'b0010_0010_0010_0010_01_10_01_10,
          L_E_Y_F = 24'b0010_0010_0010_0010_00_10_00_10,
          // L,G,Y,R,  NR,NG,WR,WG,SR,SG,ER,EG
          L_F = 24'b0001_1100_0001_0001_01_10_10_10,
          L_F_F = 24'b0001_1100_0001_0001_00_10_10_10,
          L_F_Y = 24'b0010_0010_0010_0010_01_10_10_10,
          L_F_Y_F = 24'b0010_0010_0010_0010_00_10_10_10,
          // L,G,Y,R,  NR,NG,WR,WG,SR,SG,ER,EG
          L_G = 24'b0001_0001_0001_1100_10_10_01_10,
          L_G_F = 24'b0001_0001_0001_1100_10_10_00_10,
          L_G_Y = 24'b0010_0010_0010_0010_10_10_01_10,
          L_G_Y_F = 24'b0010_0010_0010_0010_10_10_00_10,
          // L,G,Y,R,  NR,NG,WR,WG,SR,SG,ER,EG
          L_H = 24'b0001_1000_0001_1000_10_10_10_10,
          L_H_Y = 24'b0010_0010_0010_0010_10_10_10_10,
          
          north = 2'b00,
          west = 2'b01,
          south = 2'b10,
          east = 2'b11;

integer t_cnt;

oneshot_universal #(.WIDTH(2)) u1(clk, rst, {add_hour, emgc_btn}, {add_hour_t, emgc_btn_t});
clock c1(rst, clk, time_spd, add_hour_t, hour, min, sec, d_or_n);
LCD l1(rst, clk, hour, min, sec, d_or_n, t_state, LCD_E, LCD_RS, LCD_RW, LCD_DATA);


/*always @(posedge clk or negedge rst)
begin
    if(!rst) direction <= north;
    else begin
        case (direction)
            north : direction <= west;
            west : direction <= south;
            south : direction <= east;
            east : direction <= north;
        endcase
    end
end
*/        

//emgc
/*always @(posedge clk or negedge rst)
begin
    if(!rst) emgc = 0;
    else begin
        if(emgc_btn_t) emgc = !emgc;
    end
end*/

//state
always @(posedge clk or negedge rst)
begin
    if(!rst) begin
        t_state = B;
        t_cnt = 0;
        prev_t_state = H;
        d_or_n_stay = 1;
        emgc = 0;
    end
    else begin
        if(emgc_btn_t) emgc = !emgc;
        else begin
        if(d_or_n_stay) begin // night
            case(t_state)
                B : begin
                    if(t_cnt >= 10000) begin
                        if(emgc) begin
                            t_state = E_A;
                            t_cnt = 0;
                            prev_t_state = B;
                            d_or_n_stay = d_or_n;
                            emgc_cnt = 0;
                        end
                        else begin
                            if(!d_or_n) begin
                                t_state = A;
                                t_cnt = 0;
                                prev_t_state = B;
                                d_or_n_stay = d_or_n;
                            end
                            else begin
                                t_state = A;
                                t_cnt = 0;
                                prev_t_state = B;
                                d_or_n_stay = d_or_n;
                            end
                        end 
                    end   
                    else begin//emgc
                        if(emgc) begin
                            if(emgc_cnt >= 1000) begin
                                t_state = E_A;
                                t_cnt = 0;
                                emgc_cnt = 0;
                                d_or_n_stay = d_or_n;
                                prev_t_state = B;
                            end
                            else begin
                                t_cnt = t_cnt + 1;
                                emgc_cnt = emgc_cnt + 1;
                            end
                        end
                        else begin
                            t_cnt = t_cnt + 1;
                        end
                    end
                end
                
                A : begin
                    if(t_cnt >= 10000) begin
                        if(emgc) begin
                            t_state = E_A;
                            t_cnt = 0;
                            prev_t_state = A;
                            d_or_n_stay = d_or_n;
                            emgc_cnt = 0;
                        end
                        else begin
                            if(!d_or_n) begin
                                t_state = A;
                                t_cnt = 0;
                                prev_t_state = A;
                                d_or_n_stay = d_or_n;
                            end
                            else begin
                                if(prev_t_state == B) begin
                                    t_state = C;
                                    t_cnt = 0;
                                    prev_t_state = A;
                                    d_or_n_stay = d_or_n;
                                end
                                else begin
                                    t_state = E;
                                    t_cnt = 0;
                                    prev_t_state = A;
                                    d_or_n_stay = d_or_n;
                                end
                            end
                        end 
                    end   
                    else begin//emgc
                        if(emgc) begin
                            if(emgc_cnt >= 1000) begin
                                t_state = E_A;
                                t_cnt = 0;
                                emgc_cnt = 0;
                                d_or_n_stay = d_or_n;
                                prev_t_state = A;
                            end
                            else begin
                                t_cnt = t_cnt + 1;
                                emgc_cnt = emgc_cnt + 1;
                            end
                        end
                        else begin
                            t_cnt = t_cnt + 1;
                        end
                    end
                end
                
                C : begin
                    if(t_cnt >= 10000) begin
                        if(emgc) begin
                            t_state = E_A;
                            t_cnt = 0;
                            prev_t_state = C;
                            d_or_n_stay = d_or_n;
                            emgc_cnt = 0;
                        end
                        else begin
                            if(!d_or_n) begin
                                t_state = A;
                                t_cnt = 0;
                                prev_t_state = C;
                                d_or_n_stay = d_or_n;
                            end
                            else begin
                                t_state = A;
                                t_cnt = 0;
                                prev_t_state = C;
                                d_or_n_stay = d_or_n;
                            end
                        end 
                    end   
                    else begin//emgc
                        if(emgc) begin
                            if(emgc_cnt >= 1000) begin
                                t_state = E_A;
                                t_cnt = 0;
                                emgc_cnt = 0;
                                d_or_n_stay = d_or_n;
                                prev_t_state = C;
                            end
                            else begin
                                t_cnt = t_cnt + 1;
                                emgc_cnt = emgc_cnt + 1;
                            end
                        end
                        else begin
                            t_cnt = t_cnt + 1;
                        end
                    end
                end
                
                E : begin
                    if(t_cnt >= 10000) begin
                        if(emgc) begin
                            t_state = E_A;
                            t_cnt = 0;
                            prev_t_state = E;
                            d_or_n_stay = d_or_n;
                            emgc_cnt = 0;
                        end
                        else begin
                            if(!d_or_n) begin
                                t_state = A;
                                t_cnt = 0;
                                prev_t_state = E;
                                d_or_n_stay = d_or_n;
                            end
                            else begin
                                t_state = H;
                                t_cnt = 0;
                                prev_t_state = E;
                                d_or_n_stay = d_or_n;
                            end
                        end 
                    end   
                    else begin//emgc
                        if(emgc) begin
                            if(emgc_cnt >= 1000) begin
                                t_state = E_A;
                                t_cnt = 0;
                                emgc_cnt = 0;
                                d_or_n_stay = d_or_n;
                                prev_t_state = E;
                            end
                            else begin
                                t_cnt = t_cnt + 1;
                                emgc_cnt = emgc_cnt + 1;
                            end
                        end
                        else begin
                            t_cnt = t_cnt + 1;
                        end
                    end
                end
                
                H : begin
                    if(t_cnt >= 10000) begin
                        if(emgc) begin
                            t_state = E_A;
                            t_cnt = 0;
                            prev_t_state = H;
                            d_or_n_stay = d_or_n;
                            emgc_cnt = 0;
                        end
                        else begin
                            if(!d_or_n) begin
                                t_state = A;
                                t_cnt = 0;
                                prev_t_state = H;
                                d_or_n_stay = d_or_n;
                            end
                            else begin
                                t_state = B;
                                t_cnt = 0;
                                prev_t_state = H;
                                d_or_n_stay = d_or_n;
                            end
                        end 
                    end   
                    else begin//emgc
                        if(emgc) begin
                            if(emgc_cnt >= 1000) begin
                                t_state = E_A;
                                t_cnt = 0;
                                emgc_cnt = 0;
                                d_or_n_stay = d_or_n;
                                prev_t_state = H;
                            end
                            else begin
                                t_cnt = t_cnt + 1;
                                emgc_cnt = emgc_cnt + 1;
                            end
                        end
                        else begin
                            t_cnt = t_cnt + 1;
                        end
                    end
                end
                
                E_A : begin
                    if(t_cnt >= 15000) begin
                        if(!d_or_n) begin
                            t_state = A;
                            t_cnt = 0;
                            emgc = 0;
                            d_or_n_stay = d_or_n;
                        end
                        else begin
                            t_state = prev_t_state;
                            d_or_n_stay = d_or_n;
                            t_cnt = 0;
                            emgc = 0;
                        end 
                    end   
                    else t_cnt = t_cnt + 1;
                end
            endcase
        end
        
        
        
        //day
        else begin
            case(t_state)
                A : begin
                    if(t_cnt >= 5000) begin
                        if(emgc) begin
                            t_state = E_A;
                            t_cnt = 0;
                            prev_t_state = A;
                            d_or_n_stay = d_or_n;
                            emgc_cnt = 0;
                        end
                        else begin
                            if(d_or_n) begin
                                t_state = B;
                                t_cnt = 0;
                                prev_t_state = A;
                                d_or_n_stay = d_or_n;
                            end
                            else begin
                                t_state = D;
                                t_cnt = 0;
                                prev_t_state = A;
                                d_or_n_stay = d_or_n;
                            end
                        end 
                    end   
                    else begin//emgc
                        if(emgc) begin
                            if(emgc_cnt >= 1000) begin
                                t_state = E_A;
                                t_cnt = 0;
                                emgc_cnt = 0;
                                d_or_n_stay = d_or_n;
                                prev_t_state = A;
                            end
                            else begin
                                t_cnt = t_cnt + 1;
                                emgc_cnt = emgc_cnt + 1;
                            end
                        end
                        else begin
                            t_cnt = t_cnt + 1;
                        end
                    end
                end
                
                D : begin
                    if(t_cnt >= 5000) begin
                        if(emgc) begin
                            t_state = E_A;
                            t_cnt = 0;
                            prev_t_state = D;
                            d_or_n_stay = d_or_n;
                            emgc_cnt = 0;
                        end
                        else begin
                            if(d_or_n) begin
                                t_state = B;
                                t_cnt = 0;
                                prev_t_state = D;
                                d_or_n_stay = d_or_n;
                            end
                            else begin
                                t_state = F;
                                t_cnt = 0;
                                prev_t_state = D;
                                d_or_n_stay = d_or_n;
                            end
                        end 
                    end   
                    else begin//emgc
                        if(emgc) begin
                            if(emgc_cnt >= 1000) begin
                                t_state = E_A;
                                t_cnt = 0;
                                emgc_cnt = 0;
                                d_or_n_stay = d_or_n;
                                prev_t_state = D;
                            end
                            else begin
                                t_cnt = t_cnt + 1;
                                emgc_cnt = emgc_cnt + 1;
                            end
                        end
                        else begin
                            t_cnt = t_cnt + 1;
                        end
                    end
                end
                
                
                F : begin
                    if(t_cnt >= 5000) begin
                        if(emgc) begin
                            t_state = E_A;
                            t_cnt = 0;
                            prev_t_state = F;
                            d_or_n_stay = d_or_n;
                            emgc_cnt = 0;
                        end
                        else begin
                            if(d_or_n) begin
                                t_state = B;
                                t_cnt = 0;
                                prev_t_state = F;
                                d_or_n_stay = d_or_n;
                            end
                            else begin
                                t_state = E;
                                t_cnt = 0;
                                prev_t_state = F;
                                d_or_n_stay = d_or_n;
                            end
                        end 
                    end   
                    else begin//emgc
                        if(emgc) begin
                            if(emgc_cnt >= 1000) begin
                                t_state = E_A;
                                t_cnt = 0;
                                emgc_cnt = 0;
                                d_or_n_stay = d_or_n;
                                prev_t_state = F;
                            end
                            else begin
                                t_cnt = t_cnt + 1;
                                emgc_cnt = emgc_cnt + 1;
                            end
                        end
                        else begin
                            t_cnt = t_cnt + 1;
                        end
                    end
                end
                
                E : begin
                    if(t_cnt >= 5000) begin
                        if(emgc) begin
                            t_state = E_A;
                            t_cnt = 0;
                            prev_t_state = E;
                            d_or_n_stay = d_or_n;
                            emgc_cnt = 0;
                        end
                        else begin
                            if(d_or_n) begin
                                t_state = B;
                                t_cnt = 0;
                                prev_t_state = E;
                                d_or_n_stay = d_or_n;
                            end
                            else begin
                                if(prev_t_state == F) begin
                                    t_state = G;
                                    t_cnt = 0;
                                    prev_t_state = E;
                                    d_or_n_stay = d_or_n;
                                end
                                else begin
                                    t_state = A;
                                    t_cnt = 0;
                                    prev_t_state = E;
                                    d_or_n_stay = d_or_n;
                                end
                            end
                        end 
                    end   
                    else begin//emgc
                        if(emgc) begin
                            if(emgc_cnt >= 1000) begin
                                t_state = E_A;
                                t_cnt = 0;
                                emgc_cnt = 0;
                                d_or_n_stay = d_or_n;
                                prev_t_state = E;
                            end
                            else begin
                                t_cnt = t_cnt + 1;
                                emgc_cnt = emgc_cnt + 1;
                            end
                        end
                        else begin
                            t_cnt = t_cnt + 1;
                        end
                    end
                end
                
                G : begin
                    if(t_cnt >= 5000) begin
                        if(emgc) begin
                            t_state = E_A;
                            t_cnt = 0;
                            prev_t_state = G;
                            d_or_n_stay = d_or_n;
                            emgc_cnt = 0;
                        end
                        else begin
                            if(d_or_n) begin
                                t_state = B;
                                t_cnt = 0;
                                prev_t_state = G;
                                d_or_n_stay = d_or_n;
                            end
                            else begin
                                t_state = E;
                                t_cnt = 0;
                                prev_t_state = G;
                                d_or_n_stay = d_or_n;
                            end
                        end 
                    end   
                    else begin//emgc
                        if(emgc) begin
                            if(emgc_cnt >= 1000) begin
                                t_state = E_A;
                                t_cnt = 0;
                                emgc_cnt = 0;
                                d_or_n_stay = d_or_n;
                                prev_t_state = G;
                            end
                            else begin
                                t_cnt = t_cnt + 1;
                                emgc_cnt = emgc_cnt + 1;
                            end
                        end
                        else begin
                            t_cnt = t_cnt + 1;
                        end
                    end
                end
                
                E_A : begin
                    if(t_cnt >= 15000) begin
                        if(!d_or_n) begin
                            t_state = A;
                            t_cnt = 0;
                            emgc = 0;
                            d_or_n_stay = d_or_n;
                        end
                        else begin
                            t_state = prev_t_state;
                            d_or_n_stay = d_or_n;
                            t_cnt = 0;
                            emgc = 0;
                        end 
                    end   
                    else t_cnt = t_cnt + 1;
                end
            endcase
        end
        end
    end
end

//light

always @(posedge clk or negedge rst)
begin
    if(!rst) {N_C,W_C,S_C,E_C,Walk} <= 24'b1111_1111_1111_1111_11_11_11_11;
    else begin
        if(d_or_n_stay) begin // night
            case(t_state)
                B : begin
                    if(emgc) {N_C,W_C,S_C,E_C,Walk} <= L_B_Y;
                    else begin
                        if(t_cnt < 5000) {N_C,W_C,S_C,E_C,Walk} <= L_B;
                        else if(t_cnt >= 5000 & t_cnt < 5500) {N_C,W_C,S_C,E_C,Walk} <= L_B_F;
                        else if(t_cnt >= 5500 & t_cnt < 6000) {N_C,W_C,S_C,E_C,Walk} <= L_B;
                        else if(t_cnt >= 6000 & t_cnt < 6500) {N_C,W_C,S_C,E_C,Walk} <= L_B_F;
                        else if(t_cnt >= 6500 & t_cnt < 7000) {N_C,W_C,S_C,E_C,Walk} <= L_B;
                        else if(t_cnt >= 7000 & t_cnt < 7500) {N_C,W_C,S_C,E_C,Walk} <= L_B_F;
                        else if(t_cnt >= 7500 & t_cnt < 8000) {N_C,W_C,S_C,E_C,Walk} <= L_B;
                        else if(t_cnt >= 8000 & t_cnt < 8500) {N_C,W_C,S_C,E_C,Walk} <= L_B_F;
                        else if(t_cnt >= 8500 & t_cnt < 9000) {N_C,W_C,S_C,E_C,Walk} <= L_B;
                        else if(t_cnt >= 9000 & t_cnt < 9500) {N_C,W_C,S_C,E_C,Walk} <= L_B_Y_F;
                        else {N_C,W_C,S_C,E_C,Walk} <= L_B_Y;
                    end
                end
                
                A : begin
                    if(emgc) {N_C,W_C,S_C,E_C,Walk} <= L_A_Y;
                    else begin
                        if(t_cnt < 5000) {N_C,W_C,S_C,E_C,Walk} <= L_A;
                        else if(t_cnt >= 5000 & t_cnt < 5500) {N_C,W_C,S_C,E_C,Walk} <= L_A_F;
                        else if(t_cnt >= 5500 & t_cnt < 6000) {N_C,W_C,S_C,E_C,Walk} <= L_A;
                        else if(t_cnt >= 6000 & t_cnt < 6500) {N_C,W_C,S_C,E_C,Walk} <= L_A_F;
                        else if(t_cnt >= 6500 & t_cnt < 7000) {N_C,W_C,S_C,E_C,Walk} <= L_A;
                        else if(t_cnt >= 7000 & t_cnt < 7500) {N_C,W_C,S_C,E_C,Walk} <= L_A_F;
                        else if(t_cnt >= 7500 & t_cnt < 8000) {N_C,W_C,S_C,E_C,Walk} <= L_A;
                        else if(t_cnt >= 8000 & t_cnt < 8500) {N_C,W_C,S_C,E_C,Walk} <= L_A_F;
                        else if(t_cnt >= 8500 & t_cnt < 9000) {N_C,W_C,S_C,E_C,Walk} <= L_A;
                        else if(t_cnt >= 9000 & t_cnt < 9500) {N_C,W_C,S_C,E_C,Walk} <= L_A_Y_F;
                        else {N_C,W_C,S_C,E_C,Walk} <= L_A_Y;
                    end
                end
                
                C : begin
                    if(emgc) {N_C,W_C,S_C,E_C,Walk} <= L_C_Y;
                    else begin
                        if(t_cnt < 5000) {N_C,W_C,S_C,E_C,Walk} <= L_C;
                        else if(t_cnt >= 5000 & t_cnt < 5500) {N_C,W_C,S_C,E_C,Walk} <= L_C_F;
                        else if(t_cnt >= 5500 & t_cnt < 6000) {N_C,W_C,S_C,E_C,Walk} <= L_C;
                        else if(t_cnt >= 6000 & t_cnt < 6500) {N_C,W_C,S_C,E_C,Walk} <= L_C_F;
                        else if(t_cnt >= 6500 & t_cnt < 7000) {N_C,W_C,S_C,E_C,Walk} <= L_C;
                        else if(t_cnt >= 7000 & t_cnt < 7500) {N_C,W_C,S_C,E_C,Walk} <= L_C_F;
                        else if(t_cnt >= 7500 & t_cnt < 8000) {N_C,W_C,S_C,E_C,Walk} <= L_C;
                        else if(t_cnt >= 8000 & t_cnt < 8500) {N_C,W_C,S_C,E_C,Walk} <= L_C_F;
                        else if(t_cnt >= 8500 & t_cnt < 9000) {N_C,W_C,S_C,E_C,Walk} <= L_C;
                        else if(t_cnt >= 9000 & t_cnt < 9500) {N_C,W_C,S_C,E_C,Walk} <= L_C_Y_F;
                        else {N_C,W_C,S_C,E_C,Walk} <= L_C_Y;
                    end
                end
                
                E : begin
                if(emgc) {N_C,W_C,S_C,E_C,Walk} <= L_E_Y;
                    else begin
                        if(t_cnt < 5000) {N_C,W_C,S_C,E_C,Walk} <= L_E;
                        else if(t_cnt >= 5000 & t_cnt < 5500) {N_C,W_C,S_C,E_C,Walk} <= L_E_F;
                        else if(t_cnt >= 5500 & t_cnt < 6000) {N_C,W_C,S_C,E_C,Walk} <= L_E;
                        else if(t_cnt >= 6000 & t_cnt < 6500) {N_C,W_C,S_C,E_C,Walk} <= L_E_F;
                        else if(t_cnt >= 6500 & t_cnt < 7000) {N_C,W_C,S_C,E_C,Walk} <= L_E;
                        else if(t_cnt >= 7000 & t_cnt < 7500) {N_C,W_C,S_C,E_C,Walk} <= L_E_F;
                        else if(t_cnt >= 7500 & t_cnt < 8000) {N_C,W_C,S_C,E_C,Walk} <= L_E;
                        else if(t_cnt >= 8000 & t_cnt < 8500) {N_C,W_C,S_C,E_C,Walk} <= L_E_F;
                        else if(t_cnt >= 8500 & t_cnt < 9000) {N_C,W_C,S_C,E_C,Walk} <= L_E;
                        else if(t_cnt >= 9000 & t_cnt < 9500) {N_C,W_C,S_C,E_C,Walk} <= L_E_Y_F;
                        else {N_C,W_C,S_C,E_C,Walk} <= L_E_Y;
                    end
                end
                
                H : begin
                    if(emgc) {N_C,W_C,S_C,E_C,Walk} <= L_H_Y;
                    else begin
                        if(t_cnt < 8500) {N_C,W_C,S_C,E_C,Walk} <= L_H;
                        else {N_C,W_C,S_C,E_C,Walk} <= L_H_Y;
                        end
                    end
                
                E_A : begin
                    if(t_cnt < 7500) {N_C,W_C,S_C,E_C,Walk} <= L_A;
                    else if(t_cnt >= 7500 & t_cnt < 8000) {N_C,W_C,S_C,E_C,Walk} <= L_A_F;
                    else if(t_cnt >= 8000 & t_cnt < 8500) {N_C,W_C,S_C,E_C,Walk} <= L_A;
                    else if(t_cnt >= 8500 & t_cnt < 9000) {N_C,W_C,S_C,E_C,Walk} <= L_A_F;
                    else if(t_cnt >= 9000 & t_cnt < 9500) {N_C,W_C,S_C,E_C,Walk} <= L_A;
                    else if(t_cnt >= 9500 & t_cnt < 10000) {N_C,W_C,S_C,E_C,Walk} <= L_A_F;
                    else if(t_cnt >= 10000 & t_cnt < 10500) {N_C,W_C,S_C,E_C,Walk} <= L_A;
                    else if(t_cnt >= 10500 & t_cnt < 11000) {N_C,W_C,S_C,E_C,Walk} <= L_A_F;                
                    else if(t_cnt >= 11000 & t_cnt < 11500) {N_C,W_C,S_C,E_C,Walk} <= L_A;
                    else if(t_cnt >= 11500 & t_cnt < 12000) {N_C,W_C,S_C,E_C,Walk} <= L_A_F;
                    else if(t_cnt >= 12000 & t_cnt < 12500) {N_C,W_C,S_C,E_C,Walk} <= L_A;
                    else if(t_cnt >= 12500 & t_cnt < 13000) {N_C,W_C,S_C,E_C,Walk} <= L_A_F;
                    else if(t_cnt >= 13000 & t_cnt < 13500) {N_C,W_C,S_C,E_C,Walk} <= L_A;                    
                    else if(t_cnt >= 13500 & t_cnt < 14000) {N_C,W_C,S_C,E_C,Walk} <= L_A_F;
                    else if(t_cnt >= 14000 & t_cnt < 14500) {N_C,W_C,S_C,E_C,Walk} <= L_A_Y;
                    else {N_C,W_C,S_C,E_C,Walk} <= L_A_Y_F;
                end
            endcase
        end
        
        else begin
            case(t_state)
                A : begin
                    if(emgc) {N_C,W_C,S_C,E_C,Walk} <= L_A_Y;
                    else begin
                        if(t_cnt < 2500) {N_C,W_C,S_C,E_C,Walk} <= L_A;
                        else if(t_cnt >= 2500 & t_cnt < 3000) {N_C,W_C,S_C,E_C,Walk} <= L_A_F;
                        else if(t_cnt >= 3000 & t_cnt < 3500) {N_C,W_C,S_C,E_C,Walk} <= L_A;
                        else if(t_cnt >= 3500 & t_cnt < 4000) {N_C,W_C,S_C,E_C,Walk} <= L_A_F;
                        else if(t_cnt >= 4000 & t_cnt < 4500) {N_C,W_C,S_C,E_C,Walk} <= L_A_Y;
                        else {N_C,W_C,S_C,E_C,Walk} <= L_A_Y_F;
                    end
                end
                
                D : begin
                    if(emgc) {N_C,W_C,S_C,E_C,Walk} <= L_D_Y;
                    else begin
                        if(t_cnt < 3500) {N_C,W_C,S_C,E_C,Walk} <= L_D;
                        else {N_C,W_C,S_C,E_C,Walk} <= L_D_Y;
                    end
                end
                
                F : begin
                    if(emgc) {N_C,W_C,S_C,E_C,Walk} <= L_F_Y;
                    else begin
                        if(t_cnt < 2500) {N_C,W_C,S_C,E_C,Walk} <= L_F;
                        else if(t_cnt >= 2500 & t_cnt < 3000) {N_C,W_C,S_C,E_C,Walk} <= L_F_F;
                        else if(t_cnt >= 3000 & t_cnt < 3500) {N_C,W_C,S_C,E_C,Walk} <= L_F;
                        else if(t_cnt >= 3500 & t_cnt < 4000) {N_C,W_C,S_C,E_C,Walk} <= L_F_F;
                        else if(t_cnt >= 4000 & t_cnt < 4500) {N_C,W_C,S_C,E_C,Walk} <= L_F_Y;
                        else {N_C,W_C,S_C,E_C,Walk} <= L_F_Y_F;
                    end
                end
                
                E : begin
                    if(emgc) {N_C,W_C,S_C,E_C,Walk} <= L_E_Y;
                    else begin
                        if(t_cnt < 2500) {N_C,W_C,S_C,E_C,Walk} <= L_E;
                        else if(t_cnt >= 2500 & t_cnt < 3000) {N_C,W_C,S_C,E_C,Walk} <= L_E_F;
                        else if(t_cnt >= 3000 & t_cnt < 3500) {N_C,W_C,S_C,E_C,Walk} <= L_E;
                        else if(t_cnt >= 3500 & t_cnt < 4000) {N_C,W_C,S_C,E_C,Walk} <= L_E_F;
                        else if(t_cnt >= 4000 & t_cnt < 4500) {N_C,W_C,S_C,E_C,Walk} <= L_E_Y;
                        else {N_C,W_C,S_C,E_C,Walk} <= L_E_Y_F;
                    end
                end
                
                G : begin
                    if(emgc) {N_C,W_C,S_C,E_C,Walk} <= L_G_Y;
                    else begin
                        if(t_cnt < 2500) {N_C,W_C,S_C,E_C,Walk} <= L_G;
                        else if(t_cnt >= 2500 & t_cnt < 3000) {N_C,W_C,S_C,E_C,Walk} <= L_G_F;
                        else if(t_cnt >= 3000 & t_cnt < 3500) {N_C,W_C,S_C,E_C,Walk} <= L_G;
                        else if(t_cnt >= 3500 & t_cnt < 4000) {N_C,W_C,S_C,E_C,Walk} <= L_G_F;
                        else if(t_cnt >= 4000 & t_cnt < 4500) {N_C,W_C,S_C,E_C,Walk} <= L_G_Y;
                        else {N_C,W_C,S_C,E_C,Walk} <= L_G_Y_F;
                    end
                end
                
                E_A : begin
                    if(t_cnt < 7500) {N_C,W_C,S_C,E_C,Walk} <= L_A;
                    else if(t_cnt >= 7500 & t_cnt < 8000) {N_C,W_C,S_C,E_C,Walk} <= L_A_F;
                    else if(t_cnt >= 8000 & t_cnt < 8500) {N_C,W_C,S_C,E_C,Walk} <= L_A;
                    else if(t_cnt >= 8500 & t_cnt < 9000) {N_C,W_C,S_C,E_C,Walk} <= L_A_F;
                    else if(t_cnt >= 9000 & t_cnt < 9500) {N_C,W_C,S_C,E_C,Walk} <= L_A;
                    else if(t_cnt >= 9500 & t_cnt < 10000) {N_C,W_C,S_C,E_C,Walk} <= L_A_F;
                    else if(t_cnt >= 10000 & t_cnt < 10500) {N_C,W_C,S_C,E_C,Walk} <= L_A;
                    else if(t_cnt >= 10500 & t_cnt < 11000) {N_C,W_C,S_C,E_C,Walk} <= L_A_F;                
                    else if(t_cnt >= 11000 & t_cnt < 11500) {N_C,W_C,S_C,E_C,Walk} <= L_A;
                    else if(t_cnt >= 11500 & t_cnt < 12000) {N_C,W_C,S_C,E_C,Walk} <= L_A_F;
                    else if(t_cnt >= 12000 & t_cnt < 12500) {N_C,W_C,S_C,E_C,Walk} <= L_A;
                    else if(t_cnt >= 12500 & t_cnt < 13000) {N_C,W_C,S_C,E_C,Walk} <= L_A_F;
                    else if(t_cnt >= 13000 & t_cnt < 13500) {N_C,W_C,S_C,E_C,Walk} <= L_A;                    
                    else if(t_cnt >= 13500 & t_cnt < 14000) {N_C,W_C,S_C,E_C,Walk} <= L_A_F;
                    else if(t_cnt >= 14000 & t_cnt < 14500) {N_C,W_C,S_C,E_C,Walk} <= L_A_Y;
                    else {N_C,W_C,S_C,E_C,Walk} <= L_A_Y_F;
                end
            endcase
        end
    end
end
/*
always @(posedge clk or negedge rst)
begin
    if(!rst) {N_C_out,W_C_out,S_C_out,E_C_out,walk_out} <= 24'b0000_0000_0000_0000_00_00_00_00;
    else begin
        case(direction)
            north : begin
                N_C_out <= N_C;
                walk_out[7:6] <= Walk[7:6];
            end 
            west : begin
                W_C_out <= W_C;
                walk_out[5:4] <= Walk[5:4];
            end
            south : begin
                S_C_out <= S_C;
                walk_out[3:2] <= Walk[3:2];
            end
            north : begin
                E_C_out <= E_C;
                walk_out[1:0] <= Walk[1:0];
            end
        endcase
    end
end
*/





endmodule
