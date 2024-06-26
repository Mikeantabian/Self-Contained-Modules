
module LFSR 
#(parameter N = 3)
(
    input logic clk,
    output logic [N-1:0] o_LFSR_data,
    output logic o_LFSR_done
);

    //provide timescale
    timeunit 1ns; //the time unit for delays and simulation time is 1 ns.
    timeprecision 1ps; // he smallest unit of time that can be represented, is 1 ps.
    
    logic [N-1:0] r_LFSR = {N{1'b0}}; //a register to shift with
    logic w_XNOR;
    
    
    always_ff @(posedge clk)
    begin
        r_LFSR <= {r_LFSR[N-2:0], w_XNOR};
    end // end: always_ff

    assign w_XNOR = r_LFSR[N-1] ^~ r_LFSR[N-2]; //feedback XNOR takes last two bits of register
    assign o_LFSR_done = (r_LFSR == {N{1'b0}}); //verify that the register has gone through all possible combinatiosn
    assign o_LFSR_data = r_LFSR; //assign register data to output

endmodule