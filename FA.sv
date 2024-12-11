///////////////////////////////////////////////////
// FA.sv  This design will take in 3 bits       //
// and add them to produce a sum and carry out //
////////////////////////////////////////////////
module FA(
  input 	A,B,Cin,	// three input bits to be added
  output	S,Cout		// Sum and carry out
);

	/////////////////////////////////////////////////
	// Declare any internal signals as type logic //
	///////////////////////////////////////////////
	logic a_and_b, a_and_cin, b_and_cin;	// internal signals declared as logic


	
	/////////////////////////////////////////////////
	// Implement Full Adder as structural verilog //
	///////////////////////////////////////////////
	xor xor0(xor_ab, A, B);	    		// First XOR: A XOR B
	and and0(and_ab, A, B);	        	// First AND gate: A AND B
	xor xor1(S, xor_ab, Cin);		// Second XOR: (A XOR B) XOR Cin
	and and1(and_xor_cin, xor_ab, Cin);	// Second AND gate: (A XOR B) AND Cin

	or or0(Cout, and_ab, and_xor_cin); 	// OR gate: Combine the outputs of the two AND gates
	
endmodule // full_adder