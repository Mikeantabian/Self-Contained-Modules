/**
 * Module: BarrelShifter
 * Description:
 * This module implements a parameterized barrel shifter capable of rotating its input
 * left or right by a specified amount. The width of the input is determined by the 
 * parameter N, such that the width of the input is 2^N bits.
 * 
 * Parameters:
 *  - N: The parameter that determines the width of the input (2^N bits).
 * 
 * Ports:
 *  - input logic [2**N-1:0] a: The input data to be rotated.
 *  - input logic [N-1:0] amt: The amount by which the input is to be rotated.
 *  - input logic dir: The direction of rotation (0 for left, 1 for right).
 *  - output logic [2**N-1:0] y: The rotated output data.
 * 
 * Functionality:
 *  - If dir is 1, the module performs a right rotation.
 *  - If dir is 0, the module performs a left rotation.
 *  - The rotation amount is specified by the 'amt' input.
 * 
 * Rotation Logic:
 *  - For right rotation: y = (a >> amt) | (a << (2**N - amt))
 *  - For left rotation: y = (a << amt) | (a >> (2**N - amt))
 * 
 * The above operations ensure that the bits rotated out from one end are 
 * reintroduced at the other end, completing the rotation.
 */
module BarrelShifter
#(parameter N = 3)
(
    input logic [2**N-1:0] a,
    input logic [N-1:0] amt,
    input logic dir,//rotate right or left
    output logic [2**N-1:0] y
);
    
    timeunit 1ns;
    timeprecision 1ps;
    
    always_comb begin
        if (dir) begin // rotate right
            // 3 step process:
            // 1- shift register by specified amount
            // 2- shift discarded bits from the previous shift to where they should be
            // 3- perform logical OR to combine both shifts into one register
            y = (a >> amt) | (a << (2**N - amt));
        end else begin // rotate left
            y = (a << amt) | (a >> (2**N - amt));
        end
    end
    
endmodule
