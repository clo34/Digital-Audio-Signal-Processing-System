module ampCalcAvg(clk,rst_n,aud_vld,lft_aud,rht_aud,lft_amp,rht_amp);

  ////////////////////////////////////////////////////////
  // This module selects the absolute value of either  //
  // left or right signed 16-bit audio signal and     //
  // then performs an exponential average of L=8.    //
  // This unsigned 15-bit average then converted    //
  // to a thermometer scale (instantiation of your //
  // mag2therm block) before being stored in a    //
  // register that drives the LED display of     //
  // music amplitude. A SM is the heart of this //
  // module that you have to implement.        //
  //////////////////////////////////////////////
  
  input clk;					// 50MHz clock
  input rst_n;					// asynch active low reset
  input aud_vld;				// indicates when new audio sample is valid
  input [15:0] lft_aud;			// left channel audio, already scaled in upsream
  input [15:0] rht_aud;			// right channel audio, already scaled in upsream
  output logic [8:0] lft_amp;	// left channel amplitude display
  output logic [8:0] rht_amp;	// right channel amplitude display
  
  wire [15:0] aud;			// selected left or right audio
  wire [14:0] mag;			// abs of selected audio signal
  wire [14:0] avg;			// average of selected audio signal
  wire [20:0] prod;			// accum*7, which accum depends on sel_lft
  wire [17:0] new_avg;  // new avg calculated by new audio sample
  wire [8:0] therm;			// computed thermometer code to write to reg

  reg [17:0] lft_accum;
  reg [17:0] rht_accum;
  
  ///////////////////////////////////////
  // Create enumerated type for state //
  /////////////////////////////////////  
  typedef enum reg [3:0] {LFT_ACCUM=4'b0001,LFT_UPDATE=4'b0010,RHT_ACCUM=4'b0100,
                          RHT_UPDATE=4'b1000} state_t;
  state_t nxt_state;		// create nxt_state of type state_t
  
  /////////////////////////////////////////////////
  // Declaraion of state and SM outputs as type logic //
  ///////////////////////////////////////////////
  logic [3:0] state;
  logic sel_lft;		// 1 => selecting left channel
  logic accum;			// 1 => update exponential average (either lft or rht)
  logic update;			// 1 => update output thermometer code 
   
  //////////////////////////////
  // Instantiate state flops //
  ////////////////////////////
  state4_reg iST(.clk(clk),.rst_n(rst_n),.nxt_state(nxt_state),.state(state));
   
  ////////////////////////////////////////////////////
  // Use dataflow to infer mux that selects aud to //
  // be lft_aud or right_aud based on sel_lft     // 
  // This is to time share the abs15from16 module//
  ////////////////////////////////////////////////
  assign aud = sel_lft ? lft_aud : rht_aud;
  // <<<<<<<<<<<< Your dataflow code to select right_aud or lft_aud based on sel_lft>>>>>>>>>>>
  
  ///////////////////////////////////////////////////////////////////////////////////
  // Instantiation of ABS block to calculate the absolute value of new audio signal//
  //////////////////////////////////////////////////////////////////////////////////
  abs15from16 iABS(.inSigned(aud), .outUnsigned(mag));
  
  ////////////////////////////////////////////////////////////////////////////////////////////
  // Form product of selected accumulator (lft_accum/rht_accum) time 7                     //
  // Use data flow verylog to implement the mux.                                          //
  // To calculate the product of (lft_accum times 7 ) you can use data flow operator *   //
  ////////////////////////////////////////////////////////////////////////////////////////
  assign prod = sel_lft ? (lft_accum * 7) : (rht_accum * 7);
  // <<<<<<<<<<<< Your code >>>>>>>>>>>

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////
  // Calculate the new average                                                                               //
  // new_average = [(lft_accum or rht_accum )* 7] >> 3 + [new absolute value of scaled audion sample(mag)]  //
  // you have already calculated (lft_accum or rht_accum )* 7], signal named prod
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////
  assign new_avg = (prod >> 3) + mag;
  // <<<<<<<<<<<< Your code >>>>>>>>>>>


  ///////////////////////////////////////////////////////////////////////
  // Instantiate two copies of accumReg18 to form lft_accum/rht_accum //
  // NOTES:                                                          //
  //    1. the enable will have to be a function of accum signal    //
  //       from SM and the sel_lft signal.                         //
  //    2. You input the new_avg to this accumulator              //
  /////////////////////////////////////////////////////////////////
  accumReg18 iACCMlft(
    // <<<<<<<<<<<< Your code >>>>>>>>>>>
    .clk(clk),
    .rst_n(rst_n),
    .en(accum & sel_lft),
    .newSum(new_avg),
    .accum(lft_accum) 
   );

  accumReg18 iACCMrht(
  // <<<<<<<<<<<< Your code >>>>>>>>>>>
  .clk(clk),
  .rst_n(rst_n),
  .en(accum & ~sel_lft),
  .newSum(new_avg),
  .accum(rht_accum) 
  ); 



  
  //////////////////////////////////////////////////////////////////
  // select either lft_accum/rht_accum as avg to drive mag2therm //
  // NOTES: you need to use 15 most significant bits            // 
  // This is to time share the mag2them module                 // 
  //////////////////////////////////////////////////////////////  
  assign avg = sel_lft ? lft_accum[17:3] : rht_accum[17:3]; 
  // <<<<<<<<<<<< Your code >>>>>>>>>>>



  
  
  /////////////////////////////////////////////////////////
  // compute thermometer code based on selected average //
  ///////////////////////////////////////////////////////
  mag2therm iMAG2THERM(.avg_mag(avg),.therm(therm));


  
  /////////////////////////////////////////////////////////////////////////
  // Instantiate two copies of ampReg9 which will drive LED amplitude   //
  // NOTE: the enable will have to be a function of "update" signal    //
  // from SM and the "sel_lft" signal.                                //
  // NOTE 2: You are allowed to update each register if that register//
  // if "update" is active and that register was selected (sel_lft).//                               //
  ///////////////////////////////////////////////////////////////////
  ampReg9 iAMPlft(
    // <<<< Your code >>>>>>
    .clk(clk),
    .rst_n(rst_n),
    .en(update & sel_lft),
    .newAmp(therm), 
    .amp(lft_amp)  
  );

  ampReg9 iAMPrht(
    // <<<< Your code >>>>>> 
    .clk(clk),
    .rst_n(rst_n), 
    .en(update & ~sel_lft),
    .newAmp(therm), 
    .amp(rht_amp)
  );


	  
  ////////////////////////////////////////////////////////////
  // Now for the "intellectual property" of the machine... //
  // Implement the state transition and output logic as   //
  // an always_comb block.                               //
  ////////////////////////////////////////////////////////
  always_comb begin
    /// Default nxt_state and SM outputs ///
	/// (OK...nxt_state defaulting done for you) ///
    nxt_state = state_t'(state);		// nxt_state defaulted to stay in current state      

  // <<<<<<<<<<<<< default signals go here >>>>>>>>>>>
  sel_lft = 0;
  accum = 0;
  update = 0;
	
	case(state)

	  LFT_ACCUM : begin
	    // <<<< Do your magic here>>>>>>>
      sel_lft = 1;
      if (aud_vld)
        accum = 1;
        nxt_state = LFT_UPDATE;
      if(!aud_vld)
        nxt_state = LFT_ACCUM;
	  end

	  LFT_UPDATE : begin
	    // <<<< Do your magic here>>>>>>>
      sel_lft = 1;
      update = 1;
      nxt_state = RHT_ACCUM;
	  end	  

	  RHT_ACCUM : begin
		  // <<<< Do your magic here>>>>>>>
      accum = 1; 
      nxt_state = RHT_UPDATE;
	  end

	  RHT_UPDATE : begin
      // <<<< Do your magic here>>>>>>>
      update = 1;
      nxt_state = LFT_ACCUM;
	  end	

	endcase
  end
  
endmodule