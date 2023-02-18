`ifndef TBS
`define TBS 1
package tbs;

// task which drives six consecutive 7=segment displays
// $display performs a return / new line feed; $write does not
task display_tb(
   input[6:0] seg_d,
              seg_e, seg_f,
              seg_g, seg_h, seg_i
   );

   begin
   // segment A
      if(~seg_d[ 0 ]) $write(" _ ");
      else         $write("   ");
      $write(" ");

      if(~seg_e[ 0 ]) $write(" _ ");
      else         $write("   ");
      $write("  ");

      if(~seg_f[ 0 ]) $write(" _ ");
      else         $write("   ");
      $write(" ");

      if(~seg_g[ 0 ]) $write(" _ ");
      else         $write("   ");
      $write("  ");

      if(~seg_h[ 0 ]) $write(" _ ");
      else         $write("   ");
      $write(" ");

      if(~seg_i[ 0 ]) $write(" _ ");
      else         $write("   ");
      $display();

 // segments FGB
     if(~seg_d[ 5 ]) $write("|");
     else $write(" ");

     if(~seg_d[ 6 ]) $write("_");
     else $write(" ");

     if(~seg_d[ 1 ]) $write("|");
     else $write(" ");
         $write(" ");

     if(~seg_e[ 5 ]) $write("|");
     else $write(" ");

     if(~seg_e[ 6 ]) $write("_");
     else $write(" ");

     if(~seg_e[ 1 ]) $write("|");
     else $write(" ");
     $write("  ");

     if(~seg_f[ 5 ]) $write("|");
     else $write(" ");

     if(~seg_f[ 6 ]) $write("_");
     else $write(" ");

     if(~seg_f[ 1 ]) $write("|");
     else $write(" ");
     $write(" ");

     if(~seg_g[ 5 ]) $write("|");
     else $write(" ");

     if(~seg_g[ 6 ]) $write("_");
     else $write(" ");

     if(~seg_g[ 1 ]) $write("|");
     else $write(" ");
     $write("  ");

     if(~seg_h[ 5 ]) $write("|");
     else $write(" ");

     if(~seg_h[ 6 ]) $write("_");
     else $write(" ");

     if(~seg_h[ 1 ]) $write("|");
     else $write(" ");
     $write(" ");

     if(~seg_i[ 5 ]) $write("|");
     else $write(" ");

     if(~seg_i[ 6 ]) $write("_");
     else $write(" ");

     if(~seg_i[ 1 ]) $write("|");
     else $write(" ");
     $display();

  // segments EDC
     if(~seg_d[ 4 ]) $write("|");
     else $write(" ");

     if(~seg_d[3]) $write("_");
     else $write(" ");

     if(~seg_d[ 2 ]) $write("|");
     else $write(" ");
     $write(" ");

     if(~seg_e[ 4 ]) $write("|");
     else $write(" ");

     if(~seg_e[3]) $write("_");
     else $write(" ");

     if(~seg_e[ 2 ]) $write("|");
     else $write(" ");
     $write("  ");

     if(~seg_f[ 4 ]) $write("|");
     else $write(" ");

     if(~seg_f[3]) $write("_");
     else $write(" ");

     if(~seg_f[ 2 ]) $write("|");
     else $write(" ");
     $write(" ");

     if(~seg_g[ 4 ]) $write("|");
     else $write(" ");

     if(~seg_g[3]) $write("_");
     else $write(" ");
     if(~seg_g[ 2 ]) $write("|");
     else $write(" ");
     $write("  ");

     if(~seg_h[ 4 ]) $write("|");
     else $write(" ");

     if(~seg_h[3]) $write("_");
     else $write(" ");

     if(~seg_h[ 2 ]) $write("|");
     else $write(" ");
     $write(" ");

     if(~seg_i[ 4 ]) $write("|");
     else $write(" ");

     if(~seg_i[3]) $write("_");
     else $write(" ");

     if(~seg_i[ 2 ]) $write("|");
     else $write(" ");
     $display();
  end
