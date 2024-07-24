/*
 * Module: pwm
 * Description: This module generates a Pulse Width Modulation (PWM) signal 
 *              with a configurable resolution. The duty cycle of the PWM 
 *              signal is controlled by a duty cycle input.
 * 
 * Parameters:
 *    N - Resolution of the PWM counter (default is 4 bits).
 * 
 * Inputs:
 *    clk    - System clock input.
 *    reset  - System reset input (active high).
 *    duty   - N-bit input to set the duty cycle of the PWM signal.
 * 
 * Outputs:
 *    pwm_out - PWM output signal.
 * 
 * Functionality:
 *    The module generates a PWM signal with a duty cycle specified by the 
 *    duty input. The PWM resolution is defined by the parameter N, which 
 *    sets the width of the counter. The counter increments on each clock 
 *    cycle, and the PWM output is high when the counter value is less than 
 *    the duty cycle value. When the counter reaches its maximum value, it 
 *    resets to zero.
 */
module pwm
#(parameter N=4)
(
    input logic clk, reset,
    input logic [N-1:0] duty,
    output logic pwm_out
);

    timeunit 1ns;
    timeprecision 1ps;
    
    logic [N-1:0] counter;
    
    always_ff @(posedge clk, posedge reset) begin
        if (reset) begin
            counter <= 0;
            pwm_out <= 0;
        end else begin
            // If threshold is higher than count, set output high
            if (counter < duty) begin
                pwm_out <= 1'b1;
            end else begin
                pwm_out <= 1'b0;
            end 
                
            //increment count
            counter <= counter + 1;
            
            // counter has reached max, restart from 0
            if (counter == 2**N-1) begin
                counter <= 0;
            end
        end
    end

endmodule
