module CODEC_cfg_tb();

  // Testbench signals
  reg clk;
  reg rst_n;
  reg error;
  wire SCL;
  tri0 SDA;  // Open-drain behavior, defaults to weak1

  // Instantiate the DUT (Device Under Test)
  CODEC_cfg iDUT (
    .clk(clk),
    .rst_n(rst_n),
    .SCL(SCL),
    .SDA(SDA)
  );




// Control signal for driving SDA in the testbench
reg sda_drive;
assign SDA = (sda_drive) ? 1'b0 : 1'bz;  // Drive SDA with strong 0 when sda_drive is 1, otherwise high-Z (weak 1 by default)


  // Clock generation: 50 MHz (20 ns period)
  initial begin
    clk = 0;
    forever #10 clk = ~clk;
  end

  // Test sequence
  initial begin
    // Initialize signals
    rst_n = 0;
    error = 1'b0;
    sda_drive = 0;  // Start with SDA in high-Z (floating)

    // Apply reset
    #15 rst_n = 1;

    // Check if the initial state is POR
    #50;
    if (iDUT.state !== iDUT.POR || iDUT.wrt !== 1'b0) begin
      $display("ERR: Initial state is not POR or wrt is not deasserted after reset at time %t. \
        Current state: %b, wrt: %b", $time, iDUT.state, iDUT.wrt);
      error = 1'b1;
    end else begin
      $display("Initial state is POR as expected at time %t", $time);
    end

    // Wait for tmr_ovr to go high
    @(posedge iDUT.tmr_ovr);
    $display("tmr_ovr signal asserted at time %t", $time);
    @(posedge clk);

    // On the next clock cycle, check if the state transitions to WAIT_SENT
    // wrt need to be asserter as well
    @(posedge clk);
    if (iDUT.state !== iDUT.WAIT_SENT ) begin
      $display("ERR: State did not transition to WAIT_SENT after tmr_ovr at time %t. Current state: %b, \
        wrt: %b \n Check your wrt signal, when timer is over it should assert the wet signal", $time, iDUT.state, iDUT.wrt);
      error = 1'b1;
    end else begin
      $display("State transitioned to WAIT_SENT as expected at time %t", $time);
    end
    // Monitor for premature transition to DONE
    forever begin
      @(posedge clk);
      
      // Check if state goes to DONE before both conditions (done == 1 && cmd_indx == 5'h9) are met
      if (iDUT.state == iDUT.DONE && !(iDUT.done && iDUT.cmd_indx == 5'h9)) begin
        $display("ERR: State transitioned to DONE prematurely at time %t. Current cmd_indx: %h, done: %b", $time, iDUT.cmd_indx, iDUT.done);
        error = 1'b1;
        $stop; // Stop the simulation immediately if premature transition is detected
      end

      // Break the loop once both done and cmd_indx conditions are met
      if (iDUT.done && iDUT.cmd_indx == 5'h9) begin
        $display("Conditions met: done == 1 and cmd_indx == 5'h9 at time %t", $time);
        break;
      end
    end

    // On the next clock cycle, check if the state transitions to DONE
    @(posedge clk);
    if (iDUT.state !== iDUT.DONE) begin
      $display("ERR: State did not transition to DONE after done == 1 and cmd_indx == 5'h9 at time %t. Current state: %b", $time, iDUT.state);
      error = 1'b1;
    end else begin
      $display("State transitioned to DONE as expected at time %t", $time);
    end

    // Final check for any errors
    if (error) begin
      $display("TEST FAILED: Errors detected during the test.");
    end else begin
      $display("YAHOO! test passed for CODEC_cfg.");
    end

    // Finish the test
    #500000;
    $stop;
  end 

endmodule
