`timescale 1ns / 1ps


module FSM_TOP(
        input logic [7:0]sw,
        input logic btnC,
        input logic clk,
        output logic led[2:0]
    );
    
    FSM FSM1(.clk(clk),.reset(btnC),
             .G1(sw[1:0]),.G2(sw[3:2]),.A(sw[5:4]),.P(sw[7:6]),
             .E(led[2]),.R1(led[0]),.R2(led[1])
             );
endmodule