endtask

   
typedef enum {CORRECT, BADINPUT, TIMEOUT} user_t;

   // convert seven segment control wires for a
   // hexadecimal digit
   // to its ordinal value (hex)
   //
   function bit [4:0] Seven2Bin(logic [6:0] hexSeg);
      begin
	 logic [4:0] val;
	 case (hexSeg)
	   7'b100_0000: val = 5'b0_0000; // 0
	   7'b111_1001: val = 5'b0_0001; // 1
	   7'b010_0100: val = 5'b0_0010; // 2        
	   7'b011_0000: val = 5'b0_0011; // 3         
	   7'b001_1001: val = 5'b0_0100; // 4        
	   7'b001_0010: val = 5'b0_0101; // 5         
	   7'b000_0010: val = 5'b0_0110; // 6        
	   7'b111_1000: val = 5'b0_0111; // 7        
	   7'b000_0000: val = 5'b0_1000; // 8        
	   7'b001_1000: val = 5'b0_1001; // 9        
	   7'b000_1000: val = 5'b0_1010; // a        
	   7'b000_0011: val = 5'b0_1011; // b        
	   7'b100_0110: val = 5'b0_1100; // C        
	   7'b010_0001: val = 5'b0_1101; // d        
	   7'b000_0110: val = 5'b0_1110; // E        
	   7'b010_1110: val = 5'b0_1111; // F        
	   default: val = 5'b1_0000;
	 endcase
	 return val;
      end
   endfunction

   function integer getNum(input logic [6:0] D1, D0);
      begin
	 integer low;
	 low = Seven2Bin(D0);
	 return (Seven2Bin(D1)*16 + low);
      end
   endfunction
	 

