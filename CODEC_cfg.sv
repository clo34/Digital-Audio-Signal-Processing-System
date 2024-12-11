 module CODEC_cfg(clk,rst_n,SDA,SCL);
           
  input clk, rst_n;

  output SCL;     // I2C clock
  inout SDA;      // I2C data

  //////////////////////////////////////
  // Outputs of SM are of type logic //
  ////////////////////////////////////
  logic wrt;          // wrt strobe to inertial sensor used during initialization
  
	
  wire done;          // I2C transaction done

  ///////////////////////////////
  // declare internal signals //
  /////////////////////////////
  logic [2:0] state;
  logic [3:0] cmd_indx;     // what initialization command to send
  logic [15:0] cmd;       // initialization command to send (from ROM)
  
  ///////////////////////////////////////
  // Create enumerated type for state //
  /////////////////////////////////////
  typedef enum reg [2:0] {POR=3'b001,WAIT_SENT=3'b010,DONE=3'b100} state_t;
  
  /////////////////////////////
  // declare nxt_state type //
  /////////////////////////// 
  state_t nxt_state;
  
  /////////////////////////////
  // Instantiate I2C Master //
  ///////////////////////////
  I2C24Wrt iI2C24Wrt(.clk(clk),.rst_n(rst_n),.data16(cmd),.wrt(wrt),.done(done),
           .err(err),.SCL(SCL),.SDA(SDA));
          

  
  //////////////////////////////
  // Instantiate state flops //
  ////////////////////////////
  state3_reg iST(.clk(clk),.rst_n(rst_n),.nxt_state(nxt_state),.state(state));
    
  ///////////////////////////////
  // Instantiate 18-bit timer //
  /////////////////////////////
  tmr18 iTMR(.clk(clk),.rst_n(rst_n),.tmr_ovr(tmr_ovr));
  
  /////////////////////////////////////////////
  // Instantiate 4-bit init command counter //
  ///////////////////////////////////////////
  cmdCnt4 iINIT_STEP(.clk(clk),.rst_n(rst_n),.inc(wrt),.cnt(cmd_indx));
  
  ///////////////////////////////////
  // Instantiate Init Command ROM //
  /////////////////////////////////
  cmdROM iROM(.clk(clk),.cmd_indx(cmd_indx),.cmd(cmd));  
  
  
  always_comb begin
    /// Default nxt_state and SM outputs ///
  /// (OK...nxt_state defaulting done for you) ///
  nxt_state = state_t'(state);    // nxt_state defaulted to stay in current state      
  
  //<< default all outputs of SM >>
	assign wrt = ((tmr_ovr == 1'b1) && (state != DONE) && (cmd_indx < 4'h9)) ? 1'b1 : 1'b0;

	
  case (state)
		POR : begin
		//<< your magic occurs here >>			
			if ((tmr_ovr == 1'b1) && (cmd_indx < 4'h9)) begin
				nxt_state = WAIT_SENT;
			end
		end
		WAIT_SENT : begin
		//<< your magic occurs here >>
			assign iI2C24Wrt.done = 1'b1;
			if (cmd_indx == 4'h9) begin
				nxt_state = DONE;
			end
		end
		default : begin      // Same as DONE
			nxt_state = POR;
		end
		endcase
  end
 
endmodule
    