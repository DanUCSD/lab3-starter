//
// Bryan Chin, UCSD
// All Rights Reserved
// Permission granted to use for those enrolled in cse140L
//

module lab3_tb;
   import tbs::*;   // get package test bench support
   
   task automatic doRst(ref logic rst, ref logic clk);
      begin
	 rst = 0;
	 @(posedge clk);
	 @(posedge clk);
	 rst = 1;
	 @(posedge clk);
	 @(posedge clk);
	 @(posedge clk);
	 @(posedge clk);
	 rst = 0;
	 @(posedge clk);
      end
   endtask

   // -------------------------------------------
   // test a
   // good input up to maxSeq
   //
   task testa(integer testNum, integer maxSeq);
      
      begin 
	 user_t userInput;
	 doRst(rst, clk);
	 $display("***** test %d testa - good user input maxSeq = 0x%02x\n", testNum, maxSeq);
	 userInput = CORRECT;
	 
	 for (int seqLength=1; seqLength<maxSeq; seqLength++) begin 
	    // playback
	    $display("Simon's Turn");
	    
	    chk.checkPlay(.dutLEDs(LEDR), 
			  .HEX5(HEX5), .HEX4(HEX4), .HEX3(HEX3), .HEX1(HEX1), .HEX0(HEX0),
			  .clk(clk), .simCycle(simCycle), .seqLength(seqLength));
	    
	    // user
	    chk.startUser();
	    $display("User's Turn");
	    for (int seqCnt = 0; seqCnt<seqLength; seqCnt++) begin
	       chk.checkUserLED(.LEDR(LEDR), .clk(clk), .simCycle(simCycle), 
				.HEX5(HEX5), .HEX4(HEX4), .HEX3(HEX3), .HEX1(HEX1), .HEX0(HEX0),
				.SW(SW),
				.seqCnt(seqCnt),
				.seqLength(seqLength),
				.response(userInput));
	    end
	    
	 end
      end 
   endtask 
      

   // -------------------------------------------
   // test b
   //
   // test for failure - bad user input
   // keep playing until we hit maxSeq -1.
   // (assert reset at the end)
   task testb(integer testNum, integer maxSeq);
      begin
	 int seqLength;
	 int 	 seqCnt;
	 
	 doRst(rst, clk);
	 $display("\n***** test %d - testb - bad user input maxSeq = 0x%02x\n", testNum, maxSeq);
	 
	 for (seqLength=1; seqLength<maxSeq; seqLength++) begin 
	    // playback
	    chk.checkPlay(.dutLEDs(LEDR), 
			  .HEX5(HEX5), .HEX4(HEX4), .HEX3(HEX3), .HEX1(HEX1), .HEX0(HEX0), 
			  .clk(clk), .simCycle(simCycle), .seqLength(seqLength));
	    // user
	    chk.startUser();
	    for (seqCnt = 0; seqCnt<seqLength-1; seqCnt++) begin
	       chk.checkUserLED(.LEDR(LEDR), .clk(clk), .simCycle(simCycle), 
				.HEX5(HEX5), .HEX4(HEX4), .HEX3(HEX3), .HEX1(HEX1), .HEX0(HEX0),
				.SW(SW),
				.seqCnt(seqCnt),
				.seqLength(seqLength),
				.response(CORRECT));
	    end
	    if (seqLength == (maxSeq-1))
	      chk.checkUserLED(.LEDR(LEDR), .clk(clk), .simCycle(simCycle), 
			       .HEX5(HEX5), .HEX4(HEX4), .HEX3(HEX3), .HEX1(HEX1), .HEX0(HEX0),
			       .SW(SW),
			       .seqCnt(seqCnt),   // we dont' increment the seq cnt if we got a bad input
			       .seqLength(seqLength),
			       .response(BADINPUT));
	    else
	      chk.checkUserLED(.LEDR(LEDR), .clk(clk), .simCycle(simCycle), 
			       .HEX5(HEX5), .HEX4(HEX4), .HEX3(HEX3), .HEX1(HEX1), .HEX0(HEX0),
			       .SW(SW),
			       .seqCnt(seqCnt),
			       .seqLength(seqLength),
			       .response(CORRECT));
	    
	 end
      end
   endtask


   // -------------------------------------------
   // test c
   //
   // test for failure - bad user input timeout
   // 
   task testc(integer testNum, integer maxSeq);
      begin
	 int seqLength;
	 int seqCnt;
	 doRst(rst, clk);
	 $display("\n***** test %d testc - user timeout maxSeq = 0x%02x", testNum, maxSeq);

	 for (seqLength=1; seqLength<maxSeq; seqLength++) begin 
	    // playback
	    chk.checkPlay(.dutLEDs(LEDR), 
			  .HEX5(HEX5), .HEX4(HEX4), .HEX3(HEX3), .HEX1(HEX1), .HEX0(HEX0),
 			  .clk(clk), .simCycle(simCycle), .seqLength(seqLength));
	    // user
	    chk.startUser();
	    for (seqCnt = 0; seqCnt<seqLength-1; seqCnt++) begin
	       chk.checkUserLED(.LEDR(LEDR), .clk(clk), .simCycle(simCycle), 
				.HEX5(HEX5), .HEX4(HEX4), .HEX3(HEX3), .HEX1(HEX1), .HEX0(HEX0),
				.SW(SW),
				.seqCnt(seqCnt),
				.seqLength(seqLength),
				.response(CORRECT));
	    end
	    if (seqLength == (maxSeq-1))
	      chk.checkUserLED(.LEDR(LEDR), .clk(clk), .simCycle(simCycle), 
			       .HEX5(HEX5), .HEX4(HEX4), .HEX3(HEX3), .HEX1(HEX1), .HEX0(HEX0),
			       .SW(SW),
			       .seqCnt(seqCnt),
			       .seqLength(seqLength),
			       .response(TIMEOUT));
	    else
	      chk.checkUserLED(.LEDR(LEDR), .clk(clk), .simCycle(simCycle), 
			       .HEX5(HEX5), .HEX4(HEX4), .HEX3(HEX3), .HEX1(HEX1), .HEX0(HEX0),
			       .SW(SW),
			       .seqCnt(seqCnt),
			       .seqLength(seqLength),
			       .response(CORRECT));
	    
	 end
      end
   endtask


   // =============================================
   //
   // testbench driver
   //
   // =============================================
   user_t userInput = CORRECT;
   logic [6:0] HEX5;
   logic [6:0] HEX4;
   logic [6:0] HEX3;
   logic [6:0] HEX1;
   logic [6:0] HEX0;

   //
   // clock and reset generation
   //
   logic clk = 0;
   always
     #10 clk <= ~clk;
   
   logic rst;
   initial begin
      doRst(rst, clk);
   end      

   logic [9:0] LEDR;
   logic [9:0] SW;

   Checkit chk = new();
   
   lab3 dutbatch (.HEX5(HEX5), .HEX4(HEX4), .HEX3(HEX3), .HEX1(HEX1), .HEX0(HEX0),
		  .LEDR(LEDR), .SW(SW), .clk(clk), .rst(rst));
      
   integer     seqCnt;    // increments up to the current bestscore
   integer seqLength;     // the current best score

   // play the game correctly
   integer testNum = 0;
   
   // fixed simulation time
   integer     simCycle;
   initial begin
      @(negedge rst);
      for (simCycle = 0; simCycle < 100000; simCycle++) begin
	 @(posedge clk);
      end
      $finish();
   end


   initial begin

      SW = 10'b0; 
      
      @(negedge rst);
      testa(.testNum(++testNum), .maxSeq(8'h0f));
      testb(.testNum(++testNum), .maxSeq(4));
      testc(.testNum(++testNum), .maxSeq(2));

      // long test
      //      testa(.testNum(++testNum), .maxSeq(8'h7f));
      $finish();
   end
endmodule
      
	
