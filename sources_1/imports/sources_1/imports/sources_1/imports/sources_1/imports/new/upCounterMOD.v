`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/20/2019 01:11:54 PM
// Design Name: 
// Module Name: upCounterMOD
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

//Specifically used for the Ones Hour, as it can count from 0 to 9 or 0 to 2
//Adapted from downCounter in lab9_3_2 then from upCounter in basicAlarmClock
module upCounterMOD(clk, reset, tensHour, threshVal, amPM, thr, count);
    input clk;
    input [3:0] tensHour; //Increment differently based on what the Tens Hour is
    input reset;
    input [3:0] threshVal;
    output reg amPM;
    output reg thr;
    output reg [3:0] count = 4'b0010;   //Start at 2 for 12:00
    
    //Similar to upCounter
    //Count from 1 to 9 if tens hour is a 0
    //Else count from 0 to 2 if tens hour is a 1 
    always@(posedge clk or posedge reset) begin
        if(reset) begin   //Testing adding reset
            count <= 4'b0010;
            thr <= 0;
            amPM <= 0;
        end
        else begin
            if(tensHour == 4'd0) begin
                if(count == threshVal) begin
                    count <= 4'b0000;
                    thr <= 1;
                end
                else begin
                    count <= count + 4'd1;
                    thr <= 0;
                end
            end
            else begin
                //Count up to 2, if the tensHour is at 1, i.e. 10, 11, 12 output thresh
                if(count == 4'b0010) begin
                    count <= 4'b0001;
                    thr <= 1;
                end
                else if(count == 4'b0001) begin
                    count <= count + 4'b0001;
                    amPM <= ~amPM;
                end
                else begin
                    count <= count + 4'b0001;
                    thr <= 0;
                end
            end
        end
    end
    
endmodule
