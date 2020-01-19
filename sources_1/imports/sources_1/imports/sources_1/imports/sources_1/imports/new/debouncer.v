`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/22/2019 10:25:18 AM
// Design Name: 
// Module Name: debouncer
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

//Check if input is stable, but feeding it through a FF
//Then comparing if there have been and changes
module debouncer(pushSignal, clk, Q);
    input pushSignal;
    input clk;
    output reg Q;
    wire firstQ;
    wire secondQ;
    
    //Rising Edge Flip-Flop Modules
    risingEdgeDFF firstFF(pushSignal, clk, firstQ);
    risingEdgeDFF secondFF(firstQ, clk, secondQ);
    
    always@(*) begin
        Q <=  firstQ & ~secondQ;
    end
    
endmodule


module risingEdgeDFF(D, clk, Q);
    input D;
    input clk;
    output reg Q;
    
    //D flip flop, every clk cycle assign D to Q
    always@(posedge clk) begin
        Q <= D;
    end
    
endmodule
