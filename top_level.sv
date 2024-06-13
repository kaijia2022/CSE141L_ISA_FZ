// sample top level design
module top_level(
  input        clk, reset, 
  output logic done);
  parameter 	D = 12,             // program counter width
    		A = 5;             		  // ALU command bit width
  wire[D-1:0] 	target, 			  // jump
	      	LUTout, 
              	prog_ctr;
  logic        	memRead,memWrite,regWrite, memToReg, regToMem, regToReg, jump, call,ret,lea,mode,setMode;
  logic[7:0]   	datA,datB,		  // from RegFile
		rslt,               // alu output
              	immediate,
		regfile_dat;
  logic 	c_i,   				  // shift/carry out from/to ALU
		equalQ,
		gtQ,
		ltQ,
        	zeroQ;                   // registered zero flag from ALU 
  logic  	equal,
		gt,
		lt,
        	zero,
		c_o,
        	//ALUSrc,   // immediate switch 
		modeQ;		           
  wire[A-1:0] opcode, ALUOp;
  wire[8:0]   mach_code;           // machine code
  wire[2:0] reg1, reg2;    // address pointers to reg_file

  logic [1:0] cycle_ctr;

// fetch subassembly
  PC #(.D(D)) 					  // D sets program counter width
     pc1 (.reset            ,
         .clk              ,
		  .stage(cycle_ctr),
		 .target,
		 .prog_ctr);

// lookup table to facilitate jumps/branches
  PC_LUT #(.D(D))
    pl1 ( .clk,
	  .addr(prog_ctr),
          .target(LUTout), 
	        .jump);   

  LUT_RetAddrStack #(.D(D))
    lras (.clk,
	  .stage(cycle_ctr),
          .addr(prog_ctr),
          .target_in(LUTout),
          .call,
          .ret,
          .target_out(target));
 	  
	
// contains machine code
  instr_ROM ir1(.prog_ctr,
                .mach_code);
//Decoder
  Decoder dc(   .clk,
		.mach_code,
              .modeQ,
              .opcode,
              .reg1,
              .reg2,
              .immediate,
	      .setMode);
// control
  Control ctl1( .clk,
		.opcode,
		.stage(cycle_ctr),
		.equalQ,
		.zeroQ,
		.gtQ,
		.ltQ,
                .memRead, 
                .memWrite, 
                .regWrite, 
                .memToReg, 
		.regToReg,
		.regToMem,
                .jump,     
                .call,
                .ret,
                .lea,
                .ALUOp);

  reg_file rf1( .clk ,
	              .mode,
	       	      .lea,
		.stage(cycle_ctr),
                .reg_dest(reg1),
                .reg_src(reg2),
                .data_in(regfile_dat),
                .immediate(immediate),
                .write_enable(regWrite),
		.regToReg,
		.memToReg,
		.regToMem,
                .data_out1(datA),
                .data_out2(datB)); 


  alu alu1(.clk, .ALUOp, .stage(cycle_ctr),
        .inA(datA),
        .inB(datB),
        .c_i,  
        .out(rslt),
        .c_o(c_o),
        .equal(equal),
        .gt(gt),
        .lt(lt),
        .zero(zero) // input to sc register
        );  

  dat_mem dm(	.dat_in(datB),
                .ALU_out(rslt),
                .memToReg,
                .clk           ,
                .wr_en(memWrite), 
                .addr(datA),
                .dat_out(regfile_dat));
// registered flags from ALU
  always_ff @(posedge clk) begin
	if (reset) begin
		cycle_ctr = 2'b00;
		mode = 1'b0;
		modeQ = 1'b0;
	end
	else begin
		if (cycle_ctr == 2'b11) begin
			cycle_ctr <= 2'b00;
		end
		else if (cycle_ctr == 2'b00) begin 
			cycle_ctr <= 2'b01;
		end
		else if (cycle_ctr == 2'b01) begin
			cycle_ctr <= 2'b10;
		end
		else begin
			cycle_ctr <= 2'b11;
		end
			
			
 	end
	zeroQ <= zero;
	equalQ <= equal;
	gtQ <= gt;
	ltQ <= lt;
      	c_i <= c_o;
  end
  always_ff @(negedge clk) begin
	if(!reset) begin
		if (cycle_ctr == 2'b11)
			modeQ <= mode;
		if (cycle_ctr == 2'b00) begin
			if (setMode)
				mode <= !modeQ;
			else
				mode <= modeQ;
		end
			
	end
  end
  //assign modeQ = mode;
  assign done = prog_ctr == 4095;
 
endmodule