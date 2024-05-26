// program counter
// supports both relative and absolute jumps
// use either or both, as desired
module PC #(parameter D=12)(
  input reset,					// synchronous reset
        clk,        
  input       [D-1:0] target,	// how far/where to jump
  output logic[D-1:0] prog_ctr
);

  always_ff @(posedge clk) begin
    if(reset)
	  prog_ctr <= 8'b00000000;
    else
	  prog_ctr <= target;

  end

endmodule