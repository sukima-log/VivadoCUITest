`timescale 1ps/1ps
`default_nettype none

// ---------------------------
// level to pulse
// ---------------------------

module ltop (
    input   wire    clk     //- clock
,   input   wire    resetn  //- reset negative logic
,   input   wire    sig_i   //- input level signal  _|---
,   output  wire    sig_o   //- output pulse signal _|-|_
);

    reg buffer;     // tmp buffer

    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            buffer <= 1'b0;
        end else begin
            buffer <= sig_i;
        end 
    end

    assign sig_o = (buffer < sig_i); // judge posedge

endmodule // ltop


`default_nettype wire
