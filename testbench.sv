module testbench;
	bit  clk,reset;
  	wire done;
	
	logic[ 12-1:0] target, prog_ctr;	
	logic[5-1:0] ALUOp;
	logic[8-1:0] dataA, dataB;
	logic 	modeQ,
		c_i,   				  // shift/carry out from/to ALU
		equalQ,
		gtQ,
		ltQ,
        	zeroQ;                    // registered zero flag from ALU 
  	wire	equal,
		gt,
		lt,
        	zero,
		c_o,rslt;
	


	PC 					  // D sets program counter width
     	pc1 (.reset(reset),
         .clk(clk)              ,
		 .target,
		 .prog_ctr );
	
	 alu alu1(.ALUOp,
        .inA    (dataA),
	.inB    (dataB),
	.c_i,  
	.rslt (rslt)  ,
	.c_o, .equal, .gt,.lt,.zero
	);  
	
 	always begin
    		#50ns clk = 'b1;
		#50ns clk = 'b0;
  	end

	initial begin
		#100ns;   //pc, alu-ADD
		target = 12'b001001010111;
		c_i = 'b0;
		dataA = 8'b00000001;
		dataB = 8'b00000100;
		ALUOp = 5'b01101; 		
		#50ns
		c_i = 'b0;         //sub
		dataA = 8'b01110001;
		dataB = 8'b00100100;
		ALUOp = 5'b01110; 	
		#50ns
		c_i = 'b0;         //adds
		dataA = 8'b10000000;
		dataB = 8'b00000001;
		ALUOp = 5'b10110; 	
		#50ns
		c_i = 'b0;         //subs
		dataA = 8'b00000000;
		dataB = 8'b00000001;
		ALUOp = 5'b10111; 	
		#50ns
		c_i = 'b0;         //dec
		dataA = 8'b00000010;
		dataB = 8'b00000000;
		ALUOp = 5'b00010; 	
		#50ns
		c_i = 'b0;         //xor
		dataA = 8'b01110001;
		dataB = 8'b00100100;
		ALUOp = 5'b10000; 	
		#50ns
		c_i = 'b0;         //and
		dataA = 8'b11111111;
		dataB = 8'b00100100;
		ALUOp = 5'b01111; 	
		#50ns
		c_i = 'b0;         //or
		dataA = 8'b11111111;
		dataB = 8'b00100100;
		ALUOp = 5'b10101; 	
		#50ns
		c_i = 'b0;      //logical right shift
		dataA = 8'b01110001;
		dataB = 8'b00000000;
		ALUOp = 5'b10001; 	
		#50ns
		c_i = 'b0;      //logical left shift
		dataA = 8'b01110001;
		dataB = 8'b00000000;
		ALUOp = 5'b10011; 	
		#50ns
		c_i = 'b1;      //right shift with carry
		dataA = 8'b01110001;
		dataB = 8'b00000000;
		ALUOp = 5'b10010; 	
		#50ns
		c_i = 'b1;      //left shift with carry
		dataA = 8'b01110001;
		dataB = 8'b00000000;
		ALUOp = 5'b10100; 	
		#50ns
		c_i = 'b0;      //compare (a == b)
		dataA = 8'b01110001;
		dataB = 8'b01110001;
		ALUOp = 5'b00101; 	
		#50ns
		c_i = 'b0;      //compare (a > b)
		dataA = 8'b01110001;
		dataB = 8'b01110000;
		ALUOp = 5'b00101; 	
		#50ns
		c_i = 'b0;      //compare (a < b)
		dataA = 8'b01110001;
		dataB = 8'b01110010;
		ALUOp = 5'b00101; 	
		#50ns
		$stop;
	end
endmodule
