// sample top level design
module top_level(
  input        clk, reset, 
  output logic done);
  parameter 	D = 12,             // program counter width
    		A = 5;             		  // ALU command bit width
  wire[D-1:0] 	target, 			  // jump
	      	LUTout, 
              	prog_ctr;
  logic        	memRead,memWrite,regWrite, memToReg, regToReg, jump, call,ret,lea,mode;
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
  logic[2:0] reg_wb;

  logic [1:0] cycle_ctr;
// fetch subassembly
  PC #(.D(D)) 					  // D sets program counter width
     pc1 (.reset            ,
         .clk              ,
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
	      .mode);
// control
  Control ctl1( .opcode,
		.stage(cycle_ctr),
                .memRead, 
                .memWrite, 
                .regWrite, 
                .memToReg, 
		.regToReg,
                .jump,     
                .call,
                .ret,
                .lea,
                .ALUOp);

  reg_file rf1( .clk ,
	              .mode,
	       	      .lea,
                .reg_dest(reg1),
                .reg_src(reg2),
                .reg_write(reg_wb),
                .data_in(regfile_dat),
                .immediate(immediate),
                .write_enable(regWrite),
		.regToReg,
		.memToReg,
                .data_out1(datA),
                .data_out2(datB)); 


  alu alu1(.ALUOp,
        .inA    (datA),
        .inB    (datB),
        .c_i,  
        .rslt,
        .c_o(c_o),
        .equal(equalQ),
        .gt(gtQ),
        .lt(ltQ),
        .zero(zeroQ) // input to sc register
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
		mode = 1'b0;
		modeQ = 1'b0;
		cycle_ctr = 2'b00;
		zero = 1'b0;
		equal = 1'b0;
		gt = 1'b0;
		lt = 1'b0;
		c_o = 1'b0;
		reg_wb = 2'b00;
	end
	else begin
		if (cycle_ctr == 2'b11) begin
			cycle_ctr <= 2'b01;
		end
		else 
			cycle_ctr <= cycle_ctr + 1;
 	end
	zeroQ <= zero;
	equalQ <= equal;
	reg_wb <= reg1;
	gtQ <= gt;
	ltQ <= lt;
      	c_i <= c_o;
  end
  always_ff @(negedge clk) begin
	if(!reset) begin
		if (cycle_ctr == 2'b11)
			modeQ <= mode;
	end
  end
  //assign modeQ = mode;
  assign done = prog_ctr == 4096;
 
endmodule