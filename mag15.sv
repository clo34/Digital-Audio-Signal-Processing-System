module mag15(
  input [14:0] A,	// number to compare
  input [14:0] B,	// number to compare
  output AgtB,		// A>B
  output AeqB,		// A==B
  output AltB		// A<B
);

  ////////////////////////////////////////////////////////////
  // Connections from AgtBo --> AgtBi, etc. made by vector //
  //////////////////////////////////////////////////////////
  logic [14:0] gt_vec;	// used to interconnect the gt sigs
  logic [14:0] eq_vec;	// used to interconnect the eq sigs
  logic [14:0] lt_vec;	// used to interconnect the lt sigs
  
  ///////////////////////////////////////
  // Instantiate 16-copies of cmp1bit //
  /////////////////////////////////////
  cmp1bit iCMP[14:0] (
    .A(A), 
    .B(B), 
    .AgtBi({gt_vec[13:0], 1'b0}),   // Initialize first comparator's greater input to 0
    .AeqBi({eq_vec[13:0], 1'b1}),   // Initialize first comparator's equal input to 1 (assume initial equality)
    .AltBi({lt_vec[13:0], 1'b0}),   // Initialize first comparator's less input to 0
    .AgtBo(gt_vec), 
    .AeqBo(eq_vec), 
    .AltBo(lt_vec)
  );
          
  assign AgtB = gt_vec[14];  // The result from the most significant bit
  assign AeqB = eq_vec[14];  // The result from the most significant bit
  assign AltB = lt_vec[14];  // The result from the most significant bit

endmodule