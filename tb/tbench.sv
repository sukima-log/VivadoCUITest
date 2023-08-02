`timescale 1ps/1ps
`default_nettype none


module tbench ();

//==============================================================================
//-- tbench : RESET generator
//==============================================================================
    reg resetn;
 
    initial begin
        resetn = 1'b0;
        #1_234_000
        resetn = 1'b1;
    end

//==============================================================================
//-- tbench : CLOCK generator
//==============================================================================
    real    FREQ_CLK = 100.0/*MHz*/;
    reg     clk;

    initial begin
        clk = 1'b0;
        forever #(1_000_000_000 / (FREQ_CLK*1_000) / 2) clk = ~clk;
    end

//==============================================================================
//-- tbench : Test Target
//==============================================================================
    reg         sig_i;  // signal in
    reg [3:0]   sig_o;  // signal out

    top top (
        .clk    (clk)       //- in  clock
    ,   .resetn (resetn)    //- in  reset negative
    ,   .btn    (sig_i)     //- in  signal
    ,   .led    (sig_o)     //- out signal
    );


    `include "tp.sv"

endmodule

`default_nettype wire