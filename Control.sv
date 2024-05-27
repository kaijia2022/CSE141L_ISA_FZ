// control decoder
module Control #(parameter opwidth = 5, Width = 5)(
  input [opwidth-1:0] opcode,
  input [1:0] stage,
  output logic memRead, memWrite, regWrite,memToReg, regToReg, jump, call, ret,lea,
  output logic[Width-1:0] ALUOp);	  

always_comb begin
	// defaults
    memRead = 1'b0;
    memWrite = 1'b0;
    regWrite = 1'b0;
    memToReg = 1'b0;
    regToReg = 1'b0;
    jump = 1'b0;
    call = 1'b0;
    ret = 1'b0;
    lea = 1'b0;
    ALUOp = 5'b00000;

	case(opcode)  
		//'b00000: begin   end         //tog
		'b01010: begin              //move mem to reg
			memRead  = 1'b1; 
			memToReg = 1'b1;
			regWrite = 1'b1;
		end                         
		'b01001: memWrite = 1'b1;   //mov reg to mem
		'b00001: begin regWrite = 1'b1;  regToReg = 1'b1; end//mov reg to reg                 
		'b00011, 'b00100, 'b11001, 'b11010:   jump = 1'b1;         //JE, JZ, JGT, JLT
		'b01011: begin call = 1'b1; jump = 1'b1;end
		'b01100: begin ret = 1'b1; jump = 1'b1;end
		'b01000: begin lea = 1'b1; regWrite = 1'b1;  end
		'b00101:  ALUOp = opcode;                              //CMP, no writeback
		default: begin
			ALUOp = opcode;
			regWrite = 1'b1;
		end

	endcase
	//if(ALUOp != 5'b00000) begin
		if (stage == 'b01) begin
			regWrite = regWrite;
		end
   		else if (stage == 'b10) begin
			regWrite = 1'b0;
		end
		else
			regWrite = 1'b0;
	//end
end
	
endmodule