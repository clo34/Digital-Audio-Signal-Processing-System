module AHW2(SW,KEY0,LEDR,HEX0,HEX3,LEDG);

  input [17:0] SW;			// slide switches [17:14] & [3:0] used
  input KEY0;				// ~inc (inverse of inc) for testing inc4EnComb
  output [17:0] LEDR;		// Red LEDs above swithes
  output [6:0] HEX0;		// from bcd7seg driven by SW[3:0] connected to "HEX0" display
  output [6:0] HEX3;		// from bcd7seg driven by SW[17:14] connected to HEX3
  output [7:0] LEDG;		// the greed LEDs
  
  ////////////////////////////////////////////////////////
  // instantiate bcd7seg drivers for HEX0 HEX3 display //
  //////////////////////////////////////////////////////
  bcd7seg iBCD0(.num(SW[3:0]),.seg(HEX0));
  bcd7seg iBCD3(.num(SW[17:14]),.seg(HEX3));
  
  ////////////////////////
  // Instantiate mag15 //
  //////////////////////
  mag15 iMAG(.A({SW[3:0],11'h000}),.B({SW[17:14],11'h000}),.AgtB(LEDG[7]),
             .AeqB(LEDG[6]),.AltB(LEDG[5]));

  /////////////////////////////
  // Instantiate inc4EnComb //
  ///////////////////////////
  inc4EnComb iINC(.cnt(SW[3:0]),.inc(~KEY0),.nxt_cnt(LEDG[3:0]));
 
endmodule
  
  