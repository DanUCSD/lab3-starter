// State machine implementation for Simons Game
// Uses enumerated variable for states
// Starter -- you need to complete the always_comb logic 
// States description provided in the lab instructions document  

module simonStmach (
    output logic       timerCntEn, // enable the timer
    output logic       timerRst, // reset the timer

    output logic       uTimerCntEn, // enable the user timer
    output logic       uTimerRst, // reset the user timer

    output logic       scoreCntEn, // adv the score
    output logic       scoreCntRst, // reset the score count

    output logic       rndSeqEn, // adv the rnd sequence
    output logic       rndSeqRst, // rst rnd sequence

    output logic       seqCntEn, // adv the step counter
    output logic       seqCntRst, // reset the step counter

    output logic       lightAllSl, // turn on all the lights
    output logic       lightRndSl, // light the random sequence

    output logic       simonsTurn, // turnon when playing sequence      
    output logic       fini,

    input logic        timerGtN, // timer is greater than 2 
    input logic        timerOut, // timer timed out
    input logic        uTimerOut, // user times out

    input logic        seqEqScore, // the step is equal to the score
    input logic        anySwitch, // any switch is on
    input logic        switchMatch, // user matches expected 

    input 	       clk,
    input 	       rst);
   
   typedef enum {
                 Idle, IdlePause, Play, PlayPause, Rec, RecWait, Fail } state_t;
   
   state_t curState;
   state_t nxtState;
   
   
// sequential part of our state machine

   always_ff @(posedge clk)
     begin
       if (rst)
         curState <= Idle;
       else
         curState <= nxtState;
     end 

// combinational part will reset or increment the counters and figure out the next_state

   always_comb begin
      // Default value of signals. You only need to specify signal values in
      // the case statement when you want a value other than these defaults.
      timerCntEn = 0;
      timerRst = 0;
      uTimerCntEn = 0;
      uTimerRst = 0;
      scoreCntEn = 0;
      scoreCntRst = 0;
      rndSeqEn = 0;
      rndSeqRst = 0;
      seqCntEn = 0;
      seqCntRst = 0;
      lightAllSl = 0;
      lightRndSl = 0;
      simonsTurn = 0;
      fini = 0;
      
    unique case (curState)

/* ************* Fill in the case statements ************** */
      Idle : begin
        // what is next_state value, what are the conditions to update it?
        // what other counters should be checked and updated here? 
        // Refer to instructions document and the state diagram you created for checkpoint
			timerCntEn = 1;
			timerRst = rst;
			lightAllSl = 1;
			scoreCntRst = rst;
        nxtState = timerGtN ? curState : IdlePause;
      end
//Similar to Idle, think of the logic to be added in other states(check below) 

      IdlePause: begin
        timerCntEn = 1;
		  lightAllSl = 0;
		  rndSeqRst = 1;
		  scoreCntEn = 1;
        nxtState = timerOut ? Play : curState;
		  if (timerOut) begin
				nxtState = Play;
				scoreCntEn = 0;
		  end else begin
				nxtState = curState;
		  end
      end

      Play: begin
//		   timerCntEn = 1;
//			timerRst = 0;
//			uTimerCntEn = 0;
//			uTimerRst = 0;
//			scoreCntEn = 1;
//			scoreCntRst = 0;
//			rndSeqEn = 1;
//			rndSeqRst = 0;
//			seqCntEn = 1;
//			seqCntRst = 0;
//			lightAllSl = 0;
//			lightRndSl = 1;
//			simonsTurn = 1;
//			fini = 0;

			timerCntEn = 1;
			rndSeqEn = 1;
			lightRndSl = 1;
			simonsTurn = 1;
			if (timerGtN) begin
				nxtState = curState;
				rndSeqEn = 0;
			end else begin
				nxtState = PlayPause;
			end
      end

      PlayPause: begin
			timerCntEn = 1;
			
			nxtState = timerOut ? Play : curState;
      end

      Rec: begin
        nxtState = curState;
      end
      
      RecWait: begin
        nxtState = curState;
      end

      Fail: begin
        nxtState = curState;
      end

     endcase // unique case (curState)
   end // comb
endmodule