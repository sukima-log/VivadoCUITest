`timescale 1ps/1ps
`default_nettype none


module onehot #(
    parameter P_BIT     = 'd32   //- counter bit
,   parameter P_OUT_BIT = 'd32   //- out bit
) (
    input   wire    [(P_BIT-1):0]       sig_i   //- count value
,   output  wire    [(P_OUT_BIT-1):0]   sig_o   //- signal out
);

    function [(P_OUT_BIT-1):0] FUNCTION_ONEHOT (
        input [(P_BIT-1):0]    value
    );
    begin
        case (value)
            'd0:  FUNCTION_ONEHOT       = 4'b0001; 
            'd1:  FUNCTION_ONEHOT       = 4'b0010; 
            'd2:  FUNCTION_ONEHOT       = 4'b0100; 
            'd3:  FUNCTION_ONEHOT       = 4'b1000;  
            default: FUNCTION_ONEHOT    = 4'b0000;
        endcase
    end
    endfunction

    assign sig_o = FUNCTION_ONEHOT(sig_i);

endmodule // onehot


`default_nettype wire
