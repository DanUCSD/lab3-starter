// count up from 0 
// until endVal
// only counts when enab is active
// rst synchronously sets the counter to startVal
//
module counterUp #(parameter WIDTH=12, bit [WIDTH-1:0] ENDVAL = 4095)
   (output logic [WIDTH-1:0] val,
    output logic 	    wrap,
    input logic 	    enab,
    input logic 	    rst,
    input logic 	    clk);


   logic [WIDTH-1:0] 	    next_val;

   logic [WIDTH-1:0] 	    valPlusOne;
   assign valPlusOne  = val + 'b1;
   
   assign wrap = (val == ENDVAL);
   assign next_val = rst ? {WIDTH{1'b0}} :             // if rst -> 0
		     enab ?                            // if enab and not  wrap, increment
		     (~wrap ? valPlusOne  : {WIDTH{1'b0}}) :       // if enab and wrap, 0
		     val;                              // else keep the same value
 
   always_ff @(posedge clk) begin
      val <= next_val;
   end
endmodule // counterUp
