module rate_controller(
	input sppm,

	output led
    );


reg sppm_sync, sppm_de, sppm_mono;
always @(posedge clk400M) begin
	sppm_sync <= sppm;
	sppm_de <= sppm_sync;
	sppm_mono <= ((sppm_sync==1'd1)&(sppm_de==1'd0));
end

reg [19:0] cnt1;
always @(posedge clk400M) begin
	cnt1 <= cnt1=='d399999 ? 'd0 : cnt1+1'd1;		
end

reg [16:0] sppm_1ms;
always @(posedge clk400M) begin
	sppm_1ms <= cnt1 == 'd399999 ? 'd0 : sppm_1ms+sppm_mono;	
end

reg [8:0] w1;
always @(posedge clk400M) begin
	if(cnt1 == 'd399999) begin
		if(sppm_1ms > 'd808) begin
			w1 <= w1=='d0 ? 'd0 : w1-'d1;
		end
		else if(sppm_1ms < 'd792) begin
			w1 <= w1=='d400 ? w1 : w1+'d1;
		end
	end
end

duty_cycle_out dcout1( .clk(clk400M), .w(w1), .out(led));

endmodule