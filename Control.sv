// control decoder
module Control #(parameter opwidth = 5, Width = 5)(
  input clk,
  input [opwidth-1:0] opcode,
  input [1:0] stage,
  input logic equalQ, gtQ, ltQ, zeroQ,
  output logic memRead, memWrite, regWrite,memToReg, regToReg, regToMem, jump, call, ret,lea,
  output logic[Width-1:0] ALUOp);	

  logic[Width-1:0] ALUctr;  

always_comb begin
	// defaults
    memRead = 1'b0;
    memWrite = 1'b0;
    regWrite = 1'b0;
    memToReg = 1'b0;
    regToReg = 1'b0;
    regToMem = 1'b0; 
    jump = 1'b0;
    call = 1'b0;
    ret = 1'b0;
    lea = 1'b0;
    ALUctr = 5'b00000;

	case(opcode)  
		'b00000: begin   end         //tog
		'b00110: jump = 1'b1;
		'b01010: begin              //move mem to reg
			memRead  = 1'b1; 
			memToReg = 1'b1;
			regWrite = 1'b1;
		end                         
		'b01001: begin memWrite = 1'b1; regToMem = 1'b1; end   //mov reg to mem
		'b00001: begin regWrite = 1'b1;  regToReg = 1'b1; end//mov reg to reg                 
		'b00011: begin      //JE
			if(equalQ)
				 jump = 1'b1;
		end
		'b00100: begin    //JZ
			if(zeroQ)
				 jump = 1'b1;
		end
		'b11001:  begin   //JGT
			if(gtQ)
				 jump = 1'b1;
		end
		'b11010:  begin
			if(ltQ)
				 jump = 1'b1;
		end 
		'b01011: begin call = 1'b1; jump = 1'b1;end
		'b01100: begin ret = 1'b1; jump = 1'b1;end
		'b01000: begin lea = 1'b1; regWrite = 1'b1;  end
		'b00101:  ALUctr = opcode;                              //CMP, no writeback
		default: begin
			ALUctr = opcode;
			regWrite = 1'b1;
		end

	endcase
	/*if (stage == 'b11) begin
		regWrite = regWrite;
	end
	else
		regWrite = 1'b0;*/
	if (stage == 'b10) begin
		memWrite = memWrite;
		regWrite = regWrite;
	end
	else begin
		memWrite = 1'b0;
		regWrite = 1'b0;
	end
	
end

always_ff@(posedge clk) begin
	if(stage == 2'b00) begin
			ALUOp <= ALUctr;

	end
end
	
endmodule