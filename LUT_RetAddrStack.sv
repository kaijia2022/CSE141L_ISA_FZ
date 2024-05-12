module LUT_RetAddrStack #(parameter D=12,parameter STACK_DEPTH = 8)(
  input logic  clk,
  input       [D-1:0] addr,	
  input       [D-1:0] target_in,	  
  input	      call,
  input       ret,
  output logic[D-1:0] target_out);

  logic [D-1:0] ReturnAddr_Stack[STACK_DEPTH-1:0];
  logic [$clog2(STACK_DEPTH)-1:0] sp = 0;

  always_ff@(posedge clk) begin
     if (call) begin
     	if (sp < STACK_DEPTH) begin
        	ReturnAddr_Stack[sp] <= addr + 1;
        	sp <= sp + 1;
      	end
     end 
     else if (ret) begin
     	if (sp > 0) begin
        	sp <= sp - 1;
     	end
     end
     assign target_out = (ret && sp >= 0) ? ReturnAddr_Stack[sp] : target_in;
   end

endmodule
