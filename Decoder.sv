// control decoder
module Decoder #(parameter opwidth = 5,parameter regwidth = 3)(
  input logic[8:0] mach_code,
  input	logic  modeQ,    
  output logic[opwidth-1:0] opcode,	
  output logic[regwidth-1:0] reg1, reg2,	
  output logic[7:0] immediate,
  output logic mode);   // for up to 8 ALU operations

always_comb begin
    reg1 = 0;
    reg2 = 0;
    immediate = 0;
    mode = modeQ;
	//reg-reg mode
	if (!modeQ) begin
		opcode = mach_code[8:4];
		reg1 = {1'b0,mach_code[3:2]};
		reg2 = {1'b0,mach_code[1:0]};	
	end
	//reg-immediate mode
	else begin
		opcode = {3'b00,mach_code[8:6]};
		reg1 = mach_code[5:3];
		reg2 = mach_code[2:0];
		case(reg2)
			3'b000:	 immediate = 8'd0; 
  			3'b001:  immediate = 8'd1;  
			3'b010:  immediate = 8'd4; 
			3'b011:  immediate = 8'd8; 
			3'b100:  immediate = 8'd16;
			3'b101:  immediate = 8'd32; 
			3'b110:  immediate = 8'd64; 
			3'b111:  immediate = 8'd127; 
			default: immediate = 0;  
		endcase
	end
	if (opcode == 5'b00000)
		mode = !modeQ;	


end
	
endmodule
