/*****************************************************************************
 * Module Name: Binary_To_7Segment
 *
 * Description:
 * This module converts a 4-bit binary input into the corresponding 7-segment 
 * display output. The output signals control the individual segments of a 
 * 7-segment display to represent hexadecimal digits (0-9, A-F).
 *
 * Parameters: None
 *
 * Ports:
 * - Input:
 *   - i_clk: Clock signal for synchronous operations.
 *   - i_Binary_Num: 4-bit binary input representing the number to be displayed.
 * - Output:
 *   - o_Segment_A: Output signal for segment A of the 7-segment display.
 *   - o_Segment_B: Output signal for segment B of the 7-segment display.
 *   - o_Segment_C: Output signal for segment C of the 7-segment display.
 *   - o_Segment_D: Output signal for segment D of the 7-segment display.
 *   - o_Segment_E: Output signal for segment E of the 7-segment display.
 *   - o_Segment_F: Output signal for segment F of the 7-segment display.
 *   - o_Segment_G: Output signal for segment G of the 7-segment display.
 *
 * Notes:
 * The 7-segment encoding is common cathode and follows the convention where a 
 * segment is lit when its corresponding signal is high.
 *
 * Author: Michael Antabian
 * Date: 5/31/2024
 *****************************************************************************/

module Binary_To_7Segment(
    input logic i_clk,
    input logic [3:0] i_Binary_Num,
//    output logic o_Segment_A,
//    output logic o_Segment_B,
//    output logic o_Segment_C,
//    output logic o_Segment_D,
//    output logic o_Segment_E,
//    output logic o_Segment_F,
//    output logic o_Segment_G
    output logic [6:0] o_Segments // 7'bABCDEFG
);
    
    // Provide timescale
    timeunit 1ns;        // The time unit for delays and simulation time is 1 ns.
    timeprecision 1ps;   // The smallest unit of time that can be represented is 1 ps.
    
    logic [6:0] r_Hex_Encoding; //register holds the seven bits of the ssd
    
    always @(posedge i_clk) begin
        case (i_Binary_Num)
            4'b0000: r_Hex_Encoding <= 7'b1111110; //0x7E - 0
            4'b0001: r_Hex_Encoding <= 7'b0110000; //0x30 - 1
            4'b0010: r_Hex_Encoding <= 7'b1101101; //0x6D - 2
            4'b0011: r_Hex_Encoding <= 7'b1111001; //0x79 - 3
            4'b0100: r_Hex_Encoding <= 7'b0110011; //0x33 - 4
            4'b0101: r_Hex_Encoding <= 7'b1011011; //0x5B - 5
            4'b0110: r_Hex_Encoding <= 7'b1011111; //0x5F - 6
            4'b0111: r_Hex_Encoding <= 7'b1110000; //0x70 - 7
            4'b1000: r_Hex_Encoding <= 7'b1111111; //0x7F - 8
            4'b1001: r_Hex_Encoding <= 7'b1111011; //0x7B - 9
            4'b1010: r_Hex_Encoding <= 7'b1110111; //0x77 - A
            4'b1011: r_Hex_Encoding <= 7'b0011111; //0x1F - B
            4'b1100: r_Hex_Encoding <= 7'b1001110; //0x4E - C
            4'b1101: r_Hex_Encoding <= 7'b0111101; //0x3D - D
            4'b1110: r_Hex_Encoding <= 7'b1001111; //0x4F - E
            4'b1111: r_Hex_Encoding <= 7'b1000111; //0x47 - F
            default: r_Hex_Encoding <= 7'b0000000; //0x00 - OFF
        endcase
    end // always block
    
    assign o_Segments = r_Hex_Encoding; // 7'bABCDEFG
    
//    assign o_Segment_A = r_Hex_Encoding[6];
//    assign o_Segment_B = r_Hex_Encoding[5];
//    assign o_Segment_C = r_Hex_Encoding[4];
//    assign o_Segment_D = r_Hex_Encoding[3];
//    assign o_Segment_E = r_Hex_Encoding[2];
//    assign o_Segment_F = r_Hex_Encoding[1];
//    assign o_Segment_G = r_Hex_Encoding[0];
    
endmodule
