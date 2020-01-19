`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/20/2019 12:30:17 PM
// Design Name: 
// Module Name: upCounter
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
    
//Given a threshVal, will count up to that number, 
//and afterwards queue an output signal for the next value
//Adapted from downCounter in lab9_3_2
module upCounter(clk, reset, threshVal, thr, count);
    input clk;
    input reset;
    input [3:0] threshVal;
    output reg thr;
    output reg [3:0] count;
    
    //Count every clk cycle, if reached thresh output signal
    always@(posedge clk or posedge reset) begin
        if(reset) begin
            count <= 4'b0000;
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
