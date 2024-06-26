
// Russell Merrick - http://www.nandland.com
//
// Infers a Dual Port RAM (DPRAM) Based FIFO using a single clock
// Uses a Dual Port RAM but automatically handles read/write addresses.
// To use Almost Full/Empty Flags (dynamic)
// Set i_AF_Level to number of words away from full when o_AF_Flag goes high
// Set i_AE_Level to number of words away from empty when o_AE goes high
//   o_AE_Flag is high when this number OR LESS is in FIFO.
//
// Parameters: 
// WIDTH     - Width of the FIFO
// DEPTH     - Max number of items able to be stored in the FIFO
//
// This FIFO cannot be used to cross clock domains, because in order to keep count
// correctly it would need to handle all metastability issues. 
// If crossing clock domains is required, use FIFO primitives directly from the vendor.

module FIFO #(parameter WIDTH = 8, 
              parameter DEPTH = 256)
  (input                     i_Rst_L,
   input                     i_Clk,
   // Write Side
   input                     i_Wr_DV,
   input [WIDTH-1:0]         i_Wr_Data,
   input [$clog2(DEPTH)-1:0] i_AF_Level,
   output                    o_AF_Flag,
   output                    o_Full,
   // Read Side
   input                     i_Rd_En,
   output                    o_Rd_DV,
   output reg [WIDTH-1:0]    o_Rd_Data,
   input [$clog2(DEPTH)-1:0] i_AE_Level,
   output                    o_AE_Flag,
   output                    o_Empty
   );

  reg [$clog2(DEPTH)-1:0] r_Wr_Addr, r_Rd_Addr;
  reg [$clog2(DEPTH):0] r_Count;  // 1 extra bit to go to DEPTH

  wire w_Rd_DV;
  wire [WIDTH-1:0] w_Rd_Data;

  // Dual Port RAM used for storing FIFO data
  RAM #(.WIDTH(WIDTH), .DEPTH(DEPTH)) FIFO_Inst 
    (// Write Port
     .i_Wr_Clk(i_Clk),   
     .i_Wr_Addr(r_Wr_Addr),
     .i_Wr_DV(i_Wr_DV),
     .i_Wr_Data(i_Wr_Data),
     // Read Port
     .i_Rd_Clk(i_Clk),
     .i_Rd_Addr(r_Rd_Addr),
     .i_Rd_En(i_Rd_En),
     .o_Rd_DV(w_Rd_DV),
     .o_Rd_Data(w_Rd_Data)
     );

  always @(posedge i_Clk or negedge i_Rst_L)
  begin
    if (~i_Rst_L)
    begin
      r_Wr_Addr <= 0;
      r_Rd_Addr <= 0;
      r_Count   <= 0;
    end
    else
    begin
      // Write
      if (i_Wr_DV)
      begin
        if (r_Wr_Addr == DEPTH-1)
          r_Wr_Addr <= 0;
        else
          r_Wr_Addr <= r_Wr_Addr + 1;
      end

      // Read
      if (i_Rd_En)
      begin
        if (r_Rd_Addr == DEPTH-1)
          r_Rd_Addr <= 0;
        else
          r_Rd_Addr <= r_Rd_Addr + 1;
      end

      // Keeps track of number of words in FIFO
      // Read with no write
      if (i_Rd_En & ~i_Wr_DV)
      begin
        if (r_Count != 0)
        begin
          r_Count <= r_Count - 1;
        end
      end
      // Write with no read
      else if (i_Wr_DV & ~i_Rd_En)
      begin
        if (r_Count != DEPTH)
        begin
          r_Count <= r_Count + 1;
        end
      end

      if (i_Rd_En)
      begin
        o_Rd_Data <= w_Rd_Data;
      end

    end // else: !if(~i_Rst_L)
  end // always @ (posedge i_Clk or negedge i_Rst_L)


  assign o_Full  = (r_Count == DEPTH) || (r_Count == DEPTH-1 && i_Wr_DV && !i_Rd_En);
  
  assign o_Empty = (r_Count == 0);

  assign o_AF_Flag = (r_Count > DEPTH - i_AF_Level);
  assign o_AE_Flag = (r_Count < i_AE_Level);

  assign o_Rd_DV = w_Rd_DV;

  /////////////////////////////////////////////////////////////////////////////
  // ASSERTION CODE, NOT SYNTHESIZED
  // synthesis translate_off
  // Ensures that we never read from empty FIFO or write to full FIFO.
  always @(posedge i_Clk)
  begin
    if (i_Rd_En && !i_Wr_DV && r_Count == 0)
    begin
      $error("Error! Reading Empty FIFO");
    end

    if (i_Wr_DV && !i_Rd_En && r_Count == DEPTH)
    begin
      $error("Error! Writing Full FIFO");
    end
  end
  // synthesis translate_on
  /////////////////////////////////////////////////////////////////////////////
  
