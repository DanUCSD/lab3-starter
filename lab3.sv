//
// Bryan Chin, UCSD, 2023
// All rights reserved
// Limited use granted for those enrolled in cse140L.
//
// switches
//
// sw[3:0] game play switches
// sw[8:4] seed for the random # generator
//

// Complete the Implementation 


module lab3 (
       output logic [6:0] HEX5,   // seven segment display interface
       output logic [6:0] HEX4, 
       output logic [6:0] HEX3,
       output logic [6:0] HEX1,
       output logic [6:0] HEX0,
       output logic [9:0] LEDR,   // LEDs
       input logic [9:0]  SW,     // switches
       input logic  clk,    // 250 ms period clock
       input logic  rst);   // sync reset
   
   logic timerCntEn;
   logic timerRst;

	logic uTimerCntEn;
	logic uTimerRst;
	logic scoreCntEn;
	logic scoreCntRst;
	logic rndSeqEn;
	logic rndSeqRst;
	logic seqCntEn;
	logic seqCntRst;
	logic lightAllSl;
	logic lightRndSl;
	logic simonsTurn;
	logic fini;


   //
   // timer
   // this timer counts down from some configurable multiple of 250 ms.
   //
   wire [5:0] timerVal;
   wire       timerOut;
   wire       timerGtN;
   assign timerGtN = (timerVal > 2);

   logic [5:0] countStart;
   
   assign countStart = 6;  
             
   counterDn #(6) timerCnt  (
        .val(timerVal),
        .zero(timerOut),
        .startVal(countStart),
        .enab(timerCntEn),
        .rst(timerRst),
        .clk(clk));

   // Using the timerCnt example implement the rest of the counters and design  

   //
   // user timer
   // this counter counts down from some configurable multiple of 250 ms.
   // It generates a timeout if a user does not respond in a timely manner.
   //
   wire [5:0] uTimerVal;
   wire       uTimerOut;
   wire       uTimerGtN;
   assign uTimerGtN = (uTimerVal > 0);

   logic [5:0] uCountStart;
   
   assign uCountStart = 20;  
	
   counterDn #(6) 
       
       Cnt  (
        .val(uTimerVal),                   // not sure
        .zero(uTimerOut), 
        .startVal(uCountStart),           
        .enab(uTimerCntEn),
        .rst(uTimerRst),
        .clk(clk));
		  

   //
   // score counter
   // what is the max simon seq length so far
   // start at 1, after each successful play, increment by 1
   //
	wire scoreWrap;  // Unused.
   wire [7:0] score;
   counterUp #(8,127) scoreCnt (
        .val(score),
        .wrap(scoreWrap),
        .enab(scoreCntEn),                   
        .rst(scoreCntRst), 
		  .clk(clk));

         
      
   //
   // seq counter
   // this counter increments for each step of a "simon" sequence
   // It increments after a light is shown by Simon or a light is
   // turned off by the User.
   // What should seqEqScore be?
	
	wire seqWrap;  // Unused.
   wire [8:0] seqEqScore;
   counterUp #(8, 255) sequenceCnt (
        .val(seqEqScore),
        .wrap(seqWrap),
        .enab(seqCntEn),                     
        .rst(seqCntRst), .clk(clk));

   //
   // polynomial counter
   // random number generator
   //   
   
	wire [7:0] rndVal;
   poly poly (
        .val(rndVal),
        .seed({2'b0, SW[8:4], 1'b1}),
        // x8 + x6 + x5 + x4 + 1
        .taps(8'b1011_1000),
        .enab(rndSeqEn),
        .rst(rndSeqRst),
        .clk(clk));

   
  // TODO : fill in the logic for LEDR[9:0]
  // Hint : Think of the different scenarios which will light up the lEDS
  //********Fill here ***********
  
  wire anySwitch;
  wire switchMatch;
  always_comb begin
		LEDR[8:0] = lightAllSl ? 9'b111111111 : 9'b000000000;
		
  end
 
	bcd2hex debug (.bcd(timerVal), .hexSeg(HEX5));
  
  // TODO: check if any switch active and how should it be used
  //********Fill here ***********
  

  // TODO: does the current switch match what is expected
  //********Fill here ***********
   
  // TODO: display "H" or blank on HEX5
  //********Fill here ***********
	
   
   // TODO score
   bcd2hex sc1 ();
   bcd2hex sc0 ();
   bcd2hex seq1 ();
   bcd2hex seq0 ();

   simonStmach statemach (
        .fini(fini),
        .timerCntEn(timerCntEn),
        .timerRst(timerRst),                
        .uTimerCntEn(uTimerCntEn),     
        .uTimerRst(uTimerRst),
        .scoreCntEn(scoreCntEn),
        .scoreCntRst(scoreCntRst),
        .rndSeqEn(rndSeqEn),
        .rndSeqRst(rndSeqRst),
        .seqCntEn(seqCntEn),
        .seqCntRst(seqCntRst),
        .lightAllSl(lightAllSl),
        .lightRndSl(lightRndSl),
        .simonsTurn(simonsTurn), 
		   
        .timerGtN(timerGtN),
        .timerOut(timerOut),
        .uTimerOut(uTimerOut),     
        .seqEqScore(seqEqScore),
        .anySwitch(anySwitch),
        .switchMatch(switchMatch),
        .clk(clk),
        .rst(rst));
endmodule                 