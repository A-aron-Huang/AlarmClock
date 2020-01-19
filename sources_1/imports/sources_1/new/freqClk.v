`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/04/2019 11:39:43 AM
// Design Name: 
// Module Name: freqClk
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

//Given a frequency (rate) will output a sound at a speciic frequency
//When a beat is over (pwmSound = 0) will stop playing
//Adapted from rateClk in alarmClock
module freqClk(clk, enable, rate, pwmSound);
    input clk;
    input enable;
    input [22:0] rate;  //Max frequency of 5mhz which uses 23 bits
    //input pwmControl;
    output reg pwmSound;
    
    wire [22:0] counterLimit = 23'd5000000/rate;
    reg [22:0] counter;
    
    assign counterLimit = 23'd5000000/rate;
 
    //Simple Counter
    always @(posedge clk) begin
        if((counter == counterLimit)) begin
            counter <= 23'd0;
        end
        else begin
            counter <= counter + 23'd1;
        end
    end
    
    //Change on/off depending on frequency
    always @(counter) begin
        if(counter == counterLimit/2) begin
            pwmSound <= 1'b1;
        end
        else if(counter == 23'd0) begin
            pwmSound <= 1'b0;
        end
    end
    
    
endmodule
