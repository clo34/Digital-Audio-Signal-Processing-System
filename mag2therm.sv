module mag2therm(avg_mag,therm);

  input [14:0] avg_mag;		// incoming 15-bit magnitude of selected average
  output [8:0] therm;		// 9-bit thermometer code of incoming magnitude
  
  //////////////////////////////////////////////////////
  // Each successive LED from LSB to MSB driven when //
  // magnitude exceeds an increasing threshold.     //
  ///////////////////////////////////////////////////
  mag15 iLED0(.A(avg_mag),.B(15'h017F),.AgtB(therm[0]),.AeqB(),.AltB());
  mag15 iLED1(.A(avg_mag),.B(15'h057F),.AgtB(therm[1]),.AeqB(),.AltB());
  mag15 iLED2(.A(avg_mag),.B(15'h0B7F),.AgtB(therm[2]),.AeqB(),.AltB());
  mag15 iLED3(.A(avg_mag),.B(15'h147F),.AgtB(therm[3]),.AeqB(),.AltB());
  mag15 iLED4(.A(avg_mag),.B(15'h1FFF),.AgtB(therm[4]),.AeqB(),.AltB());
  mag15 iLED5(.A(avg_mag),.B(15'h2DFF),.AgtB(therm[5]),.AeqB(),.AltB());
  mag15 iLED6(.A(avg_mag),.B(15'h3E7F),.AgtB(therm[6]),.AeqB(),.AltB());
  mag15 iLED7(.A(avg_mag),.B(15'h507F),.AgtB(therm[7]),.AeqB(),.AltB());
  mag15 iLED8(.A(avg_mag),.B(15'h66FF),.AgtB(therm[8]),.AeqB(),.AltB());
					 
endmodule