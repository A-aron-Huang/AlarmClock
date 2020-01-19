`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/20/2019 12:22:30 PM
// Design Name: 
// Module Name: muxTimeAlarm
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

//Choose between the time or alarm count depending on the button
//Adapted from lab2_2_1
module muxTimeAlarm(timeCount, alarmCount, alarmChange, seg);
    input [3:0] timeCount;
    input [3:0] alarmCount;
    input alarmChange;
    output reg [7:0] seg;

    wire [3:0] x;
    
    //Assign the count to x depending on button change
    assign x = alarmChange ? alarmCount : timeCount;
    
    //With the x changed, assign the respetive segments
    always @(x,seg) begin
        seg[0] = (x[0] & ~x[1] & ~x[2] & ~x[3]) | (~x[0] & ~x[1] & x[2] & ~x[3]);
        seg[1] = (x[0] & ~x[1] & x[2] & ~x[3]) | (~x[0] & x[1] & x[2] & ~x[3]);  
        seg[2] = (~x[0] & x[1] & ~x[2] & ~x[3]);
        seg[3] = (x[0] & ~x[1] & ~x[2] & ~x[3]) | (~x[0] & ~x[1] & x[2] & ~x[3]) | (x[0] & x[1] & x[2] & ~x[3]);
        seg[4] = (x[0] & ~x[1] & ~x[2] & ~x[3]) | (x[0] & x[1] & ~x[2] & ~x[3]) | (~x[0] & ~x[1] & x[2] & ~x[3]) | (x[0] & ~x[1] & x[2] & ~x[3]) | (x[0] & x[1] & x[2] & ~x[3]) | (x[0] & ~x[1] & ~x[2] & x[3]);
        seg[5] = (x[0] & ~x[1] & ~x[2] & ~x[3]) | (~x[0] & x[1] & ~x[2] & ~x[3])| (x[0] & x[1] & ~x[2] & ~x[3])| (x[0] & x[1] & x[2] & ~x[3]);
        seg[6] = (~x[0] & ~x[1] & ~x[2] & ~x[3]) | (x[0] & ~x[1] & ~x[2] & ~x[3])| (x[0] & x[1] & x[2] & ~x[3]);                               
    end

endmodule
