// 4x1 Mux that selects one of the inputs to output
module Mux (
    input logic [3:0] i_data,
    input logic [1:0] i_sel,
    output logic o_data
);
    
    //provide timescale
    timeunit 1ns; //the time unit for delays and simulation time is 1 ns.
    timeprecision 1ps; // he smallest unit of time that can be represented, is 1 ps.
    

    //case statement will select appropriate input based on select lines
    always_comb begin
        case (i_sel)
            2'b00 : o_data = i_data[0]; //bit select of first input
            2'b01 : o_data = i_data[1]; //bit select of second input
            2'b10 : o_data = i_data[2]; //bit select of third input
            2'b11 : o_data = i_data[3]; //bit select of fourth input
            default : o_data = 1'b0;
        endcase //end of case statement   
    end // end always_comb
endmodule