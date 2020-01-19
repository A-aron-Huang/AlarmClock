`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/25/2019 10:18:05 AM
// Design Name: 
// Module Name: upCounterMOD2
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

//Specifically used for the Tens Hour, as it can count from 0 to 1, BUT starts at 1 for 12:00
//Adapted from downCounter in lab9_3_2 then from upCounter in basicAlarmClock
module upCounterMOD2(clk, reset, threshVal, thr, count);
    input clk;
    input reset;
    input [3:0] threshVal;
    output reg thr;
    output reg [3:0] count = 4'b0001;
    
    //Similar to upCounter
    //Starts counting at 1 instead of 0
    always@(posedge clk or posedge reset) begin
        if(reset) begin
            count <= 4'b0001;
            thr <= 0;
        end
        else begin
            if(count == threshVal) begin
                count <= 4'b0000;
                thr <= 1;
            end
            else begin
                count <= count + 4'b0001;
                thr <= 0;
            end
        end
    end
    
endmodule
