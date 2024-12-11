module ampReg9(
  input clk,				// clock
  input rst_n,				// asynch active low reset
  input en,					// enable (if asserted accum <= newSum)
  input [8:0] newAmp,		// new value accumulator takes if enabled
  output [8:0] amp			// output of register
);
  
  
  /////////////////////////////////////////////////////////////
  // instantiate 9 d_en_ff as a vector to implement ampReg9 //
  ///////////////////////////////////////////////////////////
  d_en_ff iDFF[8:0] (.clk(clk), .D(newAmp), .CLRN(rst_n),
                      .EN(en), .Q(amp));
  
endmodule