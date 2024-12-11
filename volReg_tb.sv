module volReg_tb();

  // Testbench signals
  reg clk;
  reg rst_n;
  reg step_up;
  reg step_dwn;
  reg error;
  reg [11:0] expected_volume; // Variable to track expected volume
  wire [11:0] volume12;

  // Clock generation: 50 MHz (20 ns period)
  initial begin
    clk = 0;
    forever #10 clk = ~clk;
  end

  //////////////////////
  // Instantiate DUT //
  ////////////////////
  volReg iDUT (
    .clk(clk),
    .rst_n(rst_n),
    .step_up(step_up),
    .step_dwn(step_dwn),
    .volume12(volume12)
  );

  // Test sequence
  initial begin
    // Initialize signals
    rst_n = 0;
    step_up = 0;
    step_dwn = 0;
    error = 1'b0; // Initialize error signal to 0
    expected_volume = 12'h800; // Initialize expected volume to reset value
    
    // // deassert reset
    @(negedge clk);
    rst_n = 1;
    
    // Wait and observe initial value
    #25;
    @(negedge clk);
    if (volume12 !== expected_volume) begin
      $display("ERR: at time = %t, register needs to reset to 0x800 which represents nominal volume.", $time);
      error = 1'b1;
    end
    
    // Test step up
    step_up = 1;
    #20;
    step_up = 0;
    #20;
    expected_volume = expected_volume + 12'h040; // Update expected volume
    @(negedge clk);
    if (volume12 !== expected_volume) begin
      $display("ERR: at time = %t, expected volume after step up is %h, but got %h", $time, expected_volume, volume12);
      error = 1'b1;
    end
    
    // Test multiple step ups
    repeat(3) begin
      step_up = 1;
      #20;
      step_up = 0;
      #20;
      expected_volume = expected_volume + 12'h040; // Update expected volume
      @(negedge clk);
        if (volume12 !== expected_volume) begin
        $display("ERR: at time = %t, expected volume after step up is %h, but got %h", $time, expected_volume, volume12);
        error = 1'b1;
      end
    end

    // Test step down
    step_dwn = 1;
    #20;
    step_dwn = 0;
    #20;
    expected_volume = expected_volume - 12'h040; // Update expected volume
    @(negedge clk);
    if (volume12 !== expected_volume) begin
      $display("ERR: at time = %t, expected volume after step down is %h, but got %h", $time, expected_volume, volume12);
      error = 1'b1;
    end
    
    // Test multiple step downs
    repeat(3) begin
      step_dwn = 1;
      #20;
      step_dwn = 0;
      #20;
      expected_volume = expected_volume - 12'h040; // Update expected volume
      @(negedge clk);
      if (volume12 !== expected_volume) begin
        $display("ERR: at time = %t, expected volume after step down is %h, but got %h", $time, expected_volume, volume12);
        error = 1'b1;
      end
    end
 
    // End of test
    if (error) begin
      $display("TEST FAILED: One or more checks did not pass.");
    end else begin
      $display("YAHOO! test passed for volReg");
    end
    $stop;
  end

endmodule
