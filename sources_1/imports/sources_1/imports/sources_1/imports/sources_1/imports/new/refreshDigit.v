`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/20/2019 06:52:50 PM
// Design Name: 
// Module Name: refreshDigit
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

//Given a refresh rate, will determine how often it
//switches between a single seven segment display 
//Adapted from downCounter in lab8_1_2
module refreshDigit(refreshRate, onesMinSeg, tensMinSeg, onesHourSeg, tensHourSeg, seg, an);
    input refreshRate;
    input [7:0] onesMinSeg;
    input [7:0] tensMinSeg;
    input [7:0] onesHourSeg;
    input [7:0] tensHourSeg;
    output reg [7:0] seg;
    output reg [7:0] an;
    
    reg [1:0] refreshDigit = 2'b00;
    
    //Every refreshRate cycle swtich between each digit display
    //Then point to the location of the next digit display
    always@(posedge refreshRate) begin
        if(refreshDigit == 2'b00) begin
            seg <= onesMinSeg;
            seg[7] <= 1;
            an[0] <= 0;
            an[1] <= 1;
            an[2] <= 1;
            an[3] <= 1;
            refreshDigit <= 2'b01;
        end
        else if (refreshDigit == 2'b01) begin
            seg <= tensMinSeg;
            seg[7] <= 1;
            an[0] <= 1;
            an[1] <= 0;
            an[2] <= 1;
            an[3] <= 1;
            refreshDigit <= 2'b10;
        end
        else if (refreshDigit == 2'b10) begin
            seg <= onesHourSeg;
            seg[7] <= 0;
            an[0] <= 1;
            an[1] <= 1;
            an[2] <= 0;
            an[3] <= 1;
            refreshDigit <= 2'b11;
        end
        else if (refreshDigit == 2'b11) begin
            seg <= tensHourSeg;
            seg[7] <= 1;
            an[0] <= 1;
            an[1] <= 1;
            an[2] <= 1;
            an[3] <= 0;
            refreshDigit <= 2'b00;
        end
    end
    
endmodule
