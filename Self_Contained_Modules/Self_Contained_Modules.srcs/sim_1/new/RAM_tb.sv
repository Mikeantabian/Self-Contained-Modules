module RAM_tb();

    localparam DEPTH = 4;
    localparam WIDTH = 8;

    logic r_Clk = 1'b0;
    logic i_Wr_DV = 1'b0, i_Rd_En = 1'b0;
    logic [$clog2(DEPTH)-1:0] i_Wr_Addr = 0, i_Rd_Addr = 0;
    logic [WIDTH-1:0] i_Wr_Data = 0;
    logic [WIDTH-1:0] o_Rd_Data;
    logic o_Rd_DV;
    
    always #10 r_Clk <= !r_Clk; // create oscillating clock

      RAM #(.WIDTH(WIDTH), .DEPTH(DEPTH)) UUT 
      (// Write Signals
      .i_Wr_Clk(r_Clk),
      .i_Wr_Addr,
      .i_Wr_DV,
      .i_Wr_Data,
      // Read Signals
      .i_Rd_Clk(r_Clk),
      .i_Rd_Addr,
      .i_Rd_En,
      .o_Rd_DV,
      .o_Rd_Data
      );

    initial begin
        // Allow some time for initialization
        #10;

        // Continuous write and read operations
        forever begin
            // Generate random write address, data, and enable
            i_Wr_Addr = $urandom_range(0, DEPTH);
            i_Wr_Data = $urandom;
            i_Wr_DV = 1;

            // Wait for a few clock cycles before issuing read
            #10;

            // Generate random read address and enable
            i_Rd_Addr = $urandom_range(0, DEPTH);
            i_Rd_En = 1;

            // Wait for read data valid
            @(posedge r_Clk);
            
            // Verify read data matches written data
            if (o_Rd_DV) begin
                if (o_Rd_Data !== UUT.r_Mem[i_Rd_Addr]) begin
                    $display("Error: Read data mismatch at address %0d", i_Rd_Addr);
                end
            end

            // Disable write and read
            i_Wr_DV = 0;
            i_Rd_En = 0;

            // Wait for a few clock cycles before next iteration
            #10;
        end
    end

endmodule

//// Russell Merrick - http://www.nandland.com
////
//// Dual Port RAM testbench.

//module RAM_tb ();

//  localparam DEPTH = 4;
//  localparam WIDTH = 8;

//  logic r_Clk = 1'b0;
//  logic r_Wr_DV = 1'b0, r_Rd_En = 1'b0;
//  logic [$clog2(DEPTH)-1:0] r_Wr_Addr = 0, r_Rd_Addr = 0;
//  logic [WIDTH-1:0] r_Wr_Data = 0;
//  logic [WIDTH-1:0] w_Rd_Data;
  
//  always #10 r_Clk <= !r_Clk; // create oscillating clock

//  RAM #(.WIDTH(WIDTH), .DEPTH(DEPTH)) UUT 
//  (// Write Signals
//  .i_Wr_Clk(r_Clk),
//  .i_Wr_Addr(r_Wr_Addr),
//  .i_Wr_DV(r_Wr_DV),
//  .i_Wr_Data(r_Wr_Data),
//  // Read Signals
//  .i_Rd_Clk(r_Clk),
//  .i_Rd_Addr(r_Rd_Addr),
//  .i_Rd_En(r_Rd_En),
//  .o_Rd_DV(),
//  .o_Rd_Data(w_Rd_Data)
//  );

//  initial
//  begin 
    
//    repeat(4) @(posedge r_Clk); // Give simulation a few clocks to start

//    // Fill memory with incrementing pattern
//    repeat(DEPTH)
//    begin
//      r_Wr_DV <= 1'b1;
//      @(posedge r_Clk);
//      r_Wr_Data <= r_Wr_Data + 1;
//      r_Wr_Addr <= r_Wr_Addr + 1;
//    end
//    r_Wr_DV <= 1'b0;

//    // Read out incrementing pattern
//    repeat(DEPTH)
//    begin
//      r_Rd_En   <= 1'b1;
//      @(posedge r_Clk);
//      r_Rd_Addr <= r_Rd_Addr + 1;
//	  end
//    r_Rd_En   <= 1'b0;

//    repeat(4) @(posedge r_Clk); 

//    // Test reading and writing at the same time
//    r_Wr_Addr <= 1;
//    r_Wr_Data <= 84;
//    r_Rd_Addr <= 1;
//    r_Rd_En <= 1'b1;
//    r_Wr_DV <= 1'b1;
//    @(posedge r_Clk);
//    r_Rd_En <= 1'b0;
//    r_Wr_DV <= 1'b0;
//    repeat(3) @(posedge r_Clk);
//    r_Rd_En <= 1'b1;
//    @(posedge r_Clk);
//    r_Rd_En <= 1'b0;
//    repeat(3) @(posedge r_Clk);
    
//    $finish();
//  end

//endmodule