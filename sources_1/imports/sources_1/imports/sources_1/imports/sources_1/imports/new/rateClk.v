`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/22/2019 11:29:58 AM
// Design Name: 
// Module Name: rateClk
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

//Example: Given 5Mhz -> For 1 Sec -> 5Mhz/1Hz = 5 000 000
//Adapted from lab8_1_1 in lab9_3_2
module rateClk(clk, rate, Q);
    input clk;
    input [22:0] rate;  //Max frequency of 5mhz which uses 23 bits
    output reg Q;
    
    //Divide the maximum frequency by what is required if need,
    //i.e. For 1 hz signal divide by 1 to have to 5Mhz counter count up to the quotient
    wire [22:0] counterLimit = 23'd5000000/rate;
    reg [22:0] counter;
    
    //Simpe counter to count up to limit
    always @(posedge clk) begin
        if(counter == counterLimit) begin
            counter <= 23'd0;
        end
        else begin
            counter <= counter + 23'd1;
        end
    end
    
    //If reached past halfpoint of limit output high, else low -> Creates squarewave
    always @(counter) begin
        if(counter == counterLimit/2) begin
            Q <= 1'b1;
        end
        else if(counter == 23'd0) begin
            Q <= 1'b0;
        end
    end
    
endmodule
