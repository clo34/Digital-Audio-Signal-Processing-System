module inc4EnComb(
  input [3:0] cnt,	// current value of count
  input inc,		// if asserted cnt gets incremented
  output [3:0] nxt_cnt
  );
  
  ///////////////////////////////////
  // declare intermediate signals //
  /////////////////////////////////
  
  logic C0, C1, C2, C3;
  
  ////////////////////////////////////////
  // Implement with structural verilog //
  // using instantiations of FA, and  //
  // verilog primitive gates         //
  ////////////////////////////////////
  
  // Full Adder for cnt[0]
  xor u1(nxt_cnt[0], cnt[0], inc);  // Sum for the LSB
  and u2(C0, cnt[0], inc);          // Carry-out from LSB

  // Full Adder for cnt[1]
  xor u3(sum1, cnt[1], C0);         // Intermediate sum for the second bit
  xor u4(nxt_cnt[1], sum1, 1'b0);   // Sum for the second bit
  and u5(and1, cnt[1], C0);         // Carry between cnt[1] and C0
  and u6(and2, C0, 1'b0);           // Dummy carry (1'b0 doesn't contribute)
  or  u7(C1, and1, and2);           // Final carry-out for the second bit

  // Full Adder for cnt[2]
  xor u8(sum2, cnt[2], C1);         // Intermediate sum for the third bit
  xor u9(nxt_cnt[2], sum2, 1'b0);   // Sum for the third bit
  and u10(and3, cnt[2], C1);        // Carry between cnt[2] and C1
  and u11(and4, C1, 1'b0);          // Dummy carry (1'b0 doesn't contribute)
  or  u12(C2, and3, and4);          // Final carry-out for the third bit

  // Full Adder for cnt[3]
  xor u13(sum3, cnt[3], C2);        // Intermediate sum for the fourth bit
  xor u14(nxt_cnt[3], sum3, 1'b0);  // Sum for the fourth bit
  and u15(and5, cnt[3], C2);        // Carry between cnt[3] and C2
  and u16(and6, C2, 1'b0);          // Dummy carry (1'b0 doesn't contribute)
  or  u17(C3, and5, and6);          // Final carry-out for the fourth bit (unused)
  
endmodule