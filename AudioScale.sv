module AudioScale(volumeBin12,lft_in,rht_in,lft_out,rht_out,volumeDec8);

  input signed [15:0] lft_in;
  input signed [15:0] rht_in;
  input [11:0] volumeBin12;			// 12-bit volume scaling register
  output reg [15:0] lft_out;
  output reg [15:0] rht_out;
  output [7:0] volumeDec8;			// volume display for silly 10 fingered humans
  
  wire signed [27:0] prod_lft;		// intermediate of scaling.
  wire signed [27:0] prod_rht;		// intermediate of scaling.
  wire [18:0] vol_prod;				// intermediate of decimal calc
  
  ///////////////////////////
  // Scale by volumeBin12 //
  /////////////////////////
  assign prod_lft = lft_in*$signed({1'b0,volumeBin12});
  assign prod_rht = rht_in*$signed({1'b0,volumeBin12});

  /////////////////////
  // Divide by 2048 //
  ///////////////////////////////////////////////////////////////
  // Overflow is possible here, but just turn down the volume //
  /////////////////////////////////////////////////////////////
  assign lft_out = prod_lft[26:11];	// div by 2048
  assign rht_out = prod_rht[26:11];	// div by 2048
  
  ////////////////////////////////
  // Scale for decimal display //
  //////////////////////////////
  assign vol_prod = volumeBin12*7'd100;
  assign volumeDec8 = vol_prod[18:11];	// div by 2048
  
endmodule