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
        .val(uTimerVal),                   
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
	wire scoreWrap;  
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
   wire seqEqScore;
	logic [7:0] seqVal;
   counterUp #(8, 255) sequenceCnt (
        .val(seqVal),
        .wrap(seqWrap),
        .enab(seqCntEn),                     
        .rst(seqCntRst), .clk(clk));
		  
	assign seqEqScore = seqVal == score;

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
  
  wire [3:0] lights;

	wire b1;
	wire b0;
	assign b1 = rndVal[4] ? 1'b1 : 1'b0;
	assign b0 = rndVal[2] ? 1'b1 : 1'b0;

  assign lights = b1 * 2 + b0;
  
  
  assign anySwitch = (SW[0] || SW[1] || SW[2] || SW[3]);
	logic [7:0] switchOnIdx;


	always_comb begin
		if (SW[0]) begin
			switchOnIdx = 0;
		end else if (SW[1]) begin
			switchOnIdx = 1;
		end else if (SW[2]) begin
			switchOnIdx = 2;
		end else if (SW[3]) begin
			switchOnIdx = 3;
		end else begin
			switchOnIdx = -1;
		end
		
	end
  
  assign switchMatch = (lights == switchOnIdx);
  
  always_comb begin
		LEDR[9] = !simonsTurn;
		LEDR[8:4] = lightAllSl ? 5'b11111 : 5'b00000;
		LEDR[3] = lightAllSl ? 1 : switchOnIdx == 3 ? 1 : (lightRndSl ? lights == 3 : 0);
		LEDR[2] = lightAllSl ? 1 : switchOnIdx == 2 ? 1 : (lightRndSl ? lights == 2 : 0);
		LEDR[1] = lightAllSl ? 1 : switchOnIdx == 1 ? 1 : (lightRndSl ? lights == 1 : 0);
		LEDR[0] = lightAllSl ? 1 : switchOnIdx == 0 ? 1 : (lightRndSl ? lights == 0 : 0);
		
		if (fini) begin
			HEX5 = 7'b0001001;
			
			// Some code here to show 
		end else begin
			
		end
		
  end

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