module volReg(clk,rst_n,step_up,step_dwn,volume12);

  input clk;						// 50MHz clock
  input rst_n;						// asynch active low reset
  input step_up;					// step volume up by STEP
  input step_dwn;					// step volume down by STEP
  output logic [11:0] volume12;		// 12-bit unsigned volume register 199% to 0%
  
  localparam STEP = 12'h040;
  
  //////////////////////////////////////////////////
  // This register needs to reset to 0x800 which //
  // represents nominal (100%) volume.  It can  //
  // increment or decrement by a STEP amount   //
  // depending on signals step_up & step_dwn. //
  // use datafow verilog!                    //
  ////////////////////////////////////////////







  /////////////////////////////////////////////////////////////
  // instantiate 12 d_en_ff as a vector to implement volReg //
  ///////////////////////////////////////////////////////////




endmodule