// note that this is NOT a program - it is a hardware description that gets turned into logic!

module segFdec
(
	input [3:0] D,
	output segF
);

/// You figure out implementation as instances of verilog primitive gates ///
  wire not_D3, not_D2, and1, and2, and3;

// Logic for active-low segment F
  // NOT gates
  not u1(not_D2, D[2]);
  not u2(not_D3, D[3]);

  // AND gates
  and u3(and1, D[1], D[0]);            // D1 * D0
  and u4(and2, not_D2, D[1]);          // !D2 * D1
  and u5(and3, not_D3, not_D2, D[0]);  // !D3 * !D2 * D0

  // OR gate for the final output
  or u6(segF, and1, and2, and3);

endmodule
