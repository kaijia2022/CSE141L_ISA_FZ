// cache memory/register file
module reg_file(
    input clk,
    input mode,
    input lea,	
    input[1:0] stage,
    input [2:0] reg_dest,
    input [2:0] reg_src,   
    input [7:0] data_in,
    input [7:0] immediate, 
    input write_enable, regToReg,memToReg, regToMem,
    output logic [7:0] data_out1,
    output logic [7:0] data_out2 );

	logic[7:0] registers[7:0];
	logic[7:0] ENTRY = 'b00000000;
	logic[7:0] data_out1_intermediate;
	logic[7:0] data_out2_intermediate;
	logic[7:0] data_out2_intermediate2;
	logic[2:0] reg_write;
	//logic[7:0] imm;
	assign reg_write = reg_dest;   
	// combinational reading
	assign data_out1_intermediate = memToReg ? registers[reg_src] : registers[reg_dest];  
	assign data_out2_intermediate = memToReg ? registers[reg_dest] : registers[reg_src];
	assign data_out2_intermediate2 = mode ? immediate : data_out2_intermediate;

	// sequential writing
	always_ff @(posedge clk) begin
		if (write_enable) begin
			if (regToReg & !mode) begin
				registers[reg_write] <= registers[reg_src];    //MOV reg to reg, mode = 0		
			end
			else if (regToReg & mode) begin
				registers[reg_write] <= immediate;      //MOV immediate to reg, mode = 1
			end
			else if (lea) begin
				registers[reg_write] <= ENTRY;        //LEA
				
			end
			else if (regToMem) begin
				registers[reg_write] <= registers[reg_write];   //MOV reg to mem
			end
			else 
				registers[reg_write] <= data_in;     //MOV mem to reg or ALUOut
		end
	end
  	always_ff @(posedge clk) begin
		if(stage == 2'b00) begin
			//imm <= immediate;
			data_out1 <= data_out1_intermediate;
			data_out2 <= data_out2_intermediate2;
		end
	end

endmodule
