`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/16/2019 06:23:46 PM
// Design Name: 
// Module Name: innovatedAlarmClock_tb
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


module innovatedAlarmClock_tb();
    reg fiveMhz;      //Usually 100 Mhz clk, but used 5 Mhz for quicker testing
    reg reset;        //Used for resets
    reg alarmEnable;  //Turn alarm on/off
    reg timeChange;   //Hold to change time
    reg alarmChange;  //Hold to change alarm time
    reg minutes;      //Press to increment minute timing
    reg hours;        //Press to increment hour timing
    wire alarmEnabled;   //Turn on if alarm is rdy to go
    wire alarmOn;        //Flicker if alarm is on
    wire amPMLED;        //Turn on for pm, turn off for am
    wire [7:0] seg;      //Seven segment display
    wire [7:0] an;       //8 Common annodes
    wire pwmSound;       //Controls frequency/note of speaker
    wire pwmControl;     //Controls beat/length of speaker
    wire [2:0] rgb1;    //RGB #1
    wire [2:0] rgb2;    //RGB #2
    wire [9:0] currentNote;  //Optional display for the led frequenecy in binary

    innovatedAlarmClock DUT(.fiveMhz(fiveMhz), .reset(reset), .alarmEnable(alarmEnable), .timeChange(timeChange), .alarmChange(alarmChange), .minutes(minutes), .hours(hours), .alarmEnabled(alarmEnabled), .alarmOn(alarmOn), .amPMLED(amPMLED), .seg(seg), .an(an), .pwmSound(pwmSound), .pwmControl(pwmControl), .rgb1(rgb1), .rgb2(rgb2), .currentNote(currentNote));
  
    always begin
        #2 fiveMhz = ~fiveMhz;  //200ns on/off, represents 5 Mhz
    end
    
    initial begin
        reset = 1;
        fiveMhz = 0;
        alarmEnable = 1;    //Enable alarm first, should turn on immeditaley after reset
        timeChange = 0;
        alarmChange = 0;
        minutes = 0;
        hours = 0;
        
        //At 0.25s turn off reset, and increment time by two hours and two minuts
        #2500000
        reset = ~reset; //Turn off reset at 0.5s
        
        timeChange = ~timeChange;
        hours = ~hours;
        #150000 hours = ~hours; //Needs at least 10 ms (150000*100ns) to debounce
        hours = ~hours;
        #150000 hours = ~hours; //Needs at least 10 ms (150000*100ns) to debounce
        minutes = ~minutes;
        #150000 minutes = ~minutes; //Needs at least 10 ms (150000*100ns) to debounce
        minutes = ~minutes;
        #150000 minutes = ~minutes; //Needs at least 10 ms (150000*100ns) to debounce
        timeChange = ~timeChange;
        
        //Wait until next 0.25s interval, then incrment alarm by two hours and two minutes
        #1900000
        alarmChange = ~alarmChange;
        hours = ~hours;
        #150000 hours = ~hours; //Needs at least 10 ms (150000*100ns) to debounce
        hours = ~hours;
        #150000 hours = ~hours; //Needs at least 10 ms (150000*100ns) to debounce
        minutes = ~minutes;
        #150000 minutes = ~minutes; //Needs at least 10 ms (150000*100ns) to debounce
        minutes = ~minutes;
        #150000 minutes = ~minutes; //Needs at least 10 ms (150000*100ns) to debounce
        alarmChange = ~alarmChange;
        
        //Disable alarm
        #1900000
        alarmEnable = ~alarmEnable;
        
        //Reset again
        #2500000
        reset = ~reset;
        
        //Finish the program
        #2500000 
        $finish;
    end
    
endmodule
