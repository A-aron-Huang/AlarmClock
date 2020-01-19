`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/02/2019 10:40:38 AM
// Design Name: 
// Module Name: dutyClk
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


//Given a duty cycle will turn off an on at that rate
//Example: At 20% Duty cycle will turn off at 20% of the potential counter/signal
//Adapted from rateClk in alarmClock
module dutyClk(clk, enable, dutyCycle, pwmControl);
    input clk;
    input enable;
    input [6:0] dutyCycle;  //Max of 100% duty cycle
    output reg pwmControl = 1;
    
    wire [23:0] counterLimit = 24'd5000000; //24 as could be 10mil which is 24bin
    wire [23:0] counterDuty;
    reg [23:0] counter = 0;
    reg [23:0] oldCounterDutyVal;
    
    assign counterDuty = 24'd5000000/100*dutyCycle;
    
    //Turns on/off the controls depending on enable or duty counter value
    always @(counter or enable) begin
        if(enable) begin
            if (counter == counterDuty) begin
                pwmControl <= 0;
            end
            else if (counter == 18'd0) begin
                pwmControl <= 1;
            end
        end
        else begin
            pwmControl <= 0;
        end
    end
   
   //Once it reaches the countey and then some (tiny rest) restarts counter
    always@(posedge clk) begin
        if(counter == (counterDuty + 24'd250000)) begin
            counter <= 24'd0;
        end
        else begin
            counter <= counter + 24'd1;
        end
    end
    
//    //Plan 1 
//    //Plan 1 
//    //Plan 1 
//    //Plan 1 - Just try following below
//       //Once it reaches the countey and then some (tiny rest) restarts counter
//    always@(posedge clk) begin
//        if(counter == (counterDuty)) begin  //See what happens without 250000, should work perfect expect no rest
//            counter <= 24'd0;
//        end
//        else begin
//            counter <= counter + 24'd1;
//        end
//    end
    
    //Plan 2 -
    //Plan 2 -
    //Plan 2 -
    //Plan 2 -
    //Plan 2 - Comment the always blocks
        //Turns on/off the controls depending on enable or duty counter value
//    always @(counter or enable) begin
//        if(enable) begin
//            if (counter == (counterDuty + 24'd250000)) begin
//                pwmControl <= 0;    //Extra by still stay off
//            end
//            else if (counter == counterDuty) begin
//                pwmControl <= 0;
//            end
//            else if (counter == 24'd0) begin
//                pwmControl <= 1;
//            end
//        end
//        else begin
//            pwmControl <= 0;
//        end
//    end
   
//   //Once it reaches the countey and then some (tiny rest) restarts counter
//    always@(posedge clk) begin
//        if(counter == (counterDuty + 24'd250000)) begin
//            counter <= 24'd0;
//        end
//        else begin
//            counter <= counter + 24'd1;
//        end
//    end



     //Plan - C 
      //Plan - C 
       //Plan - C 
    //Plan - C using noteChange to reset the counter each time, NEED TO ADD INPUT FOR NOTECHANGER AND resetCounter
       //Once it reaches the countey and then some (tiny rest) restarts counter
//    always@(noteChanger) begin
//        resetCounter <= 1;
//    end
       
       
//    always@(posedge clk or posedge resetCounter) begin
//        if(resetCounter) begin
//            counter <= 24'd0l;
//            resetCounter <= 0;
//        end
//        else begin
//            if(counter == (counterDuty + 24'd250000)) begin
//                counter <= 24'd0;
//            end
//            else begin
//                counter <= counter + 24'd1;
//            end
//        end
//    end
    
endmodule
