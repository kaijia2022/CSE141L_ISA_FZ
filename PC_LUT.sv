module PC_LUT #(parameter D=12)(
  input clk,
  input  [D-1:0] addr,	
  output logic [D-1:0] target,
  input	logic      jump);	
  logic [D-1:0] Jump_Instructions[256];
  logic [D-1:0] Jump_Offsets[256];
  initial begin
     $readmemb("Jump_Instructions.txt", Jump_Instructions);
     $readmemb("offsets.txt", Jump_Offsets); 
  end

  always_ff@(posedge clk) begin
    	if (jump) begin
        	target = addr;
        	for (int i = 0; i < 256; i++) begin
            	if (addr == Jump_Instructions[i]) begin
                	target = addr + Jump_Offsets[i];
                	break;
            	end
        	end
    	end 
	else begin
        	target = addr + 1;
    	end
  end
endmodule

/*

	   pc = 4    0000_0000_0100	  4
	             1111_1111_1111	 -1

                 0000_0000_0011   3

				 (a+b)%(2**12)


   	  1111_1111_1011      -5
      0000_0001_0100     +20
	  1111_1111_1111      -1
	  0000_0000_0000     + 0


  */
