
module LFSR_tb ();

    parameter N = 3; // Parameter declaration for Shift Register width

    logic clk = 0;
    logic [N-1:0] o_LFSR_data;
    logic o_LFSR_done = 0;
    
    LFSR #(N) UUT(
        .clk(clk),
        .o_LFSR_data(o_LFSR_data),
        .o_LFSR_done(o_LFSR_done)
    );
    
    // Clock generation
    always #5 clk = ~clk;
    
     // Initialize LFSR register within the module
    initial begin
        #10; // Wait for a few clock cycles for initialization
        $display("Initial state of LFSR register: %0h", UUT.r_LFSR);
    end


endmodule