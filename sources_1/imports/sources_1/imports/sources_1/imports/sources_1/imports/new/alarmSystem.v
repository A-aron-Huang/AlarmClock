`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/22/2019 03:05:56 PM
// Design Name: 
// Module Name: alarmSystem
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

//Checking for a few condtioins such as:
//Did the alarm values equal the clock values while the alarm was enabled?
//If it did reached the same value and the alarm is still enabled, is it still on?
module alarmSystem(clk, reset, sameSame, alarmEnable, turnedOn, isItOn);
    input clk;
    input reset;
    input sameSame;
    input alarmEnable;
    input turnedOn;
    output reg isItOn;

    //Checks if alarm is still on by:
    //Checking if the time values == alarm values, while alarm was enabled
    //Checking if the alarm was activated preivosuly, and the alarm is still on
    //Else will turn off alarm
    always@(posedge clk) begin
        if(reset) begin
            isItOn <= 0;
        end
        else begin
            if((alarmEnable & sameSame) | (alarmEnable & turnedOn)) begin
                isItOn <= 1;
            end
            else begin
                isItOn <= 0;
            end
        end
    end

endmodule
