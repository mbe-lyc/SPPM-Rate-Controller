module duty_cycle_out(
    input clk,
    input [8:0] w,
    
    output reg out
    
    );

reg [8:0] cnt;

always @(posedge clk) begin
    cnt <= cnt == 'd399 ? 1'd0 : cnt+1'd1;
    out <= (w>cnt);
end    

    
endmodule