// sample top level design
module top_level(
  input        clk, reset, 
  output logic done);
  parameter 	D = 12,             // program counter width
    		A = 5;             		  // ALU command bit width
  wire[D-1:0] 	target, 			  // jump
	      	LUTout, 
              	prog_ctr;
  logic        	memRead,memWrite,regWrite, memToReg, jump, call,ret,lea,mode;
  logic[7:0]   	datA,datB,		  // from RegFile
		rslt,               // alu output
              	immediate,
		regfile_dat;
  logic 	modeQ,
		c_i,   				  // shift/carry out from/to ALU
		equalQ,
		gtQ,
		ltQ,
        	zeroQ;                    // registered zero flag from ALU 
  wire  	equal,
		gt,
		lt,
        	zero,
		c_o,
        ALUSrc;		              // immediate switch
  wire[A-1:0] opcode, ALUOp;
  wire[8:0]   mach_code;          // machine code
  wire[2:0] reg1, reg2, reg1_1;    // address pointers to reg_file
// fetch subassembly
  PC #(.D(D)) 					  // D sets program counter width
     pc1 (.reset            ,
         .clk              ,
		 .target,
		 .prog_ctr );

// lookup table to facilitate jumps/branches
  PC_LUT #(.D(D))
    pl1 ( .addr(prog_ctr),
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
  Decoder dc( .mach_code,
              .mode,
              .opcode,
              .reg1,
              .reg2,
              .immediate);
// control
  Control ctl1( .opcode,
                .memRead, 
                .memWrite, 
                .regWrite, 
                .memToReg, 
                .jump,     
                .call,
                .ret,
                .lea,
                .mode,
                .ALUOp);

  reg_file rf1( .clk ,
	              .mode,
	       	      .lea,
                .reg_dest(reg1),
                .reg_src(reg2),
                .reg_write(reg1),
                .data_in(regfile_dat),
                .immediate(immediate),
                .write_enable(regWrite),
                .data_out1(datA),
                .data_out2(datB)); 


  alu alu1(.ALUOp(),
        .inA    (datA),
        .inB    (datB),
        .c_i,  
        .rslt(rslt),
        .c_o(c_o),
        .equal,
        .gt,
        .lt,
        .zero // input to sc register
        );  

  dat_mem dm1(	.dat_in(datB),
                .ALU_out(rslt),
                .memToReg,
                .clk           ,
                .wr_en(memWrite), 
                .addr(datA),
                .dat_out(regfile_dat));

// registered flags from ALU
  always_ff @(posedge clk) begin
	zeroQ <= zero;
	modeQ <= mode;
	equalQ <= equal;
	gtQ <= gt;
	ltQ <= lt;
	
      	c_i <= c_o;
  end

  assign done = prog_ctr == 128;
 
endmodule