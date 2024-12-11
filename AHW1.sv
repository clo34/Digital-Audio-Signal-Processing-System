module AHW1(
  input		[17:0] SW,		// 18 slide switches on board
  input		[3:0] KEY,		// hooked to the 4 push buttons
  output 	[17:0] LEDR,	// 18 red LEDs
  output	[7:0] LEDG		// 8 green LEDs
);

  ///////////////////////////////////////////////////////////////////
  // Instantiate your RCA4 block and make appropriate connections //
  /////////////////////////////////////////////////////////////////
  wire [3:0] A, B;       // 4-bit vectors for RCA4 inputs
  wire Cin;              // Carry-in for RCA4
  wire [3:0] S;          // 4-bit sum output from RCA4
  wire Cout;             // Carry-out from RCA4

  // Map switches to RCA4 inputs
  assign A = SW[17:14];  // A[3:0] mapped to SW[17:14]
  assign B = SW[3:0];    // B[3:0] mapped to SW[3:0]
  assign Cin = ~KEY[0];  // Cin mapped to KEY[0] (active low)

  RCA4 rca4_inst (
    .A(A),
    .B(B),
    .Cin(Cin),
    .S(S),
    .Cout(Cout)
  );

  ////////////////////////////////////////////////////////////////////
  // Need a couple of assign statements below to have LEDR[17:14]  //
  // represent SW[17:14] and LEDR[3:0] represent SW[3:0].         //
  /////////////////////////////////////////////////////////////////
  assign LEDR[3:0] = SW[3:0];   // Reflect state of SW[3:0] on LEDR[3:0]
  assign LEDR[17:14] = SW[17:14]; // Reflect state of SW[17:14] on LEDR[17:14]
  assign LEDG[3:0] = S;         // Sum output on green LEDs [3:0]
  assign LEDG[7] = Cout;        // Carry-out on LEDG[7]
				
  
endmodule
