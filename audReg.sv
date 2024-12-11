module audReg(clk,rst_n,smpl,aud_raw,aud_smpld);

  input clk;				// 50MHz clock
  input rst_n;				// asynch active low reset
  input smpl;				// indicates when to sample (enable to flop)
  input [15:0] aud_raw;		// aud_raw (raw audio value to sample)
  output logic [15:0] aud_smpld;	// sampled audio value

  always_ff @(posedge clk, negedge rst_n)
    if (!rst_n)
	  aud_smpld <= 16'h0000;
	else if (smpl)
	  aud_smpld <= aud_raw;
	  
endmodule
