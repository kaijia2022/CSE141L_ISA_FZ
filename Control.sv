// control decoder
module Control #(parameter opwidth = 5, Width = 5)(
  input [opwidth-1:0] opcode,   
  output logic memRead, memWrite, regWrite,memToReg, jump, call, ret,lea, mode,
  output logic[Width-1:0] ALUOp);	  

always_comb begin
	// defaults
	memRead = 'b0;
    memWrite = 'b0;
    regWrite = 'b0;
    memToReg = 'b0;
    jump = 'b0;
    call = 'b0;
    ret = 'b0;
    lea = 'b0;
    mode = 'b0;
    ALUOp = 'd0;

	case(opcode)    
		'b00000:  mode = !mode;      
		'b01010: begin
			memRead  = 'b1; 
			memToReg = 'b1;
			regWrite = 'b1;
		end 
		'b01001: memWrite = 'b1;                        
		'b00011, 'b00100, 'b01011, 'b01100:    jump = 'b1;             //JE, JZ, CALL, RET
		'b01000: lea = 'b1;
		default: ALUOp = opcode;

	endcase

end
	
endmodule