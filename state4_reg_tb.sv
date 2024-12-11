module state4_reg_tb();

  //// declare stimulus as type reg ////
  reg error;
  reg clk;
  reg rst_n;
  
  wire [3:0] nxt_state;
  
  wire [3:0] state;		// hook to state output of DUT
  
  //////////////////////
  // Instantiate DUT //
  ////////////////////
  state4_reg iDUT(.clk(clk),.rst_n(rst_n),.nxt_state(nxt_state),.state(state));
  
  assign nxt_state = {state[0],state[3:1]};
  
  initial begin
    error = 1'b0;		// innocent till proven guilty
    clk = 1'b0;
	rst_n = 1'b1;
	
	@(negedge clk);
	if (state!==4'bxxxx) begin
	  $display("ERR: at time = %t state should be mainly uninitialized",$time);
	  error = 1'b1;
	end
	#1 rst_n = 1'b0;
	#1;
	if (state!==4'b0001) begin
	  $display("ERR: at time = %t state should be 4'b0001",$time);
	  error = 1'b1;
	end
	
	@(negedge clk);
	rst_n = 1'b1;
	if (state!==4'b0001) begin
	  $display("ERR: at time = %t state should be 4'b0001",$time);
	  error = 1'b1;
	end	
	
	@(negedge clk);
	if (state!==4'b1000) begin
	  $display("ERR: at time = %t state should be 4'b1000",$time);
	  error = 1'b1;
	end	

	@(negedge clk);
	if (state!==4'b0100) begin
	  $display("ERR: at time = %t state should be 4'b0100",$time);
	  error = 1'b1;
	end
	
	#1 rst_n = 1'b0;
	#1;
	if (state!==4'b0001) begin
	  $display("ERR: at time = %t state should be 4'b0001",$time);
	  error = 1'b1;
	end
	
    if (!error)
	  $display("YAHOO! test passed for state4_reg");
	$stop();
  end
  
  always
    #5 clk = ~clk;		// clock start at zero and toggles every 5 time units
  
endmodule