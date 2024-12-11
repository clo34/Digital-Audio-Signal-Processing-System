//////////////////////////////////////////////////////////
// Forms a 4-bit state register that will be one hot.  //
// Meaning it needs to aynchronously reset to 4'b0001 //
//                                                   //
// Student 1 Name: << Charles Lo >>                 //
// Student 2 Name: << Katherine Shieh >>           //
////////////////////////////////////////////////////
module state4_reg(
  input clk,				// clock
  input rst_n,				// asynchronous active low reset
  input [3:0] nxt_state,	// forms next state (i.e. goes to D input of FFs)
  output [3:0] state		// output (current state)
);
  
  ////////////////////////////////////////////////////
  // Declare any needed internal signals.  Due to  //
  // all bits except LSB needed to reset, and the //
  // LSB needing to preset you will need to form //
  // two 4-bit vectors to hook to CLRN and PRN  //
  ///////////////////////////////////////////////
  wire [3:0] CLRN_vec;
  wire [3:0] PRN_vec;
  
  ///////////////////////////////////////////////////////////
  // The two 3-bit vectors for CLRN & PRN are formed with //
  // vector concatenation of a mix of CLRN and 1'b1      //
  ////////////////////////////////////////////////////////
  assign CLRN_vec = {rst_n, rst_n, rst_n, 1'b1};
  assign PRN_vec =  {1'b1, 1'b1, 1'b1, rst_n};
  
  ////////////////////////////////////////////////////////
  // instantiate 3 d_ff as a vector to implement state //
  //////////////////////////////////////////////////////
  d_ff state_ff [3:0] (
    .clk(clk),
    .D(nxt_state),
    .CLRN(CLRN_vec),
    .PRN(PRN_vec),
    .Q(state)
  );
  
endmodule