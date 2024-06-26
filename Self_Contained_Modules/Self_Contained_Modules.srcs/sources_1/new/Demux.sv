
module Demux (
    input logic i_data,
    input logic [1:0] i_sel,
    output logic [3:0] o_data
);

    //provide timescale
    timeunit 1ns; //the time unit for delays and simulation time is 1 ns.
    timeprecision 1ps; // he smallest unit of time that can be represented, is 1 ps.
    
    //conditional assignments that select the appropriate output
    assign o_data[0] = !i_sel[1] & !i_sel[0] ? i_data : 1'b0;
    assign o_data[1] = !i_sel[1] & i_sel[0] ? i_data : 1'b0;
    assign o_data[2] = i_sel[1] & !i_sel[0] ? i_data : 1'b0;
    assign o_data[3] = i_sel[1] & i_sel[0] ? i_data : 1'b0;

endmodule