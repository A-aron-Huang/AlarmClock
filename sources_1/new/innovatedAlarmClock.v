`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/16/2019 06:20:19 PM
// Design Name: 
// Module Name: innovatedAlarmClock
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


module innovatedAlarmClock(clk, reset, alarmEnable, timeChange, alarmChange, minutes, hours, alarmEnabled, alarmOn, amPMLED, seg, an, pwmSound, pwmControl, rgb1, rgb2, currentNote);
    input clk;          //Used for timing
    input reset;        //Used for resets
    input alarmEnable;  //Turn alarm on/off
    input timeChange;   //Hold to change time
    input alarmChange;  //Hold to change alarm time
    input minutes;      //Press to increment minute timing
    input hours;        //Press to increment hour timing
    output wire alarmEnabled;   //Turn on if alarm is rdy to go
    output wire alarmOn;        //Flicker if alarm is on
    output wire amPMLED;        //Turn on for pm, turn off for am
    output wire [7:0] seg;      //Seven segment display
    output wire [7:0] an;       //8 Common annodes
    output wire pwmSound;       //Controls frequency/note of speaker
    output wire pwmControl;     //Controls beat/length of speaker
    output wire [2:0] rgb1;    //RGB #1
    output wire [2:0] rgb2;    //RGB #2
    output wire [9:0] currentNote;  //Optional display for the led frequenecy in binary
   

    //Parameters and Variables / Parameters and Variables
    //Parameters and Variables / Parameters and Variables
    //Parameters and Variables / Parameters and Variables 
    //5th Octave
    parameter Do = 523; //C 
    parameter Re = 587; //D
    parameter Mi = 660; //E
    parameter Fa = 698; //F
    parameter So = 784; //G
    parameter La = 880; //A
    parameter Si = 988; //B
    parameter No = 20;  //Off - Optional, must set to detect for 20 to not play, else static
    
    //4th Octave
//    parameter Do = 261; //C
//    parameter Re = 294; //D
//    parameter Mi = 330; //E
//    parameter Fa = 349; //F
//    parameter So = 392; //G
//    parameter La = 440; //A
//    parameter Si = 494; //B
//    parameter No = 20;  //Off - Optional, must set to detect for 20 to not play, else static
    
    //Beat Length
    parameter b1 = 25;  //0.5   - 50%
    parameter b2 = 50;  //0.25  - 25%
    parameter b3 = 100;//0.125 - 12.5%
    parameter b4 = 200; //0.075 - 7.5%

    //Array of of freqenecy and accompanying beat
    reg [9:0] noteArray [25:0];
    reg [6:0] beatArray [25:0];
    initial begin
        //Note or Sound
        noteArray[0] = Mi;
        noteArray[1] = Mi;
        noteArray[2] = Mi;
        
        noteArray[3] = Mi;
        noteArray[4] = Mi;
        noteArray[5] = Mi;
        
        noteArray[6] = Mi;
        noteArray[7] = So;
        noteArray[8] = Do;
        noteArray[9] = Re;
        
        noteArray[10] = Mi;
        
        noteArray[11] = Fa;
        noteArray[12] = Fa;
        noteArray[13] = Fa;
        noteArray[14] = Fa;
        
        noteArray[15] = Fa;
        noteArray[16] = Mi;
        noteArray[17] = Mi;
        noteArray[18] = Mi;
        
        noteArray[19] = Mi;
        noteArray[20] = Re;
        noteArray[21] = Re;
        noteArray[22] = Mi;
        
        noteArray[23] = Re;
        noteArray[24] = So;
        noteArray[25] = No;
       
       //Beat or length
        beatArray[0] = b2;
        beatArray[1] = b2;
        beatArray[2] = b3;
        
        beatArray[3] = b2;
        beatArray[4] = b2;
        beatArray[5] = b3;
        
        beatArray[6] = b2;
        beatArray[7] = b2;
        beatArray[8] = b2;
        beatArray[9] = b2;
        
        beatArray[10] = b4;
        
        beatArray[11] = b2;
        beatArray[12] = b2;
        beatArray[13] = b2; //was b1
        beatArray[14] = b2; //was b1

        beatArray[15] = b2;
        beatArray[16] = b2;
        beatArray[17] = b2;
        beatArray[18] = b2;

        beatArray[19] = b2;
        beatArray[20] = b2;
        beatArray[21] = b2;
        beatArray[22] = b2;
                
        beatArray[23] = b3;
        beatArray[24] = b3;
        beatArray[25] = b3; //Super Short Rest
        
    end
    
    //Used for clocking
    wire fiveMhz;
    wire debouncePulse;
    wire refresh;
    wire secPulse;
    wire minPulse;
    wire timePulse;
    
    //Keeps track of time/alarm count;
    wire [3:0] timeOnesSecCount;
    wire [3:0] timeTensSecCount;
    wire [3:0] timeOnesMinCount;
    wire [3:0] timeTensMinCount;
    wire [3:0] timeOnesHourCount;
    wire [3:0] timeTensHourCount;
    wire [3:0] alarmOnesSecCount;
    wire [3:0] alarmTensSecCount;
    wire [3:0] alarmOnesMinCount;
    wire [3:0] alarmTensMinCount;
    wire [3:0] alarmOnesHourCount;
    wire [3:0] alarmTensHourCount;                    

    //Used to keep track of when time/alarm reaches threshold
    wire timeOnesSecThresh;
    wire timeTensSecThresh;
    wire timeOnesMinThresh;
    wire timeTensMinThresh;    
    wire timeOnesHourThresh;
    wire timeTensHourThresh;
    wire alarmOnesSecThresh;
    wire alarmTensSecThresh;
    wire alarmOnesMinThresh;
    wire alarmTensMinThresh;    
    wire alarmOnesHourThresh;
    wire alarmTensHourThresh;     

    //Used for outputing time/alarm seg
    wire [7:0] onesSecSeg;
    wire [7:0] tensSecSeg;
    wire [7:0] onesMinSeg;
    wire [7:0] tensMinSeg;
    wire [7:0] onesHourSeg;
    wire [7:0] tensHourSeg;
    
    //Used for alarm
    wire turnedOn;  //Has it been turned on
    wire isItOn;    //Was it triggered
    wire sameSame;  //Clock values == Alarm Values?
    
    //Used for determining am/pm
    wire timePM;
    wire alarmPM;
      
    //Used for Debouncing
    wire minutesDB;
    wire hoursDB;
    
    //Used for Alarm Sound
    wire [6:0] currentBeat;
    reg [6:0] i = 0;
    
    
    //MODULES / MODULES / MODULES / MODULES / MODULES
    //MODULES / MODULES / MODULES / MODULES / MODULES
    //MODULES / MODULES / MODULES / MODULES / MODULES
    //Clocking modules
    clk_wiz_0 mainClk(fiveMhz,clk); // O/I -> Covnerts 100 Mhz System Clk to 5Mhz
    rateClk secondsRate(fiveMhz, 1'd1,secPulse);    //Converts 5Mhz to seconds (1 Hz)
    rateClk timeRate(fiveMhz, 10'd600, timePulse);  //Speeds up time for display purposes 10 minutes = 1 second (600 Hz)
    rateClk debounce(fiveMhz, 7'd100, debouncePulse);   //Used to debounce button press at 10ms intervals (100 Hz)
    rateClk refreshRate(fiveMhz, 10'd1000, refresh);    //Refresh Rate of seven segment display 1000Hz
    
    //Time counter modules - Change pulse depending on speed
    upCounter onesSecTime((timePulse & ~timeChange), reset, 4'b1001, timeOnesSecThresh, timeOnesSecCount);
    upCounter tensSecTime((timeOnesSecThresh & ~timeChange), reset, 4'b0101, timeTensSecThresh, timeTensSecCount);
    upCounter onesMinTime(((timeTensSecThresh & ~timeChange ) | (minutesDB & timeChange)), reset, 4'b1001, timeOnesMinThresh, timeOnesMinCount);
    upCounter tensMinTime(((timeOnesMinThresh & ~timeChange) | (timeOnesMinThresh & timeChange)), reset, 4'b0101, timeTensMinThresh, timeTensMinCount);
    upCounterMOD onesHourTime(((timeTensMinThresh& ~timeChange) | (hoursDB & timeChange)), reset, timeTensHourCount, 4'b1001, timePM,timeOnesHourThresh, timeOnesHourCount);
    upCounterMOD2 tensHourTime(((timeOnesHourThresh & ~timeChange) | (timeOnesHourThresh & timeChange)), reset, 4'b0001, timeTensHourThresh, timeTensHourCount);

    //Alarm counter modules
    upCounter onesMinAlarm((minutesDB & alarmChange), reset, 4'b1001, alarmOnesMinThresh, alarmOnesMinCount);
    upCounter tensMinAlarm((alarmOnesMinThresh & alarmChange), reset, 4'b0101, alarmTensMinThresh, alarmTensMinCount);
    upCounterMOD onesHourAlarm((hoursDB & alarmChange), reset, alarmTensHourCount, 4'b1001, alarmPM, alarmOnesHourThresh, alarmOnesHourCount);
    upCounterMOD2 tensHourAlarm((alarmOnesHourThresh & alarmChange), reset, 4'b0001, alarmTensHourThresh, alarmTensHourCount);

    //Mux modules
    muxTimeAlarm onesMin(timeOnesMinCount, alarmOnesMinCount, alarmChange, onesMinSeg);
    muxTimeAlarm tensMin(timeTensMinCount, alarmTensMinCount, alarmChange, tensMinSeg);
    muxTimeAlarm onesHour(timeOnesHourCount, alarmOnesHourCount, alarmChange, onesHourSeg);
    muxTimeAlarm tensHour(timeTensHourCount, alarmTensHourCount, alarmChange, tensHourSeg); 
    
    //Refresh Rate for Display
    refreshDigit refresher(refresh, onesMinSeg, tensMinSeg, onesHourSeg, tensHourSeg, seg, an);
    
    //For AM/PM - Depenidng in time or alarm mode display the respective LED
    assign amPMLED = alarmChange ? alarmPM : timePM;
    
    //Debounce button module
    debouncer minuteDB(minutes, debouncePulse, minutesDB);
    debouncer hourDB(hours, debouncePulse, hoursDB);
    
    //For Alarm
    //Assign the switch turn be enable or not for the LED[0]
    assign alarmEnabled = alarmEnable;
    //Time Values == Alarm Values
    assign sameSame = ((timeOnesMinCount == alarmOnesMinCount) & (timeTensMinCount == alarmTensMinCount) & (timeOnesHourCount == alarmOnesHourCount) & (timeTensHourCount == alarmTensHourCount) & (timePM == alarmPM));
    //Has the alarm been triggered and turned on
    assign turnedOn = isItOn;
    //Flicker every second that the alarm has been actiavted
    assign alarmOn = turnedOn ? secPulse : 0;
    alarmSystem isAlarmOn(fiveMhz, reset, sameSame, alarmEnable, turnedOn, isItOn);

    //Alarm Lights module
    alarmLight alarmlight(fiveMhz, pwmControl, reset, turnedOn & alarmEnabled, rgb1, rgb2);
        
        
    //Plan C - Use notechange to toggle on an off to demotstarte reset
//    reg noteChanger = 0;
        
    //Alarm Sounds module
    //Output the sound as the dclared freuqnecy(pwmSound)
    freqClk pwmSpeaker(fiveMhz, turnedOn & ~reset, noteArray[i], pwmSound);
    //Control when the sound plays (pwmControl) 
    dutyClk pwmDutyCycle(fiveMhz, turnedOn & ~reset, beatArray[i], pwmControl); //Try with 1 (fully on), then try with note[0] (13% Duty Cycle)
    //Depending if alarm is on or not output the frequency leds
    assign currentNote = (turnedOn & ~reset) ? noteArray[i] : 9'b0;
    //Increment counter when note finishes
    always@(negedge pwmControl) begin  //or posedge reset
        i <= (i < 24) ? i + 1 : 0;
//        noteChanger <= ~noteChanger;
    end

endmodule