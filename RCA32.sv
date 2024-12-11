////////////////////////////////////////////////////////
// RCA32.sv  This design will add two 32-bit vectors //
// plus a carry in to produce a sum and a carry out //
/////////////////////////////////////////////////////
module RCA32(
  input 	[31:0]	A,B,	// two 32-bit vectors to be added
  input 			Cin,	// An optional carry in bit
  output 	[31:0]	S,		// 32-bit Sum
  output 			Cout  	// and carry out
);

	/////////////////////////////////////////////////
	// Declare any internal signals as type logic //
	///////////////////////////////////////////////
	wire [31:0] Carries;	// this is driven by .Cout of FA and will
							// in a "promoted" form drive .Cin of FA's
	
	/////////////////////////////////////////////////
	// Implement Full Adder as structural verilog //
	///////////////////////////////////////////////
	//<< You fill in vectored instantiation of 32 FA cells >>
	//<< Also remember a line to drive Cout of top level with Carries[31] >>

  genvar i;
  generate
    for (i = 0; i < 32; i = i + 1) begin : FA_Block
      if (i == 0) begin
        // First full adder takes Cin as the carry input
        FA FA_inst (
          .A(A[i]), 
          .B(B[i]), 
          .Cin(Cin), 
          .S(S[i]), 
          .Cout(Carries[1])   // First intermediate carry
        );
      end else if (i == 31) begin
        // Last full adder generates the final carry-out
        FA FA_inst (
          .A(A[i]), 
          .B(B[i]), 
          .Cin(Carries[i]), 
          .S(S[i]), 
          .Cout(Cout)   // Final carry-out
        );
      end else begin
        // Intermediate full adders
        FA FA_inst (
          .A(A[i]), 
          .B(B[i]), 
          .Cin(Carries[i]), 
          .S(S[i]), 
          .Cout(Carries[i + 1])   // Intermediate carries
        );
      end
    end
  endgenerate
	
endmodule