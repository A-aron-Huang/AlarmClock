`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/04/2019 10:45:49 PM
// Design Name: 
// Module Name: alarmLight
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

//If alarm is not actiavted will dispaly a dimly lit red led
//If alarm is actiavted will display RGB according to the beat of the sound
module alarmLight(clk, musicClk, reset, turnedOn, rgb1, rgb2);
    input clk;
    input musicClk;
    input reset;
    input turnedOn;   //alarm on (1), alarm off(0)
    output wire [2:0] rgb1;
    output wire [2:0] rgb2;
    
    reg [2:0] xmas1 = 3'b000;
    reg [2:0] xmas2 = 3'b000;
    reg [2:0] LED = 2'b00;
    reg [6:0] counter = 7'b0;
    
    //Simple counter
    always@(posedge clk)begin
        if(counter >= 7'd100) begin
            counter <= 7'd0;
        end
        else begin
            counter <= counter + 7'd1;
        end
    end
    
    //Will pick what LED to use according to if the alarm was triggered or has been reseted
    assign rgb1 = (~turnedOn | reset) ? ((counter < 4'd10) ? 3'b100 : 3'b000) : xmas1 ;  //ledsOn? Nope, Passed 5% Duty cycle?
    assign rgb2 = (~turnedOn | reset) ? ((counter < 4'd10) ? 3'b100 : 3'b000) : xmas2;  //ledsOn? Nope, Passed 5% Duty cycle?
    
    //Used to switch between different RGB displays
    always@(posedge musicClk) begin
        if(reset | ~turnedOn) begin
            xmas1 <= 3'b000;
            xmas2 <= 3'b000;
            LED <= 2'b00;
        end
        else begin
            if(LED == 2'b00) begin
                xmas1 <= 3'b100;
                xmas2 <= 3'b010;
                LED <= 2'b01;
            end
            else if(LED == 2'b01) begin
                xmas1 <= 3'b010;
                xmas2 <= 3'b111;
                LED <= 2'b11;
            end
            else if(LED == 2'b11) begin
                xmas1 <= 3'b111;
                xmas2 <= 3'b100;
                LED <= 2'b00;
            end
        end
    end
         
endmodule