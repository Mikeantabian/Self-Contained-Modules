
module RAM
#(parameter WIDTH = 16, DEPTH = 256)
(
    //write signals
    input logic i_Wr_Clk,
    input logic [$clog2(DEPTH)-1:0] i_Wr_Addr,
    input logic i_Wr_DV,
    input logic [WIDTH-1:0] i_Wr_Data,
    //read signals
    input logic i_Rd_Clk,
    input logic [$clog2(DEPTH)-1:0] i_Rd_Addr,
    input logic i_Rd_En,
    output logic o_Rd_DV,
    output logic [WIDTH-1:0] o_Rd_Data
);

    //provide timescale
    timeunit 1ns; //the time unit for delays and simulation time is 1 ns.
    timeprecision 1ps; // he smallest unit of time that can be represented, is 1 ps.
    
    //array of depth amount of width length data
    logic [WIDTH-1:0] r_Mem [DEPTH-1:0];
    
    //procedure for write clock
    always @(posedge i_Wr_Clk)
    begin
        if(i_Wr_DV)
        begin
            r_Mem[i_Wr_Addr] <= i_Wr_Data;
        end
    end
    
    //procedure for read clock
    always @(posedge i_Rd_Clk)
    begin
        o_Rd_Data <= r_Mem[i_Rd_Addr];
        o_Rd_DV <= i_Rd_En;
    end
    

endmodule
