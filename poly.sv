// poly
// 
// polynomial counter
// counts when enable = 1

// set the taps to the bits that will be xor'd to form the'
// input to the lsb.
//
module poly #(
	      parameter WIDTH = 8 )
   (output logic [WIDTH-1:0] val,
    input logic [WIDTH-1:0] seed, // initial value
    input logic [WIDTH-1:0] taps, // bits that will be tapped
    input logic enab, // enable
    input logic rst, // rst 
    input logic clk);
   
   logic [WIDTH-1:0] 	     nextVal;

   logic 		     inp;
   assign inp  = ^(val & taps);
   always_comb begin
      if (rst)
		  nextVal = seed;
      else
	if (enab)
	  nextVal = {val[WIDTH-2:0], inp};
	else
	  nextVal = val;
   end
   always_ff @(posedge clk) begin
      val <= nextVal;
   end
endmodule
