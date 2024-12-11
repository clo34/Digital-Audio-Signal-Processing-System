module cmp1bit(
  input 	A,				// incoming A-bit to compare
  input 	B,				// incoming B-bit to compare
  input 	AgtBi,			// bit below was greater
  input		AeqBi,			// bit below was equal
  input		AltBi,			// bit below was less
  output 	AgtBo,			// outgoing compare result
  output	AeqBo,			// outgoing compare result
  output  AltBo			// outgoing compare result
);

  //////////////////////////////////////////
  // Declare any needed internal signals //
  ////////////////////////////////////////
  wire not_A, not_B, Aeq_local;

  
  //////////////////////////////////////////////
  // Implement cmp1bit logic as structural   //
  // (placement of primitive gates) verilog //
  ///////////////////////////////////////////

  // NOT gates for A and B
  not u1(not_A, A);
  not u2(not_B, B);

  // Check if A == B
  xnor u3(Aeq_local, A, B);   // Aeq_local is 1 when A == B

  // Compute AeqBo
  and u7(AeqBo, AeqBi, Aeq_local);  // AeqBo = AeqBi & (A == B)


  // Compute AgtBo
  wire and1, and2;
  and u4(and1, A, not_B);           // A > B (A & ~B)
  and u5(and2, Aeq_local, AgtBi);       // propagate previous A > B when A == B
  or  u6(AgtBo, and1, and2);        // AgtBo = (A & ~B) | (AeqBi & AgtBi)


  // Compute AltBo
  wire and3, and4;
  and u8(and3, not_A, B);           // A < B (~A & B)
  and u9(and4, Aeq_local, AltBi);       // propagate previous A < B when A == B
  or  u10(AltBo, and3, and4);       // AltBo = (~A & B) | (AeqBi & AltBi)

endmodule  