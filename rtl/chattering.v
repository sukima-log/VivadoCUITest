`timescale 1ps/1ps
`default_nettype none

module chattering #(
    parameter P_SAMPL_BIT   = 'd32  // bit (sampling)
,   parameter P_MATCH_BIT   = 'd32  // bit (match)
) (
    input   wire                            clk         //- clock
,   input   wire                            resetn      //- reset negative logic
,   input   wire                            sig_i       //- input signal
,   input   wire    [(P_SAMPL_BIT-1):0]     sample      //- sample base
,   input   wire    [(P_MATCH_BIT-1):0]     count       //- N_mutch base
,   output  reg                             sig_o       //- output signal
);

    reg [(P_SAMPL_BIT-1):0]     scount;                 // sampling timing
    reg                         buffer;                 // temporary buffer

    wire w_flag = ~(scount+'d1 < (sample));

    // -----------------------------------
    // count up
    // -----------------------------------
    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            scount   <= {P_SAMPL_BIT{1'b0}};
        end else if (w_flag) begin
            scount   <= {P_SAMPL_BIT{1'b0}};
        end else begin
            scount   <= scount + 'd1;
        end
    end

    // -----------------------------------
    // sampling
    // -----------------------------------
    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            buffer <= 'd0;
        end else if (scount == 'd0) begin
            buffer <= sig_i;
        end
    end


    reg [(P_MATCH_BIT-1):0]   mcount;            // n times

    wire w_pass     = ~(mcount+'d1 < (count));   // n times match
    wire w_judge    = (buffer == sig_i);         // same
    wire w_dif      = ~(buffer == sig_i);        // different

    // -----------------------------------
    // n times matchs
    // -----------------------------------
    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            mcount <= {P_MATCH_BIT{1'b0}};
        end else if (w_pass) begin
            mcount <= {P_MATCH_BIT{1'b0}};
        end else if (w_dif) begin
            mcount <= {P_MATCH_BIT{1'b0}};
        end else if (w_judge) begin
            mcount <= mcount + 'd1;
        end
    end

    // -----------------------------------
    // pass signal
    // -----------------------------------
    always @(posedge clk) begin
        if (w_pass) begin
            sig_o <= buffer;
        end
    end

endmodule // chattering

`default_nettype wire