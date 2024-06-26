/*****************************************************************************
 * Module Name: Count_And_Toggle
 *
 * Description:
 * This module implements a counter that toggles an output signal when it 
 * reaches a specified limit. The counter increments on each clock cycle 
 * when the enable signal is high. When the counter reaches the COUNT_LIMIT, 
 * the output toggle signal flips, and the counter resets to zero. This module 
 * is parameterized to allow flexibility in setting the count limit.
 *
 * Parameters:
 * - COUNT_LIMIT: Specifies the limit up to which the counter counts before 
 *                toggling the output. Default value is 10.
 *
 * Ports:
 * - Input:
 *   - i_clk: Clock signal for synchronous operations.
 *   - i_En: Enable signal to allow counting.
 * - Output:
 *   - o_toggle: Output signal that toggles when the counter reaches the limit.
 *
 * Notes:
 * The time unit for delays and simulation time is set to 1 ns, with the smallest 
 * unit of time that can be represented being 1 ps. The counter width is 
 * automatically determined using $clog2(COUNT_LIMIT).
 *
 * Author: Michael Antabian
 * Date: 5/29/2024
 *****************************************************************************/
 
module Count_And_Toggle
#(parameter COUNT_LIMIT = 10)
(
    input logic i_clk,
    input logic i_En,
    output logic o_toggle
);

    //provide timescale
    timeunit 1ns; //the time unit for delays and simulation time is 1 ns.
    timeprecision 1ps; // he smallest unit of time that can be represented, is 1 ps.
    
    logic [$clog2(COUNT_LIMIT)-1:0] r_counter; //will count up to limit
    
    always_ff @(posedge i_clk) begin
        if (i_En) begin
            if (r_counter == COUNT_LIMIT -1) begin
                o_toggle <= !o_toggle;
                r_counter <= 0;
            end else begin
                r_counter <= r_counter + 1;
            end
        end
    end // end: always_ff

endmodule