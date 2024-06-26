
module ShiftRegister
#(parameter N = 4)
(
    input logic i_data,
    input logic clk,
    output logic [N-1:0] o_data
);

    //provide timescale
    timeunit 1ns; //the time unit for delays and simulation time is 1 ns.
    timeprecision 1ps; // he smallest unit of time that can be represented, is 1 ps.
    
    logic [N-1:0] r_shift; //a register to shift with
    
    always_ff @(posedge clk)
    begin
        r_shift[0] <= i_data;
        r_shift[N-1:1] <= r_shift[N-2:0];
    end // end: always_ff

    assign o_data = r_shift;

endmodule