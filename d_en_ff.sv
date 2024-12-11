////////////////////////////////////////////////////////
// d_en_ff.sv: Models a FF with active high enable   //
//                                                  //
// Student 1 Name: << Charles Lo >>                //
// Student 2 Name: << Katherine Shieh >>          //
///////////////////////////////////////////////////
module d_en_ff(
  input clk,
  input D,			// D input to be flopped
  input CLRN,		// asynch active low clear (reset)
  input EN,			// enable signal
  output logic Q
);

  ////////////////////////////////////////////////////
  // Declare any needed internal sigals below here //
  //////////////////////////////////////////////////
  logic D_mux;
  
  ///////////////////////////////////////////////////
  // Infer logic needed to feed D input of simple //
  // flop to form an enabled flop (use dataflow) //
  ////////////////////////////////////////////////
  assign D_mux = EN ? D : Q;
  
  //////////////////////////////////////////////
  // Instantiate simple d_ff without enable  //
  // and tie PRN inactive.  Connect D input //    
  // to logic you inferred above.          //
  //////////////////////////////////////////
  d_ff u_ff(
    .clk(clk),
    .D(D_mux),
    .CLRN(CLRN),
    .PRN(1'b1),
    .Q(Q)
  );
  

endmodule
