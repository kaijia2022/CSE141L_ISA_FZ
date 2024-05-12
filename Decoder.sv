// control decoder
module Decoder #(parameter opwidth = 5,parameter regwidth = 3)(
  input logic[8:0] mach_code,
  input		mode,    
  output logic[opwidth-1:0] opcode,	
  output logic[regwidth-1:0] reg1, reg2,	
  output logic[7:0] immediate);   // for up to 8 ALU operations

always_comb begin
	//reg-reg mode
	if (!mode) begin
		assign opcode = mach_code[8:4];
		assign reg1 = {1'b0,mach_code[3:2]};
		assign reg2 = {1'b0,mach_code[1:0]};

		
	end
	//reg-immediate mode
	else begin
		assign opcode = {3'b00,mach_code[8:6]};
		assign reg1 = mach_code[5:3];
		assign reg2 = mach_code[2:0];
		case(reg2)
			'b000:	immediate = 'd0; 
  			'b001:  immediate = 'd1;  
			'b010:  immediate = 'd4; 
			'b011:  immediate = 'd8; 
			'b100:  immediate = 'd16;
			'b101:  immediate = 'd32; 
			'b110:  immediate = 'd64; 
			'b111:  immediate = 'd127; 
		 endcase         
	end

end
	
endmodule
