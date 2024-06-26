
// Russell Merrick - http://www.nandland.com
//
// FIFO testbench.

module FIFO_TB ();

  localparam DEPTH = 4;
  localparam WIDTH = 8;

  reg r_Clk = 1'b0, r_Rst_L = 1'b0;
  reg r_Wr_DV = 1'b0, r_Rd_En = 1'b0;
  reg [WIDTH-1:0] r_Wr_Data = 0;
  reg [$clog2(DEPTH)-1:0] r_AF_Level = DEPTH-1, r_AE_Level = 1;
  wire w_AF_Flag, w_AE_Flag, w_Full, w_Empty, w_Rd_DV;
  wire [WIDTH-1:0] w_Rd_Data;
  
  FIFO #(.WIDTH(WIDTH), .DEPTH(DEPTH)) UUT 
  (
  .i_Rst_L(r_Rst_L),
  .i_Clk(r_Clk),
  // Write Side
  .i_Wr_DV(r_Wr_DV),
  .i_Wr_Data(r_Wr_Data),
  .i_AF_Level(r_AF_Level),
  .o_AF_Flag(w_AF_Flag),
  .o_Full(w_Full),
  // Read Side
  .i_Rd_En(r_Rd_En),
  .o_Rd_DV(w_Rd_DV),
  .o_Rd_Data(w_Rd_Data),
  .i_AE_Level(r_AE_Level),
  .o_AE_Flag(w_AE_Flag),
  .o_Empty(w_Empty)
  );

  always #10 r_Clk <= !r_Clk; // create oscillating clock

  // This task triggers a reset condition to the FIFO.
  task reset_fifo();
    @(posedge r_Clk);
    r_Rst_L <= 1'b0;
    r_Wr_DV <= 1'b0;  // ensure rd/wr are off
    r_Rd_En <= 1'b0;
    @(posedge r_Clk);
    r_Rst_L <= 1'b1;
    @(posedge r_Clk);
    @(posedge r_Clk);
  endtask


  initial
  begin 
    integer i;
    $dumpfile("dump.vcd"); $dumpvars; // for EDA Playground sim
    
    reset_fifo();

    // Write single word, ensure it appears on output
    r_Wr_DV   <= 1'b1;
    r_Wr_Data <= 8'hAB;
    @(posedge r_Clk);
    r_Wr_DV   <= 1'b0;
    @(posedge r_Clk);
    assert (!w_Empty);

    repeat(4) @(posedge r_Clk);

    // Read out that word, ensure DV and empty is correct
    r_Rd_En <= 1'b1;
    @(posedge r_Clk);
    r_Rd_En <= 1'b0;
    @(posedge r_Clk);
    assert (w_Rd_DV);
    assert (w_Empty);
    assert (w_Rd_Data == 8'hAB);


    // Test: Fill FIFO with incrementing pattern, then read it back.
    reset_fifo();
    r_Wr_Data <= 8'h30;
    repeat(DEPTH)
    begin
      r_Wr_DV <= 1'b1;
      @(posedge r_Clk);
      r_Wr_DV <= 1'b0;
      @(posedge r_Clk);
      r_Wr_Data <= r_Wr_Data + 1;
    end
    r_Wr_DV <= 1'b0;
    @(posedge r_Clk);
    assert (w_Full);
    @(posedge r_Clk);

    // Read out and verify incrementing pattern
    for (i=8'h30; i<8'h30 + DEPTH; i=i+1)
    begin
      r_Rd_En <= 1'b1;
      @(posedge r_Clk);
      r_Rd_En <= 1'b0;
      @(posedge r_Clk);
      assert (w_Rd_DV);
      assert (w_Rd_Data == i) else $error("rd_data is %d i is %d", w_Rd_Data, i);
      @(posedge r_Clk);
    end
    assert (w_Empty);


    // Test: Read and write on same clock cycle when empty + full
    reset_fifo();
    r_Rd_En <= 1'b1;
    r_Wr_DV <= 1'b1;
    @(posedge r_Clk);
    @(posedge r_Clk);
    r_Rd_En <= 1'b0;
    repeat(DEPTH) @(posedge r_Clk);
    assert (w_Full);
    r_Rd_En <= 1'b1;
    @(posedge r_Clk);
    assert (w_Full);
    @(posedge r_Clk);
    assert (w_Full);
    r_Wr_DV <= 1'b0;
    r_Rd_En <= 1'b0;

    // Test: Almost Empty, Almost Full Flags
    // AE is set to 1, AF is set to 3
    reset_fifo();
    assert (w_AE_Flag);
    assert (!w_AF_Flag);
    
    r_Wr_DV <= 1'b1;
    @(posedge r_Clk);
    assert (w_AE_Flag);
    assert (!w_AF_Flag);
    @(posedge r_Clk);
    assert (!w_AE_Flag);
    assert (!w_AF_Flag);
    @(posedge r_Clk);
    assert (!w_AE_Flag);
    assert (w_AF_Flag);
    @(posedge r_Clk);
    assert (!w_AE_Flag);
    assert (w_AF_Flag);
    assert (w_Full);  

    $finish();
  end

endmodule



//module FIFO_tb;

//    parameter WIDTH = 8;
//    parameter DEPTH = 16;

//    logic i_rst_L;
//    logic i_clk;
//    logic i_Wr_DV;
//    logic [WIDTH-1:0] i_Wr_Data;
//    logic [$clog2(DEPTH)-1:0] i_AF_Level;
//    logic o_AF_Flag;
//    logic o_Full;
//    logic i_Rd_En;
//    logic o_Rd_DV;
//    logic [WIDTH-1:0] o_Rd_Data;
//    logic [$clog2(DEPTH)-1:0] i_AE_Level;
//    logic o_AE_Flag;
//    logic o_Empty;

//    FIFO #(
//        .WIDTH(WIDTH),
//        .DEPTH(DEPTH)
//    ) UUT (
//        .i_rst_L(i_rst_L),
//        .i_clk(i_clk),
//        .i_Wr_DV(i_Wr_DV),
//        .i_Wr_Data(i_Wr_Data),
//        .i_AF_Level(i_AF_Level),
//        .o_AF_Flag(o_AF_Flag),
//        .o_Full(o_Full),
//        .i_Rd_En(i_Rd_En),
//        .o_Rd_DV(o_Rd_DV),
//        .o_Rd_Data(o_Rd_Data),
//        .i_AE_Level(i_AE_Level),
//        .o_AE_Flag(o_AE_Flag),
//        .o_Empty(o_Empty)
//    );

//    // Clock generation
//    always #5 i_clk = ~i_clk;

//    initial begin
//        // Initialize signals
//        i_clk = 0;
//        i_rst_L = 0;
//        i_Wr_DV = 0;
//        i_Wr_Data = 0;
//        i_AF_Level = 2; // Set Almost Full level
//        i_Rd_En = 0;
//        i_AE_Level = 2; // Set Almost Empty level

//        // Apply reset
//        #10;
//        i_rst_L = 1;
//        #10;
//        i_rst_L = 0;
//        #10;
//        i_rst_L = 1;

//        // Write data to FIFO
//        for (int i = 0; i < DEPTH; i++) begin
//            @(posedge i_clk);
//            i_Wr_DV = 1;
//            i_Wr_Data = i;
//            #10;
//            i_Wr_DV = 0;
//        end

//        // Check Full flag
//        @(posedge i_clk);
//        if (o_Full) $display("FIFO is full");

//        // Read data from FIFO at random intervals
//        fork
//            begin
//                for (int i = 0; i < DEPTH; i++) begin
//                    @(posedge i_clk);
//                    if ($urandom_range(0, 1)) begin
//                        i_Rd_En = 1;
//                        #10;
//                        i_Rd_En = 0;
//                    end
//                end
//            end

//            // Write and read simultaneously
//            begin
//                for (int i = 0; i < DEPTH; i++) begin
//                    @(posedge i_clk);
//                    i_Wr_DV = 1;
//                    i_Wr_Data = i + DEPTH;
//                    if ($urandom_range(0, 1)) begin
//                        i_Rd_En = 1;
//                    end
//                    #10;
//                    i_Wr_DV = 0;
//                    i_Rd_En = 0;
//                end
//            end
//        join

//        // End simulation
//        #100;
//        $finish;
//    end

//    // Monitor outputs
//    always @(posedge i_clk) begin
//        if (o_Rd_DV) begin
//            $display("Read Data: %0d", o_Rd_Data);
//        end

//        $display("Full: %b, Empty: %b, Almost Full: %b, Almost Empty: %b", o_Full, o_Empty, o_AF_Flag, o_AE_Flag);
//    end

//endmodule
