module ampCalcAvg_tb;

  // Inputs
  reg clk;
  reg rst_n;
  reg aud_vld;
  reg [15:0] lft_aud;
  reg [15:0] rht_aud;

  // Outputs
  wire [8:0] lft_amp;
  wire [8:0] rht_amp;

  // Error counter
  integer errors = 0;

  // Instantiate the Design Under Test (DUT)
  ampCalcAvg iDUT (
    .clk(clk),
    .rst_n(rst_n),
    .aud_vld(aud_vld),
    .lft_aud(lft_aud),
    .rht_aud(rht_aud),
    .lft_amp(lft_amp),
    .rht_amp(rht_amp)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #10 clk = ~clk; // 50MHz clock
  end

  // Stimulus process
  initial begin
    // Initialize inputs
    rst_n = 0;
    aud_vld = 0;
    lft_aud = 0;
    rht_aud = 0;

    // Display headers
    $display("Time | rst_n | aud_vld | lft_aud | rht_aud | lft_amp | rht_amp | Result");
    $display("-----------------------------------------------------------------------");

    // Reset sequence
    #50 rst_n = 1;

    // Gradually increase left channel amplitude
    test_case_left(16'h0000, 16'h0000, 9'b000000000); // lft_aud: 0
    test_case_left(16'h0877, 16'h0000, 9'b000000001); // lft_aud: 2167
    test_case_left(16'h0B00, 16'h0000, 9'b000000011); // lft_aud: 2816
    test_case_left(16'h0E00, 16'h0000, 9'b000000111); // lft_aud: 3584
    test_case_left(16'h2000, 16'h0000, 9'b000001111); // lft_aud: 8192
    test_case_left(16'h3000, 16'h0000, 9'b000011111); // lft_aud: 12288
    test_case_left(16'h4000, 16'h0000, 9'b000111111); // lft_aud: 16384
    test_case_left(16'h5000, 16'h0000, 9'b001111111); // lft_aud: 20480
    test_case_left(16'h6000, 16'h0000, 9'b011111111); // lft_aud: 24576
    test_case_left(16'h7FFF, 16'h0000, 9'b111111111); // lft_aud: 32767

    // Gradually increase right channel amplitude
    test_case_right(16'h0000, 16'h0000, 9'b000000000); // rht_aud: 0
    test_case_right(16'h0000, 16'h0877, 9'b000000001); // rht_aud: 2167
    test_case_right(16'h0000, 16'h0B00, 9'b000000011); // rht_aud: 2816
    test_case_right(16'h0000, 16'h0E00, 9'b000000111); // rht_aud: 3584
    test_case_right(16'h0000, 16'h2000, 9'b000001111); // rht_aud: 8192
    test_case_right(16'h0000, 16'h3000, 9'b000011111); // rht_aud: 12288
    test_case_right(16'h0000, 16'h4000, 9'b000111111); // rht_aud: 16384
    test_case_right(16'h0000, 16'h5000, 9'b001111111); // rht_aud: 20480
    test_case_right(16'h0000, 16'h6000, 9'b011111111); // rht_aud: 24576
    test_case_right(16'h0000, 16'h7FFF, 9'b111111111); // rht_aud: 32767

    // Check for errors
    if (errors == 0) begin
      $display("Yahoo! all tests passed for ampCalcAvg module");
    end else begin
      $display("Test failed: %d errors detected.", errors);
    end

    // End simulation
    $stop;
  end

  // Task to test left channel
  task test_case_left(
    input [15:0] lft_aud_in,
    input [15:0] rht_aud_in,
    input [8:0] exp_lft_amp
  );
    begin
      // Apply inputs
      aud_vld = 1;
      lft_aud = lft_aud_in;
      rht_aud = rht_aud_in;
      #500 aud_vld = 0; // Deassert aud_vld after a short pulse
      #10000; // Allow processing time

      // Check left channel result
      if (lft_amp !== exp_lft_amp) begin
        $display("%t | %b | %d | %d | %b | %b | FAIL (Expected Left: %b)",
                 $time, aud_vld, lft_aud, rht_aud, lft_amp, rht_amp, exp_lft_amp);
        errors = errors + 1;
      end else begin
        $display("%t | %b | %d | %d | %b | %b | PASS",
                 $time, aud_vld, lft_aud, rht_aud, lft_amp, rht_amp);
      end
    end
  endtask

  // Task to test right channel
  task test_case_right(
    input [15:0] lft_aud_in,
    input [15:0] rht_aud_in,
    input [8:0] exp_rht_amp
  );
    begin
      // Apply inputs
      aud_vld = 1;
      lft_aud = lft_aud_in;
      rht_aud = rht_aud_in;
      #500 aud_vld = 0; // Deassert aud_vld after a short pulse
      #10000; // Allow processing time

      // Check right channel result
      if (rht_amp !== exp_rht_amp) begin
        $display("%t | %b | %d | %d | %b | %b | FAIL (Expected Right: %b)",
                 $time, aud_vld, lft_aud, rht_aud, lft_amp, rht_amp, exp_rht_amp);
        errors = errors + 1;
      end else begin
        $display("%t | %b | %d | %d | %b | %b | PASS",
                 $time, aud_vld, lft_aud, rht_aud, lft_amp, rht_amp);
      end
    end
  endtask

endmodule
