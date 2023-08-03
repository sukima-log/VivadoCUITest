

task pulse (
    input integer x
,   input integer y
);
    begin

        for (int i=0; i<x; i++) begin
            #123_400_000
            sig_i = sig_i;
        end

        sig_i = 1;

        for (int i=0; i<x; i++) begin
            #123_400_000
            sig_i = sig_i;
        end

        sig_i = 0;
    end
endtask


initial begin
    
    sig_i = 0;
    @(posedge resetn)
    $display("test start");

    for (int i=0; i<10; i++) begin
        pulse((($random%2)+2),(($random%2)+1));
    end

    $finish();

end