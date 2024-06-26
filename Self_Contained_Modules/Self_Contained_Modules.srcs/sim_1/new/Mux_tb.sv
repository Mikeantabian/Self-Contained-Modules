
module Mux_tb();

    //local test signals
    logic [3:0] i_data;
    logic [1:0] i_sel;
    logic o_data;
    
/*   
    //Instantiate Mux module: UUT
    Mux UUT (
        .i_data(i_data),
        .i_sel(i_sel),
        .o_data(o_data)
    );
    
    use dot-name shortcut method
    Mux UUT (
        .i_data, .i_sel, .o_data
    );
*/
    
    //use dot-star shortcut method
    Mux UUT (.*);
    
    initial begin
        //apply test vector
        i_data = 4'b1010; //random input data
        
        i_sel = 2'b00; //select lines : 00
        #10 //wait 10ns
        
        i_sel = 2'b01; //select lines : 01
        #10 //wait 10ns
        
        i_sel = 2'b10; //select lines : 10
        #10 //wait 10ns
        
        i_sel = 2'b11; //select lines : 11
        #10 //wait 10ns
        $finish;
    end
    
endmodule