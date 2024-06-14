module LUT_RetAddrStack #(parameter D=12,parameter STACK_DEPTH = 8)(
  input  clk,
  input[1:0] stage,
  input       [D-1:0] addr,	
  input       [D-1:0] target_in,	  
  input	      call,
  input       ret,
  output logic[D-1:0] target_out);

  logic [D-1:0] ReturnAddr_Stack[STACK_DEPTH-1:0];
  logic [$clog2(STACK_DEPTH)-1:0] sp = 0;

  always_ff@(posedge clk) begin
     if (stage == 2'b01) begin
     	if (call) begin
     		if (sp < STACK_DEPTH) begin
        		ReturnAddr_Stack[sp] = addr + 1;
			/*$display("addr: %0d", addr);
			$display("call");
			$display("sp: %0d",sp);
			$display("0: ReturnAddr_Stack[sp]: %0d",ReturnAddr_Stack[0]);
			$display("1: ReturnAddr_Stack[sp]: %0d", ReturnAddr_Stack[1]);
			$display("2: ReturnAddr_Stack[sp]: %0d", ReturnAddr_Stack[2]);*/
        		sp = sp + 1;
      		end
     	end 
     	if (ret && sp > 0) begin
            	sp = sp - 1;  
            	target_out <= ReturnAddr_Stack[sp];  
	    	/*$display("return");
	    	$display("sp: %0d",sp);
		$display("0: ReturnAddr_Stack[sp]: %0d",ReturnAddr_Stack[0]);
		$display("1: ReturnAddr_Stack[sp]: %0d", ReturnAddr_Stack[1]);
		$display("2: ReturnAddr_Stack[sp]: %0d", ReturnAddr_Stack[2]);*/
     	end 
     end
     if (!ret) begin
            target_out <= target_in;  
     end
   end

endmodule

// else if (ret) begin
//      	if (sp > 0) begin
//         	sp <= sp - 1;
//      	end
//      end
//      assign target_out = (ret && sp >= 0) ? ReturnAddr_Stack[sp] : target_in;