endmodule




/*
module FIFO 
#(
    parameter WIDTH = 8, 
    parameter DEPTH = 16
)
(
    input logic i_rst_L,           // reset signal
    input logic i_clk,             // clock signal

    // write signals
    input logic i_Wr_DV,           // write data valid
    input logic [WIDTH-1:0] i_Wr_Data, // write data
    input logic [$clog2(DEPTH)-1:0] i_AF_Level, // almost full level
    output logic o_AF_Flag,        // almost full flag
    output logic o_Full,           // full flag

    // read signals
    input logic i_Rd_En,           // read enable
    output logic o_Rd_DV,          // read data valid
    output logic [WIDTH-1:0] o_Rd_Data, // read data
    input logic [$clog2(DEPTH)-1:0] i_AE_Level, // almost empty level
    output logic o_AE_Flag,        // almost empty flag
    output logic o_Empty           // empty flag
);

    //provide timescale
    timeunit 1ns; //the time unit for delays and simulation time is 1 ns.
    timeprecision 1ps; // he smallest unit of time that can be represented, is 1 ps.
    
    // internal FIFO storage
    logic [WIDTH-1:0] r_Mem [0:DEPTH-1]; // array of depth elements at width size
    logic [$clog2(DEPTH)-1:0] r_Wr_Addr, r_Rd_Addr; // read and write pointers
    logic [$clog2(DEPTH):0] r_count; // number of entries in the FIFO

    always_ff @(posedge i_clk or negedge i_rst_L) 
    begin
        if (~i_rst_L) 
        begin
            //reset count and pointers to 0
            r_Wr_Addr <= 0;
            r_Rd_Addr <= 0;
            r_count <= 0;
            o_Rd_DV <= 0;
        end 
        else 
        begin
            // Write operation
            if (i_Wr_DV && !o_Full) //Writing is valid and FIFO is not full
            begin
                r_Mem[r_Wr_Addr] <= i_Wr_Data; //input data in FIFO
                r_Wr_Addr <= (r_Wr_Addr == DEPTH-1) ? 0 : r_Wr_Addr + 1; //increment write pointer or restart if at end
                if (!i_Rd_En) r_count <= r_count + 1; // increment count if only write operation
            end

            // Read operation
            if (i_Rd_En && !o_Empty) //read enable is one and FIFO is not empty
            begin
                o_Rd_Data <= r_Mem[r_Rd_Addr]; //read the data from FIFO
                o_Rd_DV <= 1; //toggle data validity on
                r_Rd_Addr <= (r_Rd_Addr == DEPTH-1) ? 0 : r_Rd_Addr + 1; //increment read pointer or restart if at end
                if (!i_Wr_DV) r_count <= r_count - 1; //decrement count if only read operation
            end else begin
                o_Rd_DV <= 0;
            end
        end
    end

    // Full and empty logic
    assign o_Full = (r_count == DEPTH) || (r_count == DEPTH-1 && i_Wr_DV && !i_Rd_En);// check if FIFO is full or will be full
    assign o_Empty = (r_count == 0); // verify if there are no entries in FIFO

    // Almost full and almost empty logic
    assign o_AF_Flag = (r_count >= DEPTH - i_AF_Level);
    assign o_AE_Flag = (r_count <= i_AE_Level);

endmodule

*/