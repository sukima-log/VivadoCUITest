`timescale 1ps/1ps
`default_nettype none


module top #(
    parameter P_OUT_BIT = 4
) (
    input   wire                        clk     //- clock
,   input   wire                        resetn  //- reset negative logic
,   input   wire                        btn     //- input signal
,   output  wire    [(P_OUT_BIT-1):0]   led     //- output signal
);

    localparam P_SAMPL = 'd2000;
    localparam P_SAMPL_BIT = clogb2(P_SAMPL);
    localparam P_MATCH = 'd20;
    localparam P_MATCH_BIT = clogb2(P_MATCH);

    wire sig_i;

    // ---------------------------
    // chattering
    // ---------------------------
    chattering #(
        .P_SAMPL_BIT(P_SAMPL_BIT)
    ,   .P_MATCH_BIT(P_MATCH_BIT)
    ) chattering (
        .clk    (clk)
    ,   .resetn (resetn)
    ,   .sig_i  (btn)
    ,   .sample (P_SAMPL)
    ,   .count  (P_MATCH)
    ,   .sig_o  (sig_i)
    );


    wire enable;                            // enable _|-|_

    // ---------------------------
    // level to pulse
    // ---------------------------
    ltop ltop (
        .clk    (clk)               //- clock
    ,   .resetn (resetn)            //- reset negative logic
    ,   .sig_i  (sig_i)             //- in  level signal    _|---
    ,   .sig_o  (enable)            //- out pulse signal    _|-|_
    );


    localparam P_BASE   = 3 + 1;            // counter max + 1
    localparam P_BIT    = clogb2(P_BASE);   // counter bit

    wire    [(P_BIT-1):0]   count;  // count
    wire                    carry;  // carry

    // ---------------------------
    // counter
    // ---------------------------
    counter #(
        .P_BASE (P_BASE)            // counter max + 1
    ,   .P_BIT  (P_BIT)             // counter bit
    ) counter (
        .clk    (clk)               //- clock
    ,   .resetn (resetn)            //- reset
    ,   .enable (enable)            //- in  enable
    ,   .up_dw  (1'b1)              //- in  up:1, down:0
    ,   .count  (count)             //- out count value
    ,   .carry  (carry)             //- out carry
    );


    // ---------------------------
    // onehot count to 8bit
    // ---------------------------
    onehot #(
        .P_BIT  (P_BIT)             // count bit
    ,   .P_OUT_BIT(P_OUT_BIT)       // out bit
    ) onehot (
        .sig_i  (count)             //- in  count value
    ,   .sig_o  (led)               //- out onehot
    );

    // define the clogb2 function   
    // 定数関数（Constant Function）
    function integer clogb2 (
        input integer value
    );    
        begin  
            value = value-1;  
            for (clogb2=0; value>0; clogb2=clogb2+1) begin
              value = value>>1;
            end
        end  
    endfunction

endmodule

`default_nettype wire

