module accumReg18(
  input clk,				// clock
  input rst_n,				// asynch active low reset
  input en,					// enable (if asserted accum <= newSum)
  input [17:0] newSum,		// new value accumulator takes if enabled
  output [17:0] accum		// output of accumulator
);
  
  
  /////////////////////////////////////////////////////////////////
  // instantiate 18 d_en_ff as a vector to implement accumReg18 //
  ///////////////////////////////////////////////////////////////
  genvar i;
  generate
    for (i = 0; i < 18; i = i + 1) begin : accum_ff_gen
      d_en_ff u_dff (
        .clk(clk),
        .D(newSum[i]),
        .CLRN(rst_n),
        .EN(en),
        .Q(accum[i])
      );
    end
  endgenerate
  
endmodule