// combinational -- no clock
// sample -- change as desired
module alu(
  input clk,
  input[1:0] stage,
  input[4:0] ALUOp,    // ALU instructions
  input[7:0] inA, inB,	 // 8-bit wide data path
  input  logic    c_i,       // shift_carry in
  output logic[7:0] out,
  output logic c_o,    
               equal, 
		gt,
		lt,
	       zero  );
  logic[7:0] rslt;
always_comb begin 
  rslt = 'b0;            
  c_o = 'b0;    
  zero = !rslt;
  equal = 'b0; 
  gt = 'b0;
  lt = 'b0;
  case(ALUOp)
    5'b00111:  begin    //ADD 
      {c_o,rslt} = $unsigned(inA) + $unsigned(inB) + $unsigned(c_i);
      zero = !rslt;
    end
    5'b01110: begin// SUB 
      rslt = $unsigned(inA) - $unsigned(inB);
      zero = !rslt;
    end
    5'b10110:  begin    //ADDS 
      {c_o,rslt} = $signed(inA)+ $signed(inB) + $signed(c_i);
      zero = !rslt;
    end
    5'b10111: begin// SUBS 
      {c_o,rslt} = $signed(inA)- $signed(inB) + $signed(c_i);
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
    5'b10010: begin//Shift Right with Carry inE:/CSE141L/ISA_Design_FZ/alu.sv
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
    5'b11011: begin //compare with unsigned
	  equal = ($unsigned(inA) == $unsigned(inB));
          zero = ($unsigned(inA) == $unsigned(inB));
 	  gt = ($unsigned(inA) > $unsigned(inB));
	  lt = ($unsigned(inA) < $unsigned(inB));
    end
    5'b11100: begin//Logic Shift Right
	  rslt = ~inA;
	  zero = !rslt;
    end
  endcase
end
always_ff@(negedge clk) begin
	if(stage == 2'b01) 
		out <= rslt;
end
   
endmodule