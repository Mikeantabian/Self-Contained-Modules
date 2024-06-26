module SR_tb;

    parameter N = 4; // Parameter declaration for Shift Register width

    // Declare inputs and outputs for the testbench
    logic clk = 0;
    logic i_data = 0;
    logic [N-1:0] o_data;

    // Instantiate Shift Register module with parameter N
    ShiftRegister #(N) UUT (
        .i_data(i_data),
        .clk(clk),
        .o_data(o_data)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Generate random input data at each positive clock edge
    always_ff @(posedge clk) begin
        i_data <= $random % 2; // Randomize i_data between 0 and 1
    end

endmodule
