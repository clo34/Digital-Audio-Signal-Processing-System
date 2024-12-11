module cmdROM(clk,cmd_indx,cmd);

  input clk;				// system clock (ROM takes one clk to access)
  input [3:0] cmd_indx;		// address of command to access
  output logic [15:0] cmd;		// initialization command to be sent
  
  logic [15:0] nxt_cmd;
  
  always_comb
    case (cmd_indx)
	  4'h0 : nxt_cmd = 16'h011F;	// write to lft or rght is write to both, lft not muted
	  4'h1 : nxt_cmd = 16'h031F;	// write to rght or lft is write to both, rght not muted
	  4'h2 : nxt_cmd = 16'h0465;	// Cut down left output gain
	  4'h3 : nxt_cmd = 16'h0665;	// Cut down right output gain
	  4'h4 : nxt_cmd = 16'h0812;	// Not bypassed, line in not microphone
	  4'h5 : nxt_cmd = 16'h0A16;	// 48kHz deemphasis, soft mute disabled, high pass enabled
	  4'h6 : nxt_cmd = 16'h0C62;	// MIC, OSC, and CLKOUT only things powered down
	  4'h7 : nxt_cmd = 16'h0E01;	// 16-bits, Left justified, no inv of cntrls
	  default : nxt_cmd = 16'h1201;	// turn it on
	endcase
	
  always_ff @(posedge clk)
    cmd <= nxt_cmd;
	
endmodule