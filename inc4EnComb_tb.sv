module inc4EnComb_tb();

  //// declare stimulus as type reg ////
  reg error;
  reg [3:0] cnt;
  reg inc;
  
  wire [3:0] nxt_cnt;		// hook to output of DUT
  
  //////////////////////
  // Instantiate DUT //
  ////////////////////
  inc4EnComb iDUT(.cnt(cnt),.inc(inc),.nxt_cnt(nxt_cnt));
  
  initial begin
    error = 1'b0;		// innocent till proven guilty
    cnt = 4'h0;
	inc = 1'b0;

	#5;
	if (nxt_cnt!==4'b0000) begin
	  $display("ERR: at time = %t nxt_cnt should be 0000",$time);
	  error = 1'b1;
	end
	
	#5;
	inc = 1'b1;
	#5;
	if (nxt_cnt!==4'b0001) begin
	  $display("ERR: at time = %t nxt_cnt should now be 0001",$time);
	  error = 1'b1;
	end	
	
	#5;
	cnt = 4'h1;
	#5;
	if (nxt_cnt!==4'b0010) begin
	  $display("ERR: at time = %t nxt_cnt should be 4'b0010",$time);
	  error = 1'b1;
	end		

    #5;
	inc = 1'b0;
	#5;

	if (nxt_cnt!==4'b0001) begin
	  $display("ERR: at time = %t nxt_cnt should still be 4'b0001",$time);
	  error = 1'b1;
	end	
	
	#5;
	inc = 1'b1;
	cnt = 4'hf;
	#5;

	if (nxt_cnt!==4'b0000) begin
	  $display("ERR: at time = %t nxt_cnt should be rolling over to 4'b0000",$time);
	  error = 1'b1;
	end	

    if (!error)
	  $display("YAHOO! test passed for cnt4EnComb");
	$stop();
  end
  
endmodule