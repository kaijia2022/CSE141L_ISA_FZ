module testbench;
	bit  clk,reset,
       	    start = 'b1;
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
		c_o,
	


	PC 					  // D sets program counter width
     	pc1 (.reset(reset),
         .clk(clk)              ,
		 .target,
		 .prog_ctr );
	
	 alu alu1(.ALUOp(),
        .inA    (datA),
	.inB    (datB),
	.c_i,  
	.rslt  ,
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
		#200ns start = 'b0
		#200ns start = 'b1; 
		c_i = 'b0;         //xor
		dataA = 8'b01110001;
		dataB = 8'b00100100;
		ALUOp = 5'b10000; 	
		#200ns start = 'b0
		#200ns start = 'b1; 
		c_i = 'b1;      //right shift with carry
		dataA = 8'b01110001;
		dataB = 8'b00100100;
		ALUOp = 5'b10010; 	
		$stop;
	end
endmodule
