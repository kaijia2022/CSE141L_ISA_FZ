// combinational -- no clock
// sample -- change as desired
module alu(
  input[4:0] ALUOp,    // ALU instructions
  input[7:0] inA, inB,	 // 8-bit wide data path
  input  logic    c_i,       // shift_carry in
  output logic[7:0] rslt,
  output logic c_o,    
               equal, 
		gt,
		lt,
	       zero  
);

always_comb begin 
  rslt = 'b0;            
  c_o = 'b0;    
  zero = !rslt;
  equal = 'b0; 
  gt = 'b0;
  lt = 'b0;
  case(ALUOp)
    5'b00111:  begin    //ADD 
      {c_o,rslt} = inA + inB + c_i;
      zero = !rslt;
    end
    5'b01110: begin// SUB 
      {c_o,rslt} = inA - inB + c_i;
      zero = !rslt;
    end
    5'b10110:  begin    //ADDS 
      {c_o,rslt} = $signed(inA)+ $signed(inB) + c_i;
      zero = !rslt;
    end
    5'b10111: begin// SUBS 
      {c_o,rslt} = $signed(inA)- $signed(inB) + c_i;
      zero = !rslt;
    end
    5'b00010: begin// DEC
      rslt = inA - 1;
      zero = !rslt;
    end
    5'b10000: begin// XOR 
	  rslt = inA ^ inB;
  	  zero = !rslt;
    end
    5'b01111: begin// bitwise AND (mask)
	  rslt = inA & inB;
   	  zero = !rslt;
    end
    5'b10101: begin// bitwise OR (mask)
	  rslt = inA | inB;
	  zero = !rslt;	
    end
    5'b10001: begin//Logic Shift Right
	  {c_o,rslt} = {inA[0],1'b0, inA[7:1]};
	  zero = !rslt;
    end
    5'b10011: begin//Logic Shift Left
	  {c_o, rslt} = {inA[7], inA[6:0],1'b0};
	  zero = !rslt;
    end
    5'b10010: begin//Shift Right with Carry in
	  {c_o,rslt} = {inA[0], c_i, inA[7:1]};
	  zero = !rslt;;
    end
    5'b10100: begin//Shift Left with Carry in
	  {c_o, rslt} = {inA[7], inA[6:0],c_i};
  	  zero = !rslt;
    end
    5'b11000: begin//Arithmetic Shift Right
	  {c_o,rslt} = {inA[0],inA[7], inA[7:1]};
	  zero = !rslt;
    end
    5'b00101: begin //compare
	  equal = ( $signed(inA) == $signed(inB));
          zero = ($signed(inA) == $signed(inB));
 	  gt = ($signed(inA) > $signed(inB));
	  lt = ($signed(inA) < $signed(inB));
    end
  endcase
end
   
endmodule