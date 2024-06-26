/*****************************************************************************
 * Module Name: Debounce_Filter
 *
 * Description:
 * This module implements a debounce filter that can handle multiple input 
 * signals (e.g., buttons or switches). The module uses a parameterized 
 * debounce limit to filter out spurious signals caused by mechanical 
 * bounce. Each input signal is independently debounced, and the resulting 
 * debounced signals are output.
 *
 * Parameters:
 * - DEBOUNCE_LIMIT: Specifies the number of clock cycles used for debouncing. 
 *                   Default value is 20.
 * - NUM_BUTTONS: Specifies the number of buttons or switches to debounce.
 *
 * Ports:
 * - Input:
 *   - i_clk: Clock signal for synchronous operations.
 *   - i_Bouncy: Array of input signals to be debounced.
 * - Output:
 *   - o_Debounced: Array of debounced output signals.
 *
 * Notes:
 * Each input signal is debounced independently. The module ensures that 
 * each debounced output only changes state if the corresponding input signal 
 * has remained stable for the specified debounce period.
 *
 * Author: Michael Antabian
 * Date: 5/27/2024
 *****************************************************************************/

module Debounce_Filter #(parameter DEBOUNCE_LIMIT = 20, NUM_BUTTONS = 1)(
    input i_clk,
    input [NUM_BUTTONS-1:0] i_Bouncy,
    output [NUM_BUTTONS-1:0] o_Debounced
);

    // Provide timescale
    timeunit 1ns;        // The time unit for delays and simulation time is 1 ns.
    timeprecision 1ps;   // The smallest unit of time that can be represented is 1 ps.
    
    // Internal registers for counting and state storage
    logic [$clog2(DEBOUNCE_LIMIT)-1:0] r_Count [NUM_BUTTONS-1:0] = '{default:0};
    logic [NUM_BUTTONS-1:0] r_State = '0;
    

    // Debounce logic for each button
    always_ff @(posedge i_clk) begin
        for (int i = 0; i < NUM_BUTTONS; i++) begin
            if (i_Bouncy[i] != r_State[i] && r_Count[i] < DEBOUNCE_LIMIT-1) begin
                r_Count[i] <= r_Count[i] + 1;
            end
            else if (r_Count[i] == DEBOUNCE_LIMIT-1) begin
                r_State[i] <= i_Bouncy[i];
                r_Count[i] <= 0;
            end
            else begin
                r_Count[i] <= 0;
            end
        end
    end

    // Assign the debounced states to the output
    assign o_Debounced = r_State;

endmodule