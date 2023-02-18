// count down from startVal
// when it hits 0, assert zero
// wrap back around to startVal
// only counts when enab is active
// rst synchronously sets the counter to startVal
//
module counterDn #(parameter WIDTH=12, parameter [WIDTH-1:0] STARTVAL = 4095)
   (output logic [WIDTH-1:0] val,
    output logic zero,
    input logic [WIDTH-1:0] startVal,
    input logic  enab,
    input logic  rst,
    input logic  clk);


   logic [WIDTH-1:0] 	    next_val;
   logic [WIDTH-1:0] 	    valMinusOne;
   assign valMinusOne = val - 'b1;
   
   assign zero = (val == 'b0);
   assign next_val = rst ? startVal :                  // if rst -> startVal
		     enab ?                            // if enab and not 0, decrement 
		     (~zero ? valMinusOne : startVal) :    // if enab and 0, startVal
		     val;                              // else keep the same value
 
   always_ff @(posedge clk) begin
      val <= next_val;
   end
endmodule // counterDn