`define CYCLE #20
   // -------------------------------
   //
   // polynomial counter
   // generates one-hot 4-bit sequence
   //
   class PolyRng;
      bit [7:0] val;
      bit [7:0] taps;
      bit [7:0] newVal;
      bit [7:0] initSeed;

      // constructor
      function new (bit [7:0] initSeed = 8'b1, bit [7:0] setTaps);
	 val = initSeed;
	 taps = setTaps;
	 this.initSeed = initSeed;
      endfunction

      // advance counter
      function void Next();
	 bit    inp;
	 inp = ^(taps & val);
	 val = {val[6:0], inp};
      endfunction

      // get a random 2 bit number
      function bit [3:0] getRnd();
	 bit [3:0] rndLed;
	 rndLed = {val[4] & val[2], val[4] & ~val[2], ~val[4] & val[2], ~val[4] & ~val[2]};
	 return rndLed;
      endfunction // getRnd

      // get the wrong random 2 bit number
      function bit [3:0] getWrongRnd();
	 bit [3:0] rndLed;
	 rndLed = {val[4] & ~val[2], ~val[4] & val[2], val[4] & ~val[2], val[4] & val[2]};
	 return rndLed;
      endfunction
      // reinitalize the sequence
      function void Reset();
	 val = initSeed;
      endfunction

   endclass

   // -------------------------------
   //
   // checker class 
   //
   class Checkit;
      
      logic [9:0] oldLEDs;    // previous value of dutLEDs
      bit 	  timeOut = 0;
      
      PolyRng poly = new(
			 8'b1, // temp  Seed
			 8'b10111000);
      
      
      function new ();
      endfunction // new
      
      function void startUser;
	 poly.Reset();
      endfunction

      function string getLEDstr(input logic [9:0] v);
	 begin
	    string outStr = "";
	    for (int i=9; i>=0; i--) begin
	       outStr = v[i] ? {outStr, "# "} : {outStr, "_ "};
	    end
	    outStr = outStr.substr(0, outStr.len()-2);
	    outStr = {"[", outStr, "]"};
	    
	    return outStr;
	 end
      endfunction

      //
      // wait for change in LEDs
      //
      task waitForLEDChange(ref logic [9:0] dutLEDs, ref logic clk, ref integer simCycle);
	begin
	   bit timedOut = 1;
	   oldLEDs = dutLEDs;
	   for (int i=0; i<10; i++) begin
	      if (dutLEDs != oldLEDs) begin
		 timedOut = 0;
		 break;
	      end
	      @(posedge clk);
	   end
	   assert(timedOut == 0)
	     else
	       $display("%d: Failed waiting for change dutLEDs = %s", simCycle, getLEDstr(dutLEDs));
	end
      endtask

      //
      // check that all LEDs flash ON
      //
      task checkPlayLEDFlash(
			     ref logic [9:0] dutLEDs, 
			     ref logic 	     clk, ref integer simCycle, input integer seqLength);
	 begin
	    assert(dutLEDs == 10'h1ff)
	      $display("%d: %d: Pass ExpectFlash %s(exp) = %s(got)", simCycle, seqLength, 
		       getLEDstr(10'b01_1111_1111),
		       getLEDstr(dutLEDs));
	    else
	      $display("%d: %d: Fail ExpectFlash %s(exp) = %s(got)", simCycle, seqLength, 
		       getLEDstr(10'b01_1111_1111),
		       getLEDstr(dutLEDs));
	 end
      endtask

      //
      // check that play light and all else are blank
      //
      task checkPlayLEDBlank(
			     ref logic [9:0] dutLEDs, 
			     ref logic 	     clk, ref integer simCycle, input integer seqLength);

	 begin
	    assert(dutLEDs == 10'b00_0000_0000)
	      $display("%d: %d: Pass ExpectBlank %s = %s", simCycle, 
		       seqLength,
		       getLEDstr(10'b00_0000_0000), 
		       getLEDstr(dutLEDs));
	    else
	      $display("%d: %d: Fail ExpectBlank %s(exp) = %s(got)", simCycle, 
		       seqLength,
		       getLEDstr(10'b00_0000_0000), 
		       getLEDstr(dutLEDs));
	 end
      endtask


      //
      // check that play light is on and only the correct sequence light
      //
      task checkPlayLEDOne(
			   ref logic [9:0] dutLEDs, 
			   ref logic 	   clk, ref integer simCycle, input integer seqLength);
	 begin
	    assert(dutLEDs[9] == 1'b0)
	      else
		$display("%d: %d: Fail ExpectOne LED[9] %b(exp) = %b(got)", simCycle, 
			 seqLength,
			       1'b0, dutLEDs[9]);
	    assert(dutLEDs[3:0] == poly.getRnd())
	      $display("%d: %d: Pass ExpectOne   %s = %s", simCycle, 
		       seqLength,
		       getLEDstr({6'b00_0000, poly.getRnd()}), getLEDstr(dutLEDs));
	    else
	      $display("%d: %d: Fail ExpectOne %s(exp) = %s (got)",
		       simCycle, 
		       seqLength,
		       getLEDstr({6'b00_0000, poly.getRnd()}), getLEDstr(dutLEDs));
	 end
      endtask

      //
      // check the play (demonstrate) phase
      // starts with flash of lights
      //
      task checkPlay(
			ref logic [9:0] dutLEDs, 
		        ref logic [6:0] HEX5, HEX4, HEX3, HEX1, HEX0,
			ref logic 	clk, ref integer simCycle, 
			input integer 	seqLength);
	 @(posedge clk) #2;
	 poly.Reset();
	 checkPlayLEDFlash(dutLEDs, clk, simCycle, seqLength);
	 display_tb(.seg_d(HEX5), .seg_e(HEX4), .seg_f(HEX3),
		    .seg_g(7'h7f), .seg_h(HEX1), .seg_i(HEX0));
	 waitForLEDChange(dutLEDs, clk, simCycle);



	 checkPlayLEDBlank(dutLEDs, clk, simCycle, seqLength);
	 display_tb(.seg_d(HEX5), .seg_e(HEX4), .seg_f(HEX3),
		    .seg_g(7'h7f), .seg_h(HEX1), .seg_i(HEX0));
	 waitForLEDChange(dutLEDs, clk, simCycle);

	 for (int i=0; i<seqLength; i++) begin
	    checkPlayLEDOne(dutLEDs, clk, simCycle, seqLength);
	    assert (getNum(HEX1, HEX0)   == i) begin
	       $display("%d: %d: Pass Seq # exp(%02x)  got(%02x)", simCycle, seqLength, i, getNum(HEX1, HEX0));
	    end
	    else begin
	       $display("Fail %d: %d: seq # exp(%02x)  got(%02x)", simCycle, seqLength, i, getNum(HEX1, HEX0));
	       display_tb(.seg_d(HEX5), .seg_e(HEX4), .seg_f(HEX3),
			  .seg_g(7'h7f), .seg_h(HEX1), .seg_i(HEX0));
	    end
	      
	    waitForLEDChange(dutLEDs, clk, simCycle);

	    checkPlayLEDBlank(dutLEDs, clk, simCycle, seqLength);
	    assert (getNum(HEX1, HEX0)   == (i+1)) begin
	       $display("%d: %d: Pass seq # exp(%02x)  got(%02x)", simCycle, seqLength, i+1, getNum(HEX1, HEX0));
	    end
	    else begin
	       $display("%d: %d: Fail seq # exp(%02x)  got(%02x)", simCycle, seqLength, i+1, getNum(HEX1, HEX0));
	       display_tb(.seg_d(HEX5), .seg_e(HEX4), .seg_f(HEX3),
			  .seg_g(7'h7f), .seg_h(HEX1), .seg_i(HEX0));
	    end

	    waitForLEDChange(dutLEDs, clk, simCycle);

	    poly.Next();
	 end
      endtask

      //
      // check the user's LEDs
      //
      // if correct set, provide the correct answer
      // 
      task checkUserLED(
			ref logic [9:0] LEDR,
		        ref logic [6:0] HEX5, HEX4, HEX3, HEX1, HEX0,
			ref logic 	clk,
			ref integer 	simCycle,
			ref logic [9:0] SW,
			input integer 	seqCnt,
			input integer 	seqLength,
			input 		user_t response);
	 
	 begin
	    SW = 10'b0;
	    @(posedge clk);
	    SW[3:0] = response == CORRECT ? poly.getRnd() : 
		      response == BADINPUT ? poly.getWrongRnd() :
		      4'b0000;  // no response
	    @(posedge clk);
	    assert((SW[3:0] == LEDR[3:0]) && (LEDR[9] == 1'b1))
	      $display("%d: %d: Pass checkUser LEDs %s(exp) = %s(got)", 
		       simCycle,
		       seqLength,
		       getLEDstr({6'b10_0000, SW[3:0]}), getLEDstr(LEDR[9:0]));
	    else
	      $display("%d: %d: Fail checkUser LEDs %s(exp) = %s(got)", 
		       simCycle,
		       seqLength,
		       getLEDstr({6'b10_0000, SW[3:0]}), getLEDstr(LEDR[9:0]));

	    assert (getNum(HEX1, HEX0)   == (seqCnt)) begin
	       $display("%d: %d: Pass seq # exp(%02x)  got(%02x)", simCycle, seqLength, seqCnt, getNum(HEX1, HEX0));
	    end
	    else begin
	       $display("%d: %d: Fail seq # exp(%02x)  got(%02x)", simCycle, seqLength, seqCnt, getNum(HEX1, HEX0));
	       display_tb(.seg_d(HEX5), .seg_e(HEX4), .seg_f(HEX3),
			  .seg_g(7'h7f), .seg_h(HEX1), .seg_i(HEX0));
	    end
//	    display_tb(.seg_d(HEX5), .seg_e(HEX4), .seg_f(HEX3),
//		       .seg_g(7'h7f), .seg_h(HEX1), .seg_i(HEX0));


	    @(posedge clk);
	    SW[3:0] = 4'b0;
	    @(posedge clk);
	    if (response == TIMEOUT)
	      for (int i=0; i<20; i++)
		@(posedge clk);
	    
	    case (response)
	      CORRECT : begin
		 assert(LEDR[9:0] == 10'b10_0000_0000)
		   $display("%d: %d: Pass checkUser LEDs %s(exp) = %s(got)", 
			    simCycle,
			    seqLength,
			    getLEDstr({6'b10_0000, SW[3:0]}), getLEDstr(LEDR[9:0]));
		 else
		   $display("%d: %d: Fail checkUser LEDs %s(exp) = %s(got)", 
			    simCycle,
			    seqLength,
			    getLEDstr({6'b10_0000, SW[3:0]}), getLEDstr(LEDR[9:0]));
	      end

	      BADINPUT, TIMEOUT: begin
		 assert(LEDR[9:0] == 10'b01_1111_1111)
		   $display("%d: %d: Pass checkUser LEDs %s(exp) = %s(got)", 
			    simCycle,
			    seqLength,
			    getLEDstr(10'b01_1111_1111), getLEDstr(LEDR[9:0]));
		 else
		   $display("%d: %d: Fail checkUser LEDs %s(exp) = %s(got)", 
			    simCycle,
			    seqLength,
			    getLEDstr(10'b01_1111_1111), getLEDstr(LEDR[9:0]));
	      end
	    endcase
	    assert (getNum(HEX1, HEX0)   == (response == CORRECT ? seqCnt+1: seqCnt)) begin
	       $display("%d: %d: Pass seq # exp(%02x)  got(%02x)", simCycle, seqLength, 
			response == CORRECT ? seqCnt + 1 :seqCnt,
			getNum(HEX1, HEX0));
	    end
	    else begin
	       $display("%d: %d: Fail seq # exp(%02x)  got(%02x)", simCycle, seqLength, 
			response == CORRECT ? seqCnt + 1 :seqCnt,
			getNum(HEX1, HEX0));
	       display_tb(.seg_d(HEX5), .seg_e(HEX4), .seg_f(HEX3),
			  .seg_g(7'h7f), .seg_h(HEX1), .seg_i(HEX0));
	    end
//	    display_tb(.seg_d(HEX5), .seg_e(HEX4), .seg_f(HEX3),
//		       .seg_g(7'h7f), .seg_h(HEX1), .seg_i(HEX0));
	    poly.Next();
	 end

      endtask
   endclass
endpackage // tbs
   
`endif //  `ifndef TBS
   
